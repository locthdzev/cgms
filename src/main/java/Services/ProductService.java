package Services;

import DAOs.ProductDAO;
import Models.Product;
import Utilities.MinioUtil;

import java.io.InputStream;
import java.util.List;

public class ProductService {
    private ProductDAO productDAO = new ProductDAO();
    private static final String PRODUCT_IMAGES_FOLDER = "Products";

    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }

    public List<Product> getAllActiveProducts() {
        return productDAO.getAllProducts().stream()
                .filter(product -> "Active".equals(product.getStatus()))
                .collect(java.util.stream.Collectors.toList());
    }

    public Product getProductById(int id) {
        return productDAO.getProductById(id);
    }

    public void saveProduct(Product product) {
        productDAO.saveProduct(product);
    }

    public void updateProduct(Product product) {
        productDAO.updateProduct(product);
    }

    public void deleteProduct(int id) {
        // Get the product to check if it has an image to delete
        Product product = productDAO.getProductById(id);
        if (product != null && product.getImageUrl() != null && !product.getImageUrl().isEmpty()) {
            try {
                // Extract object name from URL and delete from MinIO
                String objectName = MinioUtil.getObjectNameFromUrl(product.getImageUrl());
                if (objectName != null) {
                    MinioUtil.deleteFile(objectName);
                }
            } catch (Exception e) {
                // Log error but continue with product deletion
                e.printStackTrace();
            }
        }

        // Delete the product from database
        productDAO.deleteProduct(id);
    }

    /**
     * Upload product image to MinIO
     * 
     * @param inputStream The input stream of the image file
     * @param fileName    Original file name
     * @param contentType Content type of the file
     * @return The URL of the uploaded image
     */
    public String uploadProductImage(InputStream inputStream, String fileName, String contentType) throws Exception {
        return MinioUtil.uploadFile(inputStream, fileName, contentType, PRODUCT_IMAGES_FOLDER);
    }
}
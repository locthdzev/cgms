package Services;

import DAOs.InventoryDAO;
import DAOs.ProductDAO;
import Models.Inventory;
import Models.Product;

import java.time.Instant;
import java.util.List;

public class InventoryService {
    
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final ProductDAO productDAO = new ProductDAO();
    
    public List<Inventory> getAllInventory() {
        return inventoryDAO.getAllInventory();
    }
    
    public Inventory getInventoryByProductId(int productId) {
        return inventoryDAO.getInventoryByProductId(productId);
    }
    
    public boolean addProductToInventory(int productId, int quantity) {
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            return false;
        }
        
        Inventory existingInventory = inventoryDAO.getInventoryByProductId(productId);
        
        if (existingInventory != null) {
            // Cập nhật số lượng tồn kho
            existingInventory.setQuantity(existingInventory.getQuantity() + quantity);
            existingInventory.setLastUpdated(Instant.now());
            
            // Cập nhật trạng thái sản phẩm nếu cần
            if (existingInventory.getQuantity() > 0 && "OUT_OF_STOCK".equals(product.getStatus())) {
                product.setStatus("ACTIVE");
                product.setUpdatedAt(Instant.now());
                productDAO.updateProduct(product);
            }
            
            return inventoryDAO.updateInventory(existingInventory);
        } else {
            // Tạo mới bản ghi tồn kho
            Inventory newInventory = new Inventory();
            newInventory.setProduct(product);
            newInventory.setQuantity(quantity);
            newInventory.setLastUpdated(Instant.now());
            newInventory.setStatus("AVAILABLE");
            
            // Cập nhật trạng thái sản phẩm nếu cần
            if (quantity > 0 && "OUT_OF_STOCK".equals(product.getStatus())) {
                product.setStatus("ACTIVE");
                product.setUpdatedAt(Instant.now());
                productDAO.updateProduct(product);
            }
            
            return inventoryDAO.addInventory(newInventory);
        }
    }
    
    public boolean updateInventoryQuantity(int productId, int newQuantity) {
        Inventory inventory = inventoryDAO.getInventoryByProductId(productId);
        if (inventory == null) {
            return false;
        }
        
        inventory.setQuantity(newQuantity);
        inventory.setLastUpdated(Instant.now());
        
        // Cập nhật trạng thái sản phẩm nếu cần
        Product product = productDAO.getProductById(productId);
        if (newQuantity <= 0 && !"OUT_OF_STOCK".equals(product.getStatus())) {
            product.setStatus("OUT_OF_STOCK");
            product.setUpdatedAt(Instant.now());
            productDAO.updateProduct(product);
        } else if (newQuantity > 0 && "OUT_OF_STOCK".equals(product.getStatus())) {
            product.setStatus("ACTIVE");
            product.setUpdatedAt(Instant.now());
            productDAO.updateProduct(product);
        }
        
        return inventoryDAO.updateInventory(inventory);
    }
}
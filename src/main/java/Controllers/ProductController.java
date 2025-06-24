package Controllers;

import Models.Product;
import Models.Inventory;
import Services.ProductService;
import Services.InventoryService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@WebServlet({ "/product", "/addProduct", "/editProduct" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 30 // 30MB
)
public class ProductController extends HttpServlet {
    private final ProductService service = new ProductService();
    private final InventoryService inventoryService = new InventoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            // ----- Hiển thị form tạo -----
            case "create":
                req.setAttribute("product", new Product());
                req.getRequestDispatcher("/product-form.jsp").forward(req, resp);
                break;

            // ----- Hiển thị form edit -----
            case "edit":
                int idEdit = Integer.parseInt(req.getParameter("id"));
                Product pEdit = service.getProductById(idEdit);
                req.setAttribute("product", pEdit);
                
                // Lấy thông tin tồn kho
                Inventory inventory = inventoryService.getInventoryByProductId(idEdit);
                req.setAttribute("inventory", inventory);
                
                req.getRequestDispatcher("/product-form.jsp").forward(req, resp);
                break;

            // ----- Xoá -----
            case "delete":
                int idDel = Integer.parseInt(req.getParameter("id"));
                service.deleteProduct(idDel);
                resp.sendRedirect(req.getContextPath() + "/product?action=list");
                break;

            // ----- Danh sách -----
            default:
                List<Product> list = service.getAllProducts();
                req.setAttribute("productList", list);
                
                // Lấy thông tin tồn kho cho mỗi sản phẩm
                for (Product p : list) {
                    Inventory inv = inventoryService.getInventoryByProductId(p.getId());
                    if (inv != null) {
                        req.setAttribute("inventory_" + p.getId(), inv);
                    }
                }
                
                req.getRequestDispatcher("/product-list.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String servletPath = req.getServletPath();
        String formAction = req.getParameter("formAction");
        String idStr = req.getParameter("id");
        HttpSession session = req.getSession();
        Product product = new Product();

        try {
            if (idStr != null && !idStr.trim().isEmpty()) {
                // Update
                product = service.getProductById(Integer.parseInt(idStr));
                product.setUpdatedAt(Instant.now());
            } else {
                // Create
                product.setCreatedAt(Instant.now());
            }

            product.setName(req.getParameter("name"));
            product.setDescription(req.getParameter("description"));

            String priceStr = req.getParameter("price");
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                product.setPrice(new BigDecimal(priceStr));
            }

            product.setStatus(req.getParameter("status"));

            // Handle file upload
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String contentType = filePart.getContentType();

                // Upload to MinIO and get URL
                String imageUrl = service.uploadProductImage(filePart.getInputStream(), fileName, contentType);
                product.setImageUrl(imageUrl);
            }

            if (idStr != null && !idStr.trim().isEmpty()) {
                service.updateProduct(product);
                session.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
            } else {
                service.saveProduct(product);
                session.setAttribute("successMessage", "Tạo sản phẩm mới thành công!");
            }

            resp.sendRedirect(req.getContextPath() + "/product");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            req.setAttribute("product", product);
            req.setAttribute("formAction", formAction);
            req.getRequestDispatcher("/product.jsp").forward(req, resp);
        }
    }
}
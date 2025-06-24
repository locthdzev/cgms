package Controllers;

import Models.Product;
import Models.Inventory;
import Services.ProductService;
import Services.InventoryService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;


public class ProductController extends HttpServlet {

    private final ProductService service = new ProductService();
    private final InventoryService inventoryService = new InventoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");   // hidden field trong form khi edit

        // Chuẩn bị entity
        Product p;
        if (idStr != null && !idStr.trim().isEmpty()) {
            // UPDATE
            p = service.getProductById(Integer.parseInt(idStr));
            p.setUpdatedAt(Instant.now());
        } else {
            // CREATE
            p = new Product();
            p.setCreatedAt(Instant.now());
        }

        try {
            // ----------- Map fields từ form -----------
            p.setName(req.getParameter("name"));
            p.setDescription(req.getParameter("description"));

            String priceStr = req.getParameter("price");
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                p.setPrice(new BigDecimal(priceStr));
            }

            p.setStatus(req.getParameter("status"));
            // -------------------------------------------

            if (idStr != null && !idStr.trim().isEmpty()) {
                service.updateProduct(p);
            } else {
                service.saveProduct(p);
            }

            resp.sendRedirect(req.getContextPath() + "/product?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Invalid input: " + e.getMessage());
            req.setAttribute("product", p);
            req.getRequestDispatcher("/product-form.jsp").forward(req, resp);
        }
    }
}

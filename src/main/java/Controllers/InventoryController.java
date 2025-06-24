package Controllers;

import Models.Inventory;
import Models.Product;
import Services.InventoryService;
import Services.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.Instant;
import java.util.List;

@WebServlet("/inventory/*")
public class InventoryController extends HttpServlet {

    private final InventoryService inventoryService = new InventoryService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        String action = req.getParameter("action");
        
        if (action == null) action = "list";

        switch (action) {
            case "add":
                // Hiển thị form thêm sản phẩm vào kho
                List<Product> products = productService.getAllProducts();
                req.setAttribute("products", products);
                req.getRequestDispatcher("/inventory-add.jsp").forward(req, resp);
                break;
                
            case "edit":
                // Hiển thị form cập nhật số lượng
                int productId = Integer.parseInt(req.getParameter("productId"));
                Inventory inventory = inventoryService.getInventoryByProductId(productId);
                Product product = productService.getProductById(productId);
                
                req.setAttribute("inventory", inventory);
                req.setAttribute("product", product);
                req.getRequestDispatcher("/inventory-edit.jsp").forward(req, resp);
                break;
                
            case "list":
            default:
                // Hiển thị danh sách tồn kho
                List<Inventory> inventoryList = inventoryService.getAllInventory();
                req.setAttribute("inventoryList", inventoryList);
                req.getRequestDispatcher("/inventory-list.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        try {
            if ("add".equals(action)) {
                // Thêm sản phẩm vào kho
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                
                if (quantity <= 0) {
                    session.setAttribute("errorMessage", "Số lượng phải lớn hơn 0");
                    resp.sendRedirect(req.getContextPath() + "/inventory?action=add");
                    return;
                }
                
                boolean success = inventoryService.addProductToInventory(productId, quantity);
                
                if (success) {
                    session.setAttribute("successMessage", "Thêm sản phẩm vào kho thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể thêm sản phẩm vào kho!");
                }
                
            } else if ("update".equals(action)) {
                // Cập nhật số lượng tồn kho
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                
                if (quantity < 0) {
                    session.setAttribute("errorMessage", "Số lượng không thể âm");
                    resp.sendRedirect(req.getContextPath() + "/inventory?action=edit&productId=" + productId);
                    return;
                }
                
                boolean success = inventoryService.updateInventoryQuantity(productId, quantity);
                
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật số lượng thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể cập nhật số lượng!");
                }
            }
            
            resp.sendRedirect(req.getContextPath() + "/inventory?action=list");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/inventory?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/inventory?action=list");
        }
    }
}
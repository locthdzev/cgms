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
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/inventory/*")
public class InventoryController extends HttpServlet {

    private final InventoryService inventoryService = new InventoryService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list"; // Default action is "list"

        switch (action) {
            case "add":
                // Hiển thị form thêm sản phẩm vào kho
                List<Product> products = productService.getAllProducts();
                req.setAttribute("products", products);
                req.getRequestDispatcher("/inventory-add.jsp").forward(req, resp);
                break;

            case "edit":
                // Hiển thị form cập nhật số lượng
                try {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    Inventory inventory = inventoryService.getInventoryByProductId(productId);
                    Product product = productService.getProductById(productId);

                    req.setAttribute("inventory", inventory);
                    req.setAttribute("product", product);
                    req.getRequestDispatcher("/inventory-edit.jsp").forward(req, resp);
                } catch (NumberFormatException e) {
                    req.setAttribute("errorMessage", "Dữ liệu sản phẩm không hợp lệ.");
                    req.getRequestDispatcher("/inventory-list.jsp").forward(req, resp);
                }
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
                // Lấy các tham số từ form
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                String supplierName = req.getParameter("supplierName");
                String taxCode = req.getParameter("taxCode");
                String status = req.getParameter("status");

                // Kiểm tra nếu quantity hợp lệ
                if (quantity <= 0) {
                    session.setAttribute("errorMessage", "Số lượng phải lớn hơn 0");
                    resp.sendRedirect(req.getContextPath() + "/inventory?action=add");
                    return;
                }

                // Kiểm tra mã số thuế hợp lệ (ví dụ, bạn có thể kiểm tra định dạng)
                if (taxCode == null || taxCode.isEmpty() || !taxCode.matches("[0-9]{10}")) {
                    session.setAttribute("errorMessage", "Mã số thuế không hợp lệ.");
                    resp.sendRedirect(req.getContextPath() + "/inventory?action=add");
                    return;
                }

                // Lấy ngày nhập kho từ form
                String importedDateStr = req.getParameter("importedDate");
                Instant importedDate;
                try {
                    importedDate = java.time.LocalDate.parse(importedDateStr).atStartOfDay(java.time.ZoneId.systemDefault()).toInstant();
                } catch (Exception e) {
                    session.setAttribute("errorMessage", "Ngày nhập kho không hợp lệ.");
                    resp.sendRedirect(req.getContextPath() + "/inventory?action=add");
                    return;
                }

                // Thêm sản phẩm vào kho
                boolean success = inventoryService.addProductToInventory(productId, quantity, supplierName, taxCode, status, importedDate);

                if (success) {
                    session.setAttribute("successMessage", "Thêm sản phẩm vào kho thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể thêm sản phẩm vào kho!");
                }

                resp.sendRedirect(req.getContextPath() + "/inventory?action=list");

            } else if ("update".equals(action)) {
                // Cập nhật số lượng tồn kho
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                String status = req.getParameter("status");

                // Kiểm tra số lượng hợp lệ
                if (quantity < 0) {
                    session.setAttribute("errorMessage", "Số lượng không thể âm");
                    resp.sendRedirect(req.getContextPath() + "/inventory?action=edit&productId=" + productId);
                    return;
                }

                boolean success = inventoryService.updateInventoryQuantity(productId, quantity, status);

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

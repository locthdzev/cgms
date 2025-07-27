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
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@WebServlet("/inventory")
public class InventoryController extends HttpServlet {

    private final InventoryService inventoryService = new InventoryService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    showInventoryList(req, resp);
                    break;
                case "add":
                    showAddForm(req, resp);
                    break;
                case "view":
                    showInventoryDetail(req, resp);
                    break;
                case "search":
                    searchInventory(req, resp);
                    break;
                case "lowstock":
                    showLowStockInventory(req, resp);
                    break;
                case "delete":
                    deleteInventory(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/inventory");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/inventory");
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
                handleAddInventory(req, resp, session);
            } else if ("adjust".equals(action)) {
                handleAdjustInventory(req, resp, session);
            } else {
                session.setAttribute("errorMessage", "Hành động không hợp lệ!");
                resp.sendRedirect(req.getContextPath() + "/inventory");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/inventory");
        }
    }

    private void showInventoryList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Inventory> inventoryList = inventoryService.getAllInventory();
        req.setAttribute("inventoryList", inventoryList);
        req.getRequestDispatcher("inventory-list.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Product> products = productService.getAllProducts();
        req.setAttribute("products", products);
        req.getRequestDispatcher("inventory-add.jsp").forward(req, resp);
    }

    private void showInventoryDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int inventoryId = Integer.parseInt(req.getParameter("id"));
            Inventory inventory = inventoryService.getInventoryById(inventoryId);
            
            if (inventory != null) {
                req.setAttribute("inventory", inventory);
                req.getRequestDispatcher("inventory-detail.jsp").forward(req, resp);
            } else {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy thông tin kho!");
                resp.sendRedirect(req.getContextPath() + "/inventory");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("errorMessage", "ID không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/inventory");
        }
    }

    private void searchInventory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        List<Inventory> inventoryList = inventoryService.searchInventory(keyword);
        
        req.setAttribute("inventoryList", inventoryList);
        req.setAttribute("searchKeyword", keyword);
        req.getRequestDispatcher("inventory-list.jsp").forward(req, resp);
    }

    private void showLowStockInventory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String thresholdStr = req.getParameter("threshold");
        int threshold = (thresholdStr != null) ? Integer.parseInt(thresholdStr) : 10;
        
        List<Inventory> lowStockList = inventoryService.getLowStockInventory(threshold);
        req.setAttribute("inventoryList", lowStockList);
        req.setAttribute("isLowStock", true);
        req.setAttribute("threshold", threshold);
        req.getRequestDispatcher("inventory-list.jsp").forward(req, resp);
    }

    private void deleteInventory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int inventoryId = Integer.parseInt(req.getParameter("id"));
            inventoryService.deleteInventory(inventoryId);
            
            HttpSession session = req.getSession();
            session.setAttribute("successMessage", "Xóa thông tin kho thành công!");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("errorMessage", "ID không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Lỗi xóa: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/inventory");
    }

    private void handleAddInventory(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {
        
        try {
            String productIdStr = req.getParameter("productId");
            String quantityStr = req.getParameter("quantity");
            String supplierName = req.getParameter("supplierName");
            String taxCode = req.getParameter("taxCode");
            String status = req.getParameter("status");
            String importedDateStr = req.getParameter("importedDate");

            if (productIdStr == null || quantityStr == null || supplierName == null || 
                taxCode == null || status == null || importedDateStr == null) {
                session.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin!");
                resp.sendRedirect(req.getContextPath() + "/inventory?action=add");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                session.setAttribute("errorMessage", "Số lượng phải lớn hơn 0");
                resp.sendRedirect(req.getContextPath() + "/inventory?action=add");
                return;
            }

            Instant importedDate = LocalDate.parse(importedDateStr)
                    .atStartOfDay(ZoneId.systemDefault())
                    .toInstant();

            boolean success = inventoryService.addProductToInventory(
                productId, quantity, supplierName, taxCode, status, importedDate);

            if (success) {
                session.setAttribute("successMessage", "Thêm sản phẩm vào kho thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể thêm sản phẩm vào kho!");
            }

            resp.sendRedirect(req.getContextPath() + "/inventory");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu số không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/inventory?action=add");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/inventory?action=add");
        }
    }

    private void handleAdjustInventory(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {
        
        try {
            int inventoryId = Integer.parseInt(req.getParameter("inventoryId"));
            int adjustment = Integer.parseInt(req.getParameter("adjustment"));
            String reason = req.getParameter("reason");

            boolean success = inventoryService.adjustInventoryQuantity(inventoryId, adjustment, reason);

            if (success) {
                session.setAttribute("successMessage", "Điều chỉnh số lượng thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể điều chỉnh số lượng!");
            }

            resp.sendRedirect(req.getContextPath() + "/inventory");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu số không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/inventory");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/inventory");
        }
    }
}

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
        if (action == null)
            action = "list";

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
                case "updateStatus":
                    showUpdateStatusForm(req, resp);
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
            } else if ("updateStatus".equals(action)) {
                handleUpdateStatus(req, resp, session);
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

    private void showUpdateStatusForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String idParam = req.getParameter("id");
            System.out.println("DEBUG: Received ID parameter: " + idParam);

            if (idParam == null || idParam.trim().isEmpty()) {
                System.out.println("DEBUG: ID parameter is null or empty");
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"error\": \"ID không hợp lệ!\"}");
                return;
            }

            int inventoryId = Integer.parseInt(idParam);
            System.out.println("DEBUG: Parsed inventory ID: " + inventoryId);

            Inventory inventory = inventoryService.getInventoryById(inventoryId);
            System.out.println("DEBUG: Retrieved inventory: " + (inventory != null ? "Found" : "Not found"));

            if (inventory == null) {
                System.out.println("DEBUG: Inventory not found in database");
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"error\": \"Không tìm thấy sản phẩm trong kho!\"}");
                return;
            }

            // Return JSON data for modal
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            // Handle null values safely
            String productName = inventory.getProduct() != null ? inventory.getProduct().getName() : "N/A";
            Integer productId = inventory.getProduct() != null ? inventory.getProduct().getId() : 0;
            String status = inventory.getStatus() != null ? inventory.getStatus() : "";
            String supplierName = inventory.getSupplierName() != null ? inventory.getSupplierName() : "";
            String taxCode = inventory.getTaxCode() != null ? inventory.getTaxCode() : "";

            System.out.println("DEBUG: Building JSON response for inventory ID: " + inventory.getId());

            String json = String.format(
                    "{\"id\": %d, \"productName\": \"%s\", \"productId\": %d, \"quantity\": %d, \"status\": \"%s\", \"supplierName\": \"%s\", \"taxCode\": \"%s\"}",
                    inventory.getId(),
                    productName.replace("\"", "\\\""),
                    productId,
                    inventory.getQuantity(),
                    status.replace("\"", "\\\""),
                    supplierName.replace("\"", "\\\""),
                    taxCode.replace("\"", "\\\""));

            System.out.println("DEBUG: JSON response: " + json);
            resp.getWriter().write(json);

        } catch (NumberFormatException e) {
            System.out.println("DEBUG: NumberFormatException: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"error\": \"ID không hợp lệ!\"}");
        } catch (Exception e) {
            System.out.println("DEBUG: Exception occurred: " + e.getMessage());
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write("{\"error\": \"Lỗi hệ thống: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {
        try {
            int inventoryId = Integer.parseInt(req.getParameter("inventoryId"));
            String newStatus = req.getParameter("status");

            // Validate input
            if (newStatus == null || newStatus.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Trạng thái không được để trống!");
                resp.sendRedirect(req.getContextPath() + "/inventory");
                return;
            }

            // Get current inventory
            Inventory inventory = inventoryService.getInventoryById(inventoryId);
            if (inventory == null) {
                session.setAttribute("errorMessage", "Không tìm thấy sản phẩm trong kho!");
                resp.sendRedirect(req.getContextPath() + "/inventory");
                return;
            }

            // Update only the status, keep other fields unchanged
            inventory.setStatus(newStatus.trim());
            inventory.setLastUpdated(java.time.Instant.now());

            inventoryService.updateInventory(inventory);

            session.setAttribute("successMessage",
                    "Cập nhật trạng thái kho thành công! Trạng thái mới: " + getStatusDisplayName(newStatus.trim()));

            // Log the update
            System.out.println("Inventory Status Update - ID: " + inventoryId +
                    ", Old Status: " + (inventory.getStatus() != null ? inventory.getStatus() : "N/A") +
                    ", New Status: " + newStatus.trim() +
                    ", Product: " + (inventory.getProduct() != null ? inventory.getProduct().getName() : "N/A"));

            resp.sendRedirect(req.getContextPath() + "/inventory");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/inventory");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/inventory");
        }
    }

    private String getStatusDisplayName(String status) {
        switch (status) {
            case "AVAILABLE":
                return "Có sẵn";
            case "OUT_OF_STOCK":
                return "Hết hàng";
            case "LOW_STOCK":
                return "Sắp hết hàng";
            case "Discontinued":
                return "Ngừng kinh doanh";
            case "Damaged":
                return "Hư hỏng";
            default:
                return status;
        }
    }
}

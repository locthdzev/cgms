package Controllers;

import Models.User;
import Models.Order;
import Models.OrderDetail;
import Models.Product;
import Services.OrderService;
import Services.UserService;
import Services.ProductService;
import Services.PayOSService;
import DAOs.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@WebServlet(name = "AdminOrderController", urlPatterns = { "/admin-orders", "/admin-orders/*" })
public class AdminOrderController extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final OrderDAO orderDAO = new OrderDAO();
    private final PayOSService payOSService = new PayOSService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        if (user == null || !"Admin".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String pathInfo = req.getPathInfo();
        String action = req.getParameter("action");

        System.out.println("=== AdminOrderController Debug ===");
        System.out.println("PathInfo: " + pathInfo);
        System.out.println("Action: " + action);
        System.out.println("============================");

        try {
            if ("create".equals(action)) {
                showAdminCreateOrderPage(req, resp);
            } else if ("details".equals(action)) {
                showOrderDetails(req, resp);
            } else {
                // Default: show order list
                showAdminOrderList(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("error500.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        if (user == null || !"Admin".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("admin-create".equals(action)) {
                createOrderByAdmin(req, resp, user);
            } else if ("update-status".equals(action)) {
                updateOrderStatus(req, resp);
            } else if ("admin-cancel".equals(action)) {
                adminCancelOrder(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect("admin-orders");
        }
    }

    private void showAdminOrderList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Lấy tất cả đơn hàng
        List<Order> allOrders = orderService.getAllOrders();

        // Lấy tham số filter từ request
        String statusFilter = req.getParameter("status");

        // Filter đơn hàng theo trạng thái nếu có
        List<Order> filteredOrders = allOrders;
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equals(statusFilter)) {
            filteredOrders = allOrders.stream()
                    .filter(order -> statusFilter.equals(order.getStatus()))
                    .collect(Collectors.toList());
        }

        // Set attributes cho JSP
        req.setAttribute("orders", filteredOrders);
        req.setAttribute("allOrders", allOrders); // Để tính statistics
        req.setAttribute("currentFilter", statusFilter != null ? statusFilter : "ALL");

        req.getRequestDispatcher("admin-order-list.jsp").forward(req, resp);
    }

    private void showAdminCreateOrderPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Load products
        ProductService productService = new ProductService();
        List<Product> products = productService.getAllActiveProducts();
        req.setAttribute("products", products);

        // Load members for customer selection
        UserService userService = new UserService();
        List<User> members = userService.getAllMembers();
        req.setAttribute("members", members);

        req.getRequestDispatcher("admin-create-order.jsp").forward(req, resp);
    }

    private void showOrderDetails(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("id"));
        Order order = orderService.getOrderWithDetails(orderId);

        // Admin có thể xem tất cả đơn hàng
        if (order == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);
        req.setAttribute("order", order);
        req.setAttribute("orderDetails", orderDetails);

        req.getRequestDispatcher("order-details.jsp").forward(req, resp);
    }

    private void createOrderByAdmin(HttpServletRequest req, HttpServletResponse resp, User admin)
            throws ServletException, IOException {
        try {
            // Parse form data
            int customerId = Integer.parseInt(req.getParameter("customerId"));
            String shippingAddress = req.getParameter("shippingAddress");
            String receiverName = req.getParameter("receiverName");
            String receiverPhone = req.getParameter("receiverPhone");
            String paymentMethod = req.getParameter("paymentMethod");
            String notes = req.getParameter("notes");

            // *** DEBUG PAYMENT METHOD ***
            System.out.println("=== CREATE ORDER DEBUG ===");
            System.out.println("Payment method received: '" + paymentMethod + "'");
            System.out.println(
                    "Payment method equals PAYOS: " + OrderService.OrderConstants.PAYMENT_PAYOS.equals(paymentMethod));
            System.out.println("PAYMENT_PAYOS constant: '" + OrderService.OrderConstants.PAYMENT_PAYOS + "'");
            System.out.println("Customer ID: " + customerId);
            System.out.println("===========================");

            // Validate basic info
            if (shippingAddress == null || receiverName == null || receiverPhone == null || paymentMethod == null) {
                req.getSession().setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
                resp.sendRedirect("admin-orders?action=create");
                return;
            }

            // Get customer
            UserService userService = new UserService();
            User customer = userService.getUserById(customerId);
            if (customer == null) {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng");
                resp.sendRedirect("admin-orders?action=create");
                return;
            }

            // Parse selected products
            List<OrderService.OrderItem> orderItems = new ArrayList<>();
            Map<Integer, OrderService.OrderItem> productMap = new HashMap<>();

            for (String paramName : req.getParameterMap().keySet()) {
                if (paramName.startsWith("products[")) {
                    int startIndex = paramName.indexOf('[') + 1;
                    int endIndex = paramName.indexOf(']');
                    int index = Integer.parseInt(paramName.substring(startIndex, endIndex));

                    String fieldName = paramName.substring(paramName.lastIndexOf('.') + 1);
                    String value = req.getParameter(paramName);

                    OrderService.OrderItem item = productMap.get(index);
                    if (item == null) {
                        item = new OrderService.OrderItem(0, 0, java.math.BigDecimal.ZERO);
                        productMap.put(index, item);
                    }

                    switch (fieldName) {
                        case "productId":
                            item.setProductId(Integer.parseInt(value));
                            break;
                        case "quantity":
                            item.setQuantity(Integer.parseInt(value));
                            break;
                        case "unitPrice":
                            item.setUnitPrice(new java.math.BigDecimal(value));
                            break;
                    }
                }
            }

            orderItems.addAll(productMap.values());

            if (orderItems.isEmpty()) {
                req.getSession().setAttribute("errorMessage", "Vui lòng chọn ít nhất một sản phẩm");
                resp.sendRedirect("admin-orders?action=create");
                return;
            }

            // Create order
            int orderId = orderService.createOrderByAdmin(admin, customer, orderItems,
                    shippingAddress.trim(), receiverName.trim(), receiverPhone.trim(),
                    paymentMethod, notes != null ? notes.trim() : "");

            if (OrderService.OrderConstants.PAYMENT_PAYOS.equals(paymentMethod)) {
                // Redirect to PayOS payment
                System.out.println("=== ADMIN PAYOS ORDER DEBUG ===");
                System.out.println("Payment method: " + paymentMethod);
                System.out.println("Order ID: " + orderId);

                Order order = orderService.getOrderWithDetails(orderId);
                System.out.println("Order retrieved, PayOS code: " + order.getPayOSOrderCode());
                System.out.println("Order status: " + order.getStatus());

                List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);
                System.out.println("Order details count: " + orderDetails.size());

                String paymentUrl = payOSService.createPaymentLinkForOrder(order, orderDetails);
                System.out.println("PayOS payment URL: " + paymentUrl);

                if (paymentUrl != null) {
                    // Không set success message ở đây vì có thể user sẽ hủy
                    // Success message sẽ được set trong PayOSCallbackController khi thanh toán
                    // thành công
                    System.out.println("Redirecting to PayOS: " + paymentUrl);
                    resp.sendRedirect(paymentUrl);
                } else {
                    System.out.println("PayOS URL is null - falling back to admin orders");
                    req.getSession().setAttribute("errorMessage",
                            "Không thể tạo link thanh toán PayOS. Đơn hàng đã được tạo với mã #" + orderId);
                    resp.sendRedirect("admin-orders");
                }
            } else {
                // Cash payment - redirect to admin order list
                req.getSession().setAttribute("successMessage",
                        "Đơn hàng #" + orderId + " đã hoàn thành thành công!");
                resp.sendRedirect("admin-orders");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Không thể tạo đơn hàng: " + e.getMessage());
            resp.sendRedirect("admin-orders?action=create");
        }
    }

    private void updateOrderStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String newStatus = req.getParameter("newStatus");

            orderService.updateOrderStatus(orderId, newStatus);

            req.getSession().setAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công");
            resp.sendRedirect("admin-orders");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật trạng thái");
            resp.sendRedirect("admin-orders");
        }
    }

    private void adminCancelOrder(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String reason = req.getParameter("reason");

            if (reason == null || reason.trim().isEmpty()) {
                req.getSession().setAttribute("errorMessage", "Vui lòng nhập lý do hủy đơn hàng");
                resp.sendRedirect("admin-orders");
                return;
            }

            boolean success = orderService.cancelOrder(orderId, "Admin hủy: " + reason.trim());

            if (success) {
                req.getSession().setAttribute("successMessage", "Đã hủy đơn hàng thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng này");
            }

            resp.sendRedirect("admin-orders");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi hủy đơn hàng: " + e.getMessage());
            resp.sendRedirect("admin-orders");
        }
    }
}
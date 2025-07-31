package Controllers;

import Models.User;
import Models.Order;
import Models.OrderDetail;
import Services.OrderService;
import Services.CartService;
import Services.PayOSService;
import DAOs.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import Services.UserService;

@WebServlet(name = "OrderController", urlPatterns = { "/order", "/order/*" })
public class OrderController extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final CartService cartService = new CartService();
    private final PayOSService payOSService = new PayOSService();
    private final OrderDAO orderDAO = new OrderDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String pathInfo = req.getPathInfo();
        String action = req.getParameter("action");

        // Debug logging
        System.out.println("=== OrderController Debug ===");
        System.out.println("RequestURI: " + req.getRequestURI());
        System.out.println("PathInfo: " + pathInfo);
        System.out.println("Action: " + action);
        System.out.println("User Role: " + user.getRole());
        System.out.println("============================");

        try {
            // Xử lý dựa trên role và action thay vì pathInfo
            if ("Admin".equals(user.getRole())) {
                // Admin requests
                if ("list".equals(action)) {
                    System.out.println("Calling showAdminOrderList");
                    showAdminOrderList(req, resp);
                } else if ("create".equals(action)) {
                    System.out.println("Calling showAdminCreateOrderPage");
                    showAdminCreateOrderPage(req, resp);
                } else {
                    // Default for admin - show order list
                    System.out.println("Default - Calling showAdminOrderList");
                    showAdminOrderList(req, resp);
                }
            } else if ("Member".equals(user.getRole())) {
                // Member requests
                if ("checkout".equals(action)) {
                    showCheckoutPage(req, resp, user);
                } else if ("history".equals(action)) {
                    showOrderHistory(req, resp, user);
                } else if ("details".equals(action)) {
                    showOrderDetails(req, resp, user);
                } else {
                    // Default for member - show order history
                    showOrderHistory(req, resp, user);
                }
            } else {
                // Other roles not allowed
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
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
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String pathInfo = req.getPathInfo();
        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                createOrder(req, resp, user);
            } else if ("cancel".equals(action)) {
                cancelOrder(req, resp, user);
            } else if ("update-status".equals(action)) {
                if (!"Admin".equals(user.getRole())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                updateOrderStatus(req, resp);
            } else if ("admin-create".equals(action)) {
                if (!"Admin".equals(user.getRole())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                createOrderByAdmin(req, resp, user);
            } else if ("admin-cancel".equals(action)) {
                if (!"Admin".equals(user.getRole())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                adminCancelOrder(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("error500.jsp").forward(req, resp);
        }
    }

    private void showCheckoutPage(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        // Kiểm tra quyền (chỉ Member)
        if (!"Member".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Lấy giỏ hàng
        req.setAttribute("cartItems", cartService.getCartByMemberId(user.getId()));
        req.setAttribute("cartTotal", cartService.getCartTotal(user.getId()));

        req.getRequestDispatcher("order-checkout.jsp").forward(req, resp);
    }

    private void showOrderHistory(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        // Chỉ cho phép Member truy cập
        if (!"Member".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<Order> orders = orderService.getOrdersByMemberId(user.getId());
        req.setAttribute("orders", orders);

        req.getRequestDispatcher("member-order-history.jsp").forward(req, resp);
    }

    private void showOrderDetails(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("id"));
        Order order = orderService.getOrderWithDetails(orderId);

        // Kiểm tra quyền xem đơn hàng
        if (order == null || (!order.getMember().getId().equals(user.getId()) && !"Admin".equals(user.getRole()))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);
        req.setAttribute("order", order);
        req.setAttribute("orderDetails", orderDetails);

        req.getRequestDispatcher("order-details.jsp").forward(req, resp);
    }

    private void showAdminOrderList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("=== showAdminOrderList ===");
        List<Order> orders = orderService.getAllOrders();
        System.out.println("Orders count: " + (orders != null ? orders.size() : "null"));
        req.setAttribute("orders", orders);
        System.out.println("Forwarding to admin-order-list.jsp");
        req.getRequestDispatcher("admin-order-list.jsp").forward(req, resp);
        System.out.println("=== showAdminOrderList END ===");
    }

    private void showAdminCreateOrderPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("admin-create-order.jsp").forward(req, resp);
    }

    private void createOrder(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        try {
            String shippingAddress = req.getParameter("shippingAddress");
            String receiverName = req.getParameter("receiverName");
            String receiverPhone = req.getParameter("receiverPhone");
            String paymentMethod = req.getParameter("paymentMethod");
            String notes = req.getParameter("notes");

            // Validate required fields
            if (shippingAddress == null || shippingAddress.trim().isEmpty() ||
                    receiverName == null || receiverName.trim().isEmpty() ||
                    receiverPhone == null || receiverPhone.trim().isEmpty() ||
                    paymentMethod == null || paymentMethod.trim().isEmpty()) {

                req.getSession().setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
                resp.sendRedirect("order?action=checkout");
                return;
            }

            int orderId = orderService.createOrderFromCart(user, shippingAddress.trim(),
                    receiverName.trim(), receiverPhone.trim(),
                    paymentMethod, notes != null ? notes.trim() : "");

            if (OrderService.OrderConstants.PAYMENT_PAYOS.equals(paymentMethod)) {
                // Redirect to PayOS payment
                Order order = orderService.getOrderWithDetails(orderId);
                List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

                String paymentUrl = payOSService.createPaymentLinkForOrder(order, orderDetails);

                if (paymentUrl != null) {
                    resp.sendRedirect(paymentUrl);
                } else {
                    req.getSession().setAttribute("errorMessage",
                            "Không thể tạo link thanh toán PayOS. Vui lòng thử lại.");
                    resp.sendRedirect("order?action=checkout");
                }
            } else {
                // Cash payment - redirect to my-order page
                req.getSession().setAttribute("successMessage", "Đặt hàng thành công! Mã đơn hàng: #" + orderId);
                resp.sendRedirect("my-order");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Không thể tạo đơn hàng: " + e.getMessage());
            resp.sendRedirect("order?action=checkout");
        }
    }

    private void cancelOrder(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String reason = req.getParameter("reason");

            Order order = orderService.getOrderWithDetails(orderId);
            if (order == null || !order.getMember().getId().equals(user.getId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            boolean success = orderService.cancelOrder(orderId, reason);

            if (success) {
                req.getSession().setAttribute("successMessage", "Đã hủy đơn hàng thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng này");
            }

            resp.sendRedirect("order?action=history");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi hủy đơn hàng");
            resp.sendRedirect("order?action=history");
        }
    }

    private void updateOrderStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String newStatus = req.getParameter("newStatus");

            orderService.updateOrderStatus(orderId, newStatus);

            req.getSession().setAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công");
            resp.sendRedirect("order?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật trạng thái");
            resp.sendRedirect("order?action=list");
        }
    }

    private void createOrderByAdmin(HttpServletRequest req, HttpServletResponse resp, User admin)
            throws ServletException, IOException {
        try {
            // Lấy thông tin khách hàng
            int customerId = Integer.parseInt(req.getParameter("customerId"));
            String shippingAddress = req.getParameter("shippingAddress");
            String receiverName = req.getParameter("receiverName");
            String receiverPhone = req.getParameter("receiverPhone");
            String paymentMethod = req.getParameter("paymentMethod");
            String notes = req.getParameter("notes");

            // Validate required fields
            if (shippingAddress == null || shippingAddress.trim().isEmpty() ||
                    receiverName == null || receiverName.trim().isEmpty() ||
                    receiverPhone == null || receiverPhone.trim().isEmpty() ||
                    paymentMethod == null || paymentMethod.trim().isEmpty()) {

                req.getSession().setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
                resp.sendRedirect("order?action=create");
                return;
            }

            // Lấy thông tin khách hàng
            UserService userService = new UserService();
            User customer = userService.getUserById(customerId);
            if (customer == null) {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng");
                resp.sendRedirect("order?action=create");
                return;
            }

            // Lấy danh sách sản phẩm được chọn
            java.util.List<OrderService.OrderItem> orderItems = new java.util.ArrayList<>();
            java.util.Map<String, String[]> parameterMap = req.getParameterMap();

            // Parse products from form
            java.util.Map<Integer, OrderService.OrderItem> productMap = new java.util.HashMap<>();

            for (String paramName : parameterMap.keySet()) {
                if (paramName.startsWith("products[") && paramName.contains("].")) {
                    // Extract index and field name
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
                resp.sendRedirect("order?action=create");
                return;
            }

            // Tạo đơn hàng
            int orderId = orderService.createOrderByAdmin(admin, customer, orderItems,
                    shippingAddress.trim(), receiverName.trim(), receiverPhone.trim(),
                    paymentMethod, notes != null ? notes.trim() : "");

            if (OrderService.OrderConstants.PAYMENT_PAYOS.equals(paymentMethod)) {
                // Redirect to PayOS payment
                Order order = orderService.getOrderWithDetails(orderId);
                List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

                String paymentUrl = payOSService.createPaymentLinkForOrder(order, orderDetails);

                if (paymentUrl != null) {
                    req.getSession().setAttribute("successMessage",
                            "Đơn hàng #" + orderId
                                    + " đã được tạo thành công! Đang chuyển hướng đến trang thanh toán...");
                    resp.sendRedirect(paymentUrl);
                } else {
                    req.getSession().setAttribute("errorMessage",
                            "Không thể tạo link thanh toán PayOS. Đơn hàng đã được tạo với mã #" + orderId);
                    resp.sendRedirect("order?action=list");
                }
            } else {
                // Cash payment - redirect to admin order list
                req.getSession().setAttribute("successMessage",
                        "Đơn hàng #" + orderId + " đã được tạo thành công!");
                resp.sendRedirect("order?action=list");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Không thể tạo đơn hàng: " + e.getMessage());
            resp.sendRedirect("order?action=create");
        }
    }

    private void adminCancelOrder(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String reason = req.getParameter("reason");

            if (reason == null || reason.trim().isEmpty()) {
                req.getSession().setAttribute("errorMessage", "Vui lòng nhập lý do hủy đơn hàng");
                resp.sendRedirect("order?action=list");
                return;
            }

            boolean success = orderService.cancelOrder(orderId, "Admin hủy: " + reason.trim());

            if (success) {
                req.getSession().setAttribute("successMessage", "Đã hủy đơn hàng thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng này");
            }

            resp.sendRedirect("order?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi hủy đơn hàng: " + e.getMessage());
            resp.sendRedirect("order?action=list");
        }
    }
}
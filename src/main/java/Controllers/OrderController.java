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

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                if ("checkout".equals(action)) {
                    showCheckoutPage(req, resp, user);
                } else if ("history".equals(action)) {
                    showOrderHistory(req, resp, user);
                } else if ("details".equals(action)) {
                    showOrderDetails(req, resp, user);
                } else {
                    // Mặc định hiển thị lịch sử đơn hàng
                    showOrderHistory(req, resp, user);
                }
            } else if (pathInfo.equals("/admin")) {
                if (!"Admin".equals(user.getRole())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                if ("list".equals(action)) {
                    showAdminOrderList(req, resp);
                } else if ("create".equals(action)) {
                    showAdminCreateOrderPage(req, resp);
                } else {
                    showAdminOrderList(req, resp);
                }
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
        List<Order> orders = orderService.getAllOrders();
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("admin-order-list.jsp").forward(req, resp);
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
            resp.sendRedirect("order/admin?action=list");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật trạng thái");
            resp.sendRedirect("order/admin?action=list");
        }
    }

    private void createOrderByAdmin(HttpServletRequest req, HttpServletResponse resp, User admin)
            throws ServletException, IOException {
        // Implementation for admin creating order for member/PT
        // This would involve parsing product items, customer info, etc.
        // For now, redirect back to admin page
        req.getSession().setAttribute("errorMessage", "Chức năng này đang được phát triển");
        resp.sendRedirect("order/admin?action=create");
    }
}
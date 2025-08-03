package Controllers;

import Models.User;
import Models.Order;
import Models.OrderDetail;
import Services.OrderService;
import DAOs.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "MyOrderController", urlPatterns = { "/my-order" })
public class MyOrderController extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("details".equals(action)) {
                showOrderDetails(req, resp, user);
            } else {
                showOrderHistory(req, resp, user);
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

        String action = req.getParameter("action");

        try {
            if ("cancel".equals(action)) {
                cancelOrder(req, resp, user);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("error500.jsp").forward(req, resp);
        }
    }

    private void showOrderHistory(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        // Lấy tất cả đơn hàng của user
        List<Order> allOrders = orderService.getOrdersByMemberId(user.getId());

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

        String jspPage = "Member".equals(user.getRole()) ? "member-order-history.jsp" : "pt-order-history.jsp";
        req.getRequestDispatcher(jspPage).forward(req, resp);
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

    private void cancelOrder(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String reason = req.getParameter("reason");

            // Validate reason
            if (reason == null || reason.trim().isEmpty()) {
                req.getSession().setAttribute("errorMessage", "Vui lòng nhập lý do hủy đơn hàng.");
                resp.sendRedirect("my-order");
                return;
            }

            if (reason.trim().length() < 10) {
                req.getSession().setAttribute("errorMessage", "Lý do hủy đơn phải có ít nhất 10 ký tự.");
                resp.sendRedirect("my-order");
                return;
            }

            Order order = orderService.getOrderWithDetails(orderId);
            if (order == null || !order.getMember().getId().equals(user.getId())) {
                req.getSession().setAttribute("errorMessage", "Đơn hàng không tồn tại hoặc bạn không có quyền hủy.");
            } else if (!"PENDING".equals(order.getStatus()) && !"CONFIRMED".equals(order.getStatus())) {
                req.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng ở trạng thái này.");
            } else {
                // Format reason với thông tin user
                String formattedReason = String.format("Khách hàng %s (%s) hủy đơn: %s",
                        user.getFullName(), user.getEmail(), reason.trim());

                boolean success = orderService.cancelOrder(orderId, formattedReason);
                if (success) {
                    req.getSession().setAttribute("successMessage",
                            "Hủy đơn hàng thành công! Lý do hủy đã được gửi đến admin.");
                } else {
                    req.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng này.");
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("errorMessage", "ID đơn hàng không hợp lệ.");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi hủy đơn hàng: " + e.getMessage());
        }

        resp.sendRedirect("my-order");
    }
}
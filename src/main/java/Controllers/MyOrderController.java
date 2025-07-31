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
        List<Order> orders = orderService.getOrdersByMemberId(user.getId());
        req.setAttribute("orders", orders);

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

            Order order = orderService.getOrderWithDetails(orderId);
            if (order == null || !order.getMember().getId().equals(user.getId())) {
                req.getSession().setAttribute("errorMessage", "Đơn hàng không tồn tại hoặc bạn không có quyền hủy.");
            } else if (!"PENDING".equals(order.getStatus()) && !"CONFIRMED".equals(order.getStatus())) {
                req.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng ở trạng thái này.");
            } else {
                boolean success = orderService.cancelOrder(orderId,
                        reason != null ? reason : "Người dùng hủy đơn hàng");
                if (success) {
                    req.getSession().setAttribute("successMessage", "Hủy đơn hàng thành công!");
                } else {
                    req.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng này.");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi hủy đơn hàng: " + e.getMessage());
        }

        resp.sendRedirect("my-order");
    }
}
package Controllers;

import Models.User;
import Models.Order;
import Services.OrderService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyOrderController", urlPatterns = { "/my-order" })
public class MyOrderController extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        try {
            List<Order> orders = orderService.getOrdersByMemberId(user.getId());
            req.setAttribute("orders", orders);

            String jspPage = "Member".equals(user.getRole()) ? "member-order-history.jsp" : "pt-order-history.jsp";
            req.getRequestDispatcher(jspPage).forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("error500.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Handle order cancellation and other POST actions
        User user = (User) req.getSession().getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("cancel".equals(action)) {
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
            }

            resp.sendRedirect("my-order");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xử lý yêu cầu");
            resp.sendRedirect("my-order");
        }
    }
}
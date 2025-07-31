package Controllers;

import Models.User;
import Models.Order;
import Services.OrderService;
import DAOs.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet(name = "PayOSCallbackController", urlPatterns = { "/order/payment/success", "/order/payment/cancel" })
public class PayOSCallbackController extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getRequestURI();

        if (pathInfo.endsWith("/success")) {
            handlePayOSSuccess(req, resp);
        } else if (pathInfo.endsWith("/cancel")) {
            handlePayOSCancel(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handlePayOSSuccess(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String orderCode = req.getParameter("orderCode");
            String status = req.getParameter("status");
            String code = req.getParameter("code");

            System.out.println("PayOS Success - OrderCode: " + orderCode + ", Status: " + status + ", Code: " + code);

            // Kiểm tra thanh toán thành công
            if (orderCode != null && "PAID".equals(status) && "00".equals(code)) {
                // Tìm đơn hàng theo PayOS order code (thêm prefix ORDER-)
                String fullOrderCode = "ORDER-" + orderCode;
                Order order = orderDAO.getOrderByPayOSCode(fullOrderCode);

                if (order != null) {
                    req.getSession().setAttribute("successMessage",
                            "Thanh toán thành công! Đơn hàng #" + order.getId() + " đang chờ xác nhận từ admin.");

                    System.out.println("Payment successful for order: " + order.getId());
                    resp.sendRedirect(req.getContextPath() + "/my-order");
                } else {
                    System.out.println("Order not found: " + fullOrderCode);
                    req.getSession().setAttribute("errorMessage", "Không tìm thấy đơn hàng với mã: " + fullOrderCode);
                    resp.sendRedirect(req.getContextPath() + "/my-order");
                }
            } else {
                req.getSession().setAttribute("errorMessage",
                        "Thanh toán không thành công. Status: " + status + ", Code: " + code);
                resp.sendRedirect(req.getContextPath() + "/my-order");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xử lý thanh toán: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/my-order");
        }
    }

    private void handlePayOSCancel(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String orderCode = req.getParameter("orderCode");
            System.out.println("PayOS Cancel - OrderCode: " + orderCode);

            if (orderCode != null) {
                String fullOrderCode = "ORDER-" + orderCode;
                Order order = orderDAO.getOrderByPayOSCode(fullOrderCode);
                if (order != null) {
                    // Hủy đơn hàng (email sẽ được gửi bất đồng bộ)
                    orderService.cancelOrder(order.getId(), "Khách hàng hủy thanh toán PayOS");

                    req.getSession().setAttribute("errorMessage",
                            "Thanh toán đã bị hủy. Đơn hàng #" + order.getId() + " đã được hủy.");
                } else {
                    req.getSession().setAttribute("errorMessage", "Thanh toán đã bị hủy.");
                }
            } else {
                req.getSession().setAttribute("errorMessage", "Thanh toán đã bị hủy.");
            }
            resp.sendRedirect(req.getContextPath() + "/my-order");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xử lý hủy thanh toán.");
            resp.sendRedirect(req.getContextPath() + "/my-order");
        }
    }
}
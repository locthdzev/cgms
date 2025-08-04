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
                // Tìm đơn hàng theo PayOS order code với format ORDER-
                String fullOrderCode = "ORDER-" + orderCode;
                Order order = orderDAO.getOrderByPayOSCode(fullOrderCode);

                if (order != null) {
                    // Debug logging để kiểm tra order
                    System.out.println("=== PayOS Success Debug ===");
                    System.out.println("Order ID: " + order.getId());
                    System.out.println("Order Member: " + order.getMember().getFullName());
                    System.out.println("Order CreatedByAdmin: " + order.getCreatedByAdmin());
                    System.out.println("Is Admin Order: " + (order.getCreatedByAdmin() != null));
                    System.out.println("Order Status: " + order.getStatus());
                    System.out.println("Order PayOS Code: " + order.getPayOSOrderCode());
                    System.out.println("============================");

                    boolean isAdminOrder = (order.getCreatedByAdmin() != null);

                    if (isAdminOrder) {
                        // Admin order: Chuyển thành COMPLETED (bán trực tiếp)
                        System.out.println("PROCESSING ADMIN ORDER - Updating status to COMPLETED");
                        orderService.updateOrderStatus(order.getId(), OrderService.OrderConstants.STATUS_COMPLETED);

                        req.getSession().setAttribute("successMessage",
                                "Thanh toán thành công! Đơn hàng #" + order.getId() + " đã hoàn thành.");

                        System.out.println("Admin order payment successful and completed: " + order.getId());
                        System.out.println("REDIRECTING TO: /admin-orders");
                        resp.sendRedirect(req.getContextPath() + "/admin-orders");
                    } else {
                        // Member order: Giữ PENDING (chờ admin xác nhận, đã trừ inventory)
                        System.out.println("PROCESSING MEMBER ORDER - Keeping PENDING status");
                        req.getSession().setAttribute("successMessage",
                                "Thanh toán thành công! Đơn hàng #" + order.getId() + " đang chờ xác nhận từ admin.");

                        System.out.println("Member order payment successful: " + order.getId());
                        System.out.println("REDIRECTING TO: /my-order");
                        resp.sendRedirect(req.getContextPath() + "/my-order");
                    }
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

                    // Kiểm tra xem order được tạo bởi admin hay member để redirect đúng
                    boolean isAdminOrder = (order.getCreatedByAdmin() != null);

                    req.getSession().setAttribute("errorMessage",
                            "Thanh toán đã bị hủy. Đơn hàng #" + order.getId() + " đã được hủy.");

                    if (isAdminOrder) {
                        resp.sendRedirect(req.getContextPath() + "/admin-orders");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/my-order");
                    }
                } else {
                    req.getSession().setAttribute("errorMessage", "Thanh toán đã bị hủy.");
                    resp.sendRedirect(req.getContextPath() + "/my-order");
                }
            } else {
                req.getSession().setAttribute("errorMessage", "Thanh toán đã bị hủy.");
                resp.sendRedirect(req.getContextPath() + "/my-order");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xử lý hủy thanh toán.");
            resp.sendRedirect(req.getContextPath() + "/my-order");
        }
    }
}
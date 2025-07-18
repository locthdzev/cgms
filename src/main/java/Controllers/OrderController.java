package Controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

import Models.Order;
import Models.User;
import Models.Voucher;
import Services.OrderService;
import Services.ProductService;
import Services.UserService;
import Services.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class OrderController extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final UserService userService = new UserService();
    private final VoucherService voucherService = new VoucherService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                prepareCreateForm(request, response);
                break;
            case "edit":
                prepareEditForm(request, response);
                break;
            case "delete":
                deleteOrder(request, response);
                break;
            case "view":
                viewOrderDetail(request, response);
                break;
            default:
                listOrders(request, response);
        }
    }

    private void prepareCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("voucherList", voucherService.getAllVouchers());
        request.setAttribute("userList", userService.getAllUsers());
        request.setAttribute("products", productService.getAllProducts());
        request.getRequestDispatcher("order-create.jsp").forward(request, response);
    }

    private void prepareEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(id);
        request.setAttribute("order", order);
        request.setAttribute("voucherList", voucherService.getAllVouchers());
        request.setAttribute("userList", userService.getAllUsers());
        request.setAttribute("products", productService.getAllProducts()); // THÊM DÒNG NÀY
        request.setAttribute("action", "edit");
        request.getRequestDispatcher("order-create.jsp").forward(request, response);
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        orderService.deleteOrder(id);
        response.sendRedirect(request.getContextPath() + "/order?action=list");
    }

    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(id);
        request.setAttribute("order", order);
        request.getRequestDispatcher("order-detail.jsp").forward(request, response);
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String status = request.getParameter("status");
        String memberIdStr = request.getParameter("memberId");

        List<Order> orders;
        if (status != null && !status.isEmpty()) {
            orders = orderService.getOrdersByStatus(status);
        } else if (memberIdStr != null && !memberIdStr.isEmpty()) {
            int memberId = Integer.parseInt(memberIdStr);
            orders = orderService.getOrdersByMemberId(memberId);
        } else {
            orders = orderService.getAllOrders();
        }

        request.setAttribute("orderList", orders);
        request.setAttribute("userList", userService.getAllUsers());
        request.getRequestDispatcher("order.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action) || "update".equals(action)) {
            saveOrder(request, response);
        }
    }

    private void saveOrder(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            Order order = new Order();

            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                order.setId(Integer.parseInt(idStr));
            }

            int memberId = Integer.parseInt(request.getParameter("memberId"));
            User user = new User();
            user.setId(memberId);
            order.setMember(user);

            order.setOrderDate(LocalDate.parse(request.getParameter("orderDate")));
            order.setStatus(request.getParameter("status"));

            String voucherIdStr = request.getParameter("voucherId");
            if (voucherIdStr != null && !voucherIdStr.isEmpty()) {
                Voucher voucher = voucherService.getVoucherById(Integer.parseInt(voucherIdStr));
                order.setVoucher(voucher);
            }

            String totalAmountStr = request.getParameter("totalAmount");
            if (totalAmountStr != null && !totalAmountStr.isEmpty()) {
                order.setTotalAmount(new BigDecimal(totalAmountStr));
            }

            List<String> validationErrors = orderService.validateOrder(order);
            if (!validationErrors.isEmpty()) {
                request.setAttribute("errorMessage", String.join("<br>", validationErrors));
                request.setAttribute("order", order);
                request.setAttribute("voucherList", voucherService.getAllVouchers());
                request.setAttribute("userList", userService.getAllUsers());
                request.setAttribute("products", productService.getAllProducts());
                request.getRequestDispatcher("order-create.jsp").forward(request, response);
                return;
            }

            if (order.getId() == null || order.getId() == 0) {
                orderService.createOrder(order);
                request.getSession().setAttribute("successMessage", "Tạo đơn hàng thành công!");
            } else {
                orderService.updateOrder(order);
                request.getSession().setAttribute("successMessage", "Cập nhật đơn hàng thành công!");
            }

            response.sendRedirect(request.getContextPath() + "/order?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("order-create.jsp").forward(request, response);
        }
    }
}

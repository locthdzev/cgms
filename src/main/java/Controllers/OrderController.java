/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import Services.UserService;
import Services.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author LENOVO
 */

public class OrderController extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final UserService userService = new UserService();
    private final VoucherService voucherService = new VoucherService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "create":
                // Prepare data for form
                req.setAttribute("order", new Order());
                req.setAttribute("userList", userService.getAllUsers());
                req.setAttribute("voucherList", voucherService.getAllVouchers());
                req.getRequestDispatcher("/order-form.jsp").forward(req, resp);
                break;
            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                Order order = orderService.getOrderById(id);
                req.setAttribute("order", order);
                req.setAttribute("userList", userService.getAllUsers());
                req.setAttribute("voucherList", voucherService.getAllVouchers());
                req.getRequestDispatcher("/order-form.jsp").forward(req, resp);
                break;
            case "delete":
                try {
                    orderService.deleteOrder(Integer.parseInt(req.getParameter("id")));
                    HttpSession session = req.getSession();
                    session.setAttribute("successMessage", "Xóa đơn hàng thành công!");
                } catch (Exception e) {
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage", "Lỗi khi xóa đơn hàng: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/order?action=list");
                break;
            case "view":
                int viewId = Integer.parseInt(req.getParameter("id"));
                Order viewOrder = orderService.getOrderById(viewId);
                req.setAttribute("order", viewOrder);
                req.getRequestDispatcher("/order-detail.jsp").forward(req, resp);
                break;
            case "filterByStatus":
                String status = req.getParameter("status");
                List<Order> filteredOrders = orderService.getOrdersByStatus(status);
                req.setAttribute("orderList", filteredOrders);
                req.setAttribute("selectedStatus", status);
                req.getRequestDispatcher("/order-list.jsp").forward(req, resp);
                break;
            case "filterByMember":
                int memberId = Integer.parseInt(req.getParameter("memberId"));
                List<Order> memberOrders = orderService.getOrdersByMemberId(memberId);
                req.setAttribute("orderList", memberOrders);
                req.setAttribute("selectedMemberId", memberId);
                req.getRequestDispatcher("/order-list.jsp").forward(req, resp);
                break;
            default:
                List<Order> list = orderService.getAllOrders();
                req.setAttribute("orderList", list);
                req.getRequestDispatcher("/order-list.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        HttpSession session = req.getSession();
        Order order = new Order();

        try {
            if (idStr != null && !idStr.trim().isEmpty()) {
                // Update
                order = orderService.getOrderById(Integer.parseInt(idStr));
                order.setUpdatedAt(Instant.now());
            } else {
                // Create
                order.setCreatedAt(Instant.now());
            }

            // Set member
            String memberIdStr = req.getParameter("memberId");
            if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                User member = userService.getUserById(Integer.parseInt(memberIdStr));
                order.setMember(member);
            }

            // Set voucher (optional)
            String voucherIdStr = req.getParameter("voucherId");
            if (voucherIdStr != null && !voucherIdStr.trim().isEmpty()) {
                Voucher voucher = voucherService.getVoucherById(Integer.parseInt(voucherIdStr));
                order.setVoucher(voucher);
            } else {
                order.setVoucher(null);
            }

            // Set total amount
            String totalAmountStr = req.getParameter("totalAmount");
            if (totalAmountStr != null && !totalAmountStr.trim().isEmpty()) {
                order.setTotalAmount(new BigDecimal(totalAmountStr));
            }

            // Set order date
            String orderDateStr = req.getParameter("orderDate");
            if (orderDateStr != null && !orderDateStr.trim().isEmpty()) {
                order.setOrderDate(LocalDate.parse(orderDateStr));
            }

            // Set status
            order.setStatus(req.getParameter("status"));

            // Validate order data
            List<String> validationErrors = orderService.validateOrder(order);
            if (!validationErrors.isEmpty()) {
                StringBuilder errorMessage = new StringBuilder("Lỗi validation:<ul>");
                for (String error : validationErrors) {
                    errorMessage.append("<li>").append(error).append("</li>");
                }
                errorMessage.append("</ul>");
                req.setAttribute("errorMessage", errorMessage.toString());
                req.setAttribute("order", order);
                req.setAttribute("userList", userService.getAllUsers());
                req.setAttribute("voucherList", voucherService.getAllVouchers());
                req.getRequestDispatcher("/order-form.jsp").forward(req, resp);
                return;
            }

            if (idStr != null && !idStr.trim().isEmpty()) {
                orderService.updateOrder(order);
                session.setAttribute("successMessage", "Cập nhật đơn hàng thành công!");
            } else {
                orderService.saveOrder(order);
                session.setAttribute("successMessage", "Tạo đơn hàng mới thành công!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            req.setAttribute("order", order);
            req.setAttribute("userList", userService.getAllUsers());
            req.setAttribute("voucherList", voucherService.getAllVouchers());
            req.getRequestDispatcher("/order-form.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/order?action=list");
    }
}
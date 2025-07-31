package Services;

import DAOs.OrderDAO;
import DAOs.CartDAO;
import DAOs.InventoryDAO;
import Models.Order;
import Models.OrderDetail;
import Models.Cart;
import Models.User;
import Models.Product;
import Models.Inventory;
import Utilities.EmailSender;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public class OrderService {
    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final PayOSService payOSService = new PayOSService();

    public static class OrderConstants {
        public static final String STATUS_PENDING = "PENDING";
        public static final String STATUS_CONFIRMED = "CONFIRMED";
        public static final String STATUS_SHIPPING = "SHIPPING";
        public static final String STATUS_COMPLETED = "COMPLETED";
        public static final String STATUS_CANCELLED = "CANCELLED";

        public static final String PAYMENT_CASH = "CASH";
        public static final String PAYMENT_PAYOS = "PAYOS";
    }

    /**
     * Gửi email thông báo cho admin khi có đơn hàng mới
     */
    private void sendNewOrderNotificationToAdmin(User customer, Order order) {
        try {
            // Email admin cố định - có thể cấu hình từ database sau
            String adminEmail = "locthdev@gmail.com"; // Thay đổi email admin thực tế

            String subject = "Đơn hàng mới #" + order.getId() + " - CGMS";
            String htmlContent = buildNewOrderAdminEmailContent(customer, order);
            EmailSender.send(adminEmail, subject, htmlContent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String buildNewOrderAdminEmailContent(User customer, Order order) {
        return "<div style='max-width:600px;margin:0 auto;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);padding:32px;'>"
                +
                "<h2 style='color:#2d3748;margin-bottom:24px;'>🛒 Đơn hàng mới từ khách hàng</h2>" +
                "<div style='background:#f0f9ff;border-radius:8px;padding:20px;margin:20px 0;border-left:4px solid #0ea5e9;'>"
                +
                "<h3 style='color:#0c4a6e;margin-top:0;'>Thông tin đơn hàng</h3>" +
                "<p><strong>Mã đơn hàng:</strong> #" + order.getId() + "</p>" +
                "<p><strong>Khách hàng:</strong> " + customer.getFullName() + " (" + customer.getEmail() + ")</p>" +
                "<p><strong>Ngày đặt:</strong> " + order.getOrderDate() + "</p>" +
                "<p><strong>Tổng tiền:</strong> " + String.format("%,.0f", order.getTotalAmount()) + " VNĐ</p>" +
                "<p><strong>Phương thức thanh toán:</strong> "
                + (OrderConstants.PAYMENT_CASH.equals(order.getPaymentMethod()) ? "Tiền mặt" : "PayOS") + "</p>" +
                "<p><strong>Địa chỉ giao hàng:</strong> " + order.getShippingAddress() + "</p>" +
                "<p><strong>Người nhận:</strong> " + order.getReceiverName() + " - " + order.getReceiverPhone() + "</p>"
                +
                "</div>" +
                "<div style='background:#fef3c7;border-radius:8px;padding:15px;margin:20px 0;'>" +
                "<p style='margin:0;'><strong>⚡ Hành động cần thực hiện:</strong></p>" +
                "<p style='margin:5px 0 0 0;'>Vui lòng vào hệ thống quản lý để xác nhận đơn hàng này.</p>" +
                "</div>" +
                (order.getNotes() != null && !order.getNotes().trim().isEmpty()
                        ? "<div style='background:#f9fafb;border-radius:8px;padding:15px;margin:20px 0;'>" +
                                "<p style='margin:0;'><strong>Ghi chú:</strong> " + order.getNotes() + "</p>" +
                                "</div>"
                        : "")
                +
                "<p>Trân trọng,<br>Hệ thống CGMS</p>" +
                "</div>";
    }

    /**
     * Tạo đơn hàng từ giỏ hàng của member/PT
     */
    public int createOrderFromCart(User user, String shippingAddress, String receiverName,
            String receiverPhone, String paymentMethod, String notes) {
        try {
            // Lấy giỏ hàng
            List<Cart> cartItems = cartDAO.getCartByMemberId(user.getId());
            if (cartItems.isEmpty()) {
                throw new RuntimeException("Giỏ hàng trống");
            }

            // Kiểm tra tồn kho
            for (Cart cartItem : cartItems) {
                Inventory inventory = inventoryDAO.getInventoryByProductId(cartItem.getProduct().getId());
                if (inventory == null || inventory.getQuantity() < cartItem.getQuantity()) {
                    throw new RuntimeException("Sản phẩm " + cartItem.getProduct().getName() +
                            " không đủ số lượng trong kho");
                }
            }

            // Tính tổng tiền
            BigDecimal totalAmount = cartItems.stream()
                    .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Tạo đơn hàng
            Order order = new Order();
            order.setMember(user);
            order.setTotalAmount(totalAmount);
            order.setOrderDate(LocalDate.now());
            order.setStatus(OrderConstants.STATUS_PENDING);
            order.setCreatedAt(Instant.now());
            order.setShippingAddress(shippingAddress);
            order.setReceiverName(receiverName);
            order.setReceiverPhone(receiverPhone);
            order.setPaymentMethod(paymentMethod);
            order.setNotes(notes);

            // Nếu thanh toán qua PayOS, tạo mã đơn hàng PayOS
            if (OrderConstants.PAYMENT_PAYOS.equals(paymentMethod)) {
                String payOSOrderCode = "ORDER-" + System.currentTimeMillis();
                order.setPayOSOrderCode(payOSOrderCode);
            }

            int orderId = orderDAO.createOrder(order);
            if (orderId == -1) {
                throw new RuntimeException("Không thể tạo đơn hàng");
            }

            order.setId(orderId);

            // Tạo chi tiết đơn hàng
            for (Cart cartItem : cartItems) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrder(order);
                orderDetail.setProduct(cartItem.getProduct());
                orderDetail.setQuantity(cartItem.getQuantity());
                orderDetail.setUnitPrice(cartItem.getProduct().getPrice());
                orderDetail.setTotalPrice(cartItem.getProduct().getPrice()
                        .multiply(BigDecimal.valueOf(cartItem.getQuantity())));
                orderDetail.setCreatedAt(Instant.now());
                orderDetail.setStatus("ACTIVE");

                orderDAO.createOrderDetail(orderDetail);
            }

            // Xóa giỏ hàng
            orderDAO.clearCartAfterOrder(user.getId());

            // Gửi email bất đồng bộ để không làm chậm response
            sendEmailsAsync(user, order);

            return orderId;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi tạo đơn hàng: " + e.getMessage());
        }
    }

    /**
     * Gửi email bất đồng bộ
     */
    private void sendEmailsAsync(User user, Order order) {
        // Tạo thread riêng để gửi email
        new Thread(() -> {
            try {
                // Gửi email xác nhận cho khách hàng
                sendOrderConfirmationEmail(user, order);

                // Gửi email thông báo cho admin
                sendNewOrderNotificationToAdmin(user, order);
            } catch (Exception e) {
                // Log lỗi nhưng không ảnh hưởng đến quá trình đặt hàng
                System.err.println("Lỗi khi gửi email: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    /**
     * Admin tạo đơn hàng cho member/PT
     */
    public int createOrderByAdmin(User admin, User customer, List<OrderItem> orderItems,
            String shippingAddress, String receiverName, String receiverPhone,
            String paymentMethod, String notes) {
        try {
            // Kiểm tra tồn kho và load product details
            ProductService productService = new ProductService();
            for (OrderItem item : orderItems) {
                Inventory inventory = inventoryDAO.getInventoryByProductId(item.getProductId());
                if (inventory == null || inventory.getQuantity() < item.getQuantity()) {
                    throw new RuntimeException("Sản phẩm ID " + item.getProductId() +
                            " không đủ số lượng trong kho");
                }
            }

            // Tính tổng tiền
            BigDecimal totalAmount = orderItems.stream()
                    .map(item -> item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Tạo đơn hàng
            Order order = new Order();
            order.setMember(customer);
            order.setCreatedByAdmin(admin);
            order.setTotalAmount(totalAmount);
            order.setOrderDate(LocalDate.now());

            // Admin tạo order với Cash = CONFIRMED, PayOS = PENDING
            if (OrderConstants.PAYMENT_CASH.equals(paymentMethod)) {
                order.setStatus(OrderConstants.STATUS_CONFIRMED);
            } else {
                order.setStatus(OrderConstants.STATUS_PENDING);
            }

            order.setCreatedAt(Instant.now());
            order.setShippingAddress(shippingAddress);
            order.setReceiverName(receiverName);
            order.setReceiverPhone(receiverPhone);
            order.setPaymentMethod(paymentMethod);
            order.setNotes(notes);

            if (OrderConstants.PAYMENT_PAYOS.equals(paymentMethod)) {
                String payOSOrderCode = "ORDER-" + System.currentTimeMillis();
                order.setPayOSOrderCode(payOSOrderCode);
            }

            int orderId = orderDAO.createOrder(order);
            if (orderId == -1) {
                throw new RuntimeException("Không thể tạo đơn hàng");
            }

            order.setId(orderId);

            // Tạo chi tiết đơn hàng với product details đầy đủ
            for (OrderItem item : orderItems) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrder(order);

                // Load full product details for PayOS
                Product product = productService.getProductById(item.getProductId());
                if (product == null) {
                    throw new RuntimeException("Không tìm thấy sản phẩm ID: " + item.getProductId());
                }
                orderDetail.setProduct(product);

                orderDetail.setQuantity(item.getQuantity());
                orderDetail.setUnitPrice(item.getUnitPrice());
                orderDetail.setTotalPrice(item.getUnitPrice()
                        .multiply(BigDecimal.valueOf(item.getQuantity())));
                orderDetail.setCreatedAt(Instant.now());
                orderDetail.setStatus("ACTIVE");

                orderDAO.createOrderDetail(orderDetail);

                // Update inventory
                Inventory inventory = inventoryDAO.getInventoryByProductId(item.getProductId());
                if (inventory != null) {
                    inventory.setQuantity(inventory.getQuantity() - item.getQuantity());
                    inventoryDAO.updateInventory(inventory);
                }
            }

            // Gửi email xác nhận bất đồng bộ
            sendEmailsAsync(customer, order);

            return orderId;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi tạo đơn hàng: " + e.getMessage());
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng
     */
    public void updateOrderStatus(int orderId, String newStatus) {
        orderDAO.updateOrderStatus(orderId, newStatus);

        // Gửi email thông báo cập nhật trạng thái bất đồng bộ
        Order order = orderDAO.getOrderById(orderId);
        if (order != null) {
            sendOrderStatusUpdateEmailAsync(order.getMember(), order, newStatus);
        }
    }

    /**
     * Gửi email cập nhật trạng thái bất đồng bộ
     */
    private void sendOrderStatusUpdateEmailAsync(User customer, Order order, String newStatus) {
        // Tạo thread riêng để gửi email
        new Thread(() -> {
            try {
                sendOrderStatusUpdateEmail(customer, order, newStatus);
            } catch (Exception e) {
                // Log lỗi nhưng không ảnh hưởng đến quá trình cập nhật
                System.err.println("Lỗi khi gửi email cập nhật trạng thái: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    /**
     * Hủy đơn hàng (chỉ được phép khi chưa vận chuyển)
     */
    public boolean cancelOrder(int orderId, String reason) {
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            return false;
        }

        // Chỉ cho phép hủy khi đơn hàng chưa được vận chuyển
        if (OrderConstants.STATUS_SHIPPING.equals(order.getStatus()) ||
                OrderConstants.STATUS_COMPLETED.equals(order.getStatus())) {
            return false;
        }

        orderDAO.updateOrderStatus(orderId, OrderConstants.STATUS_CANCELLED);

        // Nếu thanh toán qua PayOS và chưa thanh toán, hủy payment link
        if (OrderConstants.PAYMENT_PAYOS.equals(order.getPaymentMethod()) &&
                order.getPayOSOrderCode() != null) {
            try {
                payOSService.cancelPaymentLink(order.getPayOSOrderCode(), reason);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Gửi email bất đồng bộ để không làm chậm response
        sendCancellationEmailsAsync(order.getMember(), order, reason);

        return true;
    }

    /**
     * Gửi email hủy đơn hàng bất đồng bộ
     */
    private void sendCancellationEmailsAsync(User customer, Order order, String reason) {
        // Tạo thread riêng để gửi email
        new Thread(() -> {
            try {
                // Gửi email thông báo cho khách hàng
                sendOrderCancellationEmail(customer, order, reason);

                // Gửi email thông báo cho admin
                sendOrderCancellationNotificationToAdmin(customer, order, reason);
            } catch (Exception e) {
                // Log lỗi nhưng không ảnh hưởng đến quá trình hủy đơn hàng
                System.err.println("Lỗi khi gửi email hủy đơn hàng: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    /**
     * Lấy danh sách đơn hàng của member/PT
     */
    public List<Order> getOrdersByMemberId(int memberId) {
        return orderDAO.getOrdersByMemberId(memberId);
    }

    /**
     * Lấy chi tiết đơn hàng
     */
    public Order getOrderWithDetails(int orderId) {
        Order order = orderDAO.getOrderById(orderId);
        if (order != null) {
            List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);
            // Set order details to order object if needed
        }
        return order;
    }

    /**
     * Lấy tất cả đơn hàng (cho admin)
     */
    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }

    /**
     * Gửi email xác nhận đơn hàng
     */
    private void sendOrderConfirmationEmail(User user, Order order) {
        try {
            String subject = "Xác nhận đơn hàng #" + order.getId() + " - CGMS";
            String htmlContent = buildOrderConfirmationEmailContent(user, order);
            EmailSender.send(user.getEmail(), subject, htmlContent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Gửi email cập nhật trạng thái đơn hàng
     */
    private void sendOrderStatusUpdateEmail(User user, Order order, String newStatus) {
        try {
            String statusText = getStatusText(newStatus);
            String subject = "Cập nhật đơn hàng #" + order.getId() + " - " + statusText;
            String htmlContent = buildOrderStatusUpdateEmailContent(user, order, statusText);
            EmailSender.send(user.getEmail(), subject, htmlContent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Gửi email thông báo hủy đơn hàng
     */
    private void sendOrderCancellationEmail(User user, Order order, String reason) {
        try {
            String subject = "Đơn hàng #" + order.getId() + " đã được hủy - CGMS";
            String htmlContent = buildOrderCancellationEmailContent(user, order, reason);
            EmailSender.send(user.getEmail(), subject, htmlContent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Gửi email thông báo cho admin khi đơn hàng bị hủy
     */
    private void sendOrderCancellationNotificationToAdmin(User customer, Order order, String reason) {
        try {
            // Email admin cố định - có thể cấu hình từ database sau
            String adminEmail = "locthdev@gmail.com"; // Thay đổi email admin thực tế

            String subject = "Đơn hàng #" + order.getId() + " đã bị hủy - CGMS";
            String htmlContent = buildOrderCancellationAdminEmailContent(customer, order, reason);
            EmailSender.send(adminEmail, subject, htmlContent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getStatusText(String status) {
        switch (status) {
            case OrderConstants.STATUS_PENDING:
                return "Chờ xác nhận";
            case OrderConstants.STATUS_CONFIRMED:
                return "Đã xác nhận";
            case OrderConstants.STATUS_SHIPPING:
                return "Đang vận chuyển";
            case OrderConstants.STATUS_COMPLETED:
                return "Hoàn thành";
            case OrderConstants.STATUS_CANCELLED:
                return "Đã hủy";
            default:
                return status;
        }
    }

    private String buildOrderConfirmationEmailContent(User user, Order order) {
        return "<div style='max-width:600px;margin:0 auto;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);padding:32px;'>"
                +
                "<h2 style='color:#2d3748;margin-bottom:24px;'>Xác nhận đơn hàng</h2>" +
                "<p>Xin chào <strong>" + user.getFullName() + "</strong>,</p>" +
                "<p>Cảm ơn bạn đã đặt hàng tại CGMS. Đơn hàng của bạn đã được tạo thành công.</p>" +
                "<div style='background:#f7fafc;border-radius:8px;padding:20px;margin:20px 0;'>" +
                "<h3 style='color:#2d3748;margin-top:0;'>Thông tin đơn hàng</h3>" +
                "<p><strong>Mã đơn hàng:</strong> #" + order.getId() + "</p>" +
                "<p><strong>Ngày đặt:</strong> " + order.getOrderDate() + "</p>" +
                "<p><strong>Tổng tiền:</strong> " + String.format("%,.0f", order.getTotalAmount()) + " VNĐ</p>" +
                "<p><strong>Phương thức thanh toán:</strong> "
                + (OrderConstants.PAYMENT_CASH.equals(order.getPaymentMethod()) ? "Tiền mặt" : "PayOS") + "</p>" +
                "<p><strong>Địa chỉ giao hàng:</strong> " + order.getShippingAddress() + "</p>" +
                "</div>" +
                "<p>Chúng tôi sẽ xử lý đơn hàng của bạn và gửi thông báo cập nhật qua email này.</p>" +
                "<p>Trân trọng,<br>Đội ngũ CGMS</p>" +
                "</div>";
    }

    private String buildOrderStatusUpdateEmailContent(User user, Order order, String statusText) {
        return "<div style='max-width:600px;margin:0 auto;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);padding:32px;'>"
                +
                "<h2 style='color:#2d3748;margin-bottom:24px;'>Cập nhật đơn hàng #" + order.getId() + "</h2>" +
                "<p>Xin chào <strong>" + user.getFullName() + "</strong>,</p>" +
                "<p>Đơn hàng #" + order.getId() + " của bạn đã được cập nhật trạng thái:</p>" +
                "<div style='background:#f0fff4;border-radius:8px;padding:20px;margin:20px 0;border-left:4px solid #48bb78;'>"
                +
                "<h3 style='color:#22543d;margin-top:0;'>Trạng thái hiện tại: " + statusText + "</h3>" +
                "</div>" +
                "<p>Cảm ơn bạn đã mua sắm tại CGMS!</p>" +
                "<p>Trân trọng,<br>Đội ngũ CGMS</p>" +
                "</div>";
    }

    private String buildOrderCancellationEmailContent(User user, Order order, String reason) {
        return "<div style='max-width:600px;margin:0 auto;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);padding:32px;'>"
                +
                "<h2 style='color:#2d3748;margin-bottom:24px;'>Đơn hàng #" + order.getId() + " đã được hủy</h2>" +
                "<p>Xin chào <strong>" + user.getFullName() + "</strong>,</p>" +
                "<p>Đơn hàng #" + order.getId() + " của bạn đã được hủy.</p>" +
                (reason != null && !reason.trim().isEmpty()
                        ? "<div style='background:#fff5f5;border-radius:8px;padding:20px;margin:20px 0;border-left:4px solid #f56565;'>"
                                +
                                "<p><strong>Lý do hủy:</strong> " + reason + "</p>" +
                                "</div>"
                        : "")
                +
                "<p>Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.</p>" +
                "<p>Trân trọng,<br>Đội ngũ CGMS</p>" +
                "</div>";
    }

    private String buildOrderCancellationAdminEmailContent(User customer, Order order, String reason) {
        return "<div style='max-width:600px;margin:0 auto;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);padding:32px;'>"
                +
                "<h2 style='color:#2d3748;margin-bottom:24px;'>❌ Đơn hàng #" + order.getId() + " đã bị hủy</h2>" +
                "<div style='background:#fff5f5;border-radius:8px;padding:20px;margin:20px 0;border-left:4px solid #f56565;'>"
                +
                "<h3 style='color:#c53030;margin-top:0;'>Thông tin đơn hàng bị hủy</h3>" +
                "<p><strong>Mã đơn hàng:</strong> #" + order.getId() + "</p>" +
                "<p><strong>Khách hàng:</strong> " + customer.getFullName() + " (" + customer.getEmail() + ")</p>" +
                "<p><strong>Ngày đặt:</strong> " + order.getOrderDate() + "</p>" +
                "<p><strong>Tổng tiền:</strong> " + String.format("%,.0f", order.getTotalAmount()) + " VNĐ</p>" +
                "<p><strong>Phương thức thanh toán:</strong> "
                + (OrderConstants.PAYMENT_CASH.equals(order.getPaymentMethod()) ? "Tiền mặt" : "PayOS") + "</p>" +
                "<p><strong>Địa chỉ giao hàng:</strong> " + order.getShippingAddress() + "</p>" +
                "<p><strong>Người nhận:</strong> " + order.getReceiverName() + " - " + order.getReceiverPhone() + "</p>"
                +
                (reason != null && !reason.trim().isEmpty()
                        ? "<p><strong>Lý do hủy:</strong> " + reason + "</p>"
                        : "<p><strong>Lý do hủy:</strong> Không có lý do cụ thể</p>")
                +
                "</div>" +
                "<div style='background:#fef3c7;border-radius:8px;padding:15px;margin:20px 0;'>" +
                "<p style='margin:0;'><strong>⚠️ Lưu ý:</strong></p>" +
                "<p style='margin:5px 0 0 0;'>Đơn hàng này đã bị hủy bởi khách hàng. Vui lòng cập nhật kho hàng nếu cần thiết.</p>"
                +
                "</div>" +
                "<p>Trân trọng,<br>Hệ thống CGMS</p>" +
                "</div>";
    }

    // Inner class for order items when admin creates order
    public static class OrderItem {
        private int productId;
        private int quantity;
        private BigDecimal unitPrice;

        public OrderItem(int productId, int quantity, BigDecimal unitPrice) {
            this.productId = productId;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
        }

        // Getters and setters
        public int getProductId() {
            return productId;
        }

        public void setProductId(int productId) {
            this.productId = productId;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public BigDecimal getUnitPrice() {
            return unitPrice;
        }

        public void setUnitPrice(BigDecimal unitPrice) {
            this.unitPrice = unitPrice;
        }
    }
}
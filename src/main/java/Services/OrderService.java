package Services;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import DAOs.OrderDAO;
import Models.Order;
import Models.User;
import Models.Voucher;

public class OrderService {
    private final OrderDAO orderDAO = new OrderDAO();

    // Get all orders
    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }

    // Get order by ID
    public Order getOrderById(int id) {
        return orderDAO.getOrderById(id);
    }

    // Get orders by member ID
    public List<Order> getOrdersByMemberId(int memberId) {
        return orderDAO.getOrdersByMemberId(memberId);
    }

    // Get orders by status
    public List<Order> getOrdersByStatus(String status) {
        return orderDAO.getOrdersByStatus(status);
    }

    // Create new order
    public void createOrder(Order order) {
        orderDAO.createOrder(order);
    }

    // Save order (create or update)
    public void saveOrder(Order order) {
        if (order.getId() == null || order.getId() == 0) {
            createOrder(order);
        } else {
            updateOrder(order);
        }
    }

    // Update existing order
    public void updateOrder(Order order) {
        orderDAO.updateOrder(order);
    }

    // Delete order
    public void deleteOrder(int orderId) {
        orderDAO.deleteOrder(orderId);
    }

    // Validate order data
    public List<String> validateOrder(Order order) {
        List<String> errors = new ArrayList<>();

        // Validate member
        if (order.getMember() == null || order.getMember().getId() == null || order.getMember().getId() <= 0) {
            errors.add("Vui lòng chọn khách hàng");
        }

        // Validate total amount
        if (order.getTotalAmount() == null) {
            errors.add("Vui lòng nhập tổng tiền");
        } else if (order.getTotalAmount().compareTo(BigDecimal.ZERO) <= 0) {
            errors.add("Tổng tiền phải lớn hơn 0");
        }

        // Validate order date
        if (order.getOrderDate() == null) {
            errors.add("Vui lòng nhập ngày đặt hàng");
        } else if (order.getOrderDate().isAfter(LocalDate.now())) {
            errors.add("Ngày đặt hàng không thể là ngày tương lai");
        }

        // Validate status
        if (order.getStatus() == null || order.getStatus().trim().isEmpty()) {
            errors.add("Vui lòng chọn trạng thái");
        } else if (!isValidStatus(order.getStatus())) {
            errors.add("Trạng thái không hợp lệ");
        }

        // Validate voucher if exists
        if (order.getVoucher() != null && order.getVoucher().getId() != null) {
            if (order.getVoucher().getId() <= 0) {
                errors.add("Voucher không hợp lệ");
            }
            // Additional voucher validation can be added here
            // For example: check if voucher is still valid, not expired, etc.
        }

        return errors;
    }

    // Check if status is valid
    private boolean isValidStatus(String status) {
        String[] validStatuses = {"PENDING", "CONFIRMED", "PROCESSING", "SHIPPED", "DELIVERED", "CANCELLED"};
        for (String validStatus : validStatuses) {
            if (validStatus.equals(status)) {
                return true;
            }
        }
        return false;
    }

    // Get all valid statuses
    public List<String> getAllValidStatuses() {
        List<String> statuses = new ArrayList<>();
        statuses.add("PENDING");
        statuses.add("CONFIRMED");
        statuses.add("PROCESSING");
        statuses.add("SHIPPED");
        statuses.add("DELIVERED");
        statuses.add("CANCELLED");
        return statuses;
    }

    // Calculate total amount after applying voucher
    public BigDecimal calculateTotalWithVoucher(Order order) {
        BigDecimal originalAmount = order.getTotalAmount();
        if (originalAmount == null) {
            return BigDecimal.ZERO;
        }

        Voucher voucher = order.getVoucher();
        if (voucher == null || voucher.getDiscountValue() == null) {
            return originalAmount;
        }

        BigDecimal discountAmount = BigDecimal.ZERO;
        
        if ("PERCENTAGE".equals(voucher.getDiscountType())) {
            // Percentage discount
            discountAmount = originalAmount.multiply(voucher.getDiscountValue())
                    .divide(new BigDecimal("100"), 2, BigDecimal.ROUND_HALF_UP);
        } else if ("FIXED".equals(voucher.getDiscountType())) {
            // Fixed amount discount
            discountAmount = voucher.getDiscountValue();
        }

        BigDecimal finalAmount = originalAmount.subtract(discountAmount);
        return finalAmount.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : finalAmount;
    }

    // Get recent orders (last 30 days)
    public List<Order> getRecentOrders() {
        List<Order> allOrders = getAllOrders();
        List<Order> recentOrders = new ArrayList<>();
        LocalDate thirtyDaysAgo = LocalDate.now().minusDays(30);

        for (Order order : allOrders) {
            if (order.getOrderDate() != null && order.getOrderDate().isAfter(thirtyDaysAgo)) {
                recentOrders.add(order);
            }
        }
        return recentOrders;
    }

    // Get order statistics
    public OrderStatistics getOrderStatistics() {
        List<Order> allOrders = getAllOrders();
        OrderStatistics stats = new OrderStatistics();
        
        stats.setTotalOrders(allOrders.size());
        
        int pendingCount = 0;
        int completedCount = 0;
        int cancelledCount = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        
        for (Order order : allOrders) {
            if (order.getTotalAmount() != null) {
                totalRevenue = totalRevenue.add(order.getTotalAmount());
            }
            
            if ("PENDING".equals(order.getStatus())) {
                pendingCount++;
            } else if ("DELIVERED".equals(order.getStatus())) {
                completedCount++;
            } else if ("CANCELLED".equals(order.getStatus())) {
                cancelledCount++;
            }
        }
        
        stats.setPendingOrders(pendingCount);
        stats.setCompletedOrders(completedCount);
        stats.setCancelledOrders(cancelledCount);
        stats.setTotalRevenue(totalRevenue);
        
        return stats;
    }

    // Inner class for order statistics
    public static class OrderStatistics {
        private int totalOrders;
        private int pendingOrders;
        private int completedOrders;
        private int cancelledOrders;
        private BigDecimal totalRevenue;

        // Getters and setters
        public int getTotalOrders() { return totalOrders; }
        public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }

        public int getPendingOrders() { return pendingOrders; }
        public void setPendingOrders(int pendingOrders) { this.pendingOrders = pendingOrders; }

        public int getCompletedOrders() { return completedOrders; }
        public void setCompletedOrders(int completedOrders) { this.completedOrders = completedOrders; }

        public int getCancelledOrders() { return cancelledOrders; }
        public void setCancelledOrders(int cancelledOrders) { this.cancelledOrders = cancelledOrders; }

        public BigDecimal getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    }
}
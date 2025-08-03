package DAOs;

import Models.Order;
import Models.OrderDetail;
import Models.User;
import Models.Product;
import DbConnection.DbConnection;

import java.sql.*;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class OrderDAO {

    public int createOrder(Order order) {
        String sql = "INSERT INTO [Order] (MemberId, VoucherId, TotalAmount, OrderDate, Status, CreatedAt, " +
                "ShippingAddress, ReceiverName, ReceiverPhone, PaymentMethod, Notes, CreatedByAdminId, PayOSOrderCode) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getMember().getId());
            if (order.getVoucher() != null) {
                stmt.setInt(2, order.getVoucher().getId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setDate(4, Date.valueOf(order.getOrderDate()));
            stmt.setString(5, order.getStatus());
            stmt.setTimestamp(6, Timestamp.from(order.getCreatedAt()));
            stmt.setString(7, order.getShippingAddress());
            stmt.setString(8, order.getReceiverName());
            stmt.setString(9, order.getReceiverPhone());
            stmt.setString(10, order.getPaymentMethod());
            stmt.setString(11, order.getNotes());
            if (order.getCreatedByAdmin() != null) {
                stmt.setInt(12, order.getCreatedByAdmin().getId());
            } else {
                stmt.setNull(12, Types.INTEGER);
            }
            stmt.setString(13, order.getPayOSOrderCode());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void createOrderDetail(OrderDetail orderDetail) {
        String sql = "INSERT INTO Order_Details (OrderId, ProductId, Quantity, UnitPrice, TotalPrice, CreatedAt, Status) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderDetail.getOrder().getId());
            stmt.setInt(2, orderDetail.getProduct().getId());
            stmt.setInt(3, orderDetail.getQuantity());
            stmt.setBigDecimal(4, orderDetail.getUnitPrice());
            stmt.setBigDecimal(5, orderDetail.getTotalPrice());
            stmt.setTimestamp(6, Timestamp.from(orderDetail.getCreatedAt()));
            stmt.setString(7, orderDetail.getStatus());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.FullName as MemberName, u.Email as MemberEmail, " +
                "admin.FullName as AdminName " +
                "FROM [Order] o " +
                "JOIN Users u ON o.MemberId = u.UserId " +
                "LEFT JOIN Users admin ON o.CreatedByAdminId = admin.UserId " +
                "WHERE o.OrderId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("OrderId"));
                    order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    order.setOrderDate(rs.getDate("OrderDate").toLocalDate());
                    order.setStatus(rs.getString("Status"));
                    order.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                    if (rs.getTimestamp("UpdatedAt") != null) {
                        order.setUpdatedAt(rs.getTimestamp("UpdatedAt").toInstant());
                    }
                    order.setShippingAddress(rs.getString("ShippingAddress"));
                    order.setReceiverName(rs.getString("ReceiverName"));
                    order.setReceiverPhone(rs.getString("ReceiverPhone"));
                    order.setPaymentMethod(rs.getString("PaymentMethod"));
                    order.setNotes(rs.getString("Notes"));
                    order.setPayOSOrderCode(rs.getString("PayOSOrderCode"));

                    // Set member info
                    User member = new User();
                    member.setId(rs.getInt("MemberId"));
                    member.setFullName(rs.getString("MemberName"));
                    member.setEmail(rs.getString("MemberEmail"));
                    order.setMember(member);

                    // Set admin info if exists
                    if (rs.getObject("CreatedByAdminId") != null) {
                        User admin = new User();
                        admin.setId(rs.getInt("CreatedByAdminId"));
                        admin.setFullName(rs.getString("AdminName"));
                        order.setCreatedByAdmin(admin);
                    }

                    return order;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByMemberId(int memberId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.FullName as MemberName, u.Email as MemberEmail, " +
                "admin.FullName as AdminName " +
                "FROM [Order] o " +
                "JOIN Users u ON o.MemberId = u.UserId " +
                "LEFT JOIN Users admin ON o.CreatedByAdminId = admin.UserId " +
                "WHERE o.MemberId = ? ORDER BY o.CreatedAt DESC";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, memberId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("OrderId"));
                    order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    order.setOrderDate(rs.getDate("OrderDate").toLocalDate());
                    order.setStatus(rs.getString("Status"));
                    order.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                    if (rs.getTimestamp("UpdatedAt") != null) {
                        order.setUpdatedAt(rs.getTimestamp("UpdatedAt").toInstant());
                    }
                    order.setShippingAddress(rs.getString("ShippingAddress"));
                    order.setReceiverName(rs.getString("ReceiverName"));
                    order.setReceiverPhone(rs.getString("ReceiverPhone"));
                    order.setPaymentMethod(rs.getString("PaymentMethod"));
                    order.setNotes(rs.getString("Notes"));
                    order.setPayOSOrderCode(rs.getString("PayOSOrderCode"));

                    User member = new User();
                    member.setId(rs.getInt("MemberId"));
                    member.setFullName(rs.getString("MemberName"));
                    member.setEmail(rs.getString("MemberEmail"));
                    order.setMember(member);

                    // Set admin info if exists
                    if (rs.getObject("CreatedByAdminId") != null) {
                        User admin = new User();
                        admin.setId(rs.getInt("CreatedByAdminId"));
                        admin.setFullName(rs.getString("AdminName"));
                        order.setCreatedByAdmin(admin);
                    }

                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT od.*, p.Name as ProductName, p.ImageUrl, p.Price as ProductPrice " +
                "FROM Order_Details od " +
                "JOIN Products p ON od.ProductId = p.ProductId " +
                "WHERE od.OrderId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderDetail orderDetail = new OrderDetail();
                    orderDetail.setId(rs.getInt("OrderDetailId"));
                    orderDetail.setQuantity(rs.getInt("Quantity"));
                    orderDetail.setUnitPrice(rs.getBigDecimal("UnitPrice"));
                    orderDetail.setTotalPrice(rs.getBigDecimal("TotalPrice"));
                    orderDetail.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                    orderDetail.setStatus(rs.getString("Status"));

                    Product product = new Product();
                    product.setId(rs.getInt("ProductId"));
                    product.setName(rs.getString("ProductName"));
                    product.setImageUrl(rs.getString("ImageUrl"));
                    product.setPrice(rs.getBigDecimal("ProductPrice"));
                    orderDetail.setProduct(product);

                    orderDetails.add(orderDetail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderDetails;
    }

    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET Status = ?, UpdatedAt = ? WHERE OrderId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.from(Instant.now()));
            stmt.setInt(3, orderId);

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.FullName as MemberName, u.Email as MemberEmail, " +
                "admin.FullName as AdminName " +
                "FROM [Order] o " +
                "JOIN Users u ON o.MemberId = u.UserId " +
                "LEFT JOIN Users admin ON o.CreatedByAdminId = admin.UserId " +
                "ORDER BY o.CreatedAt DESC";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("OrderId"));
                    order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    order.setOrderDate(rs.getDate("OrderDate").toLocalDate());
                    order.setStatus(rs.getString("Status"));
                    order.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                    if (rs.getTimestamp("UpdatedAt") != null) {
                        order.setUpdatedAt(rs.getTimestamp("UpdatedAt").toInstant());
                    }
                    order.setShippingAddress(rs.getString("ShippingAddress"));
                    order.setReceiverName(rs.getString("ReceiverName"));
                    order.setReceiverPhone(rs.getString("ReceiverPhone"));
                    order.setPaymentMethod(rs.getString("PaymentMethod"));
                    order.setNotes(rs.getString("Notes"));
                    order.setPayOSOrderCode(rs.getString("PayOSOrderCode"));

                    User member = new User();
                    member.setId(rs.getInt("MemberId"));
                    member.setFullName(rs.getString("MemberName"));
                    member.setEmail(rs.getString("MemberEmail"));
                    order.setMember(member);

                    if (rs.getObject("CreatedByAdminId") != null) {
                        User admin = new User();
                        admin.setId(rs.getInt("CreatedByAdminId"));
                        admin.setFullName(rs.getString("AdminName"));
                        order.setCreatedByAdmin(admin);
                    }

                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderByPayOSCode(String payOSOrderCode) {
        String sql = "SELECT o.*, u.FullName as MemberName, u.Email as MemberEmail, " +
                "admin.FullName as AdminName " +
                "FROM [Order] o " +
                "JOIN Users u ON o.MemberId = u.UserId " +
                "LEFT JOIN Users admin ON o.CreatedByAdminId = admin.UserId " +
                "WHERE o.PayOSOrderCode = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, payOSOrderCode);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("OrderId"));
                    order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    order.setOrderDate(rs.getDate("OrderDate").toLocalDate());
                    order.setStatus(rs.getString("Status"));
                    order.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                    if (rs.getTimestamp("UpdatedAt") != null) {
                        order.setUpdatedAt(rs.getTimestamp("UpdatedAt").toInstant());
                    }
                    order.setShippingAddress(rs.getString("ShippingAddress"));
                    order.setReceiverName(rs.getString("ReceiverName"));
                    order.setReceiverPhone(rs.getString("ReceiverPhone"));
                    order.setPaymentMethod(rs.getString("PaymentMethod"));
                    order.setNotes(rs.getString("Notes"));
                    order.setPayOSOrderCode(rs.getString("PayOSOrderCode"));

                    // Set member info
                    User member = new User();
                    member.setId(rs.getInt("MemberId"));
                    member.setFullName(rs.getString("MemberName"));
                    member.setEmail(rs.getString("MemberEmail"));
                    order.setMember(member);

                    // Set admin info if exists
                    if (rs.getObject("CreatedByAdminId") != null) {
                        User admin = new User();
                        admin.setId(rs.getInt("CreatedByAdminId"));
                        admin.setFullName(rs.getString("AdminName"));
                        order.setCreatedByAdmin(admin);
                    }

                    return order;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void clearCartAfterOrder(int memberId) {
        String sql = "DELETE FROM Cart WHERE MemberId = ? AND Status = 'Active'";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, memberId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updatePayOSOrderCode(int orderId, String payOSOrderCode) {
        String sql = "UPDATE [Order] SET PayOSOrderCode = ? WHERE OrderId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, payOSOrderCode);
            stmt.setInt(2, orderId);

            int updatedRows = stmt.executeUpdate();
            System.out.println("Updated PayOS order code for order " + orderId + ": " + updatedRows + " rows affected");

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating PayOS order code: " + e.getMessage());
        }
    }
}
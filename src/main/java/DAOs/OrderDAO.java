package DAOs;

import Models.Order;
import Models.User;
import Models.Voucher;
import DbConnection.DbConnection;

import java.sql.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.UserId, u.UserName, u.Email, "
                + "v.VoucherId, v.Code as VoucherCode, v.DiscountValue, v.DiscountType "
                + "FROM \"Order\" o "
                + "LEFT JOIN Users u ON o.MemberId = u.UserId "
                + "LEFT JOIN Vouchers v ON o.VoucherId = v.VoucherId "
                + "ORDER BY o.OrderId";

        try (Connection conn = DbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int id) {
        String sql = "SELECT o.*, u.UserId, u.UserName, u.Email, "
                + "v.VoucherId, v.Code as VoucherCode, v.DiscountValue, v.DiscountType "
                + "FROM \"Order\" o "
                + "LEFT JOIN Users u ON o.MemberId = u.UserId "
                + "LEFT JOIN Vouchers v ON o.VoucherId = v.VoucherId "
                + "WHERE o.OrderId = ?";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByMemberId(int memberId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.UserId, u.UserName, u.Email, "
                + "v.VoucherId, v.Code as VoucherCode, v.DiscountValue, v.DiscountType "
                + "FROM \"Order\" o "
                + "LEFT JOIN Users u ON o.MemberId = u.UserId "
                + "LEFT JOIN Vouchers v ON o.VoucherId = v.VoucherId "
                + "WHERE o.MemberId = ? ORDER BY o.OrderDate DESC";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, memberId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public void saveOrder(Order order) {
        String sql = "INSERT INTO \"Order\" (MemberId, VoucherId, TotalAmount, OrderDate, "
                + "Status, CreatedAt) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getMember().getId());

            if (order.getVoucher() != null) {
                stmt.setInt(2, order.getVoucher().getId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }

            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setDate(4, Date.valueOf(order.getOrderDate()));
            stmt.setString(5, order.getStatus());

            if (order.getCreatedAt() == null) {
                order.setCreatedAt(Instant.now());
            }
            stmt.setTimestamp(6, Timestamp.from(order.getCreatedAt()));

            stmt.executeUpdate();

            // Get generated ID
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    order.setId(generatedKeys.getInt(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error saving order", e);
        }
    }

    public void updateOrder(Order order) {
        String sql = "UPDATE \"Order\" SET MemberId = ?, VoucherId = ?, TotalAmount = ?, "
                + "OrderDate = ?, Status = ?, UpdatedAt = ? WHERE OrderId = ?";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, order.getMember().getId());

            if (order.getVoucher() != null) {
                stmt.setInt(2, order.getVoucher().getId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }

            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setDate(4, Date.valueOf(order.getOrderDate()));
            stmt.setString(5, order.getStatus());

            order.setUpdatedAt(Instant.now());
            stmt.setTimestamp(6, Timestamp.from(order.getUpdatedAt()));
            stmt.setInt(7, order.getId());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating order", e);
        }
    }

    public void createOrder(Order order) {
        String sql = "INSERT INTO \"Order\" (MemberId, VoucherId, TotalAmount, OrderDate, Status, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getMember().getId());

            if (order.getVoucher() != null) {
                stmt.setInt(2, order.getVoucher().getId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }

            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setDate(4, Date.valueOf(order.getOrderDate()));
            stmt.setString(5, order.getStatus());

            Instant now = Instant.now();
            order.setCreatedAt(now);
            order.setUpdatedAt(now);

            stmt.setTimestamp(6, Timestamp.from(order.getCreatedAt()));
            stmt.setTimestamp(7, Timestamp.from(order.getUpdatedAt()));

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                // Get the generated ID
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setId(generatedKeys.getInt(1));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error creating order", e);
        }
    }

    public void deleteOrder(int id) {
        String sql = "DELETE FROM \"Order\" WHERE OrderId = ?";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting order", e);
        }
    }

    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.UserId, u.UserName, u.Email, "
                + "v.VoucherId, v.Code as VoucherCode, v.DiscountValue, v.DiscountType "
                + "FROM \"Order\" o "
                + "LEFT JOIN Users u ON o.MemberId = u.UserId "
                + "LEFT JOIN Vouchers v ON o.VoucherId = v.VoucherId "
                + "WHERE o.Status = ? ORDER BY o.OrderDate DESC";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Helper method to map ResultSet to Order object
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("OrderId"));
        order.setTotalAmount(rs.getBigDecimal("TotalAmount"));

        Date orderDate = rs.getDate("OrderDate");
        if (orderDate != null) {
            order.setOrderDate(orderDate.toLocalDate());
        }

        order.setStatus(rs.getString("Status"));

        // Map Member
        int memberId = rs.getInt("MemberId");
        if (!rs.wasNull()) {
            User member = new User();
            member.setId(memberId);
            try {
                member.setUserName(rs.getString("UserName"));
                member.setEmail(rs.getString("Email"));
            } catch (SQLException e) {
                // Column not found, ignore
            }
            order.setMember(member);
        }

        // Map Voucher
        int voucherId = rs.getInt("VoucherId");
        if (!rs.wasNull()) {
            Voucher voucher = new Voucher();
            voucher.setId(voucherId);
            try {
                voucher.setCode(rs.getString("VoucherCode"));
                voucher.setDiscountValue(rs.getBigDecimal("DiscountValue"));
                voucher.setDiscountType(rs.getString("DiscountType"));
            } catch (SQLException e) {
                // Column not found, ignore
            }
            order.setVoucher(voucher);
        }

        // Map timestamps
        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            order.setCreatedAt(createdAt.toInstant());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            order.setUpdatedAt(updatedAt.toInstant());
        }

        return order;
    }
}

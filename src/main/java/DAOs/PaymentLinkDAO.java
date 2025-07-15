package DAOs;

import DbConnection.DbConnection;
import Models.Payment;
import Models.PaymentLink;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class PaymentLinkDAO {

    public PaymentLink createPaymentLink(Payment payment, String orderCode, String paymentLinkUrl, Instant expireTime) {
        String sql = "INSERT INTO Payment_Links (PaymentId, OrderCode, PaymentLinkUrl, ExpireTime, CreatedAt, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            stmt.setInt(1, payment.getId());
            stmt.setString(2, orderCode);
            stmt.setString(3, paymentLinkUrl);
            stmt.setTimestamp(4, Timestamp.from(expireTime));
            stmt.setTimestamp(5, Timestamp.from(Instant.now()));
            stmt.setString(6, "ACTIVE");

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return null;
            }

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int paymentLinkId = rs.getInt(1);
                PaymentLink paymentLink = new PaymentLink();
                paymentLink.setId(paymentLinkId);
                paymentLink.setPayment(payment);
                paymentLink.setOrderCode(orderCode);
                paymentLink.setPaymentLinkUrl(paymentLinkUrl);
                paymentLink.setExpireTime(expireTime);
                paymentLink.setCreatedAt(Instant.now());
                paymentLink.setStatus("ACTIVE");
                return paymentLink;
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updatePaymentLinkStatus(int paymentLinkId, String status) {
        String sql = "UPDATE Payment_Links SET Status = ?, UpdatedAt = ? WHERE PaymentLinkId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);

            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.from(Instant.now()));
            stmt.setInt(3, paymentLinkId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public PaymentLink getPaymentLinkById(int paymentLinkId) {
        String sql = "SELECT pl.*, p.* FROM Payment_Links pl "
                + "LEFT JOIN Payments p ON pl.PaymentId = p.PaymentId "
                + "WHERE pl.PaymentLinkId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, paymentLinkId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapPaymentLink(rs);
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public PaymentLink getPaymentLinkByOrderCode(String orderCode) {
        String sql = "SELECT pl.*, p.* FROM Payment_Links pl "
                + "LEFT JOIN Payments p ON pl.PaymentId = p.PaymentId "
                + "WHERE pl.OrderCode = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, orderCode);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapPaymentLink(rs);
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<PaymentLink> getPaymentLinksByPaymentId(int paymentId) {
        String sql = "SELECT pl.*, p.* FROM Payment_Links pl "
                + "LEFT JOIN Payments p ON pl.PaymentId = p.PaymentId "
                + "WHERE pl.PaymentId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<PaymentLink> paymentLinks = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, paymentId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                paymentLinks.add(mapPaymentLink(rs));
            }

            return paymentLinks;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<PaymentLink> getActivePaymentLinks() {
        String sql = "SELECT pl.*, p.* FROM Payment_Links pl "
                + "LEFT JOIN Payments p ON pl.PaymentId = p.PaymentId "
                + "WHERE pl.Status = 'ACTIVE' AND pl.ExpireTime > ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<PaymentLink> paymentLinks = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setTimestamp(1, Timestamp.from(Instant.now()));
            rs = stmt.executeQuery();

            while (rs.next()) {
                paymentLinks.add(mapPaymentLink(rs));
            }

            return paymentLinks;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private PaymentLink mapPaymentLink(ResultSet rs) throws SQLException {
        PaymentLink paymentLink = new PaymentLink();
        paymentLink.setId(rs.getInt("PaymentLinkId"));
        paymentLink.setOrderCode(rs.getString("OrderCode"));
        paymentLink.setPaymentLinkUrl(rs.getString("PaymentLinkUrl"));

        String qrCode = rs.getString("QrCode");
        if (qrCode != null) {
            paymentLink.setQrCode(qrCode);
        }

        Timestamp expireTime = rs.getTimestamp("ExpireTime");
        if (expireTime != null) {
            paymentLink.setExpireTime(expireTime.toInstant());
        }

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            paymentLink.setCreatedAt(createdAt.toInstant());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            paymentLink.setUpdatedAt(updatedAt.toInstant());
        }

        paymentLink.setStatus(rs.getString("Status"));

        // Tạo Payment nếu có
        int paymentId = rs.getInt("PaymentId");
        if (!rs.wasNull()) {
            Payment payment = new Payment();
            payment.setId(paymentId);
            paymentLink.setPayment(payment);
        }

        return paymentLink;
    }
}
package DAOs;

import DbConnection.DbConnection;
import Models.MemberPackage;
import Models.Payment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public Payment createPayment(MemberPackage memberPackage, BigDecimal amount, String paymentMethod) {
        // Kiểm tra xem đã có payment nào cho memberPackage này chưa
        List<Payment> existingPayments = getPaymentsByMemberPackageId(memberPackage.getId());
        if (existingPayments != null && !existingPayments.isEmpty()) {
            // Trả về payment đã tồn tại
            return existingPayments.get(0);
        }

        String sql = "INSERT INTO Payments (MemberPackageId, Amount, PaymentMethod, PaymentDate, Status, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            stmt.setInt(1, memberPackage.getId());
            stmt.setBigDecimal(2, amount);
            stmt.setString(3, paymentMethod);
            stmt.setTimestamp(4, Timestamp.from(Instant.now()));
            stmt.setString(5, "PENDING");
            stmt.setTimestamp(6, Timestamp.from(Instant.now()));

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return null;
            }

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int paymentId = rs.getInt(1);
                Payment payment = new Payment();
                payment.setId(paymentId);
                payment.setMemberPackage(memberPackage);
                payment.setAmount(amount);
                payment.setPaymentMethod(paymentMethod);
                payment.setPaymentDate(Instant.now());
                payment.setStatus("PENDING");
                payment.setCreatedAt(Instant.now());
                return payment;
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

    public boolean updatePaymentStatus(int paymentId, String status, String transactionId) {
        String sql = "UPDATE Payments SET Status = ?, TransactionId = ?, UpdatedAt = ? WHERE PaymentId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);

            stmt.setString(1, status);
            stmt.setString(2, transactionId);
            stmt.setTimestamp(3, Timestamp.from(Instant.now()));
            stmt.setInt(4, paymentId);

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

    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT p.*, mp.* FROM Payments p "
                + "LEFT JOIN Member_Packages mp ON p.MemberPackageId = mp.MemberPackageId "
                + "WHERE p.PaymentId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, paymentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapPayment(rs);
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

    public List<Payment> getPaymentsByMemberPackageId(int memberPackageId) {
        String sql = "SELECT p.*, mp.* FROM Payments p "
                + "LEFT JOIN Member_Packages mp ON p.MemberPackageId = mp.MemberPackageId "
                + "WHERE p.MemberPackageId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Payment> payments = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberPackageId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                payments.add(mapPayment(rs));
            }

            return payments;
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

    public List<Payment> getPendingPayments() {
        String sql = "SELECT p.*, mp.* FROM Payments p "
                + "LEFT JOIN Member_Packages mp ON p.MemberPackageId = mp.MemberPackageId "
                + "WHERE p.Status = 'PENDING'";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Payment> payments = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                payments.add(mapPayment(rs));
            }

            return payments;
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

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setId(rs.getInt("PaymentId"));
        payment.setAmount(rs.getBigDecimal("Amount"));
        payment.setPaymentMethod(rs.getString("PaymentMethod"));

        Timestamp paymentDate = rs.getTimestamp("PaymentDate");
        if (paymentDate != null) {
            payment.setPaymentDate(paymentDate.toInstant());
        }

        payment.setTransactionId(rs.getString("TransactionId"));
        payment.setStatus(rs.getString("Status"));

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            payment.setCreatedAt(createdAt.toInstant());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            payment.setUpdatedAt(updatedAt.toInstant());
        }

        payment.setPaymentData(rs.getString("PaymentData"));
        payment.setCallbackData(rs.getString("CallbackData"));

        // Tạo MemberPackage nếu có
        int memberPackageId = rs.getInt("MemberPackageId");
        if (!rs.wasNull()) {
            MemberPackage memberPackage = new MemberPackage();
            memberPackage.setId(memberPackageId);
            payment.setMemberPackage(memberPackage);
        }

        return payment;
    }
}
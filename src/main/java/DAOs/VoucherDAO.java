package DAOs;

import Models.Voucher;
import Models.User;
import DbConnection.DbConnection;

import java.sql.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT v.*, u.UserId, u.UserName, u.Email FROM Vouchers v " +
                "LEFT JOIN Users u ON v.MemberId = u.UserId ORDER BY v.VoucherId";

        try (Connection conn = DbConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Voucher voucher = mapResultSetToVoucher(rs);
                vouchers.add(voucher);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    public Voucher getVoucherById(int id) {
        String sql = "SELECT v.*, u.UserId, u.UserName, u.Email FROM Vouchers v " +
                "LEFT JOIN Users u ON v.MemberId = u.UserId WHERE v.VoucherId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVoucher(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Voucher getVoucherByCode(String code) {
        String sql = "SELECT v.*, u.UserId, u.UserName, u.Email FROM Vouchers v " +
                "LEFT JOIN Users u ON v.MemberId = u.UserId WHERE v.Code = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVoucher(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void saveVoucher(Voucher voucher) {
        String sql = "INSERT INTO Vouchers (Code, DiscountValue, DiscountType, MinPurchase, " +
                "ExpiryDate, MemberId, CreatedAt, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, voucher.getCode());
            stmt.setBigDecimal(2, voucher.getDiscountValue());
            stmt.setString(3, voucher.getDiscountType());

            if (voucher.getMinPurchase() != null) {
                stmt.setBigDecimal(4, voucher.getMinPurchase());
            } else {
                stmt.setNull(4, Types.DECIMAL);
            }

            stmt.setDate(5, Date.valueOf(voucher.getExpiryDate()));

            if (voucher.getMember() != null) {
                stmt.setInt(6, voucher.getMember().getId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }

            if (voucher.getCreatedAt() == null) {
                voucher.setCreatedAt(Instant.now());
            }
            stmt.setTimestamp(7, Timestamp.from(voucher.getCreatedAt()));
            stmt.setString(8, voucher.getStatus());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error saving voucher", e);
        }
    }

    public void updateVoucher(Voucher voucher) {
        String sql = "UPDATE Vouchers SET Code = ?, DiscountValue = ?, DiscountType = ?, " +
                "MinPurchase = ?, ExpiryDate = ?, MemberId = ?, UpdatedAt = ?, Status = ? " +
                "WHERE VoucherId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, voucher.getCode());
            stmt.setBigDecimal(2, voucher.getDiscountValue());
            stmt.setString(3, voucher.getDiscountType());

            if (voucher.getMinPurchase() != null) {
                stmt.setBigDecimal(4, voucher.getMinPurchase());
            } else {
                stmt.setNull(4, Types.DECIMAL);
            }

            stmt.setDate(5, Date.valueOf(voucher.getExpiryDate()));

            if (voucher.getMember() != null) {
                stmt.setInt(6, voucher.getMember().getId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }

            voucher.setUpdatedAt(Instant.now());
            stmt.setTimestamp(7, Timestamp.from(voucher.getUpdatedAt()));
            stmt.setString(8, voucher.getStatus());
            stmt.setInt(9, voucher.getId());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating voucher", e);
        }
    }

    public void deleteVoucher(int id) {
        String sql = "DELETE FROM Vouchers WHERE VoucherId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting voucher", e);
        }
    }

    // Helper method to map ResultSet to Voucher object
    private Voucher mapResultSetToVoucher(ResultSet rs) throws SQLException {
        Voucher voucher = new Voucher();
        voucher.setId(rs.getInt("VoucherId"));
        voucher.setCode(rs.getString("Code"));
        voucher.setDiscountValue(rs.getBigDecimal("DiscountValue"));
        voucher.setDiscountType(rs.getString("DiscountType"));

        BigDecimal minPurchase = rs.getBigDecimal("MinPurchase");
        if (rs.wasNull()) {
            voucher.setMinPurchase(null);
        } else {
            voucher.setMinPurchase(minPurchase);
        }

        Date expiryDate = rs.getDate("ExpiryDate");
        if (expiryDate != null) {
            voucher.setExpiryDate(expiryDate.toLocalDate());
        }

        int memberId = rs.getInt("MemberId");
        if (!rs.wasNull()) {
            User member = new User();
            member.setId(memberId);
            // Add basic user info if available in the result set
            try {
                member.setUserName(rs.getString("UserName"));
                member.setEmail(rs.getString("Email"));
            } catch (SQLException e) {
                // Column not found, ignore
            }
            voucher.setMember(member);
        }

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            voucher.setCreatedAt(createdAt.toInstant());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            voucher.setUpdatedAt(updatedAt.toInstant());
        }

        voucher.setStatus(rs.getString("Status"));
        return voucher;
    }
}
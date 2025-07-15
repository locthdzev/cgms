package DAOs;

import DbConnection.DbConnection;
import Models.MemberPackage;
import Models.MemberPurchaseHistory;
import Models.Payment;
import Models.User;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MemberPurchaseHistoryDAO {

    public boolean createPurchaseHistory(MemberPackage memberPackage, Payment payment) {
        String sql = "INSERT INTO Member_Purchase_History (MemberId, MemberPackageId, PurchaseType, PurchaseAmount, PurchaseDate, Status, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            stmt.setInt(1, memberPackage.getMember().getId());
            stmt.setInt(2, memberPackage.getId());
            stmt.setString(3, "PACKAGE");
            stmt.setBigDecimal(4, payment.getAmount());
            stmt.setDate(5, java.sql.Date.valueOf(LocalDate.now()));
            stmt.setString(6, "COMPLETED");
            stmt.setTimestamp(7, Timestamp.from(Instant.now()));

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
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

    public List<MemberPurchaseHistory> getPurchaseHistoryByMemberId(int memberId) {
        String sql = "SELECT mph.*, mp.*, u.* FROM Member_Purchase_History mph "
                + "LEFT JOIN Member_Packages mp ON mph.MemberPackageId = mp.MemberPackageId "
                + "LEFT JOIN Users u ON mph.MemberId = u.UserId "
                + "WHERE mph.MemberId = ? ORDER BY mph.CreatedAt DESC";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<MemberPurchaseHistory> purchaseHistoryList = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                MemberPurchaseHistory history = new MemberPurchaseHistory();
                history.setId(rs.getInt("PurchaseId"));

                User member = new User();
                member.setId(rs.getInt("MemberId"));
                history.setMember(member);

                MemberPackage memberPackage = new MemberPackage();
                memberPackage.setId(rs.getInt("MemberPackageId"));
                history.setMemberPackage(memberPackage);

                history.setPurchaseType(rs.getString("PurchaseType"));
                history.setPurchaseAmount(rs.getBigDecimal("PurchaseAmount"));
                history.setPurchaseDate(rs.getDate("PurchaseDate").toLocalDate());
                history.setStatus(rs.getString("Status"));
                history.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());

                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
                if (updatedAt != null) {
                    history.setUpdatedAt(updatedAt.toInstant());
                }

                purchaseHistoryList.add(history);
            }

            return purchaseHistoryList;
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
}
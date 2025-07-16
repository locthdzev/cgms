package DAOs;

import DbConnection.DbConnection;
import Models.MemberPackage;
import Models.Package;
import Models.User;
import Models.Voucher;
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

public class MemberPackageDAO {

    public MemberPackage getMemberPackageById(int memberPackageId) {
        String sql = "SELECT mp.*, p.*, v.*, u.UserId, u.UserName, u.Email FROM Member_Packages mp "
                + "LEFT JOIN Packages p ON mp.PackageId = p.PackageId "
                + "LEFT JOIN Vouchers v ON mp.VoucherId = v.VoucherId "
                + "LEFT JOIN Users u ON mp.MemberId = u.UserId "
                + "WHERE mp.MemberPackageId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberPackageId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapMemberPackage(rs);
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

    public List<MemberPackage> getMemberPackagesByMemberId(int memberId) {
        String sql = "SELECT mp.*, p.*, v.*, u.UserId, u.UserName, u.Email FROM Member_Packages mp "
                + "LEFT JOIN Packages p ON mp.PackageId = p.PackageId "
                + "LEFT JOIN Vouchers v ON mp.VoucherId = v.VoucherId "
                + "LEFT JOIN Users u ON mp.MemberId = u.UserId "
                + "WHERE mp.MemberId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<MemberPackage> memberPackages = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                memberPackages.add(mapMemberPackage(rs));
            }

            return memberPackages;
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

    public List<MemberPackage> getActiveMemberPackages() {
        String sql = "SELECT mp.*, p.*, v.*, u.UserId, u.UserName, u.Email FROM Member_Packages mp "
                + "LEFT JOIN Packages p ON mp.PackageId = p.PackageId "
                + "LEFT JOIN Vouchers v ON mp.VoucherId = v.VoucherId "
                + "LEFT JOIN Users u ON mp.MemberId = u.UserId "
                + "WHERE mp.Status = 'ACTIVE' AND mp.EndDate >= ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<MemberPackage> memberPackages = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            rs = stmt.executeQuery();

            while (rs.next()) {
                memberPackages.add(mapMemberPackage(rs));
            }

            return memberPackages;
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

    public boolean updateMemberPackage(MemberPackage memberPackage) {
        String sql = "UPDATE Member_Packages SET VoucherId = ?, TotalPrice = ?, StartDate = ?, EndDate = ?, "
                + "RemainingSessions = ?, Status = ?, UpdatedAt = ? WHERE MemberPackageId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);

            if (memberPackage.getVoucher() != null) {
                stmt.setInt(1, memberPackage.getVoucher().getId());
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }

            stmt.setBigDecimal(2, memberPackage.getTotalPrice());
            stmt.setDate(3, java.sql.Date.valueOf(memberPackage.getStartDate()));
            stmt.setDate(4, java.sql.Date.valueOf(memberPackage.getEndDate()));

            if (memberPackage.getRemainingSessions() != null) {
                stmt.setInt(5, memberPackage.getRemainingSessions());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }

            stmt.setString(6, memberPackage.getStatus());
            stmt.setTimestamp(7, Timestamp.from(Instant.now()));
            stmt.setInt(8, memberPackage.getId());

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

    public boolean updateMemberPackageStatus(int memberPackageId, String status) {
        String sql = "UPDATE Member_Packages SET Status = ?, UpdatedAt = ? WHERE MemberPackageId = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);

            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.from(Instant.now()));
            stmt.setInt(3, memberPackageId);

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

    public int createMemberPackage(MemberPackage memberPackage) {
        String sql = "INSERT INTO Member_Packages (MemberId, PackageId, VoucherId, TotalPrice, StartDate, EndDate, "
                + "RemainingSessions, CreatedAt, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            stmt.setInt(1, memberPackage.getMember().getId());
            stmt.setInt(2, memberPackage.getPackageField().getId());

            if (memberPackage.getVoucher() != null) {
                stmt.setInt(3, memberPackage.getVoucher().getId());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }

            stmt.setBigDecimal(4, memberPackage.getTotalPrice());
            stmt.setDate(5, java.sql.Date.valueOf(memberPackage.getStartDate()));
            stmt.setDate(6, java.sql.Date.valueOf(memberPackage.getEndDate()));

            if (memberPackage.getRemainingSessions() != null) {
                stmt.setInt(7, memberPackage.getRemainingSessions());
            } else {
                stmt.setNull(7, java.sql.Types.INTEGER);
            }

            stmt.setTimestamp(8, Timestamp.from(Instant.now()));
            stmt.setString(9, memberPackage.getStatus());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return -1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
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

    public List<User> getActiveMembersWithPackage() {
        List<User> members = new ArrayList<>();
        String sql = "SELECT DISTINCT u.* FROM Users u " +
                "JOIN Member_Packages mp ON u.UserId = mp.MemberId " +
                "WHERE mp.EndDate >= ? AND mp.Status = 'ACTIVE' AND u.Role = 'Member'";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            rs = stmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("UserId"));
                user.setEmail(rs.getString("Email"));
                user.setUserName(rs.getString("UserName"));
                user.setFullName(rs.getString("FullName"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setGender(rs.getString("Gender"));

                java.sql.Date dob = rs.getDate("DOB");
                if (dob != null) {
                    user.setDob(dob.toLocalDate());
                }

                user.setRole(rs.getString("Role"));
                user.setStatus(rs.getString("Status"));

                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                if (createdAt != null) {
                    user.setCreatedAt(createdAt.toInstant());
                }

                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
                if (updatedAt != null) {
                    user.setUpdatedAt(updatedAt.toInstant());
                }

                members.add(user);
            }

            return members;
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

    public List<MemberPackage> getPendingMemberPackagesByMemberId(int memberId) {
        String sql = "SELECT mp.*, p.*, v.*, u.UserId, u.UserName, u.Email FROM Member_Packages mp "
                + "LEFT JOIN Packages p ON mp.PackageId = p.PackageId "
                + "LEFT JOIN Vouchers v ON mp.VoucherId = v.VoucherId "
                + "LEFT JOIN Users u ON mp.MemberId = u.UserId "
                + "WHERE mp.MemberId = ? AND mp.Status = 'PENDING'";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<MemberPackage> memberPackages = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                memberPackages.add(mapMemberPackage(rs));
            }

            return memberPackages;
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

    private MemberPackage mapMemberPackage(ResultSet rs) throws SQLException {
        MemberPackage memberPackage = new MemberPackage();
        memberPackage.setId(rs.getInt("MemberPackageId"));
        memberPackage.setTotalPrice(rs.getBigDecimal("TotalPrice"));
        memberPackage.setStartDate(rs.getDate("StartDate").toLocalDate());
        memberPackage.setEndDate(rs.getDate("EndDate").toLocalDate());
        memberPackage.setRemainingSessions(rs.getInt("RemainingSessions"));
        memberPackage.setStatus(rs.getString("Status"));

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            memberPackage.setCreatedAt(createdAt.toInstant());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            memberPackage.setUpdatedAt(updatedAt.toInstant());
        }

        // Tạo User (member)
        int memberId = rs.getInt("MemberId");
        if (!rs.wasNull()) {
            User member = new User();
            member.setId(memberId);
            member.setUserName(rs.getString("UserName"));
            member.setEmail(rs.getString("Email"));
            memberPackage.setMember(member);
        }

        // Tạo Package
        int packageId = rs.getInt("PackageId");
        if (!rs.wasNull()) {
            Package packageField = new Package();
            packageField.setId(packageId);
            packageField.setName(rs.getString("Name"));
            packageField.setPrice(rs.getBigDecimal("Price"));
            packageField.setDuration(rs.getInt("Duration"));
            packageField.setSessions(rs.getInt("Sessions"));
            memberPackage.setPackageField(packageField);
        }

        // Tạo Voucher nếu có
        int voucherId = rs.getInt("VoucherId");
        if (!rs.wasNull()) {
            Voucher voucher = new Voucher();
            voucher.setId(voucherId);
            voucher.setCode(rs.getString("Code"));
            voucher.setDiscountValue(rs.getBigDecimal("DiscountValue"));
            voucher.setDiscountType(rs.getString("DiscountType"));
            memberPackage.setVoucher(voucher);
        }

        return memberPackage;
    }
}

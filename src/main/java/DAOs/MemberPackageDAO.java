package DAOs;

import Models.User;
import Models.MemberPackage;
import Models.Package;
import Models.Voucher;
import DbConnection.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;

public class MemberPackageDAO {
    public List<User> getActiveMembersWithPackage() {
        List<User> members = new ArrayList<>();
        String sql = "SELECT DISTINCT u.* FROM Users u " +
                "JOIN Member_Packages mp ON u.UserId = mp.MemberId " +
                "WHERE mp.EndDate >= ? AND mp.Status = 'Active' AND u.Role = 'Member'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(LocalDate.now()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("UserId"));
                user.setEmail(rs.getString("Email"));
                user.setUserName(rs.getString("UserName"));
                user.setFullName(rs.getString("FullName"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setGender(rs.getString("Gender"));
                user.setDob(rs.getDate("DOB") != null ? rs.getDate("DOB").toLocalDate() : null);
                user.setRole(rs.getString("Role"));
                user.setStatus(rs.getString("Status"));
                user.setCreatedAt(
                        rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toInstant() : null);
                user.setUpdatedAt(
                        rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toInstant() : null);
                members.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return members;
    }

    /**
     * Lấy danh sách gói tập của một member theo ID
     * 
     * @param memberId ID của member
     * @return Danh sách các gói tập đã đăng ký
     */
    public List<MemberPackage> getMemberPackagesByUserId(Integer memberId) {
        List<MemberPackage> memberPackages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            String sql = "SELECT mp.*, p.*, v.* FROM Member_Packages mp " +
                    "LEFT JOIN Packages p ON mp.PackageId = p.PackageId " +
                    "LEFT JOIN Vouchers v ON mp.VoucherId = v.VoucherId " +
                    "WHERE mp.MemberId = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                MemberPackage memberPackage = new MemberPackage();
                memberPackage.setId(rs.getInt("MemberPackageId"));

                // Tạo đối tượng User cho member
                User member = new User();
                member.setId(memberId);
                memberPackage.setMember(member);

                // Tạo đối tượng Package
                Package pkg = new Package();
                pkg.setId(rs.getInt("PackageId"));
                pkg.setName(rs.getString("Name"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));
                pkg.setSessions(rs.getObject("Sessions") != null ? rs.getInt("Sessions") : null);
                pkg.setDescription(rs.getString("Description"));
                memberPackage.setPackageField(pkg);

                // Xử lý Voucher nếu có
                if (rs.getObject("VoucherId") != null) {
                    Voucher voucher = new Voucher();
                    voucher.setId(rs.getInt("VoucherId"));
                    voucher.setCode(rs.getString("Code"));
                    voucher.setDiscountValue(rs.getBigDecimal("Discount"));
                    memberPackage.setVoucher(voucher);
                }

                memberPackage.setTotalPrice(rs.getBigDecimal("TotalPrice"));
                memberPackage
                        .setStartDate(rs.getDate("StartDate") != null ? rs.getDate("StartDate").toLocalDate() : null);
                memberPackage.setEndDate(rs.getDate("EndDate") != null ? rs.getDate("EndDate").toLocalDate() : null);
                memberPackage.setRemainingSessions(
                        rs.getObject("RemainingSessions") != null ? rs.getInt("RemainingSessions") : null);
                memberPackage.setCreatedAt(
                        rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toInstant() : null);
                memberPackage.setUpdatedAt(
                        rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toInstant() : null);
                memberPackage.setStatus(rs.getString("Status"));

                memberPackages.add(memberPackage);
            }
        } catch (Exception e) {
            e.printStackTrace();
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

        return memberPackages;
    }

    /**
     * Tạo một gói tập mới cho member
     * 
     * @param memberPackage Đối tượng MemberPackage chứa thông tin gói tập
     * @return true nếu tạo thành công, false nếu thất bại
     */
    public boolean createMemberPackage(MemberPackage memberPackage) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnection.getConnection();

            // Lấy thông tin gói tập
            PackageDAO packageDAO = new PackageDAO();
            Package pkg = packageDAO.getPackageById(memberPackage.getPackageField().getId());

            // Tính toán ngày bắt đầu và kết thúc
            LocalDate startDate = LocalDate.now();
            LocalDate endDate = startDate.plusDays(pkg.getDuration());

            // Tính toán số buổi còn lại
            Integer remainingSessions = pkg.getSessions();

            String sql = "INSERT INTO Member_Packages (MemberId, PackageId, VoucherId, TotalPrice, StartDate, EndDate, RemainingSessions, CreatedAt, Status) "
                    +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberPackage.getMember().getId());
            stmt.setInt(2, memberPackage.getPackageField().getId());

            // Xử lý voucher nếu có
            if (memberPackage.getVoucher() != null) {
                stmt.setInt(3, memberPackage.getVoucher().getId());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }

            // Tính giá tiền sau khi áp dụng voucher nếu có
            BigDecimal totalPrice = pkg.getPrice();
            if (memberPackage.getVoucher() != null) {
                // Giả sử voucher là giảm giá theo phần trăm
                BigDecimal discount = memberPackage.getVoucher().getDiscountValue();
                totalPrice = totalPrice.subtract(totalPrice.multiply(discount).divide(new BigDecimal(100)));
            }

            stmt.setBigDecimal(4, totalPrice);
            stmt.setDate(5, java.sql.Date.valueOf(startDate));
            stmt.setDate(6, java.sql.Date.valueOf(endDate));

            if (remainingSessions != null) {
                stmt.setInt(7, remainingSessions);
            } else {
                stmt.setNull(7, java.sql.Types.INTEGER);
            }

            stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            stmt.setString(9, "Active");

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

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
}

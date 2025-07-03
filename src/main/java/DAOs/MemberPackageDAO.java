package DAOs;

import Models.User;
import DbConnection.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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
}

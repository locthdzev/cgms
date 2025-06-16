package DAOs;

import Models.User;
import java.sql.*;
import DbConnection.DbConnection;

public class UserDAO {
    public User getUserByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE UserName = ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("UserId"));
                user.setUserName(rs.getString("UserName"));
                user.setPassword(rs.getString("Password"));
                user.setSalt(rs.getString("Salt"));
                user.setRole(rs.getString("Role"));
                // ... set các trường khác nếu cần ...
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean createUser(User user) {
        String sql = "INSERT INTO Users (Email, Password, Salt, UserName, GoogleId, Role, FullName, PhoneNumber, Address, Gender, DOB, LevelId, CreatedAt, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getSalt());
            ps.setString(4, user.getUserName());
            ps.setString(5, user.getGoogleId());
            ps.setString(6, user.getRole());
            ps.setString(7, user.getFullName());
            ps.setString(8, user.getPhoneNumber());
            ps.setString(9, user.getAddress());
            ps.setString(10, user.getGender());
            // DOB
            if (user.getDob() != null) {
                ps.setDate(11, java.sql.Date.valueOf(user.getDob()));
            } else {
                ps.setNull(11, java.sql.Types.DATE);
            }
            ps.setInt(12, user.getLevel().getId());
            // CreatedAt
            if (user.getCreatedAt() != null) {
                ps.setTimestamp(13, java.sql.Timestamp.from(user.getCreatedAt()));
            } else {
                ps.setNull(13, java.sql.Types.TIMESTAMP);
            }
            ps.setString(14, user.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean activateUserByEmail(String email) {
        String sql = "UPDATE Users SET Status = 'Active' WHERE Email = ? AND Status = 'Pending'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateGoogleIdByEmail(String email, String googleId) {
        String sql = "UPDATE Users SET GoogleId = ? WHERE Email = ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, googleId);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
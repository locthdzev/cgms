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

    public User getUserByGoogleId(String googleId) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE GoogleId = ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, googleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("UserId"));
                user.setUserName(rs.getString("UserName"));
                user.setEmail(rs.getString("Email"));
                user.setPassword(rs.getString("Password"));
                user.setSalt(rs.getString("Salt"));
                user.setGoogleId(rs.getString("GoogleId"));
                user.setRole(rs.getString("Role"));
                user.setFullName(rs.getString("FullName"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setGender(rs.getString("Gender"));
                if (rs.getDate("DOB") != null) {
                    user.setDob(rs.getDate("DOB").toLocalDate());
                }
                user.setStatus(rs.getString("Status"));
                // Set other fields as needed
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public User getUserByEmail(String email) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("UserId"));
                user.setUserName(rs.getString("UserName"));
                user.setEmail(rs.getString("Email"));
                user.setPassword(rs.getString("Password"));
                user.setSalt(rs.getString("Salt"));
                user.setGoogleId(rs.getString("GoogleId"));
                user.setRole(rs.getString("Role"));
                user.setFullName(rs.getString("FullName"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setGender(rs.getString("Gender"));
                if (rs.getDate("DOB") != null) {
                    user.setDob(rs.getDate("DOB").toLocalDate());
                }
                user.setStatus(rs.getString("Status"));
                // Set other fields as needed
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public java.util.List<User> getAllUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
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
                // ... set các trường khác nếu cần ...
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE UserId = ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
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
                // ... set các trường khác nếu cần ...
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET Email=?, UserName=?, FullName=?, PhoneNumber=?, Address=?, Gender=?, DOB=?, Role=?, Status=?, UpdatedAt=? WHERE UserId=?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getUserName());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getGender());
            if (user.getDob() != null) {
                ps.setDate(7, java.sql.Date.valueOf(user.getDob()));
            } else {
                ps.setNull(7, java.sql.Types.DATE);
            }
            ps.setString(8, user.getRole());
            ps.setString(9, user.getStatus());
            ps.setTimestamp(10, user.getUpdatedAt() != null ? java.sql.Timestamp.from(user.getUpdatedAt())
                    : new java.sql.Timestamp(System.currentTimeMillis()));
            ps.setInt(11, user.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE Users SET Status = ?, UpdatedAt = ? WHERE UserId = ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
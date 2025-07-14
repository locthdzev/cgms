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
                user.setZalo(rs.getString("Zalo"));
                user.setFacebook(rs.getString("Facebook"));
                user.setExperience(rs.getString("Experience"));
                user.setStatus(rs.getString("Status"));
                user.setCertificateImageUrl(rs.getString("CertificateImageUrl"));
                // ... set các trường khác nếu cần ...
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean createUser(User user) {
        String sql = "INSERT INTO Users (Email, Password, Salt, UserName, GoogleId, Role, FullName, PhoneNumber, Address, Gender, DOB, Zalo, Facebook, Experience, LevelId, CreatedAt, Status, CertificateImageUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            // Zalo
            ps.setString(12, user.getZalo());
            // Facebook
            ps.setString(13, user.getFacebook());
            // Experience
            ps.setString(14, user.getExperience());
            // LevelId - Handle null level
            if (user.getLevel() != null) {
                ps.setInt(15, user.getLevel().getId());
            } else {
                // Set default level ID (1) if level is null
                ps.setInt(15, 1);
            }
            // CreatedAt
            if (user.getCreatedAt() != null) {
                ps.setTimestamp(16, java.sql.Timestamp.from(user.getCreatedAt()));
            } else {
                ps.setNull(16, java.sql.Types.TIMESTAMP);
            }
            ps.setString(17, user.getStatus());
            // CertificateImageUrl
            ps.setString(18, user.getCertificateImageUrl());

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
                user.setZalo(rs.getString("Zalo"));
                user.setFacebook(rs.getString("Facebook"));
                user.setExperience(rs.getString("Experience"));
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
                user.setZalo(rs.getString("Zalo"));
                user.setFacebook(rs.getString("Facebook"));
                user.setExperience(rs.getString("Experience"));
                user.setStatus(rs.getString("Status"));
                user.setCertificateImageUrl(rs.getString("CertificateImageUrl"));
                // ... set các trường khác nếu cần ...
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
                user.setZalo(rs.getString("Zalo"));
                user.setFacebook(rs.getString("Facebook"));
                user.setExperience(rs.getString("Experience"));
                user.setRole(rs.getString("Role"));
                user.setStatus(rs.getString("Status"));
                user.setCertificateImageUrl(rs.getString("CertificateImageUrl"));
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
        User user = null;
        String sql = "SELECT * FROM Users WHERE UserId = ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
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
                user.setZalo(rs.getString("Zalo"));
                user.setFacebook(rs.getString("Facebook"));
                user.setExperience(rs.getString("Experience"));
                user.setStatus(rs.getString("Status"));
                user.setCertificateImageUrl(rs.getString("CertificateImageUrl"));
                user.setCreatedAt(
                        rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toInstant() : null);
                user.setUpdatedAt(
                        rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toInstant() : null);
                // ... set các trường khác nếu cần ...
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET Email=?, UserName=?, Password=?, Salt=?, FullName=?, PhoneNumber=?, Address=?, Gender=?, DOB=?, Zalo=?, Facebook=?, Experience=?, Role=?, Status=?, UpdatedAt=?, CertificateImageUrl=? WHERE UserId=?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getUserName());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getSalt());
            ps.setString(5, user.getFullName());
            ps.setString(6, user.getPhoneNumber());
            ps.setString(7, user.getAddress());
            ps.setString(8, user.getGender());
            if (user.getDob() != null) {
                ps.setDate(9, java.sql.Date.valueOf(user.getDob()));
            } else {
                ps.setNull(9, java.sql.Types.DATE);
            }
            ps.setString(10, user.getZalo());
            ps.setString(11, user.getFacebook());
            ps.setString(12, user.getExperience());
            ps.setString(13, user.getRole());
            ps.setString(14, user.getStatus());
            if (user.getUpdatedAt() != null) {
                ps.setTimestamp(15, java.sql.Timestamp.from(user.getUpdatedAt()));
            } else {
                ps.setTimestamp(15, java.sql.Timestamp.from(java.time.Instant.now()));
            }
            ps.setString(16, user.getCertificateImageUrl());
            ps.setInt(17, user.getId());
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
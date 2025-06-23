package DAOs;

import Models.PasswordResetToken;
import Models.User;
import java.sql.*;
import java.time.Instant;
import DbConnection.DbConnection;

public class PasswordResetTokenDAO {

    public boolean createToken(PasswordResetToken token) {
        String sql = "INSERT INTO PasswordResetTokens (UserId, Token, ExpiryDate, CreatedAt, Status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, token.getUser().getId());
            ps.setString(2, token.getToken());
            ps.setTimestamp(3, java.sql.Timestamp.from(token.getExpiryDate()));
            ps.setTimestamp(4, java.sql.Timestamp.from(token.getCreatedAt()));
            ps.setString(5, token.getStatus());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    token.setId(generatedKeys.getInt(1));
                    return true;
                } else {
                    return false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public PasswordResetToken getTokenByTokenString(String tokenString) {
        String sql = "SELECT prt.*, u.* FROM PasswordResetTokens prt " +
                "JOIN Users u ON prt.UserId = u.UserId " +
                "WHERE prt.Token = ? AND prt.Status = 'Active'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tokenString);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PasswordResetToken token = new PasswordResetToken();
                token.setId(rs.getInt("TokenId"));
                token.setToken(rs.getString("Token"));
                token.setExpiryDate(rs.getTimestamp("ExpiryDate").toInstant());
                token.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                token.setStatus(rs.getString("Status"));

                User user = new User();
                user.setId(rs.getInt("UserId"));
                user.setUserName(rs.getString("UserName"));
                user.setEmail(rs.getString("Email"));
                user.setRole(rs.getString("Role"));
                user.setFullName(rs.getString("FullName"));

                token.setUser(user);
                return token;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean invalidateToken(String tokenString) {
        String sql = "UPDATE PasswordResetTokens SET Status = 'Used' WHERE Token = ? AND Status = 'Active'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tokenString);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean invalidateAllUserTokens(int userId) {
        String sql = "UPDATE PasswordResetTokens SET Status = 'Expired' WHERE UserId = ? AND Status = 'Active'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isTokenValid(String tokenString) {
        String sql = "SELECT * FROM PasswordResetTokens WHERE Token = ? AND Status = 'Active' AND ExpiryDate > ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tokenString);
            ps.setTimestamp(2, java.sql.Timestamp.from(Instant.now()));
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
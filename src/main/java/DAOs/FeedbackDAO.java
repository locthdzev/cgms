package DAOs;

import Models.Feedback;
import DbConnection.DbConnection;
import Models.User;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    // Retrieve all feedbacks, ordered by CreatedAt
    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String query = "SELECT f.*, u.UserName, u.FullName, u.Email "
                + "FROM Feedbacks f "
                + "LEFT JOIN Users u ON f.UserId = u.UserId "
                + "ORDER BY f.CreatedAt DESC";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = mapResultSetWithUser(rs);
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Delete a feedback by its ID
    public boolean deleteFeedbackById(int feedbackId) {
        String query = "DELETE FROM Feedbacks WHERE FeedbackId = ?";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, feedbackId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Create new feedback
    public boolean createFeedback(Feedback fb) {
        String sql = "INSERT INTO Feedbacks(UserId, GuestEmail, Content, CreatedAt, Status) "
                + "VALUES(?, ?, ?, ?, ?)";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            System.out.println("DEBUG - Creating feedback in DB");
            System.out.println("DEBUG - SQL: " + sql);

            // Set UserId - handle null user
            if (fb.getUser() != null) {
                ps.setInt(1, fb.getUser().getId());
                System.out.println("DEBUG - UserId set: " + fb.getUser().getId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
                System.out.println("DEBUG - UserId set to NULL");
            }

            ps.setString(2, fb.getGuestEmail());
            ps.setString(3, fb.getContent());
            ps.setTimestamp(4, Timestamp.from(Instant.now()));
            ps.setString(5, "Pending");

            System.out.println("DEBUG - GuestEmail: " + fb.getGuestEmail());
            System.out.println("DEBUG - Content: " + fb.getContent());

            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG - Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("DEBUG - Exception in createFeedback: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get feedbacks by user ID with full user info
    public List<Feedback> getFeedbacksByUser(int userId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.FeedbackId, f.UserId, f.GuestEmail, f.Content, f.Response, "
                + "f.CreatedAt, f.RespondedAt, f.Status, "
                + "u.UserName, u.FullName, u.Email "
                + "FROM Feedbacks f "
                + "LEFT JOIN Users u ON f.UserId = u.UserId "
                + "WHERE f.UserId = ? ORDER BY f.CreatedAt DESC";

        System.out.println("=== FeedbackDAO.getFeedbacksByUser ===");
        System.out.println("DEBUG - SQL: " + sql);
        System.out.println("DEBUG - UserId parameter: " + userId);

        try (Connection con = DbConnection.getConnection()) {
            System.out.println("DEBUG - Database connection: " + (con != null ? "SUCCESS" : "FAILED"));

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);

                System.out.println("DEBUG - Executing query...");
                ResultSet rs = ps.executeQuery();

                int count = 0;
                while (rs.next()) {
                    count++;
                    System.out.println("DEBUG - Processing row " + count);

                    // Debug từng field
                    System.out.println("  - FeedbackId: " + rs.getInt("FeedbackId"));
                    System.out.println("  - UserId: " + rs.getInt("UserId"));
                    System.out.println("  - Content: " + rs.getString("Content"));
                    System.out.println("  - Status: " + rs.getString("Status"));

                    Feedback fb = mapResultSetWithUser(rs);
                    list.add(fb);
                }

                System.out.println("DEBUG - Total rows processed: " + count);
                System.out.println("DEBUG - List size: " + list.size());
            }

        } catch (Exception e) {
            System.out.println("DEBUG - Exception in getFeedbacksByUser: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // Respond to feedback and update its status
    public boolean respondFeedback(int feedbackId, String response) {
        String sql = "UPDATE Feedbacks SET Response = ?, RespondedAt = ?, Status = 'Responded' WHERE FeedbackId = ?";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, response);
            ps.setTimestamp(2, Timestamp.from(Instant.now()));  
            ps.setInt(3, feedbackId);  
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Feedback mapResultSetWithUser(ResultSet rs) throws SQLException {
        Feedback fb = new Feedback();

        try {
            fb.setId(rs.getInt("FeedbackId"));
            System.out.println("DEBUG - FeedbackId: " + rs.getInt("FeedbackId"));

            User u = new User();
            u.setId(rs.getInt("UserId"));
            u.setUserName(rs.getString("UserName"));
            u.setFullName(rs.getString("FullName"));
            u.setEmail(rs.getString("Email"));
            fb.setUser(u);

            System.out.println("DEBUG - UserId: " + rs.getInt("UserId"));
            System.out.println("DEBUG - UserName: " + rs.getString("UserName"));

            fb.setGuestEmail(rs.getString("GuestEmail"));
            fb.setContent(rs.getString("Content"));
            fb.setResponse(rs.getString("Response"));

            // Handle timestamps safely
            Timestamp createdAt = rs.getTimestamp("CreatedAt");
            if (createdAt != null) {
                fb.setCreatedAt(createdAt.toInstant());
            }

            Timestamp respondedAt = rs.getTimestamp("RespondedAt");
            if (respondedAt != null) {
                fb.setRespondedAt(respondedAt.toInstant());
            }

            fb.setStatus(rs.getString("Status"));

            System.out.println("DEBUG - Content: " + rs.getString("Content"));
            System.out.println("DEBUG - Status: " + rs.getString("Status"));

        } catch (SQLException e) {
            System.out.println("DEBUG - Error mapping row: " + e.getMessage());
            throw e;
        }

        return fb;
    }

    private Feedback mapResultSet(ResultSet rs) throws SQLException {
        Feedback fb = new Feedback();
        fb.setId(rs.getInt("FeedbackId"));

        User u = new User();
        u.setId(rs.getInt("UserId"));
        fb.setUser(u);

        fb.setGuestEmail(rs.getString("GuestEmail"));
        fb.setContent(rs.getString("Content"));
        fb.setResponse(rs.getString("Response"));
        fb.setCreatedAt(rs.getTimestamp("CreatedAt") != null
                ? rs.getTimestamp("CreatedAt").toInstant() : null);
        fb.setRespondedAt(rs.getTimestamp("RespondedAt") != null
                ? rs.getTimestamp("RespondedAt").toInstant() : null);
        fb.setStatus(rs.getString("Status"));
        return fb;
    }

    public boolean hasSentGeneralFeedback(int userId) {
        String sql = "SELECT COUNT(*) FROM Feedbacks WHERE UserId = ? AND Content NOT LIKE ?";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, "Feedback cho buổi tập #%");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasSentScheduleFeedback(int userId, int scheduleId) {
        String sql = "SELECT COUNT(*) FROM Feedbacks WHERE UserId = ? AND Content LIKE ?";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, "Feedback cho buổi tập #" + scheduleId + "%");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}

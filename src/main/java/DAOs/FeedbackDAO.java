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
        String query = "SELECT * FROM Feedbacks ORDER BY CreatedAt DESC";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = mapResultSet(rs);
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
            ps.setInt(1, fb.getUser().getId());  // Set UserId
            ps.setString(2, fb.getGuestEmail()); // Set GuestEmail
            ps.setString(3, fb.getContent());    // Set Content
            ps.setTimestamp(4, Timestamp.from(Instant.now())); // Set CreatedAt
            ps.setString(5, "Pending");  // Default status is "Pending"
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get feedbacks by user ID (no filtering by type)
    public List<Feedback> getFeedbacksByUser(int userId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedbacks WHERE UserId = ? ORDER BY CreatedAt DESC";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId); // Get feedbacks for a specific user
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = mapResultSet(rs);
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Respond to feedback and update its status
    public boolean respondFeedback(int feedbackId, String response) {
        String sql = "UPDATE Feedbacks SET Response = ?, RespondedAt = ?, Status = 'Responded' WHERE FeedbackId = ?";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, response);
            ps.setTimestamp(2, Timestamp.from(Instant.now()));  // RespondedAt timestamp
            ps.setInt(3, feedbackId);  // FeedbackId to update
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to map the ResultSet to a Feedback object
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
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Feedback;
import DbConnection.DbConnection;
import Models.User;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

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

    public boolean createFeedback(Feedback fb) {
        String sql = "INSERT INTO Feedbacks(UserId, GuestEmail, Content, CreatedAt, Status) "
                + "VALUES(?, ?, ?, ?, ?)";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setObject(1, fb.getUser().getId());            // hoặc ps.setInt nếu bạn sử dụng primitive
            ps.setString(2, fb.getGuestEmail());
            ps.setString(3, fb.getContent());
            ps.setTimestamp(4, Timestamp.from(Instant.now()));
            ps.setString(5, "Pending");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Feedback> getFeedbacksByUser(int userId) {
    List<Feedback> list = new ArrayList<>();
    String sql = "SELECT * FROM Feedbacks WHERE UserId = ? ORDER BY CreatedAt DESC";
    try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, userId); // Truyền đúng userId để chỉ lấy feedback của người đó
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


    public boolean respondFeedback(int feedbackId, String response) {
        String sql = "UPDATE Feedbacks "
                + "SET Response = ?, RespondedAt = ?, Status = 'Responded' "
                + "WHERE FeedbackId = ?";
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
    // Lấy feedback theo loại

    public List<Feedback> getFeedbacksByUserAndType(int userId, String feedbackType) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedbacks WHERE UserId = ? AND FeedbackType = ? ORDER BY CreatedAt DESC";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, feedbackType);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}

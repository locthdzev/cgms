/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Feedback;
import DbConnection.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String query = "SELECT * FROM Feedbacks";
        try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setId(rs.getInt("FeedbackId"));
                fb.setGuestEmail(rs.getString("GuestEmail"));
                fb.setContent(rs.getString("Content"));
                fb.setResponse(rs.getString("Response"));
                fb.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                fb.setRespondedAt(rs.getTimestamp("RespondedAt") != null ? rs.getTimestamp("RespondedAt").toInstant() : null);
                fb.setStatus(rs.getString("Status"));
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

}

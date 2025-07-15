/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Services;

import DAOs.FeedbackDAO;
import Models.Feedback;
import Models.User;

import java.util.List;

public class FeedbackService {

    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    public List<Feedback> getAllFeedbacks() {
        return feedbackDAO.getAllFeedbacks();
    }

    public boolean deleteFeedback(int feedbackId) {
        return feedbackDAO.deleteFeedbackById(feedbackId);
    }

    public boolean sendFeedback(int userId, String guestEmail, String content) {
        Feedback fb = new Feedback();
        User u = new User();
        u.setId(userId);
        fb.setUser(u);
        fb.setGuestEmail(guestEmail);
        fb.setContent(content);
        return feedbackDAO.createFeedback(fb);
    }

    public boolean respondFeedback(int id, String response) {
        return feedbackDAO.respondFeedback(id, response);
    }

    public List<Feedback> getFeedbacksByUser(int userId) {
        return feedbackDAO.getFeedbacksByUser(userId);
    }
    // Lấy feedback theo loại

    public List<Feedback> getFeedbacksByUserAndType(int userId, String feedbackType) {
        return feedbackDAO.getFeedbacksByUserAndType(userId, feedbackType);
    }

}

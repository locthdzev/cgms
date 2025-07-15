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
        Feedback feedback = new Feedback();
        User user = new User();
        user.setId(userId);
        feedback.setUser(user);
        feedback.setGuestEmail(guestEmail);
        feedback.setContent(content);
        return feedbackDAO.createFeedback(feedback);
    }

    public boolean respondFeedback(int feedbackId, String response) {
        return feedbackDAO.respondFeedback(feedbackId, response);
    }

    public List<Feedback> getFeedbacksByUser(int userId) {
        return feedbackDAO.getFeedbacksByUser(userId);
    }
}

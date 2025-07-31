package Services;

import DAOs.FeedbackDAO;
import Models.Feedback;
import Models.User;

import java.util.List;
import java.util.ArrayList;

public class FeedbackService {

    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    public List<Feedback> getAllFeedbacks() {
        return feedbackDAO.getAllFeedbacks();
    }

    public boolean deleteFeedback(int feedbackId) {
        return feedbackDAO.deleteFeedbackById(feedbackId);
    }

    public boolean sendFeedback(int userId, String guestEmail, String content) {
        if (feedbackDAO.hasSentGeneralFeedback(userId)) {
            System.out.println("DEBUG - User đã gửi feedback chung");
            return false;
        }

        Feedback feedback = new Feedback();
        User user = new User();
        user.setId(userId);
        feedback.setUser(user);
        feedback.setGuestEmail(guestEmail);
        feedback.setContent(content);
        feedback.setStatus("Pending");

        return feedbackDAO.createFeedback(feedback);
    }

    public boolean respondFeedback(int feedbackId, String response) {
        return feedbackDAO.respondFeedback(feedbackId, response);
    }
    public boolean hasSentScheduleFeedback(int userId, int scheduleId) {
    return feedbackDAO.hasSentScheduleFeedback(userId, scheduleId);
}


    public List<Feedback> getFeedbacksByUser(int userId) {
        return feedbackDAO.getFeedbacksByUser(userId);
    }

    public boolean sendScheduleFeedback(int userId, String guestEmail, int scheduleId, String content) {
        if (feedbackDAO.hasSentScheduleFeedback(userId, scheduleId)) {
            System.out.println("DEBUG - User đã gửi feedback cho buổi #" + scheduleId);
            return false;
        }

        String enhancedContent = "Feedback cho buổi tập #" + scheduleId + ": " + content;

        Feedback feedback = new Feedback();
        User user = new User();
        user.setId(userId);
        feedback.setUser(user);
        feedback.setGuestEmail(guestEmail);
        feedback.setContent(enhancedContent);
        feedback.setStatus("Pending");

        return feedbackDAO.createFeedback(feedback);
    }
}

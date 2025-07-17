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
        System.out.println("DEBUG - FeedbackService.sendFeedback called");
        System.out.println("DEBUG - UserId: " + userId);
        System.out.println("DEBUG - GuestEmail: " + guestEmail);
        System.out.println("DEBUG - Content: " + content);
        
        Feedback feedback = new Feedback();
        User user = new User();
        user.setId(userId);
        feedback.setUser(user);
        feedback.setGuestEmail(guestEmail);
        feedback.setContent(content);
        feedback.setStatus("Pending");
        
        boolean result = feedbackDAO.createFeedback(feedback);
        System.out.println("DEBUG - Feedback creation result: " + result);
        return result;
    }

    public boolean respondFeedback(int feedbackId, String response) {
        return feedbackDAO.respondFeedback(feedbackId, response);
    }

    public List<Feedback> getFeedbacksByUser(int userId) {
        return feedbackDAO.getFeedbacksByUser(userId);
    }

    public boolean sendScheduleFeedback(int userId, String guestEmail, int scheduleId, String content) {
        try {
            System.out.println("DEBUG - FeedbackService.sendScheduleFeedback called");
            System.out.println("DEBUG - UserId: " + userId);
            System.out.println("DEBUG - ScheduleId: " + scheduleId);
            System.out.println("DEBUG - Content: " + content);
            
            // Add schedule info to content
            String enhancedContent = "Feedback cho buổi tập #" + scheduleId + ": " + content;
            
            Feedback feedback = new Feedback();
            
            // Set user
            User user = new User();
            user.setId(userId);
            feedback.setUser(user);
            
            feedback.setGuestEmail(guestEmail);
            feedback.setContent(enhancedContent);
            feedback.setStatus("Pending");
            
            boolean result = feedbackDAO.createFeedback(feedback);
            System.out.println("DEBUG - Schedule feedback DAO result: " + result);
            return result;
        } catch (Exception e) {
            System.out.println("DEBUG - Exception in sendScheduleFeedback: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

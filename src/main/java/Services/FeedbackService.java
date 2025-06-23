/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Services;

import DAOs.FeedbackDAO;
import Models.Feedback;

import java.util.List;

public class FeedbackService {

    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    public List<Feedback> getAllFeedbacks() {
        return feedbackDAO.getAllFeedbacks();
    }

    public boolean deleteFeedback(int feedbackId) {
        return feedbackDAO.deleteFeedbackById(feedbackId);
    }

}
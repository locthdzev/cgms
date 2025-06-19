/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers;

import Models.Feedback;
import Services.FeedbackService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/pt-feedback")
public class FeedbackController extends HttpServlet {

    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
        req.setAttribute("feedbacks", feedbacks);
        req.getRequestDispatcher("/pt-feedback.jsp").forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            String idParam = req.getParameter("id");
            try {
                int feedbackId = Integer.parseInt(idParam);
                feedbackService.deleteFeedback(feedbackId);
            } catch (NumberFormatException ignored) {
            }
        }

        List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
        req.setAttribute("feedbacks", feedbacks);
        req.getRequestDispatcher("feedback-list.jsp").forward(req, resp);
    }

}

package Controllers;

import Models.Feedback;
import Models.User;
import Services.FeedbackService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/member-feedback")
public class MemberFeedbackController extends HttpServlet {

    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get the logged-in user from the session
        User user = (User) req.getSession().getAttribute("loggedInUser");

        // If user is not logged in, redirect to login page
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Retrieve all feedback for the logged-in user
        List<Feedback> memberFeedbacks = feedbackService.getFeedbacksByUser(user.getId());

        // Set the feedback data to the request scope for display in the JSP
        req.setAttribute("memberFeedbacks", memberFeedbacks);

        // Forward the request to the JSP for rendering
        req.getRequestDispatcher("/member-feedback.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get the action type from the request
        String action = req.getParameter("action");

        // If the action is to send feedback
        if ("sendFeedback".equals(action)) {
            // Get the feedback details from the form
            String guestEmail = req.getParameter("guestEmail");
            String content = req.getParameter("content");

            // Get the logged-in user from the session
            User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");

            // Attempt to send the feedback
            boolean success = feedbackService.sendFeedback(loggedInUser.getId(), guestEmail, content);

            // Store the result message in the session
            if (success) {
                req.getSession().setAttribute("successMessage", "Gửi phản hồi thành công!");
            } else {
                req.getSession().setAttribute("errorMessage", "Gửi phản hồi thất bại!");
            }

            // Redirect back to the feedback page
            resp.sendRedirect(req.getContextPath() + "/member-feedback");
        }
    }
}

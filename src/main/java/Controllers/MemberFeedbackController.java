/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Models.Feedback;
import Models.User;
import Services.FeedbackService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author maile
 */
@WebServlet("/member/feedback")
public class MemberFeedbackController extends HttpServlet {

    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("=== DEBUG: MemberFeedbackController doGet called ===");

        User user = (User) req.getSession().getAttribute("loggedInUser");
        if (user == null) {
            System.out.println("DEBUG: User not logged in, redirecting to login");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        System.out.println("DEBUG: User ID: " + user.getId());

        String feedbackType = req.getParameter("type");
        System.out.println("DEBUG: Feedback type: " + feedbackType);

        List<Feedback> memberFeedbacks;
        if (feedbackType != null && !feedbackType.isEmpty()) {
            memberFeedbacks = feedbackService.getFeedbacksByUserAndType(user.getId(), feedbackType);
        } else {
            memberFeedbacks = feedbackService.getFeedbacksByUser(user.getId());
        }

        System.out
                .println("DEBUG: Found " + (memberFeedbacks != null ? memberFeedbacks.size() : "null") + " feedbacks");

        req.setAttribute("memberFeedbacks", memberFeedbacks);
        req.setAttribute("selectedType", feedbackType);

        System.out.println("DEBUG: Forwarding to member-feedback.jsp");
        req.getRequestDispatcher("/member-feedback.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("sendFeedback".equals(action)) {
            String guestEmail = req.getParameter("guestEmail");
            String content = req.getParameter("content");

            // Lấy ID người dùng đăng nhập từ session
            User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");
            boolean success = feedbackService.sendFeedback(loggedInUser.getId(), guestEmail, content);

            if (success) {
                req.getSession().setAttribute("successMessage", "Gửi phản hồi thành công!");
            } else {
                req.getSession().setAttribute("errorMessage", "Gửi phản hồi thất bại!");
            }

            // Redirect lại trang feedback
            resp.sendRedirect(req.getContextPath() + "/member/feedback");
        }
    }
}

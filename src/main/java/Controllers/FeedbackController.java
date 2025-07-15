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

@WebServlet("/feedback")
public class FeedbackController extends HttpServlet {

    private FeedbackService feedbackService = new FeedbackService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
        req.setAttribute("feedbacks", feedbacks);
        req.getRequestDispatcher("/feedback.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if ("delete".equals(action)) {
            String idParam = req.getParameter("id");
            try {
                int feedbackId = Integer.parseInt(idParam);
                boolean success = feedbackService.deleteFeedback(feedbackId);
                if (success) {
                    session.setAttribute("successMessage", "Xóa phản hồi thành công!");
                } else {
                    session.setAttribute("errorMessage", "Xóa phản hồi thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID phản hồi không hợp lệ!");
            }
        }
         else if ("respond".equals(action)) {
        int id = Integer.parseInt(req.getParameter("id"));
        String respText = req.getParameter("response");
        boolean ok = feedbackService.respondFeedback(id, respText);
        if (ok) session.setAttribute("successMessage", "Phản hồi thành công!");
        else   session.setAttribute("errorMessage",   "Phản hồi thất bại!");
    }

        // Chuyển hướng để tránh việc gửi lại form khi refresh trang
        resp.sendRedirect(req.getContextPath() + "/feedback");
    }

}

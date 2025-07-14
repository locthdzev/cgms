package Controllers;

import Models.Checkin;
import Services.CheckinService;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({ "/checkinHistory", "/checkin" })
public class CheckinController extends HttpServlet {
    private final CheckinService checkinService = new CheckinService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if ("/checkinHistory".equals(servletPath)) {
            // Xem lịch sử check-in của member cụ thể hoặc tất cả
            String memberIdStr = req.getParameter("memberId");
            if (memberIdStr != null) {
                // Xem lịch sử check-in của member cụ thể
                int memberId = Integer.parseInt(memberIdStr);
                List<Checkin> checkinList = checkinService.getCheckinHistoryByMemberId(memberId);
                req.setAttribute("checkinList", checkinList);
                req.getRequestDispatcher("/checkin-history.jsp").forward(req, resp);
            } else {
                // Admin xem tất cả lịch sử check-in
                List<Checkin> checkinList = checkinService.getAllCheckins();
                req.setAttribute("checkinList", checkinList);
                req.getRequestDispatcher("/checkin-history.jsp").forward(req, resp);
            }
        }
    }
}

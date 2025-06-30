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

@WebServlet("/checkinHistory")
public class CheckinController extends HttpServlet {
    private final CheckinService checkinService = new CheckinService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String memberIdStr = req.getParameter("memberId");
        int memberId = 0;
        if (memberIdStr != null) {
            memberId = Integer.parseInt(memberIdStr);
        } else {
            // Lấy từ session nếu không truyền qua param (ví dụ: hội viên tự xem lịch sử)
            HttpSession session = req.getSession();
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            if (loggedInUser != null) {
                memberId = loggedInUser.getId();
            }
        }
        List<Checkin> checkinList = checkinService.getCheckinHistoryByMemberId(memberId);
        req.setAttribute("checkinList", checkinList);
        req.getRequestDispatcher("/checkin-history.jsp").forward(req, resp);
    }
}

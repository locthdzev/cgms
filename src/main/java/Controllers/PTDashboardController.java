package Controllers;

import Models.User;
import Models.Schedule;
import Services.PTScheduleService;
import Services.PTStatsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "PTDashboardController", urlPatterns = { "/pt_dashboard" })
public class PTDashboardController extends HttpServlet {

    private PTStatsService ptStatsService = new PTStatsService();
    private PTScheduleService ptScheduleService = new PTScheduleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");

        // Kiểm tra xem người dùng đã đăng nhập và có vai trò Personal Trainer không
        if (loggedInUser == null || !"Personal Trainer".equals(loggedInUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy thống kê cho PT
            int todaySchedulesCount = ptStatsService.getTodaySchedulesCount(loggedInUser.getId());
            int totalClientsCount = ptStatsService.getTotalClientsCount(loggedInUser.getId());
            int thisWeekSchedulesCount = ptStatsService.getThisWeekSchedulesCount(loggedInUser.getId());
            int completedSchedulesCount = ptStatsService.getCompletedSchedulesCount(loggedInUser.getId());

            // Lấy lịch hẹn hôm nay
            List<Schedule> todaySchedules = ptScheduleService.getTodaySchedules(loggedInUser.getId());

            // Lấy lịch hẹn sắp tới (7 ngày tới)
            List<Schedule> upcomingSchedules = ptScheduleService.getUpcomingSchedules(loggedInUser.getId());

            // Lấy thống kê theo tuần cho biểu đồ
            List<Integer> weeklyStats = ptStatsService.getWeeklyScheduleStats(loggedInUser.getId());

            // Lấy thống kê theo tháng
            List<Integer> monthlyStats = ptStatsService.getMonthlyScheduleStats(loggedInUser.getId());

            // Set attributes để hiển thị trên JSP
            req.setAttribute("todaySchedulesCount", todaySchedulesCount);
            req.setAttribute("totalClientsCount", totalClientsCount);
            req.setAttribute("thisWeekSchedulesCount", thisWeekSchedulesCount);
            req.setAttribute("completedSchedulesCount", completedSchedulesCount);
            req.setAttribute("todaySchedules", todaySchedules);
            req.setAttribute("upcomingSchedules", upcomingSchedules);
            req.setAttribute("weeklyStats", weeklyStats);
            req.setAttribute("monthlyStats", monthlyStats);

        } catch (Exception e) {
            System.err.println("Error in PTDashboardController: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("/pt_dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
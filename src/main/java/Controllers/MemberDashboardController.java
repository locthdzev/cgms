package Controllers;

import Models.User;
import Models.Schedule;
import Models.MemberPackage;
import Models.Order;
import Services.MemberStatsService;
import Services.MemberScheduleService;
import Services.MemberPackageService;
import Services.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "MemberDashboardController", urlPatterns = { "/member-dashboard" })
public class MemberDashboardController extends HttpServlet {

    private MemberStatsService memberStatsService = new MemberStatsService();
    private MemberScheduleService memberScheduleService = new MemberScheduleService();
    private MemberPackageService memberPackageService = new MemberPackageService();
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");

        // Kiểm tra xem người dùng đã đăng nhập và có vai trò Member không
        if (loggedInUser == null || !"Member".equals(loggedInUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            System.out.println("=== MEMBER DASHBOARD CONTROLLER DEBUG ===");
            System.out.println("Logged in user: " + loggedInUser.getFullName() + " (ID: " + loggedInUser.getId() + ")");

            // Lấy thống kê cho Member
            int completedSessionsCount = memberStatsService.getCompletedSessionsCount(loggedInUser.getId());
            int upcomingSessionsCount = memberStatsService.getUpcomingSessionsCount(loggedInUser.getId());
            int totalOrdersCount = memberStatsService.getTotalOrdersCount(loggedInUser.getId());

            System.out.println("Completed Sessions: " + completedSessionsCount);
            System.out.println("Upcoming Sessions: " + upcomingSessionsCount);
            System.out.println("Total Orders: " + totalOrdersCount);

            // Lấy lịch tập sắp tới (7 ngày tới)
            List<Schedule> upcomingSchedules = memberScheduleService.getUpcomingSchedules(loggedInUser.getId());
            System.out.println(
                    "Upcoming Schedules count: " + (upcomingSchedules != null ? upcomingSchedules.size() : "null"));

            // Lấy dữ liệu cho biểu đồ
            List<Integer> weeklyWorkoutStats = memberStatsService.getWeeklyWorkoutStats(loggedInUser.getId());
            List<Double> monthlySpendingStats = memberStatsService.getMonthlySpendingStats(loggedInUser.getId());

            System.out.println("Weekly Workout Stats: " + weeklyWorkoutStats);
            System.out.println("Monthly Spending Stats: " + monthlySpendingStats);
            System.out.println("=== END CONTROLLER DEBUG ===");

            // Set attributes để hiển thị trên JSP
            req.setAttribute("completedSessionsCount", completedSessionsCount);
            req.setAttribute("upcomingSessionsCount", upcomingSessionsCount);
            req.setAttribute("totalOrdersCount", totalOrdersCount);
            req.setAttribute("upcomingSchedules", upcomingSchedules);
            req.setAttribute("weeklyWorkoutStats", weeklyWorkoutStats);
            req.setAttribute("monthlySpendingStats", monthlySpendingStats);

        } catch (Exception e) {
            System.err.println("Error in MemberDashboardController: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("/member-dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
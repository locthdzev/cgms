package Controllers;

import Models.Checkin;
import Services.CheckinService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import DAOs.UserDAO;
import java.time.LocalDate;
import Services.ScheduleService;
import Models.User;
import jakarta.servlet.http.HttpSession;

@WebServlet({ "/checkinHistory", "/checkin" })
public class CheckinController extends HttpServlet {
    private final CheckinService checkinService = new CheckinService();
    private final UserDAO userDAO = new UserDAO();
    private final ScheduleService scheduleService = new ScheduleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if ("/checkinHistory".equals(servletPath)) {
            // Lấy những member có lịch tập hôm nay
            LocalDate today = LocalDate.now();
            List<Models.Schedule> allSchedules = scheduleService.getAllSchedules();

            // Debug: In ra tổng số lịch tập và ngày hôm nay
            System.out.println("Tổng số lịch tập: " + allSchedules.size());
            System.out.println("Ngày hôm nay: " + today);

            // Lấy danh sách member cần check-in hôm nay
            List<Models.Schedule> schedulesToday = allSchedules.stream()
                    .filter(s -> s.getScheduleDate() != null && s.getScheduleDate().isEqual(today))
                    .filter(s -> "Confirmed".equals(s.getStatus()))
                    .collect(java.util.stream.Collectors.toList());

            // Debug: In ra số lịch tập hôm nay
            System.out.println("Số lịch tập hôm nay: " + schedulesToday.size());

            // Tự động hiển thị danh sách member cần check-in hôm nay
            req.setAttribute("schedulesToday", schedulesToday);

            // Load những Member có lịch tập trong hệ thống để hiển thị trong dropdown tra
            // cứu
            List<Integer> memberIdsWithSchedules = allSchedules.stream()
                    .map(s -> s.getMember().getId())
                    .distinct()
                    .collect(java.util.stream.Collectors.toList());

            List<User> userList = memberIdsWithSchedules.stream()
                    .map(id -> userDAO.getUserById(id))
                    .filter(java.util.Objects::nonNull)
                    .filter(u -> "Member".equals(u.getRole()))
                    .collect(java.util.stream.Collectors.toList());
            req.setAttribute("userList", userList);

            String userIdStr = req.getParameter("userId");
            String filterDateStr = req.getParameter("filterDate");
            if (userIdStr != null) {
                int userId = Integer.parseInt(userIdStr);
                User member = userDAO.getUserById(userId);
                req.setAttribute("member", member);
                List<Checkin> checkinList = checkinService.getCheckinHistoryByMemberId(userId);
                // Nếu có filterDate, chỉ lấy check-in của ngày đó
                if (filterDateStr != null && !filterDateStr.isEmpty()) {
                    java.time.LocalDate filterDate = java.time.LocalDate.parse(filterDateStr);
                    checkinList = checkinList.stream()
                            .filter(c -> c.getCheckinDate() != null && c.getCheckinDate().isEqual(filterDate))
                            .collect(java.util.stream.Collectors.toList());
                }
                req.setAttribute("checkinList", checkinList);

                // Lấy lịch tập hợp lệ cho member này hôm nay
                List<Models.Schedule> validSchedules = allSchedules.stream()
                        .filter(s -> s.getMember().getId().equals(userId))
                        .filter(s -> s.getScheduleDate() != null && s.getScheduleDate().isEqual(today))
                        .filter(s -> "Pending".equals(s.getStatus()) || "Confirmed".equals(s.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                req.setAttribute("validSchedules", validSchedules);
            }
            req.getRequestDispatcher("/checkin-history.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        if ("/checkin".equals(servletPath)) {
            String userIdStr = req.getParameter("userId");
            if (userIdStr != null) {
                int userId = Integer.parseInt(userIdStr);
                LocalDate today = LocalDate.now();

                // Kiểm tra xem user đã check-in hôm nay chưa
                List<Checkin> todayCheckins = checkinService.getCheckinHistoryByMemberId(userId).stream()
                        .filter(c -> c.getCheckinDate() != null && c.getCheckinDate().isEqual(today))
                        .collect(java.util.stream.Collectors.toList());

                if (!todayCheckins.isEmpty()) {
                    // Đã check-in hôm nay
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage", "Người dùng này đã check-in hôm nay rồi!");
                    resp.sendRedirect("checkinHistory?userId=" + userId);
                    return;
                }

                // Kiểm tra xem có lịch tập hợp lệ hôm nay không và thời gian check-in
                List<Models.Schedule> validSchedulesToday = scheduleService.getAllSchedules().stream()
                        .filter(s -> s.getMember().getId().equals(userId)
                                && "Confirmed".equals(s.getStatus())
                                && s.getScheduleDate().isEqual(today))
                        .collect(java.util.stream.Collectors.toList());

                if (validSchedulesToday.isEmpty()) {
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage", "Người dùng này không có lịch tập hợp lệ hôm nay!");
                    resp.sendRedirect("checkinHistory?userId=" + userId);
                    return;
                }

                // Kiểm tra thời gian check-in
                java.time.LocalTime currentTime = java.time.LocalTime.now();
                boolean canCheckin = false;
                String timeMessage = "";

                for (Models.Schedule schedule : validSchedulesToday) {
                    if (schedule.getScheduleTime() != null) {
                        java.time.LocalTime scheduleTime = schedule.getScheduleTime();
                        java.time.LocalTime earliestCheckinTime = scheduleTime.minusMinutes(15);
                        java.time.LocalTime latestCheckinTime = scheduleTime
                                .plusHours(schedule.getDurationHours() != null ? schedule.getDurationHours().longValue()
                                        : 1);

                        if (currentTime.isAfter(earliestCheckinTime) && currentTime.isBefore(latestCheckinTime)) {
                            canCheckin = true;
                            break;
                        } else if (currentTime.isBefore(earliestCheckinTime)) {
                            timeMessage = "Chưa tới thời gian check-in. Có thể check-in từ " +
                                    earliestCheckinTime.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm")) +
                                    " đến "
                                    + latestCheckinTime.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm"));
                        }
                    }
                }

                if (canCheckin) {
                    checkinService.createCheckinForUser(userId);
                    HttpSession session = req.getSession();
                    session.setAttribute("successMessage", "Check-in thành công cho người dùng!");
                } else {
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage",
                            timeMessage.isEmpty() ? "Đã quá thời gian check-in!" : timeMessage);
                }
                resp.sendRedirect("checkinHistory?userId=" + userId);
            } else {
                resp.sendRedirect("checkinHistory");
            }
        }
    }
}

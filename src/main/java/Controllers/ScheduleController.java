package Controllers;

import Models.Schedule;
import Models.User;
import Services.ScheduleService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet({ "/schedule", "/addSchedule", "/editSchedule" })
public class ScheduleController extends HttpServlet {
    private final ScheduleService service = new ScheduleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        String action = req.getParameter("action");

        if ("/addSchedule".equals(servletPath)) {
            // Hiển thị form thêm lịch tập
            req.setAttribute("schedule", new Schedule());
            req.setAttribute("formAction", "create");
            req.setAttribute("trainers", service.getAllTrainers());
            req.setAttribute("members", service.getActiveMembersWithPackage());
            if (((List<?>) req.getAttribute("members")).isEmpty()) {
                req.setAttribute("errorMessage", "Không có hội viên nào có gói tập còn hiệu lực để tạo lịch!");
            }
            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
        } else if ("/editSchedule".equals(servletPath)) {
            // Hiển thị form chỉnh sửa lịch tập
            String idStr = req.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Schedule schedule = service.getScheduleById(id);
                req.setAttribute("schedule", schedule);
                req.setAttribute("formAction", "edit");
                req.setAttribute("trainers", service.getAllTrainers());
                req.setAttribute("members", service.getActiveMembersWithPackage());
                if (((List<?>) req.getAttribute("members")).isEmpty()) {
                    req.setAttribute("errorMessage", "Không có hội viên nào có gói tập còn hiệu lực để tạo lịch!");
                }
                req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/schedule");
            }
        } else if ("/schedule".equals(servletPath)) {
            if (action == null) {
                // Hiển thị danh sách lịch tập
                List<Schedule> list = service.getAllSchedules();
                req.setAttribute("scheduleList", list);
                req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
            } else if ("delete".equals(action)) {
                // Xóa lịch tập
                try {
                    service.deleteSchedule(Integer.parseInt(req.getParameter("id")));
                    HttpSession session = req.getSession();
                    session.setAttribute("successMessage", "Xóa lịch tập thành công!");
                } catch (Exception e) {
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage", "Lỗi khi xóa lịch tập: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/schedule");
            } else if ("view".equals(action)) {
                // Xem chi tiết lịch tập
                int id = Integer.parseInt(req.getParameter("id"));
                Schedule schedule = service.getScheduleById(id);
                req.setAttribute("schedule", schedule);
                req.setAttribute("formAction", "view");
                req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
            } else if ("updateStatus".equals(action)) {
                // Cập nhật trạng thái lịch tập
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    String status = req.getParameter("status");
                    service.updateScheduleStatus(id, status);
                    HttpSession session = req.getSession();
                    session.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
                } catch (Exception e) {
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/schedule");

            } else {
                // Mặc định hiển thị danh sách
                List<Schedule> list = service.getAllSchedules();
                req.setAttribute("scheduleList", list);
                req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String formAction = req.getParameter("formAction");
        String idStr = req.getParameter("id");
        HttpSession session = req.getSession();
        Schedule schedule = new Schedule();

        try {
            if (idStr != null && !idStr.trim().isEmpty()) {
                // Update
                schedule = service.getScheduleById(Integer.parseInt(idStr));
                if (schedule == null) {
                    throw new IllegalArgumentException("Không tìm thấy lịch tập để cập nhật");
                }
                schedule.setUpdatedAt(Instant.now());
            } else {
                // Create
                schedule.setCreatedAt(Instant.now());
            }

            // Set trainer
            String trainerIdStr = req.getParameter("trainerId");
            if (trainerIdStr != null && !trainerIdStr.trim().isEmpty()) {
                User trainer = new User();
                trainer.setId(Integer.parseInt(trainerIdStr));
                schedule.setTrainer(trainer);
            } else {
                schedule.setTrainer(null);
            }

            // Set member
            String memberIdStr = req.getParameter("memberId");
            if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                User member = new User();
                member.setId(Integer.parseInt(memberIdStr));
                schedule.setMember(member);
            } else {
                schedule.setMember(null);
            }

            // Set schedule date
            String scheduleDateStr = req.getParameter("scheduleDate");
            if (scheduleDateStr != null && !scheduleDateStr.trim().isEmpty()) {
                schedule.setScheduleDate(LocalDate.parse(scheduleDateStr));
            } else {
                schedule.setScheduleDate(null);
            }

            // Set schedule time
            String scheduleTimeStr = req.getParameter("scheduleTime");
            if (scheduleTimeStr != null && !scheduleTimeStr.trim().isEmpty()) {
                schedule.setScheduleTime(LocalTime.parse(scheduleTimeStr));
            } else {
                schedule.setScheduleTime(null);
            }

            // Set duration
            String durationStr = req.getParameter("durationHours");
            if (durationStr != null && !durationStr.trim().isEmpty()) {
                schedule.setDurationHours(new BigDecimal(durationStr));
            } else {
                schedule.setDurationHours(null);
            }

            // Set status
            String status = req.getParameter("status");
            if (status != null && !status.trim().isEmpty()) {
                schedule.setStatus(status);
            } else {
                schedule.setStatus("Pending"); // Default status
            }

            if (idStr != null && !idStr.trim().isEmpty()) {
                service.updateSchedule(schedule);
                session.setAttribute("successMessage", "Cập nhật lịch tập thành công!");
            } else {
                service.saveSchedule(schedule);
                session.setAttribute("successMessage", "Tạo lịch tập mới thành công!");
            }

            resp.sendRedirect(req.getContextPath() + "/schedule");

        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("schedule", schedule);
            req.setAttribute("formAction", formAction);
            req.setAttribute("trainers", service.getAllTrainers());
            req.setAttribute("members", service.getActiveMembersWithPackage());
            if (((List<?>) req.getAttribute("members")).isEmpty()) {
                req.setAttribute("errorMessage", "Không có hội viên nào có gói tập còn hiệu lực để tạo lịch!");
            }
            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            req.setAttribute("schedule", schedule);
            req.setAttribute("formAction", formAction);
            req.setAttribute("trainers", service.getAllTrainers());
            req.setAttribute("members", service.getAllMembers());
            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
        }
    }
}

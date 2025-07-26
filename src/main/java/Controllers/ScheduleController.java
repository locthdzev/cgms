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
            String type = req.getParameter("type");
            boolean isPTMode = "pt".equalsIgnoreCase(type);
            req.setAttribute("isPTMode", isPTMode);
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
            // Xử lý action delete
            if ("delete".equals(action)) {
                String idStr = req.getParameter("id");
                if (idStr != null && !idStr.trim().isEmpty()) {
                    try {
                        int id = Integer.parseInt(idStr);
                        service.deleteSchedule(id);
                        HttpSession session = req.getSession();
                        session.setAttribute("successMessage", "Xóa lịch tập thành công!");
                    } catch (Exception e) {
                        e.printStackTrace();
                        HttpSession session = req.getSession();
                        session.setAttribute("errorMessage", "Lỗi khi xóa lịch tập: " + e.getMessage());
                    }
                } else {
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage", "Không tìm thấy ID lịch tập để xóa!");
                }
                resp.sendRedirect(req.getContextPath() + "/schedule");
                return;
            }

            // Xử lý hiển thị danh sách lịch tập
            String trainerIdStr = req.getParameter("trainerId");
            String memberIdStr = req.getParameter("memberId");
            List<Schedule> list;
            if (trainerIdStr != null && !trainerIdStr.isEmpty()) {
                list = service.getSchedulesByTrainerId(Integer.parseInt(trainerIdStr));
            } else if (memberIdStr != null && !memberIdStr.isEmpty()) {
                list = service.getSchedulesByMemberId(Integer.parseInt(memberIdStr));
            } else {
                list = service.getAllSchedules();
            }
            // Luôn truyền đầy đủ danh sách trainer và member
            req.setAttribute("scheduleList", list);
            req.setAttribute("formAction", "list");
            req.setAttribute("trainers", service.getAllTrainers());
            req.setAttribute("members", service.getAllMembers());
            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String formAction = req.getParameter("formAction");
        String idStr = req.getParameter("id");
        HttpSession session = req.getSession();

        try {
            if ("create".equals(formAction)) {
                // Xử lý tạo lịch tập mới (có thể nhiều lịch)
                String trainerIdStr = req.getParameter("trainerId");
                String memberIdStr = req.getParameter("memberId");
                // Lấy các trường có thể là mảng
                String[] scheduleDates = req.getParameterValues("scheduleDate");
                String[] scheduleTimes = req.getParameterValues("scheduleTime");
                String[] durationHoursArr = req.getParameterValues("durationHours");
                String[] statusArr = req.getParameterValues("status");

                int count = scheduleDates != null ? scheduleDates.length : 0;
                int successCount = 0;
                for (int i = 0; i < count; i++) {
                    Schedule sch = new Schedule();
                    sch.setCreatedAt(Instant.now());
                    // Trainer
                    if (trainerIdStr != null && !trainerIdStr.trim().isEmpty()) {
                        User trainer = new User();
                        trainer.setId(Integer.parseInt(trainerIdStr));
                        sch.setTrainer(trainer);
                    }
                    // Member
                    if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                        User member = new User();
                        member.setId(Integer.parseInt(memberIdStr));
                        sch.setMember(member);
                    }
                    // Date
                    if (scheduleDates[i] != null && !scheduleDates[i].trim().isEmpty()) {
                        sch.setScheduleDate(LocalDate.parse(scheduleDates[i]));
                    }
                    // Time
                    if (scheduleTimes[i] != null && !scheduleTimes[i].trim().isEmpty()) {
                        LocalTime scheduleTime = LocalTime.parse(scheduleTimes[i]);
                        // Kiểm tra điều kiện giờ bắt đầu
                        LocalTime minTime = LocalTime.of(7, 0);
                        LocalTime maxTime = LocalTime.of(22, 0);
                        if (scheduleTime.isBefore(minTime) || scheduleTime.isAfter(maxTime)) {
                            req.setAttribute("errorMessage", "Chỉ được tạo lịch từ 07:00 đến 22:00!");
                            req.setAttribute("formAction", "create");
                            req.setAttribute("trainers", service.getAllTrainers());
                            req.setAttribute("members", service.getActiveMembersWithPackage());
                            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                            return;
                        }
                        sch.setScheduleTime(scheduleTime);
                    }
                    // Duration
                    if (durationHoursArr[i] != null && !durationHoursArr[i].trim().isEmpty()) {
                        sch.setDurationHours(new BigDecimal(durationHoursArr[i]));
                    }
                    // Status
                    if (statusArr[i] != null && !statusArr[i].trim().isEmpty()) {
                        sch.setStatus(statusArr[i]);
                    } else {
                        sch.setStatus("Pending");
                    }
                    // Lưu từng lịch
                    try {
                        service.saveSchedule(sch);
                        successCount++;
                    } catch (Exception ex) {
                        // Có thể log lỗi từng dòng nếu muốn
                    }
                }
                session.setAttribute("successMessage",
                        "Đã tạo thành công " + successCount + "/" + count + " lịch tập!");
                resp.sendRedirect(req.getContextPath() + "/schedule");
                return;
            } else if ("edit".equals(formAction)) {
                // Xử lý chỉnh sửa lịch tập
                if (idStr == null || idStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Không tìm thấy ID lịch tập để cập nhật");
                }

                Schedule schedule = service.getScheduleById(Integer.parseInt(idStr));
                if (schedule == null) {
                    throw new IllegalArgumentException("Không tìm thấy lịch tập để cập nhật");
                }

                schedule.setUpdatedAt(Instant.now());

                // Set trainer
                String trainerIdStr = req.getParameter("trainerId");
                if (trainerIdStr != null && !trainerIdStr.trim().isEmpty()) {
                    User trainer = new User();
                    trainer.setId(Integer.parseInt(trainerIdStr));
                    schedule.setTrainer(trainer);
                }

                // Set member
                String memberIdStr = req.getParameter("memberId");
                if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                    User member = new User();
                    member.setId(Integer.parseInt(memberIdStr));
                    schedule.setMember(member);
                }

                // Set schedule date
                String scheduleDateStr = req.getParameter("scheduleDate");
                if (scheduleDateStr != null && !scheduleDateStr.trim().isEmpty()) {
                    schedule.setScheduleDate(LocalDate.parse(scheduleDateStr));
                }

                // Set schedule time
                String scheduleTimeStr = req.getParameter("scheduleTime");
                if (scheduleTimeStr != null && !scheduleTimeStr.trim().isEmpty()) {
                    schedule.setScheduleTime(LocalTime.parse(scheduleTimeStr));
                }

                // Set duration
                String durationStr = req.getParameter("durationHours");
                if (durationStr != null && !durationStr.trim().isEmpty()) {
                    schedule.setDurationHours(new BigDecimal(durationStr));
                }

                // Set status
                String status = req.getParameter("status");
                if (status != null && !status.trim().isEmpty()) {
                    schedule.setStatus(status);
                }

                service.updateSchedule(schedule);
                session.setAttribute("successMessage", "Cập nhật lịch tập thành công!");
                resp.sendRedirect(req.getContextPath() + "/schedule");
                return;
            } else {
                // Xử lý tạo lịch tập đơn lẻ (fallback)
                Schedule schedule = new Schedule();

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
            }

        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", e.getMessage());
            if ("edit".equals(formAction) && idStr != null) {
                // Lấy lại thông tin lịch tập để hiển thị lại form
                try {
                    Schedule schedule = service.getScheduleById(Integer.parseInt(idStr));
                    req.setAttribute("schedule", schedule);
                } catch (Exception ex) {
                    // Nếu không lấy được, tạo schedule rỗng
                    req.setAttribute("schedule", new Schedule());
                }
            } else {
                req.setAttribute("schedule", new Schedule());
            }
            req.setAttribute("formAction", formAction);
            req.setAttribute("trainers", service.getAllTrainers());
            req.setAttribute("members", service.getAllMembers());
            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            if ("edit".equals(formAction) && idStr != null) {
                // Lấy lại thông tin lịch tập để hiển thị lại form
                try {
                    Schedule schedule = service.getScheduleById(Integer.parseInt(idStr));
                    req.setAttribute("schedule", schedule);
                } catch (Exception ex) {
                    // Nếu không lấy được, tạo schedule rỗng
                    req.setAttribute("schedule", new Schedule());
                }
            } else {
                req.setAttribute("schedule", new Schedule());
            }
            req.setAttribute("formAction", formAction);
            req.setAttribute("trainers", service.getAllTrainers());
            req.setAttribute("members", service.getAllMembers());
            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
        }
    }
}

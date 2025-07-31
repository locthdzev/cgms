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
            // Lấy trainer và member thực sự có trong lịch
            java.util.Set<Integer> trainerIds = new java.util.HashSet<>();
            java.util.Set<Integer> memberIds = new java.util.HashSet<>();
            for (Schedule s : list) {
                if (s.getTrainer() != null && s.getTrainer().getId() != null)
                    trainerIds.add(s.getTrainer().getId());
                if (s.getMember() != null && s.getMember().getId() != null)
                    memberIds.add(s.getMember().getId());
            }
            java.util.List<User> filteredTrainers = new java.util.ArrayList<>();
            java.util.List<User> filteredMembers = new java.util.ArrayList<>();
            for (User t : service.getAllTrainers()) {
                if (trainerIds.contains(t.getId()))
                    filteredTrainers.add(t);
            }
            for (User m : service.getAllMembers()) {
                if (memberIds.contains(m.getId()))
                    filteredMembers.add(m);
            }
            req.setAttribute("trainers", filteredTrainers);
            req.setAttribute("members", filteredMembers);
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
                String trainerIdStr = req.getParameter("trainerId");
                String memberIdStr = req.getParameter("memberId");
                boolean createFullWeek = req.getParameter("createFullWeek") != null;
                if (createFullWeek) {
                    // Tạo lịch cho cả tuần (thứ 2 đến thứ 7)
                    String weekStartDateStr = req.getParameter("weekStartDate");
                    String scheduleTimeStr = req.getParameter("weekScheduleTime");
                    String durationStr = req.getParameter("weekDurationHours");
                    String status = req.getParameter("weekStatus");
                    if (weekStartDateStr != null && !weekStartDateStr.trim().isEmpty()
                            && scheduleTimeStr != null && !scheduleTimeStr.trim().isEmpty()
                            && durationStr != null && !durationStr.trim().isEmpty()) {
                        LocalDate weekStart = LocalDate.parse(weekStartDateStr);
                        // Kiểm tra ngày bắt đầu phải là thứ 2
                        if (weekStart.getDayOfWeek().getValue() != 1) { // 1 = MONDAY
                            req.setAttribute("errorMessage", "Ngày bắt đầu tuần phải là thứ 2!");
                            req.setAttribute("formAction", "create");
                            req.setAttribute("trainers", service.getAllTrainers());
                            req.setAttribute("members", service.getActiveMembersWithPackage());
                            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                            return;
                        }
                        LocalTime scheduleTime = LocalTime.parse(scheduleTimeStr);
                        BigDecimal duration = new BigDecimal(durationStr);
                        int successCount = 0;
                        int total = 0;
                        for (int i = 0; i < 6; i++) { // Thứ 2 đến thứ 7
                            LocalDate date = weekStart.plusDays(i);
                            if (date.getDayOfWeek().getValue() == 7)
                                continue; // Bỏ qua Chủ Nhật
                            Schedule sch = new Schedule();
                            sch.setCreatedAt(Instant.now());
                            if (trainerIdStr != null && !trainerIdStr.trim().isEmpty()) {
                                User trainer = new User();
                                trainer.setId(Integer.parseInt(trainerIdStr));
                                sch.setTrainer(trainer);
                            }
                            if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                                User member = new User();
                                member.setId(Integer.parseInt(memberIdStr));
                                sch.setMember(member);
                            }
                            sch.setScheduleDate(date);
                            sch.setScheduleTime(scheduleTime);
                            sch.setDurationHours(duration);
                            sch.setStatus(status != null && !status.trim().isEmpty() ? status : "Pending");
                            try {
                                service.saveSchedule(sch);
                                successCount++;
                            } catch (Exception ex) {
                                req.setAttribute("errorMessage", "Lỗi ở ngày " + date + ": " + ex.getMessage());
                                req.setAttribute("formAction", "create");
                                req.setAttribute("trainers", service.getAllTrainers());
                                req.setAttribute("members", service.getActiveMembersWithPackage());
                                req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                                return;
                            }
                            total++;
                        }
                        session.setAttribute("successMessage",
                                "Đã tạo thành công " + successCount + "/" + total + " lịch tập trong tuần!");
                        resp.sendRedirect(req.getContextPath() + "/schedule");
                        return;
                    }
                }
                // Xử lý tạo lịch tập mới (có thể nhiều lịch)
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
                        LocalDate date = LocalDate.parse(scheduleDates[i]);
                        // Kiểm tra nếu là Chủ Nhật
                        if (date.getDayOfWeek().getValue() == 7) { // 7 = SUNDAY
                            req.setAttribute("errorMessage",
                                    "Không được tạo lịch vào Chủ Nhật! Phòng gym chỉ hoạt động từ thứ 2 đến thứ 7.");
                            req.setAttribute("formAction", "create");
                            req.setAttribute("trainers", service.getAllTrainers());
                            req.setAttribute("members", service.getActiveMembersWithPackage());
                            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                            return;
                        }
                        sch.setScheduleDate(date);
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
                        // Kiểm tra thời gian kết thúc không vượt quá giờ đóng cửa
                        if (durationHoursArr != null && durationHoursArr[i] != null
                                && !durationHoursArr[i].trim().isEmpty()) {
                            double duration = Double.parseDouble(durationHoursArr[i]);
                            int minutes = (int) (duration * 60);
                            LocalTime endTime = scheduleTime.plusMinutes(minutes);
                            if (endTime.isAfter(maxTime)) {
                                req.setAttribute("errorMessage",
                                        "Thời gian tập vượt quá giờ đóng cửa (22:00). Vui lòng chọn giờ bắt đầu sớm hơn!");
                                req.setAttribute("formAction", "create");
                                req.setAttribute("trainers", service.getAllTrainers());
                                req.setAttribute("members", service.getActiveMembersWithPackage());
                                req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                                return;
                            }
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
                        req.setAttribute("errorMessage", ex.getMessage());
                        req.setAttribute("formAction", "create");
                        req.setAttribute("trainers", service.getAllTrainers());
                        req.setAttribute("members", service.getActiveMembersWithPackage());
                        req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                        return;
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
                    LocalDate date = LocalDate.parse(scheduleDateStr);
                    // Kiểm tra nếu là Chủ Nhật
                    if (date.getDayOfWeek().getValue() == 7) { // 7 = SUNDAY
                        req.setAttribute("errorMessage",
                                "Không được tạo hoặc chỉnh sửa lịch vào Chủ Nhật! Phòng gym chỉ hoạt động từ thứ 2 đến thứ 7.");
                        req.setAttribute("formAction", formAction);
                        req.setAttribute("trainers", service.getAllTrainers());
                        req.setAttribute("members", service.getActiveMembersWithPackage());
                        req.setAttribute("schedule", schedule);
                        req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                        return;
                    }
                    schedule.setScheduleDate(date);
                }

                // Set schedule time
                String scheduleTimeStr = req.getParameter("scheduleTime");
                if (scheduleTimeStr != null && !scheduleTimeStr.trim().isEmpty()) {
                    LocalTime scheduleTime = LocalTime.parse(scheduleTimeStr);
                    // Kiểm tra điều kiện giờ bắt đầu
                    LocalTime minTime = LocalTime.of(7, 0);
                    LocalTime maxTime = LocalTime.of(22, 0);
                    if (scheduleTime.isBefore(minTime) || scheduleTime.isAfter(maxTime)) {
                        req.setAttribute("errorMessage", "Chỉ được đặt lịch từ 07:00 đến 22:00!");
                        req.setAttribute("formAction", formAction);
                        req.setAttribute("trainers", service.getAllTrainers());
                        req.setAttribute("members", service.getActiveMembersWithPackage());
                        req.setAttribute("schedule", schedule);
                        req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                        return;
                    }
                    // Kiểm tra thời gian kết thúc không vượt quá giờ đóng cửa
                    String durationStr = req.getParameter("durationHours");
                    if (durationStr != null && !durationStr.trim().isEmpty()) {
                        double duration = Double.parseDouble(durationStr);
                        int minutes = (int) (duration * 60);
                        LocalTime endTime = scheduleTime.plusMinutes(minutes);
                        if (endTime.isAfter(maxTime)) {
                            req.setAttribute("errorMessage",
                                    "Thời gian tập vượt quá giờ đóng cửa (22:00). Vui lòng chọn giờ bắt đầu sớm hơn!");
                            req.setAttribute("formAction", formAction);
                            req.setAttribute("trainers", service.getAllTrainers());
                            req.setAttribute("members", service.getActiveMembersWithPackage());
                            req.setAttribute("schedule", schedule);
                            req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                            return;
                        }
                    }
                    schedule.setScheduleTime(scheduleTime);
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

                try {
                    service.updateSchedule(schedule);
                    session.setAttribute("successMessage", "Cập nhật lịch tập thành công!");
                    resp.sendRedirect(req.getContextPath() + "/schedule");
                    return;
                } catch (Exception ex) {
                    req.setAttribute("errorMessage", ex.getMessage());
                    req.setAttribute("formAction", formAction);
                    req.setAttribute("trainers", service.getAllTrainers());
                    req.setAttribute("members", service.getActiveMembersWithPackage());
                    req.setAttribute("schedule", schedule);
                    req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                    return;
                }
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
                    LocalDate date = LocalDate.parse(scheduleDateStr);
                    // Kiểm tra nếu là Chủ Nhật
                    if (date.getDayOfWeek().getValue() == 7) { // 7 = SUNDAY
                        req.setAttribute("errorMessage",
                                "Không được tạo lịch vào Chủ Nhật! Phòng gym chỉ hoạt động từ thứ 2 đến thứ 7.");
                        req.setAttribute("formAction", "create");
                        req.setAttribute("trainers", service.getAllTrainers());
                        req.setAttribute("members", service.getActiveMembersWithPackage());
                        req.getRequestDispatcher("/schedule.jsp").forward(req, resp);
                        return;
                    }
                    schedule.setScheduleDate(date);
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

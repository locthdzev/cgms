package Controllers;

import Models.User;
import Models.TrainerAvailability;
import Services.TrainerAvailabilityService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "PTAvailabilityController", urlPatterns = { "/pt-availability" })
public class PTAvailabilityController extends HttpServlet {

    private final TrainerAvailabilityService availabilityService = new TrainerAvailabilityService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");

        // Kiểm tra quyền PT
        if (loggedInUser == null || !"Personal Trainer".equals(loggedInUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");

        if ("list".equals(action) || action == null) {
            showAvailabilityList(req, resp, loggedInUser);
        } else if ("calendar".equals(action)) {
            showCalendarView(req, resp, loggedInUser);
        } else if ("register".equals(action)) {
            showRegisterForm(req, resp);
        } else if ("cancel".equals(action)) {
            cancelAvailability(req, resp, loggedInUser);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");

        // Kiểm tra quyền PT
        if (loggedInUser == null || !"Personal Trainer".equals(loggedInUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");

        if ("register".equals(action)) {
            registerAvailability(req, resp, loggedInUser);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showAvailabilityList(HttpServletRequest req, HttpServletResponse resp, User trainer)
            throws ServletException, IOException {
        List<TrainerAvailability> availabilities = availabilityService.getTrainerAvailabilities(trainer.getId());
        req.setAttribute("availabilities", availabilities);
        req.getRequestDispatcher("pt-availability-list.jsp").forward(req, resp);
    }

    private void showCalendarView(HttpServletRequest req, HttpServletResponse resp, User trainer)
            throws ServletException, IOException {
        // Lấy tháng/năm từ parameter hoặc dùng hiện tại
        String yearParam = req.getParameter("year");
        String monthParam = req.getParameter("month");

        java.time.LocalDate now = java.time.LocalDate.now();
        int year = yearParam != null ? Integer.parseInt(yearParam) : now.getYear();
        int month = monthParam != null ? Integer.parseInt(monthParam) : now.getMonthValue();

        List<TrainerAvailability> monthlyAvailabilities = availabilityService.getAvailabilitiesByMonth(trainer.getId(),
                year, month);

        req.setAttribute("monthlyAvailabilities", monthlyAvailabilities);
        req.setAttribute("currentYear", year);
        req.setAttribute("currentMonth", month);
        req.getRequestDispatcher("pt-availability-calendar.jsp").forward(req, resp);
    }

    private void showRegisterForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("pt-availability-register.jsp").forward(req, resp);
    }

    private void registerAvailability(HttpServletRequest req, HttpServletResponse resp, User trainer)
            throws ServletException, IOException {
        try {
            String dateStr = req.getParameter("availabilityDate");
            String startTimeStr = req.getParameter("startTime");
            String endTimeStr = req.getParameter("endTime");

            // Validation
            if (dateStr == null || startTimeStr == null || endTimeStr == null) {
                req.getSession().setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin");
                resp.sendRedirect("pt-availability?action=register");
                return;
            }

            java.time.LocalDate date = java.time.LocalDate.parse(dateStr);
            java.time.LocalTime startTime = java.time.LocalTime.parse(startTimeStr);
            java.time.LocalTime endTime = java.time.LocalTime.parse(endTimeStr);

            // Tạo availability object
            TrainerAvailability availability = new TrainerAvailability();
            availability.setTrainer(trainer);
            availability.setAvailabilityDate(date);
            availability.setStartTime(startTime);
            availability.setEndTime(endTime);

            boolean success = availabilityService.registerAvailability(availability);

            if (success) {
                req.getSession().setAttribute("successMessage", "Đăng ký lịch sẵn sàng thành công! Chờ admin duyệt.");
            } else {
                // Kiểm tra lý do thất bại
                if (date.getDayOfWeek() == java.time.DayOfWeek.SUNDAY) {
                    req.getSession().setAttribute("errorMessage", "Gym không hoạt động vào Chủ nhật");
                } else {
                    req.getSession().setAttribute("errorMessage",
                            "Bạn đã đăng ký lịch cho ngày này rồi. Mỗi ngày chỉ được đăng ký 1 lần.");
                }
            }

            resp.sendRedirect("pt-availability");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect("pt-availability?action=register");
        }
    }

    private void cancelAvailability(HttpServletRequest req, HttpServletResponse resp, User trainer)
            throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                req.getSession().setAttribute("errorMessage", "Thiếu thông tin ID");
                resp.sendRedirect("pt-availability");
                return;
            }

            int availabilityId = Integer.parseInt(idStr);
            String result = availabilityService.cancelAvailability(availabilityId, trainer.getId());

            if ("success".equals(result)) {
                req.getSession().setAttribute("successMessage", "Hủy lịch sẵn sàng thành công");
            } else {
                req.getSession().setAttribute("errorMessage", result);
            }

            resp.sendRedirect("pt-availability");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect("pt-availability");
        }
    }
}
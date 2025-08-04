package Controllers;

import Models.User;
import Models.TrainerAvailability;
import Services.TrainerAvailabilityService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAvailabilityController", urlPatterns = { "/admin-pt-availability" })
public class AdminAvailabilityController extends HttpServlet {

    private final TrainerAvailabilityService availabilityService = new TrainerAvailabilityService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");

        // Kiểm tra quyền Admin
        if (loggedInUser == null || !"Admin".equals(loggedInUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");

        if ("list".equals(action) || action == null) {
            showPendingList(req, resp);
        } else if ("calendar".equals(action)) {
            showCalendarView(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");

        // Kiểm tra quyền Admin
        if (loggedInUser == null || !"Admin".equals(loggedInUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");

        if ("approve".equals(action)) {
            approveAvailability(req, resp);
        } else if ("reject".equals(action)) {
            rejectAvailability(req, resp);
        } else if ("cancel".equals(action)) {
            cancelAvailability(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showPendingList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // Lấy filter trainer (nếu có)
            String trainerIdParam = req.getParameter("trainerId");
            Integer trainerId = null;
            if (trainerIdParam != null && !trainerIdParam.trim().isEmpty()) {
                try {
                    trainerId = Integer.parseInt(trainerIdParam);
                } catch (NumberFormatException e) {
                    // Invalid trainerId, ignore filter
                }
            }

            // Lấy danh sách pending availabilities
            List<TrainerAvailability> pendingAvailabilities = availabilityService
                    .getPendingAvailabilitiesByTrainer(trainerId);

            // Lấy danh sách tất cả trainer để làm filter dropdown
            List<User> trainers = getUsersByRole("Personal Trainer");

            req.setAttribute("pendingAvailabilities", pendingAvailabilities);
            req.setAttribute("trainers", trainers);
            req.setAttribute("selectedTrainerId", trainerId);

            req.getRequestDispatcher("admin-pt-availability-list.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách lịch chờ duyệt");
            req.getRequestDispatcher("admin-pt-availability-list.jsp").forward(req, resp);
        }
    }

    private void showCalendarView(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // Lấy tháng/năm từ parameter hoặc dùng hiện tại
            String yearParam = req.getParameter("year");
            String monthParam = req.getParameter("month");

            java.time.LocalDate now = java.time.LocalDate.now();
            int year = yearParam != null ? Integer.parseInt(yearParam) : now.getYear();
            int month = monthParam != null ? Integer.parseInt(monthParam) : now.getMonthValue();

            // Lấy filter trainer (nếu có)
            String trainerIdParam = req.getParameter("trainerId");
            Integer trainerId = null;
            if (trainerIdParam != null && !trainerIdParam.trim().isEmpty()) {
                try {
                    trainerId = Integer.parseInt(trainerIdParam);
                } catch (NumberFormatException e) {
                    // Invalid trainerId, ignore filter
                }
            }

            // Lấy availabilities trong tháng
            List<TrainerAvailability> monthlyAvailabilities = getMonthlyAvailabilities(trainerId, year, month);

            // Lấy danh sách tất cả trainer để làm filter dropdown
            List<User> trainers = getUsersByRole("Personal Trainer");

            req.setAttribute("monthlyAvailabilities", monthlyAvailabilities);
            req.setAttribute("trainers", trainers);
            req.setAttribute("selectedTrainerId", trainerId);
            req.setAttribute("currentYear", year);
            req.setAttribute("currentMonth", month);

            req.getRequestDispatcher("admin-pt-availability-calendar.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra khi tải lịch PT");
            req.getRequestDispatcher("admin-pt-availability-calendar.jsp").forward(req, resp);
        }
    }

    private void approveAvailability(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                req.getSession().setAttribute("errorMessage", "Thiếu thông tin ID");
                resp.sendRedirect("admin-pt-availability");
                return;
            }

            int availabilityId = Integer.parseInt(idStr);
            boolean success = availabilityService.approveAvailability(availabilityId);

            if (success) {
                req.getSession().setAttribute("successMessage", "Duyệt lịch sẵn sàng thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Duyệt lịch sẵn sàng thất bại");
            }

            resp.sendRedirect("admin-pt-availability");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect("admin-pt-availability");
        }
    }

    private void rejectAvailability(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                req.getSession().setAttribute("errorMessage", "Thiếu thông tin ID");
                resp.sendRedirect("admin-pt-availability");
                return;
            }

            int availabilityId = Integer.parseInt(idStr);
            boolean success = availabilityService.rejectAvailability(availabilityId);

            if (success) {
                req.getSession().setAttribute("successMessage", "Từ chối lịch sẵn sàng thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Từ chối lịch sẵn sàng thất bại");
            }

            resp.sendRedirect("admin-pt-availability");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect("admin-pt-availability");
        }
    }

    private void cancelAvailability(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                req.getSession().setAttribute("errorMessage", "Thiếu thông tin ID");
                resp.sendRedirect("admin-pt-availability");
                return;
            }

            int availabilityId = Integer.parseInt(idStr);
            boolean success = availabilityService.deleteAvailability(availabilityId);

            if (success) {
                req.getSession().setAttribute("successMessage", "Hủy lịch sẵn sàng thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Hủy lịch sẵn sàng thất bại");
            }

            resp.sendRedirect("admin-pt-availability");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect("admin-pt-availability");
        }
    }

    /**
     * Lấy availabilities theo tháng (tất cả trainer hoặc filter theo trainer)
     */
    private List<TrainerAvailability> getMonthlyAvailabilities(Integer trainerId, int year, int month) {
        try {
            java.time.LocalDate startDate = java.time.LocalDate.of(year, month, 1);
            java.time.LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());

            if (trainerId != null) {
                // Filter theo trainer cụ thể
                return availabilityService.getAvailabilitiesByMonth(trainerId, year, month);
            } else {
                // Lấy tất cả trainer availabilities trong tháng
                return availabilityService.getAllAvailabilitiesInMonth(year, month);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    /**
     * Lấy danh sách user theo role
     */
    private List<User> getUsersByRole(String role) {
        try {
            // Implement using UserDAO - simple query
            String sql = "SELECT * FROM Users WHERE Role = ? ORDER BY FullName";
            List<User> users = new java.util.ArrayList<>();

            try (java.sql.Connection conn = DbConnection.DbConnection.getConnection();
                    java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, role);

                try (java.sql.ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        User user = new User();
                        user.setId(rs.getInt("UserId"));
                        user.setFullName(rs.getString("FullName"));
                        user.setEmail(rs.getString("Email"));
                        user.setRole(rs.getString("Role"));
                        users.add(user);
                    }
                }
            }

            return users;
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
}
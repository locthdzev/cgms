package Controllers;

import DAOs.ScheduleDAO;
import Models.Schedule;
import Models.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "MemberScheduleController", urlPatterns = { "/member-training-schedule",
        "/member-training-schedule/*" })
public class MemberScheduleController extends HttpServlet {
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();
    private final ObjectMapper objectMapper;

    public MemberScheduleController() {
        objectMapper = new ObjectMapper();
        // Cấu hình ObjectMapper để xử lý ký tự Unicode đúng cách
        objectMapper.configure(com.fasterxml.jackson.core.JsonParser.Feature.ALLOW_UNQUOTED_CONTROL_CHARS, true);
        objectMapper.configure(com.fasterxml.jackson.databind.SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Kiểm tra người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Nếu không có pathInfo hoặc pathInfo là "/", hiển thị trang lịch tập
        if (pathInfo == null || pathInfo.equals("/")) {
            // Lấy danh sách lịch tập của member
            List<Schedule> schedules = scheduleDAO.getSchedulesByMemberId(loggedInUser.getId());

            // Tính toán số lượng các trạng thái
            int totalSchedules = schedules.size();
            int completedCount = 0;
            int confirmedCount = 0;
            int pendingCount = 0;
            int cancelledCount = 0;

            for (Schedule schedule : schedules) {
                String status = schedule.getStatus();
                if ("Completed".equals(status)) {
                    completedCount++;
                } else if ("Confirmed".equals(status)) {
                    confirmedCount++;
                } else if ("Pending".equals(status)) {
                    pendingCount++;
                } else if ("Cancelled".equals(status)) {
                    cancelledCount++;
                }
            }

            // Đặt các thuộc tính vào request
            request.setAttribute("schedules", schedules);
            request.setAttribute("totalSchedules", totalSchedules);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("confirmedCount", confirmedCount);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("cancelledCount", cancelledCount);

            // Lấy thông báo từ session nếu có
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");

            // Xóa thông báo khỏi session sau khi lấy
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");

            // Đặt thông báo vào request
            request.setAttribute("successMessage", successMessage);
            request.setAttribute("errorMessage", errorMessage);

            // Chuyển hướng đến trang JSP
            request.getRequestDispatcher("/member-schedule.jsp").forward(request, response);
        } else if (pathInfo.equals("/cancel")) {
            // Xử lý hủy lịch tập
            try {
                int scheduleId = Integer.parseInt(request.getParameter("id"));
                System.out.println("Đang xử lý hủy lịch tập ID: " + scheduleId + " bởi user: " + loggedInUser.getId());

                Schedule schedule = scheduleDAO.getScheduleById(scheduleId);

                if (schedule == null) {
                    System.out.println("Không tìm thấy lịch tập ID: " + scheduleId);
                    session.setAttribute("errorMessage", "Không tìm thấy lịch tập");
                    response.sendRedirect(request.getContextPath() + "/member-training-schedule");
                    return;
                }

                System.out.println("Thông tin lịch tập: MemberId=" +
                        (schedule.getMember() != null ? schedule.getMember().getId() : "null") +
                        ", Status=" + schedule.getStatus());

                // Kiểm tra xem lịch tập có thuộc về member hiện tại không
                if (schedule.getMember() == null || !schedule.getMember().getId().equals(loggedInUser.getId())) {
                    System.out.println("Không có quyền hủy lịch tập: User ID không khớp");
                    session.setAttribute("errorMessage", "Bạn không có quyền hủy lịch tập này");
                    response.sendRedirect(request.getContextPath() + "/member-training-schedule");
                    return;
                }

                // Kiểm tra xem lịch tập có thể hủy không
                if (!"Pending".equals(schedule.getStatus()) && !"Confirmed".equals(schedule.getStatus())) {
                    System.out.println("Không thể hủy lịch tập với trạng thái: " + schedule.getStatus());
                    session.setAttribute("errorMessage", "Không thể hủy lịch tập đã hoàn thành hoặc đã hủy");
                    response.sendRedirect(request.getContextPath() + "/member-training-schedule");
                    return;
                }

                // Cập nhật trạng thái thành Cancelled
                schedule.setStatus("Cancelled");
                schedule.setUpdatedAt(Instant.now());

                try {
                    System.out.println("Đang cập nhật trạng thái lịch tập ID: " + scheduleId + " thành Cancelled");
                    scheduleDAO.updateSchedule(schedule);
                    System.out.println("Hủy lịch tập thành công ID: " + scheduleId);
                    session.setAttribute("successMessage", "Hủy lịch tập thành công");
                } catch (Exception e) {
                    System.err.println("Lỗi khi hủy lịch tập ID " + scheduleId + ": " + e.getMessage());
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "Lỗi khi hủy lịch tập: " + e.getMessage());
                }

                // Chuyển hướng về trang lịch tập
                response.sendRedirect(request.getContextPath() + "/member-training-schedule");
            } catch (NumberFormatException e) {
                System.err.println("ID lịch tập không hợp lệ: " + e.getMessage());
                session.setAttribute("errorMessage", "ID lịch tập không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/member-training-schedule");
            } catch (Exception e) {
                System.err.println("Lỗi không xác định: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi server: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/member-training-schedule");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Kiểm tra người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (pathInfo != null && pathInfo.equals("/cancel")) {
            // Xử lý hủy lịch tập qua POST
            try {
                int scheduleId = Integer.parseInt(request.getParameter("id"));
                System.out.println("Đang xử lý hủy lịch tập ID: " + scheduleId + " bởi user: " + loggedInUser.getId());

                Schedule schedule = scheduleDAO.getScheduleById(scheduleId);

                if (schedule == null) {
                    System.out.println("Không tìm thấy lịch tập ID: " + scheduleId);
                    sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy lịch tập");
                    return;
                }

                System.out.println("Thông tin lịch tập: MemberId=" +
                        (schedule.getMember() != null ? schedule.getMember().getId() : "null") +
                        ", Status=" + schedule.getStatus());

                // Kiểm tra xem lịch tập có thuộc về member hiện tại không
                if (schedule.getMember() == null || !schedule.getMember().getId().equals(loggedInUser.getId())) {
                    System.out.println("Không có quyền hủy lịch tập: User ID không khớp");
                    sendErrorResponse(response, HttpServletResponse.SC_FORBIDDEN,
                            "Bạn không có quyền hủy lịch tập này");
                    return;
                }

                // Kiểm tra xem lịch tập có thể hủy không
                if (!"Pending".equals(schedule.getStatus()) && !"Confirmed".equals(schedule.getStatus())) {
                    System.out.println("Không thể hủy lịch tập với trạng thái: " + schedule.getStatus());
                    sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST,
                            "Không thể hủy lịch tập đã hoàn thành hoặc đã hủy");
                    return;
                }

                // Cập nhật trạng thái thành Cancelled
                schedule.setStatus("Cancelled");
                schedule.setUpdatedAt(Instant.now());

                try {
                    System.out.println("Đang cập nhật trạng thái lịch tập ID: " + scheduleId + " thành Cancelled");
                    scheduleDAO.updateSchedule(schedule);
                    System.out.println("Hủy lịch tập thành công ID: " + scheduleId);
                    sendSuccessResponse(response, "Hủy lịch tập thành công");
                } catch (Exception e) {
                    System.err.println("Lỗi khi hủy lịch tập ID " + scheduleId + ": " + e.getMessage());
                    e.printStackTrace();
                    sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "Lỗi khi hủy lịch tập: " + e.getMessage());
                }
            } catch (NumberFormatException e) {
                System.err.println("ID lịch tập không hợp lệ: " + e.getMessage());
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "ID lịch tập không hợp lệ");
            } catch (Exception e) {
                System.err.println("Lỗi không xác định: " + e.getMessage());
                e.printStackTrace();
                sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Lỗi server: " + e.getMessage());
            }
        }
    }

    private void sendSuccessResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", message);

        String jsonResponse = objectMapper.writeValueAsString(result);
        System.out.println("Sending success response: " + jsonResponse);

        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private void sendErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", message);

        String jsonResponse = objectMapper.writeValueAsString(error);
        System.out.println("Sending error response: " + jsonResponse);

        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }
}
package Controllers;

import Models.User;
import Services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ChangePasswordController")
public class ChangePasswordController extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Kiểm tra người dùng đã đăng nhập chưa
        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy thông tin từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra các trường không được để trống
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin!");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra mật khẩu hiện tại có đúng không
        User authenticatedUser = userService.authenticate(loggedInUser.getUserName(), currentPassword);
        if (authenticatedUser == null) {
            session.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng!");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra mật khẩu mới có trùng với mật khẩu cũ không
        if (newPassword.equals(currentPassword)) {
            session.setAttribute("errorMessage", "Mật khẩu mới không được trùng với mật khẩu cũ!");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra độ dài mật khẩu
        if (newPassword.length() < 8 || newPassword.length() > 32) {
            session.setAttribute("errorMessage", "Mật khẩu phải có độ dài từ 8 đến 32 ký tự!");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra có chữ hoa
        if (!newPassword.matches(".*[A-Z].*")) {
            session.setAttribute("errorMessage", "Mật khẩu phải chứa ít nhất 1 chữ cái viết hoa!");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra có ký tự đặc biệt
        if (!newPassword.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
            session.setAttribute("errorMessage", "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt!");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra mật khẩu xác nhận
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp với mật khẩu mới!");
            response.sendRedirect("profile");
            return;
        }

        // Cập nhật mật khẩu mới
        String result = userService.changePassword(loggedInUser.getId(), newPassword);

        if ("success".equals(result)) {
            session.setAttribute("successMessage", "Mật khẩu đã được thay đổi thành công!");
        } else {
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi thay đổi mật khẩu. Vui lòng thử lại sau!");
        }

        response.sendRedirect("profile");
    }
}
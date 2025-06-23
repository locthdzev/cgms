package Controllers;

import Services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ResetPasswordController")
public class ResetPasswordController extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Link đặt lại mật khẩu không hợp lệ!");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        boolean isValid = userService.validateResetToken(token);

        if (!isValid) {
            request.setAttribute("error", "Link đặt lại mật khẩu đã hết hạn hoặc không hợp lệ!");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Link đặt lại mật khẩu không hợp lệ!");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty() || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp với mật khẩu mới!");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        String result = userService.resetPassword(token, password);

        switch (result) {
            case "success":
                request.setAttribute("success",
                        "Mật khẩu của bạn đã được đặt lại thành công. Bạn có thể đăng nhập bằng mật khẩu mới.");
                break;
            case "invalid_token":
                request.setAttribute("error", "Link đặt lại mật khẩu đã hết hạn hoặc không hợp lệ!");
                break;
            default:
                request.setAttribute("error", "Đã xảy ra lỗi khi đặt lại mật khẩu. Vui lòng thử lại sau!");
                break;
        }

        request.getRequestDispatcher("reset-password.jsp").forward(request, response);
    }
}
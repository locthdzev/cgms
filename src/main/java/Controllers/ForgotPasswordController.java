package Controllers;

import Services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ForgotPasswordController")
public class ForgotPasswordController extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usernameOrEmail = request.getParameter("usernameOrEmail");

        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập tên đăng nhập hoặc email!");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        String result = userService.requestPasswordReset(usernameOrEmail);

        switch (result) {
            case "success":
                request.setAttribute("success",
                        "Một email đặt lại mật khẩu đã được gửi đến địa chỉ email của bạn. Vui lòng kiểm tra hộp thư đến của bạn.");
                break;
            case "not_found":
                request.setAttribute("error", "Không tìm thấy tài khoản với tên đăng nhập hoặc email này!");
                break;
            case "no_email":
                request.setAttribute("error",
                        "Tài khoản này không có địa chỉ email. Vui lòng liên hệ quản trị viên để được hỗ trợ.");
                break;
            case "email_error":
                request.setAttribute("error",
                        "Không thể gửi email đặt lại mật khẩu. Vui lòng thử lại sau hoặc liên hệ quản trị viên.");
                break;
            default:
                request.setAttribute("error", "Đã xảy ra lỗi khi xử lý yêu cầu của bạn. Vui lòng thử lại sau!");
                break;
        }

        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }
}
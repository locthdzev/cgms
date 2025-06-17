package Controllers;

import DAOs.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

public class VerifyEmail extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        // String token = request.getParameter("token");
        // TODO: kiểm tra token nếu có lưu token
        boolean ok = userDAO.activateUserByEmail(email);
        if (ok) {
            // Sinh GoogleId và lưu vào DB
            String googleId = UUID.randomUUID().toString();
            userDAO.updateGoogleIdByEmail(email, googleId);
            request.setAttribute("message", "Xác thực email thành công! Bạn có thể đăng nhập.");
        } else {
            request.setAttribute("error", "Xác thực thất bại hoặc tài khoản đã được xác thực!");
        }
        request.getRequestDispatcher("verify-email.jsp").forward(request, response);
    }
}
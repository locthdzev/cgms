package Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy session hiện tại
        HttpSession session = request.getSession(false);

        // Nếu session tồn tại, hủy nó
        if (session != null) {
            session.invalidate();
        }

        // Chuyển hướng về trang đăng nhập sử dụng sendRedirect
        response.sendRedirect("login");
    }
}
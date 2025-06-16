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

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        User user = userService.authenticate(username, password);
        if (user != null && "admin".equalsIgnoreCase(user.getRole())) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect("dashboard");
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu, hoặc bạn không phải Admin!");
            response.sendRedirect("login");
        }
    }
}
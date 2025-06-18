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
            User fullUser = userService.getUserById(user.getId());
            if (fullUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", fullUser);
                response.sendRedirect("dashboard");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Không thể lấy thông tin người dùng!");
                response.sendRedirect("login");
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu, hoặc bạn không phải Admin!");
            response.sendRedirect("login");
        }
    }
}
package Controllers;

import Models.User;
import Models.MemberLevel;
import Services.UserService;
import DAOs.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterController")
public class RegisterController extends HttpServlet {
    private UserService userService = new UserService();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phonenumber = request.getParameter("phonenumber");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        java.time.LocalDate dob = null;
        try {
            dob = java.time.LocalDate.parse(dobStr);
        } catch (Exception e) {
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (userDAO.getUserByUsername(username) != null) {
            request.setAttribute("error", "Tên đăng nhập đã được đăng ký!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (userDAO.getUserByUsername(email) != null) {
            request.setAttribute("error", "Email đã được đăng ký!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        User user = new User();
        user.setUserName(username);
        user.setFullName(fullname);
        user.setEmail(email);
        user.setPhoneNumber(phonenumber);
        user.setAddress(address);
        user.setGender(gender);
        user.setDob(dob);
        user.setGoogleId(null); // sẽ cập nhật khi xác thực email
        MemberLevel level = new MemberLevel();
        level.setId(1); // default level
        user.setLevel(level);
        String result = userService.registerMember(user, password);
        if ("pending".equals(result)) {
            response.sendRedirect("register?verify=1");
            return;
        } else {
            request.setAttribute("error", "Đăng ký thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
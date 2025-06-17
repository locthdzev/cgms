package Controllers;

import Models.User;
import Services.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.annotation.WebServlet;
import Models.MemberLevel;

@WebServlet({ "/user", "/addUser", "/editUser", "/updateUserStatus" })
public class UserController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String servletPath = req.getServletPath();
        if ("/user".equals(servletPath)) {
            // Hiển thị danh sách user
            List<User> users = userService.getAllUsers();
            req.setAttribute("userList", users);
            req.getRequestDispatcher("/user.jsp").forward(req, resp);
        } else if ("/addUser".equals(servletPath)) {
            // Hiển thị form thêm user
            req.getRequestDispatcher("/addUser.jsp").forward(req, resp);
        } else if ("/editUser".equals(servletPath)) {
            // Hiển thị form chỉnh sửa user
            String idStr = req.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                User user = userService.getUserById(id);
                req.setAttribute("user", user);
            }
            req.getRequestDispatcher("/editUser.jsp").forward(req, resp);
        } else if ("/updateUserStatus".equals(servletPath)) {
            // Cập nhật trạng thái người dùng (GET)
            String idStr = req.getParameter("id");
            String status = req.getParameter("status");
            if (idStr != null && status != null) {
                int id = Integer.parseInt(idStr);
                userService.updateUserStatus(id, status);
            }
            resp.sendRedirect(req.getContextPath() + "/user");
        }
        // ... các action khác nếu cần ...
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String servletPath = req.getServletPath();
        if ("/addUser".equals(servletPath)) {
            // Xử lý thêm user
            User user = new User();
            user.setEmail(req.getParameter("email"));
            user.setUserName(req.getParameter("userName"));
            user.setFullName(req.getParameter("fullName"));
            user.setPhoneNumber(req.getParameter("phoneNumber"));
            user.setAddress(req.getParameter("address"));
            user.setGender(req.getParameter("gender"));
            user.setRole(req.getParameter("role"));
            user.setStatus("Active"); // luôn là Active khi tạo mới
            String dobStr = req.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                user.setDob(java.time.LocalDate.parse(dobStr));
            }
            String rawPassword = req.getParameter("password");
            MemberLevel defaultLevel = new MemberLevel();
            defaultLevel.setId(1);
            user.setLevel(defaultLevel);
            boolean created = userService.createUser(user, rawPassword);
            if (created) {
                resp.sendRedirect(req.getContextPath() + "/user");
            } else {
                req.setAttribute("errorMessage", "Tạo người dùng thất bại. Vui lòng kiểm tra lại dữ liệu!");
                req.getRequestDispatcher("/addUser.jsp").forward(req, resp);
            }
        } else if ("/editUser".equals(servletPath)) {
            // Xử lý cập nhật user
            String idStr = req.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                User user = userService.getUserById(id);
                user.setEmail(req.getParameter("email"));
                user.setUserName(req.getParameter("userName"));
                user.setFullName(req.getParameter("fullName"));
                user.setPhoneNumber(req.getParameter("phoneNumber"));
                user.setAddress(req.getParameter("address"));
                user.setGender(req.getParameter("gender"));
                user.setRole(req.getParameter("role"));
                user.setStatus(req.getParameter("status"));
                String dobStr = req.getParameter("dob");
                if (dobStr != null && !dobStr.isEmpty()) {
                    user.setDob(java.time.LocalDate.parse(dobStr));
                }
                // Đảm bảo luôn có level
                MemberLevel defaultLevel = new MemberLevel();
                defaultLevel.setId(1);
                user.setLevel(defaultLevel);
                boolean updated = userService.updateUser(user);
                if (updated) {
                    resp.sendRedirect(req.getContextPath() + "/user");
                } else {
                    req.setAttribute("user", user);
                    req.setAttribute("errorMessage", "Cập nhật người dùng thất bại. Vui lòng kiểm tra lại dữ liệu!");
                    req.getRequestDispatcher("/editUser.jsp").forward(req, resp);
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/user");
            }
        } else if ("/updateUserStatus".equals(servletPath)) {
            // Cập nhật trạng thái người dùng (POST)
            String idStr = req.getParameter("id");
            String status = req.getParameter("status");
            if (idStr != null && status != null) {
                int id = Integer.parseInt(idStr);
                userService.updateUserStatus(id, status);
            }
            resp.sendRedirect(req.getContextPath() + "/user");
        }
    }
}
package Controllers;

import Models.User;
import Models.MemberLevel;
import Services.UserService;
import DAOs.UserDAO;
import Utilities.ConfigUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

@WebServlet("/GoogleLoginController")
public class GoogleLoginController extends HttpServlet {
    private UserService userService = new UserService();
    private UserDAO userDAO = new UserDAO();
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin từ Google response
            String credential = request.getParameter("credential");
            String g_csrf_token = request.getParameter("g_csrf_token");

            // Kiểm tra client ID trong token có khớp với client ID của ứng dụng không
            String expectedClientId = ConfigUtil.getGoogleClientId();

            // Verify the token (trong thực tế bạn nên xác thực token với Google API)
            // Decode JWT token để lấy thông tin người dùng
            String[] parts = credential.split("\\.");
            if (parts.length != 3) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid token format");
                return;
            }

            // Decode phần payload của JWT
            String payload = new String(java.util.Base64.getUrlDecoder().decode(parts[1]));
            JsonNode payloadJson = objectMapper.readTree(payload);

            // Kiểm tra client ID trong token có khớp với client ID của ứng dụng không
            String tokenClientId = payloadJson.get("aud").asText();
            if (!expectedClientId.equals(tokenClientId)) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid client ID");
                return;
            }

            // Lấy thông tin từ token
            String googleId = payloadJson.get("sub").asText();
            String email = payloadJson.get("email").asText();
            String name = payloadJson.get("name").asText();

            // Kiểm tra xem người dùng đã tồn tại chưa
            User user = userDAO.getUserByGoogleId(googleId);

            if (user == null) {
                // Kiểm tra xem email đã được sử dụng chưa
                user = userDAO.getUserByEmail(email);

                if (user != null) {
                    // Email đã tồn tại, cập nhật GoogleId
                    userDAO.updateGoogleIdByEmail(email, googleId);
                } else {
                    // Tạo người dùng mới
                    user = new User();
                    user.setEmail(email);
                    user.setFullName(name);
                    user.setUserName(email); // Sử dụng email làm username
                    user.setGoogleId(googleId);
                    user.setRole("Member");
                    user.setStatus("Active");

                    // Thiết lập MemberLevel mặc định (Level 1)
                    MemberLevel defaultLevel = new MemberLevel();
                    defaultLevel.setId(1); // Giả sử level ID 1 là level mặc định
                    user.setLevel(defaultLevel);

                    // Tạo một mật khẩu ngẫu nhiên (người dùng sẽ không cần dùng nó)
                    String randomPassword = java.util.UUID.randomUUID().toString();

                    // Đăng ký người dùng mới
                    userService.registerGoogleUser(user, randomPassword);
                }
            }

            // Lấy thông tin đầy đủ của người dùng
            User fullUser = userDAO.getUserByGoogleId(googleId);

            if (fullUser != null) {
                // Đăng nhập thành công, tạo session
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", fullUser);

                // Chuyển hướng tùy theo vai trò
                if ("Admin".equalsIgnoreCase(fullUser.getRole())) {
                    response.sendRedirect("dashboard");
                } else {
                    response.sendRedirect("member-dashboard");
                }
            } else {
                // Đăng nhập thất bại
                HttpSession session = request.getSession();
                session.setAttribute("error", "Đăng nhập bằng Google thất bại!");
                response.sendRedirect("login");
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Đăng nhập bằng Google thất bại: " + e.getMessage());
            response.sendRedirect("login");
        }
    }
}
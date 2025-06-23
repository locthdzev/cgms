package Services;

import DAOs.UserDAO;
import DAOs.PasswordResetTokenDAO;
import Models.User;
import Models.PasswordResetToken;
import java.security.MessageDigest;
import java.time.Instant;
import java.util.UUID;
import Utilities.EmailSender;

public class UserService {
    private UserDAO userDAO = new UserDAO();
    private PasswordResetTokenDAO passwordResetTokenDAO = new PasswordResetTokenDAO();

    public User authenticate(String username, String password) {
        User user = userDAO.getUserByUsername(username);
        if (user == null)
            return null;
        String hashedInput = hashPassword(password, user.getSalt());
        if (hashedInput.equals(user.getPassword())) {
            return user;
        }
        return null;
    }

    private String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            String salted = password + salt;
            byte[] hash = md.digest(salted.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public String registerMember(User user, String rawPassword) {
        // Tạo salt và hash password
        String salt = UUID.randomUUID().toString().replaceAll("-", "").substring(0, 16);
        String hashedPassword = hashPassword(rawPassword, salt);
        user.setSalt(salt);
        user.setPassword(hashedPassword);
        user.setRole("Member");
        user.setStatus("Pending");
        // Sinh mã xác thực
        String token = UUID.randomUUID().toString();
        user.setCreatedAt(java.time.Instant.now());
        boolean created = userDAO.createUser(user);
        if (created) {
            // Gửi email xác thực
            String link = "http://localhost:8080/VerifyEmail?token=" + token + "&email=" + user.getEmail();
            String subject = "Xác thực đăng ký CGMS";
            String content = Utilities.EmailSender.buildVerificationEmail(link);
            EmailSender.send(user.getEmail(), subject, content);
            // Lưu token vào DB (bạn cần tạo bảng lưu token hoặc lưu tạm vào user nếu có
            // field)
            // ...
            return "pending";
        }
        return "fail";
    }

    public String registerGoogleUser(User user, String rawPassword) {
        // Tạo salt và hash password
        String salt = UUID.randomUUID().toString().replaceAll("-", "").substring(0, 16);
        String hashedPassword = hashPassword(rawPassword, salt);
        user.setSalt(salt);
        user.setPassword(hashedPassword);

        // Đảm bảo MemberLevel được thiết lập
        if (user.getLevel() == null) {
            Models.MemberLevel defaultLevel = new Models.MemberLevel();
            defaultLevel.setId(1); // Level mặc định
            user.setLevel(defaultLevel);
        }

        // Người dùng Google đã được xác thực qua Google OAuth
        user.setCreatedAt(java.time.Instant.now());
        boolean created = userDAO.createUser(user);

        if (created) {
            return "success";
        }
        return "fail";
    }

    public java.util.List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    public boolean updateUser(User user) {
        user.setUpdatedAt(java.time.Instant.now());
        return userDAO.updateUser(user);
    }

    public boolean updateUserStatus(int userId, String status) {
        return userDAO.updateUserStatus(userId, status);
    }

    public boolean createUser(User user, String rawPassword) {
        // Tạo salt và hash password
        String salt = java.util.UUID.randomUUID().toString().replaceAll("-", "").substring(0, 16);
        String hashedPassword = hashPassword(rawPassword, salt);
        user.setSalt(salt);
        user.setPassword(hashedPassword);
        user.setCreatedAt(java.time.Instant.now());
        return userDAO.createUser(user);
    }

    // Phương thức tạo yêu cầu đặt lại mật khẩu
    public String requestPasswordReset(String usernameOrEmail) {
        User user = null;

        // Kiểm tra xem đầu vào là username hay email
        if (usernameOrEmail.contains("@")) {
            user = userDAO.getUserByEmail(usernameOrEmail);
        } else {
            user = userDAO.getUserByUsername(usernameOrEmail);
        }

        if (user == null) {
            return "not_found";
        }

        // Kiểm tra xem user có email không
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return "no_email";
        }

        // Lấy thông tin đầy đủ của user để đảm bảo có đủ thông tin
        User fullUser = userDAO.getUserById(user.getId());
        if (fullUser == null || fullUser.getEmail() == null || fullUser.getEmail().trim().isEmpty()) {
            return "no_email";
        }

        // Vô hiệu hóa tất cả các token cũ của người dùng
        passwordResetTokenDAO.invalidateAllUserTokens(fullUser.getId());

        // Tạo token mới
        String tokenString = UUID.randomUUID().toString();
        PasswordResetToken token = new PasswordResetToken();
        token.setUser(fullUser);
        token.setToken(tokenString);
        token.setStatus("Active");
        token.setCreatedAt(Instant.now());

        // Token hết hạn sau 24 giờ
        token.setExpiryDate(Instant.now().plusSeconds(86400));

        boolean tokenCreated = passwordResetTokenDAO.createToken(token);

        if (tokenCreated) {
            try {
                // Gửi email với link đặt lại mật khẩu
                String resetLink = "http://localhost:8080/reset-password?token=" + tokenString;
                String subject = "Đặt lại mật khẩu - CoreFit Gym Management System";
                String content = buildPasswordResetEmail(fullUser.getFullName(), resetLink);
                EmailSender.send(fullUser.getEmail(), subject, content);
                return "success";
            } catch (Exception e) {
                // Nếu có lỗi khi gửi email, vô hiệu hóa token và trả về lỗi
                passwordResetTokenDAO.invalidateToken(tokenString);
                e.printStackTrace();
                return "email_error";
            }
        }

        return "error";
    }

    // Phương thức xác thực token và đặt lại mật khẩu
    public String resetPassword(String token, String newPassword) {
        if (!passwordResetTokenDAO.isTokenValid(token)) {
            return "invalid_token";
        }

        PasswordResetToken resetToken = passwordResetTokenDAO.getTokenByTokenString(token);
        if (resetToken == null) {
            return "invalid_token";
        }

        User user = resetToken.getUser();

        // Lấy thông tin đầy đủ của user để đảm bảo các trường khác không bị mất
        User fullUser = userDAO.getUserById(user.getId());
        if (fullUser == null) {
            return "error";
        }

        // Tạo salt mới và hash mật khẩu mới
        String salt = UUID.randomUUID().toString().replaceAll("-", "").substring(0, 16);
        String hashedPassword = hashPassword(newPassword, salt);

        // Chỉ cập nhật mật khẩu, salt và updatedAt, giữ nguyên các trường khác
        fullUser.setPassword(hashedPassword);
        fullUser.setSalt(salt);
        fullUser.setUpdatedAt(Instant.now());

        boolean updated = userDAO.updateUser(fullUser);

        if (updated) {
            // Đánh dấu token đã sử dụng
            passwordResetTokenDAO.invalidateToken(token);
            return "success";
        }

        return "error";
    }

    // Phương thức kiểm tra token có hợp lệ không
    public boolean validateResetToken(String token) {
        return passwordResetTokenDAO.isTokenValid(token);
    }

    // Phương thức tạo nội dung email đặt lại mật khẩu
    private String buildPasswordResetEmail(String name, String resetLink) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<style>"
                + "body { font-family: Arial, sans-serif; line-height: 1.6; }"
                + ".container { width: 100%; max-width: 600px; margin: 0 auto; padding: 20px; }"
                + ".header { background-color: #4a6cf7; color: white; padding: 20px; text-align: center; }"
                + ".content { padding: 20px; background-color: #f9f9f9; }"
                + ".button { display: inline-block; padding: 10px 20px; background-color: #4a6cf7; color: white; text-decoration: none; border-radius: 5px; }"
                + ".footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "<div class='header'><h2>Đặt lại mật khẩu</h2></div>"
                + "<div class='content'>"
                + "<p>Xin chào " + name + ",</p>"
                + "<p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn tại CoreFit Gym Management System.</p>"
                + "<p>Để đặt lại mật khẩu, vui lòng nhấp vào liên kết dưới đây:</p>"
                + "<p style='text-align: center;'><a class='button' href='" + resetLink + "'>Đặt lại mật khẩu</a></p>"
                + "<p>Liên kết này sẽ hết hạn sau 24 giờ.</p>"
                + "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>"
                + "</div>"
                + "<div class='footer'>"
                + "<p>© " + java.time.Year.now().getValue()
                + " CoreFit Gym Management System. Tất cả các quyền được bảo lưu.</p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";
    }
}
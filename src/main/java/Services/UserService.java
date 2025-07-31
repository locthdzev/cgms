package Services;

import DAOs.UserDAO;
import DAOs.PasswordResetTokenDAO;
import Models.User;
import Models.PasswordResetToken;
import Utilities.MinioUtil;
import java.security.MessageDigest;
import java.time.Instant;
import java.util.UUID;
import Utilities.EmailSender;
import java.io.InputStream;

public class UserService {
    private UserDAO userDAO = new UserDAO();
    private PasswordResetTokenDAO passwordResetTokenDAO = new PasswordResetTokenDAO();
    private static final String CERTIFICATE_IMAGES_FOLDER = "Certificates";

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

    // Phương thức đăng ký Google user và gửi email thông tin tài khoản
    public String registerGoogleUserWithEmail(User user, String rawPassword) {
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
            try {
                // Gửi email với thông tin tài khoản
                String subject = "Thông tin tài khoản CGMS - Chào mừng bạn!";
                String content = EmailSender.buildAccountCredentialsEmail(
                        user.getFullName(),
                        user.getUserName(),
                        rawPassword);
                EmailSender.send(user.getEmail(), subject, content);
                return "success";
            } catch (Exception e) {
                // Nếu có lỗi khi gửi email, vẫn trả về success vì tài khoản đã được tạo
                e.printStackTrace();
                System.err.println("Lỗi khi gửi email thông tin tài khoản: " + e.getMessage());
                return "success";
            }
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

    public boolean updateUserWithPassword(User user, String newPassword) {
        // Tạo salt mới và hash mật khẩu mới
        String salt = UUID.randomUUID().toString().replaceAll("-", "").substring(0, 16);
        String hashedPassword = hashPassword(newPassword, salt);

        // Cập nhật mật khẩu và salt mới
        user.setPassword(hashedPassword);
        user.setSalt(salt);
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
        return "<div style='background:#f4f4f7;padding:40px 0;font-family:Arial,sans-serif;'>"
                + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);padding:32px;'>"
                + "<h2 style='color:#2d3748;text-align:center;margin-bottom:24px;'>Đặt lại mật khẩu CGMS</h2>"
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Xin chào <b>" + name + "</b>,</p>"
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn tại <b>CoreFit Gym Management System</b>.</p>"
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Để đặt lại mật khẩu, vui lòng nhấp vào nút bên dưới:</p>"
                + "<div style='text-align:center;margin:30px 0;'>"
                + "<a href='" + resetLink
                + "' style='display:inline-block;padding:12px 30px;background:#4299e1;color:#fff;text-decoration:none;border-radius:6px;font-weight:bold;font-size:16px;'>Đặt lại mật khẩu</a>"
                + "</div>"
                + "<div style='background:#fff5f5;border-radius:8px;padding:20px;margin:20px 0;border-left:4px solid #f56565;'>"
                + "<p style='margin:0;font-size:14px;color:#742a2a;'><strong>Lưu ý quan trọng:</strong></p>"
                + "<p style='margin:8px 0 0 0;font-size:14px;color:#742a2a;'>• Liên kết này sẽ hết hạn sau 24 giờ</p>"
                + "<p style='margin:4px 0 0 0;font-size:14px;color:#742a2a;'>• Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</p>"
                + "</div>"
                + "<p style='font-size:14px;color:#718096;text-align:center;margin-top:20px;'>Để đảm bảo bảo mật tài khoản, chúng tôi khuyến nghị bạn sử dụng mật khẩu mạnh bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</p>"
                + "<hr style='border:none;border-top:1px solid #e2e8f0;margin:32px 0;'>"
                + "<p style='font-size:12px;color:#a0aec0;text-align:center;'>© 2024 CoreFit Gym Management System</p>"
                + "</div></div>";
    }

    // Phương thức đổi mật khẩu cho người dùng đã đăng nhập
    public String changePassword(int userId, String newPassword) {
        // Lấy thông tin đầy đủ của user
        User user = userDAO.getUserById(userId);
        if (user == null) {
            return "error";
        }

        // Tạo salt mới và hash mật khẩu mới
        String salt = UUID.randomUUID().toString().replaceAll("-", "").substring(0, 16);
        String hashedPassword = hashPassword(newPassword, salt);

        // Cập nhật mật khẩu và salt mới
        user.setPassword(hashedPassword);
        user.setSalt(salt);
        user.setUpdatedAt(Instant.now());

        boolean updated = userDAO.updateUser(user);

        if (updated) {
            return "success";
        }

        return "error";
    }

    /**
     * Upload certificate image to MinIO
     * 
     * @param inputStream The input stream of the image file
     * @param fileName    Original file name
     * @param contentType Content type of the file
     * @return The URL of the uploaded image
     */
    public String uploadCertificateImage(InputStream inputStream, String fileName, String contentType)
            throws Exception {
        return MinioUtil.uploadFile(inputStream, fileName, contentType, CERTIFICATE_IMAGES_FOLDER);
    }
}
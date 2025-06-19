package Services;

import DAOs.UserDAO;
import Models.User;
import java.security.MessageDigest;
import java.util.UUID;
import Utilities.EmailSender;

public class UserService {
    private UserDAO userDAO = new UserDAO();

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
}
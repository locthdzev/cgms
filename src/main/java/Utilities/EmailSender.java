package Utilities;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeUtility;

public class EmailSender {
    public static void send(String to, String subject, String content) {
        final String username = "academix.verify@gmail.com";
        final String password = "ntwk imbk eqbs fsht";
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
            message.setContent(content, "text/html; charset=UTF-8");
            Transport.send(message);
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }

    // Hàm tạo template email xác thực chuyên nghiệp
    public static String buildVerificationEmail(String verifyLink) {
        return "<div style='background:#f4f4f7;padding:40px 0;font-family:Arial,sans-serif;'>"
                + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);padding:32px;'>"
                + "<h2 style='color:#2d3748;text-align:center;margin-bottom:24px;'>Xác thực đăng ký CGMS</h2>"
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Cảm ơn bạn đã đăng ký tài khoản tại <b>CoreFit Gym Management System</b>!</p>"
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Để hoàn tất quá trình đăng ký, vui lòng nhấp vào nút xác thực bên dưới:</p>"
                + "<div style='text-align:center;margin:30px 0;'>"
                + "<a href='" + verifyLink
                + "' style='display:inline-block;padding:12px 30px;background:#48bb78;color:#fff;text-decoration:none;border-radius:6px;font-weight:bold;font-size:16px;'>Xác thực tài khoản</a>"
                + "</div>"
                + "<div style='background:#f0fff4;border-radius:8px;padding:20px;margin:20px 0;border-left:4px solid #48bb78;'>"
                + "<p style='margin:0;font-size:14px;color:#22543d;'><strong>Lưu ý:</strong> Nếu nút không hoạt động, bạn có thể sao chép và dán liên kết sau vào trình duyệt:</p>"
                + "<p style='margin:8px 0 0 0;font-size:12px;color:#22543d;word-break:break-all;'>" + verifyLink
                + "</p>"
                + "</div>"
                + "<p style='font-size:14px;color:#718096;text-align:center;margin-top:20px;'>Sau khi xác thực thành công, bạn có thể đăng nhập và sử dụng đầy đủ các tính năng của hệ thống.</p>"
                + "<hr style='border:none;border-top:1px solid #e2e8f0;margin:32px 0;'>"
                + "<p style='font-size:12px;color:#a0aec0;text-align:center;'>© 2024 CoreFit Gym Management System</p>"
                + "</div></div>";
    }

    // Hàm tạo template email gửi thông tin tài khoản cho người dùng đăng nhập
    // Google lần đầu
    public static String buildAccountCredentialsEmail(String fullName, String username, String password) {
        return "<div style='background:#f4f4f7;padding:40px 0;font-family:Arial,sans-serif;'>"
                + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);padding:32px;'>"
                + "<h2 style='color:#2d3748;text-align:center;margin-bottom:24px;'>Chào mừng đến với CGMS!</h2>"
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Xin chào <b>" + fullName + "</b>,</p>"
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Cảm ơn bạn đã đăng nhập vào <b>CoreFit Gym Management System</b> bằng tài khoản Google!</p>"
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Chúng tôi đã tạo tài khoản cho bạn với thông tin sau:</p>"
                + "<div style='background:#f7fafc;border-radius:8px;padding:20px;margin:20px 0;border-left:4px solid #4299e1;'>"
                + "<p style='margin:8px 0;font-size:16px;color:#2d3748;'><strong>Tên đăng nhập:</strong> " + username
                + "</p>"
                + "<p style='margin:8px 0;font-size:16px;color:#2d3748;'><strong>Mật khẩu:</strong> " + password
                + "</p>"
                + "</div>"
                + "<p style='font-size:14px;color:#718096;text-align:center;margin-top:20px;'>Vui lòng lưu trữ thông tin này một cách an toàn. Bạn có thể sử dụng thông tin này để đăng nhập trực tiếp vào hệ thống khi cần thiết.</p>"
                + "<p style='font-size:14px;color:#e53e3e;text-align:center;font-weight:bold;'>Khuyến nghị: Hãy đổi mật khẩu sau khi đăng nhập để đảm bảo bảo mật tài khoản!</p>"
                + "<hr style='border:none;border-top:1px solid #e2e8f0;margin:32px 0;'>"
                + "<p style='font-size:12px;color:#a0aec0;text-align:center;'>© 2024 CoreFit Gym Management System</p>"
                + "</div></div>";
    }

    // Hàm tạo mật khẩu ngẫu nhiên an toàn
    public static String generateSecurePassword(int length) {
        String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lowerCase = "abcdefghijklmnopqrstuvwxyz";
        String numbers = "0123456789";
        String specialChars = "@#$%&*!";
        String allChars = upperCase + lowerCase + numbers + specialChars;

        java.security.SecureRandom random = new java.security.SecureRandom();
        StringBuilder password = new StringBuilder();

        // Đảm bảo có ít nhất 1 ký tự từ mỗi loại
        password.append(upperCase.charAt(random.nextInt(upperCase.length())));
        password.append(lowerCase.charAt(random.nextInt(lowerCase.length())));
        password.append(numbers.charAt(random.nextInt(numbers.length())));
        password.append(specialChars.charAt(random.nextInt(specialChars.length())));

        // Tạo các ký tự còn lại
        for (int i = 4; i < length; i++) {
            password.append(allChars.charAt(random.nextInt(allChars.length())));
        }

        // Trộn lại các ký tự
        char[] passwordArray = password.toString().toCharArray();
        for (int i = passwordArray.length - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            char temp = passwordArray[i];
            passwordArray[i] = passwordArray[j];
            passwordArray[j] = temp;
        }

        return new String(passwordArray);
    }
}
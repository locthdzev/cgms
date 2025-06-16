package Utilities;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeUtility;

public class EmailSender {
    public static void send(String to, String subject, String content) {
        final String username = "academix.verify@gmail.com"; // Thay bằng email gửi
        final String password = "ntwk imbk eqbs fsht"; // Thay bằng app password
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
                + "<p style='font-size:16px;color:#4a5568;text-align:center;'>Vui lòng nhấn vào liên kết bên dưới để xác thực email và hoàn tất đăng ký:</p>"
                + "<p style='font-size:14px;word-break:break-all;text-align:center;'><a href='" + verifyLink + "'>"
                + verifyLink + "</a></p>"
                + "<hr style='border:none;border-top:1px solid #e2e8f0;margin:32px 0;'>"
                + "<p style='font-size:12px;color:#a0aec0;text-align:center;'>© 2024 CoreFit Gym Management System</p>"
                + "</div></div>";
    }
}
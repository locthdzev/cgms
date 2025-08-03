package Services;

import Models.MemberPackage;
import Models.User;
import Models.Package;
import java.time.format.DateTimeFormatter;

public class MembershipCardService {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    /**
     * Tạo thẻ tập HTML cho member (dùng cho xem trên web)
     */
    public static String generateMembershipCard(MemberPackage memberPackage) {
        return generateMembershipCard(memberPackage, true);
    }

    /**
     * Tạo thẻ tập HTML cho email (không hiển thị buổi còn lại)
     */
    public static String generateMembershipCardForEmail(MemberPackage memberPackage) {
        return generateMembershipCard(memberPackage, false);
    }

    /**
     * Tạo thẻ tập HTML cho member
     */
    private static String generateMembershipCard(MemberPackage memberPackage, boolean showRemainingSessions) {
        User member = memberPackage.getMember();
        Package packageInfo = memberPackage.getPackageField();

        // Tạo member ID duy nhất
        String memberId = generateMemberId(member.getId());

        return buildMembershipCardHTML(member, packageInfo, memberPackage, memberId, showRemainingSessions);
    }

    /**
     * Tạo member ID duy nhất
     */
    private static String generateMemberId(Integer userId) {
        return String.format("CF%04d", userId);
    }

    /**
     * Tạo HTML cho thẻ tập
     */
    private static String buildMembershipCardHTML(User member, Package packageInfo,
            MemberPackage memberPackage, String memberId, boolean showRemainingSessions) {

        String memberName = member.getFullName();
        if (memberName == null || memberName.trim().isEmpty()) {
            memberName = member.getUserName();
        }
        String memberEmail = member.getEmail() != null ? member.getEmail() : "N/A";
        String packageName = packageInfo.getName();
        String startDate = memberPackage.getStartDate().format(DATE_FORMATTER);
        String endDate = memberPackage.getEndDate().format(DATE_FORMATTER);
        String remainingSessions = showRemainingSessions ? memberPackage.getRemainingSessions().toString() : "";

        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<title>Thẻ tập CORE-FIT GYM</title>" +
                "<style>" +
                "* { margin: 0; padding: 0; box-sizing: border-box; }" +
                "body { " +
                "font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; " +
                "background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); " +
                "min-height: 100vh; " +
                "display: flex; " +
                "align-items: center; " +
                "justify-content: center; " +
                "padding: 20px; " +
                "}" +
                ".card-container { " +
                "perspective: 1000px; " +
                "}" +
                ".membership-card { " +
                "width: 400px; " +
                "height: 220px; " +
                "background: linear-gradient(135deg, #ff6b35 0%, #ff8a65 100%); " +
                "border-radius: 20px; " +
                "box-shadow: 0 20px 40px rgba(0,0,0,0.3), 0 15px 12px rgba(0,0,0,0.2); " +
                "position: relative; " +
                "overflow: hidden; " +
                "color: white; " +
                "transform-style: preserve-3d; " +
                "transition: transform 0.3s ease; " +
                "}" +
                ".membership-card:hover { " +
                "transform: rotateY(5deg) rotateX(5deg); " +
                "}" +
                ".card-bg { " +
                "position: absolute; " +
                "top: -50%; " +
                "right: -50%; " +
                "width: 200%; " +
                "height: 200%; " +
                "background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%); " +
                "animation: rotate 20s linear infinite; " +
                "}" +
                "@keyframes rotate { " +
                "from { transform: rotate(0deg); } " +
                "to { transform: rotate(360deg); } " +
                "}" +
                ".card-header { " +
                "position: relative; " +
                "padding: 15px 20px 10px; " +
                "border-bottom: 1px solid rgba(255,255,255,0.2); " +
                "}" +
                ".gym-logo { " +
                "font-size: 18px; " +
                "font-weight: 800; " +
                "letter-spacing: 1px; " +
                "text-transform: uppercase; " +
                "}" +
                ".gym-tagline { " +
                "font-size: 10px; " +
                "opacity: 0.9; " +
                "font-weight: 300; " +
                "margin-top: 2px; " +
                "}" +
                ".member-id-badge { " +
                "position: absolute; " +
                "top: 15px; " +
                "right: 20px; " +
                "background: rgba(255,255,255,0.25); " +
                "padding: 4px 10px; " +
                "border-radius: 12px; " +
                "font-size: 10px; " +
                "font-weight: 600; " +
                "backdrop-filter: blur(10px); " +
                "}" +
                ".card-body { " +
                "position: relative; " +
                "padding: 15px 20px; " +
                "height: calc(100% - 65px); " +
                "display: flex; " +
                "flex-direction: column; " +
                "justify-content: space-between; " +
                "}" +
                ".member-info { " +
                "flex: 1; " +
                "}" +
                ".member-name { " +
                "font-size: 20px; " +
                "font-weight: 700; " +
                "margin-bottom: 4px; " +
                "text-transform: uppercase; " +
                "letter-spacing: 0.5px; " +
                "text-shadow: 0 2px 4px rgba(0,0,0,0.3); " +
                "}" +
                ".member-email { " +
                "font-size: 12px; " +
                "opacity: 0.9; " +
                "margin-bottom: 12px; " +
                "font-weight: 400; " +
                "}" +
                ".package-info { " +
                "background: rgba(255,255,255,0.15); " +
                "padding: 10px 12px; " +
                "border-radius: 12px; " +
                "backdrop-filter: blur(10px); " +
                "}" +
                ".package-name { " +
                "font-size: 13px; " +
                "font-weight: 600; " +
                "margin-bottom: 4px; " +
                "display: flex; " +
                "align-items: center; " +
                "}" +
                ".package-name .icon { " +
                "margin-right: 6px; " +
                "font-size: 14px; " +
                "}" +
                ".validity-info { " +
                "display: flex; " +
                "justify-content: space-between; " +
                "align-items: center; " +
                "font-size: 11px; " +
                "opacity: 0.95; " +
                "}" +
                ".validity-dates { " +
                "display: flex; " +
                "align-items: center; " +
                "}" +
                ".validity-dates .icon { " +
                "margin-right: 4px; " +
                "}" +
                (showRemainingSessions && !remainingSessions.isEmpty() ? ".sessions-remaining { " +
                        "background: rgba(255,255,255,0.25); " +
                        "padding: 3px 8px; " +
                        "border-radius: 20px; " +
                        "font-size: 10px; " +
                        "font-weight: 600; " +
                        "white-space: nowrap; " +
                        "}" : "")
                +
                ".print-info { " +
                "background: white; " +
                "color: #333; " +
                "margin-top: 30px; " +
                "padding: 20px; " +
                "border-radius: 15px; " +
                "box-shadow: 0 10px 30px rgba(0,0,0,0.1); " +
                "}" +
                ".print-info h3 { " +
                "color: #ff6b35; " +
                "margin-bottom: 15px; " +
                "font-size: 18px; " +
                "font-weight: 600; " +
                "}" +
                ".info-grid { " +
                "display: grid; " +
                "grid-template-columns: 1fr 1fr; " +
                "gap: 15px; " +
                "margin-bottom: 20px; " +
                "}" +
                ".info-item { " +
                "padding: 12px; " +
                "background: #f8f9fa; " +
                "border-radius: 8px; " +
                "border-left: 4px solid #ff6b35; " +
                "}" +
                ".info-label { " +
                "font-size: 12px; " +
                "color: #666; " +
                "font-weight: 500; " +
                "margin-bottom: 4px; " +
                "}" +
                ".info-value { " +
                "font-size: 14px; " +
                "color: #333; " +
                "font-weight: 600; " +
                "}" +
                ".instructions { " +
                "background: #e8f5e8; " +
                "padding: 15px; " +
                "border-radius: 10px; " +
                "border-left: 4px solid #28a745; " +
                "}" +
                ".instructions ul { " +
                "list-style: none; " +
                "margin: 0; " +
                "}" +
                ".instructions li { " +
                "padding: 5px 0; " +
                "font-size: 14px; " +
                "color: #2d5a2d; " +
                "position: relative; " +
                "padding-left: 20px; " +
                "}" +
                ".instructions li:before { " +
                "content: '✓'; " +
                "position: absolute; " +
                "left: 0; " +
                "color: #28a745; " +
                "font-weight: bold; " +
                "}" +
                "@media print { " +
                "body { background: white; min-height: auto; } " +
                ".print-info { display: none; } " +
                ".membership-card { box-shadow: 0 2px 10px rgba(0,0,0,0.1); } " +
                "}" +
                "@media (max-width: 480px) { " +
                ".membership-card { width: 350px; height: 200px; } " +
                ".member-name { font-size: 16px; } " +
                ".package-name { font-size: 12px; } " +
                "}" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='card-container'>" +
                "<div class='membership-card'>" +
                "<div class='card-bg'></div>" +
                "<div class='card-header'>" +
                "<div class='gym-logo'>🏋️ CORE-FIT GYM</div>" +
                "<div class='gym-tagline'>Premium Fitness Experience</div>" +
                "<div class='member-id-badge'>" + memberId + "</div>" +
                "</div>" +
                "<div class='card-body'>" +
                "<div class='member-info'>" +
                "<div class='member-name'>" + memberName + "</div>" +
                "<div class='member-email'>📧 " + memberEmail + "</div>" +
                "</div>" +
                "<div class='package-info'>" +
                "<div class='package-name'>" +
                "<span class='icon'>💎</span>" + packageName +
                "</div>" +
                "<div class='validity-info'>" +
                "<div class='validity-dates'>" +
                "<span class='icon'>📅</span>" + startDate + " - " + endDate +
                "</div>" +
                (showRemainingSessions && !remainingSessions.isEmpty()
                        ? "<div class='sessions-remaining'>" + remainingSessions + " buổi</div>"
                        : "")
                +
                "</div>" +
                "</div>" +
                "</div>" +
                "</div>" +

                "<div class='print-info'>" +
                "<h3>📋 Thông tin thẻ tập</h3>" +
                "<div class='info-grid'>" +
                "<div class='info-item'>" +
                "<div class='info-label'>Thành viên</div>" +
                "<div class='info-value'>" + memberName + "</div>" +
                "</div>" +
                "<div class='info-item'>" +
                "<div class='info-label'>Email</div>" +
                "<div class='info-value'>" + memberEmail + "</div>" +
                "</div>" +
                "<div class='info-item'>" +
                "<div class='info-label'>Gói tập</div>" +
                "<div class='info-value'>" + packageName + "</div>" +
                "</div>" +
                "<div class='info-item'>" +
                "<div class='info-label'>Thời hạn</div>" +
                "<div class='info-value'>" + startDate + " - " + endDate + "</div>" +
                "</div>" +
                "</div>" +
                "<div class='instructions'>" +
                "<ul>" +
                "<li>Xuất trình thẻ này khi vào phòng tập</li>" +
                "<li>Có thể in ra giấy hoặc lưu trên điện thoại</li>" +
                "<li>Liên hệ reception nếu cần hỗ trợ: 1900-COREFIT</li>" +
                (showRemainingSessions && !remainingSessions.isEmpty()
                        ? "<li>Còn lại " + remainingSessions + " buổi tập</li>"
                        : "")
                +
                "</ul>" +
                "</div>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    /**
     * Tạo email template với thẻ tập
     */
    public static String buildMembershipCardEmail(MemberPackage memberPackage) {
        User member = memberPackage.getMember();
        Package packageInfo = memberPackage.getPackageField();
        String memberName = member.getFullName();
        if (memberName == null || memberName.trim().isEmpty()) {
            memberName = member.getUserName();
        }
        String memberEmail = member.getEmail() != null ? member.getEmail() : "N/A";
        String packageName = packageInfo.getName();
        String startDate = memberPackage.getStartDate().format(DATE_FORMATTER);
        String endDate = memberPackage.getEndDate().format(DATE_FORMATTER);
        String memberId = generateMemberId(member.getId());

        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<meta http-equiv='X-UA-Compatible' content='IE=edge'>" +
                "<title>Thẻ tập CORE-FIT GYM</title>" +
                "</head>" +
                "<body style='margin:0;padding:0;background-color:#f4f4f7;font-family:Arial,sans-serif;'>" +

                "<!-- Main Container -->" +
                "<table width='100%' cellpadding='0' cellspacing='0' border='0' style='background-color:#f4f4f7;padding:40px 0;'>"
                +
                "<tr>" +
                "<td align='center'>" +

                "<!-- Email Content -->" +
                "<table width='680' cellpadding='0' cellspacing='0' border='0' style='max-width:680px;background-color:#ffffff;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.05);margin:0 auto;'>"
                +

                "<!-- Header -->" +
                "<tr>" +
                "<td style='padding:32px 32px 24px;text-align:center;'>" +
                "<h1 style='color:#2d3748;margin:0 0 16px;font-size:28px;font-weight:700;'>🎉 Chúc mừng!</h1>" +
                "<h2 style='color:#4a5568;margin:0 0 8px;font-size:20px;font-weight:600;'>Bạn đã đăng ký thành công!</h2>"
                +
                "<p style='color:#4a5568;margin:0;font-size:16px;'>Xin chào <strong>" + memberName + "</strong>,</p>" +
                "</td>" +
                "</tr>" +

                "<!-- Welcome Message -->" +
                "<tr>" +
                "<td style='padding:0 32px 24px;text-align:center;'>" +
                "<p style='color:#4a5568;margin:0 0 16px;font-size:16px;line-height:1.5;'>Cảm ơn bạn đã đăng ký gói tập <strong style='color:#ff6b35;'>"
                + packageName + "</strong> tại <strong style='color:#ff6b35;'>CORE-FIT GYM</strong>!</p>" +
                "<p style='color:#4a5568;margin:0;font-size:16px;line-height:1.5;'>Thanh toán của bạn đã được xử lý thành công. Dưới đây là thẻ tập của bạn:</p>"
                +
                "</td>" +
                "</tr>" +

                "<!-- Membership Card -->" +
                "<tr>" +
                "<td style='padding:0 32px 24px;text-align:center;'>" +

                "<!-- Card Container -->" +
                "<table width='400' cellpadding='0' cellspacing='0' border='0' style='max-width:400px;margin:0 auto;background:linear-gradient(135deg, #ff6b35 0%, #ff8a65 100%);border-radius:20px;box-shadow:0 8px 20px rgba(0,0,0,0.15);overflow:hidden;'>"
                +

                "<!-- Card Header -->" +
                "<tr>" +
                "<td style='padding:20px 24px 12px;border-bottom:1px solid rgba(255,255,255,0.2);position:relative;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0' border='0'>" +
                "<tr>" +
                "<td style='color:white;'>" +
                "<div style='font-size:18px;font-weight:800;letter-spacing:1px;text-transform:uppercase;margin-bottom:4px;'>🏋️ CORE-FIT GYM</div>"
                +
                "<div style='font-size:11px;opacity:0.9;font-weight:300;'>Premium Fitness Experience</div>" +
                "</td>" +
                "<td align='right' style='color:white;'>" +
                "<div style='background:rgba(255,255,255,0.25);padding:6px 12px;border-radius:12px;font-size:11px;font-weight:600;display:inline-block;'>"
                + memberId + "</div>" +
                "</td>" +
                "</tr>" +
                "</table>" +
                "</td>" +
                "</tr>" +

                "<!-- Card Body -->" +
                "<tr>" +
                "<td style='padding:20px 24px;color:white;'>" +

                "<!-- Member Info -->" +
                "<div style='margin-bottom:16px;'>" +
                "<div style='font-size:22px;font-weight:700;margin-bottom:6px;text-transform:uppercase;letter-spacing:0.5px;text-shadow:0 2px 4px rgba(0,0,0,0.3);'>"
                + memberName + "</div>" +
                "<div style='font-size:13px;opacity:0.9;margin-bottom:0;font-weight:400;'>📧 " + memberEmail + "</div>"
                +
                "</div>" +

                "<!-- Package Info -->" +
                "<div style='background:rgba(255,255,255,0.15);padding:12px 16px;border-radius:12px;backdrop-filter:blur(10px);'>"
                +
                "<div style='font-size:14px;font-weight:600;margin-bottom:6px;display:flex;align-items:center;'>" +
                "<span style='margin-right:8px;font-size:16px;'>💎</span>" + packageName +
                "</div>" +
                "<div style='font-size:12px;opacity:0.95;display:flex;justify-content:space-between;align-items:center;'>"
                +
                "<span>📅 " + startDate + " - " + endDate + "</span>" +
                "</div>" +
                "</div>" +

                "</td>" +
                "</tr>" +

                "</table>" +

                "</td>" +
                "</tr>" +

                "<!-- Important Notes -->" +
                "<tr>" +
                "<td style='padding:24px 32px;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0' border='0' style='background:#f0fff4;border-radius:8px;border-left:4px solid #48bb78;'>"
                +
                "<tr>" +
                "<td style='padding:20px;'>" +
                "<p style='margin:0 0 8px;font-size:14px;color:#22543d;font-weight:600;'>📌 Lưu ý quan trọng:</p>" +
                "<table cellpadding='0' cellspacing='0' border='0'>" +
                "<tr><td style='color:#22543d;font-size:14px;padding:2px 0;'>✓ Thẻ tập có hiệu lực đến " + endDate
                + "</td></tr>" +
                "<tr><td style='color:#22543d;font-size:14px;padding:2px 0;'>✓ Vui lòng xuất trình thẻ này khi đến phòng tập</td></tr>"
                +
                "<tr><td style='color:#22543d;font-size:14px;padding:2px 0;'>✓ Bạn có thể in thẻ này ra giấy hoặc lưu trên điện thoại</td></tr>"
                +
                "<tr><td style='color:#22543d;font-size:14px;padding:2px 0;'>✓ Liên hệ reception nếu cần hỗ trợ: 1900-COREFIT</td></tr>"
                +
                "</table>" +
                "</td>" +
                "</tr>" +
                "</table>" +
                "</td>" +
                "</tr>" +

                "<!-- Footer Message -->" +
                "<tr>" +
                "<td style='padding:0 32px 32px;text-align:center;'>" +
                "<p style='color:#718096;margin:20px 0 0;font-size:14px;'>Chúc bạn có những buổi tập luyện hiệu quả tại CORE-FIT GYM! 💪</p>"
                +
                "<hr style='border:none;border-top:1px solid #e2e8f0;margin:32px 0;'>" +
                "<p style='color:#a0aec0;margin:0;font-size:12px;'>© 2024 CORE-FIT GYM Management System</p>" +
                "</td>" +
                "</tr>" +

                "</table>" +

                "</td>" +
                "</tr>" +
                "</table>" +

                "</body>" +
                "</html>";
    }
}
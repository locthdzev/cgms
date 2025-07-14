package Services;

import DAOs.PaymentDAO;
import DAOs.PaymentLinkDAO;
import DbConnection.DbConnection;
import Models.MemberPackage;
import Models.Payment;
import Models.PaymentLink;
import Models.Voucher;
import Utilities.ConfigUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import vn.payos.PayOS;
import vn.payos.type.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class PayOSService {
    private final String clientId;
    private final String apiKey;
    private final String checksumKey;
    private final String baseUrl;
    private final PayOS payOS;
    private final ObjectMapper objectMapper;
    private final PaymentDAO paymentDAO;
    private final PaymentLinkDAO paymentLinkDAO;

    public PayOSService() {
        // Đọc thông tin cấu hình từ app.properties
        this.clientId = ConfigUtil.getProperty("payos.client.id");
        this.apiKey = ConfigUtil.getProperty("payos.api.key");
        this.checksumKey = ConfigUtil.getProperty("payos.checksum.key");
        this.baseUrl = ConfigUtil.getProperty("payos.base.url");
        this.payOS = new PayOS(clientId, apiKey, checksumKey);
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.paymentDAO = new PaymentDAO();
        this.paymentLinkDAO = new PaymentLinkDAO();
    }

    public PaymentLink createPaymentLink(Payment payment, MemberPackage memberPackage, Voucher voucher) {
        try {
            // Tạo mã đơn hàng duy nhất
            long orderCodeLong = System.currentTimeMillis();
            String orderCode = "CGMS-" + orderCodeLong;

            // Tạo thông tin sản phẩm
            ItemData itemData = ItemData.builder()
                    .name(memberPackage.getPackageField().getName())
                    .quantity(1)
                    .price(payment.getAmount().intValue())
                    .build();

            List<ItemData> items = new ArrayList<>();
            items.add(itemData);

            // Giới hạn mô tả không quá 25 ký tự
            String description = "Thanh toán gói tập";
            if (description.length() > 25) {
                description = description.substring(0, 22) + "...";
            }

            // Tạo dữ liệu thanh toán
            PaymentData paymentData = PaymentData.builder()
                    .orderCode(orderCodeLong)
                    .amount(payment.getAmount().intValue())
                    .description(description)
                    .returnUrl(baseUrl + "/payment/success")
                    .cancelUrl(baseUrl + "/payment/cancel")
                    .items(items)
                    .build();

            // Gọi API tạo link thanh toán
            CheckoutResponseData responseData = payOS.createPaymentLink(paymentData);

            // Lưu thông tin phản hồi từ PayOS
            payment.setPaymentData(objectMapper.writeValueAsString(responseData));
            payment.setStatus("PENDING");
            payment.setUpdatedAt(Instant.now());

            // Cập nhật payment
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DbConnection.getConnection();
                String sql = "UPDATE Payments SET PaymentData = ?, Status = ?, UpdatedAt = ? WHERE PaymentId = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, payment.getPaymentData());
                stmt.setString(2, payment.getStatus());
                stmt.setTimestamp(3, Timestamp.from(payment.getUpdatedAt()));
                stmt.setInt(4, payment.getId());
                stmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (stmt != null)
                        stmt.close();
                    if (conn != null)
                        DbConnection.closeConnection(conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            // Tạo payment link
            PaymentLink paymentLink = paymentLinkDAO.createPaymentLink(
                    payment,
                    orderCode,
                    responseData.getCheckoutUrl(),
                    Instant.now().plus(24, ChronoUnit.HOURS));

            // Không cần cập nhật mã QR vào database nữa
            if (paymentLink != null && responseData.getQrCode() != null) {
                // Chỉ cập nhật đối tượng trong bộ nhớ
                paymentLink.setQrCode(responseData.getQrCode());
            }

            return paymentLink;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public PaymentLinkData getPaymentLinkInfo(String orderCode) {
        try {
            // Chuyển đổi orderCode từ String sang Long
            String numericPart = orderCode.replace("CGMS-", "");
            long orderCodeLong = Long.parseLong(numericPart);
            return payOS.getPaymentLinkInformation(orderCodeLong);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean cancelPaymentLink(String orderCode, String reason) {
        try {
            // Chuyển đổi orderCode từ String sang Long
            String numericPart = orderCode.replace("CGMS-", "");
            long orderCodeLong = Long.parseLong(numericPart);
            PaymentLinkData data = payOS.cancelPaymentLink(orderCodeLong, reason);
            return data != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public WebhookData verifyWebhookData(Webhook webhookData) {
        try {
            return payOS.verifyPaymentWebhookData(webhookData);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updatePaymentStatus(Payment payment, WebhookData webhookData) {
        try {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DbConnection.getConnection();

                // Cập nhật thông tin thanh toán
                String sql = "UPDATE Payments SET CallbackData = ?, TransactionId = ?, Status = ?, UpdatedAt = ? WHERE PaymentId = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, objectMapper.writeValueAsString(webhookData));
                stmt.setString(2, webhookData.getReference());
                stmt.setString(3, "COMPLETED");
                stmt.setTimestamp(4, Timestamp.from(Instant.now()));
                stmt.setInt(5, payment.getId());
                stmt.executeUpdate();
                stmt.close();

                // Cập nhật trạng thái của PaymentLink
                String orderCode = "CGMS-" + webhookData.getOrderCode();
                PaymentLink paymentLink = paymentLinkDAO.getPaymentLinkByOrderCode(orderCode);

                if (paymentLink != null) {
                    sql = "UPDATE Payment_Links SET Status = ?, UpdatedAt = ? WHERE PaymentLinkId = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, "COMPLETED");
                    stmt.setTimestamp(2, Timestamp.from(Instant.now()));
                    stmt.setInt(3, paymentLink.getId());
                    stmt.executeUpdate();
                    stmt.close();
                }

                // Cập nhật trạng thái của MemberPackage
                MemberPackage memberPackage = payment.getMemberPackage();
                if (memberPackage != null) {
                    sql = "UPDATE Member_Packages SET Status = ?, UpdatedAt = ? WHERE MemberPackageId = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, "ACTIVE");
                    stmt.setTimestamp(2, Timestamp.from(Instant.now()));
                    stmt.setInt(3, memberPackage.getId());
                    stmt.executeUpdate();
                }

                return true;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            } finally {
                try {
                    if (stmt != null)
                        stmt.close();
                    if (conn != null)
                        DbConnection.closeConnection(conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
package Controllers;

import DAOs.MemberPackageDAO;
import DAOs.PaymentDAO;
import DAOs.PaymentLinkDAO;
import DAOs.VoucherDAO;
import DAOs.MemberPurchaseHistoryDAO;
import Models.MemberPackage;
import Models.Payment;
import Models.PaymentLink;
import Models.User;
import Models.Voucher;
import Services.PayOSService;
import Services.MembershipCardService;
import Utilities.EmailSender;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import vn.payos.type.WebhookData;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "PaymentController", urlPatterns = { "/payment/*" })
public class PaymentController extends HttpServlet {
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final PaymentLinkDAO paymentLinkDAO = new PaymentLinkDAO();
    private final MemberPackageDAO memberPackageDAO = new MemberPackageDAO();
    private final VoucherDAO voucherDAO = new VoucherDAO();
    private final MemberPurchaseHistoryDAO memberPurchaseHistoryDAO = new MemberPurchaseHistoryDAO();
    private final PayOSService payOSService = new PayOSService();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final MembershipCardService membershipCardService = new MembershipCardService();
    private final EmailSender emailSender = new EmailSender();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/all-packages");
            return;
        }

        switch (pathInfo) {
            case "/checkout":
                processCheckout(request, response);
                break;
            case "/success":
                processSuccess(request, response);
                break;
            case "/cancel":
                processCancel(request, response);
                break;
            case "/check-status":
                checkPaymentStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/all-packages");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "";
        }

        switch (pathInfo) {
            case "/webhook":
                processWebhook(request, response);
                break;
            case "/process-payment":
                processPayment(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                break;
        }
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy memberPackageId từ request
            int memberPackageId = Integer.parseInt(request.getParameter("memberPackageId"));
            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);

            if (memberPackage == null) {
                response.sendRedirect(request.getContextPath() + "/all-packages?error=package_not_found");
                return;
            }

            // Lưu memberPackageId vào session để sử dụng sau khi chọn voucher
            HttpSession session = request.getSession();
            session.setAttribute("checkoutMemberPackageId", memberPackageId);

            // Chuyển hướng đến trang chọn voucher
            response.sendRedirect(request.getContextPath() + "/select-voucher.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/all-packages?error=checkout_error");
        }
    }

    private void checkPaymentStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int memberPackageId = Integer.parseInt(request.getParameter("memberPackageId"));

            // Lấy payment mới nhất của memberPackage
            List<Payment> payments = paymentDAO.getPaymentsByMemberPackageId(memberPackageId);
            Map<String, Object> result = new HashMap<>();

            if (payments != null && !payments.isEmpty()) {
                Payment payment = payments.get(0);
                result.put("status", payment.getStatus());
            } else {
                result.put("status", "PENDING");
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            objectMapper.writeValue(response.getOutputStream(), result);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Lỗi khi kiểm tra trạng thái thanh toán");
            objectMapper.writeValue(response.getOutputStream(), error);
        }
    }

    private void processSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin từ URL
            String paymentLinkId = request.getParameter("paymentLinkId");
            boolean isUpgrade = "true".equals(request.getParameter("isUpgrade"));

            if (paymentLinkId != null && !paymentLinkId.isEmpty()) {
                // Tìm payment link từ paymentLinkId
                int paymentLinkIdInt = Integer.parseInt(paymentLinkId);
                PaymentLink paymentLink = paymentLinkDAO.getPaymentLinkById(paymentLinkIdInt);

                if (paymentLink != null) {
                    // Kiểm tra trạng thái thanh toán với PayOS
                    vn.payos.type.PaymentLinkData paymentLinkData = payOSService
                            .getPaymentLinkInfo(paymentLink.getOrderCode());

                    if (paymentLinkData != null && "PAID".equals(paymentLinkData.getStatus())) {
                        // Lấy payment từ payment link
                        Payment payment = paymentLink.getPayment();

                        if (payment != null) {
                            // Cập nhật trạng thái thanh toán
                            String transactionId = paymentLinkData.getTransactions().get(0).getReference();
                            boolean updated = paymentDAO.updatePaymentStatus(payment.getId(), "COMPLETED",
                                    transactionId);

                            if (updated) {
                                // Cập nhật trạng thái PaymentLink
                                paymentLinkDAO.updatePaymentLinkStatus(paymentLink.getId(), "COMPLETED");

                                // Cập nhật trạng thái MemberPackage
                                MemberPackage memberPackage = payment.getMemberPackage();
                                if (memberPackage != null) {
                                    // Lấy thông tin đầy đủ của memberPackage
                                    memberPackage = memberPackageDAO.getMemberPackageById(memberPackage.getId());

                                    if (memberPackage != null) {
                                        // Cập nhật trạng thái gói thành ACTIVE
                                        boolean packageUpdated = memberPackageDAO
                                                .updateMemberPackageStatus(memberPackage.getId(), "ACTIVE");

                                        if (packageUpdated) {
                                            // Nếu là nâng cấp, vô hiệu hóa các gói tập cũ
                                            if (isUpgrade) {
                                                boolean deactivated = memberPackageDAO.deactivateActiveMemberPackages(
                                                        memberPackage.getMember().getId(), memberPackage.getId());
                                                if (deactivated) {
                                                    System.out
                                                            .println("Đã vô hiệu hóa các gói tập cũ của thành viên: " +
                                                                    memberPackage.getMember().getId());
                                                }
                                            }

                                            // Lưu lịch sử mua hàng
                                            memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);

                                            // Gửi email thông báo với thẻ tập (async)
                                            final MemberPackage finalMemberPackage = memberPackage;
                                            new Thread(() -> {
                                                try {
                                                    String subject = "🎉 Chúc mừng! Đăng ký gói tập thành công - CORE-FIT GYM";
                                                    String emailContent = MembershipCardService
                                                            .buildMembershipCardEmail(finalMemberPackage);
                                                    EmailSender.send(finalMemberPackage.getMember().getEmail(), subject,
                                                            emailContent);
                                                    System.out.println("Đã gửi email thẻ tập cho member: "
                                                            + finalMemberPackage.getMember().getEmail());
                                                } catch (Exception emailEx) {
                                                    System.err
                                                            .println("Lỗi khi gửi email thẻ tập: "
                                                                    + emailEx.getMessage());
                                                    emailEx.printStackTrace();
                                                }
                                            }).start();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Xử lý khi thanh toán thành công
            HttpSession session = request.getSession();
            session.setAttribute("paymentStatus", "success");
            response.sendRedirect(request.getContextPath() + "/profile?message=payment_success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/all-packages?error=payment_process_error");
        }
    }

    private void processCancel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý khi thanh toán bị hủy
        HttpSession session = request.getSession();
        session.setAttribute("paymentStatus", "cancelled");
        response.sendRedirect(request.getContextPath() + "/all-packages?message=payment_cancelled");
    }

    private void createPayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Lấy thông tin từ request
            int memberPackageId = Integer.parseInt(request.getParameter("memberPackageId"));
            String voucherCode = request.getParameter("voucherCode");

            // Lấy thông tin gói tập
            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);

            if (memberPackage == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid member package");
                return;
            }

            // Tính toán số tiền thanh toán
            BigDecimal amount = memberPackage.getTotalPrice();
            Voucher voucher = null;

            // Áp dụng voucher nếu có
            if (voucherCode != null && !voucherCode.isEmpty()) {
                voucher = voucherDAO.getVoucherByCode(voucherCode);

                if (voucher != null) {
                    // Kiểm tra voucher có hợp lệ không
                    if (voucher.getExpiryDate().isBefore(java.time.LocalDate.now())) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Voucher has expired");
                        return;
                    }

                    // Áp dụng giảm giá
                    if ("PERCENTAGE".equals(voucher.getDiscountType())) {
                        BigDecimal discountPercentage = voucher.getDiscountValue().divide(new BigDecimal(100));
                        BigDecimal discountAmount = amount.multiply(discountPercentage);
                        amount = amount.subtract(discountAmount);
                    } else if ("FIXED".equals(voucher.getDiscountType())) {
                        amount = amount.subtract(voucher.getDiscountValue());
                        if (amount.compareTo(BigDecimal.ZERO) < 0) {
                            amount = BigDecimal.ZERO;
                        }
                    }

                    // Cập nhật voucher vào gói tập
                    memberPackage.setVoucher(voucher);
                    memberPackage.setTotalPrice(amount);
                    memberPackageDAO.updateMemberPackage(memberPackage);
                }
            }

            // Tạo payment
            Payment payment = paymentDAO.createPayment(memberPackage, amount, "PAYOS");

            if (payment == null) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create payment");
                return;
            }

            // Tạo payment link qua PayOS
            PaymentLink paymentLink = payOSService.createPaymentLink(payment, memberPackage, voucher);

            if (paymentLink == null) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create payment link");
                return;
            }

            // Trả về URL thanh toán
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"paymentUrl\": \"" + paymentLink.getPaymentLinkUrl() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }

    private void processWebhook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Đọc dữ liệu webhook từ PayOS
        StringBuilder buffer = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }

        String webhookData = buffer.toString();

        try {
            // Xác thực và xử lý dữ liệu webhook
            @SuppressWarnings("unchecked")
            Map<String, Object> webhookMap = objectMapper.readValue(webhookData, Map.class);

            // Kiểm tra dữ liệu webhook
            if (!webhookMap.containsKey("data") || !webhookMap.containsKey("signature")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid webhook data format");
                return;
            }

            // Lấy thông tin từ webhook
            @SuppressWarnings("unchecked")
            Map<String, Object> data = (Map<String, Object>) webhookMap.get("data");
            String orderCode = "CGMS-" + data.get("orderCode").toString();

            // Tìm payment link từ orderCode
            PaymentLink paymentLink = paymentLinkDAO.getPaymentLinkByOrderCode(orderCode);

            if (paymentLink == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Payment link not found");
                return;
            }

            // Lấy payment từ payment link
            Payment payment = paymentLink.getPayment();

            if (payment == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Payment not found");
                return;
            }

            // Cập nhật trạng thái thanh toán
            String transactionId = data.get("reference").toString();
            boolean updated = paymentDAO.updatePaymentStatus(payment.getId(), "COMPLETED", transactionId);

            if (updated) {
                // Cập nhật trạng thái PaymentLink
                paymentLinkDAO.updatePaymentLinkStatus(paymentLink.getId(), "COMPLETED");

                // Cập nhật trạng thái MemberPackage
                MemberPackage memberPackage = payment.getMemberPackage();
                if (memberPackage != null) {
                    // Lấy thông tin đầy đủ của memberPackage
                    memberPackage = memberPackageDAO.getMemberPackageById(memberPackage.getId());

                    if (memberPackage != null) {
                        // Cập nhật trạng thái gói thành ACTIVE
                        boolean packageUpdated = memberPackageDAO.updateMemberPackageStatus(memberPackage.getId(),
                                "ACTIVE");

                        if (packageUpdated) {
                            // Lưu lịch sử mua hàng
                            memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);

                            // Gửi email thông báo với thẻ tập (webhook)
                            final MemberPackage finalMemberPackage = memberPackage;
                            new Thread(() -> {
                                try {
                                    String subject = "🎉 Chúc mừng! Đăng ký gói tập thành công - CORE-FIT GYM";
                                    String emailContent = MembershipCardService
                                            .buildMembershipCardEmail(finalMemberPackage);
                                    EmailSender.send(finalMemberPackage.getMember().getEmail(), subject, emailContent);
                                    System.out.println("Webhook: Đã gửi email thẻ tập cho member: "
                                            + finalMemberPackage.getMember().getEmail());
                                } catch (Exception emailEx) {
                                    System.err.println("Webhook: Lỗi khi gửi email thẻ tập: " + emailEx.getMessage());
                                    emailEx.printStackTrace();
                                }
                            }).start();
                        }
                    }
                }

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Webhook processed successfully");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Failed to update payment status");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error processing webhook: " + e.getMessage());
        }
    }

    /**
     * Xử lý thanh toán sau khi người dùng đã chọn voucher
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            // Lấy memberPackageId từ form thay vì từ session
            String memberPackageIdStr = request.getParameter("memberPackageId");
            System.out.println("memberPackageId from form: " + memberPackageIdStr);

            if (memberPackageIdStr == null || memberPackageIdStr.isEmpty()) {
                // Thử lấy từ session nếu không có trong form
                Integer sessionMemberPackageId = (Integer) session.getAttribute("checkoutMemberPackageId");
                System.out.println("memberPackageId from session: " + sessionMemberPackageId);

                if (sessionMemberPackageId != null) {
                    memberPackageIdStr = sessionMemberPackageId.toString();
                } else {
                    System.out.println("memberPackageId not found in form or session");
                    response.sendRedirect(
                            request.getContextPath() + "/all-packages?error=invalid_request");
                    return;
                }
            }

            Integer memberPackageId = Integer.parseInt(memberPackageIdStr);

            // Xóa dữ liệu session nếu có
            session.removeAttribute("checkoutMemberPackageId");

            // Lấy thông tin gói tập
            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);
            if (memberPackage == null) {
                response.sendRedirect(request.getContextPath() + "/all-packages?error=package_not_found");
                return;
            }

            // Lấy mã voucher từ form (nếu có)
            String voucherCode = request.getParameter("voucherCode");
            Voucher voucher = null;

            // Áp dụng voucher nếu có
            if (voucherCode != null && !voucherCode.isEmpty()) {
                voucher = voucherDAO.getVoucherByCode(voucherCode);

                // Kiểm tra voucher có hợp lệ không
                if (voucher == null) {
                    response.sendRedirect(request.getContextPath() + "/select-voucher.jsp?error=invalid_voucher");
                    return;
                }

                // Kiểm tra trạng thái voucher (Active thay vì ACTIVE)
                if (!"Active".equals(voucher.getStatus())
                        || voucher.getExpiryDate().isBefore(java.time.LocalDate.now())) {
                    response.sendRedirect(request.getContextPath() + "/select-voucher.jsp?error=expired_voucher");
                    return;
                }

                // Kiểm tra voucher có phải của member này hoặc là voucher dùng chung không
                User member = (User) session.getAttribute("loggedInUser");
                if (voucher.getMember() != null && !voucher.getMember().getId().equals(member.getId())) {
                    response.sendRedirect(request.getContextPath() + "/select-voucher.jsp?error=unauthorized_voucher");
                    return;
                }

                // Kiểm tra điều kiện giá trị tối thiểu
                if (voucher.getMinPurchase() != null
                        && memberPackage.getTotalPrice().compareTo(voucher.getMinPurchase()) < 0) {
                    response.sendRedirect(request.getContextPath()
                            + "/select-voucher.jsp?error=min_purchase_not_met&min=" + voucher.getMinPurchase());
                    return;
                }
            }

            // Tính toán giá sau khi áp dụng voucher
            BigDecimal finalPrice = memberPackage.getTotalPrice();
            if (voucher != null) {
                System.out.println("Applying voucher: " + voucher.getCode());
                System.out.println("Original price: " + finalPrice);
                System.out.println("Discount type: " + voucher.getDiscountType() + " (class: "
                        + voucher.getDiscountType().getClass().getName() + ")");
                System.out.println("Discount value: " + voucher.getDiscountValue());

                String discountType = voucher.getDiscountType().trim().toUpperCase();
                System.out.println("Normalized discount type: " + discountType);

                if (discountType.contains("PERCENT")) {
                    BigDecimal discountAmount = finalPrice.multiply(voucher.getDiscountValue())
                            .divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);
                    System.out.println("Discount amount (percent): " + discountAmount);
                    finalPrice = finalPrice.subtract(discountAmount);
                } else {
                    // Xử lý tất cả các loại giảm giá khác như giảm trực tiếp
                    System.out.println("Discount amount (fixed): " + voucher.getDiscountValue());
                    finalPrice = finalPrice.subtract(voucher.getDiscountValue());
                    if (finalPrice.compareTo(BigDecimal.ZERO) < 0) {
                        finalPrice = BigDecimal.ZERO;
                    }
                }

                System.out.println("Final price after discount: " + finalPrice);
            }

            // Kiểm tra xem đã có payment cho memberPackage này chưa
            Payment payment = null;
            PaymentLink paymentLink = null;

            // Tìm payment đã tồn tại
            List<Payment> payments = paymentDAO.getPaymentsByMemberPackageId(memberPackageId);
            if (payments != null && !payments.isEmpty()) {
                // Lấy payment gần nhất
                payment = payments.get(0);

                // Cập nhật lại số tiền nếu có voucher
                payment.setAmount(finalPrice);
                payment.setUpdatedAt(Instant.now());
                System.out.println("Updating existing payment with amount: " + finalPrice);
                paymentDAO.updatePayment(payment);
            } else {
                // Tạo mới payment
                System.out.println("Creating new payment with amount: " + finalPrice);
                payment = paymentDAO.createPayment(memberPackage, finalPrice, "PAYOS");
                if (payment == null) {
                    response.sendRedirect(
                            request.getContextPath() + "/all-packages?error=payment_creation_failed");
                    return;
                }
            }

            // Kiểm tra lại giá trị payment sau khi tạo/cập nhật
            System.out.println("Payment amount before creating link: " + payment.getAmount());

            // Tạo payment link
            System.out.println("Creating payment link with final price: " + finalPrice);
            paymentLink = payOSService.createPaymentLink(payment, memberPackage, voucher);
            if (paymentLink == null) {
                System.out.println("Failed to create payment link");
                response.sendRedirect(request.getContextPath()
                        + "/all-packages?error=payment_link_creation_failed");
                return;
            }

            // Log thông tin payment link
            System.out.println("Payment link created successfully");
            System.out.println("Payment link URL: " + paymentLink.getPaymentLinkUrl());

            // Chuyển hướng đến URL thanh toán của PayOS
            response.sendRedirect(paymentLink.getPaymentLinkUrl());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/all-packages?error=payment_process_error");
        }
    }
}
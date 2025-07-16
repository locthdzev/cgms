package Controllers;

import Models.User;
import Models.MemberPackage;
import Services.UserService;
import DAOs.MemberPackageDAO;
import DAOs.PaymentDAO;
import DAOs.PaymentLinkDAO;
import DAOs.MemberPurchaseHistoryDAO;
import Services.PayOSService;
import Models.Payment;
import Models.PaymentLink;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ProfileController")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 30 // 30MB
)
public class ProfileController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProfileController.class.getName());
    private UserService userService = new UserService();
    private MemberPackageDAO memberPackageDAO = new MemberPackageDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private PaymentLinkDAO paymentLinkDAO = new PaymentLinkDAO();
    private MemberPurchaseHistoryDAO memberPurchaseHistoryDAO = new MemberPurchaseHistoryDAO();
    private PayOSService payOSService = new PayOSService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Kiểm tra thông báo thanh toán thành công
        String message = request.getParameter("message");
        if (message != null && message.equals("payment_success")) {
            LOGGER.info("Xử lý thanh toán thành công cho user ID: " + loggedInUser.getId());
            // Xử lý cập nhật trạng thái thanh toán
            handlePaymentSuccess(loggedInUser.getId(), request);
        }

        // Lấy thông tin đầy đủ của user từ database
        User user = userService.getUserById(loggedInUser.getId());
        request.setAttribute("user", user);

        // Thêm thuộc tính để xác định nếu là PT
        boolean isPersonalTrainer = "Personal Trainer".equals(user.getRole());
        request.setAttribute("isPersonalTrainer", isPersonalTrainer);

        // Lấy danh sách gói tập hiện tại của thành viên
        if (!isPersonalTrainer) {
            List<MemberPackage> memberPackages = memberPackageDAO.getMemberPackagesByMemberId(loggedInUser.getId());
            request.setAttribute("memberPackages", memberPackages);
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    private void handlePaymentSuccess(int memberId, HttpServletRequest request) {
        try {
            // Lấy danh sách gói tập của thành viên có trạng thái PENDING
            List<MemberPackage> pendingPackages = memberPackageDAO.getPendingMemberPackagesByMemberId(memberId);

            // Lấy thông tin nâng cấp từ session
            HttpSession session = request.getSession();
            boolean isUpgrade = session.getAttribute("isUpgradePackage") != null
                    && (boolean) session.getAttribute("isUpgradePackage");
            Integer newMemberPackageId = (Integer) session.getAttribute("newMemberPackageId");

            // Xóa thông tin nâng cấp khỏi session sau khi đã sử dụng
            session.removeAttribute("isUpgradePackage");
            session.removeAttribute("newMemberPackageId");

            if (pendingPackages == null || pendingPackages.isEmpty()) {
                LOGGER.info("Không tìm thấy gói tập nào ở trạng thái PENDING cho member ID: " + memberId);
                return;
            }

            for (MemberPackage memberPackage : pendingPackages) {
                // Lấy payment liên quan đến gói tập
                List<Payment> payments = paymentDAO.getPaymentsByMemberPackageId(memberPackage.getId());

                if (payments == null || payments.isEmpty()) {
                    continue;
                }

                Payment payment = payments.get(0);
                LOGGER.info("Xử lý payment ID: " + payment.getId() + ", status: " + payment.getStatus());

                // Kiểm tra nếu payment đã hoàn thành nhưng gói tập vẫn PENDING
                if ("COMPLETED".equals(payment.getStatus()) && "PENDING".equals(memberPackage.getStatus())) {
                    // Cập nhật trạng thái gói tập thành ACTIVE
                    boolean updated = memberPackageDAO.updateMemberPackageStatus(memberPackage.getId(), "ACTIVE");

                    if (updated) {
                        // Luôn vô hiệu hóa các gói tập ACTIVE khác (trừ gói hiện tại)
                        boolean deactivated = memberPackageDAO.deactivateActiveMemberPackages(memberId,
                                memberPackage.getId());
                        if (deactivated) {
                            LOGGER.info("Đã vô hiệu hóa các gói tập khác của thành viên: " + memberId);
                        }

                        // Lưu lịch sử mua hàng
                        memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);
                        LOGGER.info("Cập nhật gói tập và lưu lịch sử thành công");
                    }
                }
                // Nếu payment vẫn PENDING nhưng URL trả về là payment_success
                else if ("PENDING".equals(payment.getStatus())) {
                    // Tìm payment link liên quan đến payment
                    List<PaymentLink> paymentLinks = paymentLinkDAO.getPaymentLinksByPaymentId(payment.getId());

                    if (paymentLinks != null && !paymentLinks.isEmpty()) {
                        PaymentLink paymentLink = paymentLinks.get(0);

                        try {
                            // Kiểm tra trạng thái thanh toán với PayOS
                            vn.payos.type.PaymentLinkData paymentLinkData = payOSService
                                    .getPaymentLinkInfo(paymentLink.getOrderCode());

                            if (paymentLinkData != null) {
                                if ("PAID".equals(paymentLinkData.getStatus()) &&
                                        paymentLinkData.getTransactions() != null &&
                                        !paymentLinkData.getTransactions().isEmpty()) {

                                    // Lấy TransactionId từ PayOS
                                    String transactionId = paymentLinkData.getTransactions().get(0).getReference();
                                    LOGGER.info("Lấy được TransactionId từ PayOS: " + transactionId);

                                    // Cập nhật trạng thái thanh toán thành COMPLETED với TransactionId thật
                                    boolean paymentUpdated = paymentDAO.updatePaymentStatus(payment.getId(),
                                            "COMPLETED", transactionId);

                                    if (paymentUpdated) {
                                        // Cập nhật trạng thái PaymentLink
                                        paymentLinkDAO.updatePaymentLinkStatus(paymentLink.getId(), "COMPLETED");

                                        // Cập nhật trạng thái gói tập thành ACTIVE
                                        boolean packageUpdated = memberPackageDAO
                                                .updateMemberPackageStatus(memberPackage.getId(), "ACTIVE");

                                        if (packageUpdated) {
                                            // Luôn vô hiệu hóa các gói tập ACTIVE khác (trừ gói hiện tại)
                                            boolean deactivated = memberPackageDAO
                                                    .deactivateActiveMemberPackages(memberId,
                                                            memberPackage.getId());
                                            if (deactivated) {
                                                LOGGER.info(
                                                        "Đã vô hiệu hóa các gói tập khác của thành viên: "
                                                                + memberId);
                                            }

                                            // Lưu lịch sử mua hàng
                                            memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);
                                            LOGGER.info("Cập nhật trạng thái và lưu lịch sử thành công");
                                        }
                                    }
                                } else {
                                    LOGGER.info(
                                            "PayOS không trả về trạng thái PAID hoặc không có thông tin transaction");
                                    // Nếu không có thông tin từ PayOS, vẫn cập nhật trạng thái
                                    String manualTransactionId = "MANUAL-" + System.currentTimeMillis();

                                    boolean paymentUpdated = paymentDAO.updatePaymentStatus(payment.getId(),
                                            "COMPLETED", manualTransactionId);

                                    if (paymentUpdated) {
                                        // Cập nhật trạng thái PaymentLink
                                        paymentLinkDAO.updatePaymentLinkStatus(paymentLink.getId(), "COMPLETED");

                                        // Cập nhật trạng thái gói tập thành ACTIVE
                                        boolean packageUpdated = memberPackageDAO
                                                .updateMemberPackageStatus(memberPackage.getId(), "ACTIVE");

                                        if (packageUpdated) {
                                            // Luôn vô hiệu hóa các gói tập ACTIVE khác (trừ gói hiện tại)
                                            boolean deactivated = memberPackageDAO
                                                    .deactivateActiveMemberPackages(memberId,
                                                            memberPackage.getId());
                                            if (deactivated) {
                                                LOGGER.info(
                                                        "Đã vô hiệu hóa các gói tập khác của thành viên: "
                                                                + memberId);
                                            }

                                            // Lưu lịch sử mua hàng
                                            memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);
                                            LOGGER.info("Cập nhật trạng thái và lưu lịch sử thành công (manual)");
                                        }
                                    }
                                }
                            } else {
                                LOGGER.warning("Không lấy được thông tin từ PayOS API");
                            }
                        } catch (Exception e) {
                            LOGGER.log(Level.SEVERE, "Lỗi khi gọi PayOS API", e);
                        }
                    } else {
                        // Nếu không có payment link, vẫn cập nhật trạng thái
                        String directTransactionId = "DIRECT-" + System.currentTimeMillis();

                        boolean paymentUpdated = paymentDAO.updatePaymentStatus(payment.getId(), "COMPLETED",
                                directTransactionId);

                        if (paymentUpdated) {
                            // Cập nhật trạng thái gói tập thành ACTIVE
                            boolean packageUpdated = memberPackageDAO.updateMemberPackageStatus(memberPackage.getId(),
                                    "ACTIVE");

                            if (packageUpdated) {
                                // Luôn vô hiệu hóa các gói tập ACTIVE khác (trừ gói hiện tại)
                                boolean deactivated = memberPackageDAO.deactivateActiveMemberPackages(memberId,
                                        memberPackage.getId());
                                if (deactivated) {
                                    LOGGER.info("Đã vô hiệu hóa các gói tập cũ của thành viên: " + memberId);
                                }

                                // Lưu lịch sử mua hàng
                                memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);
                                LOGGER.info("Cập nhật trạng thái và lưu lịch sử thành công (direct)");
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xử lý thanh toán thành công", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy thông tin đầy đủ của user từ database
        User user = userService.getUserById(loggedInUser.getId());

        // Cập nhật thông tin từ form
        user.setEmail(request.getParameter("email"));
        user.setUserName(request.getParameter("userName"));
        user.setFullName(request.getParameter("fullName"));
        user.setPhoneNumber(request.getParameter("phoneNumber"));
        user.setAddress(request.getParameter("address"));
        user.setGender(request.getParameter("gender"));

        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.isEmpty()) {
            user.setDob(LocalDate.parse(dobStr));
        }

        // Nếu là Personal Trainer, cập nhật thêm thông tin PT
        if ("Personal Trainer".equals(user.getRole())) {
            user.setZalo(request.getParameter("zalo"));
            user.setFacebook(request.getParameter("facebook"));
            user.setExperience(request.getParameter("experience"));

            // Xử lý upload chứng chỉ nếu có
            Part certificateFilePart = request.getPart("certificateImage");
            if (certificateFilePart != null && certificateFilePart.getSize() > 0) {
                String fileName = certificateFilePart.getSubmittedFileName();
                String contentType = certificateFilePart.getContentType();

                try {
                    // Upload to MinIO and get URL
                    String certificateImageUrl = userService.uploadCertificateImage(
                            certificateFilePart.getInputStream(), fileName, contentType);
                    user.setCertificateImageUrl(certificateImageUrl);
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "Lỗi khi tải lên chứng chỉ: " + e.getMessage());
                    response.sendRedirect("profile");
                    return;
                }
            }
        }

        // Cập nhật thông tin user
        boolean updated = userService.updateUser(user);

        if (updated) {
            // Cập nhật thông tin user trong session
            session.setAttribute("loggedInUser", user);
            session.setAttribute("successMessage", "Cập nhật thông tin thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật thông tin thất bại. Vui lòng thử lại!");
        }

        response.sendRedirect("profile");
    }
}
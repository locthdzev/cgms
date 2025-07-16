package Controllers;

import Models.Package;
import Models.MemberPackage;
import Models.User;
import Models.Payment;
import Models.PaymentLink;
import DAOs.PackageDAO;
import DAOs.MemberPackageDAO;
import DAOs.PaymentDAO;
import DAOs.PaymentLinkDAO;
import DAOs.MemberPurchaseHistoryDAO;
import Services.PayOSService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.time.LocalDate;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/member-packages-controller")
public class MemberPackageController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MemberPackageController.class.getName());

    private PackageDAO packageDAO = new PackageDAO();
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

        // Kiểm tra người dùng đã đăng nhập chưa
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra thông báo thanh toán thành công
        String message = request.getParameter("message");
        if (message != null && message.equals("payment_success")) {
            LOGGER.info("Xử lý thanh toán thành công cho user ID: " + loggedInUser.getId());
            // Xử lý cập nhật trạng thái thanh toán nếu cần
            handlePaymentSuccess(loggedInUser.getId(), request);
        }

        // Lấy danh sách gói tập của thành viên
        List<MemberPackage> memberPackages = memberPackageDAO.getMemberPackagesByMemberId(loggedInUser.getId());
        request.setAttribute("memberPackages", memberPackages);

        // Lấy danh sách gói tập có sẵn để đăng ký
        List<Package> availablePackages = packageDAO.getActivePackages();
        request.setAttribute("availablePackages", availablePackages);

        request.getRequestDispatcher("/member-packages.jsp").forward(request, response);
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
                        boolean deactivated = memberPackageDAO.deactivateActiveMemberPackages(
                                memberId, memberPackage.getId());
                        if (deactivated) {
                            LOGGER.info("Đã vô hiệu hóa các gói tập khác của thành viên: "
                                    + memberId);
                        } else {
                            LOGGER.warning(
                                    "Không thể vô hiệu hóa các gói tập khác của thành viên: "
                                            + memberId);
                        }

                        // Lưu lịch sử mua hàng
                        memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);
                        LOGGER.info("Cập nhật trạng thái và lưu lịch sử thành công");
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
                                            boolean deactivated = memberPackageDAO.deactivateActiveMemberPackages(
                                                    memberId, memberPackage.getId());
                                            if (deactivated) {
                                                LOGGER.info("Đã vô hiệu hóa các gói tập khác của thành viên: "
                                                        + memberId);
                                            } else {
                                                LOGGER.warning(
                                                        "Không thể vô hiệu hóa các gói tập khác của thành viên: "
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
                                            boolean deactivated = memberPackageDAO.deactivateActiveMemberPackages(
                                                    memberId, memberPackage.getId());
                                            if (deactivated) {
                                                LOGGER.info("Đã vô hiệu hóa các gói tập khác của thành viên: "
                                                        + memberId);
                                            } else {
                                                LOGGER.warning(
                                                        "Không thể vô hiệu hóa các gói tập khác của thành viên: "
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
                                    LOGGER.info("Đã vô hiệu hóa các gói tập khác của thành viên: " + memberId);
                                } else {
                                    LOGGER.warning(
                                            "Không thể vô hiệu hóa các gói tập khác của thành viên: " + memberId);
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

        // Kiểm tra người dùng đã đăng nhập chưa
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy thông tin từ form
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            try {
                // Đăng ký gói tập mới
                int packageId = Integer.parseInt(request.getParameter("packageId"));
                Package selectedPackage = packageDAO.getPackageById(packageId);

                // Kiểm tra xem có phải là nâng cấp gói tập không
                boolean isUpgrade = "true".equals(request.getParameter("isUpgrade"));
                LOGGER.info("Đăng ký gói tập mới, isUpgrade: " + isUpgrade);

                if (selectedPackage != null) {
                    // Tạo gói tập mới cho thành viên
                    MemberPackage memberPackage = new MemberPackage();
                    memberPackage.setMember(loggedInUser);
                    memberPackage.setPackageField(selectedPackage);
                    memberPackage.setTotalPrice(selectedPackage.getPrice());
                    memberPackage.setStartDate(LocalDate.now());
                    memberPackage.setEndDate(LocalDate.now().plusDays(selectedPackage.getDuration()));
                    memberPackage.setRemainingSessions(selectedPackage.getSessions());
                    memberPackage.setStatus("PENDING");

                    // Lưu vào database
                    int memberPackageId = memberPackageDAO.createMemberPackage(memberPackage);

                    if (memberPackageId > 0) {
                        // Không vô hiệu hóa các gói tập đang hoạt động ngay lập tức
                        // Chỉ vô hiệu hóa khi thanh toán thành công
                        // Lưu thông tin isUpgrade vào session để xử lý sau khi thanh toán
                        if (isUpgrade) {
                            session.setAttribute("isUpgradePackage", true);
                            session.setAttribute("newMemberPackageId", memberPackageId);
                            LOGGER.info(
                                    "Đánh dấu gói tập là nâng cấp, sẽ vô hiệu hóa gói cũ sau khi thanh toán thành công");
                        }

                        // Chuyển đến trang thanh toán
                        response.sendRedirect(
                                request.getContextPath() + "/payment/checkout?memberPackageId=" + memberPackageId);
                        return;
                    }
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi đăng ký gói tập", e);
            }
        }

        // Nếu có lỗi, quay lại trang gói tập
        response.sendRedirect(request.getContextPath() + "/member-packages-controller");
    }
}
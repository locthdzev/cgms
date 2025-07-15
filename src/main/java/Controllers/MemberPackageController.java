package Controllers;

import Models.Package;
import Models.MemberPackage;
import Models.User;
import Models.Payment;
import DAOs.PackageDAO;
import DAOs.MemberPackageDAO;
import DAOs.PaymentDAO;
import DAOs.PaymentLinkDAO;
import DAOs.MemberPurchaseHistoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.time.LocalDate;

@WebServlet("/member-packages-controller")
public class MemberPackageController extends HttpServlet {
    private PackageDAO packageDAO = new PackageDAO();
    private MemberPackageDAO memberPackageDAO = new MemberPackageDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private PaymentLinkDAO paymentLinkDAO = new PaymentLinkDAO();
    private MemberPurchaseHistoryDAO memberPurchaseHistoryDAO = new MemberPurchaseHistoryDAO();

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
            // Xử lý cập nhật trạng thái thanh toán nếu cần
            handlePaymentSuccess(loggedInUser.getId());
        }

        // Lấy danh sách gói tập của thành viên
        List<MemberPackage> memberPackages = memberPackageDAO.getMemberPackagesByMemberId(loggedInUser.getId());
        request.setAttribute("memberPackages", memberPackages);

        // Lấy danh sách gói tập có sẵn để đăng ký
        List<Package> availablePackages = packageDAO.getActivePackages();
        request.setAttribute("availablePackages", availablePackages);

        request.getRequestDispatcher("/member-packages.jsp").forward(request, response);
    }

    private void handlePaymentSuccess(int memberId) {
        try {
            // Lấy danh sách gói tập của thành viên có trạng thái PENDING
            List<MemberPackage> pendingPackages = memberPackageDAO.getPendingMemberPackagesByMemberId(memberId);

            for (MemberPackage memberPackage : pendingPackages) {
                // Lấy payment liên quan đến gói tập
                List<Payment> payments = paymentDAO.getPaymentsByMemberPackageId(memberPackage.getId());

                if (payments != null && !payments.isEmpty()) {
                    Payment payment = payments.get(0);

                    // Kiểm tra nếu payment đã hoàn thành nhưng gói tập vẫn PENDING
                    if ("COMPLETED".equals(payment.getStatus()) && "PENDING".equals(memberPackage.getStatus())) {
                        // Cập nhật trạng thái gói tập thành ACTIVE
                        boolean updated = memberPackageDAO.updateMemberPackageStatus(memberPackage.getId(), "ACTIVE");

                        if (updated) {
                            // Lưu lịch sử mua hàng
                            memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);
                        }
                    }
                    // Nếu payment vẫn PENDING nhưng URL trả về là payment_success
                    else if ("PENDING".equals(payment.getStatus())) {
                        // Cập nhật trạng thái thanh toán thành COMPLETED
                        boolean paymentUpdated = paymentDAO.updatePaymentStatus(payment.getId(), "COMPLETED", null);

                        if (paymentUpdated) {
                            // Cập nhật trạng thái gói tập thành ACTIVE
                            boolean packageUpdated = memberPackageDAO.updateMemberPackageStatus(memberPackage.getId(),
                                    "ACTIVE");

                            if (packageUpdated) {
                                // Lưu lịch sử mua hàng
                                memberPurchaseHistoryDAO.createPurchaseHistory(memberPackage, payment);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
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
                        // Chuyển đến trang thanh toán
                        response.sendRedirect(
                                request.getContextPath() + "/payment/checkout?memberPackageId=" + memberPackageId);
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Nếu có lỗi, quay lại trang gói tập
        response.sendRedirect(request.getContextPath() + "/member-packages-controller");
    }
}
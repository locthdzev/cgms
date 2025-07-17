package Controllers;

import Models.User;
import Models.MemberPackage;
import Models.MemberPurchaseHistory;
import Models.Payment;
import DAOs.MemberPackageDAO;
import DAOs.MemberPurchaseHistoryDAO;
import DAOs.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Logger;

@WebServlet("/package-history")
public class PackageHistoryController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(PackageHistoryController.class.getName());
    private MemberPackageDAO memberPackageDAO = new MemberPackageDAO();
    private MemberPurchaseHistoryDAO memberPurchaseHistoryDAO = new MemberPurchaseHistoryDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();

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

        // Lấy tất cả gói tập của thành viên (bao gồm cả đã hủy, hết hạn, v.v.)
        List<MemberPackage> allMemberPackages = memberPackageDAO.getMemberPackagesByMemberId(loggedInUser.getId());

        // Lọc ra chỉ các gói tập có trạng thái ACTIVE, EXPIRED, CANCELLED
        allMemberPackages.removeIf(pkg -> !("ACTIVE".equals(pkg.getStatus()) ||
                "EXPIRED".equals(pkg.getStatus()) ||
                "CANCELLED".equals(pkg.getStatus())));

        request.setAttribute("allMemberPackages", allMemberPackages);

        // Lấy lịch sử mua gói tập
        List<MemberPurchaseHistory> purchaseHistory = memberPurchaseHistoryDAO
                .getPurchaseHistoryByMemberId(loggedInUser.getId());
        request.setAttribute("purchaseHistory", purchaseHistory);

        // Lấy thông tin TransactionId từ bảng Payments
        Map<Integer, String> transactionIds = new HashMap<>();
        for (MemberPurchaseHistory history : purchaseHistory) {
            if (history.getMemberPackage() != null) {
                List<Payment> payments = paymentDAO.getPaymentsByMemberPackageId(history.getMemberPackage().getId());
                if (payments != null && !payments.isEmpty()) {
                    Payment payment = payments.get(0);
                    if (payment.getTransactionId() != null && !payment.getTransactionId().isEmpty()) {
                        transactionIds.put(history.getId(), payment.getTransactionId());
                    }
                }
            }
        }
        request.setAttribute("transactionIds", transactionIds);

        // Chuyển đến trang hiển thị lịch sử
        request.getRequestDispatcher("/package-history.jsp").forward(request, response);
    }
}
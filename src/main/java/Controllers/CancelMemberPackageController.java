package Controllers;

import DAOs.MemberPackageDAO;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/cancel-member-package")
public class CancelMemberPackageController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CancelMemberPackageController.class.getName());
    private MemberPackageDAO memberPackageDAO = new MemberPackageDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // Lấy ID của gói tập cần hủy
            String memberPackageIdStr = request.getParameter("memberPackageId");
            if (memberPackageIdStr == null || memberPackageIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "Không tìm thấy thông tin gói tập cần hủy!");
                response.sendRedirect("profile");
                return;
            }

            int memberPackageId = Integer.parseInt(memberPackageIdStr);

            // Cập nhật trạng thái gói tập thành CANCELLED
            boolean updated = memberPackageDAO.updateMemberPackageStatus(memberPackageId, "CANCELLED");

            if (updated) {
                session.setAttribute("successMessage", "Hủy gói tập thành công!");
            } else {
                session.setAttribute("errorMessage", "Hủy gói tập thất bại. Vui lòng thử lại sau!");
            }

            // Chuyển hướng về trang profile
            response.sendRedirect("profile");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi chuyển đổi memberPackageId", e);
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
            response.sendRedirect("profile");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi hủy gói tập", e);
            session.setAttribute("errorMessage", "Đã xảy ra lỗi khi hủy gói tập. Vui lòng thử lại sau!");
            response.sendRedirect("profile");
        }
    }
}
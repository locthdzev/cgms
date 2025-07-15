package Controllers;

import Models.Package;
import Models.User;
import DAOs.PackageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/all-packages")
public class AllPackagesController extends HttpServlet {
    private PackageDAO packageDAO = new PackageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy danh sách tất cả các gói tập có trạng thái Active
        List<Package> activePackages = packageDAO.getAllActivePackages();
        request.setAttribute("packages", activePackages);

        // Xử lý thông báo thành công và lỗi
        String message = request.getParameter("message");
        String error = request.getParameter("error");

        if (message != null) {
            String successMessage;
            switch (message) {
                case "register_success":
                    successMessage = "Đăng ký gói tập thành công!";
                    break;
                default:
                    successMessage = message;
                    break;
            }
            request.setAttribute("successMessage", successMessage);
        }

        if (error != null) {
            request.setAttribute("errorMessage", error);
        }

        // Chuyển đến trang hiển thị tất cả các gói tập
        request.getRequestDispatcher("/all-packages.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng tất cả các yêu cầu POST đến MemberPackageController
        // để xử lý đăng ký gói tập
        request.getRequestDispatcher("/member-packages-controller").forward(request, response);
    }
}
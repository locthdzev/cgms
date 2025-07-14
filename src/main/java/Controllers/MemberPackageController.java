package Controllers;

import Models.Package;
import Models.MemberPackage;
import Models.User;
import DAOs.PackageDAO;
import DAOs.MemberPackageDAO;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy danh sách các gói tập có sẵn
        List<Package> availablePackages = packageDAO.getAllActivePackages();
        request.setAttribute("availablePackages", availablePackages);

        // Lấy danh sách các gói tập của member đã đăng ký
        List<MemberPackage> memberPackages = memberPackageDAO.getMemberPackagesByUserId(loggedInUser.getId());
        request.setAttribute("memberPackages", memberPackages);

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

        // Chuyển đến trang hiển thị gói tập
        request.getRequestDispatcher("/member-packages.jsp").forward(request, response);
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

        String action = request.getParameter("action");

        if ("register".equals(action)) {
            // Xử lý đăng ký gói tập mới
            int packageId = Integer.parseInt(request.getParameter("packageId"));

            // Tạo đối tượng User
            User member = new User();
            member.setId(loggedInUser.getId());

            // Tạo đối tượng Package
            Package pkg = new Package();
            pkg.setId(packageId);

            // Tạo đối tượng MemberPackage
            MemberPackage memberPackage = new MemberPackage();
            memberPackage.setMember(member);
            memberPackage.setPackageField(pkg);

            boolean success = memberPackageDAO.createMemberPackage(memberPackage);

            if (success) {
                response.sendRedirect("member-packages-controller?message=register_success");
            } else {
                response.sendRedirect("member-packages-controller?error=register_failed");
            }
        } else {
            // Mặc định chuyển đến trang hiển thị gói tập
            doGet(request, response);
        }
    }
}
package Controllers;

import Models.Package;
import DAOs.PackageDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ListPackageServlet", urlPatterns = { "/listPackage" })
public class ListPackageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            PackageDAO packageDAO = new PackageDAO();

            // Xử lý tìm kiếm và lọc
            String searchTerm = request.getParameter("search");
            String status = request.getParameter("status");

            // Xử lý thông báo thành công và lỗi
            String message = request.getParameter("message");
            String error = request.getParameter("error");

            if (message != null) {
                String successMessage;
                switch (message) {
                    case "status_update_success":
                        successMessage = "Cập nhật trạng thái gói tập thành công!";
                        break;
                    case "add_success":
                        successMessage = "Thêm gói tập mới thành công!";
                        break;
                    case "edit_success":
                        successMessage = "Chỉnh sửa gói tập thành công!";
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

            List<Package> packages;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                packages = packageDAO.searchPackages(searchTerm);
            } else if (status != null && !status.trim().isEmpty()) {
                packages = packageDAO.getPackagesByStatus(status);
            } else {
                packages = packageDAO.getAllPackages();
            }

            request.setAttribute("packages", packages);
            request.getRequestDispatcher("/listPackage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách gói tập: " + e.getMessage());
            request.getRequestDispatcher("/listPackage.jsp").forward(request, response);
        }
    }
}

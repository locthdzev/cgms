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

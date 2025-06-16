package Controllers;

import Models.Package;
import DAOs.PackageDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.Instant;

@WebServlet(name = "UpdatePackageStatusServlet", urlPatterns = { "/updatePackageStatus" })
public class UpdatePackageStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");

            if (idStr == null || idStr.trim().isEmpty() || status == null || status.trim().isEmpty()) {
                response.sendRedirect("listPackage?error=Dữ+liệu+không+hợp+lệ");
                return;
            }

            int id = Integer.parseInt(idStr);
            PackageDAO packageDAO = new PackageDAO();
            Package pkg = packageDAO.getPackageById(id);

            if (pkg == null) {
                response.sendRedirect("listPackage?error=Không+tìm+thấy+gói+tập");
                return;
            }

            // Cập nhật trạng thái
            pkg.setStatus(status);
            pkg.setUpdatedAt(Instant.now());

            boolean success = packageDAO.updatePackage(pkg);

            if (success) {
                response.sendRedirect("listPackage?message=status_update_success");
            } else {
                response.sendRedirect("listPackage?error=Cập+nhật+trạng+thái+thất+bại");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("listPackage?error=ID+gói+tập+không+hợp+lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("listPackage?error=" + e.getMessage());
        }
    }
}

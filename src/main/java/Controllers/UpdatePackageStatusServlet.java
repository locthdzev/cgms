package Controllers;

import Models.Package;
import DAOs.PackageDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.Instant;

@WebServlet(name = "UpdatePackageStatusServlet", urlPatterns = { "/updatePackageStatus" })
public class UpdatePackageStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng từ GET sang POST để xử lý
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");

            if (idStr == null || idStr.trim().isEmpty() || status == null || status.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Dữ liệu không hợp lệ");
                response.sendRedirect("listPackage");
                return;
            }

            int id = Integer.parseInt(idStr);
            PackageDAO packageDAO = new PackageDAO();
            Package pkg = packageDAO.getPackageById(id);

            if (pkg == null) {
                session.setAttribute("errorMessage", "Không tìm thấy gói tập");
                response.sendRedirect("listPackage");
                return;
            }

            // Cập nhật trạng thái
            pkg.setStatus(status);
            pkg.setUpdatedAt(Instant.now());

            boolean success = packageDAO.updatePackage(pkg);

            if (success) {
                session.setAttribute("successMessage", "Cập nhật trạng thái gói tập thành công");
            } else {
                session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại");
            }
            response.sendRedirect("listPackage");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID gói tập không hợp lệ");
            response.sendRedirect("listPackage");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect("listPackage");
        }
    }
}

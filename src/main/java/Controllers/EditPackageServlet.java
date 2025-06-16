package Controllers;

import Models.Package;
import DAOs.PackageDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.Instant;

/**
 *
 * @author Admin
 */
@WebServlet(name = "EditPackageServlet", urlPatterns = { "/editPackage" })
public class EditPackageServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("listPackage?error=ID+gói+tập+không+hợp+lệ");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            PackageDAO packageDAO = new PackageDAO();
            Package pkg = packageDAO.getPackageById(id);

            if (pkg == null) {
                response.sendRedirect("listPackage?error=Không+tìm+thấy+gói+tập");
                return;
            }

            request.setAttribute("package", pkg);
            request.getRequestDispatcher("/editPackage.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("listPackage?error=ID+gói+tập+không+hợp+lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("listPackage?error=" + e.getMessage());
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy dữ liệu từ form
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String durationStr = request.getParameter("duration");
            String sessionsStr = request.getParameter("sessions");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            // Kiểm tra dữ liệu đầu vào
            if (idStr == null || idStr.trim().isEmpty() ||
                    name == null || name.trim().isEmpty() ||
                    priceStr == null || priceStr.trim().isEmpty() ||
                    durationStr == null || durationStr.trim().isEmpty()) {

                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");

                // Lấy lại thông tin gói tập để hiển thị lại form
                int id = Integer.parseInt(idStr);
                PackageDAO packageDAO = new PackageDAO();
                Package pkg = packageDAO.getPackageById(id);
                request.setAttribute("package", pkg);

                request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                return;
            }

            // Chuyển đổi dữ liệu
            int id = Integer.parseInt(idStr);
            BigDecimal price = new BigDecimal(priceStr);
            int duration = Integer.parseInt(durationStr);
            Integer sessions = null;
            if (sessionsStr != null && !sessionsStr.trim().isEmpty()) {
                sessions = Integer.parseInt(sessionsStr);
            }

            // Lấy thông tin gói tập hiện tại
            PackageDAO packageDAO = new PackageDAO();
            Package pkg = packageDAO.getPackageById(id);

            if (pkg == null) {
                response.sendRedirect("listPackage?error=Không+tìm+thấy+gói+tập");
                return;
            }

            // Cập nhật thông tin
            pkg.setName(name);
            pkg.setPrice(price);
            pkg.setDuration(duration);
            pkg.setSessions(sessions);
            pkg.setDescription(description);
            pkg.setStatus(status);
            pkg.setUpdatedAt(Instant.now());

            // Lưu vào database
            boolean success = packageDAO.updatePackage(pkg);

            if (success) {
                // Chuyển hướng đến trang danh sách gói tập với thông báo thành công
                response.sendRedirect("listPackage?message=update_success");
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật gói tập. Vui lòng thử lại.");
                request.setAttribute("package", pkg);
                request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu số không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}

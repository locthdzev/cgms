package Controllers;

import Models.Package;
import DAOs.PackageDAO;
import Utilities.VNDPriceValidator;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "ID gói tập không hợp lệ");
            response.sendRedirect("listPackage");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            PackageDAO packageDAO = new PackageDAO();
            Package pkg = packageDAO.getPackageById(id);

            if (pkg == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Không tìm thấy gói tập");
                response.sendRedirect("listPackage");
                return;
            }

            request.setAttribute("package", pkg);
            request.getRequestDispatcher("/editPackage.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "ID gói tập không hợp lệ");
            response.sendRedirect("listPackage");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            response.sendRedirect("listPackage");
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
        HttpSession session = request.getSession();

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

            // Parse ID
            int id;
            try {
                id = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID gói tập không hợp lệ");
                response.sendRedirect("listPackage");
                return;
            }

            // Validate và parse giá tiền VND
            VNDPriceValidator.ValidationResult priceValidation = VNDPriceValidator.validatePriceString(priceStr);
            if (!priceValidation.isValid()) {
                request.setAttribute("errorMessage", priceValidation.getErrorMessage());

                // Lấy lại thông tin gói tập để hiển thị lại form
                PackageDAO packageDAO = new PackageDAO();
                Package pkg = packageDAO.getPackageById(id);
                request.setAttribute("package", pkg);
                request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                return;
            }
            BigDecimal price = priceValidation.getValidatedPrice();

            // Parse duration
            int duration;
            try {
                duration = Integer.parseInt(durationStr);
                if (duration <= 0) {
                    request.setAttribute("errorMessage", "Thời hạn phải lớn hơn 0");

                    PackageDAO packageDAO = new PackageDAO();
                    Package pkg = packageDAO.getPackageById(id);
                    request.setAttribute("package", pkg);
                    request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                    return;
                }
                if (duration > 3650) {
                    request.setAttribute("errorMessage", "Thời hạn không được vượt quá 3650 ngày (10 năm)");

                    PackageDAO packageDAO = new PackageDAO();
                    Package pkg = packageDAO.getPackageById(id);
                    request.setAttribute("package", pkg);
                    request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Thời hạn phải là số nguyên");

                PackageDAO packageDAO = new PackageDAO();
                Package pkg = packageDAO.getPackageById(id);
                request.setAttribute("package", pkg);
                request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                return;
            }

            // Parse sessions (optional)
            Integer sessions = null;
            if (sessionsStr != null && !sessionsStr.trim().isEmpty()) {
                try {
                    sessions = Integer.parseInt(sessionsStr);
                    if (sessions <= 0) {
                        request.setAttribute("errorMessage", "Số buổi tập phải lớn hơn 0");

                        PackageDAO packageDAO = new PackageDAO();
                        Package pkg = packageDAO.getPackageById(id);
                        request.setAttribute("package", pkg);
                        request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                        return;
                    }
                    if (sessions > 1000) {
                        request.setAttribute("errorMessage", "Số buổi tập không được vượt quá 1000");

                        PackageDAO packageDAO = new PackageDAO();
                        Package pkg = packageDAO.getPackageById(id);
                        request.setAttribute("package", pkg);
                        request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Số buổi tập phải là số nguyên");

                    PackageDAO packageDAO = new PackageDAO();
                    Package pkg = packageDAO.getPackageById(id);
                    request.setAttribute("package", pkg);
                    request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                    return;
                }
            }

            // Validate giá theo loại gói tập
            VNDPriceValidator.ValidationResult packageValidation = VNDPriceValidator.validatePriceForPackageType(price,
                    duration, sessions);
            if (!packageValidation.isValid()) {
                request.setAttribute("errorMessage", packageValidation.getErrorMessage());

                PackageDAO packageDAO = new PackageDAO();
                Package pkg = packageDAO.getPackageById(id);
                request.setAttribute("package", pkg);
                request.getRequestDispatcher("/editPackage.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin gói tập hiện tại
            PackageDAO packageDAO = new PackageDAO();
            Package pkg = packageDAO.getPackageById(id);

            if (pkg == null) {
                session.setAttribute("errorMessage", "Không tìm thấy gói tập");
                response.sendRedirect("listPackage");
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
                session.setAttribute("successMessage", "Cập nhật gói tập \"" + name + "\" thành công!");
                response.sendRedirect("listPackage");
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

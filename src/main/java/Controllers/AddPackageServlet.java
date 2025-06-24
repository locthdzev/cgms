/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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

/**
 *
 * @author Admin
 */
@WebServlet(name = "AddPackageServlet", urlPatterns = { "/addPackage" })
public class AddPackageServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
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
        request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
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
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String durationStr = request.getParameter("duration");
            String sessionsStr = request.getParameter("sessions");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            // Kiểm tra dữ liệu đầu vào cơ bản
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tên gói tập không được để trống");
                request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                return;
            }

            if (durationStr == null || durationStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Thời hạn không được để trống");
                request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                return;
            }

            // Validate và parse giá tiền VND
            VNDPriceValidator.ValidationResult priceValidation = VNDPriceValidator.validatePriceString(priceStr);
            if (!priceValidation.isValid()) {
                request.setAttribute("errorMessage", priceValidation.getErrorMessage());
                request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                return;
            }
            BigDecimal price = priceValidation.getValidatedPrice();

            // Parse duration
            int duration;
            try {
                duration = Integer.parseInt(durationStr);
                if (duration <= 0) {
                    request.setAttribute("errorMessage", "Thời hạn phải lớn hơn 0");
                    request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                    return;
                }
                if (duration > 3650) { // Max 10 years
                    request.setAttribute("errorMessage", "Thời hạn không được vượt quá 3650 ngày (10 năm)");
                    request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Thời hạn phải là số nguyên");
                request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                return;
            }

            // Parse sessions (optional)
            Integer sessions = null;
            if (sessionsStr != null && !sessionsStr.trim().isEmpty()) {
                try {
                    sessions = Integer.parseInt(sessionsStr);
                    if (sessions <= 0) {
                        request.setAttribute("errorMessage", "Số buổi tập phải lớn hơn 0");
                        request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                        return;
                    }
                    if (sessions > 1000) {
                        request.setAttribute("errorMessage", "Số buổi tập không được vượt quá 1000");
                        request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Số buổi tập phải là số nguyên");
                    request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                    return;
                }
            }

            // Validate giá theo loại gói tập
            VNDPriceValidator.ValidationResult packageValidation = VNDPriceValidator.validatePriceForPackageType(price,
                    duration, sessions);
            if (!packageValidation.isValid()) {
                request.setAttribute("errorMessage", packageValidation.getErrorMessage());
                request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng Package
            Package pkg = new Package();
            pkg.setName(name);
            pkg.setPrice(price);
            pkg.setDuration(duration);
            pkg.setSessions(sessions);
            pkg.setDescription(description);
            pkg.setStatus(status != null && !status.isEmpty() ? status : "Active");

            // Lưu vào database
            PackageDAO packageDAO = new PackageDAO();
            boolean success = packageDAO.addPackage(pkg);

            if (success) {
                // Chuyển hướng đến trang danh sách gói tập với thông báo thành công
                session.setAttribute("successMessage", "Thêm gói tập \"" + name + "\" thành công!");
                response.sendRedirect("listPackage");
            } else {
                request.setAttribute("errorMessage", "Không thể thêm gói tập. Vui lòng thử lại.");
                request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu số không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
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
    }// </editor-fold>

}

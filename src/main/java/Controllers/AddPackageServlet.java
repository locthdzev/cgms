/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Models.Package;
import DAOs.PackageDAO;
import Utilities.VNDUtils;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
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

            // Kiểm tra dữ liệu đầu vào
            if (name == null || name.trim().isEmpty() ||
                    priceStr == null || priceStr.trim().isEmpty() ||
                    durationStr == null || durationStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
                request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                return;
            }

            // Xử lý và validate giá tiền VND
            BigDecimal price;
            try {
                // Parse giá tiền từ định dạng VND
                price = VNDUtils.parseVND(priceStr);

                // Validate giá tiền
                String priceValidationMessage = VNDUtils.getValidationMessage(price);
                if (priceValidationMessage != null) {
                    request.setAttribute("errorMessage", priceValidationMessage);
                    request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                    return;
                }
            } catch (ParseException e) {
                request.setAttribute("errorMessage",
                        "Định dạng giá tiền không hợp lệ. Vui lòng nhập số tiền hợp lệ (ví dụ: 1.000.000)");
                request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
                return;
            }

            // Chuyển đổi dữ liệu khác
            int duration = Integer.parseInt(durationStr);
            Integer sessions = null;
            if (sessionsStr != null && !sessionsStr.trim().isEmpty()) {
                sessions = Integer.parseInt(sessionsStr);
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
            request.setAttribute("errorMessage",
                    "Dữ liệu số không hợp lệ. Vui lòng kiểm tra lại thời hạn và số buổi tập.");
            request.getRequestDispatcher("/addPackage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm gói tập. Vui lòng thử lại sau.");
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

package Controllers;

import Models.User;
import Models.MemberLevel;
import Services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/ProfileController")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 30 // 30MB
)
public class ProfileController extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy thông tin đầy đủ của user từ database
        User user = userService.getUserById(loggedInUser.getId());
        request.setAttribute("user", user);

        // Thêm thuộc tính để xác định nếu là PT
        boolean isPersonalTrainer = "Personal Trainer".equals(user.getRole());
        request.setAttribute("isPersonalTrainer", isPersonalTrainer);

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
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

        // Lấy thông tin đầy đủ của user từ database
        User user = userService.getUserById(loggedInUser.getId());

        // Cập nhật thông tin từ form
        user.setEmail(request.getParameter("email"));
        user.setUserName(request.getParameter("userName"));
        user.setFullName(request.getParameter("fullName"));
        user.setPhoneNumber(request.getParameter("phoneNumber"));
        user.setAddress(request.getParameter("address"));
        user.setGender(request.getParameter("gender"));

        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.isEmpty()) {
            user.setDob(LocalDate.parse(dobStr));
        }

        // Nếu là Personal Trainer, cập nhật thêm thông tin PT
        if ("Personal Trainer".equals(user.getRole())) {
            user.setZalo(request.getParameter("zalo"));
            user.setFacebook(request.getParameter("facebook"));
            user.setExperience(request.getParameter("experience"));

            // Xử lý upload chứng chỉ nếu có
            Part certificateFilePart = request.getPart("certificateImage");
            if (certificateFilePart != null && certificateFilePart.getSize() > 0) {
                String fileName = certificateFilePart.getSubmittedFileName();
                String contentType = certificateFilePart.getContentType();

                try {
                    // Upload to MinIO and get URL
                    String certificateImageUrl = userService.uploadCertificateImage(
                            certificateFilePart.getInputStream(), fileName, contentType);
                    user.setCertificateImageUrl(certificateImageUrl);
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "Lỗi khi tải lên chứng chỉ: " + e.getMessage());
                    response.sendRedirect("profile");
                    return;
                }
            }
        }

        // Cập nhật thông tin user
        boolean updated = userService.updateUser(user);

        if (updated) {
            // Cập nhật thông tin user trong session
            session.setAttribute("loggedInUser", user);
            session.setAttribute("successMessage", "Cập nhật thông tin thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật thông tin thất bại. Vui lòng thử lại!");
        }

        response.sendRedirect("profile");
    }
}
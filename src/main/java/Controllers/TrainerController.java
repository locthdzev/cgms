package Controllers;

import Models.User;
import Services.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import Models.MemberLevel;

@WebServlet({ "/trainer", "/addTrainer", "/editTrainer", "/updateTrainerStatus" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 30 // 30MB
)
public class TrainerController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String servletPath = req.getServletPath();
        if ("/trainer".equals(servletPath)) {
            // Hiển thị danh sách Personal Trainer
            List<User> allUsers = userService.getAllUsers();
            // Lọc chỉ lấy Personal Trainer
            List<User> trainers = allUsers.stream()
                    .filter(user -> "Personal Trainer".equals(user.getRole()))
                    .collect(Collectors.toList());
            req.setAttribute("trainerList", trainers);
            req.getRequestDispatcher("/trainer.jsp").forward(req, resp);
        } else if ("/addTrainer".equals(servletPath)) {
            // Hiển thị form thêm Personal Trainer
            req.getRequestDispatcher("/addTrainer.jsp").forward(req, resp);
        } else if ("/editTrainer".equals(servletPath)) {
            // Hiển thị form chỉnh sửa Personal Trainer
            String idStr = req.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                User trainer = userService.getUserById(id);
                req.setAttribute("trainer", trainer);
            }
            req.getRequestDispatcher("/editTrainer.jsp").forward(req, resp);
        } else if ("/updateTrainerStatus".equals(servletPath)) {
            // Cập nhật trạng thái Personal Trainer (GET)
            String idStr = req.getParameter("id");
            String status = req.getParameter("status");
            if (idStr != null && status != null) {
                int id = Integer.parseInt(idStr);
                boolean updated = userService.updateUserStatus(id, status);
                HttpSession session = req.getSession();
                if (updated) {
                    session.setAttribute("successMessage", "Cập nhật trạng thái Personal Trainer thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật trạng thái Personal Trainer thất bại!");
                }
            }
            resp.sendRedirect(req.getContextPath() + "/trainer");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String servletPath = req.getServletPath();
        if ("/addTrainer".equals(servletPath)) {
            // Xử lý thêm Personal Trainer
            User trainer = new User();
            trainer.setEmail(req.getParameter("email"));
            trainer.setUserName(req.getParameter("userName"));
            trainer.setFullName(req.getParameter("fullName"));
            trainer.setPhoneNumber(req.getParameter("phoneNumber"));
            trainer.setAddress(req.getParameter("address"));
            trainer.setGender(req.getParameter("gender"));
            trainer.setRole("Personal Trainer"); // Luôn là Personal Trainer
            trainer.setStatus("Active"); // luôn là Active khi tạo mới

            // Các trường bổ sung cho Personal Trainer
            String zalo = req.getParameter("zalo");
            String facebook = req.getParameter("facebook");
            String experience = req.getParameter("experience");

            trainer.setZalo(zalo != null && !zalo.isEmpty() ? zalo : null);
            trainer.setFacebook(facebook != null && !facebook.isEmpty() ? facebook : null);
            trainer.setExperience(experience != null && !experience.isEmpty() ? experience : null);

            String dobStr = req.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                trainer.setDob(java.time.LocalDate.parse(dobStr));
            }

            // Xử lý upload chứng chỉ
            Part certificateFilePart = req.getPart("certificateImage");
            if (certificateFilePart != null && certificateFilePart.getSize() > 0) {
                String fileName = certificateFilePart.getSubmittedFileName();
                String contentType = certificateFilePart.getContentType();

                try {
                    // Upload to MinIO and get URL
                    String certificateImageUrl = userService.uploadCertificateImage(
                            certificateFilePart.getInputStream(), fileName, contentType);
                    trainer.setCertificateImageUrl(certificateImageUrl);
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("errorMessage", "Lỗi khi tải lên chứng chỉ: " + e.getMessage());
                    req.getRequestDispatcher("/addTrainer.jsp").forward(req, resp);
                    return;
                }
            }

            String rawPassword = req.getParameter("password");
            MemberLevel defaultLevel = new MemberLevel();
            defaultLevel.setId(1);
            trainer.setLevel(defaultLevel);

            boolean created = userService.createUser(trainer, rawPassword);
            HttpSession session = req.getSession();
            if (created) {
                session.setAttribute("successMessage", "Thêm Personal Trainer mới thành công!");
                resp.sendRedirect(req.getContextPath() + "/trainer");
            } else {
                req.setAttribute("errorMessage", "Tạo Personal Trainer thất bại. Vui lòng kiểm tra lại dữ liệu!");
                req.getRequestDispatcher("/addTrainer.jsp").forward(req, resp);
            }
        } else if ("/editTrainer".equals(servletPath)) {
            // Xử lý cập nhật Personal Trainer
            String idStr = req.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                User trainer = userService.getUserById(id);
                trainer.setEmail(req.getParameter("email"));
                trainer.setUserName(req.getParameter("userName"));
                trainer.setFullName(req.getParameter("fullName"));
                trainer.setPhoneNumber(req.getParameter("phoneNumber"));
                trainer.setAddress(req.getParameter("address"));
                trainer.setGender(req.getParameter("gender"));
                trainer.setRole("Personal Trainer"); // Luôn là Personal Trainer
                trainer.setStatus(req.getParameter("status"));

                // Các trường bổ sung cho Personal Trainer
                String zalo = req.getParameter("zalo");
                String facebook = req.getParameter("facebook");
                String experience = req.getParameter("experience");

                trainer.setZalo(zalo != null && !zalo.isEmpty() ? zalo : null);
                trainer.setFacebook(facebook != null && !facebook.isEmpty() ? facebook : null);
                trainer.setExperience(experience != null && !experience.isEmpty() ? experience : null);

                String dobStr = req.getParameter("dob");
                if (dobStr != null && !dobStr.isEmpty()) {
                    trainer.setDob(java.time.LocalDate.parse(dobStr));
                }

                // Xử lý upload chứng chỉ
                Part certificateFilePart = req.getPart("certificateImage");
                if (certificateFilePart != null && certificateFilePart.getSize() > 0) {
                    String fileName = certificateFilePart.getSubmittedFileName();
                    String contentType = certificateFilePart.getContentType();

                    try {
                        // Upload to MinIO and get URL
                        String certificateImageUrl = userService.uploadCertificateImage(
                                certificateFilePart.getInputStream(), fileName, contentType);
                        trainer.setCertificateImageUrl(certificateImageUrl);
                    } catch (Exception e) {
                        e.printStackTrace();
                        req.setAttribute("errorMessage", "Lỗi khi tải lên chứng chỉ: " + e.getMessage());
                        req.setAttribute("trainer", trainer);
                        req.getRequestDispatcher("/editTrainer.jsp").forward(req, resp);
                        return;
                    }
                }

                // Đảm bảo luôn có level
                MemberLevel defaultLevel = new MemberLevel();
                defaultLevel.setId(1);
                trainer.setLevel(defaultLevel);

                // Kiểm tra xem có cập nhật mật khẩu không
                String newPassword = req.getParameter("password");
                boolean updated;
                if (newPassword != null && !newPassword.isEmpty()) {
                    updated = userService.updateUserWithPassword(trainer, newPassword);
                } else {
                    updated = userService.updateUser(trainer);
                }

                HttpSession session = req.getSession();
                if (updated) {
                    session.setAttribute("successMessage", "Cập nhật thông tin Personal Trainer thành công!");
                    resp.sendRedirect(req.getContextPath() + "/trainer");
                } else {
                    req.setAttribute("trainer", trainer);
                    req.setAttribute("errorMessage",
                            "Cập nhật Personal Trainer thất bại. Vui lòng kiểm tra lại dữ liệu!");
                    req.getRequestDispatcher("/editTrainer.jsp").forward(req, resp);
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/trainer");
            }
        } else if ("/updateTrainerStatus".equals(servletPath)) {
            // Cập nhật trạng thái Personal Trainer (POST)
            String idStr = req.getParameter("id");
            String status = req.getParameter("status");
            if (idStr != null && status != null) {
                int id = Integer.parseInt(idStr);
                boolean updated = userService.updateUserStatus(id, status);
                HttpSession session = req.getSession();
                if (updated) {
                    session.setAttribute("successMessage", "Cập nhật trạng thái Personal Trainer thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật trạng thái Personal Trainer thất bại!");
                }
            }
            resp.sendRedirect(req.getContextPath() + "/trainer");
        }
    }
}
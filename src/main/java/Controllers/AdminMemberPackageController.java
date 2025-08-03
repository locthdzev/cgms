package Controllers;

import DAOs.MemberPackageDAO;
import DAOs.UserDAO;
import DAOs.PackageDAO;
import DAOs.PaymentDAO;
import Models.MemberPackage;
import Models.User;
import Models.Package;
import Models.Payment;
import Services.MembershipCardService;
import Services.PayOSService;
import Utilities.EmailSender;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin-member-packages")
public class AdminMemberPackageController extends HttpServlet {

    private final MemberPackageDAO memberPackageDAO = new MemberPackageDAO();
    private final UserDAO userDAO = new UserDAO();
    private final PackageDAO packageDAO = new PackageDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final PayOSService payOSService = new PayOSService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");

        if (user == null || !"Admin".equals(user.getRole())) {
            resp.sendRedirect("login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("details".equals(action)) {
                showMemberPackageDetails(req, resp);
            } else if ("create".equals(action)) {
                showCreateMemberPackagePage(req, resp);
            } else if ("edit".equals(action)) {
                showEditMemberPackagePage(req, resp);
            } else if ("getActivePackages".equals(action)) {
                getActiveMemberPackages(req, resp);
            } else {
                showMemberPackagesList(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect("admin-member-packages");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");

        if (user == null || !"Admin".equals(user.getRole())) {
            resp.sendRedirect("login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                createMemberPackage(req, resp);
            } else if ("update".equals(action)) {
                updateMemberPackage(req, resp);
            } else if ("cancel".equals(action)) {
                cancelMemberPackage(req, resp);
            } else if ("payment".equals(action)) {
                processMemberPackagePayment(req, resp);
            } else {
                resp.sendRedirect("admin-member-packages");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            resp.sendRedirect("admin-member-packages");
        }
    }

    private void showMemberPackagesList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Get filter parameters
        String statusFilter = req.getParameter("status");
        String memberFilter = req.getParameter("member");

        // Get all member packages
        List<MemberPackage> memberPackages = memberPackageDAO.getAllMemberPackages();

        // Filter to only show ACTIVE, CANCELLED, EXPIRED packages by default
        if (statusFilter == null || statusFilter.isEmpty() || "ALL".equals(statusFilter)) {
            memberPackages = memberPackages.stream()
                    .filter(mp -> "ACTIVE".equals(mp.getStatus()) ||
                            "CANCELLED".equals(mp.getStatus()) ||
                            "EXPIRED".equals(mp.getStatus()))
                    .collect(Collectors.toList());
        } else {
            // Apply specific status filter
            memberPackages = memberPackages.stream()
                    .filter(mp -> statusFilter.equals(mp.getStatus()))
                    .collect(Collectors.toList());
        }

        // Get all members and packages for dropdowns
        List<User> allUsers = userDAO.getAllUsers();
        List<User> members = allUsers.stream()
                .filter(user -> "Member".equals(user.getRole()))
                .collect(Collectors.toList());
        List<Package> packages = packageDAO.getAllPackages();

        req.setAttribute("memberPackages", memberPackages);
        req.setAttribute("members", members);
        req.setAttribute("packages", packages);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("memberFilter", memberFilter);

        req.getRequestDispatcher("admin-member-packages.jsp").forward(req, resp);
    }

    private void showMemberPackageDetails(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect("admin-member-packages");
            return;
        }

        try {
            int memberPackageId = Integer.parseInt(idStr);
            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);

            if (memberPackage == null) {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy gói tập với ID: " + memberPackageId);
                resp.sendRedirect("admin-member-packages");
                return;
            }

            // Get membership card HTML
            String membershipCardHTML = MembershipCardService.generateMembershipCard(memberPackage);

            // Get payment history
            List<Payment> payments = paymentDAO.getPaymentsByMemberPackageId(memberPackageId);

            req.setAttribute("memberPackage", memberPackage);
            req.setAttribute("membershipCardHTML", membershipCardHTML);
            req.setAttribute("payments", payments);

            req.getRequestDispatcher("admin-member-package-details.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect("admin-member-packages");
        }
    }

    private void showCreateMemberPackagePage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<User> allUsers = userDAO.getAllUsers();
        List<User> members = allUsers.stream()
                .filter(user -> "Member".equals(user.getRole()))
                .collect(Collectors.toList());
        List<Package> packages = packageDAO.getAllPackages();

        req.setAttribute("members", members);
        req.setAttribute("packages", packages);

        req.getRequestDispatcher("admin-create-member-package.jsp").forward(req, resp);
    }

    private void showEditMemberPackagePage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect("admin-member-packages");
            return;
        }

        try {
            int memberPackageId = Integer.parseInt(idStr);
            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);

            if (memberPackage == null) {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy gói tập với ID: " + memberPackageId);
                resp.sendRedirect("admin-member-packages");
                return;
            }

            List<User> allUsers = userDAO.getAllUsers();
            List<User> members = allUsers.stream()
                    .filter(user -> "Member".equals(user.getRole()))
                    .collect(Collectors.toList());
            List<Package> packages = packageDAO.getAllPackages();

            req.setAttribute("memberPackage", memberPackage);
            req.setAttribute("members", members);
            req.setAttribute("packages", packages);

            req.getRequestDispatcher("admin-edit-member-package.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect("admin-member-packages");
        }
    }

    private void createMemberPackage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int memberId = Integer.parseInt(req.getParameter("memberId"));
            int packageId = Integer.parseInt(req.getParameter("packageId"));
            String paymentMethod = req.getParameter("paymentMethod");

            User member = userDAO.getUserById(memberId);
            Package packageInfo = packageDAO.getPackageById(packageId);

            if (member == null || packageInfo == null) {
                req.getSession().setAttribute("errorMessage", "Thông tin member hoặc package không hợp lệ");
                resp.sendRedirect("admin-member-packages?action=create");
                return;
            }

            // Check if member already has an active package
            List<MemberPackage> existingPackages = memberPackageDAO.getActiveMemberPackagesByMemberId(memberId);
            boolean hasActivePackage = existingPackages != null && !existingPackages.isEmpty();

            // Create member package
            MemberPackage memberPackage = new MemberPackage();
            memberPackage.setMember(member);
            memberPackage.setPackageField(packageInfo);
            memberPackage.setTotalPrice(packageInfo.getPrice());
            memberPackage.setStartDate(LocalDate.now());
            memberPackage.setEndDate(LocalDate.now().plusDays(packageInfo.getDuration()));
            memberPackage.setRemainingSessions(packageInfo.getSessions());

            if ("CASH".equals(paymentMethod)) {
                memberPackage.setStatus("ACTIVE");

                int memberPackageId = memberPackageDAO.createMemberPackage(memberPackage);

                if (memberPackageId > 0) {
                    // Create cash payment record
                    memberPackage.setId(memberPackageId);

                    // Deactivate existing active packages
                    if (hasActivePackage) {
                        for (MemberPackage existingPackage : existingPackages) {
                            memberPackageDAO.updateMemberPackageStatus(existingPackage.getId(), "CANCELLED");
                            System.out.println("Deactivated existing package ID: " + existingPackage.getId());
                        }
                    }

                    Payment payment = paymentDAO.createPayment(memberPackage, packageInfo.getPrice(), "CASH");
                    if (payment != null) {
                        paymentDAO.updatePaymentStatus(payment.getId(), "COMPLETED",
                                "CASH-" + System.currentTimeMillis());
                    }

                    // Send membership card email (async to avoid blocking)
                    try {
                        final MemberPackage finalMemberPackage = memberPackage;
                        final User finalMember = member;
                        new Thread(() -> {
                            try {
                                String subject = "🎉 Chúc mừng! Đăng ký gói tập thành công - CORE-FIT GYM";
                                String emailContent = MembershipCardService
                                        .buildMembershipCardEmail(finalMemberPackage);
                                EmailSender.send(finalMember.getEmail(), subject, emailContent);
                                System.out.println("Email sent successfully to: " + finalMember.getEmail());
                            } catch (Exception emailEx) {
                                System.err.println("Lỗi khi gửi email: " + emailEx.getMessage());
                                emailEx.printStackTrace();
                            }
                        }).start();
                    } catch (Exception emailEx) {
                        System.err.println("Lỗi khi khởi tạo thread gửi email: " + emailEx.getMessage());
                    }

                    req.getSession().setAttribute("successMessage",
                            "Tạo gói tập thành công cho " + member.getFullName());
                } else {
                    req.getSession().setAttribute("errorMessage", "Không thể tạo gói tập");
                }

                resp.sendRedirect("admin-member-packages");

            } else if ("PAYOS".equals(paymentMethod)) {
                memberPackage.setStatus("PENDING");

                int memberPackageId = memberPackageDAO.createMemberPackage(memberPackage);

                if (memberPackageId > 0) {
                    memberPackage.setId(memberPackageId);

                    // Create payment and redirect to PayOS
                    Payment payment = paymentDAO.createPayment(memberPackage, packageInfo.getPrice(), "PAYOS");

                    if (payment != null) {
                        System.out.println("Created payment with ID: " + payment.getId());

                        // Create PayOS payment link
                        try {
                            Models.PaymentLink paymentLink = payOSService.createPaymentLink(payment, memberPackage,
                                    null);

                            if (paymentLink != null) {
                                // Get payment link URL directly
                                String checkoutUrl = paymentLink.getPaymentLinkUrl();

                                if (checkoutUrl != null && !checkoutUrl.isEmpty()) {
                                    System.out.println("PayOS checkout URL: " + checkoutUrl);
                                    resp.sendRedirect(checkoutUrl);
                                    return;
                                } else {
                                    System.err.println("Payment link URL is null or empty");
                                }
                            } else {
                                System.err.println("PayOS service returned null payment link");
                            }
                        } catch (Exception payosEx) {
                            System.err.println("Error creating PayOS payment link: " + payosEx.getMessage());
                            payosEx.printStackTrace();
                        }
                    } else {
                        System.err.println("Failed to create payment record");
                    }
                }

                req.getSession().setAttribute("errorMessage", "Không thể tạo liên kết thanh toán PayOS");
                resp.sendRedirect("admin-member-packages?action=create");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Lỗi khi tạo gói tập: " + e.getMessage());
            resp.sendRedirect("admin-member-packages?action=create");
        }
    }

    private void updateMemberPackage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int memberPackageId = Integer.parseInt(req.getParameter("memberPackageId"));
            String status = req.getParameter("status");
            String endDateStr = req.getParameter("endDate");
            String remainingSessionsStr = req.getParameter("remainingSessions");

            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);

            if (memberPackage == null) {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy gói tập");
                resp.sendRedirect("admin-member-packages");
                return;
            }

            // Update fields
            if (status != null && !status.isEmpty()) {
                memberPackage.setStatus(status);
            }

            if (endDateStr != null && !endDateStr.isEmpty()) {
                memberPackage.setEndDate(LocalDate.parse(endDateStr));
            }

            if (remainingSessionsStr != null && !remainingSessionsStr.isEmpty()) {
                memberPackage.setRemainingSessions(Integer.parseInt(remainingSessionsStr));
            }

            boolean updated = memberPackageDAO.updateMemberPackage(memberPackage);

            if (updated) {
                req.getSession().setAttribute("successMessage", "Cập nhật gói tập thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Không thể cập nhật gói tập");
            }

            resp.sendRedirect("admin-member-packages");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật gói tập: " + e.getMessage());
            resp.sendRedirect("admin-member-packages");
        }
    }

    private void cancelMemberPackage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int memberPackageId = Integer.parseInt(req.getParameter("memberPackageId"));

            boolean cancelled = memberPackageDAO.updateMemberPackageStatus(memberPackageId, "CANCELLED");

            if (cancelled) {
                req.getSession().setAttribute("successMessage", "Hủy gói tập thành công");
            } else {
                req.getSession().setAttribute("errorMessage", "Không thể hủy gói tập");
            }

            resp.sendRedirect("admin-member-packages");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Lỗi khi hủy gói tập: " + e.getMessage());
            resp.sendRedirect("admin-member-packages");
        }
    }

    private void processMemberPackagePayment(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int memberPackageId = Integer.parseInt(req.getParameter("memberPackageId"));
            String paymentMethod = req.getParameter("paymentMethod");

            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);

            if (memberPackage == null) {
                req.getSession().setAttribute("errorMessage", "Không tìm thấy gói tập");
                resp.sendRedirect("admin-member-packages");
                return;
            }

            if ("CASH".equals(paymentMethod)) {
                // Update status to ACTIVE and create cash payment
                boolean updated = memberPackageDAO.updateMemberPackageStatus(memberPackageId, "ACTIVE");

                if (updated) {
                    Payment payment = paymentDAO.createPayment(memberPackage, memberPackage.getTotalPrice(), "CASH");
                    if (payment != null) {
                        paymentDAO.updatePaymentStatus(payment.getId(), "COMPLETED",
                                "CASH-" + System.currentTimeMillis());
                    }

                    // Send membership card email
                    try {
                        final MemberPackage finalMemberPackage = memberPackage;
                        new Thread(() -> {
                            try {
                                String subject = "🎉 Chúc mừng! Đăng ký gói tập thành công - CORE-FIT GYM";
                                String emailContent = MembershipCardService
                                        .buildMembershipCardEmail(finalMemberPackage);
                                EmailSender.send(finalMemberPackage.getMember().getEmail(), subject, emailContent);
                                System.out.println(
                                        "Email sent successfully to: " + finalMemberPackage.getMember().getEmail());
                            } catch (Exception emailEx) {
                                System.err.println("Lỗi khi gửi email: " + emailEx.getMessage());
                                emailEx.printStackTrace();
                            }
                        }).start();
                    } catch (Exception emailEx) {
                        System.err.println("Lỗi khi khởi tạo thread gửi email: " + emailEx.getMessage());
                    }

                    req.getSession().setAttribute("successMessage", "Thanh toán tiền mặt thành công");
                } else {
                    req.getSession().setAttribute("errorMessage", "Không thể cập nhật trạng thái thanh toán");
                }

            } else if ("PAYOS".equals(paymentMethod)) {
                // Create PayOS payment
                Payment payment = paymentDAO.createPayment(memberPackage, memberPackage.getTotalPrice(), "PAYOS");

                if (payment != null) {
                    Models.PaymentLink paymentLink = payOSService.createPaymentLink(payment, memberPackage, null);

                    if (paymentLink != null) {
                        try {
                            String checkoutUrl = (String) paymentLink.getClass().getMethod("getCheckoutUrl")
                                    .invoke(paymentLink);
                            resp.sendRedirect(checkoutUrl);
                            return;
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                }

                req.getSession().setAttribute("errorMessage", "Không thể tạo liên kết thanh toán PayOS");
            }

            resp.sendRedirect("admin-member-packages");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Lỗi khi xử lý thanh toán: " + e.getMessage());
            resp.sendRedirect("admin-member-packages");
        }
    }

    private void getActiveMemberPackages(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String ajaxHeader = req.getHeader("X-Requested-With");
        if (!"XMLHttpRequest".equals(ajaxHeader)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int memberId = Integer.parseInt(req.getParameter("memberId"));
            List<MemberPackage> activePackages = memberPackageDAO.getActiveMemberPackagesByMemberId(memberId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            // Build JSON manually
            StringBuilder json = new StringBuilder();
            json.append("{\"success\": true, \"activePackages\": [");

            for (int i = 0; i < activePackages.size(); i++) {
                MemberPackage mp = activePackages.get(i);
                if (i > 0)
                    json.append(",");
                json.append("{")
                        .append("\"id\": ").append(mp.getId()).append(",")
                        .append("\"packageName\": \"").append(mp.getPackageField().getName()).append("\",")
                        .append("\"startDate\": \"")
                        .append(mp.getStartDate().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")))
                        .append("\",")
                        .append("\"endDate\": \"")
                        .append(mp.getEndDate().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")))
                        .append("\"")
                        .append("}");
            }

            json.append("]}");
            resp.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": false, \"error\": \"Invalid member ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\": false, \"error\": \"Error fetching active packages\"}");
        }
    }
}
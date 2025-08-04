package Controllers;

import DAOs.MemberPackageDAO;
import Models.MemberPackage;
import Models.User;
import Services.MembershipCardService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/admin-membership-card")
public class AdminMembershipCardController extends HttpServlet {

    private final MemberPackageDAO memberPackageDAO = new MemberPackageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");

        if (user == null || !"Admin".equals(user.getRole())) {
            resp.sendRedirect("login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("view".equals(action)) {
                viewMembershipCard(req, resp);
            } else if ("print".equals(action)) {
                printMembershipCard(req, resp);
            } else {
                resp.sendRedirect("dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("error500.jsp").forward(req, resp);
        }
    }

    private void viewMembershipCard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String memberPackageIdStr = req.getParameter("id");
        if (memberPackageIdStr == null || memberPackageIdStr.isEmpty()) {
            resp.sendRedirect("dashboard");
            return;
        }

        try {
            int memberPackageId = Integer.parseInt(memberPackageIdStr);
            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);

            if (memberPackage == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("Không tìm thấy gói tập");
                return;
            }

            // Tạo HTML thẻ tập (bỏ QR code)
            String membershipCardHTML = MembershipCardService.generateMembershipCard(memberPackage);

            // Check if this is an AJAX request
            String ajaxHeader = req.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxHeader)) {
                // Return JSON for AJAX
                resp.setContentType("application/json; charset=UTF-8");
                String json = "{\"success\": true, \"html\": " + escapeJson(membershipCardHTML) + "}";
                resp.getWriter().write(json);
            } else {
                // Return HTML directly for direct access
                resp.setContentType("text/html; charset=UTF-8");
                resp.getWriter().write(membershipCardHTML);
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("ID không hợp lệ");
        }
    }

    private String escapeJson(String str) {
        if (str == null)
            return "null";
        return "\"" + str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t") + "\"";
    }

    private void printMembershipCard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String memberPackageIdStr = req.getParameter("id");
        if (memberPackageIdStr == null || memberPackageIdStr.isEmpty()) {
            resp.sendRedirect("dashboard");
            return;
        }

        try {
            int memberPackageId = Integer.parseInt(memberPackageIdStr);
            MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);

            if (memberPackage == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Membership package not found");
                return;
            }

            // Tạo HTML thẻ tập cho in với auto-print script
            String membershipCardHTML = MembershipCardService.generateMembershipCard(memberPackage);

            // Add auto-print script
            String printableHTML = membershipCardHTML.replace("</body>",
                    "<script>" +
                            "window.onload = function() {" +
                            "setTimeout(function() {" +
                            "window.print();" +
                            "}, 500);" +
                            "};" +
                            "</script>" +
                            "</body>");

            // Set response headers for printing
            resp.setContentType("text/html; charset=UTF-8");
            resp.setHeader("Content-Disposition", "inline; filename=membership-card-" + memberPackageId + ".html");

            // Write HTML directly to response
            resp.getWriter().write(printableHTML);

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid membership package ID");
        }
    }
}
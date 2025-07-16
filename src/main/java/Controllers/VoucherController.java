package Controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

import Models.Voucher;
import Services.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VoucherController extends HttpServlet {
    private final VoucherService service = new VoucherService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "create":
                req.setAttribute("voucher", new Voucher());
                req.getRequestDispatcher("/voucher-form.jsp").forward(req, resp);
                break;
            case "edit":
                int id = Integer.parseInt(req.getParameter("id"));
                Voucher v = service.getVoucherById(id);
                req.setAttribute("voucher", v);
                req.getRequestDispatcher("/voucher-form.jsp").forward(req, resp);
                break;
            case "delete":
                try {
                    service.deleteVoucher(Integer.parseInt(req.getParameter("id")));
                    HttpSession session = req.getSession();
                    session.setAttribute("successMessage", "Xóa voucher thành công!");
                } catch (Exception e) {
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage", "Lỗi khi xóa voucher: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/voucher?action=list");
                break;
            default:
                List<Voucher> list = service.getAllVouchers();
                req.setAttribute("voucherList", list);
                req.getRequestDispatcher("/voucher-list.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        HttpSession session = req.getSession();
        Voucher v = new Voucher();

        try {
            if (idStr != null && !idStr.trim().isEmpty()) {
                // Update
                v = service.getVoucherById(Integer.parseInt(idStr));
                v.setUpdatedAt(Instant.now());
            } else {
                // Create
                v.setCreatedAt(Instant.now());
            }

            v.setCode(req.getParameter("code"));

            String discountStr = req.getParameter("discountValue");
            if (discountStr != null && !discountStr.trim().isEmpty()) {
                v.setDiscountValue(new BigDecimal(discountStr));
            }

            v.setDiscountType(req.getParameter("discountType"));

            String minPurchaseStr = req.getParameter("minPurchase");
            if (minPurchaseStr != null && !minPurchaseStr.trim().isEmpty()) {
                v.setMinPurchase(new BigDecimal(minPurchaseStr));
            }

            String expiryDateStr = req.getParameter("expiryDate");
            if (expiryDateStr != null && !expiryDateStr.trim().isEmpty()) {
                v.setExpiryDate(LocalDate.parse(expiryDateStr));
            }

            v.setStatus(req.getParameter("status"));

            // Validate voucher data
            List<String> validationErrors = service.validateVoucher(v);
            if (!validationErrors.isEmpty()) {
                StringBuilder errorMessage = new StringBuilder("Tạo Voucher không thành công!");
                for (String error : validationErrors) {
                    errorMessage.append("<li>").append(error).append("</li>");
                }
                errorMessage.append("</ul>");
                req.setAttribute("errorMessage", errorMessage.toString());
                req.setAttribute("voucher", v);
                req.getRequestDispatcher("/voucher-form.jsp").forward(req, resp);
                return;
            }

            if (idStr != null && !idStr.trim().isEmpty()) {
                service.updateVoucher(v);
                session.setAttribute("successMessage", "Cập nhật voucher thành công!");
            } else {
                service.saveVoucher(v);
                session.setAttribute("successMessage", "Tạo voucher mới thành công!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            req.setAttribute("voucher", v);
            req.getRequestDispatcher("/voucher-form.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/voucher?action=list");
    }
}

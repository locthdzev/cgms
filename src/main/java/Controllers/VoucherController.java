package Controllers;

import Models.Voucher;
import Services.VoucherService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public class VoucherController extends HttpServlet {
    private final VoucherService service = new VoucherService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

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
                service.deleteVoucher(Integer.parseInt(req.getParameter("id")));
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

            if (idStr != null && !idStr.trim().isEmpty()) {
                service.updateVoucher(v);
            } else {
                service.saveVoucher(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Invalid input: " + e.getMessage());
            req.setAttribute("voucher", v);
            req.getRequestDispatcher("/voucher-form.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/voucher?action=list");
    }
}

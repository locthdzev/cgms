package Controllers;

import DAOs.VoucherDAO;
import Models.Voucher;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "VoucherCheckServlet", urlPatterns = { "/voucher/check" })
public class VoucherCheckServlet extends HttpServlet {
    private final VoucherDAO voucherDAO = new VoucherDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String voucherCode = request.getParameter("voucherCode");
        String packageId = request.getParameter("packageId");

        Map<String, Object> result = new HashMap<>();

        if (voucherCode == null || voucherCode.isEmpty()) {
            result.put("valid", false);
            result.put("message", "Voucher code is required");
            sendJsonResponse(response, result);
            return;
        }

        Voucher voucher = voucherDAO.getVoucherByCode(voucherCode);

        if (voucher == null) {
            result.put("valid", false);
            result.put("message", "Invalid voucher code");
            sendJsonResponse(response, result);
            return;
        }

        // Kiểm tra ngày hết hạn
        if (voucher.getExpiryDate().isBefore(LocalDate.now())) {
            result.put("valid", false);
            result.put("message", "Voucher has expired");
            sendJsonResponse(response, result);
            return;
        }

        // Kiểm tra trạng thái
        if (!"ACTIVE".equals(voucher.getStatus())) {
            result.put("valid", false);
            result.put("message", "Voucher is not active");
            sendJsonResponse(response, result);
            return;
        }

        // Voucher hợp lệ
        result.put("valid", true);
        result.put("message", "Voucher is valid");
        result.put("discountType", voucher.getDiscountType());
        result.put("discountValue", voucher.getDiscountValue());

        sendJsonResponse(response, result);
    }

    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        objectMapper.writeValue(response.getOutputStream(), data);
    }
}
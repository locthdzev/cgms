package Controllers;

import DAOs.PaymentDAO;
import Models.MemberPackage;
import Models.Payment;
import Models.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PaymentHistoryController", urlPatterns = { "/payment-history", "/payment-history/*" })
public class PaymentHistoryController extends HttpServlet {
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public PaymentHistoryController() {
        // Cấu hình ObjectMapper
        objectMapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
        objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Kiểm tra người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (pathInfo == null || pathInfo.equals("/")) {
            // Hiển thị trang lịch sử thanh toán
            List<Payment> payments = paymentDAO.getPaymentsByUserId(loggedInUser.getId());
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/payment-history.jsp").forward(request, response);
        } else if (pathInfo.equals("/detail")) {
            try {
                // Lấy chi tiết thanh toán
                int paymentId = Integer.parseInt(request.getParameter("id"));
                Payment payment = paymentDAO.getPaymentById(paymentId);

                if (payment == null) {
                    sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND,
                            "Không tìm thấy thông tin thanh toán");
                    return;
                }

                // Tạm thời bỏ qua việc kiểm tra quyền truy cập
                // Tạo một đối tượng đơn giản hơn để trả về
                Map<String, Object> paymentData = new HashMap<>();
                paymentData.put("id", payment.getId());
                paymentData.put("amount", payment.getAmount());
                paymentData.put("paymentMethod", payment.getPaymentMethod());
                paymentData.put("paymentDate",
                        payment.getPaymentDate() != null ? payment.getPaymentDate().toString() : null);
                paymentData.put("status", payment.getStatus());
                paymentData.put("transactionId", payment.getTransactionId());

                // Thông tin gói tập
                if (payment.getMemberPackage() != null) {
                    MemberPackage pkg = payment.getMemberPackage();
                    Map<String, Object> packageData = new HashMap<>();
                    packageData.put("id", pkg.getId());

                    // Log để debug
                    System.out.println("MemberPackage ID: " + pkg.getId());
                    System.out.println("Package Field: " + pkg.getPackageField());

                    // Lấy thông tin từ Package thông qua MemberPackage
                    if (pkg.getPackageField() != null) {
                        System.out.println("Package Name: " + pkg.getPackageField().getName());
                        System.out.println("Package Duration: " + pkg.getPackageField().getDuration());
                        System.out.println("Package Price: " + pkg.getPackageField().getPrice());

                        packageData.put("packageName", pkg.getPackageField().getName());
                        packageData.put("duration", pkg.getPackageField().getDuration());
                        packageData.put("price", pkg.getPackageField().getPrice());
                    } else {
                        packageData.put("packageName", "N/A");
                        packageData.put("duration", 0);
                        packageData.put("price", BigDecimal.ZERO);
                    }

                    // Thêm thông tin TotalPrice từ MemberPackage
                    packageData.put("totalPrice", pkg.getTotalPrice());

                    paymentData.put("memberPackage", packageData);
                }

                // Trả về dữ liệu JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> result = new HashMap<>();
                result.put("payment", paymentData);

                // Sử dụng PrintWriter thay vì ObjectMapper để tránh lỗi
                PrintWriter out = response.getWriter();
                out.print(objectMapper.writeValueAsString(result));
                out.flush();
            } catch (NumberFormatException e) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "ID thanh toán không hợp lệ");
            } catch (Exception e) {
                e.printStackTrace();
                sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Lỗi server: " + e.getMessage());
            }
        }
    }

    private void sendErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> error = new HashMap<>();
        error.put("error", message);

        PrintWriter out = response.getWriter();
        out.print(objectMapper.writeValueAsString(error));
        out.flush();
    }
}
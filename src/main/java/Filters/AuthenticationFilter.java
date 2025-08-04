package Filters;

import Models.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = { "/*" })
public class AuthenticationFilter implements Filter {

    // Các URL không cần xác thực
    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/login", "/GoogleLoginController", "/register", "/RegisterController", "/logout", "/verify-email",
            "/VerifyEmail",
            "/forgot-password", "/reset-password", "/assets/", "/css/", "/js/", "/img/", "/svg/",
            "/order/payment/success", "/order/payment/cancel", "/payment/success", "/payment/cancel");

    // Các URL chỉ dành cho Admin
    private static final List<String> ADMIN_URLS = Arrays.asList(
            "/dashboard", "/user", "/addUser", "/editUser", "/trainer", "/addTrainer", "/editTrainer",
            "/listPackage", "/addPackage", "/editPackage", "/product", "/voucher", "/inventory", "/feedback",
            "/admin-orders", "/admin-membership-card", "/admin-member-packages", "/admin-pt-availability");

    // Các URL chỉ dành cho Personal Trainer
    private static final List<String> PT_URLS = Arrays.asList(
            "/pt_dashboard.jsp", "/pt_dashboard", "/pt_schedule.jsp", "/pt_clients.jsp", "/pt-availability");

    // Các URL chỉ dành cho Member
    private static final List<String> MEMBER_URLS = Arrays.asList(
            "/member-dashboard", "/member-packages-controller", "/all-packages-controller", "/all-packages",
            "/member-schedule.jsp", "/member-shop.jsp", "member-shop", "/member-cart.jsp", "/member-feedback.jsp",
            "/select-voucher");

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Loại bỏ contextPath khỏi requestURI để dễ so sánh
        String path = requestURI.substring(contextPath.length());

        // Kiểm tra nếu là URL công khai hoặc tài nguyên tĩnh
        if (isPublicResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra xác thực người dùng
        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        if (loggedInUser == null) {
            // Chưa đăng nhập, chuyển hướng về trang login
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // Kiểm tra phân quyền truy cập
        String userRole = loggedInUser.getRole();

        if (isAdminURL(path) && !"Admin".equals(userRole)) {
            // Không phải Admin nhưng cố truy cập trang Admin
            redirectBasedOnRole(httpResponse, contextPath, userRole);
            return;
        }

        if (isPTURL(path) && !"Personal Trainer".equals(userRole)) {
            // Không phải PT nhưng cố truy cập trang PT
            redirectBasedOnRole(httpResponse, contextPath, userRole);
            return;
        }

        if (isMemberURL(path) && !"Member".equals(userRole) && !"Personal Trainer".equals(userRole)) {
            // Không phải Member hoặc PT nhưng cố truy cập trang Member
            redirectBasedOnRole(httpResponse, contextPath, userRole);
            return;
        }

        // Nếu mọi thứ đều hợp lệ, tiếp tục chuỗi filter
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }

    private boolean isPublicResource(String path) {
        // Kiểm tra xem path có phải là tài nguyên công khai không
        if (path.equals("/") || path.isEmpty()) {
            return true; // Trang chủ là công khai
        }

        for (String publicUrl : PUBLIC_URLS) {
            if (path.startsWith(publicUrl)) {
                return true;
            }
        }
        return false;
    }

    private boolean isAdminURL(String path) {
        for (String adminUrl : ADMIN_URLS) {
            if (path.startsWith(adminUrl)) {
                return true;
            }
        }
        return false;
    }

    private boolean isPTURL(String path) {
        for (String ptUrl : PT_URLS) {
            if (path.startsWith(ptUrl)) {
                return true;
            }
        }
        return false;
    }

    private boolean isMemberURL(String path) {
        for (String memberUrl : MEMBER_URLS) {
            if (path.startsWith(memberUrl)) {
                return true;
            }
        }
        return false;
    }

    private void redirectBasedOnRole(HttpServletResponse response, String contextPath, String role) throws IOException {
        if ("Admin".equals(role)) {
            response.sendRedirect(contextPath + "/dashboard");
        } else if ("Personal Trainer".equals(role)) {
            response.sendRedirect(contextPath + "/pt_dashboard");
        } else {
            response.sendRedirect(contextPath + "/member-dashboard");
        }
    }
}
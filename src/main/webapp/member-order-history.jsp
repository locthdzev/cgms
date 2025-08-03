<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    User memberLoggedInUser = (User) session.getAttribute("loggedInUser");
    if (memberLoggedInUser == null || !"Member".equals(memberLoggedInUser.getRole())) {
        response.sendRedirect("login");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");

    String errorMessage = (String) session.getAttribute("errorMessage");
    boolean hasErrorMessage = (errorMessage != null);
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    String successMessage = (String) session.getAttribute("successMessage");
    boolean hasSuccessMessage = (successMessage != null);
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }

    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đơn hàng của tôi - CGMS</title>
    <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        .main-content {
            margin-left: 260px;
            transition: margin-left 0.3s;
        }

        @media (max-width: 991.98px) {
            .main-content {
                margin-left: 0;
            }
        }

        /* Toast Container */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .toast {
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border: none;
        }

        /* Header Section */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            font-size: 1rem;
            opacity: 0.8;
            margin-bottom: 0;
        }

        /* Order Cards */
        .order-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
        }

        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.12);
        }

        .order-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 1.5rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .order-meta {
            display: flex;
            justify-content: between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .order-id {
            font-size: 1.1rem;
            font-weight: 700;
            color: #2d3748;
        }

        .order-date {
            color: #718096;
            font-size: 0.9rem;
        }

        .order-status {
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending {
            background: #fef3cd;
            color: #856404;
        }

        .status-confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-delivered {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .order-body {
            padding: 1.5rem;
        }

        .order-items {
            margin-bottom: 1rem;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-info {
            flex: 1;
        }

        .item-name {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.25rem;
        }

        .item-details {
            font-size: 0.875rem;
            color: #718096;
        }

        .item-total {
            font-weight: 600;
            color: #059669;
        }

        .order-footer {
            background: #f8fafc;
            padding: 1rem 1.5rem;
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .order-total {
            font-size: 1.125rem;
            font-weight: 700;
            color: #2d3748;
        }

        .order-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-modern {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-modern {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary-modern:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }

        .btn-outline-modern {
            background: transparent;
            color: #718096;
            border: 1px solid #e2e8f0;
        }

        .btn-outline-modern:hover {
            background: #f8fafc;
            color: #4a5568;
            text-decoration: none;
        }

        .btn-danger-modern {
            background: linear-gradient(135deg, #FF416C 0%, #FF4B2B 100%);
            color: white;
        }

        .btn-danger-modern:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(255, 65, 108, 0.4);
            color: white;
            text-decoration: none;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .empty-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 1rem;
        }

        .empty-description {
            color: #718096;
            font-size: 1rem;
            margin-bottom: 2rem;
        }

        .shop-now-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .shop-now-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }

        /* Statistics Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            text-align: center;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 1rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .stat-icon.pending {
            background: linear-gradient(135deg, #FFB75E 0%, #ED8F03 100%);
        }

        .stat-icon.confirmed {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .stat-icon.delivered {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }

        .stat-icon.cancelled {
            background: linear-gradient(135deg, #FF416C 0%, #FF4B2B 100%);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #718096;
            font-size: 0.875rem;
            text-transform: uppercase;
            font-weight: 600;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .order-meta {
                flex-direction: column;
                align-items: flex-start;
            }

            .order-footer {
                flex-direction: column;
                align-items: flex-start;
            }

            .order-actions {
                width: 100%;
                justify-content: stretch;
            }

            .btn-modern {
                flex: 1;
                justify-content: center;
            }
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <!-- Toast Container thay thế Alert -->
    <div class="toast-container">
        <% if (hasSuccessMessage) { %>
        <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true" id="successToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
        <% } %>
        <% if (hasErrorMessage) { %>
        <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" id="errorToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
        <% } %>
    </div>

    <%@ include file="member_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Đơn hàng của tôi"/>
            <jsp:param name="parentPage" value="Dashboard"/>
            <jsp:param name="parentPageUrl" value="member-dashboard"/>
            <jsp:param name="currentPage" value="Đơn hàng"/>
        </jsp:include>

        <div class="container-fluid py-4">
            <!-- Header -->
            <div class="page-header">
                <div class="container-fluid">
                    <div class="text-center">
                        <h1 class="page-title">
                            <i class="fas fa-shopping-bag me-2"></i>
                            Đơn hàng của tôi
                        </h1>
                        <p class="page-subtitle">
                            Theo dõi trạng thái và lịch sử đơn hàng của bạn
                        </p>
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <%
                    int pendingCount = 0, confirmedCount = 0, deliveredCount = 0, cancelledCount = 0;
                    if (orders != null) {
                        for (Order order : orders) {
                            switch (order.getStatus()) {
                                case "PENDING": pendingCount++; break;
                                case "CONFIRMED": confirmedCount++; break;
                                case "DELIVERED": deliveredCount++; break;
                                case "CANCELLED": cancelledCount++; break;
                            }
                        }
                    }
                %>
                <div class="stat-card">
                    <div class="stat-icon pending">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-number"><%= pendingCount %></div>
                    <div class="stat-label">Chờ xác nhận</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon confirmed">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="stat-number"><%= confirmedCount %></div>
                    <div class="stat-label">Đã xác nhận</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon delivered">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div class="stat-number"><%= deliveredCount %></div>
                    <div class="stat-label">Đã giao</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon cancelled">
                        <i class="fas fa-times"></i>
                    </div>
                    <div class="stat-number"><%= cancelledCount %></div>
                    <div class="stat-label">Đã hủy</div>
                </div>
            </div>

            <!-- Orders List -->
            <% if (orders != null && !orders.isEmpty()) { %>
                <% for (Order order : orders) { %>
                <div class="order-card">
                    <div class="order-header">
                        <div class="order-meta">
                            <div>
                                <div class="order-id">Đơn hàng #<%= order.getId() %></div>
                                <div class="order-date">
                                    <i class="fas fa-calendar me-1"></i>
                                    <%= order.getCreatedAt().atZone(java.time.ZoneId.systemDefault()).format(dateFormatter) %>
                                </div>
                            </div>
                            <div class="order-status status-<%= order.getStatus().toLowerCase() %>">
                                <% 
                                    String statusText = "";
                                    switch (order.getStatus()) {
                                        case "PENDING": statusText = "Chờ xác nhận"; break;
                                        case "CONFIRMED": statusText = "Đã xác nhận"; break;
                                        case "DELIVERED": statusText = "Đã giao"; break;
                                        case "CANCELLED": statusText = "Đã hủy"; break;
                                        default: statusText = order.getStatus();
                                    }
                                %>
                                <%= statusText %>
                            </div>
                        </div>
                    </div>

                    <div class="order-body">
                        <div class="order-items">
                            <!-- Hiển thị tóm tắt items từ orderDetails nếu có -->
                            <div class="order-item">
                                <div class="item-info">
                                    <div class="item-name">
                                        <%= order.getPaymentMethod() %> • 
                                        <% if (order.getNotes() != null && !order.getNotes().trim().isEmpty()) { %>
                                            <%= order.getNotes().length() > 50 ? order.getNotes().substring(0, 50) + "..." : order.getNotes() %>
                                        <% } else { %>
                                            Không có ghi chú
                                        <% } %>
                                    </div>
                                    <div class="item-details">
                                        Phương thức: <%= "CASH".equals(order.getPaymentMethod()) ? "Tiền mặt" : "PayOS" %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="order-footer">
                        <div class="order-total">
                            Tổng cộng: <%= formatter.format(order.getTotalAmount().longValue()) %> VNĐ
                        </div>
                        <div class="order-actions">
                            <a href="my-order?action=details&id=<%= order.getId() %>" class="btn-modern btn-primary-modern">
                                <i class="fas fa-eye"></i>
                                Chi tiết
                            </a>
                            <% if ("PENDING".equals(order.getStatus())) { %>
                            <form method="post" action="my-order" style="display: inline;">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <button type="submit" class="btn-modern btn-danger-modern" 
                                        onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                    <i class="fas fa-times"></i>
                                    Hủy đơn
                                </button>
                            </form>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            <% } else { %>
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <h3 class="empty-title">Chưa có đơn hàng nào</h3>
                <p class="empty-description">
                    Bạn chưa thực hiện đơn hàng nào. Hãy khám phá cửa hàng và mua sắm ngay!
                </p>
                <a href="member-shop" class="shop-now-btn">
                    <i class="fas fa-store"></i>
                    Mua sắm ngay
                </a>
            </div>
            <% } %>
        </div>

        <footer class="footer pt-3">
            <div class="container-fluid">
                <div class="row align-items-center justify-content-lg-between">
                    <div class="col-lg-6 mb-lg-0 mb-4">
                        <div class="text-muted text-sm text-center text-lg-start">
                            © <script>document.write(new Date().getFullYear())</script>, CoreFit Gym Management System
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </main>

    <!-- Scripts -->
    <script src="assets/js/core/bootstrap.bundle.min.js"></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Initialize and show toasts
            const toastElList = [].slice.call(document.querySelectorAll('.toast'));
            const toastList = toastElList.map(function(toastEl) {
                const toast = new bootstrap.Toast(toastEl, { delay: 5000 });
                toast.show();
                return toast;
            });
        });
    </script>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="Models.User" %>
<%@page import="Models.Order" %>
<%@page import="Models.OrderDetail" %>
<%@page import="java.util.List" %>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.ZoneId" %>

<%
    Order order = (Order) request.getAttribute("order");
    List<OrderDetail> orderDetails = (List<OrderDetail>) request.getAttribute("orderDetails");

    if (order == null) {
        response.sendRedirect("my-order");
        return;
    }

    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Chi tiết đơn hàng #<%= order.getId() %> - CGMS</title>
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

        /* Steps Progress */
        .steps-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
        }

        .steps {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            margin: 2rem 0;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            flex: 1;
            z-index: 2;
        }

        .step-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }

        .step-circle.active {
            background: rgba(255, 255, 255, 0.9);
            color: #667eea;
            border-color: white;
            transform: scale(1.1);
        }

        .step-circle.completed {
            background: #10b981;
            border-color: #10b981;
            color: white;
        }

        .step-label {
            font-size: 0.875rem;
            text-align: center;
            font-weight: 600;
            margin-top: 0.5rem;
        }

        .step-line {
            position: absolute;
            top: 25px;
            left: 0;
            right: 0;
            height: 3px;
            background: rgba(255, 255, 255, 0.3);
            z-index: 1;
        }

        .step-line-progress {
            height: 100%;
            background: linear-gradient(90deg, #10b981, #34d399);
            border-radius: 1.5px;
            transition: width 0.5s ease;
        }

        /* Modern Cards */
        .modern-card {
            background: white;
            border-radius: 1rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .modern-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .modern-card .card-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-bottom: 1px solid #e9ecef;
            padding: 1.5rem;
        }

        .modern-card .card-body {
            padding: 1.5rem;
        }

        .order-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
        }

        /* Payment Status */
        .payment-status {
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-weight: 600;
            font-size: 0.875rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .payment-paid {
            background: linear-gradient(135deg, #10b981, #34d399);
            color: white;
        }

        .payment-unpaid {
            background: linear-gradient(135deg, #f59e0b, #fbbf24);
            color: white;
        }

        /* Product Items */
        .product-item {
            background: #f8f9fa;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .product-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .product-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 0.75rem;
            margin-right: 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .price-highlight {
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
        }

        /* Buttons */
        .btn-modern {
            border-radius: 0.75rem;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-back {
            background: linear-gradient(135deg, #6b7280, #9ca3af);
            color: white;
        }

        .btn-back:hover {
            background: linear-gradient(135deg, #4b5563, #6b7280);
            color: white;
            transform: translateY(-2px);
        }

        .btn-cancel {
            background: linear-gradient(135deg, #ef4444, #f87171);
            color: white;
        }

        .btn-cancel:hover {
            background: linear-gradient(135deg, #dc2626, #ef4444);
            color: white;
            transform: translateY(-2px);
        }

        /* Info Cards */
        .info-item {
            background: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
            border-left: 4px solid #667eea;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .summary-item:last-child {
            border-bottom: none;
            font-weight: 700;
            font-size: 1.1rem;
            color: #667eea;
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">

<!-- Sidebar -->
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if ("Member".equals(currentUser.getRole())) {
%>
<%@ include file="member_sidebar.jsp" %>
<% } else if ("PT".equals(currentUser.getRole())) { %>
<%@ include file="pt_sidebar.jsp" %>
<% } else { %>
<%@ include file="sidebar.jsp" %>
<% } %>

<main class="main-content position-relative border-radius-lg">
    <!-- Navbar -->
    <%@ include file="navbar.jsp" %>

    <div class="container-fluid py-4">
        <!-- Alert Messages -->
        <% if (errorMessage != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <span class="alert-icon"><i class="fas fa-exclamation-circle"></i></span>
            <span class="alert-text"><%= errorMessage %></span>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        <% if (successMessage != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <span class="alert-icon"><i class="fas fa-check-circle"></i></span>
            <span class="alert-text"><%= successMessage %></span>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Order Header -->
        <div class="order-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-2">
                        <i class="fas fa-shopping-bag me-3"></i>
                        Đơn hàng #<%= order.getId() %>
                    </h2>
                    <p class="mb-0 opacity-8">
                        <i class="fas fa-calendar me-2"></i>
                        Đặt hàng lúc: <%= order.getCreatedAt().atZone(ZoneId.systemDefault()).format(dateFormatter) %>
                    </p>
                </div>
                <div class="text-end">
                    <h3 class="mb-0 price-highlight" style="color: white !important;">
                        <%= formatter.format(order.getTotalAmount().longValue()) %> VNĐ
                    </h3>
                    <small class="opacity-8">Tổng giá trị</small>
                </div>
            </div>
        </div>

        <!-- Order Status Steps -->
        <div class="steps-container">
            <h5 class="mb-4">
                <i class="fas fa-route me-2"></i>
                Trạng thái đơn hàng
            </h5>
            <div class="steps">
                <div class="step-line">
                    <%
                        String status = order.getStatus();
                        int progressWidth = 0;
                        if ("CONFIRMED".equals(status) || "SHIPPING".equals(status) || "DELIVERED".equals(status) || "COMPLETED".equals(status)) {
                            progressWidth = 33;
                        }
                        if ("SHIPPING".equals(status) || "DELIVERED".equals(status) || "COMPLETED".equals(status)) {
                            progressWidth = 66;
                        }
                        if ("DELIVERED".equals(status) || "COMPLETED".equals(status)) {
                            progressWidth = 100;
                        }
                        if ("CANCELLED".equals(status)) {
                            progressWidth = 0;
                        }
                    %>
                    <div class="step-line-progress" style="width: <%= progressWidth %>%;"></div>
                </div>

                <div class="step">
                    <div class="step-circle <%= ("PENDING".equals(status) || "CONFIRMED".equals(status) || "SHIPPING".equals(status) || "DELIVERED".equals(status) || "COMPLETED".equals(status)) ? "completed" : "" %>">
                        <i class="fas fa-clipboard-check"></i>
                    </div>
                    <div class="step-label">Chờ xác nhận</div>
                </div>

                <div class="step">
                    <div class="step-circle <%= ("CONFIRMED".equals(status)) ? "active" : (("SHIPPING".equals(status) || "DELIVERED".equals(status) || "COMPLETED".equals(status)) ? "completed" : "") %>">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="step-label">Đã xác nhận</div>
                </div>

                <div class="step">
                    <div class="step-circle <%= ("SHIPPING".equals(status)) ? "active" : (("DELIVERED".equals(status) || "COMPLETED".equals(status)) ? "completed" : "") %>">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div class="step-label">Đang giao hàng</div>
                </div>

                <div class="step">
                    <div class="step-circle <%= ("DELIVERED".equals(status) || "COMPLETED".equals(status)) ? "completed" : "" %>">
                        <i class="fas fa-gift"></i>
                    </div>
                    <div class="step-label">Đã giao hàng</div>
                </div>
            </div>

            <% if ("CANCELLED".equals(status)) { %>
            <div class="text-center mt-3">
                <span class="badge" style="background: linear-gradient(135deg, #ef4444, #f87171); color: white; padding: 0.75rem 1.5rem; border-radius: 2rem; font-size: 1rem;">
                    <i class="fas fa-times-circle me-2"></i>Đơn hàng đã bị hủy
                </span>
            </div>
            <% } %>
        </div>

        <div class="row">
            <!-- Left Column -->
            <div class="col-lg-8">
                <!-- Order Information -->
                <div class="modern-card">
                    <div class="card-header">
                        <h6 class="mb-0">
                            <i class="fas fa-info-circle me-2"></i>
                            Thông tin đơn hàng
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-primary mb-3">
                                    <i class="fas fa-shipping-fast me-2"></i>
                                    Thông tin giao hàng
                                </h6>
                                <div class="info-item">
                                    <strong>Người nhận:</strong> <%= order.getReceiverName() %>
                                </div>
                                <div class="info-item">
                                    <strong>Số điện thoại:</strong> <%= order.getReceiverPhone() %>
                                </div>
                                <div class="info-item">
                                    <strong>Địa chỉ:</strong> <%= order.getShippingAddress() %>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-primary mb-3">
                                    <i class="fas fa-credit-card me-2"></i>
                                    Thông tin thanh toán
                                </h6>
                                <div class="info-item">
                                    <strong>Phương thức:</strong>
                                    <% if ("CASH".equals(order.getPaymentMethod())) { %>
                                    <span class="badge bg-secondary ms-2">Tiền mặt khi nhận hàng</span>
                                    <% } else { %>
                                    <span class="badge bg-primary ms-2">Thanh toán online PayOS</span>
                                    <% } %>
                                </div>
                                <div class="info-item">
                                    <strong>Trạng thái thanh toán:</strong>
                                    <%
                                        // Logic kiểm tra trạng thái thanh toán
                                        boolean isPaid = false;

                                        if ("PAYOS".equals(order.getPaymentMethod())) {
                                            // PayOS: Mặc định đã thanh toán (trừ khi CANCELLED)
                                            isPaid = !"CANCELLED".equals(order.getStatus());
                                        } else if ("CASH".equals(order.getPaymentMethod())) {
                                            // Cash: Chỉ khi COMPLETED mới đã thanh toán
                                            isPaid = "COMPLETED".equals(order.getStatus());
                                        }
                                    %>
                                    <% if (isPaid) { %>
                                    <span class="payment-status payment-paid ms-2">
                                        <i class="fas fa-check-circle"></i>
                                        Đã thanh toán
                                    </span>
                                    <% } else { %>
                                    <span class="payment-status payment-unpaid ms-2">
                                        <i class="fas fa-clock"></i>
                                        <% if ("CASH".equals(order.getPaymentMethod())) { %>
                                        Thanh toán khi nhận hàng
                                        <% } else { %>
                                        Chưa thanh toán
                                        <% } %>
                                    </span>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <% if (order.getNotes() != null && !order.getNotes().trim().isEmpty()) { %>
                        <div class="mt-4">
                            <h6 class="text-primary">
                                <i class="fas fa-sticky-note me-2"></i>
                                Ghi chú
                            </h6>
                            <div class="info-item">
                                <%= order.getNotes() %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Order Items -->
                <div class="modern-card">
                    <div class="card-header">
                        <h6 class="mb-0">
                            <i class="fas fa-box me-2"></i>
                            Sản phẩm đã đặt
                        </h6>
                    </div>
                    <div class="card-body">
                        <% if (orderDetails != null && !orderDetails.isEmpty()) { %>
                        <% for (OrderDetail detail : orderDetails) { %>
                        <div class="product-item">
                            <img src="<%= detail.getProduct().getImageUrl() != null ? detail.getProduct().getImageUrl() : "assets/img/default-product.jpg" %>"
                                 alt="<%= detail.getProduct().getName() %>" class="product-img">
                            <div class="flex-grow-1">
                                <h6 class="mb-2"><%= detail.getProduct().getName() %></h6>
                                <div class="d-flex gap-3 text-muted">
                                    <span><i class="fas fa-cubes me-1"></i>Số lượng: <strong><%= detail.getQuantity() %></strong></span>
                                    <span><i class="fas fa-tag me-1"></i>Đơn giá: <strong><%= formatter.format(detail.getUnitPrice().longValue()) %> VNĐ</strong></span>
                                </div>
                            </div>
                            <div class="text-end">
                                <h5 class="mb-0 price-highlight">
                                    <%= formatter.format(detail.getTotalPrice().longValue() * detail.getQuantity()) %> VNĐ
                                </h5>
                            </div>
                        </div>
                        <% } %>
                        <% } else { %>
                        <div class="text-center py-5 text-muted">
                            <i class="fas fa-box-open fa-3x mb-3"></i>
                            <p>Không có sản phẩm nào trong đơn hàng này.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="col-lg-4">
                <!-- Order Summary -->
                <div class="modern-card">
                    <div class="card-header">
                        <h6 class="mb-0">
                            <i class="fas fa-calculator me-2"></i>
                            Tóm tắt đơn hàng
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="summary-item">
                            <span>Tổng tiền hàng:</span>
                            <span><%= formatter.format(order.getTotalAmount().longValue()) %> VNĐ</span>
                        </div>
                        <div class="summary-item">
                            <span>Phí vận chuyển:</span>
                            <span class="text-success">Miễn phí</span>
                        </div>
                        <div class="summary-item">
                            <span>Tổng cộng:</span>
                            <span><%= formatter.format(order.getTotalAmount().longValue()) %> VNĐ</span>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="modern-card">
                    <div class="card-body">
                        <div class="d-grid gap-3">
                            <a href="my-order" class="btn btn-back btn-modern">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại đơn hàng của tôi
                            </a>

                            <% if ("PENDING".equals(order.getStatus())) { %>
                            <button type="button" class="btn btn-cancel btn-modern" onclick="cancelOrder(<%= order.getId() %>)">
                                <i class="fas fa-times me-2"></i>Hủy đơn hàng
                            </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Cancel Order Modal -->
<div class="modal fade" id="cancelOrderModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle me-2 text-warning"></i>
                    Hủy đơn hàng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="my-order" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="cancel"/>
                    <input type="hidden" name="orderId" id="cancelOrderId"/>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        Bạn có chắc chắn muốn hủy đơn hàng này không?
                    </div>
                    <div class="form-group">
                        <label class="form-control-label">
                            <i class="fas fa-comment me-2"></i>
                            Lý do hủy đơn hàng:
                        </label>
                        <textarea class="form-control" name="reason" rows="3" required placeholder="Vui lòng cho biết lý do hủy đơn hàng..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Đóng
                    </button>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-check me-2"></i>Xác nhận hủy
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Core JS Files -->
<script src="assets/js/core/popper.min.js"></script>
<script src="assets/js/core/bootstrap.min.js"></script>
<script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

<script>
    function cancelOrder(orderId) {
        document.getElementById("cancelOrderId").value = orderId;
        new bootstrap.Modal(document.getElementById("cancelOrderModal")).show();
    }

    // Animation for steps
    document.addEventListener('DOMContentLoaded', function() {
        const steps = document.querySelectorAll('.step');
        steps.forEach((step, index) => {
            setTimeout(() => {
                step.style.opacity = '0';
                step.style.transform = 'translateY(20px)';
                step.style.animation = 'fadeInUp 0.6s ease forwards';
            }, index * 200);
        });
    });
</script>

<style>
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>

</body>
</html>
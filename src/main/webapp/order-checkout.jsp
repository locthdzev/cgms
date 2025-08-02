<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Cart" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // Không khai báo lại loggedInUser vì navbar.jsp đã khai báo
    if (session.getAttribute("loggedInUser") == null || 
        (!"Member".equals(((User) session.getAttribute("loggedInUser")).getRole()) && 
         !"PT".equals(((User) session.getAttribute("loggedInUser")).getRole()))) {
        response.sendRedirect("login");
        return;
    }

    User currentUser = (User) session.getAttribute("loggedInUser");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    BigDecimal totalAmount = BigDecimal.ZERO;
    
    if (cartItems != null) {
        for (Cart item : cartItems) {
            totalAmount = totalAmount.add(item.getProduct().getPrice().multiply(new BigDecimal(item.getQuantity())));
        }
    }

    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    
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
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán đơn hàng - CORE-FIT GYM</title>
    <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --warning-gradient: linear-gradient(135deg, #FFB75E 0%, #ED8F03 100%);
            --danger-gradient: linear-gradient(135deg, #FF416C 0%, #FF4B2B 100%);
            --info-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --card-shadow: 0 20px 27px 0 rgb(0 0 0 / 5%);
            --card-shadow-hover: 0 30px 50px 0 rgb(0 0 0 / 10%);
            --border-radius: 20px;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            color: #2d3748;
        }

        .main-content {
            margin-left: 260px;
            transition: all 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .main-content {
                margin-left: 0;
            }
        }

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

        .checkout-header {
            background: var(--primary-gradient);
            color: white;
            padding: 3rem 0;
            margin-bottom: 3rem;
            position: relative;
            overflow: hidden;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
        }

        .checkout-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .checkout-header .container-fluid {
            position: relative;
            z-index: 1;
        }

        .checkout-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .checkout-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        .back-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            color: white;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }

        .back-btn:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
            text-decoration: none;
            box-shadow: 0 8px 25px rgba(255,255,255,0.3);
        }

        .progress-steps {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .progress-steps::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: #e2e8f0;
            z-index: 1;
        }

        .progress-step {
            background: white;
            border: 3px solid #e2e8f0;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            font-weight: 700;
            color: #a0aec0;
            position: relative;
            z-index: 2;
            transition: all 0.3s ease;
        }

        .progress-step.active {
            background: var(--primary-gradient);
            border-color: transparent;
            color: white;
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .progress-step.completed {
            background: var(--success-gradient);
            border-color: transparent;
            color: white;
        }

        .step-label {
            text-align: center;
            margin-top: 1rem;
            font-weight: 600;
            color: #718096;
        }

        .step-label.active {
            color: #667eea;
        }

        .checkout-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .checkout-card:hover {
            box-shadow: var(--card-shadow-hover);
            transform: translateY(-2px);
        }

        .card-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 2rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .card-subtitle {
            color: #718096;
            font-size: 0.95rem;
            margin-bottom: 0;
        }

        .card-body {
            padding: 2rem;
        }

        .order-item {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .order-item:hover {
            border-color: #cbd5e0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .item-image {
            width: 80px;
            height: 80px;
            border-radius: 12px;
            object-fit: cover;
            margin-right: 1.5rem;
        }

        .item-image-placeholder {
            width: 80px;
            height: 80px;
            border-radius: 12px;
            background: var(--primary-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            margin-right: 1.5rem;
        }

        .item-details {
            flex: 1;
        }

        .item-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .item-price {
            color: #059669;
            font-weight: 700;
            font-size: 1rem;
        }

        .item-quantity {
            color: #718096;
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        .item-total {
            text-align: right;
            font-size: 1.25rem;
            font-weight: 700;
            color: #2d3748;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.75rem;
            display: block;
            font-size: 0.95rem;
        }

        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            width: 100%;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }

        .payment-methods {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .payment-option {
            position: relative;
        }

        .payment-option input[type="radio"] {
            position: absolute;
            opacity: 0;
        }

        .payment-label {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            background: white;
        }

        .payment-option input[type="radio"]:checked + .payment-label {
            border-color: #667eea;
            background: linear-gradient(135deg, #f8faff 0%, #e6edff 100%);
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
        }

        .payment-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            background: var(--primary-gradient);
            color: white;
        }

        .order-summary {
            background: var(--primary-gradient);
            color: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            position: sticky;
            top: 20px;
            box-shadow: var(--card-shadow);
        }

        .summary-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .summary-row:last-child {
            border-bottom: none;
            padding-top: 1.5rem;
            font-size: 1.25rem;
            font-weight: 700;
        }

        .checkout-btn {
            width: 100%;
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 16px;
            color: white;
            padding: 1.25rem 2rem;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            margin-top: 2rem;
        }

        .checkout-btn:hover:not(:disabled) {
            background: white;
            color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(255, 255, 255, 0.3);
        }

        .checkout-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
        }

        .empty-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            background: var(--primary-gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .empty-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 1rem;
        }

        .empty-description {
            color: #718096;
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        .shop-btn {
            background: var(--primary-gradient);
            border: none;
            border-radius: 16px;
            color: white;
            padding: 1rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }

        .shop-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }

        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .checkout-title {
                font-size: 2rem;
            }

            .payment-methods {
                grid-template-columns: 1fr;
            }

            .order-item {
                flex-direction: column;
                text-align: center;
            }

            .item-image, .item-image-placeholder {
                margin-right: 0;
                margin-bottom: 1rem;
            }

            .item-total {
                text-align: center;
                margin-top: 1rem;
            }

            .progress-steps {
                flex-direction: column;
                gap: 1rem;
            }

            .progress-steps::before {
                display: none;
            }

            .order-summary {
                position: static;
                margin-top: 2rem;
            }
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
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

    <!-- Sidebar -->
    <%@ include file="member_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <%@ include file="navbar.jsp" %>

        <div class="container-fluid py-4">
            <div class="checkout-header">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <a href="member-cart" class="back-btn">
                                <i class="fas fa-arrow-left"></i>
                                Quay lại giỏ hàng
                            </a>
                        </div>
                        <div class="text-end">
                            <h1 class="checkout-title">
                                <i class="fas fa-credit-card me-3"></i>
                                Thanh toán đơn hàng
                            </h1>
                            <p class="checkout-subtitle">
                                Hoàn tất đơn hàng của bạn một cách an toàn và nhanh chóng
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="progress-steps">
                <div class="text-center">
                    <div class="progress-step completed">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="step-label">Giỏ hàng</div>
                </div>
                <div class="text-center">
                    <div class="progress-step active">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <div class="step-label active">Thanh toán</div>
                </div>
                <div class="text-center">
                    <div class="progress-step">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="step-label">Hoàn thành</div>
                </div>
            </div>

            <% if (cartItems != null && !cartItems.isEmpty()) { %>
            <div class="row">
                <div class="col-lg-8">
                    <form action="order" method="post" id="checkoutForm">
                        <input type="hidden" name="action" value="create">
                        
                        <div class="checkout-card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <i class="fas fa-truck text-info"></i>
                                    Thông tin giao hàng
                                </h3>
                                <p class="card-subtitle">Vui lòng cung cấp thông tin chính xác để giao hàng</p>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label">Tên người nhận *</label>
                                            <input type="text" class="form-control" name="receiverName" 
                                                value="<%= currentUser.getFullName() %>" required
                                                placeholder="Nhập tên người nhận">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label">Số điện thoại *</label>
                                            <input type="tel" class="form-control" name="receiverPhone" 
                                                value="<%= currentUser.getPhoneNumber() != null ? currentUser.getPhoneNumber() : "" %>" required
                                                placeholder="Nhập số điện thoại">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">Địa chỉ giao hàng *</label>
                                    <textarea class="form-control" name="shippingAddress" rows="3" required
                                        placeholder="Nhập địa chỉ chi tiết (số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố)"><%= currentUser.getAddress() != null ? currentUser.getAddress() : "" %></textarea>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Ghi chú đơn hàng</label>
                                    <textarea class="form-control" name="notes" rows="2"
                                        placeholder="Ghi chú thêm cho đơn hàng (tùy chọn)"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="checkout-card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <i class="fas fa-credit-card text-success"></i>
                                    Phương thức thanh toán
                                </h3>
                                <p class="card-subtitle">Chọn phương thức thanh toán phù hợp với bạn</p>
                            </div>
                            <div class="card-body">
                                <div class="payment-methods">
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" value="CASH" id="cashPayment" checked>
                                        <label class="payment-label" for="cashPayment">
                                            <div class="payment-icon">
                                                <i class="fas fa-money-bill-wave"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">Tiền mặt</div>
                                                <small class="text-muted">Thanh toán khi nhận hàng</small>
                                            </div>
                                        </label>
                                    </div>
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" value="PAYOS" id="payosPayment">
                                        <label class="payment-label" for="payosPayment">
                                            <div class="payment-icon">
                                                <i class="fas fa-credit-card"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">PayOS</div>
                                                <small class="text-muted">Thanh toán trực tuyến</small>
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="checkout-card">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <i class="fas fa-shopping-bag text-primary"></i>
                                    Sản phẩm đã đặt
                                </h3>
                                <p class="card-subtitle">Xem lại các sản phẩm trong đơn hàng của bạn</p>
                            </div>
                            <div class="card-body">
                                <% for (Cart item : cartItems) { %>
                                <div class="order-item">
                                    <% if (item.getProduct().getImageUrl() != null && !item.getProduct().getImageUrl().isEmpty()) { %>
                                    <img src="<%= item.getProduct().getImageUrl() %>" class="item-image" alt="Product">
                                    <% } else { %>
                                    <div class="item-image-placeholder">
                                        <i class="fas fa-box"></i>
                                    </div>
                                    <% } %>
                                    
                                    <div class="item-details">
                                        <div class="item-name"><%= item.getProduct().getName() %></div>
                                        <div class="item-price">
                                            <%= formatter.format(item.getProduct().getPrice().longValue()) %> VNĐ
                                        </div>
                                        <div class="item-quantity">
                                            Số lượng: <%= item.getQuantity() %>
                                        </div>
                                    </div>
                                    
                                    <div class="item-total">
                                        <%= formatter.format(item.getProduct().getPrice().multiply(new BigDecimal(item.getQuantity())).longValue()) %> VNĐ
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="col-lg-4">
                    <div class="order-summary">
                        <h4 class="summary-title">
                            <i class="fas fa-receipt"></i>
                            Tóm tắt đơn hàng
                        </h4>
                        
                        <div class="summary-row">
                            <span>Tạm tính:</span>
                            <span><%= formatter.format(totalAmount.longValue()) %> VNĐ</span>
                        </div>
                        
                        <div class="summary-row">
                            <span>Phí vận chuyển:</span>
                            <span class="text-success">Miễn phí</span>
                        </div>
                        
                        <div class="summary-row">
                            <span>Tổng cộng:</span>
                            <span><%= formatter.format(totalAmount.longValue()) %> VNĐ</span>
                        </div>
                        
                        <button type="button" class="checkout-btn" onclick="submitOrder()">
                            <i class="fas fa-lock"></i>
                            <span>Đặt hàng ngay</span>
                        </button>

                        <div class="text-center mt-3">
                            <small style="color: rgba(255,255,255,0.8);">
                                <i class="fas fa-shield-alt me-1"></i>
                                Thanh toán an toàn và bảo mật
                            </small>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="empty-cart">
                <div class="empty-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h3 class="empty-title">Giỏ hàng trống</h3>
                <p class="empty-description">
                    Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy khám phá các sản phẩm tuyệt vời của chúng tôi!
                </p>
                <a href="member-shop.jsp" class="shop-btn">
                    <i class="fas fa-shopping-bag"></i>
                    Tiếp tục mua sắm
                </a>
            </div>
            <% } %>
        </div>
    </main>

    <!-- Core JS Files -->
    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
    <script>
        function showToast(type, message) {
            const toastContainer = document.querySelector('.toast-container');
            const toast = document.createElement('div');
            toast.className = 'toast align-items-center text-white bg-' + (type === 'success' ? 'success' : 'danger') + ' border-0';
            toast.setAttribute('role', 'alert');
            toast.innerHTML = 
                '<div class="d-flex">' +
                    '<div class="toast-body">' +
                        '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle') + ' me-2"></i>' + message +
                    '</div>' +
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>';
            
            toastContainer.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            toast.addEventListener('hidden.bs.toast', function() {
                toast.remove();
            });
        }

        function submitOrder() {
            const form = document.getElementById('checkoutForm');
            const btn = document.querySelector('.checkout-btn');
            
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            
            btn.innerHTML = '<div class="loading-spinner"></div><span>Đang xử lý...</span>';
            btn.disabled = true;
            
            form.submit();
        }

        document.addEventListener("DOMContentLoaded", function () {
            var toastElList = [].slice.call(document.querySelectorAll('.toast'));
            var toastList = toastElList.map(function(toastEl) {
                return new bootstrap.Toast(toastEl);
            });
            
            toastList.forEach(function(toast) {
                toast.show();
            });

            const cards = document.querySelectorAll('.checkout-card, .order-summary');
            cards.forEach(function(card, index) {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(function() {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>
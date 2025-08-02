<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Cart" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null ||
            (!"Member".equals(loggedInUser.getRole()) &&
                    !"PT".equals(loggedInUser.getRole()))) {
        response.sendRedirect("login");
        return;
    }

    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");

    String successMessage = (String) session.getAttribute("successMessage");
    boolean hasSuccessMessage = (successMessage != null);
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }

    String errorMessage = (String) session.getAttribute("errorMessage");
    boolean hasErrorMessage = (errorMessage != null);
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Giỏ hàng - CGMS</title>
    <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --warning-gradient: linear-gradient(135deg, #FFB75E 0%, #ED8F03 100%);
            --danger-gradient: linear-gradient(135deg, #FF416C 0%, #FF4B2B 100%);
            --info-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --card-shadow: 0 20px 27px 0 rgb(0 0 0 / 5%);
            --card-shadow-hover: 0 30px 50px 0 rgb(0 0 0 / 10%);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
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
        .cart-header {
            background: var(--primary-gradient);
            border-radius: 20px;
            border: none;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
            position: relative;
        }

        .cart-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .header-content {
            position: relative;
            z-index: 1;
            padding: 2rem;
        }

        .header-title {
            color: white;
            font-weight: 700;
            font-size: 1.75rem;
            margin-bottom: 0.5rem;
        }

        .header-subtitle {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1rem;
            margin-bottom: 0;
        }

        .back-to-shop-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 16px;
            color: white;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }

        .back-to-shop-btn:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
            text-decoration: none;
        }

        /* Cart Items Section */
        .cart-section {
            background: white;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
        }

        .section-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 1.5rem 2rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-subtitle {
            color: #718096;
            font-size: 0.875rem;
            margin-bottom: 0;
        }

        .cart-controls {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-top: 1rem;
        }

        .select-all-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .select-all-container input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #667eea;
        }

        .select-all-label {
            font-weight: 600;
            color: #4a5568;
            cursor: pointer;
        }

        .cart-item {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            margin: 1.5rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border: 2px solid transparent;
            transition: all 0.3s ease;
            position: relative;
        }

        .cart-item:hover {
            border-color: #e2e8f0;
            box-shadow: var(--card-shadow);
        }

        .cart-item.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #f8faff 0%, #e6edff 100%);
        }

        .item-checkbox {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            width: 20px;
            height: 20px;
            accent-color: #667eea;
        }

        .item-content {
            display: grid;
            grid-template-columns: 120px 1fr auto;
            gap: 2rem;
            align-items: center;
        }

        .item-image-container {
            position: relative;
        }

        .item-image {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .item-image-placeholder {
            width: 120px;
            height: 120px;
            background: var(--primary-gradient);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
        }

        .item-info {
            flex: 1;
        }

        .item-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .item-description {
            color: #718096;
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .item-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: #059669;
            margin-bottom: 1rem;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .quantity-btn {
            width: 40px;
            height: 40px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            background: white;
            color: #718096;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        .quantity-btn:hover:not(:disabled) {
            border-color: #667eea;
            background: var(--primary-gradient);
            color: white;
            transform: translateY(-2px);
        }

        .quantity-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .quantity-input {
            width: 80px;
            height: 40px;
            text-align: center;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            color: #2d3748;
            background: white;
        }

        .quantity-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }

        .item-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 1rem;
        }

        .item-total {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            text-align: right;
        }

        .remove-btn {
            background: #fee2e2;
            border: 2px solid #fecaca;
            border-radius: 50%;
            width: 44px;
            height: 44px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #dc2626;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .remove-btn:hover {
            background: var(--danger-gradient);
            border-color: transparent;
            color: white;
            transform: translateY(-2px);
        }

        /* Cart Summary */
        .cart-summary {
            background: var(--primary-gradient);
            border-radius: 20px;
            padding: 2rem;
            color: white;
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
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .summary-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .summary-label {
            font-size: 1rem;
            font-weight: 500;
        }

        .summary-value {
            font-size: 1.25rem;
            font-weight: 700;
        }

        .total-row {
            font-size: 1.5rem;
            font-weight: 700;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 2px solid rgba(255, 255, 255, 0.3);
        }

        .checkout-btn {
            width: 100%;
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 16px;
            color: white;
            padding: 1rem 2rem;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            text-decoration: none;
            margin-top: 2rem;
        }

        .checkout-btn:hover:not(.disabled) {
            background: white;
            color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(255, 255, 255, 0.3);
            text-decoration: none;
        }

        .checkout-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        .checkout-btn.active {
            background: var(--success-gradient);
            border-color: transparent;
        }

        .checkout-btn.active:hover {
            background: var(--success-gradient);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(17, 153, 142, 0.4);
        }

        /* Empty State */
        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 20px;
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

        .shop-now-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }

        /* Modal Styles */
        .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
        }

        .modal-header {
            background: var(--danger-gradient);
            color: white;
            border-radius: 20px 20px 0 0;
            padding: 2rem;
            border-bottom: none;
        }

        .modal-title {
            font-weight: 700;
            font-size: 1.25rem;
        }

        .modal-body {
            padding: 2rem;
        }

        .modal-footer {
            padding: 1.5rem 2rem;
            border-top: 1px solid #e2e8f0;
            border-radius: 0 0 20px 20px;
        }

        .btn-modern {
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-secondary-modern {
            background: #6c757d;
            color: white;
        }

        .btn-secondary-modern:hover {
            background: #5a6268;
            transform: translateY(-2px);
            color: white;
        }

        .btn-danger-modern {
            background: var(--danger-gradient);
            color: white;
        }

        .btn-danger-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 65, 108, 0.3);
            color: white;
        }

        /* Item Count Badge */
        .item-count {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 600;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header-content {
                padding: 1.5rem;
            }

            .header-title {
                font-size: 1.5rem;
            }

            .cart-item {
                padding: 1.5rem;
                margin: 1rem;
            }

            .item-content {
                grid-template-columns: 1fr;
                gap: 1.5rem;
                text-align: center;
            }

            .item-checkbox {
                position: static;
                margin-bottom: 1rem;
            }

            .item-actions {
                align-items: center;
            }

            .cart-summary {
                position: static;
                margin-top: 2rem;
            }

            .header-content .d-flex {
                flex-direction: column;
                gap: 1rem;
            }

            .back-to-shop-btn {
                align-self: center;
            }

            .quantity-input {
                width: 100px;
            }
        }

        /* Loading Animation */
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
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <!-- Toast Container -->
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

    <!-- Confirm Delete Modal -->
    <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmDeleteModalLabel">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Xác nhận xóa sản phẩm
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-3">Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng không?</p>
                    <div class="alert alert-warning" style="border-radius: 12px;">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Hành động này không thể hoàn tác.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modern btn-secondary-modern" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i>
                        Hủy
                    </button>
                    <button type="button" class="btn-modern btn-danger-modern" id="confirmDeleteBtn">
                        <i class="fas fa-trash"></i>
                        Xóa sản phẩm
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="member_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Giỏ hàng"/>
            <jsp:param name="parentPage" value="Dashboard"/>
            <jsp:param name="parentPageUrl" value="member-dashboard"/>
            <jsp:param name="currentPage" value="Giỏ hàng"/>
        </jsp:include>

        <div class="container-fluid py-4">
            <!-- Header -->
            <div class="cart-header">
                <div class="header-content">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="header-title">
                                <i class="fas fa-shopping-cart me-3"></i>
                                Giỏ hàng của bạn
                            </h1>
                            <p class="header-subtitle">
                                Quản lý các sản phẩm bạn muốn mua
                            </p>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <% if (cartItems != null && !cartItems.isEmpty()) { %>
                            <div class="item-count">
                                <i class="fas fa-shopping-bag me-2"></i>
                                <%= cartItems.size() %> sản phẩm
                            </div>
                            <% } %>
                            <a href="member-shop" class="back-to-shop-btn">
                                <i class="fas fa-store"></i>
                                Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <!-- Cart Items -->
                    <div class="cart-section">
                        <div class="section-header">
                            <h3 class="section-title">
                                <i class="fas fa-list text-primary"></i>
                                Danh sách sản phẩm
                            </h3>
                            <p class="section-subtitle">Kiểm tra và điều chỉnh số lượng sản phẩm</p>
                            
                            <% if (cartItems != null && !cartItems.isEmpty()) { %>
                            <div class="cart-controls">
                                <div class="select-all-container">
                                    <input type="checkbox" id="selectAllCart" checked>
                                    <label for="selectAllCart" class="select-all-label">Chọn tất cả</label>
                                </div>
                            </div>
                            <% } %>
                        </div>

                        <% if (cartItems != null && !cartItems.isEmpty()) { %>
                        <form id="cartForm">
                            <% for (Cart cartItem : cartItems) { %>
                            <div class="cart-item selected">
                                <input type="checkbox" class="item-checkbox select-cart-item" 
                                       data-id="<%= cartItem.getId() %>" checked>
                                
                                <div class="item-content">
                                    <div class="item-image-container">
                                        <% if (cartItem.getProduct().getImageUrl() != null && 
                                               !cartItem.getProduct().getImageUrl().isEmpty()) { %>
                                        <img src="<%= cartItem.getProduct().getImageUrl() %>" 
                                             class="item-image" 
                                             alt="<%= cartItem.getProduct().getName() %>">
                                        <% } else { %>
                                        <div class="item-image-placeholder">
                                            <i class="fas fa-box"></i>
                                        </div>
                                        <% } %>
                                    </div>

                                    <div class="item-info">
                                        <h4 class="item-name">
                                            <a href="product.jsp?id=<%= cartItem.getProduct().getId() %>" 
                                               class="text-decoration-none text-dark" target="_blank">
                                                <%= cartItem.getProduct().getName() %>
                                            </a>
                                        </h4>
                                        <p class="item-description">
                                            <%= cartItem.getProduct().getDescription() != null ? 
                                                cartItem.getProduct().getDescription() : 
                                                "Sản phẩm chất lượng cao cho việc tập luyện" %>
                                        </p>
                                        <div class="item-price">
                                            <%= formatter.format(cartItem.getProduct().getPrice().longValue()) %> VNĐ
                                        </div>
                                        
                                        <div class="quantity-controls">
                                            <button type="button" class="quantity-btn decrease-btn" 
                                                    data-id="<%= cartItem.getId() %>"
                                                    <%= cartItem.getQuantity() <= 1 ? "disabled" : "" %>>
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <input type="number" class="quantity-input" 
                                                   value="<%= cartItem.getQuantity() %>" 
                                                   min="1" max="999"
                                                   data-id="<%= cartItem.getId() %>">
                                            <button type="button" class="quantity-btn increase-btn" 
                                                    data-id="<%= cartItem.getId() %>">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="item-actions">
                                        <div class="item-total" id="line-total-<%= cartItem.getId() %>">
                                            <%= formatter.format(cartItem.getProduct().getPrice().longValue() * cartItem.getQuantity()) %> VNĐ
                                        </div>
                                        <button type="button" class="remove-btn" data-id="<%= cartItem.getId() %>">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </form>
                        <% } else { %>
                        <div class="empty-cart">
                            <div class="empty-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <h3 class="empty-title">Giỏ hàng trống</h3>
                            <p class="empty-description">
                                Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy khám phá cửa hàng để tìm những sản phẩm yêu thích!
                            </p>
                            <a href="member-shop" class="shop-now-btn">
                                <i class="fas fa-store"></i>
                                Mua sắm ngay
                            </a>
                        </div>
                        <% } %>
                    </div>
                </div>

                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <div class="col-lg-4">
                    <!-- Cart Summary -->
                    <div class="cart-summary">
                        <h4 class="summary-title">
                            <i class="fas fa-calculator"></i>
                            Tóm tắt đơn hàng
                        </h4>

                        <div class="summary-row">
                            <span class="summary-label">Sản phẩm đã chọn:</span>
                            <span class="summary-value" id="selectedItemCount">0</span>
                        </div>

                        <div class="summary-row">
                            <span class="summary-label">Tạm tính:</span>
                            <span class="summary-value" id="subtotalAmount">0 VNĐ</span>
                        </div>

                        <div class="summary-row">
                            <span class="summary-label">Phí vận chuyển:</span>
                            <span class="summary-value">Miễn phí</span>
                        </div>

                        <div class="summary-row total-row">
                            <span class="summary-label">Tổng cộng:</span>
                            <span class="summary-value" id="totalAmount">0 VNĐ</span>
                        </div>

                        <a href="order?action=checkout" class="checkout-btn disabled" id="checkoutBtn">
                            <i class="fas fa-credit-card"></i>
                            <span>Thanh toán</span>
                        </a>

                        <div class="text-center mt-3">
                            <small style="color: rgba(255, 255, 255, 0.7);">
                                <i class="fas fa-shield-alt me-1"></i>
                                Thanh toán an toàn và bảo mật
                            </small>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
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
        let deleteRow = null;
        let deleteCartId = null;

        // Format number function
        function formatNumber(num) {
            return new Intl.NumberFormat('vi-VN').format(num);
        }

        // Update selected total and checkout button state
        function updateSelectedTotal() {
            let total = 0;
            let itemCount = 0;
            
            document.querySelectorAll('.select-cart-item:checked').forEach(function(cb) {
                const cartItem = cb.closest('.cart-item');
                const priceText = cartItem.querySelector('.item-price').textContent;
                const price = parseInt(priceText.replace(/[^\d]/g, ''));
                const qtyInput = cartItem.querySelector('.quantity-input');
                const qty = parseInt(qtyInput.value);
                
                total += price * qty;
                itemCount++;
                
                // Update visual selection
                cartItem.classList.add('selected');
            });

            // Update unselected items
            document.querySelectorAll('.select-cart-item:not(:checked)').forEach(function(cb) {
                cb.closest('.cart-item').classList.remove('selected');
            });

            // Update summary
            document.getElementById('selectedItemCount').textContent = itemCount + ' sản phẩm';
            document.getElementById('subtotalAmount').textContent = formatNumber(total) + ' VNĐ';
            document.getElementById('totalAmount').textContent = formatNumber(total) + ' VNĐ';

            // Update checkout button
            const checkoutBtn = document.getElementById('checkoutBtn');
            if (itemCount > 0) {
                checkoutBtn.classList.remove('disabled');
                checkoutBtn.classList.add('active');
            } else {
                checkoutBtn.classList.add('disabled');
                checkoutBtn.classList.remove('active');
            }
        }

        function updateQuantity(cartId, newQty, inputElement) {
            const cartItem = inputElement.closest('.cart-item');
            const priceText = cartItem.querySelector('.item-price').textContent;
            const price = parseInt(priceText.replace(/[^\d]/g, ''));
            const lineTotalElement = cartItem.querySelector('.item-total');
            
            // Update total immediately
            lineTotalElement.textContent = formatNumber(price * newQty) + ' VNĐ';
            
            // Update selected total if item is selected
            if (cartItem.querySelector('.select-cart-item').checked) {
                updateSelectedTotal();
            }

            // Send request to server
            fetch('member-cart?action=setquantity&id=' + cartId + '&quantity=' + newQty, {
                method: 'GET',
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    inputElement.value = data.newQuantity;
                    lineTotalElement.textContent = formatNumber(price * data.newQuantity) + ' VNĐ';
                    
                    // Update decrease button state
                    const decreaseBtn = cartItem.querySelector('.decrease-btn');
                    decreaseBtn.disabled = (data.newQuantity <= 1);
                    
                    if (cartItem.querySelector('.select-cart-item').checked) {
                        updateSelectedTotal();
                    }
                    
                    showToast('success', 'Cập nhật số lượng thành công');
                } else {
                    // Revert on failure
                    const oldQty = parseInt(inputElement.getAttribute('data-old-value') || '1');
                    inputElement.value = oldQty;
                    lineTotalElement.textContent = formatNumber(price * oldQty) + ' VNĐ';
                    updateSelectedTotal();
                    showToast('error', data.message || 'Có lỗi xảy ra!');
                }
            })
            .catch(() => {
                // Revert on error
                const oldQty = parseInt(inputElement.getAttribute('data-old-value') || '1');
                inputElement.value = oldQty;
                lineTotalElement.textContent = formatNumber(price * oldQty) + ' VNĐ';
                updateSelectedTotal();
                showToast('error', 'Lỗi mạng hoặc server!');
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Initialize toasts
            const toastElList = [].slice.call(document.querySelectorAll('.toast'));
            const toastList = toastElList.map(function(toastEl) {
                return new bootstrap.Toast(toastEl);
            });
            
            // Show toasts
            toastList.forEach(function(toast) {
                toast.show();
            });

            // Initialize checkout button state
            updateSelectedTotal();

            // Select all functionality
            const selectAllCheckbox = document.getElementById('selectAllCart');
            if (selectAllCheckbox) {
                selectAllCheckbox.addEventListener('change', function() {
                    document.querySelectorAll('.select-cart-item').forEach((cb) => {
                        cb.checked = this.checked;
                    });
                    updateSelectedTotal();
                });
            }

            // Individual item selection
            document.querySelectorAll('.select-cart-item').forEach((cb) => {
                cb.addEventListener('change', function() {
                    // Update select all checkbox
                    const totalItems = document.querySelectorAll('.select-cart-item').length;
                    const checkedItems = document.querySelectorAll('.select-cart-item:checked').length;
                    
                    if (selectAllCheckbox) {
                        selectAllCheckbox.checked = (checkedItems === totalItems);
                        selectAllCheckbox.indeterminate = (checkedItems > 0 && checkedItems < totalItems);
                    }
                    
                    updateSelectedTotal();
                });
            });

            // Quantity input direct editing
            document.querySelectorAll('.quantity-input').forEach(function(input) {
                // Store original value
                input.setAttribute('data-old-value', input.value);
                
                input.addEventListener('focus', function() {
                    this.setAttribute('data-old-value', this.value);
                });

                input.addEventListener('blur', function() {
                    const cartId = this.getAttribute('data-id');
                    let newQty = parseInt(this.value) || 1;
                    
                    // Validate quantity
                    if (newQty < 1) newQty = 1;
                    if (newQty > 999) newQty = 999;
                    
                    this.value = newQty;
                    
                    const oldQty = parseInt(this.getAttribute('data-old-value'));
                    if (newQty !== oldQty) {
                        updateQuantity(cartId, newQty, this);
                    }
                });

                input.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        this.blur();
                    }
                });
            });

            // Quantity buttons
            document.querySelectorAll('.quantity-btn').forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    const cartId = this.getAttribute('data-id');
                    const cartItem = this.closest('.cart-item');
                    const quantityInput = cartItem.querySelector('.quantity-input');
                    const oldQty = parseInt(quantityInput.value);
                    const action = this.classList.contains('increase-btn') ? 'increase' : 'decrease';
                    
                    if (action === 'decrease' && oldQty === 1) {
                        return; // Don't allow decrease below 1
                    }

                    // Show loading state
                    const originalContent = this.innerHTML;
                    this.innerHTML = '<div class="loading-spinner"></div>';
                    this.disabled = true;

                    // Update quantity optimistically
                    const newQty = oldQty + (action === 'increase' ? 1 : -1);
                    quantityInput.value = newQty;
                    quantityInput.setAttribute('data-old-value', oldQty);
                    
                    updateQuantity(cartId, newQty, quantityInput);
                    
                    // Restore button
                    setTimeout(() => {
                        this.innerHTML = originalContent;
                        this.disabled = false;
                    }, 500);
                });
            });

            // Remove item functionality
            const confirmDeleteModal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
            
            document.querySelectorAll('.remove-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    deleteRow = this.closest('.cart-item');
                    deleteCartId = this.getAttribute('data-id');
                    confirmDeleteModal.show();
                });
            });

            document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
                if (deleteRow && deleteCartId) {
                    // Show loading state
                    const originalContent = this.innerHTML;
                    this.innerHTML = '<div class="loading-spinner"></div> Đang xóa...';
                    this.disabled = true;

                    fetch('member-cart?action=remove&id=' + deleteCartId, {
                        method: 'GET',
                        headers: { 'X-Requested-With': 'XMLHttpRequest' }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Animate removal
                            deleteRow.style.transition = 'all 0.3s ease';
                            deleteRow.style.opacity = '0';
                            deleteRow.style.transform = 'translateX(100%)';
                            
                            setTimeout(() => {
                                deleteRow.remove();
                                updateSelectedTotal();
                                
                                // Check if cart is empty
                                if (document.querySelectorAll('.cart-item').length === 0) {
                                    location.reload(); // Reload to show empty state
                                }
                            }, 300);
                            
                            showToast('success', 'Đã xóa sản phẩm khỏi giỏ hàng');
                        } else {
                            showToast('error', data.message || 'Có lỗi xảy ra!');
                        }
                        
                        this.innerHTML = originalContent;
                        this.disabled = false;
                        confirmDeleteModal.hide();
                    })
                    .catch(() => {
                        showToast('error', 'Lỗi mạng hoặc server!');
                        this.innerHTML = originalContent;
                        this.disabled = false;
                        confirmDeleteModal.hide();
                    });
                }
            });

            // Add smooth animations on page load
            const cartItems = document.querySelectorAll('.cart-item');
            cartItems.forEach((item, index) => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    item.style.transition = 'all 0.6s ease';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });

        // Utility function to show toast messages
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
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
                '</div>';
            
            toastContainer.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast, { delay: 3000 });
            bsToast.show();
            
            // Remove toast element after it's hidden
            toast.addEventListener('hidden.bs.toast', () => {
                toast.remove();
            });
        }
    </script>
</body>
</html>
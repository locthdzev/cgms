<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Product" %>
<%@ page import="Models.Inventory" %>
<%@ page import="Services.UserService" %>
<%@ page import="Services.ProductService" %>
<%@ page import="Services.InventoryService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // Không khai báo lại loggedInUser vì navbar.jsp đã khai báo
    if (session.getAttribute("loggedInUser") == null || 
        !"Admin".equals(((User) session.getAttribute("loggedInUser")).getRole())) {
        response.sendRedirect("login");
        return;
    }

    // Lấy danh sách members và products
    UserService userService = new UserService();
    ProductService productService = new ProductService();
    InventoryService inventoryService = new InventoryService();
    
    List<User> members = userService.getAllMembers();
    List<Product> products = productService.getAllActiveProducts();

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
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Tạo đơn hàng - CGMS Admin</title>
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
        .page-header {
            background: var(--primary-gradient);
            border-radius: 20px;
            border: none;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
            position: relative;
        }

        .page-header::before {
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

        .back-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            color: white;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-btn:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
            text-decoration: none;
        }

        /* Form Cards */
        .form-section {
            background: white;
            border-radius: 20px;
            border: none;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-bottom: 2rem;
            transition: all 0.3s ease;
        }

        .form-section:hover {
            box-shadow: var(--card-shadow-hover);
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

        .section-body {
            padding: 2rem;
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-control-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            display: block;
        }

        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            width: 100%;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }

        /* Product Selection */
        .product-search-container {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid #e2e8f0;
        }

        .search-input-group {
            position: relative;
            margin-bottom: 1rem;
        }

        .search-input-group .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #718096;
            z-index: 2;
        }

        .search-input-group .form-control {
            padding-left: 3rem;
            padding-right: 3rem;
        }

        .search-clear-btn {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #718096;
            font-size: 1.2rem;
            cursor: pointer;
            z-index: 2;
        }

        .product-grid {
            display: grid;
            gap: 1rem;
            max-height: 500px;
            overflow-y: auto;
            padding-right: 0.5rem;
        }

        .product-grid::-webkit-scrollbar {
            width: 6px;
        }

        .product-grid::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .product-grid::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 10px;
        }

        .product-item {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            padding: 1.5rem;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }

        .product-item:hover {
            border-color: #cbd5e0;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .product-item.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #f8faff 0%, #e6edff 100%);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
        }

        .product-image {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            object-fit: cover;
        }

        .product-image-placeholder {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            background: var(--primary-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .product-info {
            flex: 1;
            margin-left: 1rem;
        }

        .product-name {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.25rem;
            font-size: 1rem;
        }

        .product-price {
            color: #059669;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .stock-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        .stock-info.in-stock {
            color: #059669;
        }

        .stock-info.low-stock {
            color: #d97706;
        }

        .stock-info.out-of-stock {
            color: #dc2626;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .quantity-btn {
            width: 36px;
            height: 36px;
            border: 2px solid #e2e8f0;
            background: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .quantity-btn:hover:not(:disabled) {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .quantity-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .quantity-input {
            width: 60px;
            text-align: center;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.5rem;
        }

        /* Order Summary */
        .order-summary {
            background: var(--primary-gradient);
            border-radius: 20px;
            padding: 2rem;
            color: white;
            position: sticky;
            top: 20px;
            box-shadow: var(--card-shadow);
        }

        .summary-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .selected-products {
            margin-bottom: 1.5rem;
            min-height: 150px;
        }

        .selected-product-item {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .total-section {
            border-top: 1px solid rgba(255, 255, 255, 0.2);
            padding-top: 1.5rem;
            margin-top: 1.5rem;
        }

        .total-amount {
            font-size: 1.75rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .create-order-btn {
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
        }

        .create-order-btn:hover:not(:disabled) {
            background: white;
            color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(255, 255, 255, 0.3);
        }

        .create-order-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .create-order-btn.active {
            background: var(--success-gradient);
            border-color: transparent;
        }

        .create-order-btn.active:hover {
            background: var(--success-gradient);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(17, 153, 142, 0.4);
        }

        /* Payment Methods */
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
            gap: 0.75rem;
            padding: 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .payment-option input[type="radio"]:checked + .payment-label {
            border-color: #667eea;
            background: linear-gradient(135deg, #f8faff 0%, #e6edff 100%);
            color: #667eea;
        }

        /* Empty State */
        .empty-products {
            text-align: center;
            padding: 3rem;
            color: #718096;
        }

        .empty-products i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
            }

            .header-content {
                padding: 1.5rem;
            }

            .header-title {
                font-size: 1.5rem;
            }

            .section-body {
                padding: 1.5rem;
            }

            .payment-methods {
                grid-template-columns: 1fr;
            }

            .order-summary {
                position: static;
                margin-top: 2rem;
            }

            .header-content .d-flex {
                flex-direction: column-reverse;
                gap: 1rem;
            }

            .back-btn {
                align-self: flex-start;
            }
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
    
    <!-- Sidebar -->
    <%@ include file="sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <%@ include file="navbar.jsp" %>

        <div class="container-fluid py-4">
            <!-- Header -->
            <div class="page-header">
                <div class="header-content">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <a href="admin-orders" class="back-btn">
                                <i class="fas fa-arrow-left"></i>
                                Quay lại danh sách
                            </a>
                        </div>
                        <div class="text-end">
                            <h1 class="header-title">
                                <i class="fas fa-plus-circle me-3"></i>
                                Tạo đơn hàng mới
                            </h1>
                            <p class="header-subtitle">
                                Tạo đơn hàng cho khách hàng tại cơ sở
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <form action="admin-orders" method="post" id="createOrderForm">
                <input type="hidden" name="action" value="admin-create">
                
                <div class="row">
                    <!-- Customer Information -->
                    <div class="col-lg-4 col-md-6">
                        <div class="form-section">
                            <div class="section-header">
                                <h3 class="section-title">
                                    <i class="fas fa-user text-primary"></i>
                                    Thông tin khách hàng
                                </h3>
                                <p class="section-subtitle">Chọn khách hàng và thông tin giao hàng</p>
                            </div>
                            <div class="section-body">
                                <div class="form-group">
                                    <label class="form-control-label">Chọn khách hàng *</label>
                                    <select class="form-select" name="customerId" required>
                                        <option value="">-- Chọn khách hàng --</option>
                                        <% if (members != null) { 
                                            for (User member : members) { %>
                                        <option value="<%= member.getId() %>">
                                            <%= member.getFullName() %> - <%= member.getEmail() %>
                                        </option>
                                        <% } } %>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-control-label">Địa chỉ giao hàng *</label>
                                    <textarea class="form-control" name="shippingAddress" rows="3" required 
                                        placeholder="Nhập địa chỉ giao hàng"></textarea>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-control-label">Tên người nhận *</label>
                                            <input type="text" class="form-control" name="receiverName" required 
                                                placeholder="Tên người nhận">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-control-label">Số điện thoại *</label>
                                            <input type="tel" class="form-control" name="receiverPhone" required 
                                                placeholder="Số điện thoại">
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-control-label">Phương thức thanh toán *</label>
                                    <div class="payment-methods">
                                        <div class="payment-option">
                                            <input type="radio" name="paymentMethod" value="Cash" id="cashPayment" checked>
                                            <label class="payment-label" for="cashPayment">
                                                <i class="fas fa-money-bill-wave"></i>
                                                Tiền mặt
                                            </label>
                                        </div>
                                        <div class="payment-option">
                                            <input type="radio" name="paymentMethod" value="PayOS" id="payosPayment">
                                            <label class="payment-label" for="payosPayment">
                                                <i class="fas fa-credit-card"></i>
                                                PayOS
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-control-label">Ghi chú</label>
                                    <textarea class="form-control" name="notes" rows="2" 
                                        placeholder="Ghi chú đơn hàng (tùy chọn)"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product Selection -->
                    <div class="col-lg-5 col-md-6">
                        <div class="form-section">
                            <div class="section-header">
                                <h3 class="section-title">
                                    <i class="fas fa-box text-info"></i>
                                    Chọn sản phẩm
                                </h3>
                                <p class="section-subtitle">Tìm kiếm và chọn sản phẩm cho đơn hàng</p>
                            </div>
                            <div class="section-body">
                                <!-- Search Box -->
                                <div class="product-search-container">
                                    <div class="search-input-group">
                                        <i class="fas fa-search search-icon"></i>
                                        <input type="text" class="form-control" id="productSearch" 
                                            placeholder="Tìm kiếm sản phẩm...">
                                        <button type="button" class="search-clear-btn" onclick="clearSearch()">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <i class="fas fa-info-circle me-1"></i>
                                            <span id="productCount"><%= products != null ? products.size() : 0 %></span> sản phẩm có sẵn
                                        </small>
                                        <small class="text-muted" id="selectedCount">
                                            <i class="fas fa-check-circle me-1"></i>
                                            0 sản phẩm đã chọn
                                        </small>
                                    </div>
                                </div>

                                <div class="product-grid">
                                    <% if (products != null && !products.isEmpty()) { 
                                        for (Product product : products) { 
                                            Inventory inventory = inventoryService.getInventoryByProductId(product.getId());
                                            int stockQuantity = (inventory != null && inventory.getQuantity() != null) ? inventory.getQuantity() : 0;
                                            String stockClass = stockQuantity <= 0 ? "out-of-stock" : (stockQuantity <= 10 ? "low-stock" : "in-stock");
                                    %>
                                    <div class="product-item" 
                                        data-product-id="<%= product.getId() %>" 
                                        data-product-price="<%= product.getPrice() %>"
                                        data-product-name="<%= product.getName().toLowerCase() %>"
                                        data-stock-quantity="<%= stockQuantity %>">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-shrink-0">
                                                <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                                                <img src="<%= product.getImageUrl() %>" class="product-image" alt="Product">
                                                <% } else { %>
                                                <div class="product-image-placeholder">
                                                    <i class="fas fa-box"></i>
                                                </div>
                                                <% } %>
                                            </div>
                                            <div class="product-info">
                                                <h6 class="product-name"><%= product.getName() %></h6>
                                                <div class="product-price">
                                                    <%= formatter.format(product.getPrice().longValue()) %> VNĐ
                                                </div>
                                                <div class="stock-info <%= stockClass %>">
                                                    <i class="fas <%= stockQuantity <= 0 ? "fa-times-circle" : (stockQuantity <= 10 ? "fa-exclamation-triangle" : "fa-check-circle") %>"></i>
                                                    <span>Kho: <%= stockQuantity %> sản phẩm</span>
                                                </div>
                                            </div>
                                            <div class="flex-shrink-0">
                                                <div class="quantity-controls">
                                                    <button type="button" class="quantity-btn" onclick="decreaseQuantity(this)"
                                                            <%= stockQuantity <= 0 ? "disabled" : "" %>>
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <input type="number" class="quantity-input" 
                                                        min="0" max="<%= stockQuantity %>" value="0" 
                                                        onchange="updateProductSelection(this)"
                                                        <%= stockQuantity <= 0 ? "disabled" : "" %>>
                                                    <button type="button" class="quantity-btn" onclick="increaseQuantity(this)"
                                                            <%= stockQuantity <= 0 ? "disabled" : "" %>>
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <% } } else { %>
                                    <div class="empty-products">
                                        <i class="fas fa-box-open"></i>
                                        <h5>Không có sản phẩm nào</h5>
                                        <p>Hiện tại chưa có sản phẩm nào có sẵn</p>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Summary -->
                    <div class="col-lg-3">
                        <div class="order-summary">
                            <h4 class="summary-title">
                                <i class="fas fa-shopping-cart"></i>
                                Tóm tắt đơn hàng
                            </h4>
                            
                            <div class="selected-products" id="selectedProducts">
                                <div class="text-center text-white-50">
                                    <i class="fas fa-shopping-cart fa-2x mb-3"></i>
                                    <p class="mb-0">Chưa chọn sản phẩm nào</p>
                                </div>
                            </div>
                            
                            <div class="total-section">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span class="fw-bold">Tổng cộng:</span>
                                    <span class="total-amount" id="totalAmount">0 VNĐ</span>
                                </div>
                                
                                <button type="submit" class="create-order-btn" id="submitBtn" disabled>
                                    <i class="fas fa-plus"></i>
                                    <span>Tạo đơn hàng</span>
                                </button>

                                <div class="text-center mt-3">
                                    <small class="text-white-50">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Vui lòng chọn ít nhất 1 sản phẩm
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </main>

    <!-- Core JS Files -->
    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

    <script>
        console.log('Script loading...');
        
        let selectedProducts = [];
        let totalAmount = 0;

        // Format number function
        function formatNumber(num) {
            return new Intl.NumberFormat('vi-VN').format(num);
        }

        // Product search functionality
        function initializeSearch() {
            console.log('Initializing search...');
            const searchInput = document.getElementById('productSearch');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    console.log('Search input changed:', this.value);
                    const searchTerm = this.value.toLowerCase().trim();
                    const productItems = document.querySelectorAll('.product-item');
                    let visibleCount = 0;

                    productItems.forEach(function(item) {
                        const productName = item.getAttribute('data-product-name');
                        if (productName && productName.includes(searchTerm)) {
                            item.style.display = 'block';
                            visibleCount++;
                        } else {
                            item.style.display = 'none';
                        }
                    });

                    const productCountElement = document.getElementById('productCount');
                    if (productCountElement) {
                        productCountElement.textContent = visibleCount;
                    }
                });
                console.log('Search initialized successfully');
            } else {
                console.error('Search input not found');
            }
        }

        function clearSearch() {
            console.log('Clearing search...');
            const searchInput = document.getElementById('productSearch');
            if (searchInput) {
                searchInput.value = '';
                const productItems = document.querySelectorAll('.product-item');
                productItems.forEach(function(item) {
                    item.style.display = 'block';
                });
                
                const productCountElement = document.getElementById('productCount');
                if (productCountElement) {
                    productCountElement.textContent = productItems.length;
                }
                console.log('Search cleared');
            }
        }

        function increaseQuantity(button) {
            console.log('Increasing quantity...');
            const quantityInput = button.parentElement.querySelector('.quantity-input');
            if (quantityInput) {
                const currentValue = parseInt(quantityInput.value) || 0;
                const maxStock = parseInt(quantityInput.getAttribute('max')) || 100;
                quantityInput.value = Math.min(maxStock, currentValue + 1);
                console.log('New quantity:', quantityInput.value);
                updateProductSelection(quantityInput);
            }
        }

        function decreaseQuantity(button) {
            console.log('Decreasing quantity...');
            const quantityInput = button.parentElement.querySelector('.quantity-input');
            if (quantityInput) {
                const currentValue = parseInt(quantityInput.value) || 0;
                quantityInput.value = Math.max(0, currentValue - 1);
                console.log('New quantity:', quantityInput.value);
                updateProductSelection(quantityInput);
            }
        }

        function updateProductSelection(quantityInput) {
            console.log('Updating product selection...');
            const productItem = quantityInput.closest('.product-item');
            if (productItem) {
                const quantity = parseInt(quantityInput.value) || 0;
                console.log('Product quantity:', quantity);
                
                if (quantity > 0) {
                    productItem.classList.add('selected');
                    console.log('Product selected');
                } else {
                    productItem.classList.remove('selected');
                    console.log('Product deselected');
                }
                
                updateSelectedProducts();
            }
        }

        function updateSelectedProducts() {
            console.log('Updating selected products list...');
            selectedProducts = [];
            totalAmount = 0;
            
            const selectedItems = document.querySelectorAll('.product-item.selected');
            console.log('Selected items count:', selectedItems.length);
            
            selectedItems.forEach(function(item) {
                const productId = item.getAttribute('data-product-id');
                const productPrice = parseFloat(item.getAttribute('data-product-price'));
                const productNameElement = item.querySelector('.product-name');
                const quantityInput = item.querySelector('.quantity-input');
                
                if (productNameElement && quantityInput) {
                    const productName = productNameElement.textContent;
                    const quantity = parseInt(quantityInput.value) || 0;
                    
                    if (quantity > 0 && !isNaN(productPrice)) {
                        const subtotal = productPrice * quantity;
                        selectedProducts.push({
                            id: productId,
                            name: productName,
                            price: productPrice,
                            quantity: quantity,
                            subtotal: subtotal
                        });
                        totalAmount += subtotal;
                        console.log('Added product:', productName, 'Quantity:', quantity, 'Subtotal:', subtotal);
                    }
                }
            });
            
            console.log('Total selected products:', selectedProducts.length);
            console.log('Total amount:', totalAmount);
            
            updateOrderSummary();
            updateSelectedCount();
        }

        function updateSelectedCount() {
            const selectedCount = selectedProducts.length;
            const selectedCountElement = document.getElementById('selectedCount');
            if (selectedCountElement) {
                selectedCountElement.innerHTML = 
                    '<i class="fas fa-check-circle me-1"></i>' + selectedCount + ' sản phẩm đã chọn';
            }
        }

        function updateOrderSummary() {
            console.log('Updating order summary...');
            const selectedProductsDiv = document.getElementById('selectedProducts');
            const totalAmountDiv = document.getElementById('totalAmount');
            const submitBtn = document.getElementById('submitBtn');
            
            if (selectedProductsDiv && totalAmountDiv && submitBtn) {
                if (selectedProducts.length === 0) {
                    selectedProductsDiv.innerHTML = 
                        '<div class="text-center text-white-50">' +
                        '<i class="fas fa-shopping-cart fa-2x mb-3"></i>' +
                        '<p class="mb-0">Chưa chọn sản phẩm nào</p>' +
                        '</div>';
                    submitBtn.disabled = true;
                    submitBtn.classList.remove('active');
                } else {
                    let html = '';
                    selectedProducts.forEach(function(product) {
                        html += 
                            '<div class="selected-product-item">' +
                            '<div class="d-flex justify-content-between align-items-center w-100">' +
                            '<div>' +
                            '<div class="fw-bold" style="font-size: 0.9rem;">' + product.name + '</div>' +
                            '<small class="opacity-75">Số lượng: ' + product.quantity + '</small>' +
                            '</div>' +
                            '<div class="text-end">' +
                            '<div class="fw-bold">' + formatNumber(product.subtotal) + ' VNĐ</div>' +
                            '</div>' +
                            '</div>' +
                            '</div>';
                    });
                    selectedProductsDiv.innerHTML = html;
                    submitBtn.disabled = false;
                    submitBtn.classList.add('active');
                }
                
                totalAmountDiv.textContent = formatNumber(totalAmount) + ' VNĐ';
                console.log('Order summary updated');
            }
        }

        // Initialize everything when DOM is loaded
        document.addEventListener("DOMContentLoaded", function () {
            console.log('DOM loaded, initializing...');
            
            // Initialize toasts
            var toastElList = [].slice.call(document.querySelectorAll('.toast'));
            var toastList = toastElList.map(function(toastEl) {
                return new bootstrap.Toast(toastEl);
            });
            
            // Show toasts
            toastList.forEach(function(toast) {
                toast.show();
            });

            // Initialize search functionality
            initializeSearch();
            
            // Initialize product selection
            updateSelectedProducts();
            
            console.log('Initialization complete');
        });

        // Add hidden inputs for selected products before form submission
        document.getElementById('createOrderForm').addEventListener('submit', function(e) {
            console.log('Form submitting with products:', selectedProducts);
            
            // Remove existing product inputs
            const existingInputs = document.querySelectorAll('input[name^="products["]');
            existingInputs.forEach(function(input) {
                input.remove();
            });
            
            // Add selected products as hidden inputs
            const form = this;
            selectedProducts.forEach(function(product, index) {
                // Product ID
                const productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'products[' + index + '].productId';
                productIdInput.value = product.id;
                form.appendChild(productIdInput);
                
                // Quantity
                const quantityInput = document.createElement('input');
                quantityInput.type = 'hidden';
                quantityInput.name = 'products[' + index + '].quantity';
                quantityInput.value = product.quantity;
                form.appendChild(quantityInput);
                
                // Unit Price
                const priceInput = document.createElement('input');
                priceInput.type = 'hidden';
                priceInput.name = 'products[' + index + '].unitPrice';
                priceInput.value = product.price;
                form.appendChild(priceInput);
            });

            // Add loading effect to submit button
            const submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang tạo đơn hàng...';
                submitBtn.disabled = true;
            }
        });
    </script>
</body>
</html>
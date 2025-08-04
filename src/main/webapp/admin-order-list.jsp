<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Không khai báo lại loggedInUser vì navbar.jsp đã khai báo
    // User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (session.getAttribute("loggedInUser") == null ||
        !"Admin".equals(((User) session.getAttribute("loggedInUser")).getRole())) {
        response.sendRedirect("login");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    List<Order> allOrders = (List<Order>) request.getAttribute("allOrders");
    String currentFilter = (String) request.getAttribute("currentFilter");

    if (currentFilter == null) currentFilter = "ALL";

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
    <title>Quản lý đơn hàng - CGMS Admin</title>
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
            --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            --confirmed-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --cancelled-gradient: linear-gradient(135deg, #6c757d 0%, #495057 100%);
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
        .header-card {
            background: var(--primary-gradient);
            border-radius: 20px;
            border: none;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
            position: relative;
        }

        .header-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="25" cy="75" r="1" fill="white" opacity="0.05"/><circle cx="75" cy="25" r="1" fill="white" opacity="0.05"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
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

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 1400px) {
            .stats-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 992px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 576px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        .stats-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            border: none;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--card-shadow-hover);
            color: inherit;
            text-decoration: none;
        }

        .stats-card.active {
            background: var(--primary-gradient);
            color: white;
            transform: translateY(-5px);
            box-shadow: var(--card-shadow-hover);
        }

        .stats-card.active .stats-number,
        .stats-card.active .stats-label {
            color: white;
        }

        .stats-card.active .stats-icon {
            background: rgba(255, 255, 255, 0.2);
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            opacity: 0.1;
            transition: all 0.3s ease;
        }

        .stats-card.primary::before { background: var(--primary-gradient); }
        .stats-card.warning::before { background: var(--warning-gradient); }
        .stats-card.info::before { background: var(--info-gradient); }
        .stats-card.success::before { background: var(--success-gradient); }
        .stats-card.confirmed::before { background: var(--confirmed-gradient); }
        .stats-card.cancelled::before { background: var(--cancelled-gradient); }

        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.5rem;
            color: white;
        }

        .stats-icon.primary { background: var(--primary-gradient); }
        .stats-icon.warning { background: var(--warning-gradient); }
        .stats-icon.info { background: var(--info-gradient); }
        .stats-icon.success { background: var(--success-gradient); }
        .stats-icon.confirmed { background: var(--confirmed-gradient); }
        .stats-icon.cancelled { background: var(--cancelled-gradient); }

        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #2d3748;
        }

        .stats-label {
            color: #718096;
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .filter-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .filter-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .filter-btn {
            padding: 0.75rem 1.5rem;
            border-radius: 30px;
            border: 2px solid #e2e8f0;
            background: white;
            color: #718096;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.875rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-btn:hover {
            background: #f8fafc;
            color: #4a5568;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .filter-btn.active {
            background: var(--primary-gradient);
            color: white;
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .filter-btn.active:hover {
            color: white;
        }

        /* Order Cards */
        .orders-container {
            display: grid;
            gap: 1.5rem;
        }

        .order-card {
            background: white;
            border-radius: 20px;
            border: none;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            overflow: hidden;
            position: relative;
        }

        .order-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--card-shadow-hover);
        }

        .order-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 1.5rem 2rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .order-id {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.25rem;
        }

        .order-date {
            color: #718096;
            font-size: 0.875rem;
        }

        .order-body {
            padding: 2rem;
        }

        .order-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            align-items: center;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #a0aec0;
            margin-bottom: 0.5rem;
        }

        .info-value {
            font-size: 1rem;
            font-weight: 600;
            color: #2d3748;
        }

        .info-sub {
            font-size: 0.875rem;
            color: #718096;
            margin-top: 0.25rem;
        }

        /* Status Badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pending {
            background: linear-gradient(135deg, #fef3c7 0%, #fcd34d 100%);
            color: #92400e;
        }

        .status-confirmed {
            background: linear-gradient(135deg, #dbeafe 0%, #93c5fd 100%);
            color: #1e40af;
        }

        .status-shipping {
            background: linear-gradient(135deg, #f3e8ff 0%, #c4b5fd 100%);
            color: #7c3aed;
        }

        .status-completed {
            background: linear-gradient(135deg, #d1fae5 0%, #6ee7b7 100%);
            color: #065f46;
        }

        .status-cancelled {
            background: linear-gradient(135deg, #fee2e2 0%, #fca5a5 100%);
            color: #dc2626;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-modern {
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.875rem;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-modern {
            background: var(--primary-gradient);
            color: white;
        }

        .btn-primary-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }

        .btn-success-modern {
            background: var(--success-gradient);
            color: white;
        }

        .btn-success-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(17, 153, 142, 0.3);
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

        /* Create Order Button */
        .create-order-btn {
            background: var(--success-gradient);
            border: none;
            border-radius: 16px;
            padding: 1rem 2rem;
            color: white;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }

        .create-order-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(17, 153, 142, 0.4);
            color: white;
            text-decoration: none;
        }

        .refresh-btn {
            background: var(--info-gradient);
            border: none;
            border-radius: 16px;
            padding: 1rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-left: 1rem;
        }

        .refresh-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(79, 172, 254, 0.4);
            color: white;
        }

        /* Empty State */
        .empty-state {
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

        /* Modals */
        .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
        }

        .modal-header {
            background: var(--primary-gradient);
            color: white;
            border-radius: 20px 20px 0 0;
            padding: 1.5rem 2rem;
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
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header-content {
                padding: 1.5rem;
            }

            .header-title {
                font-size: 1.5rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .order-info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                justify-content: stretch;
            }

            .action-buttons .btn-modern {
                flex: 1;
                justify-content: center;
            }

            .filter-buttons {
                justify-content: center;
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
            <div class="header-card">
                <div class="header-content">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="header-title">
                                <i class="fas fa-shopping-cart me-3"></i>
                                Quản lý đơn hàng
                            </h1>
                            <p class="header-subtitle">
                                Theo dõi và quản lý tất cả đơn hàng trong hệ thống
                            </p>
                        </div>
                        <div class="d-flex align-items-center">
                            <a href="admin-orders?action=create" class="create-order-btn">
                                <i class="fas fa-plus"></i>
                                Tạo đơn hàng
                            </a>
                            <button class="refresh-btn" onclick="refreshOrders()">
                                <i class="fas fa-sync-alt"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <%
                    int pendingCount = 0, confirmedCount = 0, shippingCount = 0, completedCount = 0, cancelledCount = 0;
                    if (allOrders != null) {
                        for (Order order : allOrders) {
                            switch (order.getStatus()) {
                                case "PENDING": pendingCount++; break;
                                case "CONFIRMED": confirmedCount++; break;
                                case "SHIPPING": shippingCount++; break;
                                case "COMPLETED": completedCount++; break;
                                case "CANCELLED": cancelledCount++; break;
                            }
                        }
                    }
                %>

                <a href="admin-orders?status=ALL" class="stats-card primary <%= "ALL".equals(currentFilter) ? "active" : "" %>" style="text-decoration: none;">
                    <div class="stats-icon primary">
                        <i class="fas fa-shopping-bag"></i>
                    </div>
                    <div class="stats-number">
                        <%= allOrders != null ? allOrders.size() : 0 %>
                    </div>
                    <div class="stats-label">Tổng đơn hàng</div>
                </a>

                <a href="admin-orders?status=PENDING" class="stats-card warning <%= "PENDING".equals(currentFilter) ? "active" : "" %>" style="text-decoration: none;">
                    <div class="stats-icon warning">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stats-number">
                        <%= pendingCount %>
                    </div>
                    <div class="stats-label">Chờ xác nhận</div>
                </a>

                <a href="admin-orders?status=CONFIRMED" class="stats-card confirmed <%= "CONFIRMED".equals(currentFilter) ? "active" : "" %>" style="text-decoration: none;">
                    <div class="stats-icon confirmed">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stats-number">
                        <%= confirmedCount %>
                    </div>
                    <div class="stats-label">Đã xác nhận</div>
                </a>

                <a href="admin-orders?status=SHIPPING" class="stats-card info <%= "SHIPPING".equals(currentFilter) ? "active" : "" %>" style="text-decoration: none;">
                    <div class="stats-icon info">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div class="stats-number">
                        <%= shippingCount %>
                    </div>
                    <div class="stats-label">Đang vận chuyển</div>
                </a>

                <a href="admin-orders?status=COMPLETED" class="stats-card success <%= "COMPLETED".equals(currentFilter) ? "active" : "" %>" style="text-decoration: none;">
                    <div class="stats-icon success">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="stats-number">
                        <%= completedCount %>
                    </div>
                    <div class="stats-label">Hoàn thành</div>
                </a>

                <a href="admin-orders?status=CANCELLED" class="stats-card cancelled <%= "CANCELLED".equals(currentFilter) ? "active" : "" %>" style="text-decoration: none;">
                    <div class="stats-icon cancelled">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stats-number">
                        <%= cancelledCount %>
                    </div>
                    <div class="stats-label">Đã hủy</div>
                </a>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="filter-title">
                    <i class="fas fa-filter"></i>
                    Lọc theo trạng thái đơn hàng
                </div>
                <div class="filter-buttons">
                    <a href="admin-orders?status=ALL" class="filter-btn <%= "ALL".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-list"></i>
                        Tất cả (<%= allOrders != null ? allOrders.size() : 0 %>)
                    </a>
                    <a href="admin-orders?status=PENDING" class="filter-btn <%= "PENDING".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-clock"></i>
                        Chờ xác nhận (<%= pendingCount %>)
                    </a>
                    <a href="admin-orders?status=CONFIRMED" class="filter-btn <%= "CONFIRMED".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-check-circle"></i>
                        Đã xác nhận (<%= confirmedCount %>)
                    </a>
                    <a href="admin-orders?status=SHIPPING" class="filter-btn <%= "SHIPPING".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-truck"></i>
                        Đang vận chuyển (<%= shippingCount %>)
                    </a>
                    <a href="admin-orders?status=COMPLETED" class="filter-btn <%= "COMPLETED".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-check"></i>
                        Hoàn thành (<%= completedCount %>)
                    </a>
                    <a href="admin-orders?status=CANCELLED" class="filter-btn <%= "CANCELLED".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-times-circle"></i>
                        Đã hủy (<%= cancelledCount %>)
                    </a>
                </div>
            </div>

            <!-- Orders List -->
            <div class="orders-container">
                <% if (orders != null && !orders.isEmpty()) { %>
                    <% for (Order order : orders) { %>
                    <div class="order-card">
                        <div class="order-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="order-id">#<%= order.getId() %></div>
                                    <div class="order-date">
                                        <%= order.getCreatedAt().atZone(java.time.ZoneId.systemDefault()).format(dateFormatter) %>
                                    </div>
                                </div>
                                <div>
                                    <%
                                        String statusClass = "";
                                        String statusText = "";
                                        switch (order.getStatus()) {
                                            case "PENDING":
                                                statusClass = "status-pending";
                                                statusText = "Chờ xác nhận";
                                                break;
                                            case "CONFIRMED":
                                                statusClass = "status-confirmed";
                                                statusText = "Đã xác nhận";
                                                break;
                                            case "SHIPPING":
                                                statusClass = "status-shipping";
                                                statusText = "Đang vận chuyển";
                                                break;
                                            case "COMPLETED":
                                                statusClass = "status-completed";
                                                statusText = "Hoàn thành";
                                                break;
                                            case "CANCELLED":
                                                statusClass = "status-cancelled";
                                                statusText = "Đã hủy";
                                                break;
                                            default:
                                                statusClass = "status-pending";
                                                statusText = order.getStatus();
                                        }
                                    %>
                                    <span class="status-badge <%= statusClass %>">
                                        <i class="fas fa-circle me-2" style="font-size: 0.5rem"></i>
                                        <%= statusText %>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="order-body">
                            <div class="order-info-grid">
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-user me-1"></i>
                                        Khách hàng
                                    </div>
                                    <div class="info-value">
                                        <%= order.getMember().getFullName() %>
                                    </div>
                                    <div class="info-sub">
                                        <%= order.getMember().getEmail() %>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-money-bill-wave me-1"></i>
                                        Tổng tiền
                                    </div>
                                    <div class="info-value" style="color: #059669">
                                        <%= formatter.format(order.getTotalAmount().longValue()) %> VNĐ
                                    </div>
                                    <div class="info-sub">
                                        <%= "CASH".equals(order.getPaymentMethod()) ? "Tiền mặt" : "PayOS" %>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-map-marker-alt me-1"></i>
                                        Địa chỉ giao hàng
                                    </div>
                                    <div class="info-value">
                                        <%= order.getShippingAddress() != null ?
                                            (order.getShippingAddress().length() > 50 ?
                                                order.getShippingAddress().substring(0, 50) + "..." :
                                                order.getShippingAddress()) : "N/A" %>
                                    </div>
                                    <div class="info-sub">
                                        <%= order.getReceiverName() != null ? order.getReceiverName() : "N/A" %>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-cogs me-1"></i>
                                        Thao tác
                                    </div>
                                    <div class="action-buttons">
                                        <a href="admin-orders?action=details&id=<%= order.getId() %>" class="btn btn-modern btn-primary-modern">
                                            <i class="fas fa-eye"></i>
                                            Chi tiết
                                        </a>

                                        <% if (!"CANCELLED".equals(order.getStatus()) && !"COMPLETED".equals(order.getStatus())) { %>
                                        <button type="button" class="btn btn-modern btn-success-modern update-status-btn"
                                                data-order-id="<%= order.getId() %>"
                                                data-current-status="<%= order.getStatus() %>">
                                            <i class="fas fa-edit"></i>
                                            Cập nhật
                                        </button>

                                        <button type="button" class="btn btn-modern btn-danger-modern cancel-order-btn"
                                                data-order-id="<%= order.getId() %>">
                                            <i class="fas fa-times"></i>
                                            Hủy
                                        </button>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                <% } else { %>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-shopping-bag"></i>
                    </div>
                    <% if ("ALL".equals(currentFilter)) { %>
                        <h3 class="empty-title">Chưa có đơn hàng nào</h3>
                        <p class="empty-description">
                            Hệ thống chưa có đơn hàng nào được tạo. Hãy tạo đơn hàng đầu tiên!
                        </p>
                        <a href="admin-orders?action=create" class="create-order-btn">
                            <i class="fas fa-plus"></i>
                            Tạo đơn hàng đầu tiên
                        </a>
                    <% } else { %>
                        <h3 class="empty-title">Không có đơn hàng nào với trạng thái này</h3>
                        <p class="empty-description">
                            Không tìm thấy đơn hàng nào với trạng thái "<%= currentFilter.toLowerCase() %>". Hãy thử lọc theo trạng thái khác hoặc tạo đơn hàng mới.
                        </p>
                        <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                            <a href="admin-orders?status=ALL" class="create-order-btn" style="background: var(--info-gradient);">
                                <i class="fas fa-list"></i>
                                Xem tất cả đơn hàng
                            </a>
                            <a href="admin-orders?action=create" class="create-order-btn">
                                <i class="fas fa-plus"></i>
                                Tạo đơn hàng mới
                            </a>
                        </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </main>

    <!-- Update Status Modal -->
    <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateStatusModalLabel">
                        <i class="fas fa-edit me-2"></i>
                        Cập nhật trạng thái đơn hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin-orders" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update-status"/>
                        <input type="hidden" name="orderId" id="updateOrderId"/>

                        <div class="form-group mb-3">
                            <label class="form-control-label fw-bold">Trạng thái mới</label>
                            <select class="form-control" name="newStatus" id="newStatusSelect" required>
                                <option value="">-- Chọn trạng thái --</option>
                                <option value="PENDING">Chờ xác nhận</option>
                                <option value="CONFIRMED">Đã xác nhận</option>
                                <option value="SHIPPING">Đang vận chuyển</option>
                                <option value="COMPLETED">Hoàn thành</option>
                                <option value="CANCELLED">Hủy đơn hàng</option>
                            </select>
                        </div>

                        <div class="alert" style="background: linear-gradient(135deg, #dbeafe 0%, #93c5fd 100%); color: #1e40af; border-radius: 12px;">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Lưu ý:</strong> Khách hàng sẽ nhận được email thông báo khi trạng thái đơn hàng thay đổi.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-modern" style="background: #6c757d; color: white" data-bs-dismiss="modal">
                            Hủy
                        </button>
                        <button type="submit" class="btn btn-modern btn-primary-modern">
                            <i class="fas fa-save me-2"></i>
                            Cập nhật trạng thái
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Cancel Order Modal -->
    <div class="modal fade" id="cancelOrderModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background: var(--danger-gradient)">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Hủy đơn hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="admin-orders" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="admin-cancel"/>
                        <input type="hidden" name="orderId" id="cancelOrderId"/>

                        <div class="alert" style="background: linear-gradient(135deg, #fef3c7 0%, #fcd34d 100%); color: #92400e; border-radius: 12px;">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Cảnh báo:</strong> Hành động này không thể hoàn tác!
                        </div>

                        <p class="mb-3 fw-medium">
                            Bạn có chắc chắn muốn hủy đơn hàng này không?
                        </p>

                        <div class="form-group">
                            <label class="form-control-label fw-bold">Lý do hủy đơn hàng *</label>
                            <textarea class="form-control" name="reason" rows="3" required
                                      placeholder="Nhập lý do hủy đơn hàng" style="border-radius: 12px"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-modern" style="background: #6c757d; color: white" data-bs-dismiss="modal">
                            Đóng
                        </button>
                        <button type="submit" class="btn btn-modern btn-danger-modern">
                            <i class="fas fa-trash me-2"></i>
                            Hủy đơn hàng
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
        function showUpdateStatusModal(orderId, currentStatus) {
            document.getElementById('updateOrderId').value = orderId;
            document.getElementById('newStatusSelect').value = currentStatus;
            var modal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
            modal.show();
        }

        function showCancelOrderModal(orderId) {
            document.getElementById('cancelOrderId').value = orderId;
            var modal = new bootstrap.Modal(document.getElementById('cancelOrderModal'));
            modal.show();
        }

        function refreshOrders() {
            // Add loading effect
            const refreshBtn = document.querySelector('.refresh-btn');
            const icon = refreshBtn.querySelector('i');
            icon.style.animation = 'spin 1s linear infinite';

            setTimeout(() => {
                window.location.reload();
            }, 500);
        }

        // Add CSS animation for refresh button
        const style = document.createElement('style');
        style.textContent = `
            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
        `;
        document.head.appendChild(style);

        // Add event listeners
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize toasts
            var toastElList = [].slice.call(document.querySelectorAll('.toast'));
            var toastList = toastElList.map(function (toastEl) {
                return new bootstrap.Toast(toastEl);
            });

            // Show toasts
            toastList.forEach(function (toast) {
                toast.show();
            });

            // Update status buttons
            const updateButtons = document.querySelectorAll('.update-status-btn');
            updateButtons.forEach(function (button) {
                button.addEventListener('click', function () {
                    const orderId = this.getAttribute('data-order-id');
                    const currentStatus = this.getAttribute('data-current-status');
                    showUpdateStatusModal(orderId, currentStatus);
                });
            });

            // Cancel order buttons
            const cancelButtons = document.querySelectorAll('.cancel-order-btn');
            cancelButtons.forEach(function (button) {
                button.addEventListener('click', function () {
                    const orderId = this.getAttribute('data-order-id');
                    showCancelOrderModal(orderId);
                });
            });

            // Add smooth animations on page load
            const cards = document.querySelectorAll('.order-card, .stats-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>
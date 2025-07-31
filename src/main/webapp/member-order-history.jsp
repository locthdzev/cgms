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
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    String successMessage = (String) session.getAttribute("successMessage");
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

        /* Header Section */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(50%, -50%);
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            opacity: 0.9;
            margin-bottom: 0;
        }

        .stats-cards {
            margin-bottom: 2rem;
        }

        .stats-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
            color: white;
        }

        .stats-pending { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
        .stats-confirmed { background: linear-gradient(135deg, #3b82f6, #60a5fa); }
        .stats-completed { background: linear-gradient(135deg, #10b981, #34d399); }
        .stats-cancelled { background: linear-gradient(135deg, #ef4444, #f87171); }

        /* Modern Order Cards */
        .order-card {
            background: white;
            border-radius: 1rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            margin-bottom: 1.5rem;
            border: none;
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }

        .order-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
        }

        .order-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        .order-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 1.5rem;
            border-bottom: 1px solid #e9ecef;
        }

        .order-id {
            font-size: 1.1rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 0.25rem;
        }

        .order-date {
            color: #6c757d;
            font-size: 0.875rem;
        }

        .order-body {
            padding: 1.5rem;
        }

        /* Status Badges */
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-pending {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: #92400e;
        }

        .status-confirmed {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
        }

        .status-shipping {
            background: linear-gradient(135deg, #f3e8ff, #e9d5ff);
            color: #7c3aed;
        }

        .status-completed {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
        }

        .status-cancelled {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #dc2626;
        }

        /* Payment Method Badges */
        .payment-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
        }

        .payment-cash {
            background: #f3f4f6;
            color: #374151;
        }

        .payment-payos {
            background: linear-gradient(135deg, #3b82f6, #60a5fa);
            color: white;
        }

        /* Action Buttons */
        .btn-modern {
            border-radius: 0.75rem;
            padding: 0.5rem 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            font-size: 0.875rem;
        }

        .btn-details {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .btn-details:hover {
            background: linear-gradient(135deg, #5a67d8, #6b46c1);
            color: white;
            transform: translateY(-1px);
        }

        .btn-cancel {
            background: linear-gradient(135deg, #ef4444, #f87171);
            color: white;
        }

        .btn-cancel:hover {
            background: linear-gradient(135deg, #dc2626, #ef4444);
            color: white;
            transform: translateY(-1px);
        }

        /* Price Display */
        .price-display {
            font-size: 1.25rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Address Display */
        .address-info {
            background: #f8f9fa;
            border-radius: 0.5rem;
            padding: 0.75rem;
            border-left: 3px solid #667eea;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 1rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        }

        .empty-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: float 3s ease-in-out infinite;
        }

        .empty-icon i {
            font-size: 3rem;
            color: white;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .empty-state h3 {
            color: #374151;
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: #6b7280;
            margin-bottom: 2rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .order-card .row > div {
                margin-bottom: 1rem;
            }

            .page-header h1 {
                font-size: 1.5rem;
            }

            .stats-card {
                margin-bottom: 1rem;
            }
        }

        /* Loading Animation */
        .loading-shimmer {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <!-- Sidebar -->
    <%@ include file="member_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <%@ include file="navbar.jsp" %>

        <div class="container-fluid py-4">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1><i class="fas fa-shopping-bag me-3"></i>Đơn hàng của tôi</h1>
                        <p>Quản lý và theo dõi tất cả đơn hàng của bạn một cách dễ dàng</p>
                    </div>
                    <div>
                        <a href="member-shop.jsp" class="btn btn-light btn-lg">
                            <i class="fas fa-plus me-2"></i>Mua sắm ngay
                        </a>
                    </div>
                </div>
            </div>

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

            <!-- Statistics Cards -->
            <% if (orders != null && !orders.isEmpty()) { %>
            <%
                int pendingCount = 0, confirmedCount = 0, completedCount = 0, cancelledCount = 0;
                for (Order order : orders) {
                    switch (order.getStatus()) {
                        case "PENDING": pendingCount++; break;
                        case "CONFIRMED": case "SHIPPING": case "DELIVERED": confirmedCount++; break;
                        case "COMPLETED": completedCount++; break;
                        case "CANCELLED": cancelledCount++; break;
                    }
                }
            %>
            <div class="row stats-cards">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon stats-pending">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3 class="mb-1"><%= pendingCount %></h3>
                        <p class="text-muted mb-0">Chờ xác nhận</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon stats-confirmed">
                            <i class="fas fa-truck"></i>
                        </div>
                        <h3 class="mb-1"><%= confirmedCount %></h3>
                        <p class="text-muted mb-0">Đang xử lý</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon stats-completed">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <h3 class="mb-1"><%= completedCount %></h3>
                        <p class="text-muted mb-0">Hoàn thành</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon stats-cancelled">
                            <i class="fas fa-times-circle"></i>
                        </div>
                        <h3 class="mb-1"><%= cancelledCount %></h3>
                        <p class="text-muted mb-0">Đã hủy</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Orders List -->
            <div class="row">
                <div class="col-12">
                    <% if (orders != null && !orders.isEmpty()) { %>
                        <% for (Order order : orders) { %>
                        <div class="card order-card">
                            <div class="order-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="order-id">Đơn hàng #<%= order.getId() %></div>
                                        <div class="order-date">
                                            <i class="fas fa-calendar-alt me-1"></i>
                                            <%= order.getCreatedAt().atZone(java.time.ZoneId.systemDefault()).format(dateFormatter) %>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <div class="price-display"><%= formatter.format(order.getTotalAmount().longValue()) %> VNĐ</div>
                                        <div class="payment-badge <%= "CASH".equals(order.getPaymentMethod()) ? "payment-cash" : "payment-payos" %>">
                                            <i class="fas <%= "CASH".equals(order.getPaymentMethod()) ? "fa-money-bill" : "fa-credit-card" %>"></i>
                                            <%= "CASH".equals(order.getPaymentMethod()) ? "Tiền mặt" : "PayOS" %>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="order-body">
                                <div class="row align-items-center">
                                    <div class="col-lg-3 col-md-6 mb-3 mb-lg-0">
                                        <%
                                            String statusClass = "";
                                            String statusText = "";
                                            String statusIcon = "";

                                            switch (order.getStatus()) {
                                                case "PENDING":
                                                    statusClass = "status-pending";
                                                    statusText = "Chờ xác nhận";
                                                    statusIcon = "fa-clock";
                                                    break;
                                                case "CONFIRMED":
                                                    statusClass = "status-confirmed";
                                                    statusText = "Đã xác nhận";
                                                    statusIcon = "fa-check";
                                                    break;
                                                case "SHIPPING":
                                                    statusClass = "status-shipping";
                                                    statusText = "Đang vận chuyển";
                                                    statusIcon = "fa-truck";
                                                    break;
                                                case "DELIVERED":
                                                    statusClass = "status-shipping";
                                                    statusText = "Đã giao hàng";
                                                    statusIcon = "fa-box";
                                                    break;
                                                case "COMPLETED":
                                                    statusClass = "status-completed";
                                                    statusText = "Hoàn thành";
                                                    statusIcon = "fa-check-circle";
                                                    break;
                                                case "CANCELLED":
                                                    statusClass = "status-cancelled";
                                                    statusText = "Đã hủy";
                                                    statusIcon = "fa-times-circle";
                                                    break;
                                                default:
                                                    statusClass = "status-pending";
                                                    statusText = order.getStatus();
                                                    statusIcon = "fa-question";
                                            }
                                        %>
                                        <span class="status-badge <%= statusClass %>">
                                            <i class="fas <%= statusIcon %>"></i>
                                            <%= statusText %>
                                        </span>
                                    </div>

                                    <div class="col-lg-5 col-md-6 mb-3 mb-lg-0">
                                        <div class="address-info">
                                            <small class="text-muted d-block mb-1">
                                                <i class="fas fa-user me-1"></i>
                                                <%= order.getReceiverName() %>
                                            </small>
                                            <small class="text-muted d-block mb-1">
                                                <i class="fas fa-phone me-1"></i>
                                                <%= order.getReceiverPhone() %>
                                            </small>
                                            <small class="text-muted">
                                                <i class="fas fa-map-marker-alt me-1"></i>
                                                <%= order.getShippingAddress() %>
                                            </small>
                                        </div>
                                    </div>

                                    <div class="col-lg-4 text-lg-end">
                                        <div class="d-flex gap-2 justify-content-lg-end">
                                            <a href="my-order?action=details&id=<%= order.getId() %>"
                                               class="btn btn-details btn-modern">
                                                <i class="fas fa-eye me-1"></i>Chi tiết
                                            </a>

                                            <% if ("PENDING".equals(order.getStatus()) || "CONFIRMED".equals(order.getStatus())) { %>
                                            <button type="button"
                                                    class="btn btn-cancel btn-modern"
                                                    onclick="showCancelModal(<%= order.getId() %>)">
                                                <i class="fas fa-times me-1"></i>Hủy
                                            </button>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    <% } else { %>
                        <!-- Empty State -->
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-shopping-bag"></i>
                            </div>
                            <h3>Chưa có đơn hàng nào</h3>
                            <p>Bạn chưa thực hiện đơn hàng nào. Hãy khám phá các sản phẩm tuyệt vời của chúng tôi!</p>
                            <a href="member-shop.jsp" class="btn btn-details btn-modern btn-lg">
                                <i class="fas fa-shopping-cart me-2"></i>Bắt đầu mua sắm
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <!-- Cancel Order Modal -->
    <div class="modal fade" id="cancelOrderModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content" style="border-radius: 1rem; border: none;">
                <div class="modal-header" style="background: linear-gradient(135deg, #f8f9fa, #e9ecef); border-bottom: 1px solid #e9ecef;">
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

                        <div class="alert alert-warning" style="border-radius: 0.75rem;">
                            <i class="fas fa-info-circle me-2"></i>
                            Bạn có chắc chắn muốn hủy đơn hàng này không?
                        </div>

                        <div class="form-group">
                            <label class="form-control-label">
                                <i class="fas fa-comment me-2"></i>
                                Lý do hủy đơn hàng:
                            </label>
                            <textarea class="form-control"
                                      name="reason"
                                      rows="3"
                                      placeholder="Vui lòng cho biết lý do hủy đơn hàng..."
                                      style="border-radius: 0.75rem;"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer" style="border-top: 1px solid #e9ecef;">
                        <button type="button" class="btn btn-secondary btn-modern" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Đóng
                        </button>
                        <button type="submit" class="btn btn-cancel btn-modern">
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
        function showCancelModal(orderId) {
            document.getElementById("cancelOrderId").value = orderId;
            var modal = new bootstrap.Modal(document.getElementById("cancelOrderModal"));
            modal.show();
        }

        // Add loading animation when clicking detail buttons
        document.addEventListener('DOMContentLoaded', function() {
            const detailButtons = document.querySelectorAll('.btn-details');
            detailButtons.forEach(button => {
                button.addEventListener('click', function() {
                    this.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang tải...';
                });
            });

            // Add entrance animation to cards
            const cards = document.querySelectorAll('.order-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Add animation to stats cards
            const statsCards = document.querySelectorAll('.stats-card');
            statsCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 150);
            });
        });
    </script>
</body>
</html>
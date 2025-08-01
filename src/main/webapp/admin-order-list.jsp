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
    <title>Quản lý đơn hàng - CGMS Admin</title>
    <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0"/>
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
    />
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

        .order-card {
            border-radius: 1rem;
            box-shadow: 0 8px 24px 0 rgba(0, 0, 0, 0.07);
            margin-bottom: 1.5rem;
            transition: transform 0.2s;
        }

        .order-card:hover {
            transform: translateY(-2px);
        }

        .status-badge {
            font-size: 0.75rem;
            padding: 0.375rem 0.75rem;
            border-radius: 0.375rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .status-pending {
            background-color: #fef3c7;
            color: #92400e;
        }

        .status-confirmed {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .status-shipping {
            background-color: #f3e8ff;
            color: #7c3aed;
        }

        .status-completed {
            background-color: #d1fae5;
            color: #065f46;
        }

        .status-cancelled {
            background-color: #fee2e2;
            color: #dc2626;
        }

        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }

        .filter-card {
            background: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<!-- Sidebar -->
<%@ include file="sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Navbar -->
    <%@ include file="navbar.jsp" %>

    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header pb-0">
                        <div class="d-lg-flex">
                            <div>
                                <h5 class="mb-0">Quản lý đơn hàng</h5>
                                <p class="text-sm mb-0">
                                    Quản lý và theo dõi tất cả đơn hàng trong hệ thống
                                </p>
                            </div>
                            <div class="ms-auto my-auto mt-lg-0 mt-4">
                                <div class="ms-auto my-auto">
                                    <a href="admin-orders?action=create" class="btn bg-gradient-success btn-sm mb-0 me-2">
                                        <i class="fas fa-plus me-2"></i>Tạo đơn hàng
                                    </a>
                                    <button
                                            class="btn bg-gradient-primary btn-sm mb-0"
                                            onclick="refreshOrders()"
                                    >
                                        <i class="fas fa-sync-alt me-2"></i>Làm mới
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Messages -->
        <% if (errorMessage != null) { %>
        <div
                class="alert alert-danger alert-dismissible fade show"
                role="alert"
        >
            <span class="alert-icon"><i class="ni ni-like-2"></i></span>
            <span class="alert-text"><%= errorMessage %></span>
            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert"
                    aria-label="Close"
            ></button>
        </div>
        <% } %> <% if (successMessage != null) { %>
        <div
                class="alert alert-success alert-dismissible fade show"
                role="alert"
        >
            <span class="alert-icon"><i class="ni ni-like-2"></i></span>
            <span class="alert-text"><%= successMessage %></span>
            <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert"
                    aria-label="Close"
            ></button>
        </div>
        <% } %>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                <div class="card">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p
                                            class="text-sm mb-0 text-uppercase font-weight-bold"
                                    >
                                        Tổng đơn hàng
                                    </p>
                                    <h5 class="font-weight-bolder">
                                        <%= orders != null ? orders.size() : 0 %>
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div
                                        class="icon icon-shape bg-gradient-primary shadow-primary text-center rounded-circle"
                                >
                                    <i
                                            class="fas fa-shopping-bag text-lg opacity-10"
                                            aria-hidden="true"
                                    ></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                <div class="card">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p
                                            class="text-sm mb-0 text-uppercase font-weight-bold"
                                    >
                                        Chờ xác nhận
                                    </p>
                                    <h5 class="font-weight-bolder text-warning">
                                        <%= orders != null ? orders.stream().mapToInt(o ->
                                                "PENDING".equals(o.getStatus()) ? 1 : 0).sum() : 0
                                        %>
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div
                                        class="icon icon-shape bg-gradient-warning shadow-warning text-center rounded-circle"
                                >
                                    <i
                                            class="fas fa-clock text-lg opacity-10"
                                            aria-hidden="true"
                                    ></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                <div class="card">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p
                                            class="text-sm mb-0 text-uppercase font-weight-bold"
                                    >
                                        Đang vận chuyển
                                    </p>
                                    <h5 class="font-weight-bolder text-info">
                                        <%= orders != null ? orders.stream().mapToInt(o ->
                                                "SHIPPING".equals(o.getStatus()) ? 1 : 0).sum() : 0
                                        %>
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div
                                        class="icon icon-shape bg-gradient-info shadow-info text-center rounded-circle"
                                >
                                    <i
                                            class="fas fa-truck text-lg opacity-10"
                                            aria-hidden="true"
                                    ></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6">
                <div class="card">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p
                                            class="text-sm mb-0 text-uppercase font-weight-bold"
                                    >
                                        Hoàn thành
                                    </p>
                                    <h5 class="font-weight-bolder text-success">
                                        <%= orders != null ? orders.stream().mapToInt(o ->
                                                "COMPLETED".equals(o.getStatus()) ? 1 : 0).sum() : 0
                                        %>
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div
                                        class="icon icon-shape bg-gradient-success shadow-success text-center rounded-circle"
                                >
                                    <i
                                            class="fas fa-check text-lg opacity-10"
                                            aria-hidden="true"
                                    ></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Orders List -->
        <div class="row">
            <div class="col-12">
                <% if (orders != null && !orders.isEmpty()) { %> <% for (Order
                    order : orders) { %>
                <div class="card order-card">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-lg-2">
                                <div class="d-flex align-items-center">
                                    <div
                                            class="icon icon-shape bg-gradient-primary shadow text-center border-radius-md me-3"
                                    >
                                        <i
                                                class="fas fa-shopping-bag text-white opacity-10"
                                        ></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">#<%= order.getId() %>
                                        </h6>
                                        <small class="text-muted">
                                            <%=
                                            order.getCreatedAt().atZone(java.time.ZoneId.systemDefault()).format(dateFormatter)
                                            %>
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-2">
                                <div>
                                    <h6 class="mb-0">
                                        <%= order.getMember().getFullName() %>
                                    </h6>
                                    <small class="text-muted"
                                    ><%= order.getMember().getEmail() %>
                                    </small
                                    >
                                </div>
                            </div>

                            <div class="col-lg-2">
                                <div class="text-center">
                                    <h6 class="mb-0 text-primary">
                                        <%=
                                        formatter.format(order.getTotalAmount().longValue())
                                        %> VNĐ
                                    </h6>
                                    <small class="text-muted">
                                        <%= "CASH".equals(order.getPaymentMethod()) ? "Tiền mặt" : "PayOS" %>
                                    </small>
                                </div>
                            </div>

                            <div class="col-lg-2">
                                <div class="text-center">
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
                                    <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                                </div>
                            </div>


                            <div class="col-lg-2">
                                <div class="text-truncate">
                                    <small class="text-muted">
                                        <i class="fas fa-map-marker-alt me-1"></i>
                                        <%= order.getShippingAddress() != null ?
                                                order.getShippingAddress() : "N/A" %>
                                    </small>
                                </div>
                            </div>

                            <div class="col-lg-2">
                                <div class="text-end">
                                    <a
                                            href="admin-orders?action=details&id=<%= order.getId() %>"
                                            class="btn btn-outline-primary btn-sm mb-1"
                                    >
                                        <i class="fas fa-eye me-1"></i>Chi tiết
                                    </a>

                                    <% if (!"CANCELLED".equals(order.getStatus()) &&
                                            !"COMPLETED".equals(order.getStatus())) { %>
                                    <button
                                            type="button"
                                            class="btn btn-outline-success btn-sm mb-1 update-status-btn"
                                            data-order-id="<%= order.getId() %>"
                                            data-current-status="<%= order.getStatus() %>"
                                    >
                                        <i class="fas fa-edit me-1"></i>Cập nhật
                                    </button>

                                    <button
                                            type="button"
                                            class="btn btn-outline-danger btn-sm mb-1 cancel-order-btn"
                                            data-order-id="<%= order.getId() %>"
                                    >
                                        <i class="fas fa-times me-1"></i>Hủy
                                    </button>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %> <% } else { %>
                <div class="card">
                    <div class="card-body text-center py-5">
                        <div
                                class="icon icon-shape bg-gradient-primary shadow mx-auto mb-4"
                                style="width: 100px; height: 100px"
                        >
                            <i
                                    class="fas fa-shopping-bag text-white"
                                    style="font-size: 3rem; line-height: 100px"
                            ></i>
                        </div>
                        <h4>Chưa có đơn hàng nào</h4>
                        <p class="text-muted mb-4">
                            Hệ thống chưa có đơn hàng nào được tạo.
                        </p>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</main>

<!-- Update Status Modal -->
<div
        class="modal fade"
        id="updateStatusModal"
        tabindex="-1"
        aria-labelledby="updateStatusModalLabel"
        aria-hidden="true"
>
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateStatusModalLabel">
                    Cập nhật trạng thái đơn hàng
                </h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                ></button>
            </div>
            <form action="order" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update-status"/>
                    <input type="hidden" name="orderId" id="updateOrderId"/>

                    <div class="form-group">
                        <label class="form-control-label">Trạng thái mới</label>
                        <select
                                class="form-control"
                                name="newStatus"
                                id="newStatusSelect"
                                required
                        >
                            <option value="">-- Chọn trạng thái --</option>
                            <option value="PENDING">Chờ xác nhận</option>
                            <option value="CONFIRMED">Đã xác nhận</option>
                            <option value="SHIPPING">Đang vận chuyển</option>
                            <option value="COMPLETED">Hoàn thành</option>
                            <option value="CANCELLED">Hủy đơn hàng</option>
                        </select>
                    </div>

                    <div class="alert alert-info">
                        <small>
                            <i class="fas fa-info-circle me-1"></i>
                            Khách hàng sẽ nhận được email thông báo khi trạng thái đơn
                            hàng thay đổi.
                        </small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button
                            type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal"
                    >
                        Hủy
                    </button>
                    <button type="submit" class="btn btn-primary">
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
            <div class="modal-header">
                <h5 class="modal-title">Hủy đơn hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="order" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="admin-cancel">
                    <input type="hidden" name="orderId" id="cancelOrderId">
                    
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Cảnh báo:</strong> Hành động này không thể hoàn tác!
                    </div>
                    
                    <p>Bạn có chắc chắn muốn hủy đơn hàng này không?</p>
                    
                    <div class="form-group">
                        <label class="form-control-label">Lý do hủy đơn hàng *</label>
                        <textarea class="form-control" name="reason" rows="3" required
                            placeholder="Nhập lý do hủy đơn hàng"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Đóng
                    </button>
                    <button type="submit" class="btn btn-danger">
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
        document.getElementById("updateOrderId").value = orderId;
        document.getElementById("newStatusSelect").value = currentStatus;

        var modal = new bootstrap.Modal(
            document.getElementById("updateStatusModal")
        );
        modal.show();
    }

    function showCancelOrderModal(orderId) {
        document.getElementById("cancelOrderId").value = orderId;
        var modal = new bootstrap.Modal(
            document.getElementById("cancelOrderModal")
        );
        modal.show();
    }

    function refreshOrders() {
        window.location.reload();
    }

    // Add event listeners for buttons
    document.addEventListener("DOMContentLoaded", function () {
        // Update status buttons
        const updateButtons = document.querySelectorAll(".update-status-btn");
        updateButtons.forEach(function (button) {
            button.addEventListener("click", function () {
                const orderId = this.getAttribute("data-order-id");
                const currentStatus = this.getAttribute("data-current-status");
                showUpdateStatusModal(orderId, currentStatus);
            });
        });

        // Cancel order buttons
        const cancelButtons = document.querySelectorAll(".cancel-order-btn");
        cancelButtons.forEach(function (button) {
            button.addEventListener("click", function () {
                const orderId = this.getAttribute("data-order-id");
                showCancelOrderModal(orderId);
            });
        });
    });
</script>
</body>
</html>
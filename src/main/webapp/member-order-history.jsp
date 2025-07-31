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

        .btn-cancel {
            background: linear-gradient(87deg, #f5365c 0, #f56036 100%);
            border: none;
            color: white;
        }

        .btn-cancel:hover {
            color: white;
            transform: translateY(-1px);
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<!-- Sidebar -->
<%@ include file="member_sidebar.jsp" %>

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
                                <h5 class="mb-0">Đơn hàng của tôi</h5>
                                <p class="text-sm mb-0">
                                    Quản lý và theo dõi các đơn hàng của bạn
                                </p>
                            </div>
                            <div class="ms-auto my-auto mt-lg-0 mt-4">
                                <div class="ms-auto my-auto">
                                    <a
                                            href="member-shop.jsp"
                                            class="btn bg-gradient-primary btn-sm mb-0"
                                    >
                                        <i class="fas fa-shopping-cart me-2"></i>Tiếp tục
                                        mua sắm
                                    </a>
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

        <!-- Orders List -->
        <div class="row">
            <div class="col-12">
                <% if (orders != null && !orders.isEmpty()) { %> <% for (Order
                    order : orders) { %>
                <div class="card order-card">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-lg-3">
                                <div class="d-flex align-items-center">
                                    <div
                                            class="icon icon-shape bg-gradient-primary shadow text-center border-radius-md me-3"
                                    >
                                        <i
                                                class="fas fa-shopping-bag text-white opacity-10"
                                        ></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">Đơn hàng #<%= order.getId() %>
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

                            <div class="col-lg-3">
                                <div class="text-truncate">
                                    <small class="text-muted">
                                        <i class="fas fa-map-marker-alt me-1"></i>
                                        <%= order.getShippingAddress() %>
                                    </small>
                                </div>
                            </div>

                            <div class="col-lg-2">
                                <div class="text-end">
                                    <a
                                            href="my-order?action=details&id=<%= order.getId() %>"
                                            class="btn btn-outline-primary btn-sm mb-1"
                                    >
                                        <i class="fas fa-eye me-1"></i>Chi tiết
                                    </a>

                                    <% if ("PENDING".equals(order.getStatus()) ||
                                            "CONFIRMED".equals(order.getStatus())) { %>
                                    <button
                                            type="button"
                                            class="btn btn-cancel btn-sm mb-1"
                                            onclick="showCancelModal(<%= order.getId() %>)"
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
                            Bạn chưa có đơn hàng nào. Hãy bắt đầu mua sắm ngay!
                        </p>
                        <a href="member-shop.jsp" class="btn bg-gradient-primary">
                            <i class="fas fa-shopping-cart me-2"></i>Bắt đầu mua sắm
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</main>

<!-- Cancel Order Modal -->
<div class="modal fade" id="cancelOrderModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Hủy đơn hàng</h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                ></button>
            </div>
            <form action="my-order" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="cancel"/>
                    <input type="hidden" name="orderId" id="cancelOrderId"/>
                    <p>Bạn có chắc chắn muốn hủy đơn hàng này không?</p>
                    <div class="form-group">
                        <label class="form-control-label">Lý do hủy đơn hàng</label>
                        <textarea
                                class="form-control"
                                name="reason"
                                rows="3"
                                placeholder="Nhập lý do hủy đơn hàng (tùy chọn)"
                        ></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button
                            type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal"
                    >
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
    function showCancelModal(orderId) {
        document.getElementById("cancelOrderId").value = orderId;
        var modal = new bootstrap.Modal(
            document.getElementById("cancelOrderModal")
        );
        modal.show();
    }
</script>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="Models.User" %>
<%@page import="Models.Order" %>
<%@page import="Models.OrderDetail" %>
<%@page import="java.util.List" %>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<%@page import="java.time.format.DateTimeFormatter" %>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login");
        return;
    }

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

        .order-status {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.875rem;
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
            background-color: #e0e7ff;
            color: #3730a3;
        }

        .status-delivered {
            background-color: #d1fae5;
            color: #065f46;
        }

        .status-cancelled {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .product-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .product-item:last-child {
            border-bottom: none;
        }

        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 0.5rem;
            margin-right: 1rem;
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<!-- Sidebar -->
<% if ("Member".equals(loggedInUser.getRole())) { %>
<%@ include
        file="member_sidebar.jsp" %>
<% } else if
("PT".equals(loggedInUser.getRole())) { %>
<%@ include
        file="pt_sidebar.jsp" %>
<% } else { %>
<%@ include file="sidebar.jsp"
%>
<% } %>

<main class="main-content position-relative border-radius-lg">
    <!-- Navbar -->
    <%@ include file="navbar.jsp" %>

    <div class="container-fluid py-4">
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

        <!-- Order Header -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header pb-0">
                        <div
                                class="d-flex align-items-center justify-content-between"
                        >
                            <div>
                                <h4 class="mb-0">
                                    Chi tiết đơn hàng #<%= order.getId() %>
                                </h4>
                                <p class="text-sm mb-0">
                                    Đặt hàng lúc: <%=
                                order.getOrderDate().format(dateFormatter) %>
                                </p>
                            </div>
                            <div>
                        <span
                                class="order-status status-<%= order.getStatus().toLowerCase() %>"
                        >
                          <%= order.getStatus() %>
                        </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <!-- Order Information -->
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header pb-0">
                        <h6 class="mb-0">Thông tin đơn hàng</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-sm">Thông tin giao hàng</h6>
                                <p class="text-sm mb-1">
                                    <strong>Người nhận:</strong> <%=
                                order.getReceiverName() %>
                                </p>
                                <p class="text-sm mb-1">
                                    <strong>Số điện thoại:</strong> <%=
                                order.getReceiverPhone() %>
                                </p>
                                <p class="text-sm mb-3">
                                    <strong>Địa chỉ:</strong> <%=
                                order.getShippingAddress() %>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="text-sm">Thông tin thanh toán</h6>
                                <p class="text-sm mb-1">
                                    <strong>Phương thức:</strong>
                                    <% if ("CASH".equals(order.getPaymentMethod())) { %>
                                    Tiền mặt khi nhận hàng <% } else { %> Thanh toán
                                    online PayOS <% } %>
                                </p>
                                <p class="text-sm mb-1">
                                    <strong>Trạng thái thanh toán:</strong>
                                    <% if ("CONFIRMED".equals(order.getStatus()) ||
                                            "SHIPPING".equals(order.getStatus()) ||
                                            "DELIVERED".equals(order.getStatus())) { %>
                                    <span class="text-success">Đã thanh toán</span>
                                    <% } else { %>
                                    <span class="text-warning">Chưa thanh toán</span>
                                    <% } %>
                                </p>
                            </div>
                        </div>

                        <% if (order.getNotes() != null &&
                                !order.getNotes().trim().isEmpty()) { %>
                        <div class="mt-3">
                            <h6 class="text-sm">Ghi chú</h6>
                            <p class="text-sm"><%= order.getNotes() %>
                            </p>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Order Items -->
                <div class="card mt-4">
                    <div class="card-header pb-0">
                        <h6 class="mb-0">Sản phẩm đã đặt</h6>
                    </div>
                    <div class="card-body">
                        <% if (orderDetails != null && !orderDetails.isEmpty()) { %>
                        <% for (OrderDetail detail : orderDetails) { %>
                        <div class="product-item">
                            <img src="<%= detail.getProduct().getImageUrl() != null ?
                      detail.getProduct().getImageUrl() :
                      "assets/img/default-product.jpg" %>" alt="<%=
                      detail.getProduct().getName() %>" class="product-img">
                            <div class="flex-grow-1">
                                <h6 class="mb-1">
                                    <%= detail.getProduct().getName() %>
                                </h6>
                                <p class="text-sm text-muted mb-0">
                                    Số lượng: <%= detail.getQuantity() %>
                                </p>
                                <p class="text-sm text-muted mb-0">
                                    Đơn giá: <%=
                                formatter.format(detail.getUnitPrice().longValue()) %> VNĐ
                                </p>
                            </div>
                            <div class="text-end">
                                <strong
                                ><%= formatter.format(detail.getTotalPrice().longValue() *
                                        detail.getQuantity()) %> VNĐ</strong
                                >
                            </div>
                        </div>
                        <% } %> <% } else { %>
                        <p class="text-center text-muted">
                            Không có sản phẩm nào trong đơn hàng này.
                        </p>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header pb-0">
                        <h6 class="mb-0">Tóm tắt đơn hàng</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Tổng tiền hàng:</span>
                            <span
                            ><%=
                            formatter.format(order.getTotalAmount().longValue()) %>
                        VNĐ</span
                            >
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Phí vận chuyển:</span>
                            <span>Miễn phí</span>
                        </div>
                        <hr/>
                        <div class="d-flex justify-content-between">
                            <strong>Tổng cộng:</strong>
                            <strong class="text-primary"
                            ><%=
                            formatter.format(order.getTotalAmount().longValue()) %>
                                VNĐ</strong
                            >
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="card mt-4">
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="my-order" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại lịch sử
                            </a>

                            <% if ("PENDING".equals(order.getStatus())) { %>
                            <button
                                    type="button"
                                    class="btn btn-danger"
                                    onclick="cancelOrder(<%= order.getId() %>)"
                            >
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
                <h5 class="modal-title">Hủy đơn hàng</h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                ></button>
            </div>
            <form action="order" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="cancel"/>
                    <input type="hidden" name="orderId" id="cancelOrderId"/>
                    <div class="form-group">
                        <label class="form-control-label"
                        >Lý do hủy đơn hàng:</label
                        >
                        <textarea
                                class="form-control"
                                name="reason"
                                rows="3"
                                required
                                placeholder="Nhập lý do hủy đơn hàng..."
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
                        Xác nhận hủy
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
        new bootstrap.Modal(
            document.getElementById("cancelOrderModal")
        ).show();
    }
</script>
</body>
</html>
</OrderDetail></OrderDetail
>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="Models.User" %>
<%@page import="Models.Cart" %>
<%@page import="java.util.List" %>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>

<%
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Long cartTotal = (Long) request.getAttribute("cartTotal");

    if (cartItems == null || cartItems.isEmpty()) {
        response.sendRedirect("member-cart");
        return;
    }

    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    String successMessage = (String) session.getAttribute("successMessage");
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
    <title>Thanh toán đơn hàng - CGMS</title>
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

        .checkout-card {
            border-radius: 1rem;
            box-shadow: 0 8px 24px 0 rgba(0, 0, 0, 0.07);
        }

        .order-summary {
            background: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1.5rem;
        }

        .product-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .product-item:last-child {
            border-bottom: none;
        }

        .product-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 0.5rem;
            margin-right: 1rem;
        }

        .form-control:focus {
            border-color: #5e72e4;
            box-shadow: 0 0 0 0.2rem rgba(94, 114, 228, 0.25);
        }

        .btn-checkout {
            background: linear-gradient(87deg, #5e72e4 0, #825ee4 100%);
            border: none;
            padding: 0.75rem 2rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .btn-checkout:hover {
            transform: translateY(-1px);
            box-shadow: 0 7px 14px rgba(50, 50, 93, 0.1),
            0 3px 6px rgba(0, 0, 0, 0.08);
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<!-- Sidebar -->
<%@ include file="member_sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Navbar -->
    <%@ include file="navbar.jsp" %>
    <% // Authentication check User
        loggedInUser = (User) session.getAttribute("loggedInUser");
        if
        (loggedInUser == null || (!"Member".equals(loggedInUser.getRole()) &&
                !"PT".equals(loggedInUser.getRole()))) {
            response.sendRedirect("login");
            return;
        } %>

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

        <div class="row">
            <div class="col-lg-8">
                <div class="card checkout-card">
                    <div class="card-header pb-0">
                        <h5 class="mb-0">Thông tin giao hàng</h5>
                    </div>
                    <div class="card-body">
                        <form action="order" method="post" id="checkoutForm">
                            <input type="hidden" name="action" value="create"/>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label"
                                        >Tên người nhận
                                            <span class="text-danger">*</span></label
                                        >
                                        <input
                                                type="text"
                                                class="form-control"
                                                name="receiverName"
                                                value="<%= loggedInUser.getFullName() %>"
                                                required
                                        />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label"
                                        >Số điện thoại
                                            <span class="text-danger">*</span></label
                                        >
                                        <input
                                                type="tel"
                                                class="form-control"
                                                name="receiverPhone"
                                                placeholder="Nhập số điện thoại"
                                                required
                                        />
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-control-label"
                                >Địa chỉ giao hàng
                                    <span class="text-danger">*</span></label
                                >
                                <textarea
                                        class="form-control"
                                        name="shippingAddress"
                                        rows="3"
                                        placeholder="Nhập địa chỉ chi tiết (số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố)"
                                        required
                                ></textarea>
                            </div>

                            <div class="form-group">
                                <label class="form-control-label"
                                >Ghi chú đơn hàng</label
                                >
                                <textarea
                                        class="form-control"
                                        name="notes"
                                        rows="2"
                                        placeholder="Ghi chú thêm cho đơn hàng (tùy chọn)"
                                ></textarea>
                            </div>

                            <div class="form-group">
                                <label class="form-control-label"
                                >Phương thức thanh toán
                                    <span class="text-danger">*</span></label
                                >
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-check">
                                            <input
                                                    class="form-check-input"
                                                    type="radio"
                                                    name="paymentMethod"
                                                    value="CASH"
                                                    id="cashPayment"
                                                    checked
                                            />
                                            <label class="form-check-label" for="cashPayment">
                                                <i
                                                        class="fas fa-money-bill-wave text-success me-2"
                                                ></i>
                                                Thanh toán tiền mặt khi nhận hàng
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-check">
                                            <input
                                                    class="form-check-input"
                                                    type="radio"
                                                    name="paymentMethod"
                                                    value="PAYOS"
                                                    id="payosPayment"
                                            />
                                            <label
                                                    class="form-check-label"
                                                    for="payosPayment"
                                            >
                                                <i
                                                        class="fas fa-credit-card text-primary me-2"
                                                ></i>
                                                Thanh toán online PayOS
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="member-cart" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại giỏ
                                    hàng
                                </a>
                                <button
                                        type="submit"
                                        class="btn btn-checkout text-white"
                                >
                                    <i class="fas fa-check me-2"></i>Đặt hàng
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card checkout-card">
                    <div class="card-header pb-0">
                        <h5 class="mb-0">Tóm tắt đơn hàng</h5>
                    </div>
                    <div class="card-body">
                        <div class="order-summary">
                            <% for (Cart item : cartItems) { %>
                            <div class="product-item">
                                <img src="<%= item.getProduct().getImageUrl() != null ?
                        item.getProduct().getImageUrl() :
                        "assets/img/default-product.jpg" %>" alt="<%=
                        item.getProduct().getName() %>" class="product-img">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">
                                        <%= item.getProduct().getName() %>
                                    </h6>
                                    <small class="text-muted"
                                    >Số lượng: <%= item.getQuantity() %>
                                    </small
                                    >
                                </div>
                                <div class="text-end">
                                    <strong
                                    ><%=
                                    formatter.format(item.getProduct().getPrice().longValue()
                                            * item.getQuantity()) %> VNĐ</strong
                                    >
                                </div>
                            </div>
                            <% } %>

                            <hr class="my-3"/>

                            <div
                                    class="d-flex justify-content-between align-items-center"
                            >
                                <h5 class="mb-0">Tổng cộng:</h5>
                                <h5 class="mb-0 text-primary">
                                    <%= formatter.format(cartTotal) %> VNĐ
                                </h5>
                            </div>

                            <div class="mt-3">
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Phí vận chuyển sẽ được tính khi giao hàng
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Core JS Files -->
<script src="assets/js/core/popper.min.js"></script>
<script src="assets/js/core/bootstrap.min.js"></script>
<script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

<script>
    // Form validation
    document
        .getElementById("checkoutForm")
        .addEventListener("submit", function (e) {
            const requiredFields = [
                "receiverName",
                "receiverPhone",
                "shippingAddress",
            ];
            let hasError = false;

            requiredFields.forEach(function (fieldName) {
                const field = document.querySelector(`[name="${fieldName}"]`);
                if (!field.value.trim()) {
                    field.classList.add("is-invalid");
                    hasError = true;
                } else {
                    field.classList.remove("is-invalid");
                }
            });

            if (hasError) {
                e.preventDefault();
                alert("Vui lòng điền đầy đủ thông tin bắt buộc!");
            }
        });

    // Phone number validation
    document
        .querySelector('[name="receiverPhone"]')
        .addEventListener("input", function (e) {
            let value = e.target.value.replace(/\D/g, "");
            if (value.length > 10) {
                value = value.substring(0, 10);
            }
            e.target.value = value;
        });
</script>
</body>
</html>
</Cart></Cart
>

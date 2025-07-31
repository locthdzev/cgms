<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Cart" %>
<%@ page import="java.util.List" %>

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
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }

    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Giỏ hàng - CGMS</title>
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

        .cart-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 8px 24px 0 rgba(0, 0, 0, 0.07);
            overflow: hidden;
            background: #fff;
            height: 100%;
            display: flex;
            flex-direction: column;
            transition: box-shadow 0.18s;
        }

        .cart-card:hover {
            box-shadow: 0 12px 38px 0 rgba(0, 0, 0, 0.16);
        }

        .cart-img-wrap {
            background: #f7fafc;
            border-bottom: 1px solid #e9ecef;
            padding: 18px 12px 14px 12px;
            text-align: center;
            min-height: 160px;
            max-height: 160px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: none;
        }

        .cart-img {
            width: 120px;
            height: 120px;
            object-fit: contain;
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 1px 6px 0 rgba(60, 60, 60, 0.07);
            display: block;
            margin: 0 auto;
            border: 1px solid #f1f3f4;
        }

        .info-label {
            font-weight: bold;
            color: #495057;
            letter-spacing: 0.5px;
            margin-right: 5px;
            font-size: 0.97rem;
        }

        .cart-title {
            font-size: 1.09rem;
            font-weight: bold;
            color: #23272b;
            letter-spacing: 1px;
            margin-bottom: 2px;
            text-transform: none;
            display: inline;
        }

        .cart-desc {
            font-size: 0.97rem;
            color: #7b8a99;
            font-weight: 500;
            display: inline;
        }

        .cart-price {
            font-weight: bold;
            color: #dc3545;
            font-size: 1.08rem;
            display: inline;
        }

        .quantity-group {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 8px;
            margin: 16px 0 10px 0;
        }

        .qty-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            font-size: 1.2rem;
            border: 1.5px solid #d1d5db;
            background: #f6f9fc;
            color: #23272b;
            transition: background 0.18s, border 0.18s;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
            box-shadow: none;
            outline: none;
        }

        .qty-btn:hover,
        .qty-btn:focus {
            background: #e9f7f3;
            border: 1.5px solid #25a18e;
            color: #25a18e;
        }

        .qty-value {
            width: 50px;
            height: 40px;
            text-align: center;
            border: none;
            border-radius: 16px;
            background: #f1f3f4;
            font-weight: 700;
            font-size: 1.07rem;
            color: #1a1a1a;
            outline: none;
            box-shadow: none;
            margin: 0;
            padding: 0;
            vertical-align: middle;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .qty-value:focus {
            background: #e9ecef;
        }

        .remove-btn {
            font-size: 0.96rem;
            padding: 3px 10px;
            margin-top: 6px;
        }

        .cart-total-bar {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 3px 16px 0 rgba(0, 0, 0, 0.08);
            padding: 1.5rem 2rem 1rem 2rem;
            margin-top: 30px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 40px;
        }

        .checkout-btn {
            padding: 0.75rem 2.5rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 2rem;
            background: linear-gradient(90deg, #54d7ba 0%, #25a18e 100%);
            color: #fff;
            border: none;
            box-shadow: 0 2px 12px 0 rgba(84, 215, 186, 0.15);
            transition: background 0.2s;
        }

        .checkout-btn:disabled {
            background: #c3c3c3 !important;
            color: #fff;
            opacity: 0.7;
        }

        @media (max-width: 768px) {
            .cart-total-bar {
                flex-direction: column;
                gap: 18px;
                padding: 1rem 1rem;
            }
        }

        .cart-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 12px;
        }

        .cart-table th,
        .cart-table td {
            vertical-align: middle;
            background: #fff;
            border: none;
            padding: 16px 8px;
            font-size: 1rem;
        }

        .cart-table th {
            color: #344767;
            font-weight: 700;
            background: #f7fafc;
            border-radius: 8px 8px 0 0;
        }

        .cart-table td img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 12px;
            border: 1.5px solid #e9ecef;
        }

        .cart-table .cart-title {
            font-weight: bold;
            color: #222;
            font-size: 1.08rem;
        }

        .cart-table .cart-desc {
            color: #7b8a99;
            font-size: 0.95rem;
        }

        .cart-table .cart-price,
        .cart-table .cart-line-total {
            font-weight: bold;
            color: #e74c3c;
            font-size: 1.08rem;
        }

        .cart-table .cart-line-total {
            color: #27ae60;
        }

        .cart-table .qty-group {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .cart-table .qty-btn {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: 1.5px solid #d1d5db;
            background: #f6f9fc;
            color: #23272b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            transition: background 0.18s, border 0.18s;
        }

        .cart-table .qty-btn:hover {
            background: #e9f7f3;
            border: 1.5px solid #25a18e;
            color: #25a18e;
        }

        .cart-table .qty-value {
            width: 40px;
            text-align: center;
            border: none;
            background: #f1f3f4;
            font-weight: 700;
            border-radius: 8px;
        }

        .cart-table .remove-btn {
            background: #ffeaea;
            color: #e74c3c;
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.18s;
        }

        .cart-table .remove-btn:hover {
            background: #e74c3c;
            color: #fff;
        }

        @media (max-width: 991.98px) {
            .cart-table th,
            .cart-table td {
                font-size: 0.97rem;
                padding: 10px 4px;
            }

            .cart-table td img {
                width: 50px;
                height: 50px;
            }
        }

        @media (max-width: 767.98px) {
            .cart-table,
            .cart-table thead,
            .cart-table tbody,
            .cart-table tr {
                display: block;
                width: 100%;
            }

            .cart-table tr {
                margin-bottom: 18px;
                box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.07);
                border-radius: 12px;
            }

            .cart-table td,
            .cart-table th {
                display: block;
                width: 100%;
                text-align: left;
                border-radius: 0;
            }

            .cart-table td img {
                width: 100%;
                height: 120px;
                margin-bottom: 8px;
            }

            .cart-table .qty-group {
                justify-content: flex-start;
            }
        }

        .cart-checkout-bar {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 3px 16px 0 rgba(0, 0, 0, 0.08);
            padding: 1.5rem 2rem 1rem 2rem;
            margin-top: 30px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 40px;
        }

        .cart-checkout-btn {
            background: linear-gradient(45deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .cart-checkout-btn:hover:not(.disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }

        .cart-checkout-btn.disabled {
            background: #6c757d;
            cursor: not-allowed;
            opacity: 0.5;
            pointer-events: none;
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>

<!-- Toast -->
<div class="toast-container position-fixed top-0 end-0 p-3">
    <% if (successMessage != null) { %>
    <div
            class="toast align-items-center text-white bg-success border-0"
            id="successToast"
            role="alert"
    >
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-check-circle me-2"></i><%= successMessage %>
            </div>
            <button
                    type="button"
                    class="btn-close btn-close-white me-2 m-auto"
                    data-bs-dismiss="toast"
            ></button>
        </div>
    </div>
    <% } %> <% if (errorMessage != null) { %>
    <div
            class="toast align-items-center text-white bg-danger border-0"
            id="errorToast"
            role="alert"
    >
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-exclamation-circle me-2"></i><%= errorMessage
            %>
            </div>
            <button
                    type="button"
                    class="btn-close btn-close-white me-2 m-auto"
                    data-bs-dismiss="toast"
            ></button>
        </div>
    </div>
    <% } %>
</div>

<!-- Modal xác nhận xóa -->
<div
        class="modal fade"
        id="confirmDeleteModal"
        tabindex="-1"
        aria-labelledby="confirmDeleteModalLabel"
        aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmDeleteModalLabel">
                    Xác nhận xóa sản phẩm
                </h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                ></button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?
            </div>
            <div class="modal-footer">
                <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal"
                >
                    Hủy
                </button>
                <button
                        type="button"
                        class="btn btn-danger"
                        id="confirmDeleteBtn"
                >
                    Xóa
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
        <div class="card mb-4">
            <div class="card-header pb-0">
                <h6 class="mb-0">
                    <i class="fas fa-shopping-cart me-2"></i>Giỏ hàng của bạn
                </h6>
            </div>
            <div class="card-body">
                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <form id="cartForm">
                    <table class="cart-table">
                        <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAllCart"/></th>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                            <th>Xóa</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Cart c : cartItems) { %>
                        <tr>
                            <td>
                                <input
                                        type="checkbox"
                                        class="select-cart-item"
                                        data-id="<%= c.getId() %>"
                                        checked
                                />
                            </td>
                            <td>
                                <img src="<%= (c.getProduct().getImageUrl() != null &&
                          !c.getProduct().getImageUrl().isEmpty()) ?
                          c.getProduct().getImageUrl() :
                          "assets/img/no-image.png" %>" alt="Product">
                            </td>
                            <td>
                                <div class="cart-title">
                                    <a
                                            href="product.jsp?id=<%= c.getProduct().getId() %>"
                                            class="text-decoration-none text-dark"
                                            target="_blank"
                                    ><%= c.getProduct().getName() %>
                                    </a
                                    >
                                </div>
                                <div class="cart-desc">
                                    <%= c.getProduct().getDescription() %>
                                </div>
                            </td>
                            <td>
                          <span class="cart-price"
                          ><%= String.format("%,d",
                                  c.getProduct().getPrice().longValue()) %> VNĐ</span
                          >
                            </td>
                            <td>
                                <div class="qty-group">
                                    <button
                                            type="button"
                                            class="qty-btn decrease-btn"
                                            data-id="<%= c.getId() %>"
                                    >
                                        <i class="fas fa-minus"></i>
                                    </button>
                                    <input
                                            type="text"
                                            class="qty-value"
                                            value="<%= c.getQuantity() %>"
                                            readonly
                                    />
                                    <button
                                            type="button"
                                            class="qty-btn increase-btn"
                                            data-id="<%= c.getId() %>"
                                    >
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                            </td>
                            <td>
                          <span
                                  class="cart-line-total fw-bold text-success"
                                  id="line-total-<%= c.getId() %>"
                          ><%= String.format("%,d",
                                  c.getProduct().getPrice().longValue() *
                                          c.getQuantity()) %> VNĐ</span
                          >
                            </td>
                            <td>
                                <button
                                        type="button"
                                        class="remove-btn"
                                        data-id="<%= c.getId() %>"
                                >
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </form>
                <div class="cart-checkout-bar">
                    <div class="fs-5 fw-bold">
                        Tổng cộng:
                        <span class="text-danger fs-4" id="selectedTotal"></span>
                    </div>
                    <a
                            href="order?action=checkout"
                            class="cart-checkout-btn"
                            id="checkoutBtn"
                    >Thanh toán</a
                    >
                </div>
                <% } else { %>
                <div
                        class="alert alert-info text-center mt-4"
                        style="font-size: 1.1rem"
                >
                    <i class="fas fa-shopping-cart me-2"></i>Giỏ hàng của bạn đang
                    trống.
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <footer class="footer pt-3">
        <div class="container-fluid">
            <div class="row align-items-center justify-content-lg-between">
                <div class="col-lg-6 mb-lg-0 mb-4">
                    <div class="text-muted text-sm text-center text-lg-start">
                        ©
                        <script>
                            document.write(new Date().getFullYear());
                        </script>
                        , CoreFit Gym Management System
                    </div>
                </div>
            </div>
        </div>
    </footer>
</main>

<!-- Scripts -->
<script>
    // Cập nhật tổng tiền các sản phẩm được chọn
    function updateSelectedTotal() {
        let total = 0;
        document
            .querySelectorAll(".select-cart-item:checked")
            .forEach(function (cb) {
                const row = cb.closest("tr");
                const price = parseInt(
                    row
                        .querySelector(".cart-price")
                        .textContent.replace(/[^\d]/g, "")
                );
                const qty = parseInt(row.querySelector(".qty-value").value);
                total += price * qty;
            });
        document.getElementById("selectedTotal").textContent =
            total.toLocaleString() + " VNĐ";

        // Enable/disable checkout button based on selection
        const checkoutBtn = document.querySelector(".cart-checkout-btn");
        const hasSelectedItems =
            document.querySelectorAll(".select-cart-item:checked").length > 0;

        if (hasSelectedItems) {
            checkoutBtn.style.pointerEvents = "auto";
            checkoutBtn.style.opacity = "1";
            checkoutBtn.classList.remove("disabled");
        } else {
            checkoutBtn.style.pointerEvents = "none";
            checkoutBtn.style.opacity = "0.5";
            checkoutBtn.classList.add("disabled");
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        console.log("Cart page loaded");

        // Initialize checkout button state
        updateSelectedTotal();

        document
            .getElementById("selectAllCart")
            .addEventListener("change", function () {
                document.querySelectorAll(".select-cart-item").forEach((cb) => {
                    cb.checked = this.checked;
                });
                updateSelectedTotal();
            });
        document.querySelectorAll(".select-cart-item").forEach((cb) => {
            cb.addEventListener("change", function () {
                if (!this.checked)
                    document.getElementById("selectAllCart").checked = false;
                else if (
                    document.querySelectorAll(".select-cart-item:checked")
                        .length ===
                    document.querySelectorAll(".select-cart-item").length
                )
                    document.getElementById("selectAllCart").checked = true;
                updateSelectedTotal();
            });
        });

        // Auto-select all items if cart has items
        const cartItems = document.querySelectorAll(".select-cart-item");
        if (cartItems.length > 0) {
            document.getElementById("selectAllCart").checked = true;
            cartItems.forEach((cb) => (cb.checked = true));
            updateSelectedTotal();
        }
        let deleteRow = null;
        let deleteCartId = null;
        const confirmDeleteModal = new bootstrap.Modal(
            document.getElementById("confirmDeleteModal")
        );
        document.querySelectorAll(".remove-btn").forEach(function (btn) {
            btn.addEventListener("click", function () {
                deleteRow = this.closest("tr");
                deleteCartId = this.getAttribute("data-id");
                confirmDeleteModal.show();
            });
        });
        document
            .getElementById("confirmDeleteBtn")
            .addEventListener("click", function () {
                if (deleteRow && deleteCartId) {
                    fetch("member-cart?action=remove&id=" + deleteCartId, {
                        method: "GET",
                        headers: {"X-Requested-With": "XMLHttpRequest"},
                    })
                        .then((response) => response.json())
                        .then((data) => {
                            if (data.success) {
                                deleteRow.remove();
                                updateSelectedTotal();
                            } else {
                                alert(data.message || "Có lỗi xảy ra!");
                            }
                            confirmDeleteModal.hide();
                        })
                        .catch(() => {
                            alert("Lỗi mạng hoặc server!");
                            confirmDeleteModal.hide();
                        });
                }
            });
    });
    document.querySelectorAll(".qty-btn").forEach(function (btn) {
        btn.addEventListener("click", function (e) {
            e.preventDefault();
            const cartId = this.getAttribute("data-id");
            const input = this.parentElement.querySelector(".qty-value");
            const oldQty = parseInt(input.value);
            const action = this.classList.contains("increase-btn")
                ? "increase"
                : "decrease";
            if (action === "decrease" && oldQty === 1) {
                // Không làm gì nếu giảm ở mức 1
                return;
            }
            let newQty = oldQty + (action === "increase" ? 1 : -1);
            input.value = newQty;
            this.disabled = true;
            fetch("member-cart?action=" + action + "&id=" + cartId, {
                method: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
            })
                .then((response) => response.json())
                .then((data) => {
                    this.disabled = false;
                    if (data.success) {
                        input.value = data.newQuantity;
                        if (data.newQuantity <= 0) {
                            this.closest("tr").remove();
                        }
                        updateSelectedTotal();
                        const row = this.closest("tr");
                        const price = parseInt(
                            row
                                .querySelector(".cart-price")
                                .textContent.replace(/[^\d]/g, "")
                        );
                        row.querySelector(".cart-line-total").textContent =
                            (price * data.newQuantity).toLocaleString() + " VNĐ";
                        const toast = document.createElement("div");
                        toast.className =
                            "toast align-items-center text-white bg-success border-0";
                        toast.role = "alert";
                        toast.innerHTML =
                            '<div class="d-flex"><div class="toast-body"><i class="fas fa-check-circle me-2"></i>Cập nhật số lượng thành công</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>';
                        document
                            .querySelector(".toast-container")
                            .appendChild(toast);
                        new bootstrap.Toast(toast, {delay: 2000}).show();
                        setTimeout(() => toast.remove(), 2200);
                    } else {
                        input.value = oldQty;
                        alert(data.message || "Có lỗi xảy ra!");
                    }
                })
                .catch(() => {
                    this.disabled = false;
                    input.value = oldQty;
                    alert("Lỗi mạng hoặc server!");
                });
        });
    });
</script>

<script src="assets/js/core/bootstrap.bundle.min.js"></script>
<script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        if (document.getElementById("successToast"))
            new bootstrap.Toast("#successToast").show();
        if (document.getElementById("errorToast"))
            new bootstrap.Toast("#errorToast").show();
    });
</script>
</body>
</html>
</Cart></Cart>

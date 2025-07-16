<%-- 
    Document   : createOrder
    Created on : Jul 15, 2025, 9:50:58 PM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="Models.User" %>
<%@page import="Models.Order" %>
<%@page import="Models.Product" %>
<%@page import="java.util.List" %>
<% 
    User loggedInUser = (User) session.getAttribute("loggedInUser"); 
    String action = request.getParameter("action");
    boolean isEdit = "edit".equalsIgnoreCase(action); 
    Order order = (Order) request.getAttribute("order");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String pageTitle = isEdit ? "Chỉnh sửa đơn hàng" : "Tạo đơn hàng mới"; 
%>

<c:set var="uri" value="${pageContext.request.requestURI}" />
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
        <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
        <title>
            <%= isEdit ? "Chỉnh sửa đơn hàng" : "Tạo đơn hàng mới" %> - CGMS
        </title>
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css"
              rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css"
              rel="stylesheet" />
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
        <style>
            .user-welcome {
                text-align: right;
                margin-left: auto;
            }

            .user-welcome .user-name {
                font-weight: 600;
                color: white;
                font-size: 1rem;
                margin-bottom: 0;
            }

            .user-welcome .user-email {
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.875rem;
            }

            .product-item {
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                background-color: #f8f9fa;
            }

            .product-item .remove-btn {
                color: #dc3545;
                cursor: pointer;
                font-size: 1.2rem;
            }

            .product-item .remove-btn:hover {
                color: #c82333;
            }

            .total-section {
                background-color: #e9ecef;
                padding: 20px;
                border-radius: 8px;
                margin-top: 20px;
            }

            .total-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .total-row.final {
                font-weight: bold;
                font-size: 1.2rem;
                border-top: 2px solid #6c757d;
                padding-top: 10px;
            }
        </style>
    </head>

    <body class="g-sidenav-show bg-gray-100">
        <div class="min-height-300 bg-dark position-absolute w-100"></div>

        <!-- Include Sidebar Component -->
        <%@ include file="sidebar.jsp" %>

        <!-- Main Content -->
        <main class="main-content position-relative border-radius-lg">
            <!-- Include Navbar Component with parameters -->
            <jsp:include page="navbar.jsp">
                <jsp:param name="pageTitle" value="<%= pageTitle %>" />
                <jsp:param name="parentPage" value="Quản lý Đơn hàng" />
                <jsp:param name="parentPageUrl" value="order?action=list" />
                <jsp:param name="currentPage" value="<%= pageTitle %>" />
            </jsp:include>

            <!-- Form -->
            <div class="container-fluid py-4">
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6>
                            <%= isEdit ? "Chỉnh sửa đơn hàng" : "Tạo đơn hàng mới" %>
                        </h6>
                        <a href="order.jsp" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                        </a>
                    </div>
                    <div class="card-body">
                        <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <%= request.getAttribute("errorMessage") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>

                        <form method="post" action="${pageContext.request.contextPath}/order" id="orderForm" novalidate>
                            <c:if test="${order.id != null}">
                                <input type="hidden" name="id" value="${order.id}" />
                            </c:if>
                            <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>" />

                            <!-- Customer Information -->
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Họ tên khách hàng *</label>
                                    <input type="text" class="form-control" name="customerName" 
                                           value="${order.customerName}" required maxlength="100" 
                                           placeholder="Nhập họ tên khách hàng" />
                                    <div class="invalid-feedback">
                                        Vui lòng nhập họ tên khách hàng
                                    </div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email khách hàng *</label>
                                    <input type="email" class="form-control" name="customerEmail" 
                                           value="${order.customerEmail}" required maxlength="100" 
                                           placeholder="Nhập email khách hàng" />
                                    <div class="invalid-feedback">
                                        Vui lòng nhập email hợp lệ
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại khách hàng *</label>
                                    <input type="tel" class="form-control" name="customerPhone" 
                                           value="${order.customerPhone}" required 
                                           pattern="^[0-9]{10,11}$" 
                                           title="Số điện thoại phải có 10-11 chữ số"
                                           placeholder="Nhập số điện thoại khách hàng" />
                                    <div class="invalid-feedback">
                                        Số điện thoại không hợp lệ (10-11 chữ số)
                                    </div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày đặt hàng *</label>
                                    <input type="date" class="form-control" name="orderDate" 
                                           value="${order.orderDate}" required id="orderDate" />
                                    <div class="invalid-feedback">
                                        Vui lòng chọn ngày đặt hàng
                                    </div>
                                </div>
                            </div>

                            <!-- Shipping Information -->
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label class="form-label">Địa chỉ giao hàng *</label>
                                    <textarea class="form-control" name="shippingAddress" 
                                              rows="3" required maxlength="500" 
                                              placeholder="Nhập địa chỉ giao hàng">${order.shippingAddress}</textarea>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập địa chỉ giao hàng
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại giao hàng *</label>
                                    <input type="tel" class="form-control" name="deliveryPhone" 
                                           value="${order.deliveryPhone}" required 
                                           pattern="^[0-9]{10,11}$" 
                                           title="Số điện thoại phải có 10-11 chữ số"
                                           placeholder="Nhập số điện thoại giao hàng" />
                                    <div class="invalid-feedback">
                                        Số điện thoại không hợp lệ (10-11 chữ số)
                                    </div>
                                    <small class="form-text text-muted">
                                        Số điện thoại để liên hệ khi giao hàng (có thể khác với SĐT khách hàng)
                                    </small>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trạng thái *</label>
                                    <select class="form-control" name="status" required>
                                        <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>
                                            Đang chờ xử lý
                                        </option>
                                        <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>
                                            Đang xử lý
                                        </option>
                                        <option value="Shipped" ${order.status == 'Shipped' ? 'selected' : ''}>
                                            Đã giao
                                        </option>
                                        <option value="Delivered" ${order.status == 'Delivered' ? 'selected' : ''}>
                                            Đã nhận
                                        </option>
                                        <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>
                                            Đã hủy
                                        </option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Vui lòng chọn trạng thái
                                    </div>
                                </div>
                            </div>

                            <!-- Product Selection -->
                            <div class="mb-4">
                                <h6 class="mb-3">Sản phẩm</h6>
                                <div class="row mb-3">
                                    <div class="col-md-8">
                                        <select class="form-control" id="productSelect">
                                            <option value="">-- Chọn sản phẩm để thêm --</option>
                                            <c:forEach var="product" items="${products}">
                                                <option value="${product.id}" 
                                                        data-name="${product.name}" 
                                                        data-price="${product.price}"
                                                        data-stock="${product.stock}">
                                                    ${product.name} - ${product.price} VND (Kho: ${product.stock})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <button type="button" class="btn btn-success" id="addProductBtn">
                                            <i class="fas fa-plus me-2"></i>Thêm sản phẩm
                                        </button>
                                    </div>
                                </div>

                                <div id="productList">
                                    <!-- Products will be added here dynamically -->
                                </div>
                            </div>

                            <!-- Order Summary -->
                            <div class="total-section">
                                <h6>Tóm tắt đơn hàng</h6>
                                <div class="total-row">
                                    <span>Tổng tiền hàng:</span>
                                    <span id="subtotal">0 VND</span>
                                </div>
                                <div class="total-row">
                                    <span>Phí vận chuyển:</span>
                                    <span id="shippingFee">30,000 VND</span>
                                </div>
                                <div class="total-row final">
                                    <span>Tổng cộng:</span>
                                    <span id="totalAmount">30,000 VND</span>
                                </div>
                            </div>

                            <input type="hidden" name="totalAmount" id="totalAmountInput" value="30000" />

                            <div class="d-flex justify-content-end mt-4">
                                <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                <button type="submit" class="btn btn-primary">Lưu đơn hàng</button>
                                <a href="order.jsp"
                                   class="btn btn-secondary ms-2">Quay lại danh sách</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/assets/js/core/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/core/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins/smooth-scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/argon-dashboard.min.js?v=2.1.0"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.getElementById('orderForm');
                const productSelect = document.getElementById('productSelect');
                const addProductBtn = document.getElementById('addProductBtn');
                const productList = document.getElementById('productList');
                const orderDateInput = document.getElementById('orderDate');
                const customerPhoneInput = document.querySelector('input[name="customerPhone"]');
                const deliveryPhoneInput = document.querySelector('input[name="deliveryPhone"]');
                
                let productCounter = 0;
                let selectedProducts = [];
                const shippingFee = 30000;

                // Set default date to today
                const today = new Date().toISOString().split('T')[0];
                if (!orderDateInput.value) {
                    orderDateInput.value = today;
                }

                // Auto-fill delivery phone from customer phone
                customerPhoneInput.addEventListener('input', function() {
                    if (this.value && !deliveryPhoneInput.value) {
                        deliveryPhoneInput.value = this.value;
                    }
                });

                // Add product function
                addProductBtn.addEventListener('click', function() {
                    const selectedOption = productSelect.options[productSelect.selectedIndex];
                    if (!selectedOption.value) {
                        alert('Vui lòng chọn sản phẩm');
                        return;
                    }

                    const productId = selectedOption.value;
                    const productName = selectedOption.getAttribute('data-name');
                    const productPrice = parseFloat(selectedOption.getAttribute('data-price'));
                    const productStock = parseInt(selectedOption.getAttribute('data-stock'));

                    // Check if product already exists
                    if (selectedProducts.find(p => p.id === productId)) {
                        alert('Sản phẩm đã được thêm vào đơn hàng');
                        return;
                    }

                    productCounter++;
                    const productItem = document.createElement('div');
                    productItem.className = 'product-item';
                    productItem.innerHTML = `
                        <div class="row align-items-center">
                            <div class="col-md-4">
                                <strong>${productName}</strong>
                                <input type="hidden" name="productIds" value="${productId}" />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Đơn giá</label>
                                <input type="text" class="form-control" value="${productPrice.toLocaleString()} VND" readonly />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Số lượng</label>
                                <input type="number" class="form-control quantity-input" 
                                       name="quantities" value="1" min="1" max="${productStock}" 
                                       data-price="${productPrice}" data-product-id="${productId}" />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Thành tiền</label>
                                <input type="text" class="form-control item-total" 
                                       value="${productPrice.toLocaleString()} VND" readonly />
                            </div>
                            <div class="col-md-2 text-end">
                                <span class="remove-btn" onclick="removeProduct(this, '${productId}')">
                                    <i class="fas fa-trash"></i>
                                </span>
                            </div>
                        </div>
                    `;

                    productList.appendChild(productItem);
                    selectedProducts.push({
                        id: productId,
                        name: productName,
                        price: productPrice,
                        quantity: 1
                    });

                    // Reset select
                    productSelect.selectedIndex = 0;
                    calculateTotal();
                });

                // Remove product function
                window.removeProduct = function(element, productId) {
                    element.closest('.product-item').remove();
                    selectedProducts = selectedProducts.filter(p => p.id !== productId);
                    calculateTotal();
                };

                // Calculate total
                function calculateTotal() {
                    let subtotal = 0;
                    const quantityInputs = document.querySelectorAll('.quantity-input');
                    
                    quantityInputs.forEach(input => {
                        const quantity = parseInt(input.value) || 0;
                        const price = parseFloat(input.getAttribute('data-price')) || 0;
                        const itemTotal = quantity * price;
                        
                        // Update item total display
                        const itemTotalInput = input.closest('.product-item').querySelector('.item-total');
                        itemTotalInput.value = itemTotal.toLocaleString() + ' VND';
                        
                        subtotal += itemTotal;
                    });

                    const total = subtotal + shippingFee;
                    
                    document.getElementById('subtotal').textContent = subtotal.toLocaleString() + ' VND';
                    document.getElementById('totalAmount').textContent = total.toLocaleString() + ' VND';
                    document.getElementById('totalAmountInput').value = total;
                }

                // Listen for quantity changes
                document.addEventListener('input', function(e) {
                    if (e.target.classList.contains('quantity-input')) {
                        const productId = e.target.getAttribute('data-product-id');
                        const quantity = parseInt(e.target.value) || 0;
                        
                        // Update selected products array
                        const product = selectedProducts.find(p => p.id === productId);
                        if (product) {
                            product.quantity = quantity;
                        }
                        
                        calculateTotal();
                    }
                });

                // Form validation
                form.addEventListener('submit', function(event) {
                    if (selectedProducts.length === 0) {
                        alert('Vui lòng thêm ít nhất một sản phẩm vào đơn hàng');
                        event.preventDefault();
                        return;
                    }

                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                });

                // Phone number validation
                function validatePhoneNumber(input) {
                    const value = input.value;
                    if (value && !/^[0-9]{10,11}$/.test(value)) {
                        input.setCustomValidity('Số điện thoại phải có 10-11 chữ số');
                    } else {
                        input.setCustomValidity('');
                    }
                }

                customerPhoneInput.addEventListener('input', function() {
                    validatePhoneNumber(this);
                });

                deliveryPhoneInput.addEventListener('input', function() {
                    validatePhoneNumber(this);
                });

                // Email validation
                const emailInput = document.querySelector('input[name="customerEmail"]');
                emailInput.addEventListener('input', function() {
                    const value = this.value;
                    if (value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                        this.setCustomValidity('Email không hợp lệ');
                    } else {
                        this.setCustomValidity('');
                    }
                });
            });
        </script>
    </body>
</html>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Product" %>
<%@ page import="Services.UserService" %>
<%@ page import="Services.ProductService" %>
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
    
    List<User> members = userService.getAllMembers();
    List<Product> products = productService.getAllActiveProducts();

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
    <title>Tạo đơn hàng - CGMS Admin</title>
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

        .product-item {
            border: 1px solid #e9ecef;
            border-radius: 0.75rem;
            padding: 1.25rem;
            margin-bottom: 1rem;
            background: #ffffff;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .product-item:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .product-item.selected {
            border-color: #5e72e4;
            background: #f8f9ff;
            box-shadow: 0 8px 25px rgba(94, 114, 228, 0.15);
        }

        .product-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 0.5rem;
        }

        .quantity-input {
            width: 70px;
            text-align: center;
        }

        .total-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-top: 1rem;
            position: sticky;
            top: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .search-container {
            background: #f8f9fa;
            border-radius: 1rem;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid #e9ecef;
        }

        .product-list {
            max-height: 500px;
            overflow-y: auto;
            padding-right: 0.5rem;
        }

        .product-list::-webkit-scrollbar {
            width: 6px;
        }

        .product-list::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .product-list::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 10px;
        }

        .btn-create-order {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .btn-create-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        .search-input {
            border: 2px solid #e9ecef;
            border-radius: 0.75rem;
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
        }

        .search-input:focus {
            border-color: #5e72e4;
            box-shadow: 0 0 0 0.2rem rgba(94, 114, 228, 0.25);
        }

        .form-card {
            border-radius: 1rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 1rem 1rem 0 0 !important;
        }

        .product-price {
            font-weight: 600;
            color: #28a745;
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
                <div class="card form-card">
                    <div class="card-header pb-0">
                        <div class="d-lg-flex">
                            <div>
                                <h5 class="mb-0 text-white">
                                    <i class="fas fa-plus-circle me-2"></i>Tạo đơn hàng mới
                                </h5>
                                <p class="text-sm mb-0 text-white opacity-8">
                                    Tạo đơn hàng cho khách hàng tại cơ sở
                                </p>
                            </div>
                            <div class="ms-auto my-auto mt-lg-0 mt-4">
                                <a href="order?action=list" class="btn btn-light btn-sm mb-0">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                                </a>
                            </div>
                        </div>
                    </div>
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

        <form action="admin-orders" method="post" id="createOrderForm">
            <input type="hidden" name="action" value="admin-create">
            
            <div class="row">
                <!-- Customer Information -->
                <div class="col-md-4">
                    <div class="card form-card">
                        <div class="card-header">
                            <h6 class="mb-0 text-white">
                                <i class="fas fa-user me-2"></i>Thông tin khách hàng
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3">
                                <label class="form-control-label">Chọn khách hàng *</label>
                                <select class="form-control" name="customerId" required>
                                    <option value="">-- Chọn khách hàng --</option>
                                    <% if (members != null) { 
                                        for (User member : members) { %>
                                    <option value="<%= member.getId() %>">
                                        <%= member.getFullName() %> - <%= member.getEmail() %>
                                    </option>
                                    <% } } %>
                                </select>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-control-label">Địa chỉ giao hàng *</label>
                                <textarea class="form-control" name="shippingAddress" rows="3" required 
                                    placeholder="Nhập địa chỉ giao hàng"></textarea>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label class="form-control-label">Tên người nhận *</label>
                                        <input type="text" class="form-control" name="receiverName" required 
                                            placeholder="Tên người nhận">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label class="form-control-label">Số điện thoại *</label>
                                        <input type="tel" class="form-control" name="receiverPhone" required 
                                            placeholder="Số điện thoại">
                                    </div>
                                </div>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-control-label">Phương thức thanh toán *</label>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="paymentMethod" 
                                                value="CASH" id="cashPayment" checked>
                                            <label class="form-check-label" for="cashPayment">
                                                <i class="fas fa-money-bill-wave me-2"></i>Tiền mặt
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="paymentMethod" 
                                                value="PAYOS" id="payosPayment">
                                            <label class="form-check-label" for="payosPayment">
                                                <i class="fas fa-credit-card me-2"></i>PayOS
                                            </label>
                                        </div>
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
                <div class="col-md-5">
                    <div class="card form-card">
                        <div class="card-header">
                            <h6 class="mb-0 text-white">
                                <i class="fas fa-box me-2"></i>Chọn sản phẩm
                            </h6>
                        </div>
                        <div class="card-body">
                            <!-- Search Box -->
                            <div class="search-container">
                                <div class="input-group">
                                    <span class="input-group-text bg-white">
                                        <i class="fas fa-search text-muted"></i>
                                    </span>
                                    <input type="text" class="form-control search-input" id="productSearch" 
                                        placeholder="Tìm kiếm sản phẩm..." style="border-left: none;">
                                    <button type="button" class="btn btn-outline-secondary" onclick="clearSearch()">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                                <div class="mt-2 text-muted">
                                    <small><i class="fas fa-info-circle me-1"></i>
                                    <span id="productCount"><%= products != null ? products.size() : 0 %></span> sản phẩm có sẵn</small>
                                </div>
                            </div>

                            <div class="product-list">
                                <% if (products != null && !products.isEmpty()) { 
                                    for (Product product : products) { %>
                                <div class="product-item" 
                                    data-product-id="<%= product.getId() %>" 
                                    data-product-price="<%= product.getPrice() %>"
                                    data-product-name="<%= product.getName().toLowerCase() %>">
                                    <div class="row align-items-center">
                                        <div class="col-2">
                                            <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                                            <img src="<%= product.getImageUrl() %>" class="product-img" alt="Product">
                                            <% } else { %>
                                            <div class="product-img bg-gradient-primary d-flex align-items-center justify-content-center">
                                                <i class="fas fa-box text-white"></i>
                                            </div>
                                            <% } %>
                                        </div>
                                        <div class="col-6">
                                            <h6 class="mb-1 product-name"><%= product.getName() %></h6>
                                            <p class="text-sm mb-0 product-price">
                                                <%= formatter.format(product.getPrice().longValue()) %> VNĐ
                                            </p>
                                        </div>
                                        <div class="col-2">
                                            <input type="number" class="form-control quantity-input" 
                                                min="0" max="100" value="0" 
                                                onchange="updateProductSelection(this)">
                                        </div>
                                        <div class="col-2">
                                            <div class="form-check">
                                                <input class="form-check-input product-checkbox" type="checkbox" 
                                                    onchange="toggleProduct(this)">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <% } } else { %>
                                <div class="text-center py-4">
                                    <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                    <p class="text-muted">Không có sản phẩm nào</p>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="col-md-3">
                    <div class="total-section">
                        <h6 class="mb-3">
                            <i class="fas fa-shopping-cart me-2"></i>
                            Tóm tắt đơn hàng
                        </h6>
                        <div id="selectedProducts">
                            <p class="mb-0 text-sm opacity-8">Chưa chọn sản phẩm nào</p>
                        </div>
                        <hr class="my-3 opacity-5">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">Tổng cộng:</h5>
                            <h5 class="mb-0" id="totalAmount">0 VNĐ</h5>
                        </div>
                        
                        <button type="submit" class="btn btn-create-order btn-lg w-100" id="submitBtn" disabled>
                            <i class="fas fa-plus me-2"></i>Tạo đơn hàng
                        </button>

                        <div class="mt-3 text-center">
                            <small class="opacity-8">
                                <i class="fas fa-info-circle me-1"></i>
                                Vui lòng chọn ít nhất 1 sản phẩm
                            </small>
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
console.log('JavaScript loaded successfully');

let selectedProducts = [];
let totalAmount = 0;

// Product search functionality
document.getElementById('productSearch').addEventListener('input', function() {
    console.log('Search input:', this.value);
    const searchTerm = this.value.toLowerCase().trim();
    const productItems = document.querySelectorAll('.product-item');
    let visibleCount = 0;

    productItems.forEach(function(item) {
        const productName = item.getAttribute('data-product-name');
        if (productName.includes(searchTerm)) {
            item.style.display = 'block';
            visibleCount++;
        } else {
            item.style.display = 'none';
        }
    });

    document.getElementById('productCount').textContent = visibleCount;
    console.log('Visible products:', visibleCount);
});

function clearSearch() {
    console.log('Clearing search');
    document.getElementById('productSearch').value = '';
    const productItems = document.querySelectorAll('.product-item');
    productItems.forEach(function(item) {
        item.style.display = 'block';
    });
    document.getElementById('productCount').textContent = productItems.length;
}

function toggleProduct(checkbox) {
    console.log('Toggle product called');
    const productItem = checkbox.closest('.product-item');
    const quantityInput = productItem.querySelector('.quantity-input');
    
    if (checkbox.checked) {
        productItem.classList.add('selected');
        quantityInput.value = Math.max(1, quantityInput.value || 1);
        quantityInput.disabled = false;
    } else {
        productItem.classList.remove('selected');
        quantityInput.value = 0;
        quantityInput.disabled = true;
    }
    
    updateSelectedProducts();
}

function updateProductSelection(quantityInput) {
    console.log('Update product selection called with value:', quantityInput.value);
    const productItem = quantityInput.closest('.product-item');
    const checkbox = productItem.querySelector('.product-checkbox');
    const quantity = parseInt(quantityInput.value) || 0;
    
    if (quantity > 0) {
        checkbox.checked = true;
        productItem.classList.add('selected');
    } else {
        checkbox.checked = false;
        productItem.classList.remove('selected');
    }
    
    updateSelectedProducts();
}

function updateSelectedProducts() {
    console.log('Updating selected products');
    selectedProducts = [];
    totalAmount = 0;
    
    const selectedItems = document.querySelectorAll('.product-item.selected');
    console.log('Found selected items:', selectedItems.length);
    
    selectedItems.forEach(function(item) {
        const productId = item.getAttribute('data-product-id');
        const productPrice = parseFloat(item.getAttribute('data-product-price'));
        const productName = item.querySelector('.product-name').textContent;
        const quantity = parseInt(item.querySelector('.quantity-input').value) || 0;
        
        console.log('Processing:', productName, 'Price:', productPrice, 'Qty:', quantity);
        
        if (quantity > 0) {
            const subtotal = productPrice * quantity;
            selectedProducts.push({
                id: productId,
                name: productName,
                price: productPrice,
                quantity: quantity,
                subtotal: subtotal
            });
            totalAmount += subtotal;
        }
    });
    
    console.log('Selected products:', selectedProducts);
    console.log('Total amount:', totalAmount);
    
    updateOrderSummary();
}

function updateOrderSummary() {
    console.log('Updating order summary');
    const selectedProductsDiv = document.getElementById('selectedProducts');
    const totalAmountDiv = document.getElementById('totalAmount');
    const submitBtn = document.getElementById('submitBtn');
    
    if (selectedProducts.length === 0) {
        selectedProductsDiv.innerHTML = '<p class="mb-0 text-sm opacity-8">Chưa chọn sản phẩm nào</p>';
        submitBtn.disabled = true;
        submitBtn.classList.remove('btn-success');
        submitBtn.classList.add('btn-create-order');
    } else {
        let html = '';
        selectedProducts.forEach(function(product) {
            html += '<div class="d-flex justify-content-between align-items-center mb-2">';
            html += '<span class="text-sm">' + product.name + ' x ' + product.quantity + '</span>';
            html += '<span class="text-sm">' + formatNumber(product.subtotal) + ' VNĐ</span>';
            html += '</div>';
        });
        selectedProductsDiv.innerHTML = html;
        submitBtn.disabled = false;
        submitBtn.classList.remove('btn-create-order');
        submitBtn.classList.add('btn-success');
    }
    
    totalAmountDiv.textContent = formatNumber(totalAmount) + ' VNĐ';
    console.log('UI updated - Total:', totalAmountDiv.textContent, 'Button disabled:', submitBtn.disabled);
}

function formatNumber(num) {
    return new Intl.NumberFormat('vi-VN').format(num);
}

// Add hidden inputs for selected products before form submission
document.getElementById('createOrderForm').addEventListener('submit', function(e) {
    console.log('Form submitted with products:', selectedProducts);
    
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
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    console.log('Page loaded, initializing...');
    updateSelectedProducts();
});
</script>
</body>
</html>
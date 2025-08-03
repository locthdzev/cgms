<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Product" %>
<%@page import="Models.Inventory" %>
<%@page import="Services.ProductService" %>
<%@page import="Services.InventoryService" %>
<%@page import="Models.User" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>

<%
    if (session.getAttribute("loggedInUser") == null || 
        !"Member".equals(((User) session.getAttribute("loggedInUser")).getRole())) {
        response.sendRedirect("login");
        return;
    }

    ProductService productService = new ProductService();
    InventoryService inventoryService = new InventoryService();
    List<Product> allProducts = productService.getAllProducts();
    List<Product> products = new ArrayList<>();
    
    // Debug: Log số lượng products
    System.out.println("Total products from database: " + (allProducts != null ? allProducts.size() : 0));
    
    if (allProducts != null) {
        for (Product product : allProducts) {
            System.out.println("Product: " + product.getName() + " - Status: " + product.getStatus());
            if ("Active".equalsIgnoreCase(product.getStatus())) {
                products.add(product);
            }
        }
    }
    
    System.out.println("Active products: " + products.size());

    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    
    String successMessage = (String) session.getAttribute("successMessage");
    boolean hasSuccessMessage = (successMessage != null);
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }

    String errorMessage = (String) session.getAttribute("errorMessage");
    boolean hasErrorMessage = (errorMessage != null);
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cửa hàng - CORE-FIT GYM</title>
    <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
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

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .shop-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .cart-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            color: white;
            padding: 0.75rem 1.5rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            position: relative;
        }

        .cart-btn:hover {
            background: white;
            color: #667eea;
            text-decoration: none;
        }

        .cart-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #ef4444;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 700;
            min-width: 20px;
        }

        .search-section {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .search-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 3rem;
            border: 2px solid #e2e8f0;
            border-radius: 25px;
            transition: border-color 0.3s ease;
        }

        .search-input:focus {
            border-color: #667eea;
            outline: none;
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #718096;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .product-image-container {
            position: relative;
            height: 200px;
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .product-image-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .stock-badge {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .stock-badge.in-stock {
            background: #10b981;
            color: white;
        }

        .stock-badge.low-stock {
            background: #f59e0b;
            color: white;
        }

        .stock-badge.out-of-stock {
            background: #ef4444;
            color: white;
        }

        .product-content {
            padding: 1.5rem;
        }

        .product-name {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #2d3748;
        }

        .product-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: #059669;
            margin-bottom: 0.75rem;
        }

        .stock-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            font-size: 0.875rem;
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

        .add-to-cart-btn {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            color: white;
            padding: 0.75rem;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .add-to-cart-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .add-to-cart-btn:disabled {
            background: #e2e8f0;
            color: #a0aec0;
            cursor: not-allowed;
        }

        .modal-content {
            border-radius: 15px;
            border: none;
        }

        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            overflow: hidden;
        }

        .quantity-btn {
            background: white;
            border: none;
            padding: 0.5rem 0.75rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .quantity-btn:hover:not(:disabled) {
            background: #f7fafc;
        }

        .quantity-input {
            border: none;
            text-align: center;
            width: 50px;
            padding: 0.5rem;
        }

        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Toast Animation */
        .toast {
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border: none;
        }

        /* Empty State */
        .empty-products {
            text-align: center;
            padding: 4rem 2rem;
            color: #718096;
        }

        .empty-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            font-size: 1rem;
            margin-bottom: 2rem;
        }

        .debug-info {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 2rem;
            font-family: monospace;
            font-size: 0.875rem;
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
    <div class="toast-container">
        <% if (hasSuccessMessage) { %>
        <div class="toast align-items-center text-white bg-success border-0" role="alert" id="successToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <% } %>
        <% if (hasErrorMessage) { %>
        <div class="toast align-items-center text-white bg-danger border-0" role="alert" id="errorToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <% } %>
    </div>

    <%@ include file="member_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <%@ include file="navbar.jsp" %>

        <div class="container-fluid py-4">
            <div class="shop-header">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="mb-1">
                                <i class="fas fa-store me-2"></i>
                                Cửa hàng CORE-FIT
                            </h1>
                            <p class="mb-0 opacity-75">
                                Khám phá các sản phẩm chất lượng cao cho việc tập luyện
                            </p>
                        </div>
                        <div>
                            <a href="member-cart" class="cart-btn">
                                <i class="fas fa-shopping-cart"></i>
                                Giỏ hàng
                                <span class="cart-badge" id="cartBadge">0</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="search-section">
                <div class="position-relative">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" id="productSearch" placeholder="Tìm kiếm sản phẩm...">
                </div>
            </div>

            <div class="products-grid" id="productsGrid">
                <% if (products != null && !products.isEmpty()) { 
                    for (Product product : products) { 
                        Inventory inventory = inventoryService.getInventoryByProductId(product.getId());
                        int stockQuantity = (inventory != null && inventory.getQuantity() != null) ? inventory.getQuantity() : 0;
                        String stockBadgeClass = stockQuantity <= 0 ? "out-of-stock" : (stockQuantity <= 10 ? "low-stock" : "in-stock");
                        
                        // Escape strings properly for JavaScript
                        String productName = product.getName().replace("'", "\\'").replace("\"", "\\\"").replace("\r", "").replace("\n", "");
                        String productDesc = (product.getDescription() != null ? product.getDescription() : "Sản phẩm chất lượng cao").replace("'", "\\'").replace("\"", "\\\"").replace("\r", "").replace("\n", "");
                        String productImage = (product.getImageUrl() != null ? product.getImageUrl() : "").replace("'", "\\'").replace("\"", "\\\"");
                %>
                <div class="product-card" data-product-name="<%= product.getName().toLowerCase() %>">
                    <div class="product-image-container">
                        <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                        <img src="<%= product.getImageUrl() %>" class="product-image" alt="<%= product.getName() %>">
                        <% } else { %>
                        <div class="product-image-placeholder">
                            <i class="fas fa-dumbbell"></i>
                        </div>
                        <% } %>
                        <div class="stock-badge <%= stockBadgeClass %>">
                            <% if (stockQuantity <= 0) { %>
                                Hết hàng
                            <% } else if (stockQuantity <= 10) { %>
                                Sắp hết
                            <% } else { %>
                                Còn hàng
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="product-content">
                        <h3 class="product-name"><%= product.getName() %></h3>
                        <div class="product-price">
                            <%= formatter.format(product.getPrice().longValue()) %> VNĐ
                        </div>
                        
                        <div class="stock-info <%= stockQuantity <= 0 ? "out-of-stock" : (stockQuantity <= 10 ? "low-stock" : "in-stock") %>">
                            <i class="fas <%= stockQuantity <= 0 ? "fa-times-circle" : (stockQuantity <= 10 ? "fa-exclamation-triangle" : "fa-check-circle") %>"></i>
                            <span>Còn lại: <%= stockQuantity %> sản phẩm</span>
                        </div>
                        
                        <button class="add-to-cart-btn" 
                                onclick="showProductModal(<%= product.getId() %>, '<%= productName %>', '<%= productDesc %>', <%= product.getPrice() %>, '<%= productImage %>', <%= stockQuantity %>)"
                                <%= stockQuantity <= 0 ? "disabled" : "" %>>
                            <% if (stockQuantity <= 0) { %>
                                <i class="fas fa-ban"></i>
                                Hết hàng
                            <% } else { %>
                                <i class="fas fa-cart-plus"></i>
                                Thêm vào giỏ
                            <% } %>
                        </button>
                    </div>
                </div>
                <% } 
                } else { %>
                <div class="empty-products">
                    <div class="empty-icon">
                        <i class="fas fa-box-open"></i>
                    </div>
                    <h3 class="empty-title">Chưa có sản phẩm</h3>
                    <p class="empty-description">
                        Hiện tại chưa có sản phẩm nào trong cửa hàng. 
                        <% if (allProducts != null && !allProducts.isEmpty()) { %>
                        <br><strong>Lưu ý:</strong> Có <%= allProducts.size() %> sản phẩm trong database nhưng không có sản phẩm nào có status "Active".
                        <% } %>
                    </p>
                </div>
                <% } %>
            </div>
        </div>
    </main>

    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-info-circle me-2"></i>
                        Chi tiết sản phẩm
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <img id="modalProductImage" class="w-100 rounded mb-3" style="height: 250px; object-fit: cover;" alt="Product">
                        </div>
                        <div class="col-md-6">
                            <h3 id="modalProductName" class="mb-2"></h3>
                            <div id="modalProductPrice" class="h4 text-success mb-2"></div>
                            <p id="modalProductDescription" class="text-muted mb-3"></p>
                            
                            <div class="stock-info mb-3" id="modalStockInfo">
                                <i class="fas fa-check-circle"></i>
                                <span id="modalStockText"></span>
                            </div>
                            
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <span class="fw-bold">Số lượng:</span>
                                <div class="quantity-controls">
                                    <button type="button" class="quantity-btn" onclick="decreaseQuantity()">
                                        <i class="fas fa-minus"></i>
                                    </button>
                                    <input type="number" class="quantity-input" id="quantityInput" value="1" min="1">
                                    <button type="button" class="quantity-btn" onclick="increaseQuantity()">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <button type="button" class="add-to-cart-btn" id="modalAddToCartBtn" onclick="addToCart()">
                                <i class="fas fa-cart-plus"></i>
                                <span>Thêm vào giỏ hàng</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
    <script>
        let currentProduct = null;
        let maxQuantity = 0;

        function formatNumber(num) {
            return new Intl.NumberFormat('vi-VN').format(num);
        }

        // Show toast notification với hỗ trợ warning
        function showToast(type, message) {
            const toastContainer = document.querySelector('.toast-container');
            const toast = document.createElement('div');
            toast.className = 'toast align-items-center text-white bg-' + (type === 'success' ? 'success' : type === 'warning' ? 'warning' : 'danger') + ' border-0';
            toast.setAttribute('role', 'alert');
            toast.innerHTML = 
                '<div class="d-flex">' +
                    '<div class="toast-body">' +
                        '<i class="fas fa-' + (type === 'success' ? 'check-circle' : type === 'warning' ? 'exclamation-triangle' : 'exclamation-circle') + ' me-2"></i>' + message +
                    '</div>' +
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
                '</div>';
            
            toastContainer.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast, { delay: type === 'warning' ? 5000 : 3000 });
            bsToast.show();
            
            toast.addEventListener('hidden.bs.toast', function() {
                toast.remove();
            });
        }

        // Update cart badge
        function updateCartBadge() {
            fetch('member-cart?action=count', {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const badge = document.getElementById('cartBadge');
                    badge.textContent = data.cartItemCount;
                    badge.style.display = data.cartItemCount > 0 ? 'flex' : 'none';
                }
            })
            .catch(error => {
                console.error('Error updating cart badge:', error);
            });
        }

        // Search functionality
        document.getElementById('productSearch').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase().trim();
            const productCards = document.querySelectorAll('.product-card');
            
            productCards.forEach(function(card) {
                const productName = card.getAttribute('data-product-name');
                card.style.display = (productName && productName.includes(searchTerm)) ? 'block' : 'none';
            });
        });

        function showProductModal(id, name, description, price, imageUrl, stockQuantity) {
            currentProduct = { id, name, description, price, imageUrl, stockQuantity };
            maxQuantity = stockQuantity;

            document.getElementById('modalProductName').textContent = name;
            document.getElementById('modalProductPrice').textContent = formatNumber(price) + ' VNĐ';
            document.getElementById('modalProductDescription').textContent = description || 'Sản phẩm chất lượng cao';
            
            const stockInfo = document.getElementById('modalStockInfo');
            const stockText = document.getElementById('modalStockText');
            stockText.textContent = 'Còn lại: ' + stockQuantity + ' sản phẩm';
            
            if (stockQuantity <= 0) {
                stockInfo.className = 'stock-info mb-3 out-of-stock';
                stockInfo.querySelector('i').className = 'fas fa-times-circle';
            } else if (stockQuantity <= 10) {
                stockInfo.className = 'stock-info mb-3 low-stock';
                stockInfo.querySelector('i').className = 'fas fa-exclamation-triangle';
            } else {
                stockInfo.className = 'stock-info mb-3 in-stock';
                stockInfo.querySelector('i').className = 'fas fa-check-circle';
            }

            const modalImage = document.getElementById('modalProductImage');
            if (imageUrl && imageUrl.trim() !== '') {
                modalImage.src = imageUrl;
                modalImage.style.display = 'block';
            } else {
                modalImage.style.display = 'none';
            }

            document.getElementById('quantityInput').value = 1;
            updateQuantityButtons();

            new bootstrap.Modal(document.getElementById('productModal')).show();
        }

        function increaseQuantity() {
            const input = document.getElementById('quantityInput');
            const currentValue = parseInt(input.value) || 1;
            if (currentValue < maxQuantity) {
                input.value = currentValue + 1;
                updateQuantityButtons();
            }
        }

        function decreaseQuantity() {
            const input = document.getElementById('quantityInput');
            const currentValue = parseInt(input.value) || 1;
            if (currentValue > 1) {
                input.value = currentValue - 1;
                updateQuantityButtons();
            }
        }

        function updateQuantityButtons() {
            const input = document.getElementById('quantityInput');
            const currentValue = parseInt(input.value) || 1;
            const buttons = document.querySelectorAll('.quantity-btn');
            
            buttons[0].disabled = currentValue <= 1;
            buttons[1].disabled = currentValue >= maxQuantity;
        }

        function addToCart() {
            if (!currentProduct) return;

            const quantity = parseInt(document.getElementById('quantityInput').value) || 1;
            const btn = document.getElementById('modalAddToCartBtn');
            const originalHTML = btn.innerHTML;
            
            btn.innerHTML = '<div class="loading-spinner"></div><span>Đang thêm...</span>';
            btn.disabled = true;

            // AJAX request to add to cart
            fetch('member-cart?action=add&id=' + currentProduct.id + '&quantity=' + quantity, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Kiểm tra nếu là partial add (chỉ thêm được một phần)
                    if (data.isPartial) {
                        showToast('warning', data.message);
                    } else {
                        showToast('success', data.message);
                    }
                    updateCartBadge();
                    
                    // Close modal after short delay
                    setTimeout(() => {
                        bootstrap.Modal.getInstance(document.getElementById('productModal')).hide();
                    }, 1500);
                } else {
                    showToast('error', data.message || 'Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('error', 'Có lỗi kết nối. Vui lòng thử lại!');
            })
            .finally(() => {
                btn.innerHTML = originalHTML;
                btn.disabled = false;
            });
        }

        // Initialize page
        document.addEventListener("DOMContentLoaded", function () {
            // Show existing toasts
            [].slice.call(document.querySelectorAll('.toast')).forEach(function(toastEl) {
                new bootstrap.Toast(toastEl).show();
            });

            // Update cart badge on page load
            updateCartBadge();

            // Handle quantity input changes
            document.getElementById('quantityInput').addEventListener('input', function() {
                let value = Math.max(1, Math.min(maxQuantity, parseInt(this.value) || 1));
                this.value = value;
                updateQuantityButtons();
            });
        });
    </script>
</body>
</html>
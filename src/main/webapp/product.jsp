<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.User"%>
<%@page import="Models.Product"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    Product product = (Product) request.getAttribute("product");
    String formAction = (String) request.getAttribute("formAction");
    if (formAction == null) formAction = "list";
    
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
    // Lấy thông báo từ request hoặc session
    String successMessage = (String) request.getAttribute("successMessage");
    if (successMessage == null) {
        successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            session.removeAttribute("successMessage");
        }
    }
    
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) {
        errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
            session.removeAttribute("errorMessage");
        }
    }
    
    boolean hasSuccessMessage = successMessage != null;
    boolean hasErrorMessage = errorMessage != null;
    
    // Định dạng ngày tháng
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
    <title>Quản lý sản phẩm - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
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
        
        /* Toast styles */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
        
        .toast {
            min-width: 300px;
        }
        
        /* Detail styles */
        .detail-label {
            font-weight: 600;
            color: #344767;
        }
        
        .product-detail-img {
            max-height: 300px;
            object-fit: cover;
            border-radius: 10px;
        }
        
        /* Product image styles */
        .product-img-thumbnail {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        /* Image preview */
        .image-preview {
            width: 100%;
            max-height: 300px;
            object-fit: contain;
            margin-top: 10px;
            border-radius: 10px;
            display: none;
        }
        
        .current-image {
            max-width: 100%;
            max-height: 200px;
            object-fit: contain;
            border-radius: 10px;
            margin-bottom: 10px;
        }
        
        /* Delete button style */
        .delete-action {
            color: #f5365c !important;
        }
        
        .delete-action:hover {
            background-color: #ffeef1 !important;
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

<!-- Include Sidebar Component -->
<%@ include file="sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Quản lý sản phẩm" />
        <jsp:param name="parentPage" value="Dashboard" />
        <jsp:param name="parentPageUrl" value="dashboard.jsp" />
        <jsp:param name="currentPage" value="Quản lý sản phẩm" />
    </jsp:include>
    
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <% if (productList != null) { %>
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6>Danh sách sản phẩm</h6>
                        <div>
                            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <a href="${pageContext.request.contextPath}/addProduct" class="btn btn-primary btn-sm">
                                <i class="fas fa-plus me-2"></i>Thêm sản phẩm
                            </a>
                        </div>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                <tr>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">ID</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Hình ảnh</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Tên sản phẩm</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Giá</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Trạng thái</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Ngày tạo</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% for (Product p : productList) { %>
                                    <tr>
                                        <td class="text-center"><h6 class="mb-0 text-sm"><%= p.getId() %></h6></td>
                                        <td>
                                            <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
                                                <img src="<%= p.getImageUrl() %>" alt="<%= p.getName() %>" class="product-img-thumbnail" onerror="this.onerror=null; this.src='assets/img/placeholder-image.jpg';">
                                            <% } else { %>
                                                <div class="product-img-thumbnail bg-secondary d-flex align-items-center justify-content-center">
                                                    <i class="fas fa-image text-white"></i>
                                                </div>
                                            <% } %>
                                        </td>
                                        <td class="ps-2">
                                            <h6 class="mb-0 text-sm"><%= p.getName() %></h6>
                                            <% if (p.getDescription() != null && !p.getDescription().isEmpty()) { %>
                                                <p class="text-xs text-secondary mb-0">
                                                    <%= p.getDescription().length() > 50 ? p.getDescription().substring(0, 50) + "..." : p.getDescription() %>
                                                </p>
                                            <% } %>
                                        </td>
                                        <td class="ps-2"><h6 class="mb-0 text-sm"><%= String.format("%,d", p.getPrice().intValue()) %> VNĐ</h6></td>
                                        <td class="ps-2">
                                            <% if ("Active".equals(p.getStatus())) { %>
                                                <span class="badge badge-sm bg-gradient-success">Hoạt động</span>
                                            <% } else { %>
                                                <span class="badge badge-sm bg-gradient-secondary">Không hoạt động</span>
                                            <% } %>
                                        </td>
                                        <td class="ps-2">
                                            <p class="text-xs text-secondary mb-0">
                                                <%= p.getCreatedAt() != null ? p.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "" %>
                                            </p>
                                        </td>
                                        <td class="text-center">
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-icon-only text-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                    <i class="fas fa-ellipsis-v"></i>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end">
                                                    <li><a class="dropdown-item view-product-btn" href="#" 
                                                            data-id="<%= p.getId() %>"
                                                            data-name="<%= p.getName() %>"
                                                            data-description="<%= p.getDescription() != null ? p.getDescription() : "" %>"
                                                            data-price="<%= p.getPrice() %>"
                                                            data-image="<%= p.getImageUrl() != null ? p.getImageUrl() : "" %>"
                                                            data-status="<%= p.getStatus() %>"
                                                            data-created="<%= p.getCreatedAt() != null ? p.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "" %>"
                                                            data-updated="<%= p.getUpdatedAt() != null ? p.getUpdatedAt().toString().replace("T", " ").substring(0, 16) : "" %>">
                                                            <i class="fas fa-eye me-2"></i>Xem chi tiết</a></li>
                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/editProduct?id=<%= p.getId() %>"><i class="fas fa-edit me-2"></i>Chỉnh sửa</a></li>
                                                    <li>
                                                        <a class="dropdown-item delete-product-btn delete-action" href="#" 
                                                            data-id="<%= p.getId() %>" 
                                                            data-name="<%= p.getName() %>">
                                                            <i class="fas fa-trash me-2"></i>Xóa
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6><%= ("create".equals(formAction) ? "Thêm sản phẩm mới" : ("edit".equals(formAction) ? "Chỉnh sửa sản phẩm" : "Chi tiết sản phẩm")) %></h6>
                        <a href="${pageContext.request.contextPath}/product" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                        </a>
                    </div>
                    <div class="card-body">
                        <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> <%= request.getAttribute("errorMessage") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>
                        <form method="post" enctype="multipart/form-data">
                            <input type="hidden" name="formAction" value="<%= formAction %>"/>
                            <% if (product != null && product.getId() != null) { %>
                                <input type="hidden" name="id" value="<%= product.getId() %>"/>
                            <% } %>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tên sản phẩm *</label>
                                    <input type="text" name="name" class="form-control" value="<%= product != null && product.getName() != null ? product.getName() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %> required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giá *</label>
                                    <div class="input-group">
                                        <input type="number" name="price" class="form-control" value="<%= product != null && product.getPrice() != null ? product.getPrice().intValue() : "" %>" min="0" step="1000" <%= "view".equals(formAction) ? "readonly" : "" %> required/>
                                        <span class="input-group-text">VNĐ</span>
                                    </div>
                                </div>
                                <div class="col-md-12 mb-3">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="description" class="form-control" rows="4" <%= "view".equals(formAction) ? "readonly" : "" %>><%= product != null && product.getDescription() != null ? product.getDescription() : "" %></textarea>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trạng thái *</label>
                                    <% if ("view".equals(formAction)) { %>
                                        <input type="text" name="status" class="form-control" value="<%= product != null ? ("Active".equals(product.getStatus()) ? "Hoạt động" : "Không hoạt động") : "" %>" readonly/>
                                    <% } else { %>
                                        <select name="status" class="form-control" required>
                                            <option value="Active" <%= product != null && "Active".equals(product.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                                            <option value="Inactive" <%= product != null && "Inactive".equals(product.getStatus()) ? "selected" : "" %>>Không hoạt động</option>
                                        </select>
                                    <% } %>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Hình ảnh sản phẩm</label>
                                    <% if (!"view".equals(formAction)) { %>
                                        <input type="file" name="image" class="form-control" accept="image/*" onchange="previewImage(this)"/>
                                        <small class="text-muted">Chấp nhận các file hình ảnh (JPG, PNG, GIF). Tối đa 10MB.</small>
                                    <% } %>
                                </div>
                                <% if (product != null && product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                                <div class="col-md-12 mb-3">
                                    <label class="form-label"><%= "view".equals(formAction) ? "Hình ảnh" : "Hình ảnh hiện tại" %></label>
                                    <div>
                                        <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="current-image" onerror="this.onerror=null; this.src='assets/img/placeholder-image.jpg';">
                                    </div>
                                </div>
                                <% } %>
                                <% if (!"view".equals(formAction)) { %>
                                <div class="col-md-12 mb-3">
                                    <img id="imagePreview" class="image-preview" alt="Preview" />
                                </div>
                                <% } %>
                            </div>
                            <div class="d-flex justify-content-end mt-4">
                                <% if (!"view".equals(formAction)) { %>
                                <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                <button class="btn btn-primary" type="submit">Lưu</button>
                                <% } %>
                                <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary ms-2">Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
                <% } %>
                
                <!-- Modal xem chi tiết sản phẩm -->
                <div class="modal fade" id="viewProductModal" tabindex="-1" aria-labelledby="viewProductModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="viewProductModalLabel">Chi tiết sản phẩm</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Hình ảnh sản phẩm -->
                                <div class="text-center mb-4" id="productImageContainer">
                                    <img id="productImage" src="" alt="Product Image" class="product-detail-img" onerror="this.onerror=null; this.src='assets/img/placeholder-image.jpg';">
                                </div>
                                
                                <!-- Thông tin cơ bản -->
                                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                                    <div>
                                        <h4 id="productName" class="fw-bold mb-0"></h4>
                                        <div class="d-flex align-items-center mt-1">
                                            <span id="viewProductStatus" class="badge me-2"></span>
                                            <span id="productPrice" class="text-sm"></span>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Thông tin chi tiết -->
                                <div class="row">
                                    <div class="col-12 mb-3">
                                        <h6 class="mb-2 detail-label">Mô tả sản phẩm</h6>
                                        <p id="productDescription" class="text-sm"></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h6 class="mb-2 detail-label">Ngày tạo</h6>
                                        <p id="productCreatedAt" class="text-sm"></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h6 class="mb-2 detail-label">Cập nhật lần cuối</h6>
                                        <p id="productUpdatedAt" class="text-sm"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                                <a href="#" id="editProductBtn" class="btn btn-primary">Chỉnh sửa</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Modal xác nhận xóa sản phẩm -->
                <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="deleteConfirmModalLabel">Xác nhận xóa</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <p>Bạn có chắc chắn muốn xóa sản phẩm "<span id="productNameToDelete"></span>"?</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        // Hiển thị toast thông báo nếu có
                        if (document.getElementById('successToast')) {
                            var successToast = new bootstrap.Toast(document.getElementById('successToast'), {
                                delay: 5000,
                                animation: true
                            });
                            successToast.show();
                        }
                        
                        if (document.getElementById('errorToast')) {
                            var errorToast = new bootstrap.Toast(document.getElementById('errorToast'), {
                                delay: 5000,
                                animation: true
                            });
                            errorToast.show();
                        }
                        
                        // Thêm sự kiện click cho các nút xóa sản phẩm
                        document.querySelectorAll('.delete-product-btn').forEach(function(button) {
                            button.addEventListener('click', function() {
                                const id = this.getAttribute('data-id');
                                const name = this.getAttribute('data-name');
                                
                                document.getElementById('productNameToDelete').textContent = name;
                                document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/product?action=delete&id=' + id;
                                
                                var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                                deleteModal.show();
                            });
                        });
                        
                        // Thêm sự kiện click cho các nút xem chi tiết
                        document.querySelectorAll('.view-product-btn').forEach(function(button) {
                            button.addEventListener('click', function() {
                                const id = this.getAttribute('data-id');
                                const name = this.getAttribute('data-name');
                                const description = this.getAttribute('data-description');
                                const price = this.getAttribute('data-price');
                                const image = this.getAttribute('data-image');
                                const status = this.getAttribute('data-status');
                                const createdAt = this.getAttribute('data-created');
                                const updatedAt = this.getAttribute('data-updated');
                                
                                document.getElementById('productName').textContent = name;
                                document.getElementById('productDescription').textContent = description || 'Không có mô tả';
                                document.getElementById('productPrice').textContent = new Intl.NumberFormat('vi-VN').format(parseInt(price)) + ' VNĐ';
                                document.getElementById('productCreatedAt').textContent = createdAt || 'Không có thông tin';
                                document.getElementById('productUpdatedAt').textContent = updatedAt || 'Chưa cập nhật';
                                
                                // Xử lý hiển thị hình ảnh
                                const imageContainer = document.getElementById('productImageContainer');
                                const productImage = document.getElementById('productImage');
                                
                                if (image && image.trim() !== '') {
                                    productImage.src = image;
                                    imageContainer.style.display = 'block';
                                } else {
                                    imageContainer.style.display = 'none';
                                }
                                
                                // Cập nhật trạng thái với badge
                                const statusBadge = document.getElementById('viewProductStatus');
                                if (status === 'Active') {
                                    statusBadge.className = 'badge bg-gradient-success';
                                    statusBadge.textContent = 'Hoạt động';
                                } else {
                                    statusBadge.className = 'badge bg-gradient-secondary';
                                    statusBadge.textContent = 'Không hoạt động';
                                }
                                
                                // Cập nhật link chỉnh sửa
                                document.getElementById('editProductBtn').href = '${pageContext.request.contextPath}/editProduct?id=' + id;
                                
                                var viewModal = new bootstrap.Modal(document.getElementById('viewProductModal'));
                                viewModal.show();
                            });
                        });
                    });
                    
                    // Image preview function
                    function previewImage(input) {
                        const preview = document.getElementById('imagePreview');
                        if (input.files && input.files[0]) {
                            const reader = new FileReader();
                            reader.onload = function(e) {
                                preview.src = e.target.result;
                                preview.style.display = 'block';
                            }
                            reader.readAsDataURL(input.files[0]);
                        } else {
                            preview.style.display = 'none';
                        }
                    }
                </script>
                <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
                <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
                <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
                <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
                <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
            </div>
        </div>
    </div>
</main>
</body>
</html> 
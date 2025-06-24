<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Package"%>
<%
    // Lấy thông tin gói tập cần chỉnh sửa
    Package pkg = (Package) request.getAttribute("package");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
        <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
        <title>Cập nhật gói tập - CoreFit Gym</title>
        <!-- Fonts and icons -->
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
        <!-- Nucleo Icons -->
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
        <!-- Font Awesome Icons -->
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <!-- CSS Files -->
        <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
    </head>
    <body class="g-sidenav-show bg-gray-100">
        <div class="min-height-300 bg-dark position-absolute w-100"></div>
        
        <!-- Include Sidebar Component -->
        <%@ include file="sidebar.jsp" %>
        
        <!-- Main content -->
        <main class="main-content position-relative border-radius-lg">
            <!-- Include Navbar Component with parameters -->
            <jsp:include page="navbar.jsp">
                <jsp:param name="pageTitle" value="Cập nhật gói tập" />
                <jsp:param name="parentPage" value="Danh sách gói tập" />
                <jsp:param name="parentPageUrl" value="listPackage" />
                <jsp:param name="currentPage" value="Cập nhật gói tập" />
            </jsp:include>
            
            <% 
                if (pkg == null) {
                    response.sendRedirect("listPackage?error=Không+tìm+thấy+gói+tập");
                    return;
                }
            %>
            
            <div class="container-fluid py-4">
                <!-- Hiển thị thông báo lỗi nếu có -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> <%= request.getAttribute("errorMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                
                <div class="row">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                                <h6>Cập nhật gói tập</h6>
                                <a href="listPackage" class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                                </a>
                            </div>
                            <div class="card-body">
                                <!-- Form cập nhật gói tập -->
                                <form action="editPackage" method="post">
                                    <input type="hidden" name="id" value="<%= pkg.getId() %>">
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="name" class="form-label">Tên gói tập *</label>
                                            <input type="text" class="form-control" id="name" name="name" 
                                                   value="<%= pkg.getName() %>" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="price" class="form-label">Giá (VNĐ) *</label>
                                            <input type="text" class="form-control" id="price" name="price"
                                                   value="<%= String.format("%,.0f", pkg.getPrice()) %>"
                                                   placeholder="Ví dụ: 500000 hoặc 500,000"
                                                   pattern="[0-9,\s]*"
                                                   title="Chỉ nhập số và dấu phẩy"
                                                   required>
                                            <small class="form-text text-muted">
                                                Giá từ 50,000 - 100,000,000 VNĐ. Nên là bội số của 1,000 VNĐ.
                                            </small>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="duration" class="form-label">Thời hạn (ngày) *</label>
                                            <input type="number" class="form-control" id="duration" name="duration"
                                                   value="<%= pkg.getDuration() %>"
                                                   min="1" max="3650"
                                                   placeholder="Ví dụ: 30"
                                                   required>
                                            <small class="form-text text-muted">Từ 1 đến 3650 ngày (tối đa 10 năm)</small>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="sessions" class="form-label">Số buổi tập</label>
                                            <input type="number" class="form-control" id="sessions" name="sessions"
                                                   value="<%= pkg.getSessions() != null ? pkg.getSessions() : "" %>"
                                                   min="1" max="1000"
                                                   placeholder="Ví dụ: 12">
                                            <small class="form-text text-muted">Tùy chọn. Từ 1 đến 1000 buổi</small>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Mô tả</label>
                                        <textarea class="form-control" id="description" name="description" rows="3"><%= pkg.getDescription() != null ? pkg.getDescription() : "" %></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="status" class="form-label">Trạng thái</label>
                                        <div class="form-control-plaintext">
                                            <% if ("Active".equals(pkg.getStatus())) { %>
                                                <span class="badge bg-gradient-success">Hoạt động</span>
                                            <% } else { %>
                                                <span class="badge bg-gradient-secondary">Không hoạt động</span>
                                            <% } %>
                                            <input type="hidden" name="status" value="<%= pkg.getStatus() %>">
                                        </div>
                                        <small class="text-muted">Trạng thái chỉ có thể thay đổi từ trang danh sách gói tập</small>
                                    </div>
                                    <div class="d-flex justify-content-end mt-4">
                                        <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                        <button type="submit" class="btn btn-primary">Cập nhật gói tập</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
        <!-- Core JS Files -->
        <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
        <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
        <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

        <script>
        document.addEventListener('DOMContentLoaded', function() {
            const priceInput = document.getElementById('price');

            // Format price input with commas
            priceInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/[^\d]/g, ''); // Remove non-digits
                if (value) {
                    // Add commas for thousands
                    value = parseInt(value).toLocaleString('vi-VN');
                    e.target.value = value;
                }
            });

            // Remove commas before form submission
            document.querySelector('form').addEventListener('submit', function(e) {
                priceInput.value = priceInput.value.replace(/[^\d]/g, '');
            });

            // Validate price on blur
            priceInput.addEventListener('blur', function(e) {
                const value = parseInt(e.target.value.replace(/[^\d]/g, ''));

                if (value) {
                    if (value < 50000) {
                        showValidationMessage('Giá tối thiểu là 50,000 VNĐ', 'danger');
                    } else if (value > 100000000) {
                        showValidationMessage('Giá tối đa là 100,000,000 VNĐ', 'danger');
                    } else if (value % 1000 !== 0) {
                        showValidationMessage('Giá nên là bội số của 1,000 VNĐ để dễ thanh toán', 'warning');
                    } else {
                        removeValidationMessage();
                    }
                }
            });

            function showValidationMessage(message, type) {
                removeValidationMessage();

                const validation = document.createElement('div');
                validation.className = `price-validation alert alert-${type} mt-2`;
                validation.innerHTML = `<small><i class="fas fa-exclamation-triangle me-1"></i>${message}</small>`;

                priceInput.parentNode.appendChild(validation);
            }

            function removeValidationMessage() {
                const existing = document.querySelector('.price-validation');
                if (existing) {
                    existing.remove();
                }
            }
        });
        </script>
    </body>
</html>






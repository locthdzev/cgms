<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
        <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
        <title>Thêm gói tập mới - CoreFit Gym</title>
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
                <jsp:param name="pageTitle" value="Thêm gói tập mới" />
                <jsp:param name="parentPage" value="Danh sách gói tập" />
                <jsp:param name="parentPageUrl" value="listPackage" />
                <jsp:param name="currentPage" value="Thêm gói tập mới" />
            </jsp:include>
            
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
                                <h6>Thêm gói tập mới</h6>
                                <a href="listPackage" class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                                </a>
                            </div>
                            <div class="card-body">
                                <!-- Form thêm gói tập mới -->
                                <form action="addPackage" method="post">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="name" class="form-label">Tên gói tập *</label>
                                            <input type="text" class="form-control" id="name" name="name" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="price" class="form-label">Giá (VNĐ) *</label>
                                            <input type="number" class="form-control" id="price" name="price" required>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="duration" class="form-label">Thời hạn (ngày) *</label>
                                            <input type="number" class="form-control" id="duration" name="duration" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="sessions" class="form-label">Số buổi tập</label>
                                            <input type="number" class="form-control" id="sessions" name="sessions">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Mô tả</label>
                                        <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="status" class="form-label">Trạng thái *</label>
                                        <select class="form-control" id="status" name="status" required>
                                            <option value="Active" selected>Hoạt động</option>
                                            <option value="Inactive">Không hoạt động</option>
                                        </select>
                                    </div>
                                    <div class="d-flex justify-content-end mt-4">
                                        <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                        <button type="submit" class="btn btn-primary">Lưu gói tập</button>
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
    </body>
</html>



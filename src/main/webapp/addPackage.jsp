<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Thêm gói tập mới - CoreFit Gym</title>
        <!-- Fonts and icons -->
        <!--        <link href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,800" rel="stylesheet" />
                <link href="assets/css/nucleo-icons.css" rel="stylesheet" />
                <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
                <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>-->
        <!-- CSS Files -->
        <!--<link id="pagestyle" href="assets/css/soft-design-system.css" rel="stylesheet" />-->
    </head>
    <body>
        <!-- Header/Navigation would go here -->
        
        <div class="container mt-5 pt-5">
            <div class="row">
                <div class="col-12 d-flex justify-content-between align-items-center mb-4">
                    <h2>Thêm gói tập mới</h2>
                    <a href="listPackage.jsp" class="btn btn-outline-primary btn-round"><i class="fas fa-arrow-left me-2"></i>Quay lại danh sách</a>
                </div>
            </div>
            
            <!-- Hiển thị thông báo lỗi nếu có -->
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
            
            <div class="card">
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
                                <option value="Active" selected>Active</option>
                                <option value="Inactive">Inactive</option>
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
        
        <!-- Footer would go here -->
        
        <!-- Core JS Files -->
        <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
        <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/js/soft-design-system.min.js" type="text/javascript"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%
    // Lấy thông tin người dùng cần chỉnh sửa
    User trainer = (User) request.getAttribute("trainer");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
    <title>Chỉnh sửa Personal Trainer - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
    <style>
        .image-preview {
            max-width: 300px;
            max-height: 200px;
            display: none;
            margin-top: 10px;
        }
        .current-image {
            max-width: 300px;
            max-height: 200px;
            margin-top: 10px;
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>

<!-- Include Sidebar Component -->
<%@ include file="sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Chỉnh sửa Personal Trainer" />
        <jsp:param name="parentPage" value="Danh sách Personal Trainer" />
        <jsp:param name="parentPageUrl" value="trainer" />
        <jsp:param name="currentPage" value="Chỉnh sửa Personal Trainer" />
    </jsp:include>
    
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6>Chỉnh sửa Personal Trainer</h6>
                        <div>
                            <a href="trainer" class="btn btn-outline-secondary btn-sm me-2">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> <%= request.getAttribute("errorMessage") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>
                        <form method="post" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<%= trainer.getId() %>"/>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email *</label>
                                    <input type="email" name="email" class="form-control" value="<%= trainer.getEmail() %>" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tên đăng nhập *</label>
                                    <input type="text" name="userName" class="form-control" value="<%= trainer.getUserName() %>" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Họ tên *</label>
                                    <input type="text" name="fullName" class="form-control" value="<%= trainer.getFullName() %>" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" name="phoneNumber" class="form-control" value="<%= trainer.getPhoneNumber() != null ? trainer.getPhoneNumber() : "" %>"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <input type="text" name="address" class="form-control" value="<%= trainer.getAddress() != null ? trainer.getAddress() : "" %>"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giới tính</label>
                                    <select name="gender" class="form-control">
                                        <option value="Nam" <%= "Nam".equals(trainer.getGender()) ? "selected" : "" %>>Nam</option>
                                        <option value="Nữ" <%= "Nữ".equals(trainer.getGender()) ? "selected" : "" %>>Nữ</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Zalo</label>
                                    <input type="text" name="zalo" class="form-control" value="<%= trainer.getZalo() != null ? trainer.getZalo() : "" %>"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Facebook</label>
                                    <input type="text" name="facebook" class="form-control" value="<%= trainer.getFacebook() != null ? trainer.getFacebook() : "" %>"/>
                                </div>
                                <div class="col-md-12 mb-3">
                                    <label class="form-label">Kinh nghiệm</label>
                                    <textarea name="experience" class="form-control" rows="3"><%= trainer.getExperience() != null ? trainer.getExperience() : "" %></textarea>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ảnh chứng chỉ</label>
                                    <input type="file" name="certificateImage" class="form-control" accept="image/*" onchange="previewCertificateImage(this)"/>
                                    <small class="text-muted">Chấp nhận các file hình ảnh (JPG, PNG, GIF). Tối đa 10MB.</small>
                                </div>
                                <% if (trainer.getCertificateImageUrl() != null && !trainer.getCertificateImageUrl().isEmpty()) { %>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Chứng chỉ hiện tại</label>
                                    <div>
                                        <img src="<%= trainer.getCertificateImageUrl() %>" alt="Certificate" class="current-image" onerror="this.onerror=null; this.src='assets/img/placeholder-image.jpg';">
                                    </div>
                                </div>
                                <% } %>
                                <div class="col-md-12 mb-3">
                                    <img id="certificateImagePreview" class="image-preview" alt="Certificate Preview" />
                                </div>
                                <input type="hidden" name="role" value="Personal Trainer" />
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trạng thái *</label>
                                    <select name="status" class="form-control" required>
                                        <option value="Active" <%= "Active".equals(trainer.getStatus()) ? "selected" : "" %>>Active</option>
                                        <option value="Inactive" <%= "Inactive".equals(trainer.getStatus()) ? "selected" : "" %>>Inactive</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" name="dob" class="form-control" value="<%= trainer.getDob() != null ? trainer.getDob().toString() : "" %>"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Mật khẩu mới (để trống nếu không thay đổi)</label>
                                    <input type="password" name="password" class="form-control"/>
                                </div>
                            </div>
                            <div class="d-flex justify-content-end mt-4">
                                <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                <button class="btn btn-primary" type="submit">Lưu</button>
                                <a href="trainer" class="btn btn-secondary ms-2">Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="assets/js/core/popper.min.js" type="text/javascript"></script>
<script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
<script src="assets/js/plugins/perfect-scrollbar.min.js" type="text/javascript"></script>
<script src="assets/js/plugins/smooth-scrollbar.min.js" type="text/javascript"></script>
<script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
<script>
    function previewCertificateImage(input) {
        var preview = document.getElementById('certificateImagePreview');
        if (input.files && input.files[0]) {
            var reader = new FileReader();
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
</body>
</html> 
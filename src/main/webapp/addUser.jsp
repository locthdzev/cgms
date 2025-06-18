<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Thêm người dùng mới - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>

<!-- Include Sidebar Component -->
<%@ include file="sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <nav class="navbar navbar-main navbar-expand-lg px-0 mx-4 shadow-none border-radius-xl" id="navbarBlur" data-scroll="false">
        <div class="container-fluid py-1 px-3">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb bg-transparent mb-0 pb-0 pt-1 px-0 me-sm-6 me-5">
                    <li class="breadcrumb-item text-sm"><a class="opacity-5 text-white" href="dashboard.jsp">Dashboard</a></li>
                    <li class="breadcrumb-item text-sm"><a class="opacity-5 text-white" href="user">Danh sách người dùng</a></li>
                    <li class="breadcrumb-item text-sm text-white active" aria-current="page">Thêm người dùng mới</li>
                </ol>
                <h6 class="font-weight-bolder text-white mb-0">Thêm người dùng mới</h6>
            </nav>
        </div>
    </nav>
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6>Thêm người dùng mới</h6>
                        <a href="user" class="btn btn-outline-secondary btn-sm">
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
                        <form method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email *</label>
                                    <input type="email" name="email" class="form-control" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tên đăng nhập *</label>
                                    <input type="text" name="userName" class="form-control" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Họ tên *</label>
                                    <input type="text" name="fullName" class="form-control" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" name="phoneNumber" class="form-control"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <input type="text" name="address" class="form-control"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giới tính</label>
                                    <select name="gender" class="form-control">
                                        <option value="Nam">Nam</option>
                                        <option value="Nữ">Nữ</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Vai trò *</label>
                                    <select name="role" class="form-control" required>
                                        <option value="Member">Member</option>
                                        <option value="Personal Trainer">Personal Trainer</option>
                                    </select>
                                </div>
                                <input type="hidden" name="status" value="Active"/>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" name="dob" class="form-control"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Mật khẩu *</label>
                                    <input type="password" name="password" class="form-control" required/>
                                </div>
                            </div>
                            <div class="d-flex justify-content-end mt-4">
                                <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                <button class="btn btn-primary" type="submit">Lưu</button>
                                <a href="user" class="btn btn-secondary ms-2">Quay lại</a>
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
<script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
<script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
<script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html> 
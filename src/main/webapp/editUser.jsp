<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%
    User user = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Chỉnh sửa người dùng - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>
<aside class="sidenav bg-white navbar navbar-vertical navbar-expand-xs border-0 border-radius-xl my-3 fixed-start ms-4" id="sidenav-main">
    <div class="sidenav-header">
        <i class="fas fa-times p-3 cursor-pointer text-secondary opacity-5 position-absolute end-0 top-0 d-none d-xl-none" aria-hidden="true" id="iconSidenav"></i>
        <a class="navbar-brand m-0" href="dashboard.jsp">
            <img src="./assets/img/weightlifting.png" width="26px" height="26px" class="navbar-brand-img h-100" alt="main_logo" />
            <span class="ms-1 font-weight-bold">CGMS</span>
        </a>
    </div>
    <hr class="horizontal dark mt-0" />
    <div class="collapse navbar-collapse w-auto" id="sidenav-collapse-main">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="dashboard.jsp">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="ni ni-tv-2 text-dark text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="listPackage">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="ni ni-calendar-grid-58 text-dark text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Gói tập Gym</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="user">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="ni ni-single-02 text-dark text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Quản lý người dùng</span>
                </a>
            </li>
        </ul>
    </div>
</aside>
<main class="main-content position-relative border-radius-lg">
    <nav class="navbar navbar-main navbar-expand-lg px-0 mx-4 shadow-none border-radius-xl" id="navbarBlur" data-scroll="false">
        <div class="container-fluid py-1 px-3">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb bg-transparent mb-0 pb-0 pt-1 px-0 me-sm-6 me-5">
                    <li class="breadcrumb-item text-sm"><a class="opacity-5 text-white" href="dashboard.jsp">Dashboard</a></li>
                    <li class="breadcrumb-item text-sm"><a class="opacity-5 text-white" href="user">Danh sách người dùng</a></li>
                    <li class="breadcrumb-item text-sm text-white active" aria-current="page">Chỉnh sửa người dùng</li>
                </ol>
                <h6 class="font-weight-bolder text-white mb-0">Chỉnh sửa người dùng</h6>
            </nav>
        </div>
    </nav>
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6>Chỉnh sửa người dùng</h6>
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
                            <input type="hidden" name="id" value="<%= user != null ? user.getId() : "" %>"/>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email *</label>
                                    <input type="email" name="email" class="form-control" value="<%= user != null ? user.getEmail() : "" %>" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tên đăng nhập *</label>
                                    <input type="text" name="userName" class="form-control" value="<%= user != null ? user.getUserName() : "" %>" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Họ tên *</label>
                                    <input type="text" name="fullName" class="form-control" value="<%= user != null ? user.getFullName() : "" %>" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" name="phoneNumber" class="form-control" value="<%= user != null ? user.getPhoneNumber() : "" %>"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <input type="text" name="address" class="form-control" value="<%= user != null ? user.getAddress() : "" %>"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giới tính</label>
                                    <input type="text" name="gender" class="form-control" value="<%= user != null ? user.getGender() : "" %>"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Vai trò *</label>
                                    <input type="text" name="role" class="form-control" value="<%= user != null ? user.getRole() : "" %>" required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trạng thái *</label>
                                    <select name="status" class="form-control" required>
                                        <option value="Active" <%= user != null && "Active".equals(user.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                                        <option value="Inactive" <%= user != null && "Inactive".equals(user.getStatus()) ? "selected" : "" %>>Không hoạt động</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" name="dob" class="form-control" value="<%= user != null && user.getDob() != null ? user.getDob().toString() : "" %>"/>
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
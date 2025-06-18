<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.User"%>
<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    User user = (User) request.getAttribute("user");
    String formAction = (String) request.getAttribute("formAction");
    if (formAction == null) formAction = "list";
    
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Quản lý người dùng - CGMS</title>
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
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>

<!-- Include Sidebar Component -->
<%@ include file="sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Quản lý người dùng" />
        <jsp:param name="parentPage" value="Dashboard" />
        <jsp:param name="parentPageUrl" value="dashboard.jsp" />
        <jsp:param name="currentPage" value="Quản lý người dùng" />
    </jsp:include>
    
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <% if (userList != null) { %>
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6>Danh sách người dùng</h6>
                        <div>
                            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <a href="addUser" class="btn btn-primary btn-sm">
                                <i class="fas fa-plus me-2"></i>Thêm người dùng
                            </a>
                        </div>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                <tr>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">ID</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Email</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Tên đăng nhập</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Họ tên</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Số điện thoại</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Vai trò</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Trạng thái</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% for (User u : userList) { %>
                                    <tr>
                                        <td class="text-center"><h6 class="mb-0 text-sm"><%= u.getId() %></h6></td>
                                        <td class="ps-2"><h6 class="mb-0 text-sm"><%= u.getEmail() %></h6></td>
                                        <td class="ps-2"><h6 class="mb-0 text-sm"><%= u.getUserName() %></h6></td>
                                        <td class="ps-2"><h6 class="mb-0 text-sm"><%= u.getFullName() %></h6></td>
                                        <td class="ps-2"><h6 class="mb-0 text-sm"><%= u.getPhoneNumber() %></h6></td>
                                        <td class="ps-2"><h6 class="mb-0 text-sm"><%= u.getRole() %></h6></td>
                                        <td class="ps-2">
                                            <% if ("Active".equals(u.getStatus())) { %>
                                                <span class="badge badge-sm bg-gradient-success">Hoạt động</span>
                                            <% } else { %>
                                                <span class="badge badge-sm bg-gradient-secondary">Không hoạt động</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-icon-only text-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                    <i class="fas fa-ellipsis-v"></i>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end">
                                                    <li><a class="dropdown-item" href="#"><i class="fas fa-eye me-2"></i>Xem chi tiết</a></li>
                                                    <li><a class="dropdown-item" href="editUser?id=<%= u.getId() %>"><i class="fas fa-edit me-2"></i>Chỉnh sửa</a></li>
                                                    <li>
                                                        <a class="dropdown-item update-status-btn" href="#" 
                                                            data-id="<%= u.getId() %>" 
                                                            data-name="<%= u.getFullName() %>" 
                                                            data-status="<%= u.getStatus() %>">
                                                            <i class="fas fa-rotate me-2"></i>Cập nhật trạng thái
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
                        <h6><%= ("create".equals(formAction) ? "Thêm người dùng mới" : ("edit".equals(formAction) ? "Chỉnh sửa người dùng" : "Chi tiết người dùng")) %></h6>
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
                            <input type="hidden" name="formAction" value="<%= formAction %>"/>
                            <% if (user != null && user.getId() != null) { %>
                                <input type="hidden" name="id" value="<%= user.getId() %>"/>
                            <% } %>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email *</label>
                                    <input type="email" name="email" class="form-control" value="<%= user != null ? user.getEmail() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %> required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tên đăng nhập *</label>
                                    <input type="text" name="userName" class="form-control" value="<%= user != null ? user.getUserName() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %> required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Họ tên *</label>
                                    <input type="text" name="fullName" class="form-control" value="<%= user != null ? user.getFullName() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %> required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" name="phoneNumber" class="form-control" value="<%= user != null ? user.getPhoneNumber() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %>/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <input type="text" name="address" class="form-control" value="<%= user != null ? user.getAddress() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %>/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giới tính</label>
                                    <input type="text" name="gender" class="form-control" value="<%= user != null ? user.getGender() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %>/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Vai trò *</label>
                                    <input type="text" name="role" class="form-control" value="<%= user != null ? user.getRole() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %> required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trạng thái *</label>
                                    <% if ("view".equals(formAction)) { %>
                                        <input type="text" name="status" class="form-control" value="<%= user != null ? user.getStatus() : "" %>" readonly/>
                                    <% } else { %>
                                        <select name="status" class="form-control" required>
                                            <option value="Active" <%= user != null && "Active".equals(user.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                                            <option value="Inactive" <%= user != null && "Inactive".equals(user.getStatus()) ? "selected" : "" %>>Không hoạt động</option>
                                        </select>
                                    <% } %>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" name="dob" class="form-control" value="<%= user != null && user.getDob() != null ? user.getDob().toString() : "" %>" <%= "view".equals(formAction) ? "readonly" : "" %>/>
                                </div>
                                <% if ("create".equals(formAction)) { %>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Mật khẩu *</label>
                                    <input type="password" name="password" class="form-control" required/>
                                </div>
                                <% } %>
                            </div>
                            <div class="d-flex justify-content-end mt-4">
                                <% if (!"view".equals(formAction)) { %>
                                <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                <button class="btn btn-primary" type="submit">Lưu</button>
                                <% } %>
                                <a href="user" class="btn btn-secondary ms-2">Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
                <% } %>
                <!-- Modal cập nhật trạng thái người dùng -->
                <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="updateStatusModalLabel">Cập nhật trạng thái người dùng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <p>Bạn có chắc chắn muốn thay đổi trạng thái của người dùng <span id="userName"></span>?</p>
                                <form id="updateStatusForm" action="updateUserStatus" method="post">
                                    <input type="hidden" id="userId" name="id" value="">
                                    <div class="mb-3">
                                        <label class="form-label">Trạng thái mới</label>
                                        <select name="status" id="userStatus" class="form-control">
                                            <option value="Active">Hoạt động</option>
                                            <option value="Inactive">Không hoạt động</option>
                                        </select>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="button" class="btn btn-primary" onclick="document.getElementById('updateStatusForm').submit();">Xác nhận</button>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        // Thêm sự kiện click cho các nút cập nhật trạng thái
                        document.querySelectorAll('.update-status-btn').forEach(function(button) {
                            button.addEventListener('click', function() {
                                const id = this.getAttribute('data-id');
                                const name = this.getAttribute('data-name');
                                const status = this.getAttribute('data-status');
                                
                                document.getElementById('userId').value = id;
                                document.getElementById('userName').textContent = name;
                                document.getElementById('userStatus').value = status === 'Active' ? 'Inactive' : 'Active';
                                
                                var myModal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
                                myModal.show();
                            });
                        });
                    });
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
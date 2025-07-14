<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
    // Kiểm tra xem người dùng đã đăng nhập và có vai trò Member không
    if (loggedInUser == null || !"Member".equals(loggedInUser.getRole())) {
      response.sendRedirect("login");
      return;
    }
    
    // Lấy thông báo từ session nếu có
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    
    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
    
    // Đặt tiêu đề trang cho navbar
    request.setAttribute("pageTitle", "Dashboard");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Dashboard Member - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
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
        
        .card-stats {
            transition: all 0.3s ease;
        }
        
        .card-stats:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        
        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
        
        .membership-card {
            background: linear-gradient(135deg, #5e72e4 0%, #825ee4 100%);
            color: white;
            border-radius: 15px;
            overflow: hidden;
            position: relative;
        }
        
        .membership-card .card-body {
            position: relative;
            z-index: 2;
        }
        
        .membership-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('assets/img/curved-images/white-curved.jpg');
            background-size: cover;
            opacity: 0.1;
            z-index: 1;
        }
        
        .membership-info {
            font-size: 0.875rem;
        }
        
        .membership-info .value {
            font-weight: 600;
            font-size: 1rem;
        }
        
        .upcoming-session {
            border-left: 4px solid #5e72e4;
            padding-left: 15px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        
        .upcoming-session:hover {
            transform: translateX(5px);
        }
        
        .session-time {
            font-weight: 600;
            color: #5e72e4;
        }
        
        .progress-container {
            margin-top: 10px;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        
        .progress-label .value {
            font-weight: 600;
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f2f5;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }
        
        .activity-content {
            flex: 1;
        }
        
        .activity-title {
            font-weight: 600;
            margin-bottom: 3px;
        }
        
        .activity-time {
            font-size: 0.75rem;
            color: #8392ab;
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>

<!-- Toast Container -->
<div class="toast-container">
    <% if (successMessage != null) { %>
    <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true" id="successToast">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    <% } %>
    <% if (errorMessage != null) { %>
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
<%@ include file="member_sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Dashboard Member" />
        <jsp:param name="parentPage" value="Dashboard" />
        <jsp:param name="parentPageUrl" value="member-dashboard" />
        <jsp:param name="currentPage" value="Dashboard" />
    </jsp:include>
    
    <div class="container-fluid py-4">
        <!-- Greeting section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body p-3">
    <div class="row">
                            <div class="col-lg-6">
                                <div class="d-flex">
                                    <div class="avatar avatar-xl bg-gradient-primary rounded-circle">
                                        <i class="fas fa-user text-white position-relative" style="font-size: 24px; top: 10px; left: 12px;"></i>
                                    </div>
                                    <div class="ms-3">
                                        <h5 class="mb-0">Xin chào, <%= loggedInUser.getFullName() %>!</h5>
                                        <p class="text-sm mb-0">Chúc bạn một ngày tập luyện hiệu quả!</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6 text-end d-flex align-items-center justify-content-end">
                                <a href="member-schedule.jsp" class="btn btn-sm btn-primary me-2">
                                    <i class="fas fa-calendar-alt me-2"></i>Xem lịch tập
                                </a>
                                <a href="member-shop.jsp" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-shopping-cart me-2"></i>Mua sản phẩm
                                </a>
                            </div>
                        </div>
          </div>
                </div>
            </div>
        </div>
        
        <!-- Stats cards -->
        <div class="row">
            <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Buổi tập đã hoàn thành</p>
                                    <h5 class="font-weight-bolder mb-0">
                                        15
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-primary shadow text-center border-radius-md">
                                    <i class="fas fa-check-circle text-lg opacity-10" aria-hidden="true"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Buổi tập sắp tới</p>
                                    <h5 class="font-weight-bolder mb-0">
                                        3
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-warning shadow text-center border-radius-md">
                                    <i class="fas fa-calendar-alt text-lg opacity-10" aria-hidden="true"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Đơn hàng</p>
                                    <h5 class="font-weight-bolder mb-0">
                                        2
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-success shadow text-center border-radius-md">
                                    <i class="fas fa-shopping-bag text-lg opacity-10" aria-hidden="true"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Điểm tích lũy</p>
                                    <h5 class="font-weight-bolder mb-0">
                                        150
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-info shadow text-center border-radius-md">
                                    <i class="fas fa-star text-lg opacity-10" aria-hidden="true"></i>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
        <!-- Membership and schedule section -->
        <div class="row mt-4">
            <div class="col-lg-5 mb-lg-0 mb-4">
                <div class="card membership-card z-index-2 h-100">
                    <div class="card-body p-3">
                        <div class="d-flex justify-content-between">
                            <h6 class="text-white mb-2">Gói tập hiện tại</h6>
                            <span class="badge bg-gradient-light text-dark">Đang hoạt động</span>
                        </div>
                        <h4 class="text-white mb-3">Gói Premium 3 tháng</h4>
                        <div class="row">
                            <div class="col-6">
                                <div class="membership-info mb-2">
                                    <span>Ngày bắt đầu</span><br>
                                    <span class="value">01/06/2024</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="membership-info mb-2">
                                    <span>Ngày kết thúc</span><br>
                                    <span class="value">01/09/2024</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="membership-info mb-2">
                                    <span>Còn lại</span><br>
                                    <span class="value">45 ngày</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="membership-info mb-2">
                                    <span>Buổi PT còn lại</span><br>
                                    <span class="value">8 buổi</span>
                                </div>
                            </div>
                        </div>
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Tiến độ gói tập</span>
                                <span class="value">50%</span>
                            </div>
                            <div class="progress bg-light bg-opacity-10">
                                <div class="progress-bar bg-white" role="progressbar" style="width: 50%" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between mt-4">
                            <a href="member-packages-controller" class="btn btn-sm btn-outline-light">Xem chi tiết</a>
                            <a href="member-packages-controller" class="btn btn-sm btn-light">Gia hạn gói tập</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="card z-index-2 h-100">
                    <div class="card-header pb-0 p-3">
                        <div class="d-flex justify-content-between">
                            <h6 class="mb-0">Lịch tập sắp tới</h6>
                            <a href="member-schedule.jsp" class="btn btn-link text-primary text-sm">Xem tất cả</a>
                        </div>
                    </div>
                    <div class="card-body p-3">
                        <div class="upcoming-session">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="session-time">Hôm nay, 17:30 - 18:30</span>
                                    <h6 class="mb-0">Tập luyện với PT Nguyễn Văn A</h6>
                                    <p class="text-sm text-muted mb-0">Phòng tập chính, Tầng 2</p>
                                </div>
                                <div>
                                    <span class="badge bg-gradient-success">Xác nhận</span>
                                </div>
                            </div>
                        </div>
                        <div class="upcoming-session">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="session-time">Ngày mai, 08:00 - 09:00</span>
                                    <h6 class="mb-0">Lớp Yoga cơ bản</h6>
                                    <p class="text-sm text-muted mb-0">Phòng Yoga, Tầng 3</p>
                                </div>
                                <div>
                                    <span class="badge bg-gradient-warning">Chờ xác nhận</span>
                                </div>
                            </div>
                        </div>
                        <div class="upcoming-session">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="session-time">20/07/2024, 19:00 - 20:00</span>
                                    <h6 class="mb-0">Tập luyện với PT Nguyễn Văn A</h6>
                                    <p class="text-sm text-muted mb-0">Phòng tập chính, Tầng 2</p>
                                </div>
                                <div>
                                    <span class="badge bg-gradient-success">Xác nhận</span>
                                </div>
                            </div>
                        </div>
                        <div class="text-center mt-4">
                            <a href="member-schedule.jsp" class="btn btn-sm btn-outline-primary">Đặt lịch tập mới</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Activity and products section -->
        <div class="row mt-4">
            <div class="col-lg-8 mb-lg-0 mb-4">
                <div class="card">
                    <div class="card-header pb-0 p-3">
                        <div class="d-flex justify-content-between">
                            <h6 class="mb-0">Hoạt động gần đây</h6>
                        </div>
                    </div>
                    <div class="card-body p-3">
                        <div class="activity-item">
                            <div class="activity-icon bg-gradient-primary text-white">
                                <i class="fas fa-dumbbell"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Hoàn thành buổi tập với PT</div>
                                <div class="activity-description text-sm">Bạn đã hoàn thành buổi tập với PT Nguyễn Văn A</div>
                                <div class="activity-time">Hôm qua, 18:30</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-gradient-success text-white">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Mua sản phẩm</div>
                                <div class="activity-description text-sm">Bạn đã mua Whey Protein 1kg</div>
                                <div class="activity-time">15/07/2024, 10:15</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-gradient-warning text-white">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Đặt lịch tập</div>
                                <div class="activity-description text-sm">Bạn đã đặt lịch tập với PT Nguyễn Văn A</div>
                                <div class="activity-time">14/07/2024, 09:30</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-gradient-info text-white">
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Nhận điểm thưởng</div>
                                <div class="activity-description text-sm">Bạn đã nhận 50 điểm thưởng từ việc check-in liên tục 5 ngày</div>
                                <div class="activity-time">12/07/2024, 17:45</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header pb-0 p-3">
                        <div class="d-flex justify-content-between">
                            <h6 class="mb-0">Sản phẩm đề xuất</h6>
                            <a href="member-shop.jsp" class="btn btn-link text-primary text-sm">Xem tất cả</a>
                        </div>
                    </div>
                    <div class="card-body p-3">
                        <div class="d-flex mb-3">
                            <img src="assets/img/products/whey-protein.jpg" alt="Whey Protein" class="border-radius-lg shadow" style="width: 80px; height: 80px; object-fit: cover;">
                            <div class="ms-3">
                                <h6 class="mb-0">Whey Protein Isolate</h6>
                                <p class="text-sm mb-1">Hỗ trợ phục hồi cơ bắp</p>
                                <span class="text-primary font-weight-bold">750.000đ</span>
                                <a href="member-shop.jsp" class="btn btn-link text-primary p-0 ms-2">
                                    <i class="fas fa-shopping-cart"></i>
                                </a>
                            </div>
                        </div>
                        <div class="d-flex mb-3">
                            <img src="assets/img/products/bcaa.jpg" alt="BCAA" class="border-radius-lg shadow" style="width: 80px; height: 80px; object-fit: cover;">
                            <div class="ms-3">
                                <h6 class="mb-0">BCAA 5000</h6>
                                <p class="text-sm mb-1">Phục hồi và tăng sức bền</p>
                                <span class="text-primary font-weight-bold">450.000đ</span>
                                <a href="member-shop.jsp" class="btn btn-link text-primary p-0 ms-2">
                                    <i class="fas fa-shopping-cart"></i>
                                </a>
                            </div>
                        </div>
                        <div class="d-flex">
                            <img src="assets/img/products/shaker.jpg" alt="Shaker" class="border-radius-lg shadow" style="width: 80px; height: 80px; object-fit: cover;">
                            <div class="ms-3">
                                <h6 class="mb-0">Bình lắc Protein</h6>
                                <p class="text-sm mb-1">Tiện lợi khi tập luyện</p>
                                <span class="text-primary font-weight-bold">150.000đ</span>
                                <a href="member-shop.jsp" class="btn btn-link text-primary p-0 ms-2">
                                    <i class="fas fa-shopping-cart"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <footer class="footer pt-3">
            <div class="container-fluid">
                <div class="row align-items-center justify-content-lg-between">
                    <div class="col-lg-6 mb-lg-0 mb-4">
                        <div class="copyright text-center text-sm text-muted text-lg-start">
                            © <script>document.write(new Date().getFullYear())</script>, CoreFit Gym Management System
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</main>

<!-- Core JS Files -->
  <script src="assets/js/core/popper.min.js"></script>
  <script src="assets/js/core/bootstrap.min.js"></script>
<script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
<script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
<script src="assets/js/plugins/chartjs.min.js"></script>

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
    });
</script>

<script>
    var win = navigator.platform.indexOf('Win') > -1;
    if (win && document.querySelector('#sidenav-scrollbar')) {
        var options = {
            damping: '0.5'
        }
        Scrollbar.init(document.querySelector('#sidenav-scrollbar'), options);
    }
</script>

<!-- Control Center for Soft Dashboard: parallax effects, scripts for the example pages etc -->
<script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html> 
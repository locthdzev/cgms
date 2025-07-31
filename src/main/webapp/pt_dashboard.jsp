<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
    // Kiểm tra xem người dùng đã đăng nhập và có vai trò Personal Trainer không
    if (loggedInUser == null || !"Personal Trainer".equals(loggedInUser.getRole())) {
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
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
    <title>Dashboard Personal Trainer - CGMS</title>
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
<%@ include file="pt_sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Dashboard Personal Trainer" />
        <jsp:param name="parentPage" value="Dashboard" />
        <jsp:param name="parentPageUrl" value="pt_dashboard.jsp" />
        <jsp:param name="currentPage" value="Dashboard" />
    </jsp:include>
    
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-xl-4 col-sm-6 mb-4">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Lịch hẹn hôm nay</p>
                                    <h5 class="font-weight-bolder mb-0">
                                        0
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-primary shadow text-center border-radius-md">
                                    <i class="fas fa-calendar text-lg opacity-10" aria-hidden="true"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-sm-6 mb-4">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Khách hàng của bạn</p>
                                    <h5 class="font-weight-bolder mb-0">
                                        0
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-success shadow text-center border-radius-md">
                                    <i class="fas fa-users text-lg opacity-10" aria-hidden="true"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-sm-6 mb-4">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="text-sm mb-0 text-uppercase font-weight-bold">Trạng thái</p>
                                    <h5 class="font-weight-bolder mb-0">
                                        <span class="text-success">Hoạt động</span>
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-info shadow text-center border-radius-md">
                                    <i class="fas fa-check-circle text-lg opacity-10" aria-hidden="true"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-lg-7">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <div class="d-flex justify-content-between align-items-center">
                            <h6>Lịch làm việc theo tháng</h6>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button" id="monthDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    Tháng 6/2024
                                </button>
                                <ul class="dropdown-menu" aria-labelledby="monthDropdown">
                                    <li><a class="dropdown-item" href="#">Tháng 5/2024</a></li>
                                    <li><a class="dropdown-item" href="#">Tháng 6/2024</a></li>
                                    <li><a class="dropdown-item" href="#">Tháng 7/2024</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-3">
                        <div class="chart-container">
                            <canvas id="workScheduleChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-5">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <h6>Phân bổ khách hàng theo mục tiêu</h6>
                    </div>
                    <div class="card-body p-3">
                        <div class="chart-container" style="height: 250px;">
                            <canvas id="clientGoalsChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-lg-6">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <h6>Lịch làm việc tuần này</h6>
                    </div>
                    <div class="card-body p-3">
                        <div class="chart-container" style="height: 250px;">
                            <canvas id="weeklyScheduleChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <h6>Tiến độ khách hàng</h6>
                    </div>
                    <div class="card-body p-3">
                        <div class="chart-container" style="height: 250px;">
                            <canvas id="clientProgressChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0">Lịch hẹn sắp tới</h6>
                        <a href="pt_schedule.jsp" class="btn btn-sm btn-outline-primary">
                            <i class="fas fa-calendar me-1"></i>Xem tất cả
                        </a>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                    <tr>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Giờ</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Khách hàng</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Dịch vụ</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Trạng thái</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="ps-4">
                                            <p class="text-xs font-weight-bold mb-0">20/06/2024</p>
                                        </td>
                                        <td>
                                            <p class="text-xs font-weight-bold mb-0">09:00 - 10:00</p>
                                        </td>
                                        <td>
                                            <p class="text-xs font-weight-bold mb-0">Nguyễn Văn A</p>
                                        </td>
                                        <td>
                                            <p class="text-xs font-weight-bold mb-0">Tập luyện cá nhân</p>
                                        </td>
                                        <td>
                                            <span class="badge badge-sm bg-gradient-success">Đã xác nhận</span>
                                        </td>
                                        <td class="text-center">
                                            <a href="#" class="btn btn-link text-dark px-3 mb-0">
                                                <i class="fas fa-eye text-dark me-2"></i>Chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ps-4">
                                            <p class="text-xs font-weight-bold mb-0">21/06/2024</p>
                                        </td>
                                        <td>
                                            <p class="text-xs font-weight-bold mb-0">15:30 - 16:30</p>
                                        </td>
                                        <td>
                                            <p class="text-xs font-weight-bold mb-0">Trần Thị B</p>
                                        </td>
                                        <td>
                                            <p class="text-xs font-weight-bold mb-0">Yoga</p>
                                        </td>
                                        <td>
                                            <span class="badge badge-sm bg-gradient-warning">Chờ xác nhận</span>
                                        </td>
                                        <td class="text-center">
                                            <a href="#" class="btn btn-link text-dark px-3 mb-0">
                                                <i class="fas fa-eye text-dark me-2"></i>Chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
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
                            © <script>document.write(new Date().getFullYear())</script> CGMS - Gym Management System
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</main>

<script src="assets/js/core/popper.min.js" type="text/javascript"></script>
<script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
<script src="assets/js/plugins/perfect-scrollbar.min.js" type="text/javascript"></script>
<script src="assets/js/plugins/smooth-scrollbar.min.js" type="text/javascript"></script>
<script src="assets/js/argon-dashboard.min.js?v=2.1.0" type="text/javascript"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
        
        // Biểu đồ lịch làm việc theo tháng
        var workScheduleCtx = document.getElementById('workScheduleChart').getContext('2d');
        var workScheduleChart = new Chart(workScheduleCtx, {
            type: 'bar',
            data: {
                labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4'],
                datasets: [{
                    label: 'Số buổi đã hoàn thành',
                    data: [12, 15, 10, 8],
                    backgroundColor: '#5e72e4',
                    borderRadius: 5
                }, {
                    label: 'Số buổi đã đặt',
                    data: [15, 18, 14, 12],
                    backgroundColor: '#8392ab',
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            drawBorder: false,
                            color: 'rgba(0,0,0,0.1)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        align: 'end'
                    }
                }
            }
        });
        
        // Biểu đồ phân bổ khách hàng theo mục tiêu
        var clientGoalsCtx = document.getElementById('clientGoalsChart').getContext('2d');
        var clientGoalsChart = new Chart(clientGoalsCtx, {
            type: 'doughnut',
            data: {
                labels: ['Giảm cân', 'Tăng cơ', 'Sức khỏe', 'Phục hồi chấn thương'],
                datasets: [{
                    data: [35, 30, 25, 10],
                    backgroundColor: ['#2dce89', '#5e72e4', '#fb6340', '#11cdef'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                },
                cutout: '70%'
            }
        });
        
        // Biểu đồ lịch làm việc tuần này
        var weeklyScheduleCtx = document.getElementById('weeklyScheduleChart').getContext('2d');
        var weeklyScheduleChart = new Chart(weeklyScheduleCtx, {
            type: 'bar',
            data: {
                labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
                datasets: [{
                    label: 'Số giờ làm việc',
                    data: [5, 7, 4, 6, 8, 3, 0],
                    backgroundColor: '#fb6340',
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            drawBorder: false,
                            color: 'rgba(0,0,0,0.1)'
                        },
                        ticks: {
                            callback: function(value) {
                                return value + 'h';
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
        
        // Biểu đồ tiến độ khách hàng
        var clientProgressCtx = document.getElementById('clientProgressChart').getContext('2d');
        var clientProgressChart = new Chart(clientProgressCtx, {
            type: 'line',
            data: {
                labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'],
                datasets: [{
                    label: 'Tiến độ trung bình (%)',
                    data: [30, 45, 60, 70, 85, 95],
                    borderColor: '#2dce89',
                    backgroundColor: 'rgba(45, 206, 137, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        grid: {
                            drawBorder: false,
                            color: 'rgba(0,0,0,0.1)'
                        },
                        ticks: {
                            callback: function(value) {
                                return value + '%';
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    });
</script>
</body>
</html> 
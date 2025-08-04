<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%@page import="Models.Schedule"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
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
    
    // Lấy dữ liệu từ controller
    Integer completedSessionsCount = (Integer) request.getAttribute("completedSessionsCount");
    Integer upcomingSessionsCount = (Integer) request.getAttribute("upcomingSessionsCount");
    Integer totalOrdersCount = (Integer) request.getAttribute("totalOrdersCount");
    
    List<Schedule> upcomingSchedules = (List<Schedule>) request.getAttribute("upcomingSchedules");
    List<Integer> weeklyWorkoutStats = (List<Integer>) request.getAttribute("weeklyWorkoutStats");
    List<Double> monthlySpendingStats = (List<Double>) request.getAttribute("monthlySpendingStats");
    
    // Default values nếu null
    if (completedSessionsCount == null) completedSessionsCount = 0;
    if (upcomingSessionsCount == null) upcomingSessionsCount = 0;
    if (totalOrdersCount == null) totalOrdersCount = 0;
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    
    // Tạo JSON strings cho biểu đồ
    String weeklyWorkoutStatsJson = "[0,0,0,0,0,0,0]";
    String monthlySpendingStatsJson = "[0,0,0,0]";
    
    if (weeklyWorkoutStats != null && !weeklyWorkoutStats.isEmpty()) {
        weeklyWorkoutStatsJson = weeklyWorkoutStats.toString();
    }
    
    if (monthlySpendingStats != null && !monthlySpendingStats.isEmpty()) {
        monthlySpendingStatsJson = monthlySpendingStats.toString();
    }
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
    <title>Member Dashboard - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
    <style>
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
        
        .card-stats {
            transition: all 0.3s ease;
        }
        
        .card-stats:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        
        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            overflow: hidden;
            position: relative;
        }
        
        .chart-container {
            position: relative;
            height: 350px;
            width: 100%;
        }
        
        .upcoming-session {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #5e72e4;
            transition: all 0.3s ease;
        }
        
        .upcoming-session:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        
        .session-time {
            font-weight: 600;
            color: #5e72e4;
            font-size: 0.9rem;
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            line-height: 1;
        }
        
        .stats-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
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
        <jsp:param name="pageTitle" value="Member Dashboard" />
        <jsp:param name="parentPage" value="Dashboard" />
        <jsp:param name="parentPageUrl" value="member-dashboard" />
        <jsp:param name="currentPage" value="Dashboard" />
    </jsp:include>
    
    <div class="container-fluid py-4">
        <!-- Welcome section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card welcome-card">
                    <div class="card-body p-4">
                        <div class="row align-items-center">
                            <div class="col-lg-8">
                                <h3 class="text-white mb-2">Chào mừng trở lại, <%= loggedInUser.getFullName() %>! 🎯</h3>
                                <p class="text-white-75 mb-0">Hãy tiếp tục hành trình rèn luyện sức khỏe của bạn hôm nay</p>
                            </div>
                            <div class="col-lg-4 text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="member-training-schedule" class="btn btn-white btn-sm">
                                        <i class="fas fa-calendar-alt me-2"></i>Lịch tập
                                    </a>
                                    <a href="member-shop" class="btn btn-outline-white btn-sm">
                                        <i class="fas fa-shopping-cart me-2"></i>Cửa hàng
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Stats cards -->
        <div class="row mb-4">
            <div class="col-xl-4 col-sm-6 mb-3">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="stats-label text-primary mb-0">Buổi tập hoàn thành</p>
                                    <h5 class="stats-number text-primary mb-0">
                                        <%= completedSessionsCount %>
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-primary shadow text-center border-radius-md">
                                    <i class="fas fa-dumbbell text-lg opacity-10" aria-hidden="true"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-sm-6 mb-3">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="stats-label text-warning mb-0">Lịch sắp tới</p>
                                    <h5 class="stats-number text-warning mb-0">
                                        <%= upcomingSessionsCount %>
                                    </h5>
                                </div>
                            </div>
                            <div class="col-4 text-end">
                                <div class="icon icon-shape bg-gradient-warning shadow text-center border-radius-md">
                                    <i class="fas fa-calendar-check text-lg opacity-10" aria-hidden="true"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-sm-6 mb-3">
                <div class="card card-stats">
                    <div class="card-body p-3">
                        <div class="row">
                            <div class="col-8">
                                <div class="numbers">
                                    <p class="stats-label text-success mb-0">Đơn hàng đã hoàn tất</p>
                                    <h5 class="stats-number text-success mb-0">
                                        <%= totalOrdersCount %>
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
        </div>
        
        <!-- Charts section -->
        <div class="row mb-4">
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header pb-0 p-3">
                        <h6 class="mb-0">Thống kê hoạt động tập luyện</h6>
                        <p class="text-sm mb-0">Biểu đồ hoạt động 7 ngày gần đây</p>
                    </div>
                    <div class="card-body p-3">
                        <div class="chart-container">
                            <canvas id="workoutChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header pb-0 p-3">
                        <h6 class="mb-0">Thống kê chi tiêu</h6>
                        <p class="text-sm mb-0">Chi tiêu theo tuần trong tháng gần đây</p>
                    </div>
                    <div class="card-body p-3">
                        <div class="chart-container">
                            <canvas id="spendingChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Schedule section -->
        <div class="row">
            <div class="col-12 mb-4">
                <div class="card">
                    <div class="card-header pb-0 p-3">
                        <div class="d-flex justify-content-between">
                            <h6 class="mb-0">Lịch tập sắp tới</h6>
                            <a href="member-training-schedule" class="btn btn-link text-primary text-sm p-0">Xem tất cả</a>
                        </div>
                    </div>
                    <div class="card-body p-3">
                        <% if (upcomingSchedules != null && !upcomingSchedules.isEmpty()) { %>
                            <% for (Schedule schedule : upcomingSchedules) { 
                                String statusClass = "";
                                String statusText = "";
                                if ("Confirmed".equals(schedule.getStatus())) {
                                    statusClass = "bg-gradient-success";
                                    statusText = "Đã xác nhận";
                                } else if ("Pending".equals(schedule.getStatus())) {
                                    statusClass = "bg-gradient-warning";
                                    statusText = "Chờ xác nhận";
                                }
                                
                                String dateText = "";
                                LocalDate today = LocalDate.now();
                                if (schedule.getScheduleDate().isEqual(today)) {
                                    dateText = "Hôm nay";
                                } else if (schedule.getScheduleDate().isEqual(today.plusDays(1))) {
                                    dateText = "Ngày mai";
                                } else {
                                    dateText = schedule.getScheduleDate().format(dateFormatter);
                                }
                            %>
                            <div class="upcoming-session">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="flex-grow-1">
                                        <span class="session-time"><%= dateText %> • <%= schedule.getScheduleTime().format(timeFormatter) %></span>
                                        <h6 class="mb-1 mt-1">PT <%= schedule.getTrainer().getFullName() %></h6>
                                        <p class="text-sm text-muted mb-0">
                                            <i class="fas fa-clock me-1"></i><%= schedule.getDurationHours() %> giờ
                                        </p>
                                    </div>
                                    <span class="badge <%= statusClass %>"><%= statusText %></span>
                                </div>
                            </div>
                            <% } %>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-calendar-times text-muted mb-3" style="font-size: 3rem;"></i>
                                <h6 class="text-muted mb-2">Chưa có lịch tập nào</h6>
                                <p class="text-sm text-muted mb-3">Hãy đặt lịch tập với PT để bắt đầu</p>
                                <a href="member-training-schedule" class="btn btn-primary btn-sm">Đặt lịch ngay</a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <footer class="footer pt-3">
            <div class="container-fluid">
                <div class="row align-items-center justify-content-lg-between">
                    <div class="col-lg-6 mb-lg-0 mb-4">
                        <div class="copyright text-center text-sm text-muted text-lg-start">
                            © <script>document.write(new Date().getFullYear())</script>, CGMS - Gym Management System
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</main>

<script src="assets/js/core/popper.min.js"></script>
<script src="assets/js/core/bootstrap.min.js"></script>
<script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
<script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
<script src="assets/js/plugins/chartjs.min.js"></script>
<script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

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
        
        // Lấy dữ liệu từ server
        var workoutData = <%= weeklyWorkoutStatsJson %>;
        var spendingData = <%= monthlySpendingStatsJson %>;
        
        console.log('Workout Data:', workoutData);
        console.log('Spending Data:', spendingData);
        
        // Biểu đồ hoạt động tập luyện
        var workoutCtx = document.getElementById('workoutChart').getContext('2d');
        var workoutChart = new Chart(workoutCtx, {
            type: 'line',
            data: {
                labels: ['6 ngày trước', '5 ngày trước', '4 ngày trước', '3 ngày trước', '2 ngày trước', 'Hôm qua', 'Hôm nay'],
                datasets: [{
                    label: 'Buổi tập',
                    data: workoutData,
                    borderColor: '#5e72e4',
                    backgroundColor: 'rgba(94, 114, 228, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#5e72e4',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: Math.max(...workoutData) + 1,
                        grid: {
                            drawBorder: false,
                            color: 'rgba(0,0,0,0.05)'
                        },
                        ticks: {
                            stepSize: 1,
                            color: '#8392ab'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#8392ab'
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });
        
        // Biểu đồ chi tiêu
        var spendingCtx = document.getElementById('spendingChart').getContext('2d');
        var spendingChart = new Chart(spendingCtx, {
            type: 'bar',
            data: {
                labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4'],
                datasets: [{
                    label: 'Chi tiêu (VNĐ)',
                    data: spendingData,
                    backgroundColor: [
                        'rgba(45, 206, 137, 0.8)',
                        'rgba(255, 159, 64, 0.8)',
                        'rgba(94, 114, 228, 0.8)',
                        'rgba(245, 87, 108, 0.8)'
                    ],
                    borderColor: [
                        '#2dce89',
                        '#ff9f40',
                        '#5e72e4',
                        '#f5576c'
                    ],
                    borderWidth: 2,
                    borderRadius: 8,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            drawBorder: false,
                            color: 'rgba(0,0,0,0.05)'
                        },
                        ticks: {
                            color: '#8392ab',
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value) + 'đ';
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#8392ab'
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });
    });
</script>
</body>
</html>
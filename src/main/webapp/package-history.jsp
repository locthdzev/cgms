<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%@page import="Models.MemberPackage"%>
<%@page import="Models.MemberPurchaseHistory"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
    // Lấy danh sách gói tập của thành viên
    List<MemberPackage> allMemberPackages = (List<MemberPackage>) request.getAttribute("allMemberPackages");
    
    // Định dạng ngày tháng
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
    // Tạo map để lưu trạng thái hiển thị
    Map<String, String> statusDisplay = new HashMap<>();
    statusDisplay.put("ACTIVE", "Đang hoạt động");
    statusDisplay.put("INACTIVE", "Không hoạt động");
    statusDisplay.put("CANCELLED", "Đã hủy");
    statusDisplay.put("PENDING", "Đang chờ");
    statusDisplay.put("COMPLETED", "Hoàn thành");
    statusDisplay.put("EXPIRED", "Hết hạn");
    
    // Tạo map để lưu màu sắc trạng thái
    Map<String, String> statusColor = new HashMap<>();
    statusColor.put("ACTIVE", "success");
    statusColor.put("INACTIVE", "secondary");
    statusColor.put("CANCELLED", "danger");
    statusColor.put("PENDING", "warning");
    statusColor.put("COMPLETED", "info");
    statusColor.put("EXPIRED", "dark");
    
    // Tạo map để lưu icon trạng thái
    Map<String, String> statusIcon = new HashMap<>();
    statusIcon.put("ACTIVE", "fa-check-circle");
    statusIcon.put("INACTIVE", "fa-pause-circle");
    statusIcon.put("CANCELLED", "fa-times-circle");
    statusIcon.put("PENDING", "fa-clock");
    statusIcon.put("COMPLETED", "fa-check");
    statusIcon.put("EXPIRED", "fa-ban");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lịch sử gói tập - CGMS</title>
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
    
    <style>
        .timeline {
            position: relative;
            padding-left: 30px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: linear-gradient(180deg, #5e72e4 0%, #825ee4 100%);
        }

        .timeline-item {
            position: relative;
            margin-bottom: 30px;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -22px;
            top: 8px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #5e72e4;
            border: 3px solid #ffffff;
            box-shadow: 0 0 0 3px rgba(94, 114, 228, 0.2);
        }

        .timeline-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 20px 27px 0 rgba(0, 0, 0, 0.05);
            border: 1px solid #f1f2f3;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .timeline-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 40px 0 rgba(0, 0, 0, 0.1);
        }

        .timeline-card-header {
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        .timeline-card-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(30px, -30px);
        }

        .timeline-card-body {
            padding: 20px;
        }

        .timeline-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .timeline-info-item {
            text-align: center;
            flex: 1;
        }

        .timeline-info-label {
            display: block;
            font-size: 12px;
            color: #8898aa;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .timeline-info-value {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #525f7f;
        }

        .timeline-empty {
            text-align: center;
            padding: 60px 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border: 2px dashed #e3e6f0;
        }

        .timeline-empty i {
            font-size: 48px;
            color: #d1d3e2;
            margin-bottom: 20px;
        }

        .membership-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card-stats {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }

        .card-stats::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 150px;
            height: 150px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(50px, -50px);
        }

        .card-stats .icon {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 24px;
            opacity: 0.7;
        }

        .card-stats h3 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .card-stats p {
            margin: 5px 0 0 0;
            opacity: 0.9;
            font-size: 14px;
        }
    </style>
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
    <!-- Sidebar -->
    <%@ include file="member_sidebar.jsp" %>
    
    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Lịch sử gói tập" />
            <jsp:param name="parentPage" value="Trang chủ" />
            <jsp:param name="parentPageUrl" value="member-dashboard" />
            <jsp:param name="currentPage" value="Lịch sử gói tập" />
        </jsp:include>
        
        <div class="container-fluid py-4">
            <!-- Stats Cards -->
            <div class="row">
                <% 
                int totalPackages = allMemberPackages != null ? allMemberPackages.size() : 0;
                int activePackages = 0;
                int expiredPackages = 0;
                
                if (allMemberPackages != null) {
                    for (MemberPackage pkg : allMemberPackages) {
                        if ("ACTIVE".equals(pkg.getStatus())) {
                            activePackages++;
                        } else if ("EXPIRED".equals(pkg.getStatus())) {
                            expiredPackages++;
                        }
                    }
                }
                %>
                
                <div class="col-xl-4 col-sm-6 mb-xl-0 mb-4">
                    <div class="card-stats">
                        <i class="fas fa-list icon"></i>
                        <h3><%= totalPackages %></h3>
                        <p>Tổng số gói tập đã đăng ký</p>
                    </div>
                </div>
                
                <div class="col-xl-4 col-sm-6 mb-xl-0 mb-4">
                    <div class="card-stats">
                        <i class="fas fa-check-circle icon"></i>
                        <h3><%= activePackages %></h3>
                        <p>Gói tập đang hoạt động</p>
                    </div>
                </div>
                
                <div class="col-xl-4 col-sm-6 mb-xl-0 mb-4">
                    <div class="card-stats">
                        <i class="fas fa-history icon"></i>
                        <h3><%= expiredPackages %></h3>
                        <p>Gói tập đã hết hạn</p>
                    </div>
                </div>
            </div>
            
            <!-- Package History Timeline -->
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="card-header pb-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6>Lịch sử gói tập của bạn</h6>
                                <a href="<%= request.getContextPath() %>/all-packages" class="btn btn-sm btn-primary">
                                    <i class="fas fa-plus me-1"></i>Đăng ký thêm
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <% if (allMemberPackages != null && !allMemberPackages.isEmpty()) { %>
                            <div class="timeline">
                                <% for (int i = 0; i < allMemberPackages.size(); i++) { 
                                    MemberPackage pkg = allMemberPackages.get(i);
                                    String status = pkg.getStatus();
                                    String color = statusColor.getOrDefault(status, "secondary");
                                    String icon = statusIcon.getOrDefault(status, "fa-circle");
                                %>
                                <div class="timeline-item">
                                    <div class="timeline-card">
                                        <div class="timeline-card-header bg-gradient-<%= color %>">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <h6 class="text-white mb-0">
                                                    <%= pkg.getPackageField() != null ? pkg.getPackageField().getName() : "Gói tập" %>
                                                </h6>
                                                <span class="membership-badge bg-white text-<%= color %>">
                                                    <i class="fas <%= icon %>"></i>
                                                    <%= statusDisplay.getOrDefault(status, status) %>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="timeline-card-body">
                                            <div class="timeline-info">
                                                <div class="timeline-info-item">
                                                    <span class="timeline-info-label">Ngày bắt đầu</span>
                                                    <span class="timeline-info-value">
                                                        <%= pkg.getStartDate() != null ? pkg.getStartDate().format(dateFormatter) : "N/A" %>
                                                    </span>
                                                </div>
                                                <div class="timeline-info-item">
                                                    <span class="timeline-info-label">Ngày kết thúc</span>
                                                    <span class="timeline-info-value">
                                                        <%= pkg.getEndDate() != null ? pkg.getEndDate().format(dateFormatter) : "N/A" %>
                                                    </span>
                                                </div>
                                                <div class="timeline-info-item">
                                                    <span class="timeline-info-label">Thời hạn</span>
                                                    <span class="timeline-info-value">
                                                        <%= pkg.getPackageField() != null ? pkg.getPackageField().getDuration() + " tháng" : "N/A" %>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="timeline-info">
                                                <div class="timeline-info-item">
                                                    <span class="timeline-info-label">Giá gói</span>
                                                    <span class="timeline-info-value text-primary">
                                                        <%= pkg.getPackageField() != null ? String.format("%,.0f", pkg.getPackageField().getPrice()) + " VNĐ" : "N/A" %>
                                                    </span>
                                                </div>
                                                <div class="timeline-info-item">
                                                    <span class="timeline-info-label">Tổng thanh toán</span>
                                                    <span class="timeline-info-value text-success">
                                                        <%= String.format("%,.0f", pkg.getTotalPrice()) %> VNĐ
                                                    </span>
                                                </div>
                                                <div class="timeline-info-item">
                                                    <span class="timeline-info-label">Mã gói</span>
                                                    <span class="timeline-info-value">#<%= pkg.getId() %></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                            <% } else { %>
                            <div class="timeline-empty">
                                <i class="fas fa-inbox"></i>
                                <h5 class="text-muted">Chưa có gói tập nào</h5>
                                <p class="text-sm mb-3">Bạn chưa đăng ký gói tập nào. Hãy chọn gói tập phù hợp để bắt đầu hành trình rèn luyện sức khỏe!</p>
                                <a href="<%= request.getContextPath() %>/all-packages" class="btn btn-primary">
                                    <i class="fas fa-plus me-1"></i>Đăng ký gói tập ngay
                                </a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer -->
            <footer class="footer pt-3">
                <div class="container-fluid">
                    <div class="row align-items-center justify-content-lg-between">
                        <div class="col-lg-6 mb-lg-0 mb-4">
                            <div class="copyright text-center text-sm text-muted text-lg-start">
                                © <script>
                                    document.write(new Date().getFullYear())
                                </script> CGMS - Gym Management System
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
    
    <script>
        var win = navigator.platform.indexOf('Win') > -1;
        if (win && document.querySelector('#sidenav-scrollbar')) {
            var options = {
                damping: '0.5'
            }
            Scrollbar.init(document.querySelector('#sidenav-scrollbar'), options);
        }
    </script>

    <!-- Github buttons -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    <!-- Control Center for Soft Dashboard: parallax effects, scripts for the example pages etc -->
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html>
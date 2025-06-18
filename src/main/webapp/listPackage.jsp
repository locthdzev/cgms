<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.Package" %>
<%@ page import="java.util.List" %>
<%
    List<Package> packageList = (List<Package>) request.getAttribute("packages");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png"/>
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png"/>
    <title>CoreFit Gym Management System</title>
        <!-- Fonts and icons -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet"/>
        <!-- Nucleo Icons -->
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet"/>
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet"/>
        <!-- Font Awesome Icons -->
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <!-- CSS Files -->
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet"/>
    <style>
        .package-card {
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .package-card .card-body {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .package-card .card-footer {
            margin-top: auto;
        }

        .package-image {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }

        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 2;
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
                <jsp:param name="pageTitle" value="Gói tập Gym" />
                <jsp:param name="parentPage" value="Dashboard" />
                <jsp:param name="parentPageUrl" value="dashboard.jsp" />
                <jsp:param name="currentPage" value="Gói tập Gym" />
            </jsp:include>
            
            <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col-12 d-flex justify-content-between align-items-center">
                <h4 class="text-white mb-0">Danh sách gói tập</h4>
                <a href="addPackage" class="btn btn-primary">
                                        <i class="fas fa-plus me-2"></i>Thêm gói tập mới
                                    </a>
                                </div>
                            </div>
                            
                                <div class="row">
            <% if (packageList != null && !packageList.isEmpty()) {
                for (Package pkg : packageList) { %>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card package-card">
                                                    <% if ("Active".equals(pkg.getStatus())) { %>
                    <span class="badge bg-gradient-success status-badge">Hoạt động</span>
                                                    <% } else { %>
                    <span class="badge bg-gradient-secondary status-badge">Không hoạt động</span>
                                                    <% } %>
                    <img src="assets/svg/rain-7750488.svg"
                         class="card-img-top package-image" alt="<%= pkg.getName() %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= pkg.getName() %></h5>
                        <p class="card-text text-sm mb-2"><%= pkg.getDescription() %></p>
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <span class="text-dark font-weight-bold"><%= String.format("%,.0f", pkg.getPrice()) %> VNĐ</span>
                            <span class="badge bg-gradient-info"><%= pkg.getDuration() %> tháng</span>
                        </div>
                    </div>
                    <div class="card-footer bg-white d-flex justify-content-between">
                        <a href="editPackage?id=<%= pkg.getId() %>" class="btn btn-sm btn-outline-primary">
                            <i class="fas fa-edit me-1"></i>Sửa
                        </a>
                        <a href="updatePackageStatus?id=<%= pkg.getId() %>&status=<%= "Active".equals(pkg.getStatus()) ? "Inactive" : "Active" %>"
                           class="btn btn-sm btn-outline-<%= "Active".equals(pkg.getStatus()) ? "warning" : "success" %>">
                            <i class="fas fa-<%= "Active".equals(pkg.getStatus()) ? "ban" : "check" %> me-1"></i>
                            <%= "Active".equals(pkg.getStatus()) ? "Vô hiệu hóa" : "Kích hoạt" %>
                        </a>
                    </div>
                </div>
            </div>
            <% }
            } else { %>
            <div class="col-12">
                <div class="card">
                    <div class="card-body text-center py-5">
                        <h5>Không có gói tập nào.</h5>
                        <p>Hãy thêm gói tập mới để bắt đầu.</p>
                        <a href="addPackage" class="btn btn-primary mt-3">
                            <i class="fas fa-plus me-2"></i>Thêm gói tập mới
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</main>

<!--   Core JS Files   -->
<script src="./assets/js/core/popper.min.js"></script>
<script src="./assets/js/core/bootstrap.min.js"></script>
<script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
<script src="./assets/js/plugins/smooth-scrollbar.min.js"></script>
        <script>
    var win = navigator.platform.indexOf('Win') > -1;
    if (win && document.querySelector('#sidenav-scrollbar')) {
        var options = {
            damping: '0.5'
        }
        Scrollbar.init(document.querySelector('#sidenav-scrollbar'), options);
            }
        </script>
    </body>
</html>






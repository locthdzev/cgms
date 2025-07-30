<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.Package"%>
<%@page import="Models.MemberPackage"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="Models.User"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.function.BiPredicate"%>
<%
    // Đặt tiêu đề trang cho navbar
    request.setAttribute("pageTitle", "Gói Tập");
    
    // Lấy thông tin gói tập hiện tại của thành viên
    List<MemberPackage> memberPackages = (List<MemberPackage>) request.getAttribute("memberPackages");
    List<MemberPackage> activeOrPendingPackages = (List<MemberPackage>) request.getAttribute("activeOrPendingPackages");
    boolean hasActivePackage = (Boolean) request.getAttribute("hasActivePackage");
    
    // Định nghĩa các biến lambda thay vì hàm
    BiPredicate<Integer, List<MemberPackage>> isPackageRegistered = (packageId, packages) -> {
        if (packages == null) return false;
        for (MemberPackage mp : packages) {
            if (mp.getPackageField().getId() == packageId && 
                ("ACTIVE".equals(mp.getStatus()) || "PENDING".equals(mp.getStatus()))) {
                return true;
            }
        }
        return false;
    };
    
    BiPredicate<Package, List<MemberPackage>> isUpgrade = (pkg, activePackages) -> {
        if (activePackages == null || activePackages.isEmpty()) return false;
        
        for (MemberPackage mp : activePackages) {
            if ("ACTIVE".equals(mp.getStatus())) {
                // Kiểm tra nếu gói mới có giá cao hơn hoặc thời hạn dài hơn
                if (pkg.getPrice().compareTo(mp.getPackageField().getPrice()) > 0 || 
                    pkg.getDuration() > mp.getPackageField().getDuration()) {
                    return true;
                }
            }
        }
        return false;
    };
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>CORE-FIT GYM</title>
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png">
    <!-- Fonts and icons -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <!-- Font Awesome Icons -->
    <link href="assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <!-- CSS Files -->
    <link id="pagestyle" href="assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
    <style>
        .package-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .package-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        .badge-custom {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 10;
        }
    </style>
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    <!-- Sidebar -->
    <jsp:include page="member_sidebar.jsp" />
    
    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Gói Tập" />
            <jsp:param name="parentPage" value="Dashboard" />
            <jsp:param name="parentPageUrl" value="member-dashboard" />
            <jsp:param name="currentPage" value="Gói Tập" />
        </jsp:include>
        
        <div class="container-fluid py-4">
            <%-- Hiển thị thông báo thành công hoặc lỗi --%>
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= request.getAttribute("successMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= request.getAttribute("errorMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="card-header pb-0">
                            <h6>Danh sách gói tập</h6>
                            <p class="text-sm mb-0">
                                Khám phá các gói tập đa dạng của phòng gym chúng tôi để tìm gói phù hợp nhất với mục tiêu của bạn.
                            </p>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="row p-3">
                                <% 
                                    List<Package> packageList = (List<Package>) request.getAttribute("packages");
                                    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                    
                                    if (packageList != null && !packageList.isEmpty()) {
                                        for (Package pkg : packageList) {
                                %>
                                <div class="col-md-4 mb-4">
                                    <div class="card package-card h-100">
                                        <% if ("Premium".equals(pkg.getName()) || pkg.getName().contains("Premium")) { %>
                                            <span class="badge bg-gradient-warning badge-custom">Premium</span>
                                        <% } %>
                                        <div class="card-header text-center p-3">
                                            <h5 class="mb-0"><%= pkg.getName() %></h5>
                                            <h3 class="font-weight-bolder mt-3 mb-0 text-primary">
                                                <%= currencyFormat.format(pkg.getPrice()) %>
                                            </h3>
                                            <span class="text-sm text-secondary">/ <%= pkg.getDuration() %> ngày</span>
                                        </div>
                                        <div class="card-body pt-0">
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item border-0 ps-0">
                                                    <i class="fas fa-check text-success me-2"></i>
                                                    <span class="text-sm">Thời hạn: <%= pkg.getDuration() %> ngày</span>
                                                </li>
                                                <% if (pkg.getSessions() != null) { %>
                                                <li class="list-group-item border-0 ps-0">
                                                    <i class="fas fa-check text-success me-2"></i>
                                                    <span class="text-sm">Số buổi tập: <%= pkg.getSessions() %> buổi</span>
                                                </li>
                                                <% } %>
                                            </ul>
                                            <div class="d-flex justify-content-between mt-4">
                                                <button type="button" class="btn btn-sm btn-outline-primary" 
                                                        data-bs-toggle="modal" data-bs-target="#detailModal<%= pkg.getId() %>">
                                                    Xem chi tiết
                                                </button>
                                                
                                                <% if (isPackageRegistered.test(pkg.getId(), activeOrPendingPackages)) { %>
                                                    <button type="button" class="btn btn-sm btn-secondary" disabled>
                                                        Đang đăng ký
                                                    </button>
                                                <% } else if (isUpgrade.test(pkg, activeOrPendingPackages)) { %>
                                                    <button type="button" class="btn btn-sm btn-info" 
                                                            data-bs-toggle="modal" data-bs-target="#registerModal<%= pkg.getId() %>">
                                                        Nâng cấp
                                                    </button>
                                                <% } else { %>
                                                    <button type="button" class="btn btn-sm btn-primary" 
                                                            data-bs-toggle="modal" data-bs-target="#registerModal<%= pkg.getId() %>">
                                                        Đăng ký
                                                    </button>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Modal Chi tiết -->
                                <div class="modal fade" id="detailModal<%= pkg.getId() %>" tabindex="-1" role="dialog" aria-labelledby="detailModalLabel<%= pkg.getId() %>" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="detailModalLabel<%= pkg.getId() %>">Chi tiết gói tập: <%= pkg.getName() %></h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="text-center mb-4">
                                                    <h3 class="font-weight-bolder text-primary"><%= currencyFormat.format(pkg.getPrice()) %></h3>
                                                    <span class="text-sm text-secondary">/ <%= pkg.getDuration() %> ngày</span>
                                                </div>
                                                <div class="p-3">
                                                    <h6>Thông tin gói tập:</h6>
                                                    <ul class="list-group list-group-flush">
                                                        <li class="list-group-item border-0 ps-0">
                                                            <strong>Tên gói:</strong> <%= pkg.getName() %>
                                                        </li>
                                                        <li class="list-group-item border-0 ps-0">
                                                            <strong>Giá:</strong> <%= currencyFormat.format(pkg.getPrice()) %>
                                                        </li>
                                                        <li class="list-group-item border-0 ps-0">
                                                            <strong>Thời hạn:</strong> <%= pkg.getDuration() %> ngày
                                                        </li>
                                                        <% if (pkg.getSessions() != null) { %>
                                                        <li class="list-group-item border-0 ps-0">
                                                            <strong>Số buổi tập:</strong> <%= pkg.getSessions() %> buổi
                                                        </li>
                                                        <% } %>
                                                    </ul>
                                                    <h6 class="mt-3">Mô tả:</h6>
                                                    <p class="text-sm"><%= pkg.getDescription() != null ? pkg.getDescription() : "Không có mô tả" %></p>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerModal<%= pkg.getId() %>" data-bs-dismiss="modal">
                                                    Đăng ký ngay
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Modal Đăng ký -->
                                <div class="modal fade" id="registerModal<%= pkg.getId() %>" tabindex="-1" role="dialog" aria-labelledby="registerModalLabel<%= pkg.getId() %>" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="registerModalLabel<%= pkg.getId() %>">
                                                    <% if (isUpgrade.test(pkg, activeOrPendingPackages)) { %>
                                                        Nâng cấp lên gói tập: <%= pkg.getName() %>
                                                    <% } else { %>
                                                        Đăng ký gói tập: <%= pkg.getName() %>
                                                    <% } %>
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <form action="member-packages-controller" method="post">
                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="register">
                                                    <input type="hidden" name="packageId" value="<%= pkg.getId() %>">
                                                    <% if (isUpgrade.test(pkg, activeOrPendingPackages)) { %>
                                                    <input type="hidden" name="isUpgrade" value="true">
                                                    <% } %>
                                                    
                                                    <div class="text-center mb-4">
                                                        <h3 class="font-weight-bolder text-primary"><%= currencyFormat.format(pkg.getPrice()) %></h3>
                                                        <span class="text-sm text-secondary">/ <%= pkg.getDuration() %> ngày</span>
                                                    </div>
                                                    
                                                    <div class="p-3">
                                                        <% if (isUpgrade.test(pkg, activeOrPendingPackages)) { %>
                                                            <div class="alert alert-info" role="alert">
                                                                <i class="fas fa-info-circle me-2"></i> Bạn đang nâng cấp lên gói tập cao cấp hơn.
                                                            </div>
                                                            <div class="alert alert-warning" role="alert">
                                                                <i class="fas fa-exclamation-triangle me-2"></i> <strong>Lưu ý:</strong> Gói tập hiện tại của bạn sẽ bị vô hiệu hóa khi bạn nâng cấp lên gói tập mới này.
                                                            </div>
                                                        <% } %>
                                                        
                                                        <p>Bạn đang <%= isUpgrade.test(pkg, activeOrPendingPackages) ? "nâng cấp lên" : "đăng ký" %> gói tập <strong><%= pkg.getName() %></strong>.</p>
                                                        <p>Gói tập này có thời hạn <strong><%= pkg.getDuration() %> ngày</strong>
                                                        <% if (pkg.getSessions() != null) { %>
                                                            và <strong><%= pkg.getSessions() %> buổi tập</strong>
                                                        <% } %>.</p>
                                                        <p>Giá gói tập: <strong><%= currencyFormat.format(pkg.getPrice()) %></strong></p>
                                                        
                                                        <div class="form-check form-switch mt-3">
                                                            <input class="form-check-input" type="checkbox" id="confirmCheck<%= pkg.getId() %>" required>
                                                            <label class="form-check-label" for="confirmCheck<%= pkg.getId() %>">
                                                                Tôi đồng ý với các điều khoản và điều kiện
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-primary">
                                                        <%= isUpgrade.test(pkg, activeOrPendingPackages) ? "Xác nhận nâng cấp" : "Xác nhận đăng ký" %>
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <% 
                                        }
                                    } else {
                                %>
                                <div class="col-12">
                                    <div class="alert alert-info text-center" role="alert">
                                        Hiện tại không có gói tập nào khả dụng.
                                    </div>
                                </div>
                                <% } %>
                            </div>
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
                                </script> CGMS
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </main>

    <!--   Core JS Files   -->
    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
    
    <!-- Control Center for Soft Dashboard: parallax effects, scripts for the example pages etc -->
    <script src="assets/js/argon-dashboard.min.js?v=2.0.4"></script>
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
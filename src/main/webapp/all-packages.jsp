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
    <title>Gói Tập - CGMS</title>
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
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        }
        
        .package-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .package-card.premium {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .package-card.premium .text-primary {
            color: white !important;
        }
        
        .package-card.premium .text-secondary {
            color: rgba(255,255,255,0.8) !important;
        }
        
        .badge-custom {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 10;
            padding: 8px 12px;
            border-radius: 25px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .price-highlight {
            font-size: 2.2rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .feature-list {
            list-style: none;
            padding: 0;
        }
        
        .feature-list li {
            padding: 10px 0;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
        }
        
        .feature-list li:last-child {
            border-bottom: none;
        }
        
        .feature-icon {
            width: 35px;
            height: 35px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-size: 14px;
        }
        
        .btn-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .modal-header-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .modal-header-gradient .btn-close {
            filter: invert(1);
        }
        
        .terms-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            border-bottom: 1px dotted #667eea;
            transition: all 0.3s ease;
        }
        
        .terms-link:hover {
            color: #764ba2;
            border-bottom-color: #764ba2;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 30px;
            border-radius: 15px;
            color: white;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .alert-modern {
            border: none;
            border-radius: 12px;
            border-left: 4px solid;
            padding: 15px 20px;
        }
        
        .form-check-input:checked {
            background-color: #667eea;
            border-color: #667eea;
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
                <div class="alert alert-success alert-dismissible fade show alert-modern" role="alert" style="border-left-color: #28a745;">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= request.getAttribute("successMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show alert-modern" role="alert" style="border-left-color: #dc3545;">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= request.getAttribute("errorMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <!-- Page Header -->
            <div class="page-header">
                <h2 class="mb-2"><i class="fas fa-dumbbell me-2"></i>Chọn Gói Tập Phù Hợp</h2>
                <p class="mb-0 opacity-8">Khám phá các gói tập đa dạng để tìm gói phù hợp nhất với mục tiêu rèn luyện của bạn</p>
            </div>
            
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="row p-4">
                                <% 
                                    List<Package> packageList = (List<Package>) request.getAttribute("packages");
                                    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                    
                                    if (packageList != null && !packageList.isEmpty()) {
                                        for (int i = 0; i < packageList.size(); i++) {
                                            Package pkg = packageList.get(i);
                                            String cardClass = "";
                                            String badgeText = "";
                                            
                                            if (pkg.getName().toLowerCase().contains("premium") || 
                                                pkg.getName().toLowerCase().contains("vip")) {
                                                cardClass = "premium";
                                                badgeText = "Phổ biến";
                                            }
                                %>
                                <div class="col-lg-4 col-md-6 mb-4">
                                    <div class="card package-card <%= cardClass %> h-100 position-relative">
                                        <% if (!badgeText.isEmpty()) { %>
                                            <span class="badge bg-warning badge-custom"><%= badgeText %></span>
                                        <% } %>
                                        
                                        <div class="card-header text-center p-4 border-0">
                                            <div class="mb-3">
                                                <i class="fas fa-dumbbell fa-2x opacity-8"></i>
                                            </div>
                                            <h5 class="mb-3 font-weight-bold"><%= pkg.getName() %></h5>
                                            <div class="price-highlight mb-2">
                                                <%= currencyFormat.format(pkg.getPrice()).replaceAll("[^\\d,.]", "") %>
                                            </div>
                                            <span class="text-sm">cho <%= pkg.getDuration() %> ngày</span>
                                        </div>
                                        
                                        <div class="card-body pt-0">
                                            <ul class="feature-list mb-4">
                                                <li>
                                                    <div class="feature-icon">
                                                        <i class="fas fa-calendar-alt"></i>
                                                    </div>
                                                    <span>Thời hạn: <strong><%= pkg.getDuration() %> ngày</strong></span>
                                                </li>
                                                <% if (pkg.getSessions() != null) { %>
                                                <li>
                                                    <div class="feature-icon">
                                                        <i class="fas fa-fire"></i>
                                                    </div>
                                                    <span>Số buổi: <strong><%= pkg.getSessions() %> buổi</strong></span>
                                                </li>
                                                <% } %>
                                                <li>
                                                    <div class="feature-icon">
                                                        <i class="fas fa-check-circle"></i>
                                                    </div>
                                                    <span>Trạng thái: <strong><%= pkg.getStatus() %></strong></span>
                                                </li>
                                            </ul>
                                            
                                            <div class="d-grid gap-2">
                                                <% if (isPackageRegistered.test(pkg.getId(), activeOrPendingPackages)) { %>
                                                    <button type="button" class="btn btn-secondary" disabled>
                                                        <i class="fas fa-check me-2"></i>Đã đăng ký
                                                    </button>
                                                <% } else if (isUpgrade.test(pkg, activeOrPendingPackages)) { %>
                                                    <button type="button" class="btn btn-gradient" 
                                                            data-bs-toggle="modal" data-bs-target="#registerModal<%= pkg.getId() %>">
                                                        <i class="fas fa-arrow-up me-2"></i>Nâng cấp ngay
                                                    </button>
                                                <% } else { %>
                                                    <button type="button" class="btn btn-gradient" 
                                                            data-bs-toggle="modal" data-bs-target="#registerModal<%= pkg.getId() %>">
                                                        <i class="fas fa-plus me-2"></i>Đăng ký ngay
                                                    </button>
                                                <% } %>
                                                
                                                <button type="button" class="btn btn-outline-primary btn-sm" 
                                                        data-bs-toggle="modal" data-bs-target="#detailModal<%= pkg.getId() %>">
                                                    <i class="fas fa-info-circle me-2"></i>Xem chi tiết
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Modal Chi tiết -->
                                <div class="modal fade" id="detailModal<%= pkg.getId() %>" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header modal-header-gradient">
                                                <h5 class="modal-title">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    Chi tiết gói tập: <%= pkg.getName() %>
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body p-4">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="text-center mb-4">
                                                            <div class="price-highlight">
                                                                <%= currencyFormat.format(pkg.getPrice()) %>
                                                            </div>
                                                            <span class="text-muted">/ <%= pkg.getDuration() %> ngày</span>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <h6 class="text-primary mb-3">Thông tin chi tiết</h6>
                                                        <ul class="list-unstyled">
                                                            <li class="mb-2">
                                                                <i class="fas fa-tag text-success me-2"></i>
                                                                <strong>Tên gói:</strong> <%= pkg.getName() %>
                                                            </li>
                                                            <li class="mb-2">
                                                                <i class="fas fa-calendar text-primary me-2"></i>
                                                                <strong>Thời hạn:</strong> <%= pkg.getDuration() %> ngày
                                                            </li>
                                                            <% if (pkg.getSessions() != null) { %>
                                                            <li class="mb-2">
                                                                <i class="fas fa-fire text-warning me-2"></i>
                                                                <strong>Số buổi tập:</strong> <%= pkg.getSessions() %> buổi
                                                            </li>
                                                            <% } %>
                                                            <li class="mb-2">
                                                                <i class="fas fa-check-circle text-success me-2"></i>
                                                                <strong>Trạng thái:</strong> <%= pkg.getStatus() %>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                
                                                <hr class="my-4">
                                                
                                                <h6 class="text-primary mb-3">Mô tả gói tập</h6>
                                                <p class="text-muted">
                                                    <%= pkg.getDescription() != null ? pkg.getDescription() : "Gói tập này cung cấp đầy đủ các dịch vụ cơ bản để bạn có thể rèn luyện sức khỏe một cách hiệu quả và khoa học." %>
                                                </p>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                <% if (!isPackageRegistered.test(pkg.getId(), activeOrPendingPackages)) { %>
                                                <button type="button" class="btn btn-gradient" data-bs-toggle="modal" data-bs-target="#registerModal<%= pkg.getId() %>" data-bs-dismiss="modal">
                                                    <i class="fas fa-plus me-2"></i>Đăng ký ngay
                                                </button>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Modal Đăng ký -->
                                <div class="modal fade" id="registerModal<%= pkg.getId() %>" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header modal-header-gradient">
                                                <h5 class="modal-title">
                                                    <i class="fas fa-user-plus me-2"></i>
                                                    <%= isUpgrade.test(pkg, activeOrPendingPackages) ? "Nâng cấp lên gói: " : "Đăng ký gói: " %><%= pkg.getName() %>
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="member-packages-controller" method="post">
                                                <div class="modal-body p-4">
                                                    <input type="hidden" name="action" value="register">
                                                    <input type="hidden" name="packageId" value="<%= pkg.getId() %>">
                                                    <% if (isUpgrade.test(pkg, activeOrPendingPackages)) { %>
                                                    <input type="hidden" name="isUpgrade" value="true">
                                                    <% } %>
                                                    
                                                    <div class="text-center mb-4">
                                                        <div class="price-highlight mb-2">
                                                            <%= currencyFormat.format(pkg.getPrice()) %>
                                                        </div>
                                                        <span class="text-muted">/ <%= pkg.getDuration() %> ngày</span>
                                                    </div>
                                                    
                                                    <% if (isUpgrade.test(pkg, activeOrPendingPackages)) { %>
                                                        <div class="alert alert-info alert-modern" style="border-left-color: #17a2b8;">
                                                            <i class="fas fa-info-circle me-2"></i> Bạn đang nâng cấp lên gói tập cao cấp hơn.
                                                        </div>
                                                        <div class="alert alert-warning alert-modern" style="border-left-color: #ffc107;">
                                                            <i class="fas fa-exclamation-triangle me-2"></i> <strong>Lưu ý:</strong> Gói tập hiện tại của bạn sẽ bị vô hiệu hóa khi bạn nâng cấp lên gói tập mới này.
                                                        </div>
                                                    <% } %>
                                                    
                                                    <div class="bg-light p-3 rounded mb-4">
                                                        <h6 class="mb-3">Thông tin gói tập:</h6>
                                                        <p class="mb-2">• <strong>Gói:</strong> <%= pkg.getName() %></p>
                                                        <p class="mb-2">• <strong>Thời hạn:</strong> <%= pkg.getDuration() %> ngày</p>
                                                        <% if (pkg.getSessions() != null) { %>
                                                        <p class="mb-2">• <strong>Số buổi tập:</strong> <%= pkg.getSessions() %> buổi</p>
                                                        <% } %>
                                                        <p class="mb-0">• <strong>Giá:</strong> <%= currencyFormat.format(pkg.getPrice()) %></p>
                                                    </div>
                                                    
                                                    <div class="form-check d-flex align-items-center">
                                                        <input class="form-check-input me-3" type="checkbox" id="confirmCheck<%= pkg.getId() %>" required>
                                                        <label class="form-check-label flex-grow-1" for="confirmCheck<%= pkg.getId() %>">
                                                            Tôi đồng ý với 
                                                            <a href="#" class="terms-link" data-bs-toggle="modal" data-bs-target="#termsModal">
                                                                các điều khoản và điều kiện
                                                            </a>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                                                        <i class="fas fa-times me-2"></i>Hủy
                                                    </button>
                                                    <button type="submit" class="btn btn-gradient">
                                                        <i class="fas fa-check me-2"></i>
                                                        <%= isUpgrade.test(pkg, activeOrPendingPackages) ? "Xác nhận nâng cấp" : "Xác nhận đăng ký" %>
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                                <% } else { %>
                                <div class="col-12">
                                    <div class="alert alert-info text-center alert-modern" style="border-left-color: #17a2b8;">
                                        <i class="fas fa-info-circle me-2"></i>
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
                                © <script>document.write(new Date().getFullYear())</script> CGMS
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </main>

    <!-- Terms and Conditions Modal -->
    <div class="modal fade" id="termsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header modal-header-gradient">
                    <h5 class="modal-title">
                        <i class="fas fa-file-contract me-2"></i>
                        Điều khoản và Điều kiện
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" style="max-height: 70vh; overflow-y: auto;">
                    <div class="terms-content">
                        <div class="alert alert-info alert-modern mb-4" style="border-left-color: #17a2b8;">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Quan trọng:</strong> Vui lòng đọc kỹ các điều khoản dưới đây trước khi đăng ký gói tập.
                        </div>
                        
                        <h6 class="text-primary">1. Điều khoản chung</h6>
                        <p>Bằng việc đăng ký sử dụng dịch vụ của CGMS, bạn đồng ý tuân thủ các điều khoản và điều kiện sau đây.</p>
                        
                        <h6 class="text-primary">2. Quy định về gói tập</h6>
                        <ul>
                            <li>Gói tập có hiệu lực từ ngày đăng ký và thanh toán thành công</li>
                            <li>Thời hạn gói tập được tính theo ngày, không được gia hạn tự động</li>
                            <li>Số buổi tập trong gói không được chuyển nhượng hoặc hoàn tiền</li>
                            <li>Gói tập chỉ được sử dụng bởi người đăng ký, không được chia sẻ</li>
                        </ul>
                        
                        <h6 class="text-primary">3. Chính sách thanh toán</h6>
                        <ul>
                            <li>Thanh toán phải được thực hiện đầy đủ trước khi sử dụng dịch vụ</li>
                            <li>Mọi giao dịch thanh toán đều được ghi nhận và lưu trữ</li>
                            <li>Phí dịch vụ không được hoàn lại sau khi đã thanh toán thành công</li>
                            <li>Hỗ trợ thanh toán qua nhiều hình thức: PayOS chuyển khoản, tiền mặt</li>
                        </ul>
                        
                        <h6 class="text-primary">4. Quy định sử dụng phòng gym</h6>
                        <ul>
                            <li>Tuân thủ giờ hoạt động: 07:00 - 22:00 hàng ngày</li>
                            <li>Mang theo thẻ thành viên khi sử dụng dịch vụ</li>
                            <li>Giữ gìn vệ sinh và trật tự trong phòng tập</li>
                            <li>Không được mang thực phẩm, đồ uống có cồn vào khu vực tập luyện</li>
                            <li>Sử dụng đúng thiết bị theo hướng dẫn và quy định an toàn</li>
                            <li>Trang phục phù hợp: áo thể thao, quần short/dài, giày thể thao</li>
                        </ul>
                        
                        <h6 class="text-primary">5. Chính sách hủy và hoàn tiền</h6>
                        <ul>
                            <li>Gói tập có thể hủy trong vòng 24 giờ sau khi đăng ký (chưa sử dụng lần nào)</li>
                            <li>Phí hủy gói: 10% tổng giá trị gói tập</li>
                            <li>Không hoàn tiền đối với gói tập đã sử dụng</li>
                            <li>Trường hợp đặc biệt (y tế, chuyển địa) sẽ được xem xét riêng</li>
                            <li>Thời gian xử lý hoàn tiền: 5-7 ngày làm việc</li>
                        </ul>
                        
                        <h6 class="text-primary">6. Trách nhiệm và Bảo hiểm</h6>
                        <ul>
                            <li>Thành viên tự chịu trách nhiệm về sức khỏe và an toàn cá nhân</li>
                            <li>CGMS không chịu trách nhiệm về chấn thương do tập luyện không đúng cách</li>
                            <li>Khuyến khích thành viên mua bảo hiểm y tế cá nhân</li>
                            <li>Thông báo ngay cho nhân viên khi có vấn đề sức khỏe</li>
                            <li>Tuân thủ các hướng dẫn của huấn luyện viên</li>
                        </ul>
                        
                        <h6 class="text-primary">7. Bảo mật thông tin</h6>
                        <p>CGMS cam kết bảo vệ thông tin cá nhân của thành viên theo quy định pháp luật về bảo vệ dữ liệu cá nhân. Thông tin cá nhân chỉ được sử dụng cho mục đích cung cấp dịch vụ và không được chia sẻ với bên thứ ba.</p>
                        
                        <h6 class="text-primary">8. Thay đổi điều khoản</h6>
                        <p>CGMS có quyền thay đổi các điều khoản này và sẽ thông báo trước cho thành viên ít nhất 7 ngày làm việc thông qua email hoặc thông báo tại phòng gym.</p>
                        
                        <div class="alert alert-success alert-modern mt-4" style="border-left-color: #28a745;">
                            <i class="fas fa-phone me-2"></i>
                            <strong>Liên hệ hỗ trợ:</strong><br>
                            • Hotline: <strong>+84 292 383 333</strong> (7:00 - 22:00)<br>
                            • Email: <strong>support@corefitgym.com</strong><br>
                            • Địa chỉ: 600 Nguyễn Văn Cừ, An Bình, Ninh Kiều, Cần Thơ
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-gradient" data-bs-dismiss="modal">
                        <i class="fas fa-check me-2"></i>Tôi đã hiểu
                    </button>
                </div>
            </div>
        </div>
    </div>

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
        
        // Smooth animations
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.package-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>
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
    List<MemberPurchaseHistory> purchaseHistory = (List<MemberPurchaseHistory>) request.getAttribute("purchaseHistory");
    Map<Integer, String> transactionIds = (Map<Integer, String>) request.getAttribute("transactionIds");
    
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
    statusIcon.put("INACTIVE", "fa-times-circle");
    statusIcon.put("CANCELLED", "fa-ban");
    statusIcon.put("PENDING", "fa-clock");
    statusIcon.put("COMPLETED", "fa-check-double");
    statusIcon.put("EXPIRED", "fa-calendar-times");
%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <link
      rel="apple-touch-icon"
      sizes="76x76"
      href="assets/img/icons8-gym-96.png"
    />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
    <title>Lịch sử gói tập - CGMS</title>
    <!--     Fonts and icons     -->
    <link
      href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700"
      rel="stylesheet"
    />
    <!-- Nucleo Icons -->
    <link
      href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css"
      rel="stylesheet"
    />
    <link
      href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css"
      rel="stylesheet"
    />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <!-- CSS Files -->
    <link
      id="pagestyle"
      href="assets/css/argon-dashboard.css?v=2.1.0"
      rel="stylesheet"
    />
    <style>
      /* Timeline styles */
      .timeline {
        position: relative;
        padding: 20px 0;
      }
      
      .timeline::before {
        content: '';
        position: absolute;
        width: 3px;
        background-color: #e9ecef;
        top: 0;
        bottom: 0;
        left: 20px;
        margin-left: -1px;
      }
      
      .timeline-item {
        position: relative;
        margin-bottom: 30px;
        padding-left: 60px;
      }
      
      .timeline-badge {
        position: absolute;
        top: 0;
        left: 0;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        text-align: center;
        font-size: 1.2em;
        line-height: 40px;
        z-index: 10;
        color: white;
      }
      
      .timeline-card {
        position: relative;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08);
        transition: all 0.3s ease;
      }
      
      .timeline-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 7px 14px rgba(50, 50, 93, 0.1), 0 3px 6px rgba(0, 0, 0, 0.08);
      }
      
      .timeline-card-header {
        border-radius: 8px 8px 0 0;
        padding: 15px 20px;
        color: white;
      }
      
      .timeline-card-body {
        padding: 15px 20px;
        background-color: white;
        border-radius: 0 0 8px 8px;
      }
      
      .timeline-info {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;
      }
      
      .timeline-info-item {
        display: flex;
        flex-direction: column;
      }
      
      .timeline-info-label {
        font-size: 0.75rem;
        color: #8898aa;
        font-weight: 600;
      }
      
      .timeline-info-value {
        font-size: 0.875rem;
        font-weight: 600;
      }
      
      .timeline-empty {
        text-align: center;
        padding: 30px;
        background-color: #f8f9fa;
        border-radius: 8px;
        margin-left: 60px;
      }
      
      @media (min-width: 768px) {
        .timeline::before {
          left: 50%;
        }
        
        .timeline-item {
          padding-left: 0;
          margin-bottom: 50px;
        }
        
        .timeline-item:nth-child(odd) {
          padding-right: 50%;
          padding-left: 0;
        }
        
        .timeline-item:nth-child(even) {
          padding-left: 50%;
          padding-right: 0;
        }
        
        .timeline-badge {
          left: 50%;
          margin-left: -20px;
        }
        
        .timeline-item:nth-child(odd) .timeline-card {
          margin-right: 40px;
        }
        
        .timeline-item:nth-child(even) .timeline-card {
          margin-left: 40px;
        }
        
        .timeline-empty {
          margin-left: 0;
        }
      }
    </style>
  </head>

  <body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <% if (loggedInUser != null && "Personal Trainer".equals(loggedInUser.getRole())) { %>
    <%@ include file="pt_sidebar.jsp" %>
    <% } else if (loggedInUser != null && "Member".equals(loggedInUser.getRole())) { %>
    <%@ include file="member_sidebar.jsp" %>
    <% } else { %>
    <%@ include file="sidebar.jsp" %>
    <% } %>
    <main
      class="main-content position-relative max-height-vh-100 h-100 border-radius-lg"
    >
      <!-- Navbar -->
      <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Lịch sử gói tập" />
        <jsp:param name="parentPage" value="Hồ sơ" />
        <jsp:param name="parentPageUrl" value="profile" />
        <jsp:param name="currentPage" value="Lịch sử gói tập" />
      </jsp:include>
      <!-- End Navbar -->
      
      <div class="container-fluid py-4">
        <div class="row">
          <div class="col-12">
            <div class="card mb-4">
              <div class="card-header pb-0">
                <div class="d-flex align-items-center">
                  <h6 class="mb-0">Lịch sử đăng ký gói tập</h6>
                  <a href="<%= request.getContextPath() %>/profile" class="btn btn-outline-secondary btn-sm ms-auto">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại hồ sơ
                  </a>
                </div>
              </div>
              <div class="card-body">
                <% if (allMemberPackages != null && !allMemberPackages.isEmpty()) { %>
                <div class="timeline">
                  <% for (int i = 0; i < allMemberPackages.size(); i++) { 
                      MemberPackage memberPackage = allMemberPackages.get(i);
                      String status = memberPackage.getStatus();
                      String color = statusColor.getOrDefault(status, "secondary");
                      String icon = statusIcon.getOrDefault(status, "fa-dumbbell");
                  %>
                    <div class="timeline-item">
                      <div class="timeline-badge bg-gradient-<%= color %>">
                        <i class="fas <%= icon %>"></i>
                      </div>
                      <div class="timeline-card">
                        <div class="timeline-card-header bg-gradient-<%= color %>">
                          <div class="d-flex justify-content-between align-items-center">
                            <h6 class="text-white mb-0"><%= memberPackage.getPackageField().getName() %></h6>
                            <span class="badge badge-sm bg-white text-<%= color %>">
                              <%= statusDisplay.getOrDefault(status, status) %>
                            </span>
                          </div>
                        </div>
                        <div class="timeline-card-body">
                          <div class="timeline-info">
                            <div class="timeline-info-item">
                              <span class="timeline-info-label">Thời gian</span>
                              <span class="timeline-info-value">
                                <%= memberPackage.getStartDate().format(dateFormatter) %> - <%= memberPackage.getEndDate().format(dateFormatter) %>
                              </span>
                            </div>
                            <div class="timeline-info-item">
                              <span class="timeline-info-label">Giá tiền</span>
                              <span class="timeline-info-value text-primary">
                                <%= String.format("%,.0f", memberPackage.getTotalPrice()) %> VNĐ
                              </span>
                            </div>
                          </div>
                          <div class="timeline-info">
                            <div class="timeline-info-item">
                              <span class="timeline-info-label">Thời hạn</span>
                              <span class="timeline-info-value"><%= memberPackage.getPackageField().getDuration() %> ngày</span>
                            </div>
                            <div class="timeline-info-item">
                              <span class="timeline-info-label">Ngày đăng ký</span>
                              <span class="timeline-info-value">
                                <%= memberPackage.getCreatedAt() != null ? 
                                    memberPackage.getCreatedAt().toString().substring(0, 10).replace("-", "/") : "N/A" %>
                              </span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  <% } %>
                </div>
                <% } else { %>
                <div class="timeline-empty">
                  <p class="text-sm mb-3">Bạn chưa đăng ký gói tập nào</p>
                  <a href="<%= request.getContextPath() %>/all-packages" class="btn btn-sm btn-primary">Đăng ký gói tập ngay</a>
                </div>
                <% } %>
              </div>
            </div>
          </div>
        </div>
        
        <div class="row">
          <div class="col-12">
            <div class="card mb-4">
              <div class="card-header pb-0">
                <h6>Lịch sử thanh toán</h6>
              </div>
              <div class="card-body">
                <% if (purchaseHistory != null && !purchaseHistory.isEmpty()) { %>
                <div class="timeline">
                  <% for (int i = 0; i < purchaseHistory.size(); i++) { 
                      MemberPurchaseHistory history = purchaseHistory.get(i);
                      String status = history.getStatus();
                      String color = statusColor.getOrDefault(status, "secondary");
                      String transactionId = transactionIds != null && transactionIds.containsKey(history.getId()) ? 
                                             transactionIds.get(history.getId()) : "#" + history.getId();
                  %>
                    <div class="timeline-item">
                      <div class="timeline-badge bg-gradient-<%= color %>">
                        <i class="fas fa-receipt"></i>
                      </div>
                      <div class="timeline-card">
                        <div class="timeline-card-header bg-gradient-<%= color %>">
                          <div class="d-flex justify-content-between align-items-center">
                            <h6 class="text-white mb-0">Giao dịch: <%= history.getPurchaseType() %></h6>
                            <span class="badge badge-sm bg-white text-<%= color %>">
                              <%= statusDisplay.getOrDefault(status, status) %>
                            </span>
                          </div>
                        </div>
                        <div class="timeline-card-body">
                          <div class="timeline-info">
                            <div class="timeline-info-item">
                              <span class="timeline-info-label">Mã giao dịch</span>
                              <span class="timeline-info-value"><%= transactionId %></span>
                            </div>
                            <div class="timeline-info-item">
                              <span class="timeline-info-label">Số tiền</span>
                              <span class="timeline-info-value text-primary">
                                <%= String.format("%,.0f", history.getPurchaseAmount()) %> VNĐ
                              </span>
                            </div>
                          </div>
                          <div class="timeline-info">
                            <div class="timeline-info-item">
                              <span class="timeline-info-label">Ngày thanh toán</span>
                              <span class="timeline-info-value"><%= history.getPurchaseDate().format(dateFormatter) %></span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  <% } %>
                </div>
                <% } else { %>
                <div class="timeline-empty">
                  <p class="text-sm mb-0">Không có lịch sử thanh toán</p>
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
                <div
                  class="copyright text-center text-sm text-muted text-lg-start"
                >
                  ©
                  <script>
                    document.write(new Date().getFullYear());
                  </script>
                  , CoreFit Gym Management System
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
    <script>
      var win = navigator.platform.indexOf("Win") > -1;
      if (win && document.querySelector("#sidenav-scrollbar")) {
        var options = {
          damping: "0.5",
        };
        Scrollbar.init(document.querySelector("#sidenav-scrollbar"), options);
      }
    </script>
    <!-- Github buttons -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    <!-- Control Center for Soft Dashboard: parallax effects, scripts for the example pages etc -->
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
  </body>
</html> 
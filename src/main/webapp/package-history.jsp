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
      href="assets/img/weightlifting.png"
    />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
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
              <div class="card-body px-0 pt-0 pb-2">
                <div class="table-responsive p-0">
                  <table class="table align-items-center mb-0">
                    <thead>
                      <tr>
                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Gói tập</th>
                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Thời gian</th>
                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Giá tiền</th>
                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày đăng ký</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% if (allMemberPackages != null && !allMemberPackages.isEmpty()) { %>
                        <% for (MemberPackage memberPackage : allMemberPackages) { %>
                          <tr>
                            <td>
                              <div class="d-flex px-2 py-1">
                                <div>
                                  <img src="assets/img/weightlifting.png" class="avatar avatar-sm me-3" alt="package">
                                </div>
                                <div class="d-flex flex-column justify-content-center">
                                  <h6 class="mb-0 text-sm"><%= memberPackage.getPackageField().getName() %></h6>
                                  <p class="text-xs text-secondary mb-0"><%= memberPackage.getPackageField().getDuration() %> ngày</p>
                                </div>
                              </div>
                            </td>
                            <td>
                              <p class="text-xs font-weight-bold mb-0">Từ: <%= memberPackage.getStartDate().format(dateFormatter) %></p>
                              <p class="text-xs text-secondary mb-0">Đến: <%= memberPackage.getEndDate().format(dateFormatter) %></p>
                            </td>
                            <td class="align-middle text-center">
                              <span class="text-secondary text-xs font-weight-bold"><%= String.format("%,.0f", memberPackage.getTotalPrice()) %> VNĐ</span>
                            </td>
                            <td class="align-middle text-center text-sm">
                              <span class="badge badge-sm bg-gradient-<%= statusColor.getOrDefault(memberPackage.getStatus(), "secondary") %>">
                                <%= statusDisplay.getOrDefault(memberPackage.getStatus(), memberPackage.getStatus()) %>
                              </span>
                            </td>
                            <td class="align-middle text-center">
                              <span class="text-secondary text-xs font-weight-bold">
                                <%= memberPackage.getCreatedAt() != null ? 
                                    memberPackage.getCreatedAt().toString().substring(0, 10).replace("-", "/") : "N/A" %>
                              </span>
                            </td>
                          </tr>
                        <% } %>
                      <% } else { %>
                        <tr>
                          <td colspan="5" class="text-center py-4">
                            <p class="text-sm mb-0">Bạn chưa đăng ký gói tập nào</p>
                            <a href="<%= request.getContextPath() %>/all-packages" class="btn btn-sm btn-primary mt-3">Đăng ký gói tập ngay</a>
                          </td>
                        </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
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
              <div class="card-body px-0 pt-0 pb-2">
                <div class="table-responsive p-0">
                  <table class="table align-items-center mb-0">
                    <thead>
                      <tr>
                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Mã giao dịch</th>
                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Loại giao dịch</th>
                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Số tiền</th>
                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày thanh toán</th>
                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% if (purchaseHistory != null && !purchaseHistory.isEmpty()) { %>
                        <% for (MemberPurchaseHistory history : purchaseHistory) { %>
                          <tr>
                            <td>
                              <div class="d-flex px-2 py-1">
                                <div class="d-flex flex-column justify-content-center">
                                  <h6 class="mb-0 text-sm">
                                    <% if (transactionIds != null && transactionIds.containsKey(history.getId())) { %>
                                      <%= transactionIds.get(history.getId()) %>
                                    <% } else { %>
                                      #<%= history.getId() %>
                                    <% } %>
                                  </h6>
                                </div>
                              </div>
                            </td>
                            <td>
                              <p class="text-xs font-weight-bold mb-0"><%= history.getPurchaseType() %></p>
                            </td>
                            <td class="align-middle text-center">
                              <span class="text-secondary text-xs font-weight-bold"><%= String.format("%,.0f", history.getPurchaseAmount()) %> VNĐ</span>
                            </td>
                            <td class="align-middle text-center">
                              <span class="text-secondary text-xs font-weight-bold"><%= history.getPurchaseDate().format(dateFormatter) %></span>
                            </td>
                            <td class="align-middle text-center text-sm">
                              <span class="badge badge-sm bg-gradient-<%= statusColor.getOrDefault(history.getStatus(), "secondary") %>">
                                <%= statusDisplay.getOrDefault(history.getStatus(), history.getStatus()) %>
                              </span>
                            </td>
                          </tr>
                        <% } %>
                      <% } else { %>
                        <tr>
                          <td colspan="5" class="text-center py-4">
                            <p class="text-sm mb-0">Không có lịch sử thanh toán</p>
                          </td>
                        </tr>
                      <% } %>
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
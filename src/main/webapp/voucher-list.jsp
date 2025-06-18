<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="Models.User"%>
<%@page import="Models.Voucher"%>
<%@page import="java.util.List"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
%>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <link rel="apple-touch-icon" sizes="76x76" href="${pageContext.request.contextPath}/assets/img/weightlifting.png" />
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/weightlifting.png" />
  <title>Quản lý Voucher - CGMS</title>

  <!-- Fonts and icons -->
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
  <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
  <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
  <link id="pagestyle" href="${pageContext.request.contextPath}/assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
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

  <!-- Main Content -->
  <main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Quản lý Voucher" />
        <jsp:param name="parentPage" value="Dashboard" />
        <jsp:param name="parentPageUrl" value="dashboard.jsp" />
        <jsp:param name="currentPage" value="Quản lý Voucher" />
    </jsp:include>

    <!-- Page Content -->
    <div class="container-fluid py-4">
      <div class="card mb-4">
        <div class="card-header pb-0 d-flex justify-content-between align-items-center">
          <h6>Danh sách Voucher</h6>
          <div>
            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                <i class="fas fa-arrow-left me-2"></i>Quay lại
            </a>
            <a href="${pageContext.request.contextPath}/voucher?action=create" class="btn btn-primary btn-sm">
                <i class="fas fa-plus me-2"></i>Tạo Voucher mới
            </a>
          </div>
        </div>
        <div class="card-body px-0 pt-0 pb-2">
          <div class="table-responsive p-0">
            <table class="table align-items-center mb-0">
              <thead>
                <tr>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">ID</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Mã</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Giảm giá</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Loại</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Giá trị tối thiểu</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Ngày hết hạn</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Trạng thái</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="v" items="${voucherList}">
                  <tr>
                    <td class="text-center"><h6 class="mb-0 text-sm">${v.id}</h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">${v.code}</h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">${v.discountValue}</h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">
                      <c:choose>
                        <c:when test="${v.discountType == 'Percent'}">Phần trăm</c:when>
                        <c:when test="${v.discountType == 'Amount'}">Số tiền cố định</c:when>
                        <c:otherwise>${v.discountType}</c:otherwise>
                      </c:choose>
                    </h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">${v.minPurchase}</h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">${v.expiryDate}</h6></td>
                    <td class="ps-2">
                      <c:choose>
                        <c:when test="${v.status == 'Active'}">
                          <span class="badge badge-sm bg-gradient-success">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-sm bg-gradient-secondary">Không hoạt động</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="text-center">
                      <div class="dropdown">
                        <button class="btn btn-sm btn-icon-only text-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                          <i class="fas fa-ellipsis-v"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/voucher?action=edit&id=${v.id}"><i class="fas fa-edit me-2"></i>Chỉnh sửa</a></li>
                          <li><a class="dropdown-item" href="#" onclick="confirmDelete('${v.id}')"><i class="fas fa-trash me-2"></i>Xóa</a></li>
                        </ul>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </main>

  <!-- Scripts -->
  <script src="${pageContext.request.contextPath}/assets/js/core/popper.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/core/bootstrap.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/plugins/perfect-scrollbar.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/plugins/smooth-scrollbar.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/argon-dashboard.min.js?v=2.1.0"></script>
  <script>
    function confirmDelete(id) {
      if (confirm('Bạn có chắc chắn muốn xóa voucher này không?')) {
        window.location.href = '${pageContext.request.contextPath}/voucher?action=delete&id=' + id;
      }
    }
  </script>
</body>
</html>

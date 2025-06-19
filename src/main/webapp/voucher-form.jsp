<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="Models.User"%>
<%@page import="Models.Voucher"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    // Lấy thông tin voucher nếu đang chỉnh sửa
    Voucher voucher = (Voucher) request.getAttribute("voucher");
    boolean isEdit = voucher != null;
%>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title><%= isEdit ? "Chỉnh sửa voucher" : "Thêm voucher mới" %> - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
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
      <jsp:param name="pageTitle" value="<%= isEdit ? \"Chỉnh sửa voucher\" : \"Thêm voucher mới\" %>" />
      <jsp:param name="parentPage" value="Quản lý Voucher" />
      <jsp:param name="parentPageUrl" value="voucher?action=list" />
      <jsp:param name="currentPage" value="<%= isEdit ? \"Chỉnh sửa voucher\" : \"Thêm voucher mới\" %>" />
  </jsp:include>

  <!-- Form -->
  <div class="container-fluid py-4">
    <div class="card mb-4">
      <div class="card-header pb-0 d-flex justify-content-between align-items-center">
        <h6><%= isEdit ? "Chỉnh sửa voucher" : "Thêm voucher mới" %></h6>
        <a href="voucher" class="btn btn-outline-secondary btn-sm">
          <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
        </a>
      </div>
      <div class="card-body">
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          <i class="fas fa-exclamation-circle me-2"></i> <%= request.getAttribute("errorMessage") %>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/voucher">
          <c:if test="${voucher.id != null}">
            <input type="hidden" name="id" value="${voucher.id}" />
          </c:if>
          <input type="hidden" name="action" value="${voucher.id != null ? 'update' : 'create'}" />

          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label">Mã voucher *</label>
              <input type="text" class="form-control" name="code" value="${voucher.code}" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Giá trị giảm *</label>
              <input type="number" step="0.01" class="form-control" name="discountValue" value="${voucher.discountValue}" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Loại giảm giá *</label>
              <select class="form-control" name="discountType" required>
                <option value="">-- Chọn loại --</option>
                <option value="Percent" ${voucher.discountType == 'Percent' ? 'selected' : ''}>Phần trăm</option>
                <option value="Amount" ${voucher.discountType == 'Amount' ? 'selected' : ''}>Số tiền cố định</option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Giá trị đơn hàng tối thiểu</label>
              <input type="number" step="0.01" class="form-control" name="minPurchase" value="${voucher.minPurchase}" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Ngày hết hạn *</label>
              <input type="date" class="form-control" name="expiryDate" value="${voucher.expiryDate}" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Trạng thái *</label>
              <select class="form-control" name="status" required>
                <option value="Active" ${voucher.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                <option value="Inactive" ${voucher.status == 'Inactive' ? 'selected' : ''}>Không hoạt động</option>
              </select>
            </div>
          </div>

          <div class="d-flex justify-content-end mt-4">
            <button type="reset" class="btn btn-light me-2">Làm mới</button>
            <button type="submit" class="btn btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/voucher?action=list" class="btn btn-secondary ms-2">Quay lại danh sách</a>
          </div>
        </form>
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
</body>
</html>

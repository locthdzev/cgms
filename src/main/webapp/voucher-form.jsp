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

<!-- Sidebar -->
  <aside class="sidenav bg-white navbar navbar-vertical navbar-expand-xs border-0 border-radius-xl my-3 fixed-start ms-4" id="sidenav-main">
    <div class="sidenav-header">
      <i class="fas fa-times p-3 cursor-pointer text-secondary opacity-5 position-absolute end-0 top-0 d-none d-xl-none" id="iconSidenav"></i>
      <a class="navbar-brand m-0" href="${pageContext.request.contextPath}/dashboard.jsp">
        <img src="${pageContext.request.contextPath}/assets/img/weightlifting.png" width="26px" height="26px" class="navbar-brand-img h-100" alt="main_logo" />
        <span class="ms-1 font-weight-bold">CGMS</span>
      </a>
    </div>
    <hr class="horizontal dark mt-0" />
    <div class="collapse navbar-collapse w-auto" id="sidenav-collapse-main">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link ${uri.endsWith('/dashboard.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard.jsp">
            <div class="icon icon-shape icon-sm text-center me-2 d-flex align-items-center justify-content-center">
              <i class="ni ni-tv-2 text-dark text-sm opacity-10"></i>
            </div>
            <span class="nav-link-text ms-1">Dashboard</span>
          </a>
        </li>
        
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/tables.html">
            <div class="icon icon-shape icon-sm text-center me-2 d-flex align-items-center justify-content-center">
              <i class="ni ni-calendar-grid-58 text-dark text-sm opacity-10"></i>
            </div>
            <span class="nav-link-text ms-1">Tables</span>
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/billing.html">
            <div class="icon icon-shape icon-sm text-center me-2 d-flex align-items-center justify-content-center">
              <i class="ni ni-credit-card text-dark text-sm opacity-10"></i>
            </div>
            <span class="nav-link-text ms-1">Billing</span>
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/virtual-reality.html">
            <div class="icon icon-shape icon-sm text-center me-2 d-flex align-items-center justify-content-center">
              <i class="ni ni-app text-dark text-sm opacity-10"></i>
            </div>
            <span class="nav-link-text ms-1">Virtual Reality</span>
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link ${uri.contains('/voucher') ? 'active' : ''}" href="${pageContext.request.contextPath}/voucher?action=list">
            <div class="icon icon-shape icon-sm text-center me-2 d-flex align-items-center justify-content-center">
              <i class="ni ni-tag text-dark text-sm opacity-10"></i>
            </div>
            <span class="nav-link-text ms-1">Manage Vouchers</span>
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/rtl.html">
            <div class="icon icon-shape icon-sm text-center me-2 d-flex align-items-center justify-content-center">
              <i class="ni ni-world-2 text-dark text-sm opacity-10"></i>
            </div>
            <span class="nav-link-text ms-1">RTL</span>
          </a>
        </li>
        <li class="nav-item mt-3">
          <h6 class="ps-4 ms-2 text-uppercase text-xs font-weight-bolder opacity-6">Account pages</h6>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/profile.html">
            <div class="icon icon-shape icon-sm text-center me-2 d-flex align-items-center justify-content-center">
              <i class="ni ni-single-02 text-dark text-sm opacity-10"></i>
            </div>
            <span class="nav-link-text ms-1">Profile</span>
          </a>
        </li>
      </ul>
    </div>
  </aside>

<!-- Main Content -->
<main class="main-content position-relative border-radius-lg">
  <!-- Navbar -->
  <nav class="navbar navbar-main navbar-expand-lg px-0 mx-4 shadow-none border-radius-xl" id="navbarBlur" data-scroll="false">
    <div class="container-fluid py-1 px-3">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb bg-transparent mb-0 pb-0 pt-1 px-0 me-sm-6 me-5">
          <li class="breadcrumb-item text-sm"><a class="opacity-5 text-white" href="dashboard.jsp">Dashboard</a></li>
          <li class="breadcrumb-item text-sm"><a class="opacity-5 text-white" href="voucher">Danh sách voucher</a></li>
          <li class="breadcrumb-item text-sm text-white active" aria-current="page"><%= isEdit ? "Chỉnh sửa voucher" : "Thêm voucher mới" %></li>
        </ol>
        <h6 class="font-weight-bolder text-white mb-0"><%= isEdit ? "Chỉnh sửa voucher" : "Thêm voucher mới" %></h6>
      </nav>
      
      <!-- User Welcome Section -->
      <% if (loggedInUser != null) { %>
      <div class="user-welcome">
          <p class="user-name">Xin chào, <%= loggedInUser.getFullName() %></p>
          <p class="user-email"><%= loggedInUser.getEmail() %></p>
      </div>
      <% } %>
    </div>
  </nav>

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

          <div class="mb-3">
            <label class="form-label">Code</label>
            <input type="text" class="form-control" name="code" value="${voucher.code}" required />
          </div>

          <div class="mb-3">
            <label class="form-label">Discount Value</label>
            <input type="number" step="0.01" class="form-control" name="discountValue" value="${voucher.discountValue}" required />
          </div>

          <div class="mb-3">
            <label class="form-label">Discount Type</label>
            <select class="form-control" name="discountType" required>
              <option value="">-- Select --</option>
              <option value="Percent" ${voucher.discountType == 'Percent' ? 'selected' : ''}>Percent</option>
              <option value="Amount" ${voucher.discountType == 'Amount' ? 'selected' : ''}>Amount</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label">Min Purchase</label>
            <input type="number" step="0.01" class="form-control" name="minPurchase" value="${voucher.minPurchase}" />
          </div>

          <div class="mb-3">
            <label class="form-label">Expiry Date</label>
            <input type="date" class="form-control" name="expiryDate" value="${voucher.expiryDate}" required />
          </div>

          <div class="mb-3">
            <label class="form-label">Status</label>
            <select class="form-control" name="status" required>
              <option value="Active" ${voucher.status == 'Active' ? 'selected' : ''}>Active</option>
              <option value="Inactive" ${voucher.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
            </select>
          </div>

          <button type="submit" class="btn btn-primary">Save</button>
          <a href="${pageContext.request.contextPath}/voucher?action=list" class="btn btn-secondary">Back to list</a>
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

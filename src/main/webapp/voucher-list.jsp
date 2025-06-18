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
  <title>CoreFit Gym Management System</title>

  <!-- Fonts and icons -->
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
  <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
  <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
  <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
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
            <li class="breadcrumb-item text-sm"><a class="opacity-5 text-white" href="#">Pages</a></li>
            <li class="breadcrumb-item text-sm text-white active" aria-current="page">Vouchers</li>
          </ol>
          <h6 class="font-weight-bolder text-white mb-0">Manage Vouchers</h6>
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

    <!-- Page Content -->
    <div class="container-fluid py-4">
      <div class="card mb-4">
        <div class="card-header pb-0">
          <h6>Voucher List</h6>
          <a href="${pageContext.request.contextPath}/voucher?action=create" class="btn btn-primary btn-sm mt-2">Create New Voucher</a>
        </div>
        <div class="card-body px-0 pt-0 pb-2">
          <div class="table-responsive p-0">
            <table class="table align-items-center mb-0">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Code</th>
                  <th>Discount</th>
                  <th>Type</th>
                  <th>Min Purchase</th>
                  <th>Expiry</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="v" items="${voucherList}">
                  <tr>
                    <td>${v.id}</td>
                    <td>${v.code}</td>
                    <td>${v.discountValue}</td>
                    <td>${v.discountType}</td>
                    <td>${v.minPurchase}</td>
                    <td>${v.expiryDate}</td>
                    <td>${v.status}</td>
                    <td>
                      <a href="${pageContext.request.contextPath}/voucher?action=edit&id=${v.id}" class="btn btn-warning btn-sm">Edit</a>
                      <a href="${pageContext.request.contextPath}/voucher?action=delete&id=${v.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
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
</body>
</html>

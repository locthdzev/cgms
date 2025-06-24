<%@ page pageEncoding="UTF-8" %>
<%
    // Lấy đường dẫn hiện tại để đánh dấu menu active
    String currentPath = request.getServletPath();
    String contextPath = request.getContextPath();
    
    // Kiểm tra xem người dùng đang ở trang nào
    boolean isDashboard = currentPath.contains("dashboard.jsp") || currentPath.equals("/") || currentPath.equals("/dashboard");
    boolean isPackage = currentPath.contains("Package") || currentPath.contains("package");
    boolean isUser = currentPath.contains("user.jsp") || currentPath.contains("User") || currentPath.contains("/user");
    boolean isVoucher = currentPath.contains("voucher") || currentPath.contains("Voucher");
    boolean isProfile = currentPath.contains("profile.jsp");
    boolean isProduct = currentPath.contains("product.jsp") || currentPath.contains("Product") || currentPath.contains("/product") || currentPath.contains("addProduct") || currentPath.contains("editProduct");
    boolean isSchedule = currentPath.contains("schedule") || currentPath.contains("Schedule") || currentPath.contains("/schedule");
    boolean isFeedback = currentPath.contains("feedback") || currentPath.contains("Feedback");
%>

<aside
  class="sidenav bg-white navbar navbar-vertical navbar-expand-xs border-0 border-radius-xl my-3 fixed-start ms-4"
  id="sidenav-main"
>
  <div class="sidenav-header">
    <i
      class="fas fa-times p-3 cursor-pointer text-secondary opacity-5 position-absolute end-0 top-0 d-none d-xl-none"
      aria-hidden="true"
      id="iconSidenav"
    ></i>
    <a
      class="navbar-brand m-0"
      href="${pageContext.request.contextPath}/dashboard"
    >
      <img
        src="${pageContext.request.contextPath}/assets/img/weightlifting.png"
        width="26px"
        height="26px"
        class="navbar-brand-img h-100"
        alt="main_logo"
      />
      <span class="ms-1 font-weight-bold">CGMS</span>
    </a>
  </div>
  <hr class="horizontal dark mt-0" />
  <div class="collapse navbar-collapse w-auto" id="sidenav-collapse-main">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link <%= isDashboard ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-tv-2 text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Dashboard</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link <%= isPackage ? "active" : "" %>" href="${pageContext.request.contextPath}/listPackage">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-calendar-grid-58 text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Gói tập Gym</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link <%= isUser ? "active" : "" %>" href="${pageContext.request.contextPath}/user">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-single-02 text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Quản lý người dùng</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link <%= isProduct ? "active" : "" %>" href="${pageContext.request.contextPath}/product">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-bag-17 text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Quản lý sản phẩm</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link <%= isSchedule ? "active" : "" %>" href="${pageContext.request.contextPath}/schedule">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-calendar-grid-58 text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Quản lý lịch tập</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link <%= isVoucher ? "active" : "" %>" href="${pageContext.request.contextPath}/voucher?action=list">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-tag text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Quản lý Voucher</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link <%= isFeedback ? "active" : "" %>" href="${pageContext.request.contextPath}/feedback">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-chat-round text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Quản lý Feedback</span>
        </a>
      </li>
      <li class="nav-item mt-3">
        <h6
          class="ps-4 ms-2 text-uppercase text-xs font-weight-bolder opacity-6"
        >
          Tài khoản
        </h6>
      </li>
      <li class="nav-item">
        <a class="nav-link <%= isProfile ? "active" : "" %>" href="${pageContext.request.contextPath}/profile">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-single-02 text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Hồ sơ</span>
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-button-power text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Đăng xuất</span>
        </a>
      </li>
    </ul>
  </div>
</aside> 
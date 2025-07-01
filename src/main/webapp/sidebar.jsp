<%@ page pageEncoding="UTF-8" %>
<%
    // Lấy đường dẫn hiện tại để đánh dấu menu active
    String currentPath = request.getServletPath();
    String contextPath = request.getContextPath();
    
    // Kiểm tra xem người dùng đang ở trang nào
    boolean isDashboard = currentPath.contains("dashboard.jsp") || currentPath.equals("/") || currentPath.equals("/dashboard");
    boolean isPackage = currentPath.contains("Package") || currentPath.contains("package");
    boolean isMember = currentPath.contains("user.jsp") || currentPath.contains("addUser.jsp") || currentPath.contains("editUser.jsp") || (currentPath.contains("/user") && !currentPath.contains("trainer"));
    boolean isTrainer = currentPath.contains("trainer.jsp") || currentPath.contains("addTrainer.jsp") || currentPath.contains("editTrainer.jsp") || currentPath.contains("/trainer");
    boolean isUserManagement = isMember || isTrainer; // Quản lý người dùng chung
    boolean isVoucher = currentPath.contains("voucher") || currentPath.contains("Voucher");
    boolean isProfile = currentPath.contains("profile.jsp");
    boolean isProduct = currentPath.contains("product.jsp") || currentPath.contains("Product") || currentPath.contains("/product") || currentPath.contains("addProduct") || currentPath.contains("editProduct");
    boolean isSchedule = currentPath.contains("schedule") || currentPath.contains("Schedule") || currentPath.contains("/schedule");
    boolean isFeedback = currentPath.contains("feedback") || currentPath.contains("Feedback");
    boolean isInventory = currentPath.contains("inventory") || currentPath.contains("Inventory");
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
      <!-- Dropdown menu cho Quản lý người dùng -->
      <li class="nav-item">
        <a class="nav-link <%= isUserManagement ? "active" : "" %>" href="#" data-bs-toggle="collapse" data-bs-target="#userManagementCollapse" aria-expanded="<%= isUserManagement ? "true" : "false" %>">
          <div
            class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center"
          >
            <i class="ni ni-single-02 text-dark text-sm opacity-10"></i>
          </div>
          <span class="nav-link-text ms-1">Quản lý người dùng</span>
          <i class="fas fa-angle-down ms-auto"></i>
        </a>
        <div class="collapse <%= isUserManagement ? "show" : "" %>" id="userManagementCollapse">
          <ul class="navbar-nav ps-4">
            <li class="nav-item">
              <a class="nav-link <%= isMember ? "active" : "" %>" href="${pageContext.request.contextPath}/user">
                <span class="nav-link-text ms-1">
                  <i class="fas fa-users text-dark text-sm opacity-10 me-1"></i>
                  Quản lý Member
                </span>
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link <%= isTrainer ? "active" : "" %>" href="${pageContext.request.contextPath}/trainer">
                <span class="nav-link-text ms-1">
                  <i class="fas fa-user-tie text-dark text-sm opacity-10 me-1"></i>
                  Quản lý Personal Trainer
                </span>
              </a>
            </li>
          </ul>
        </div>
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
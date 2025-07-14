<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User sidebarUser = (User) session.getAttribute("loggedInUser");
    
    // Lấy đường dẫn hiện tại để xác định menu nào đang active
    String currentURI = request.getRequestURI();
    String pageName = currentURI.substring(currentURI.lastIndexOf("/") + 1);
%>

<aside class="sidenav bg-white navbar navbar-vertical navbar-expand-xs border-0 border-radius-xl my-3 fixed-start ms-4" id="sidenav-main">
    <div class="sidenav-header">
        <i class="fas fa-times p-3 cursor-pointer text-secondary opacity-5 position-absolute end-0 top-0 d-none d-xl-none" aria-hidden="true" id="iconSidenav"></i>
        <a class="navbar-brand m-0" href="member-dashboard">
            <img src="assets/img/weightlifting.png" class="navbar-brand-img h-100" alt="logo">
            <span class="ms-1 font-weight-bold">CGMS</span>
        </a>
    </div>
    <hr class="horizontal dark mt-0">
    <div class="collapse navbar-collapse w-auto" id="sidenav-collapse-main">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link <%= "member-dashboard".equals(pageName) ? "active" : "" %>" href="member-dashboard">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-tachometer-alt text-primary text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "member-packages.jsp".equals(pageName) ? "active" : "" %>" href="member-packages.jsp">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-dumbbell text-danger text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Gói tập của tôi</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "member-schedule.jsp".equals(pageName) ? "active" : "" %>" href="member-schedule.jsp">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-calendar-alt text-warning text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Lịch tập luyện</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "member-shop.jsp".equals(pageName) ? "active" : "" %>" href="member-shop.jsp">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-store text-success text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Cửa hàng</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "member-cart.jsp".equals(pageName) ? "active" : "" %>" href="member-cart.jsp">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-shopping-cart text-info text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Giỏ hàng</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "member-feedback.jsp".equals(pageName) ? "active" : "" %>" href="member-feedback.jsp">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-comment-alt text-primary text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Feedback</span>
                </a>
            </li>
            <li class="nav-item mt-3">
                <h6 class="ps-4 ms-2 text-uppercase text-xs font-weight-bolder opacity-6">Tài khoản</h6>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "profile.jsp".equals(pageName) ? "active" : "" %>" href="profile">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-user text-info text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Hồ sơ cá nhân</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="logout">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-sign-out-alt text-secondary text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Đăng xuất</span>
                </a>
            </li>
        </ul>
    </div>
</aside> 
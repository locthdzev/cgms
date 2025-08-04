<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User sidebarUser = (User) session.getAttribute("loggedInUser");
    
    // Lấy đường dẫn hiện tại để xác định menu nào đang active
    String sidebarCurrentURI = request.getRequestURI();
    String sidebarPageName = sidebarCurrentURI.substring(sidebarCurrentURI.lastIndexOf("/") + 1);
%>

<aside class="sidenav bg-white navbar navbar-vertical navbar-expand-xs border-0 border-radius-xl my-3 fixed-start ms-4" id="sidenav-main">
    <div class="sidenav-header">
        <i class="fas fa-times p-3 cursor-pointer text-secondary opacity-5 position-absolute end-0 top-0 d-none d-xl-none" aria-hidden="true" id="iconSidenav"></i>
        <a class="navbar-brand m-0" href="pt_dashboard">
            <img src="assets/img/icons8-gym-96.png" class="navbar-brand-img h-100" alt="logo">
            <span class="ms-1 font-weight-bold">CGMS</span>
        </a>
    </div>
    <hr class="horizontal dark mt-0">
    <div class="collapse navbar-collapse w-auto" id="sidenav-collapse-main">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link <%= sidebarCurrentURI.contains("pt_dashboard") ? "active" : "" %>" href="pt_dashboard">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-tachometer-alt text-primary text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= sidebarCurrentURI.contains("pt-schedule") ? "active" : "" %>" href="pt-schedule">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-calendar-check text-info text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Quản lý lịch tập</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= sidebarCurrentURI.contains("pt-availability") ? "active" : "" %>" href="pt-availability">
                    <div class="icon icon-shape icon-sm border-radius-md text-center me-2 d-flex align-items-center justify-content-center">
                        <i class="fas fa-calendar-plus text-success text-sm opacity-10"></i>
                    </div>
                    <span class="nav-link-text ms-1">Lịch sẵn sàng</span>
                </a>
            </li>
            
            <li class="nav-item mt-3">
                <h6 class="ps-4 ms-2 text-uppercase text-xs font-weight-bolder opacity-6">Tài khoản</h6>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "profile.jsp".equals(sidebarPageName) ? "active" : "" %>" href="profile">
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

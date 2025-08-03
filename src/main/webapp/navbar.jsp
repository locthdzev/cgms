<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
    // Lấy thông tin breadcrumb từ các tham số được truyền vào
    String pageTitle = request.getParameter("pageTitle");
    String parentPage = request.getParameter("parentPage");
    String parentPageUrl = request.getParameter("parentPageUrl");
    String currentPage = request.getParameter("currentPage");
    
    if (pageTitle == null) pageTitle = "Dashboard";
    if (parentPage == null) parentPage = "Pages";
    if (parentPageUrl == null) parentPageUrl = "javascript:;";
    if (currentPage == null) currentPage = "Dashboard";
%>

<style>
    .navbar-main .container-fluid {
        display: flex;
        align-items: center;
    }
    
    nav[aria-label="breadcrumb"] {
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
    
    .user-welcome {
        text-align: right;
        margin-left: auto;
        display: flex;
        align-items: center;
        height: 100%;
    }
    
    .user-info {
        margin-right: 10px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
    
    .user-welcome .user-name {
        font-weight: 600;
        color: white;
        font-size: 1rem;
        margin-bottom: 0;
        line-height: 1.2;
    }
    
    .user-welcome .user-email {
        color: rgba(255, 255, 255, 0.8);
        font-size: 0.875rem;
        line-height: 1.2;
        margin-bottom: 0;
    }
    
    .dropdown-menu-end {
        right: 0;
        left: auto;
    }
    
    .dropdown-toggle-arrow {
        cursor: pointer;
        width: 24px;
        height: 24px;
        display: flex;
        align-items: center;
    }
    
    .dropdown-toggle-arrow svg {
        width: 100%;
        height: 100%;
        transition: transform 0.3s ease;
    }
    
    .dropdown-toggle-arrow svg path {
        fill: white;
    }
    
    .dropdown.show .dropdown-toggle-arrow svg {
        transform: rotate(180deg);
    }
    
    .dropdown-item.logout {
        color: #dc3545;
    }
    
    .dropdown-item.logout:hover {
        background-color: rgba(220, 53, 69, 0.1);
    }
</style>

<!-- Navbar -->
<nav class="navbar navbar-main navbar-expand-lg px-0 mx-4 shadow-none border-radius-xl" id="navbarBlur" data-scroll="false">
    <div class="container-fluid py-1 px-3">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb bg-transparent mb-0 pb-0 pt-1 px-0 me-sm-6 me-5">
                <li class="breadcrumb-item text-sm">
                    <a class="opacity-5 text-white" href="dashboard.jsp">Dashboard</a>
                </li>
                <% if (!parentPage.equals("Dashboard")) { %>
                <li class="breadcrumb-item text-sm">
                    <a class="opacity-5 text-white" href="<%= parentPageUrl %>"><%= parentPage %></a>
                </li>
                <% } %>
                <li class="breadcrumb-item text-sm text-white active" aria-current="page">
                    <%= currentPage %>
                </li>
            </ol>
            <h6 class="font-weight-bolder text-white mb-0"><%= pageTitle %></h6>
        </nav>
        
        <!-- User Welcome Section with Dropdown -->
        <% if (loggedInUser != null) { %>
        <div class="user-welcome">
            <div class="user-info">
                <p class="user-name">Xin chào, <%= loggedInUser.getFullName() %></p>
                <p class="user-email"><%= loggedInUser.getEmail() %></p>
            </div>
            <div class="dropdown">
                <div class="dropdown-toggle-arrow" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M11.8079 14.7695L8.09346 10.3121C7.65924 9.79109 8.02976 9 8.70803 9L15.292 9C15.9702 9 16.3408 9.79108 15.9065 10.3121L12.1921 14.7695C12.0921 14.8895 11.9079 14.8895 11.8079 14.7695Z" fill="#FFFFFF"/>
                    </svg>
                </div>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <li><a class="dropdown-item" href="profile">Hồ sơ</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item logout" href="logout">Đăng xuất</a></li>
                </ul>
            </div>
        </div>
        <% } %>
    </div>
</nav>
<!-- End Navbar --> 

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Checkin" %>
<%@ page import="Models.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="Services.CheckinService" %>
<%
    // Khởi tạo CheckinService để sử dụng trong JSP
    CheckinService checkinService = new CheckinService();
    
    String selectedUserId = request.getParameter("userId");
    List<User> userList = (List<User>) request.getAttribute("userList");
    List<Checkin> checkinList = (List<Checkin>) request.getAttribute("checkinList");
    User member = null;
    if (selectedUserId != null) {
        member = (User) request.getAttribute("member");
        if (member == null && userList != null) {
            for (User u : userList) {
                if (u.getId().toString().equals(selectedUserId)) {
                    member = u;
                    break;
                }
            }
        }
    }
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    String parentPage, parentPageUrl, currentPage;
    if (selectedUserId != null && member != null) {
        parentPage = "Lịch sử Check-In";
        parentPageUrl = "checkinHistory";
        currentPage = member.getFullName() != null ? member.getFullName() : member.getUserName();
    } else {
        parentPage = "Dashboard";
        parentPageUrl = "dashboard";
        currentPage = "Lịch sử Check-In";
    }
    java.util.List<Models.Schedule> validSchedules = (java.util.List<Models.Schedule>) request.getAttribute("validSchedules");
    java.time.LocalDate filterDate = null;
    if (request.getParameter("filterDate") != null && !request.getParameter("filterDate").isEmpty()) {
        filterDate = java.time.LocalDate.parse(request.getParameter("filterDate"));
    }
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Lịch sử Check-In - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
    <style>
        .avatar {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .table-hover tbody tr:hover {
            background-color: rgba(0, 123, 255, 0.1);
        }
        .card-header.bg-success {
            border-radius: 0.75rem 0.75rem 0 0;
            font-weight: 600;
        }
        .card-header.bg-primary {
            border-radius: 0.75rem 0.75rem 0 0;
            font-weight: 600;
        }
        .card-header.bg-warning {
            border-radius: 0.75rem 0.75rem 0 0;
            font-weight: 600;
        }
        .badge {
            font-size: 0.75rem;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>

<!-- Include Sidebar Component -->
<%@ include file="sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Lịch sử Check-In" />
        <jsp:param name="parentPage" value="<%= parentPage %>" />
        <jsp:param name="parentPageUrl" value="<%= parentPageUrl %>" />
        <jsp:param name="currentPage" value="<%= currentPage %>" />
    </jsp:include>

    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <%-- Hiển thị thông báo thành công/lỗi --%>
                <% 
                // Lấy thông báo từ request hoặc session (giống các trang khác)
                String successMessage = (String) request.getAttribute("successMessage");
                if (successMessage == null) {
                    successMessage = (String) session.getAttribute("successMessage");
                    if (successMessage != null) {
                        session.removeAttribute("successMessage");
                    }
                }
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage == null) {
                    errorMessage = (String) session.getAttribute("errorMessage");
                    if (errorMessage != null) {
                        session.removeAttribute("errorMessage");
                    }
                }
                boolean hasSuccessMessage = successMessage != null;
                boolean hasErrorMessage = errorMessage != null;
                %>
                
                <!-- Toast Container (thông báo giống các trang khác) -->
                <div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 9999;">
                    <% if (hasSuccessMessage) { %>
                    <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true" id="successToast">
                        <div class="d-flex">
                            <div class="toast-body">
                                <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
                            </div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                        </div>
                    </div>
                    <% } %>
                    <% if (hasErrorMessage) { %>
                    <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" id="errorToast">
                        <div class="d-flex">
                            <div class="toast-body">
                                <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
                            </div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                        </div>
                    </div>
                    <% } %>
                </div>
                <script>
                    window.addEventListener('DOMContentLoaded', function() {
                        var successToast = document.getElementById('successToast');
                        if (successToast) {
                            var toast = new bootstrap.Toast(successToast, { delay: 3500 });
                            toast.show();
                        }
                        var errorToast = document.getElementById('errorToast');
                        if (errorToast) {
                            var toast = new bootstrap.Toast(errorToast, { delay: 3500 });
                            toast.show();
                        }
                    });
                </script>
                
                <%-- Hiển thị danh sách member cần check-in hôm nay --%>
                <% 
                List<Models.Schedule> schedulesToday = (List<Models.Schedule>) request.getAttribute("schedulesToday");
                if (schedulesToday != null && !schedulesToday.isEmpty()) { 
                %>
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <i class="fas fa-users me-2"></i>
                        Danh sách Member cần Check-in hôm nay (<%= java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>)
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-center">STT</th>
                                        <th>Member</th>
                                        <th class="text-center">Giờ tập</th>
                                        <th class="text-center">Thời lượng</th>
                                        <th class="text-center">Trạng thái lịch</th>
                                        <th class="text-center">Trạng thái Check-in</th>
                                        <th class="text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% 
                                int stt = 1;
                                for (Models.Schedule schedule : schedulesToday) {
                                    // Kiểm tra xem member đã check-in hôm nay chưa
                                    boolean hasCheckedInToday = false;
                                    if (schedule.getMember() != null) {
                                        List<Checkin> memberCheckins = checkinService.getCheckinHistoryByMemberId(schedule.getMember().getId());
                                        hasCheckedInToday = memberCheckins.stream()
                                            .anyMatch(c -> c.getCheckinDate() != null && c.getCheckinDate().isEqual(java.time.LocalDate.now()));
                                    }
                                %>
                                    <tr>
                                        <td class="text-center"><%= stt++ %></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar avatar-sm bg-gradient-primary rounded-circle me-2">
                                                    <i class="fas fa-user text-white"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 text-sm"><%= schedule.getMember().getFullName() != null ? schedule.getMember().getFullName() : schedule.getMember().getUserName() %></h6>
                                                    <small class="text-muted">ID: <%= schedule.getMember().getId() %></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <%= schedule.getScheduleTime() != null ? schedule.getScheduleTime().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm")) : "" %>
                                        </td>
                                        <td class="text-center">
                                            <% if (schedule.getDurationHours() != null) { %>
                                                <% 
                                                java.math.BigDecimal duration = schedule.getDurationHours();
                                                int hours = duration.intValue();
                                                int minutes = duration.remainder(java.math.BigDecimal.ONE).multiply(new java.math.BigDecimal("60")).intValue();
                                                if (hours == 0) {
                                                    out.print(minutes + " phút");
                                                } else if (minutes == 0) {
                                                    out.print(hours + " giờ");
                                                } else {
                                                    out.print(hours + " giờ " + minutes + " phút");
                                                }
                                                %>
                                            <% } else { %>
                                                <span class="text-muted">-</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <% String status = schedule.getStatus(); %>
                                            <% if ("Pending".equals(status)) { %>
                                                <span class="badge bg-gradient-warning text-dark">Chờ xác nhận</span>
                                            <% } else if ("Confirmed".equals(status)) { %>
                                                <span class="badge bg-gradient-success">Đã xác nhận</span>
                                            <% } else { %>
                                                <span class="badge bg-gradient-secondary"><%= status %></span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <% if (hasCheckedInToday) { %>
                                                <span class="badge bg-gradient-info">
                                                    <i class="fas fa-check me-1"></i>Đã check-in
                                                </span>
                                            <% } else { %>
                                                <span class="badge bg-gradient-warning">
                                                    <i class="fas fa-clock me-1"></i>Chưa check-in
                                                </span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <% if (hasCheckedInToday) { %>
                                                <button class="btn btn-secondary btn-sm" disabled>
                                                    <i class="fas fa-check me-1"></i>Đã check-in
                                                </button>
                                            <% } else { %>
                                                <form method="post" action="checkin" style="display:inline;">
                                                    <input type="hidden" name="userId" value="<%= schedule.getMember().getId() %>" />
                                                    <input type="hidden" name="scheduleId" value="<%= schedule.getId() %>" />
                                                    <button type="submit" class="btn btn-success btn-sm">
                                                        <i class="fas fa-sign-in-alt me-1"></i>Check-in
                                                    </button>
                                                </form>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="card mb-4">
                    <div class="card-header bg-warning text-dark">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Không có lịch tập hôm nay
                    </div>
                </div>
                <% } %>
                
                <%-- Tra cứu lịch sử check-in cho admin --%>
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-search me-2"></i>
                        Tra cứu lịch sử check-in (Dành cho Admin)
                    </div>
                    <div class="card-body">
                        <form method="get" action="checkinHistory" class="row g-2 align-items-end">
                            <div class="col-md-6 col-12 mb-2">
                                <label for="searchUserId" class="form-label fw-bold mb-1">Chọn Member để xem lịch sử check-in</label>
                                <select class="form-select" id="searchUserId" name="userId" required>
                                    <option value="">-- Chọn tên Member --</option>
                                    <% 
                                    // Phân loại Member có lịch tập hôm nay và không có
                                    java.util.List<User> membersWithScheduleToday = new java.util.ArrayList<>();
                                    java.util.List<User> allMembers = new java.util.ArrayList<>();
                                    
                                    if (userList != null) {
                                        for (User u : userList) {
                                            if ("Member".equals(u.getRole())) {
                                                allMembers.add(u);
                                                // Kiểm tra xem Member có lịch tập hôm nay không
                                                if (schedulesToday != null) {
                                                    boolean hasScheduleToday = schedulesToday.stream()
                                                        .anyMatch(s -> s.getMember() != null && s.getMember().getId().equals(u.getId()));
                                                    if (hasScheduleToday) {
                                                        membersWithScheduleToday.add(u);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    %>
                                    <% if (!membersWithScheduleToday.isEmpty()) { %>
                                    <optgroup label="&#128100; Member có lịch tập hôm nay (<%= java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>)">
                                    <% for (User u : membersWithScheduleToday) { %>
                                        <option value="<%= u.getId() %>" <%= (request.getParameter("userId") != null && request.getParameter("userId").equals(u.getId().toString())) ? "selected" : "" %>>
                                            &#128100; <%= u.getFullName() != null ? u.getFullName() : u.getUserName() %>
                                        </option>
                                    <% } %>
                                    </optgroup>
                                    <% } %>
                                    <% 
                                    // Tạo danh sách Member không có lịch tập hôm nay
                                    java.util.List<User> membersWithoutScheduleToday = allMembers.stream()
                                        .filter(u -> !membersWithScheduleToday.contains(u))
                                        .collect(java.util.stream.Collectors.toList());
                                    %>
                                    <% if (!membersWithoutScheduleToday.isEmpty()) { %>
                                    <optgroup label="&#128101; Member khác">
                                    <% for (User u : membersWithoutScheduleToday) { %>
                                        <option value="<%= u.getId() %>" <%= (request.getParameter("userId") != null && request.getParameter("userId").equals(u.getId().toString())) ? "selected" : "" %>>
                                            &#128101; <%= u.getFullName() != null ? u.getFullName() : u.getUserName() %>
                                        </option>
                                    <% } %>
                                    </optgroup>
                                    <% } %>
                                </select>
                                <div class="form-text text-muted mt-1 ms-1">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Chọn Member để xem lịch sử check-in. Member có lịch tập hôm nay sẽ được hiển thị ở đầu danh sách.
                                </div>
                            </div>
                            <div class="col-md-2 col-12 mb-2">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fa fa-search me-1"></i>Tra cứu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                <style>
                    .card.mb-4 { border-radius: 0.75rem; }
                    .card-header.bg-primary { border-radius: 0.75rem 0.75rem 0 0; font-weight: 600; }
                </style>
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0"><i class="fas fa-history me-2"></i>Lịch sử Check-In
                        <% if (selectedUserId != null && member != null) { %>
                            - <span class="text-primary"><%= member.getFullName() != null ? member.getFullName() : member.getUserName() %></span>
                        <% } %>
                        </h6>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        <%-- Bộ lọc ngày để xem lịch sử check-in --%>
                        <% if (selectedUserId != null) { %>
                        <div class="mb-3 d-flex align-items-center gap-2">
                            <form method="get" action="checkinHistory" class="d-flex align-items-center gap-2">
                                <input type="hidden" name="userId" value="<%= selectedUserId %>" />
                                <label for="filterDate" class="mb-0 fw-bold">Xem lịch sử ngày:</label>
                                <input type="date" id="filterDate" name="filterDate" class="form-control form-control-sm" style="width: 180px;" value="<%= request.getParameter("filterDate") != null ? request.getParameter("filterDate") : "" %>" />
                                <button type="submit" class="btn btn-outline-primary btn-sm ms-2"><i class="fa fa-search me-1"></i>Xem</button>
                            </form>
                            <% if (request.getParameter("filterDate") != null && !request.getParameter("filterDate").isEmpty()) { %>
                                <a href="checkinHistory?userId=<%= selectedUserId %>" class="btn btn-link btn-sm ms-2">Xem tất cả</a>
                            <% } %>
                        </div>
                        <% } %>
                        <%-- Hiển thị bảng lịch sử check-in khi admin chọn user + ngày --%>
                        <% if (selectedUserId != null) { %>
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                    <tr>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">STT</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày Check-In</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Giờ Check-In</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% if (checkinList != null && !checkinList.isEmpty()) {
                                    int stt = 1;
                                    for (Checkin c : checkinList) {
                                        if (filterDate == null || (c.getCheckinDate() != null && c.getCheckinDate().isEqual(filterDate))) { %>
                                        <tr>
                                            <td><%= stt++ %></td>
                                            <td><%= c.getCheckinDate() != null ? c.getCheckinDate().format(dateFormatter) : "" %></td>
                                            <td><%= c.getCheckinTime() != null ? c.getCheckinTime().format(timeFormatter) : "" %></td>
                                            <td>
                                                <% if (c.getStatus() != null) { %>
                                                    <span class="badge bg-gradient-info"><%= c.getStatus() %></span>
                                                <% } %>
                                            </td>
                                        </tr>
                                <%      }
                                    }
                                   } else { %>
                                    <tr><td colspan="4" class="text-center py-4">Không có dữ liệu check-in</td></tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>

                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Core JS Files -->
<script src="./assets/js/core/popper.min.js"></script>
<script src="./assets/js/core/bootstrap.min.js"></script>
<script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
<script src="./assets/js/plugins/smooth-scrollbar.min.js"></script>
<script src="./assets/js/argon-dashboard.min.js?v=2.1.0"></script>

</body>
</html>

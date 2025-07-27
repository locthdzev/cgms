<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.User"%>
<%@page import="Models.Schedule"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.DayOfWeek"%>
<%@page import="java.time.temporal.TemporalAdjusters"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.stream.Collectors"%>
<%
    List<Schedule> scheduleList = (List<Schedule>) request.getAttribute("scheduleList");
    Schedule schedule = (Schedule) request.getAttribute("schedule");
    String formAction = (String) request.getAttribute("formAction");
    if (formAction == null) formAction = "list";
    
    List<User> trainers = (List<User>) request.getAttribute("trainers");
    List<User> members = (List<User>) request.getAttribute("members");
    
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
    // Lấy thông báo từ request hoặc session
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
    
    // Định dạng ngày tháng
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    
    // Xử lý lịch tháng
    LocalDate currentDate = LocalDate.now();
    String monthParam = request.getParameter("month");
    String yearParam = request.getParameter("year");
    
    if (monthParam != null && yearParam != null) {
        try {
            currentDate = LocalDate.of(Integer.parseInt(yearParam), Integer.parseInt(monthParam), 1);
        } catch (Exception e) {
            currentDate = LocalDate.now();
        }
    }
    
    LocalDate firstDayOfMonth = currentDate.withDayOfMonth(1);
    LocalDate lastDayOfMonth = currentDate.with(TemporalAdjusters.lastDayOfMonth());
    LocalDate firstDayOfCalendar = firstDayOfMonth.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
    LocalDate lastDayOfCalendar = lastDayOfMonth.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
    
    // Nhóm lịch tập theo ngày
    Map<LocalDate, List<Schedule>> schedulesByDate = new HashMap<>();
    if (scheduleList != null) {
        schedulesByDate = scheduleList.stream()
            .collect(Collectors.groupingBy(s -> s.getScheduleDate()));
    }
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Quản lý lịch tập - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
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
        
        /* Toast styles */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
        
        .toast {
            min-width: 300px;
        }
        
        /* Calendar styles */
        .calendar-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .calendar-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .calendar-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .calendar-nav button {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .calendar-nav button:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        
        .calendar-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }
        
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background: #e9ecef;
        }
        
        .calendar-day-header {
            background: #f8f9fa;
            padding: 15px 10px;
            text-align: center;
            font-weight: 600;
            color: #495057;
            font-size: 0.875rem;
        }
        
        .calendar-day {
            background: white;
            min-height: 120px;
            padding: 10px;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .calendar-day:hover {
            background: #f8f9fa;
        }
        
        .calendar-day.other-month {
            background: #f8f9fa;
            color: #adb5bd;
        }
        
        .calendar-day.today {
            background: #e3f2fd;
            border: 2px solid #2196f3;
        }
        
        .day-number {
            font-weight: 600;
            font-size: 1.1rem;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .calendar-day.other-month .day-number {
            color: #adb5bd;
        }
        
        .schedule-item {
            background: #e8f5e8;
            border-left: 3px solid #28a745;
            padding: 5px 8px;
            margin-bottom: 5px;
            border-radius: 3px;
            font-size: 0.75rem;
            cursor: pointer;
            transition: all 0.3s ease;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .schedule-item:hover {
            background: #d4edda;
            transform: translateY(-1px);
        }
        
        .schedule-item.pending {
            background: #fff3cd;
            border-left-color: #ffc107;
        }
        
        .schedule-item.confirmed {
            background: #d1ecf1;
            border-left-color: #17a2b8;
        }
        
        .schedule-item.completed {
            background: #d4edda;
            border-left-color: #28a745;
        }
        
        .schedule-item.cancelled {
            background: #f8d7da;
            border-left-color: #dc3545;
        }
        
        .schedule-time {
            font-weight: 600;
            color: #495057;
        }
        
        .schedule-participants {
            color: #6c757d;
            font-size: 0.7rem;
        }
        
        .more-schedules {
            background: #e9ecef;
            color: #6c757d;
            text-align: center;
            padding: 3px;
            border-radius: 3px;
            font-size: 0.7rem;
            cursor: pointer;
        }
        
        .calendar-legend {
            display: flex;
            justify-content: center;
            gap: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.875rem;
        }
        
        .legend-color {
            width: 12px;
            height: 12px;
            border-radius: 2px;
        }
        
        /* Modal styles */
        .modal-dialog {
            max-width: 600px;
        }
        
        .schedule-detail {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }
        
        .schedule-detail h6 {
            color: #495057;
            margin-bottom: 5px;
        }
        
        .schedule-detail p {
            margin-bottom: 10px;
            color: #6c757d;
        }
        
        /* Status badge styles */
        .status-pending {
            background: linear-gradient(135deg, #ffc107, #ffb300) !important;
        }
        
        .status-confirmed {
            background: linear-gradient(135deg, #28a745, #20c997) !important;
        }
        
        .status-completed {
            background: linear-gradient(135deg, #17a2b8, #138496) !important;
        }
        
        .status-cancelled {
            background: linear-gradient(135deg, #dc3545, #c82333) !important;
        }
        
        /* Dropdown fixes */
        .dropdown-menu {
            z-index: 1050 !important;
            min-width: 160px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
        }

        .dropdown-menu.show {
            display: block !important;
        }

        .dropdown-toggle::after {
            display: none;
        }

        .btn-icon-only {
            width: 32px;
            height: 32px;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .calendar-grid {
                grid-template-columns: repeat(7, 1fr);
            }
            
            .calendar-day {
                min-height: 80px;
                padding: 5px;
            }
            
            .day-number {
                font-size: 0.9rem;
            }
            
            .schedule-item {
                font-size: 0.65rem;
                padding: 3px 5px;
            }
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>

<!-- Toast Container -->
<div class="toast-container">
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

<!-- Include Sidebar Component -->
<%@ include file="sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Quản lý lịch tập" />
        <jsp:param name="parentPage" value="Dashboard" />
        <jsp:param name="parentPageUrl" value="dashboard.jsp" />
        <jsp:param name="currentPage" value="Quản lý lịch tập" />
    </jsp:include>
    
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <% if (scheduleList != null) { %>
                
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6>Lịch tập tháng</h6>
                        <div>
                            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <a href="${pageContext.request.contextPath}/addSchedule" class="btn btn-primary btn-sm me-2">
                                <i class="fas fa-plus me-2"></i>Thêm lịch tập cho member
                            </a>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="calendar-container">
                            <!-- Calendar Header -->
                            <div class="calendar-header">
                                <div class="calendar-nav">
                                    <button onclick="changeMonth(-1)">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <h2 class="calendar-title">
                                        <%= currentDate.getMonth().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.forLanguageTag("vi")) %> <%= currentDate.getYear() %>
                                    </h2>
                                    <button onclick="changeMonth(1)">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Calendar Grid -->
                            <div class="calendar-grid">
                                <!-- Day Headers -->
                                <div class="calendar-day-header">T2</div>
                                <div class="calendar-day-header">T3</div>
                                <div class="calendar-day-header">T4</div>
                                <div class="calendar-day-header">T5</div>
                                <div class="calendar-day-header">T6</div>
                                <div class="calendar-day-header">T7</div>
                                <div class="calendar-day-header">CN</div>
                                
                                <!-- Calendar Days -->
                                <% 
                                LocalDate currentDay = firstDayOfCalendar;
                                while (!currentDay.isAfter(lastDayOfCalendar)) {
                                    boolean isCurrentMonth = currentDay.getMonth() == currentDate.getMonth();
                                    boolean isToday = currentDay.equals(LocalDate.now());
                                    List<Schedule> daySchedules = schedulesByDate.get(currentDay);
                                %>
                                    <div class="calendar-day <%= !isCurrentMonth ? "other-month" : "" %> <%= isToday ? "today" : "" %>">
                                        <div class="day-number"><%= currentDay.getDayOfMonth() %></div>
                                        
                                        <% if (daySchedules != null && !daySchedules.isEmpty()) { %>
                                            <% 
                                            int maxDisplay = 3;
                                            for (int i = 0; i < Math.min(daySchedules.size(), maxDisplay); i++) {
                                                Schedule s = daySchedules.get(i);
                                                String statusClass = s.getStatus().toLowerCase();
                                            %>
                                                <div class="schedule-item <%= statusClass %>" 
                                                     onclick="viewSchedule('<%= s.getId() %>', '<%= s.getTrainer().getFullName() != null ? s.getTrainer().getFullName() : s.getTrainer().getUserName() %>', '<%= s.getMember().getFullName() != null ? s.getMember().getFullName() : s.getMember().getUserName() %>', '<%= s.getScheduleDate().format(dateFormatter) %>', '<%= s.getScheduleTime().format(timeFormatter) %>', '<%= s.getDurationHours() %>', '<%= s.getStatus() %>', '<%= s.getCreatedAt() != null ? s.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "" %>')">
                                                    <div class="schedule-time"><%= s.getScheduleTime().format(timeFormatter) %></div>
                                                    <div class="schedule-participants">
                                                        <%= s.getTrainer().getFullName() != null ? s.getTrainer().getFullName() : s.getTrainer().getUserName() %> - <%= s.getMember().getFullName() != null ? s.getMember().getFullName() : s.getMember().getUserName() %>
                                                    </div>
                                                </div>
                                            <% } %>
                                            
                                            <% if (daySchedules.size() > maxDisplay) { %>
                                                <div class="more-schedules" onclick="viewDaySchedules('<%= currentDay.format(dateFormatter) %>', <%= daySchedules.size() %>)">
                                                    +<%= daySchedules.size() - maxDisplay %> lịch tập khác
                                                </div>
                                            <% } %>
                                        <% } %>
                                    </div>
                                <% 
                                    currentDay = currentDay.plusDays(1);
                                } 
                                %>
                            </div>
                            
                            <!-- Calendar Legend -->
                            <div class="calendar-legend">
                                <div class="legend-item">
                                    <div class="legend-color" style="background: #e8f5e8; border-left: 3px solid #28a745;"></div>
                                    <span>Hoàn thành</span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-color" style="background: #d1ecf1; border-left: 3px solid #17a2b8;"></div>
                                    <span>Đã xác nhận</span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-color" style="background: #fff3cd; border-left: 3px solid #ffc107;"></div>
                                    <span>Chờ xác nhận</span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-color" style="background: #f8d7da; border-left: 3px solid #dc3545;"></div>
                                    <span>Đã hủy</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <% } else { %>
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6><%= ("create".equals(formAction) ? "Thêm lịch tập mới" : ("edit".equals(formAction) ? "Chỉnh sửa lịch tập" : "Chi tiết lịch tập")) %></h6>
                        <a href="${pageContext.request.contextPath}/schedule" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                        </a>
                    </div>
                    <div class="card-body">
                        
                        <form method="post" id="multiScheduleForm">
                            <input type="hidden" name="formAction" value="<%= formAction %>"/>
                            <% if ("edit".equals(formAction) && schedule != null) { %>
                                <input type="hidden" name="id" value="<%= schedule.getId() %>"/>
                            <% } %>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trainer *</label>
                                    <select name="trainerId" class="form-control" required>
                                        <option value="">Chọn Trainer</option>
                                        <% if (trainers != null) {
                                            for (User trainer : trainers) { %>
                                                <option value="<%= trainer.getId() %>" 
                                                    <% if ("edit".equals(formAction) && schedule != null && schedule.getTrainer() != null && schedule.getTrainer().getId() != null && schedule.getTrainer().getId().equals(trainer.getId())) { %>selected<% } %>>
                                                    <%= trainer.getFullName() != null ? trainer.getFullName() : trainer.getUserName() %>
                                                </option>
                                        <% } } %>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Member *</label>
                                    <select name="memberId" class="form-control" required>
                                        <option value="">Chọn Member</option>
                                        <% if (members != null) {
                                            for (User member : members) { %>
                                                <option value="<%= member.getId() %>"
                                                    <% if ("edit".equals(formAction) && schedule != null && schedule.getMember() != null && schedule.getMember().getId() != null && schedule.getMember().getId().equals(member.getId())) { %>selected<% } %>>
                                                    <%= member.getFullName() != null ? member.getFullName() : member.getUserName() %>
                                                </option>
                                        <% } } %>
                                    </select>
                                </div>
                            </div>
                            <div id="scheduleRows">
                                <% if ("edit".equals(formAction) && schedule != null) { %>
                                    <!-- Form chỉnh sửa - chỉ hiển thị 1 dòng -->
                                    <div class="row schedule-row mb-2">
                                        <div class="col-md-3 mb-2">
                                            <input type="date" name="scheduleDate" class="form-control" required 
                                                value="<%= schedule.getScheduleDate() != null ? schedule.getScheduleDate().toString() : "" %>" />
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <input type="time" name="scheduleTime" class="form-control" required 
                                                value="<%= schedule.getScheduleTime() != null ? schedule.getScheduleTime().toString() : "" %>" />
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <select name="durationHours" class="form-control" required>
                                                <% for (double i = 0.5; i <= 3.0; i += 0.5) { 
                                                    int hours = (int) i;
                                                    int minutes = (int) ((i - hours) * 60);
                                                    String label = "";
                                                    if (hours > 0 && minutes > 0) {
                                                        label = hours + " giờ " + minutes + " phút";
                                                    } else if (hours > 0) {
                                                        label = hours + " giờ";
                                                    } else {
                                                        label = minutes + " phút";
                                                    }
                                                    boolean selected = schedule.getDurationHours() != null && schedule.getDurationHours().doubleValue() == i;
                                                %>
                                                    <option value="<%= i %>" <% if (selected) { %>selected<% } %>><%= label %></option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <div class="col-md-2 mb-2">
                                            <select name="status" class="form-control" required>
                                                <option value="Pending" <% if ("Pending".equals(schedule.getStatus())) { %>selected<% } %>>Chờ xác nhận</option>
                                                <option value="Confirmed" <% if ("Confirmed".equals(schedule.getStatus())) { %>selected<% } %>>Đã xác nhận</option>
                                                <option value="Completed" <% if ("Completed".equals(schedule.getStatus())) { %>selected<% } %>>Hoàn thành</option>
                                                <option value="Cancelled" <% if ("Cancelled".equals(schedule.getStatus())) { %>selected<% } %>>Đã hủy</option>
                                            </select>
                                        </div>
                                        <div class="col-md-1 mb-2 d-flex align-items-center">
                                            <!-- Không có nút xóa cho form chỉnh sửa -->
                                        </div>
                                    </div>
                                <% } else { %>
                                    <!-- Form tạo mới - có thể thêm nhiều dòng -->
                                    <div class="row schedule-row mb-2">
                                        <div class="col-md-3 mb-2">
                                            <input type="date" name="scheduleDate" class="form-control" required />
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <input type="time" name="scheduleTime" class="form-control" required />
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <select name="durationHours" class="form-control" required>
                                                <% for (double i = 0.5; i <= 3.0; i += 0.5) { 
                                                    int hours = (int) i;
                                                    int minutes = (int) ((i - hours) * 60);
                                                    String label = "";
                                                    if (hours > 0 && minutes > 0) {
                                                        label = hours + " giờ " + minutes + " phút";
                                                    } else if (hours > 0) {
                                                        label = hours + " giờ";
                                                    } else {
                                                        label = minutes + " phút";
                                                    }
                                                %>
                                                    <option value="<%= i %>"><%= label %></option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <div class="col-md-2 mb-2">
                                            <select name="status" class="form-control" required>
                                                <option value="Pending">Chờ xác nhận</option>
                                                <option value="Confirmed">Đã xác nhận</option>
                                                <option value="Completed">Hoàn thành</option>
                                                <option value="Cancelled">Đã hủy</option>
                                            </select>
                                        </div>
                                        <div class="col-md-1 mb-2 d-flex align-items-center">
                                            <button type="button" class="btn btn-danger btn-sm remove-row" onclick="removeScheduleRow(this)" style="display:none;">&times;</button>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                            <% if (!"edit".equals(formAction)) { %>
                            <div class="mb-3">
                                <button type="button" class="btn btn-secondary btn-sm" onclick="addScheduleRow()"><i class="fas fa-plus me-1"></i>Thêm dòng</button>
                            </div>
                            <% } %>
                            <div class="d-flex justify-content-end mt-4">
                                <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                <button class="btn btn-primary" type="submit">
                                    <% if ("edit".equals(formAction)) { %>
                                        Cập nhật lịch tập
                                    <% } else { %>
                                        Lưu tất cả
                                    <% } %>
                                </button>
                            </div>
                        </form>
                        <script>
                        function addScheduleRow() {
                            var row = document.querySelector('.schedule-row');
                            var clone = row.cloneNode(true);
                            // Reset input values
                            clone.querySelectorAll('input, select').forEach(function(input) {
                                if (input.type === 'date' || input.type === 'time') input.value = '';
                                else if (input.tagName === 'SELECT') input.selectedIndex = 0;
                            });
                            clone.querySelector('.remove-row').style.display = 'inline-block';
                            document.getElementById('scheduleRows').appendChild(clone);
                        }
                        function removeScheduleRow(btn) {
                            var row = btn.closest('.schedule-row');
                            row.parentNode.removeChild(row);
                        }
                        </script>
                    </div>
                </div>
                <% } %>

                <!-- Modal xem chi tiết lịch tập -->
                <div class="modal fade" id="viewScheduleModal" tabindex="-1" aria-labelledby="viewScheduleModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="viewScheduleModalLabel">Chi tiết lịch tập</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Thông tin cơ bản -->
                                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                                    <div>
                                        <h4 id="scheduleTitle" class="fw-bold mb-0"></h4>
                                        <div class="d-flex align-items-center mt-1">
                                            <span id="viewScheduleStatus" class="badge me-2"></span>
                                            <span id="scheduleDuration" class="text-sm"></span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Thông tin chi tiết -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <h6 class="mb-2 detail-label">Trainer</h6>
                                        <p id="scheduleTrainer" class="text-sm"></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h6 class="mb-2 detail-label">Member</h6>
                                        <p id="scheduleMember" class="text-sm"></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h6 class="mb-2 detail-label">Ngày tập</h6>
                                        <p id="scheduleDate" class="text-sm"></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h6 class="mb-2 detail-label">Giờ tập</h6>
                                        <p id="scheduleTime" class="text-sm"></p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h6 class="mb-2 detail-label">Ngày tạo</h6>
                                        <p id="scheduleCreatedAt" class="text-sm"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                                <a href="#" id="editScheduleBtn" class="btn btn-primary">Chỉnh sửa</a>
                                <button type="button" id="deleteScheduleBtn" class="btn btn-danger">Xóa</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal xem lịch tập theo ngày -->
                <div class="modal fade" id="viewDaySchedulesModal" tabindex="-1" aria-labelledby="viewDaySchedulesModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="viewDaySchedulesModalLabel">Lịch tập ngày <span id="selectedDate"></span></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div id="daySchedulesList">
                                    <!-- Schedules will be loaded here -->
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal xác nhận xóa lịch tập -->
                <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="deleteConfirmModalLabel">Xác nhận xóa</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <p>Bạn có chắc chắn muốn xóa lịch tập "<span id="scheduleInfoToDelete"></span>"?</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
                            </div>
                        </div>
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

<script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Schedule page loaded');

        // Kiểm tra Bootstrap
        if (typeof bootstrap === 'undefined') {
            console.error('Bootstrap is not loaded!');
        } else {
            console.log('Bootstrap loaded successfully');
        }

        // Hiển thị toast thông báo nếu có
        if (document.getElementById('successToast')) {
            var successToast = new bootstrap.Toast(document.getElementById('successToast'), {
                delay: 5000,
                animation: true
            });
            successToast.show();
        }

        if (document.getElementById('errorToast')) {
            var errorToast = new bootstrap.Toast(document.getElementById('errorToast'), {
                delay: 5000,
                animation: true
            });
            errorToast.show();
        }
    });

    // Function to change month
    function changeMonth(direction) {
        const urlParams = new URLSearchParams(window.location.search);
        let currentMonth = parseInt(urlParams.get('month')) || new Date().getMonth() + 1;
        let currentYear = parseInt(urlParams.get('year')) || new Date().getFullYear();
        
        currentMonth += direction;
        
        if (currentMonth > 12) {
            currentMonth = 1;
            currentYear++;
        } else if (currentMonth < 1) {
            currentMonth = 12;
            currentYear--;
        }
        
        const newUrl = new URL(window.location);
        newUrl.searchParams.set('month', currentMonth);
        newUrl.searchParams.set('year', currentYear);
        window.location.href = newUrl.toString();
    }

    // --- Thêm biến toàn cục để lưu trạng thái modal chi tiết ---
    var lastViewedSchedule = null;

    // Function to view schedule details
    function viewSchedule(id, trainer, member, date, time, duration, status, createdAt) {
        lastViewedSchedule = {
            id, trainer, member, date, time, duration, status, createdAt
        };
        document.getElementById('scheduleTitle').textContent = trainer + ' - ' + member;
        document.getElementById('scheduleTrainer').textContent = trainer;
        document.getElementById('scheduleMember').textContent = member;
        document.getElementById('scheduleDate').textContent = date;
        document.getElementById('scheduleTime').textContent = time;
        // Hiển thị thời lượng đúng định dạng
        var dur = parseFloat(duration);
        var hours = Math.floor(dur);
        var minutes = Math.round((dur - hours) * 60);
        var durationText = '';
        if (hours > 0) durationText += hours + ' giờ';
        if (minutes > 0) durationText += (hours > 0 ? ' ' : '') + minutes + ' phút';
        if (durationText === '') durationText = '0 phút';
        document.getElementById('scheduleDuration').textContent = durationText;
        document.getElementById('scheduleCreatedAt').textContent = createdAt || 'Không có thông tin';

        // Cập nhật trạng thái với badge
        const statusBadge = document.getElementById('viewScheduleStatus');
        statusBadge.textContent = getStatusText(status);

        // Cập nhật class cho badge dựa trên trạng thái
        statusBadge.className = 'badge me-2';
        if (status === 'Pending') {
            statusBadge.classList.add('status-pending');
        } else if (status === 'Confirmed') {
            statusBadge.classList.add('status-confirmed');
        } else if (status === 'Completed') {
            statusBadge.classList.add('status-completed');
        } else if (status === 'Cancelled') {
            statusBadge.classList.add('status-cancelled');
        } else {
            statusBadge.classList.add('bg-gradient-secondary');
        }

        // Cập nhật link chỉnh sửa
        document.getElementById('editScheduleBtn').href = '${pageContext.request.contextPath}/editSchedule?id=' + id;

        // Cập nhật nút xóa
        const deleteBtn = document.getElementById('deleteScheduleBtn');
        deleteBtn.onclick = function() {
            showDeleteConfirm(id, trainer + ' - ' + member);
        };

        var viewModal = new bootstrap.Modal(document.getElementById('viewScheduleModal'));
        viewModal.show();
    }

    // Function to show delete confirmation
    function showDeleteConfirm(id, scheduleInfo) {
        // Đóng modal chi tiết nếu đang mở
        var viewModalEl = document.getElementById('viewScheduleModal');
        if (viewModalEl) {
            var viewModal = bootstrap.Modal.getInstance(viewModalEl);
            if (viewModal) viewModal.hide();
        }
        document.getElementById('scheduleInfoToDelete').textContent = scheduleInfo;
        document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/schedule?action=delete&id=' + id;
        var deleteModalEl = document.getElementById('deleteConfirmModal');
        var deleteModal = new bootstrap.Modal(deleteModalEl);
        deleteModal.show();

        // Khi modal xác nhận xóa bị đóng, mở lại modal chi tiết nếu có
        deleteModalEl.addEventListener('hidden.bs.modal', function handler() {
            if (lastViewedSchedule) {
                viewSchedule(
                    lastViewedSchedule.id,
                    lastViewedSchedule.trainer,
                    lastViewedSchedule.member,
                    lastViewedSchedule.date,
                    lastViewedSchedule.time,
                    lastViewedSchedule.duration,
                    lastViewedSchedule.status,
                    lastViewedSchedule.createdAt
                );
            }
            // Xóa event handler sau khi chạy để tránh lặp
            deleteModalEl.removeEventListener('hidden.bs.modal', handler);
        });
    }

    // Function to view day schedules
    function viewDaySchedules(date, count) {
        document.getElementById('selectedDate').textContent = date;
        
        // Load schedules for this day
        const schedulesList = document.getElementById('daySchedulesList');
        schedulesList.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải...</div>';
        
        // Here you would typically make an AJAX call to get schedules for the specific date
        // For now, we'll show a placeholder
        setTimeout(() => {
            schedulesList.innerHTML = `
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Có ${count} lịch tập trong ngày ${date}. Chức năng này sẽ được phát triển thêm.
                </div>
            `;
        }, 1000);

        var dayModal = new bootstrap.Modal(document.getElementById('viewDaySchedulesModal'));
        dayModal.show();
    }

    // Helper function to get status text
    function getStatusText(status) {
        switch(status) {
            case 'Pending': return 'Chờ xác nhận';
            case 'Confirmed': return 'Đã xác nhận';
            case 'Completed': return 'Hoàn thành';
            case 'Cancelled': return 'Đã hủy';
            default: return status;
        }
    }
</script>

</body>
</html>
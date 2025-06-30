<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.User"%>
<%@page import="Models.Schedule"%>
<%@page import="java.time.format.DateTimeFormatter"%>
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
        
        /* Detail styles */
        .detail-label {
            font-weight: 600;
            color: #344767;
        }
        
        /* Delete button style */
        .delete-action {
            color: #f5365c !important;
        }
        
        .delete-action:hover {
            background-color: #ffeef1 !important;
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
                        <h6>Danh sách lịch tập</h6>
                        <div>
                            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <a href="${pageContext.request.contextPath}/addSchedule" class="btn btn-primary btn-sm">
                                <i class="fas fa-plus me-2"></i>Thêm lịch tập
                            </a>
                        </div>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                <tr>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">ID</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Trainer</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Member</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Ngày tập</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Giờ tập</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Thời lượng</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Trạng thái</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                if (scheduleList != null && !scheduleList.isEmpty()) {
                                    for (Schedule s : scheduleList) {
                                %>
                                    <tr>
                                        <td class="text-center"><h6 class="mb-0 text-sm"><%= s.getId() %></h6></td>
                                        <td class="ps-2">
                                            <h6 class="mb-0 text-sm"><%= s.getTrainer().getFullName() != null ? s.getTrainer().getFullName() : s.getTrainer().getUserName() %></h6>
                                        </td>
                                        <td class="ps-2">
                                            <h6 class="mb-0 text-sm"><%= s.getMember().getFullName() != null ? s.getMember().getFullName() : s.getMember().getUserName() %></h6>
                                        </td>
                                        <td class="ps-2">
                                            <h6 class="mb-0 text-sm"><%= s.getScheduleDate().format(dateFormatter) %></h6>
                                        </td>
                                        <td class="ps-2">
                                            <h6 class="mb-0 text-sm"><%= s.getScheduleTime().format(timeFormatter) %></h6>
                                        </td>
                                        <td class="ps-2">
                                            <h6 class="mb-0 text-sm">
                                                <% 
                                                    double d = s.getDurationHours() != null ? s.getDurationHours().doubleValue() : 0;
                                                    int hours = (int) d;
                                                    int minutes = (int) ((d - hours) * 60);
                                                    String label = "";
                                                    if (hours > 0 && minutes > 0) {
                                                        label = hours + " giờ " + minutes + " phút";
                                                    } else if (hours > 0) {
                                                        label = hours + " giờ";
                                                    } else if (minutes > 0) {
                                                        label = minutes + " phút";
                                                    } else {
                                                        label = "-";
                                                    }
                                                %>
                                                <%= label %>
                                            </h6>
                                        </td>
                                        <td class="ps-2">
                                            <% 
                                                String statusClass = "";
                                                String statusText = "";
                                                switch(s.getStatus()) {
                                                    case "Pending":
                                                        statusClass = "status-pending";
                                                        statusText = "Chờ xác nhận";
                                                        break;
                                                    case "Confirmed":
                                                        statusClass = "status-confirmed";
                                                        statusText = "Đã xác nhận";
                                                        break;
                                                    case "Completed":
                                                        statusClass = "status-completed";
                                                        statusText = "Hoàn thành";
                                                        break;
                                                    case "Cancelled":
                                                        statusClass = "status-cancelled";
                                                        statusText = "Đã hủy";
                                                        break;
                                                    default:
                                                        statusClass = "bg-gradient-secondary";
                                                        statusText = s.getStatus();
                                                }
                                            %>
                                            <span class="badge badge-sm <%= statusClass %>"><%= statusText %></span>
                                        </td>
                                        <td class="text-center">
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-icon-only text-dark dropdown-toggle" type="button" id="dropdownMenuButton<%= s.getId() %>" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
                                                    <i class="fas fa-ellipsis-v"></i>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton<%= s.getId() %>"
                                                    <li><a class="dropdown-item view-schedule-btn" href="#" 
                                                            data-id="<%= s.getId() %>"
                                                            data-trainer="<%= s.getTrainer().getFullName() != null ? s.getTrainer().getFullName() : s.getTrainer().getUserName() %>"
                                                            data-member="<%= s.getMember().getFullName() != null ? s.getMember().getFullName() : s.getMember().getUserName() %>"
                                                            data-date="<%= s.getScheduleDate().format(dateFormatter) %>"
                                                            data-time="<%= s.getScheduleTime().format(timeFormatter) %>"
                                                            data-duration="<%= s.getDurationHours() %>"
                                                            data-status="<%= statusText %>"
                                                            data-created="<%= s.getCreatedAt() != null ? s.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "" %>">
                                                            <i class="fas fa-eye me-2"></i>Xem chi tiết</a></li>
                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/editSchedule?id=<%= s.getId() %>"><i class="fas fa-edit me-2"></i>Chỉnh sửa</a></li>
                                                    <% if (!"Completed".equals(s.getStatus()) && !"Cancelled".equals(s.getStatus())) { %>
                                                    <li><hr class="dropdown-divider"></li>
                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/schedule?action=updateStatus&id=<%= s.getId() %>&status=Confirmed"><i class="fas fa-check me-2"></i>Xác nhận</a></li>
                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/schedule?action=updateStatus&id=<%= s.getId() %>&status=Completed"><i class="fas fa-check-double me-2"></i>Hoàn thành</a></li>
                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/schedule?action=updateStatus&id=<%= s.getId() %>&status=Cancelled"><i class="fas fa-times me-2"></i>Hủy</a></li>
                                                    <% } %>
                                                    <li><hr class="dropdown-divider"></li>
                                                    <li>
                                                        <a class="dropdown-item delete-schedule-btn delete-action" href="#" 
                                                            data-id="<%= s.getId() %>" 
                                                            data-info="<%= s.getTrainer().getFullName() %> - <%= s.getMember().getFullName() %> (<%= s.getScheduleDate().format(dateFormatter) %>)">
                                                            <i class="fas fa-trash me-2"></i>Xóa
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                    } // end for loop
                                } else {
                                %>
                                    <tr>
                                        <td colspan="8" class="text-center py-4">
                                            <div class="text-muted">
                                                <i class="fas fa-calendar-times fa-3x mb-3"></i>
                                                <h6>Chưa có lịch tập nào</h6>
                                                <p class="mb-0">Hãy thêm lịch tập đầu tiên của bạn!</p>
                                            </div>
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
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6><%= ("create".equals(formAction) ? "Thêm lịch tập mới" : ("edit".equals(formAction) ? "Chỉnh sửa lịch tập" : "Chi tiết lịch tập")) %></h6>
                        <a href="${pageContext.request.contextPath}/schedule" class="btn btn-outline-secondary btn-sm">
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
                        <form method="post">
                            <input type="hidden" name="formAction" value="<%= formAction %>"/>
                            <% if (schedule != null && schedule.getId() != null) { %>
                                <input type="hidden" name="id" value="<%= schedule.getId() %>"/>
                            <% } %>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trainer *</label>
                                    <% if ("view".equals(formAction)) { %>
                                        <input type="text" class="form-control" value="<%= schedule != null && schedule.getTrainer() != null ? (schedule.getTrainer().getFullName() != null ? schedule.getTrainer().getFullName() : schedule.getTrainer().getUserName()) : "" %>" readonly/>
                                    <% } else { %>
                                        <select name="trainerId" class="form-control" required>
                                            <option value="">Chọn Trainer</option>
                                            <% if (trainers != null) {
                                                for (User trainer : trainers) { %>
                                                    <option value="<%= trainer.getId() %>" <%= schedule != null && schedule.getTrainer() != null && schedule.getTrainer().getId().equals(trainer.getId()) ? "selected" : "" %>>
                                                        <%= trainer.getFullName() != null ? trainer.getFullName() : trainer.getUserName() %>
                                                    </option>
                                            <% } } %>
                                        </select>
                                    <% } %>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Member *</label>
                                    <% if ("view".equals(formAction)) { %>
                                        <input type="text" class="form-control" value="<%= schedule != null && schedule.getMember() != null ? (schedule.getMember().getFullName() != null ? schedule.getMember().getFullName() : schedule.getMember().getUserName()) : "" %>" readonly/>
                                    <% } else { %>
                                        <select name="memberId" class="form-control" required>
                                            <option value="">Chọn Member</option>
                                            <% if (members != null) {
                                                for (User member : members) { %>
                                                    <option value="<%= member.getId() %>" <%= schedule != null && schedule.getMember() != null && schedule.getMember().getId().equals(member.getId()) ? "selected" : "" %>>
                                                        <%= member.getFullName() != null ? member.getFullName() : member.getUserName() %>
                                                    </option>
                                            <% } } %>
                                        </select>
                                    <% } %>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày tập *</label>
                                    <input type="date" name="scheduleDate" class="form-control"
                                           value="<%= schedule != null && schedule.getScheduleDate() != null ? schedule.getScheduleDate().toString() : "" %>"
                                           <%= "view".equals(formAction) ? "readonly" : "" %> required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giờ tập *</label>
                                    <input type="time" name="scheduleTime" class="form-control"
                                           value="<%= schedule != null && schedule.getScheduleTime() != null ? schedule.getScheduleTime().toString() : "" %>"
                                           <%= "view".equals(formAction) ? "readonly" : "" %> required/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Thời lượng (giờ) *</label>
                                    <% if ("view".equals(formAction)) { %>
                                        <input type="text" class="form-control" value="<%= schedule != null && schedule.getDurationHours() != null ? schedule.getDurationHours() + " giờ" : "" %>" readonly/>
                                    <% } else { %>
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
                                                <option value="<%= i %>" <%= schedule != null && schedule.getDurationHours() != null && schedule.getDurationHours().doubleValue() == i ? "selected" : "" %>><%= label %></option>
                                            <% } %>
                                        </select>
                                    <% } %>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Trạng thái *</label>
                                    <% if ("view".equals(formAction)) { %>
                                        <input type="text" class="form-control" value="<%= schedule != null && schedule.getStatus() != null ? schedule.getStatus() : "" %>" readonly/>
                                    <% } else { %>
                                        <select name="status" class="form-control" required>
                                            <option value="Pending" <%= schedule != null && "Pending".equals(schedule.getStatus()) ? "selected" : "" %>>Chờ xác nhận</option>
                                            <option value="Confirmed" <%= schedule != null && "Confirmed".equals(schedule.getStatus()) ? "selected" : "" %>>Đã xác nhận</option>
                                            <option value="Completed" <%= schedule != null && "Completed".equals(schedule.getStatus()) ? "selected" : "" %>>Hoàn thành</option>
                                            <option value="Cancelled" <%= schedule != null && "Cancelled".equals(schedule.getStatus()) ? "selected" : "" %>>Đã hủy</option>
                                        </select>
                                    <% } %>
                                </div>
                            </div>
                            <div class="d-flex justify-content-end mt-4">
                                <% if (!"view".equals(formAction)) { %>
                                <button type="reset" class="btn btn-light me-2">Làm mới</button>
                                <button class="btn btn-primary" type="submit">Lưu</button>
                                <% } %>
                                <a href="${pageContext.request.contextPath}/schedule" class="btn btn-secondary ms-2">Quay lại</a>
                            </div>
                        </form>
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

        // Debug: Kiểm tra số lượng dropdown buttons
        const dropdownButtons = document.querySelectorAll('[data-bs-toggle="dropdown"]');
        console.log('Found ' + dropdownButtons.length + ' dropdown buttons');

        // Khởi tạo Bootstrap dropdowns
        dropdownButtons.forEach(function(button, index) {
            console.log('Initializing dropdown button ' + index);
            try {
                new bootstrap.Dropdown(button);
                console.log('Dropdown ' + index + ' initialized successfully');
            } catch (error) {
                console.error('Error initializing dropdown ' + index + ':', error);
            }
        });

        // Ngăn dropdown đóng khi click vào items
        document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
            menu.addEventListener('click', function(e) {
                // Chỉ ngăn đóng dropdown nếu không phải là link có href
                if (!e.target.closest('a[href]') || e.target.closest('a[href]').getAttribute('href') === '#') {
                    e.stopPropagation();
                }
            });
        });

        // Thêm sự kiện click cho các nút xóa lịch tập
        document.querySelectorAll('.delete-schedule-btn').forEach(function(button) {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                const id = this.getAttribute('data-id');
                const info = this.getAttribute('data-info');

                document.getElementById('scheduleInfoToDelete').textContent = info;
                document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/schedule?action=delete&id=' + id;

                var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                deleteModal.show();
            });
        });

        // Thêm sự kiện click cho các nút xem chi tiết
        document.querySelectorAll('.view-schedule-btn').forEach(function(button) {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const id = this.getAttribute('data-id');
                const trainer = this.getAttribute('data-trainer');
                const member = this.getAttribute('data-member');
                const date = this.getAttribute('data-date');
                const time = this.getAttribute('data-time');
                const duration = this.getAttribute('data-duration');
                const status = this.getAttribute('data-status');
                const createdAt = this.getAttribute('data-created');

                document.getElementById('scheduleTitle').textContent = trainer + ' - ' + member;
                document.getElementById('scheduleTrainer').textContent = trainer;
                document.getElementById('scheduleMember').textContent = member;
                document.getElementById('scheduleDate').textContent = date;
                document.getElementById('scheduleTime').textContent = time;
                document.getElementById('scheduleDuration').textContent = duration + ' giờ';
                document.getElementById('scheduleCreatedAt').textContent = createdAt || 'Không có thông tin';

                // Cập nhật trạng thái với badge
                const statusBadge = document.getElementById('viewScheduleStatus');
                statusBadge.textContent = status;

                // Cập nhật class cho badge dựa trên trạng thái
                statusBadge.className = 'badge me-2';
                if (status === 'Chờ xác nhận') {
                    statusBadge.classList.add('status-pending');
                } else if (status === 'Đã xác nhận') {
                    statusBadge.classList.add('status-confirmed');
                } else if (status === 'Hoàn thành') {
                    statusBadge.classList.add('status-completed');
                } else if (status === 'Đã hủy') {
                    statusBadge.classList.add('status-cancelled');
                } else {
                    statusBadge.classList.add('bg-gradient-secondary');
                }

                // Cập nhật link chỉnh sửa
                document.getElementById('editScheduleBtn').href = '${pageContext.request.contextPath}/editSchedule?id=' + id;

                var viewModal = new bootstrap.Modal(document.getElementById('viewScheduleModal'));
                viewModal.show();
            });
        });
    });
</script>

</body>
</html>

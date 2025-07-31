<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Models.User" %>
<%@ page import="Models.Schedule" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"Personal Trainer".equals(loggedInUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    List<Schedule> scheduleList = (List<Schedule>) request.getAttribute("scheduleList");
    List<User> members = (List<User>) request.getAttribute("members");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    
    // Clear messages after displaying
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản lý lịch tập - Personal Trainer</title>
    
    <!-- Fonts and icons -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- CSS Files -->
    <link id="pagestyle" href="${pageContext.request.contextPath}/assets/css/argon-dashboard.css" rel="stylesheet" />
    
    <style>
        .schedule-card {
            transition: transform 0.2s;
        }
        .schedule-card:hover {
            transform: translateY(-2px);
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
        .toast {
            min-width: 300px;
        }
    </style>
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
    <!-- Success/Error Messages -->
    <div class="position-fixed top-0 end-0 p-3" style="z-index: 1050;">
        <% if (successMessage != null) { %>
        <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= successMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
        <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
        <% } %>
    </div>

    <!-- Include PT Sidebar -->
    <%@ include file="pt_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <!-- Include Navbar -->
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Quản lý lịch tập" />
            <jsp:param name="parentPage" value="Dashboard" />
            <jsp:param name="parentPageUrl" value="pt_dashboard.jsp" />
            <jsp:param name="currentPage" value="Quản lý lịch tập" />
        </jsp:include>

        <div class="container-fluid py-4">
            <!-- Header Actions -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                            <h6 class="mb-0">Lịch tập của tôi</h6>
                            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#createScheduleModal">
                                <i class="fas fa-plus me-2"></i>Tạo lịch tập mới
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Schedule List -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header pb-0">
                            <h6>Danh sách lịch tập</h6>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            <% if (scheduleList != null && !scheduleList.isEmpty()) { %>
                            <!-- Filter and Sort Controls -->
                            <div class="row px-3 mb-3">
                                <div class="col-md-4">
                                    <select class="form-select form-select-sm" id="statusFilter">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="Pending">Chờ xác nhận</option>
                                        <option value="Confirmed">Đã xác nhận</option>
                                        <option value="Completed">Hoàn thành</option>
                                        <option value="Cancelled">Đã hủy</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <input type="date" class="form-control form-control-sm" id="dateFilter" placeholder="Lọc theo ngày">
                                </div>
                                <div class="col-md-4">
                                    <select class="form-select form-select-sm" id="sortBy">
                                        <option value="date-desc">Ngày mới nhất</option>
                                        <option value="date-asc">Ngày cũ nhất</option>
                                        <option value="status">Theo trạng thái</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Schedule Cards Container -->
                            <div class="schedule-cards-container px-3" style="max-height: 600px; overflow-y: auto;">
                                <div class="row" id="scheduleCardsContainer">
                                    <% for (Schedule schedule : scheduleList) { 
                                        String statusClass = "";
                                        String statusText = schedule.getStatus();
                                        String statusBadgeClass = "";
                                        switch(statusText) {
                                            case "Pending": 
                                                statusBadgeClass = "bg-warning"; 
                                                statusText = "Chờ xác nhận"; 
                                                statusClass = "border-warning";
                                                break;
                                            case "Confirmed": 
                                                statusBadgeClass = "bg-info"; 
                                                statusText = "Đã xác nhận"; 
                                                statusClass = "border-info";
                                                break;
                                            case "Completed": 
                                                statusBadgeClass = "bg-success"; 
                                                statusText = "Hoàn thành"; 
                                                statusClass = "border-success";
                                                break;
                                            case "Cancelled": 
                                                statusBadgeClass = "bg-secondary"; 
                                                statusText = "Đã hủy"; 
                                                statusClass = "border-secondary";
                                                break;
                                            default: 
                                                statusBadgeClass = "bg-light";
                                                statusClass = "border-light";
                                        }
                                        int scheduleId = schedule.getId();
                                    %>
                                    <div class="col-lg-6 col-xl-4 mb-3 schedule-card" 
                                         data-status="<%= schedule.getStatus() %>" 
                                         data-date="<%= schedule.getScheduleDate() %>">
                                        <div class="card h-100 <%= statusClass %>" style="border-left: 4px solid;">
                                            <div class="card-body">
                                                <!-- Card Header -->
                                                <div class="d-flex justify-content-between align-items-start mb-3">
                                                    <div>
                                                        <h6 class="card-title mb-1">
                                                            <i class="fas fa-calendar-day me-2 text-primary"></i>
                                                            <%= schedule.getScheduleDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
                                                        </h6>
                                                        <p class="text-sm text-muted mb-0">
                                                            <i class="fas fa-clock me-1"></i>
                                                            <%= schedule.getScheduleTime().format(DateTimeFormatter.ofPattern("HH:mm")) %> 
                                                            (<%= schedule.getDurationHours() %> giờ)
                                                        </p>
                                                    </div>
                                                    <span class="badge <%= statusBadgeClass %>"><%= statusText %></span>
                                                </div>

                                                <!-- Member Info -->
                                                <div class="mb-3">
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar avatar-sm bg-gradient-secondary rounded-circle me-2">
                                                            <i class="fas fa-user text-white"></i>
                                                        </div>
                                                        <div>
                                                            <h6 class="mb-0 text-sm">
                                                                <%= schedule.getMember() != null ? schedule.getMember().getFullName() : "Lịch rảnh" %>
                                                            </h6>
                                                            <% if (schedule.getMember() != null) { %>
                                                            <p class="text-xs text-muted mb-0">Khách hàng</p>
                                                            <% } else { %>
                                                            <p class="text-xs text-muted mb-0">Chưa có khách hàng đăng ký</p>
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Action Buttons -->
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-outline-primary btn-sm flex-fill" 
                                                            onclick="editSchedule(<%=scheduleId%>)">
                                                        <i class="fas fa-edit me-1"></i>Sửa
                                                    </button>
                                                    
                                                    <% if ("Pending".equals(schedule.getStatus())) { %>
                                                    <button class="btn btn-info btn-sm" 
                                                            onclick="updateStatus(<%=scheduleId%>, 'Confirmed')"
                                                            title="Xác nhận">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                    <% } %>
                                                    
                                                    <% if ("Confirmed".equals(schedule.getStatus())) { %>
                                                    <button class="btn btn-success btn-sm" 
                                                            onclick="updateStatus(<%=scheduleId%>, 'Completed')"
                                                            title="Hoàn thành">
                                                        <i class="fas fa-check-double"></i>
                                                    </button>
                                                    <% } %>
                                                    
                                                    <% if (!"Cancelled".equals(schedule.getStatus()) && !"Completed".equals(schedule.getStatus())) { %>
                                                    <div class="dropdown">
                                                        <button class="btn btn-outline-secondary btn-sm" 
                                                                data-bs-toggle="dropdown" aria-expanded="false">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li><a class="dropdown-item text-warning" 
                                                                   href="javascript:void(0)" 
                                                                   onclick="updateStatus(<%=scheduleId%>, 'Cancelled')">
                                                                <i class="fas fa-times me-2"></i>Hủy lịch
                                                            </a></li>
                                                            <li><a class="dropdown-item text-danger" 
                                                                   href="javascript:void(0)" 
                                                                   onclick="deleteSchedule(<%=scheduleId%>)">
                                                                <i class="fas fa-trash me-2"></i>Xóa lịch
                                                            </a></li>
                                                        </ul>
                                                    </div>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-calendar-times fa-3x text-secondary mb-3"></i>
                                <h6 class="text-secondary">Chưa có lịch tập nào</h6>
                                <p class="text-sm text-secondary">Tạo lịch tập đầu tiên cho khách hàng của bạn</p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Create Schedule Modal -->
    <div class="modal fade" id="createScheduleModal" tabindex="-1" aria-labelledby="createScheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/pt-schedule">
                    <div class="modal-header">
                        <h5 class="modal-title" id="createScheduleModalLabel">Tạo lịch tập mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="formAction" value="create">
                        
                        <div class="mb-3">
                            <label class="form-label">Khách hàng</label>
                            <select name="memberId" class="form-select">
                                <option value="">Chọn khách hàng (tùy chọn)</option>
                                <% if (members != null) {
                                    for (User member : members) { %>
                                <option value="<%= member.getId() %>"><%= member.getFullName() %></option>
                                <% } } %>
                            </select>
                            <small class="form-text text-muted">Có thể để trống để tạo lịch rảnh cho PT</small>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Ngày tập *</label>
                            <input type="date" name="scheduleDate" class="form-control" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Giờ tập *</label>
                            <input type="time" name="scheduleTime" class="form-control" required 
                                   min="07:00" max="22:00">
                            <small class="form-text text-muted">Giờ hoạt động: 07:00 - 22:00</small>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Thời lượng (giờ) *</label>
                            <select name="durationHours" class="form-select" required>
                                <option value="">Chọn thời lượng</option>
                                <option value="0.5">30 phút</option>
                                <option value="1.0">1 giờ</option>
                                <option value="1.5">1 giờ 30 phút</option>
                                <option value="2.0">2 giờ</option>
                                <option value="2.5">2 giờ 30 phút</option>
                                <option value="3.0">3 giờ</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Trạng thái *</label>
                            <select name="status" class="form-select" required>
                                <option value="">Chọn trạng thái</option>
                                <option value="Pending">Chờ xác nhận</option>
                                <option value="Confirmed">Đã xác nhận</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Tạo lịch</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Schedule Modal -->
    <div class="modal fade" id="editScheduleModal" tabindex="-1" aria-labelledby="editScheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/pt-schedule" id="editScheduleForm">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editScheduleModalLabel">Chỉnh sửa lịch tập</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="formAction" value="edit">
                        <input type="hidden" name="id" id="editScheduleId">
                        
                        <div class="mb-3">
                            <label class="form-label">Khách hàng</label>
                            <select name="memberId" id="editMemberId" class="form-select">
                                <option value="">Chọn khách hàng (tùy chọn)</option>
                                <% if (members != null) {
                                    for (User member : members) { %>
                                <option value="<%= member.getId() %>"><%= member.getFullName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Ngày tập *</label>
                            <input type="date" name="scheduleDate" id="editScheduleDate" class="form-control" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Giờ tập *</label>
                            <input type="time" name="scheduleTime" id="editScheduleTime" class="form-control" required
                                   min="07:00" max="22:00">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Thời lượng (giờ) *</label>
                            <select name="durationHours" id="editDurationHours" class="form-select" required>
                                <option value="">Chọn thời lượng</option>
                                <option value="0.5">30 phút</option>
                                <option value="1.0">1 giờ</option>
                                <option value="1.5">1 giờ 30 phút</option>
                                <option value="2.0">2 giờ</option>
                                <option value="2.5">2 giờ 30 phút</option>
                                <option value="3.0">3 giờ</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Trạng thái *</label>
                            <select name="status" id="editStatus" class="form-select" required>
                                <option value="">Chọn trạng thái</option>
                                <option value="Pending">Chờ xác nhận</option>
                                <option value="Confirmed">Đã xác nhận</option>
                                <option value="Completed">Hoàn thành</option>
                                <option value="Cancelled">Đã hủy</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Set minimum date to today and time constraints
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            const dateInputs = document.querySelectorAll('input[type="date"]');
            dateInputs.forEach(function(input) {
                input.setAttribute('min', today);
            });

            // Validate time input
            const timeInputs = document.querySelectorAll('input[type="time"]');
            timeInputs.forEach(function(input) {
                input.addEventListener('change', function() {
                    const time = this.value;
                    if (time && (time < '07:00' || time > '22:00')) {
                        alert('Giờ tập phải trong khoảng 07:00 - 22:00');
                        this.value = '';
                    }
                });
            });

            // Show toasts
            const toastElements = document.querySelectorAll('.toast');
            toastElements.forEach(function(toastEl) {
                try {
                    const toast = new bootstrap.Toast(toastEl);
                    toast.show();
                    
                    setTimeout(function() {
                        toast.hide();
                    }, 5000);
                } catch (error) {
                    console.log('Toast error:', error);
                }
            });
        });

        function editSchedule(scheduleId) {
            try {
                // Simple approach: just set the ID and show modal
                document.getElementById('editScheduleId').value = scheduleId;
                const editModal = new bootstrap.Modal(document.getElementById('editScheduleModal'));
                editModal.show();
            } catch (error) {
                console.error('Error in editSchedule:', error);
                alert('Có lỗi xảy ra khi mở form chỉnh sửa');
            }
        }

        function updateStatus(scheduleId, newStatus) {
            try {
                var confirmMessage = 'Bạn có chắc chắn muốn thay đổi trạng thái lịch tập này?';
                
                if (newStatus === 'Cancelled') {
                    confirmMessage = 'Bạn có chắc chắn muốn hủy lịch tập này?';
                } else if (newStatus === 'Completed') {
                    confirmMessage = 'Xác nhận lịch tập đã hoàn thành?';
                }
                
                if (confirm(confirmMessage)) {
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = '${pageContext.request.contextPath}/pt-schedule';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'formAction';
                    actionInput.value = 'updateStatus';
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = scheduleId;
                    
                    const statusInput = document.createElement('input');
                    statusInput.type = 'hidden';
                    statusInput.name = 'status';
                    statusInput.value = newStatus;
                    
                    form.appendChild(actionInput);
                    form.appendChild(idInput);
                    form.appendChild(statusInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            } catch (error) {
                console.error('Error in updateStatus:', error);
                alert('Có lỗi xảy ra khi cập nhật trạng thái');
            }
        }

        function deleteSchedule(scheduleId) {
            try {
                if (confirm('Bạn có chắc chắn muốn xóa lịch tập này? Hành động này không thể hoàn tác.')) {
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = '${pageContext.request.contextPath}/pt-schedule';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'formAction';
                    actionInput.value = 'delete';
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = scheduleId;
                    
                    form.appendChild(actionInput);
                    form.appendChild(idInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            } catch (error) {
                console.error('Error in deleteSchedule:', error);
                alert('Có lỗi xảy ra khi xóa lịch tập');
            }
        }

        // Filter and Sort Functions
        document.addEventListener('DOMContentLoaded', function() {
            // Filter by status
            document.getElementById('statusFilter').addEventListener('change', function() {
                filterSchedules();
            });

            // Filter by date
            document.getElementById('dateFilter').addEventListener('change', function() {
                filterSchedules();
            });

            // Sort schedules
            document.getElementById('sortBy').addEventListener('change', function() {
                sortSchedules();
            });
        });

        function filterSchedules() {
            const statusFilter = document.getElementById('statusFilter').value;
            const dateFilter = document.getElementById('dateFilter').value;
            const cards = document.querySelectorAll('.schedule-card');

            cards.forEach(card => {
                let showCard = true;

                // Filter by status
                if (statusFilter && card.dataset.status !== statusFilter) {
                    showCard = false;
                }

                // Filter by date
                if (dateFilter && card.dataset.date !== dateFilter) {
                    showCard = false;
                }

                card.style.display = showCard ? 'block' : 'none';
            });
        }

        function sortSchedules() {
            const sortBy = document.getElementById('sortBy').value;
            const container = document.getElementById('scheduleCardsContainer');
            const cards = Array.from(container.querySelectorAll('.schedule-card'));

            cards.sort((a, b) => {
                switch(sortBy) {
                    case 'date-asc':
                        return new Date(a.dataset.date) - new Date(b.dataset.date);
                    case 'date-desc':
                        return new Date(b.dataset.date) - new Date(a.dataset.date);
                    case 'status':
                        return a.dataset.status.localeCompare(b.dataset.status);
                    default:
                        return new Date(b.dataset.date) - new Date(a.dataset.date);
                }
            });

            // Re-append sorted cards
            cards.forEach(card => container.appendChild(card));
        }
    </script>
</body>
</html>


















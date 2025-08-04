<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.TrainerAvailability" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Kiểm tra quyền Admin
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
        response.sendRedirect("login");
        return;
    }

    List<TrainerAvailability> monthlyAvailabilities = (List<TrainerAvailability>) request.getAttribute("monthlyAvailabilities");
    List<User> trainers = (List<User>) request.getAttribute("trainers");
    if (trainers == null) {
        trainers = new java.util.ArrayList<>();
    }

    Integer selectedTrainerId = (Integer) request.getAttribute("selectedTrainerId");
    Integer currentYear = (Integer) request.getAttribute("currentYear");
    Integer currentMonth = (Integer) request.getAttribute("currentMonth");

    String errorMessage = (String) session.getAttribute("errorMessage");
    boolean hasErrorMessage = (errorMessage != null);
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    String successMessage = (String) session.getAttribute("successMessage");
    boolean hasSuccessMessage = (successMessage != null);
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }

    // Tạo map để tra cứu nhanh availabilities theo ngày
    Map<LocalDate, List<TrainerAvailability>> availabilityMap = new HashMap<>();
    if (monthlyAvailabilities != null) {
        for (TrainerAvailability availability : monthlyAvailabilities) {
            LocalDate date = availability.getAvailabilityDate();
            availabilityMap.computeIfAbsent(date, k -> new java.util.ArrayList<>()).add(availability);
        }
    }

    // Thiết lập calendar
    YearMonth yearMonth = YearMonth.of(currentYear, currentMonth);
    LocalDate firstDayOfMonth = yearMonth.atDay(1);
    LocalDate lastDayOfMonth = yearMonth.atEndOfMonth();
    int daysInMonth = yearMonth.lengthOfMonth();
    
    // Ngày đầu tuần (thứ 2 = 1, chủ nhật = 7)
    int startDayOfWeek = firstDayOfMonth.getDayOfWeek().getValue();
    
    DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MM/yyyy");
    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd/MM");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>

<%!
    // Helper method to check if admin can cancel availability
    private boolean canAdminCancelAvailability(TrainerAvailability availability) {
        // Admin có thể hủy lịch PENDING hoặc APPROVED
        if (!"PENDING".equals(availability.getStatus()) && !"APPROVED".equals(availability.getStatus())) {
            return false;
        }
        
        // Admin có thể hủy lịch trong tương lai (không cần rule 1 ngày như PT)
        java.time.LocalDate today = java.time.LocalDate.now();
        return availability.getAvailabilityDate().isAfter(today) || 
               availability.getAvailabilityDate().equals(today);
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Lịch PT tổng quan - CGMS Admin</title>
    <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --warning-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --info-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --danger-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            --hover-transform: translateY(-2px);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .tabs-container {
            background: white;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            overflow: hidden;
        }

        .nav-tabs {
            border: none;
            padding: 0;
            margin: 0;
        }

        .nav-tabs .nav-link {
            border: none;
            border-radius: 0;
            padding: 1.5rem 2rem;
            font-weight: 600;
            color: #718096;
            background: transparent;
            transition: all 0.3s ease;
        }

        .nav-tabs .nav-link.active {
            background: var(--primary-gradient);
            color: white;
        }

        .nav-tabs .nav-link:hover:not(.active) {
            background: #f8fafc;
            color: #4a5568;
        }

        .tab-content {
            padding: 2rem;
        }

        .filter-section {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-left: 4px solid #667eea;
        }

        .filter-title {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-form {
            display: flex;
            gap: 1rem;
            align-items: end;
            flex-wrap: wrap;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .filter-label {
            font-weight: 500;
            color: #4a5568;
            margin-bottom: 0.5rem;
            display: block;
        }

        .filter-select {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            background: white;
            transition: all 0.3s ease;
            width: 100%;
        }

        .filter-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-filter {
            background: var(--info-gradient);
            border: none;
            border-radius: 12px;
            padding: 0.75rem 1.5rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-filter:hover {
            transform: var(--hover-transform);
            box-shadow: 0 8px 20px rgba(79, 172, 254, 0.4);
        }

        .btn-clear {
            background: #6c757d;
            border: none;
            border-radius: 12px;
            padding: 0.75rem 1.5rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-clear:hover {
            background: #5a6268;
            color: white;
            text-decoration: none;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .calendar-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
        }

        .calendar-nav {
            display: flex;
            gap: 0.5rem;
        }

        .btn-nav {
            background: var(--info-gradient);
            border: none;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-nav:hover {
            transform: var(--hover-transform);
            box-shadow: 0 8px 20px rgba(79, 172, 254, 0.4);
            color: white;
            text-decoration: none;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background: #e2e8f0;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }

        .calendar-header-cell {
            background: #f8fafc;
            padding: 1rem;
            text-align: center;
            font-weight: 600;
            color: #4a5568;
            font-size: 0.875rem;
        }

        .calendar-cell {
            background: white;
            min-height: 140px;
            padding: 0.75rem;
            display: flex;
            flex-direction: column;
            position: relative;
            transition: all 0.3s ease;
        }

        .calendar-cell:hover {
            background: #f8fafc;
        }

        .calendar-cell.other-month {
            background: #f8fafc;
            color: #a0aec0;
        }

        .calendar-cell.sunday {
            background: #fed7d7;
            color: #9b2c2c;
        }

        .calendar-cell.today {
            background: #ebf8ff;
            border: 2px solid #3182ce;
        }

        .date-number {
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }

        .availability-items {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
            overflow-y: auto;
        }

        .availability-item {
            background: rgba(102, 126, 234, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.3);
            border-radius: 6px;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .availability-item:hover {
            background: rgba(102, 126, 234, 0.2);
            transform: scale(1.02);
        }

        .availability-item.pending {
            background: rgba(245, 158, 11, 0.1);
            border-color: rgba(245, 158, 11, 0.3);
            color: #92400e;
        }

        .availability-item.approved {
            background: rgba(16, 185, 129, 0.1);
            border-color: rgba(16, 185, 129, 0.3);
            color: #065f46;
        }

        .availability-item.rejected {
            background: rgba(239, 68, 68, 0.1);
            border-color: rgba(239, 68, 68, 0.3);
            color: #991b1b;
        }

        .trainer-name {
            font-weight: 600;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .availability-time {
            font-size: 0.65rem;
            opacity: 0.8;
        }

        .more-indicator {
            background: #e2e8f0;
            border-radius: 4px;
            padding: 0.125rem 0.25rem;
            font-size: 0.65rem;
            color: #4a5568;
            text-align: center;
            margin-top: 0.25rem;
        }

        .btn-approval {
            background: var(--warning-gradient);
            border: none;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            margin-bottom: 2rem;
        }

        .btn-approval:hover {
            transform: var(--hover-transform);
            box-shadow: 0 10px 25px rgba(240, 147, 251, 0.4);
            color: white;
            text-decoration: none;
        }

        .toast-container {
            position: fixed;
            top: 2rem;
            right: 2rem;
            z-index: 9999;
        }

        .toast {
            margin-bottom: 1rem;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        /* Modal styles */
        .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            background: var(--primary-gradient);
            color: white;
            border-radius: 20px 20px 0 0;
            border: none;
        }

        .availability-details {
            padding: 1rem 0;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .detail-label {
            font-weight: 600;
            color: #4a5568;
        }

        .detail-value {
            color: #2d3748;
        }

        /* Legend */
        .legend {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }

        .legend-color {
            width: 16px;
            height: 16px;
            border-radius: 4px;
            border: 1px solid;
        }

        .legend-color.pending {
            background: rgba(245, 158, 11, 0.3);
            border-color: rgba(245, 158, 11, 0.5);
        }

        .legend-color.approved {
            background: rgba(16, 185, 129, 0.3);
            border-color: rgba(16, 185, 129, 0.5);
        }

        .legend-color.rejected {
            background: rgba(239, 68, 68, 0.3);
            border-color: rgba(239, 68, 68, 0.5);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .calendar-grid {
                font-size: 0.75rem;
            }
            
            .calendar-cell {
                min-height: 100px;
                padding: 0.5rem;
            }
            
            .calendar-header {
                flex-direction: column;
                text-align: center;
            }

            .filter-form {
                flex-direction: column;
            }
            
            .filter-group {
                min-width: unset;
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
                    <i class="fas fa-check-circle me-2"></i>
                    <%= successMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <% } %>

        <% if (hasErrorMessage) { %>
        <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" id="errorToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <% } %>
    </div>

    <!-- Sidebar -->
    <%@ include file="sidebar.jsp" %>

    <!-- Main content -->
    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <%@ include file="navbar.jsp" %>

        <!-- Content -->
        <div class="container-fluid py-4">
            <div class="tabs-container">
                <!-- Tab Navigation -->
                <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <a class="nav-link active" href="#calendar-tab" data-bs-toggle="tab" role="tab">
                            <i class="fas fa-calendar me-2"></i>
                            Lịch PT
                        </a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link" href="admin-pt-availability?action=list">
                            <i class="fas fa-tasks me-2"></i>
                            Duyệt lịch
                        </a>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content">
                    <div class="tab-pane fade show active" id="calendar-tab" role="tabpanel">
                        <!-- Quick Actions -->
                        <a href="admin-pt-availability?action=list" class="btn-approval">
                            <i class="fas fa-tasks"></i>
                            Duyệt lịch chờ
                        </a>

                        <!-- Filter Section -->
                        <div class="filter-section">
                            <div class="filter-title">
                                <i class="fas fa-filter"></i>
                                Lọc theo PT
                            </div>
                            <form class="filter-form" method="get" action="admin-pt-availability">
                                <input type="hidden" name="action" value="calendar">
                                <input type="hidden" name="year" value="<%= currentYear %>">
                                <input type="hidden" name="month" value="<%= currentMonth %>">
                                <div class="filter-group">
                                    <label class="filter-label">Chọn Personal Trainer</label>
                                    <select name="trainerId" class="filter-select">
                                        <option value="">-- Tất cả PT --</option>
                                        <% for (User trainer : trainers) { %>
                                        <option value="<%= trainer.getId() %>" 
                                                <%= (selectedTrainerId != null && selectedTrainerId.equals(trainer.getId())) ? "selected" : "" %>>
                                            <%= trainer.getFullName() %> (<%= trainer.getEmail() %>)
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div>
                                    <button type="submit" class="btn-filter">
                                        <i class="fas fa-search"></i>
                                        Lọc
                                    </button>
                                    <a href="admin-pt-availability?action=calendar&year=<%= currentYear %>&month=<%= currentMonth %>" class="btn-clear">
                                        <i class="fas fa-times"></i>
                                        Xóa bộ lọc
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Legend -->
                        <div class="legend">
                            <div class="legend-item">
                                <div class="legend-color pending"></div>
                                <span>Chờ duyệt</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color approved"></div>
                                <span>Đã duyệt</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color rejected"></div>
                                <span>Từ chối</span>
                            </div>
                        </div>

                        <!-- Calendar Header -->
                        <div class="calendar-header">
                            <h2 class="calendar-title">
                                <i class="fas fa-calendar-alt me-2"></i>
                                Tháng <%= String.format("%02d/%d", currentMonth, currentYear) %>
                                <% if (selectedTrainerId != null) { %>
                                - <%= trainers.stream().filter(t -> t.getId() == selectedTrainerId).findFirst().map(User::getFullName).orElse("PT") %>
                                <% } %>
                            </h2>
                            <div class="calendar-nav">
                                <a href="admin-pt-availability?action=calendar&year=<%= currentMonth == 1 ? currentYear - 1 : currentYear %>&month=<%= currentMonth == 1 ? 12 : currentMonth - 1 %><%= selectedTrainerId != null ? "&trainerId=" + selectedTrainerId : "" %>" 
                                   class="btn-nav">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                                <a href="admin-pt-availability?action=calendar<%= selectedTrainerId != null ? "?trainerId=" + selectedTrainerId : "" %>" class="btn-nav">
                                    Hôm nay
                                </a>
                                <a href="admin-pt-availability?action=calendar&year=<%= currentMonth == 12 ? currentYear + 1 : currentYear %>&month=<%= currentMonth == 12 ? 1 : currentMonth + 1 %><%= selectedTrainerId != null ? "&trainerId=" + selectedTrainerId : "" %>" 
                                   class="btn-nav">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </div>
                        </div>

                        <!-- Calendar Grid -->
                        <div class="calendar-grid">
                            <!-- Header days -->
                            <div class="calendar-header-cell">Thứ 2</div>
                            <div class="calendar-header-cell">Thứ 3</div>
                            <div class="calendar-header-cell">Thứ 4</div>
                            <div class="calendar-header-cell">Thứ 5</div>
                            <div class="calendar-header-cell">Thứ 6</div>
                            <div class="calendar-header-cell">Thứ 7</div>
                            <div class="calendar-header-cell">Chủ nhật</div>

                            <%
                                LocalDate today = LocalDate.now();
                                
                                // Ngày bắt đầu hiển thị (có thể là cuối tháng trước)
                                LocalDate displayStart = firstDayOfMonth.minusDays(startDayOfWeek - 1);
                                
                                // Hiển thị 6 tuần (42 ngày)
                                for (int i = 0; i < 42; i++) {
                                    LocalDate currentDate = displayStart.plusDays(i);
                                    boolean isCurrentMonth = currentDate.getMonth() == yearMonth.getMonth();
                                    boolean isToday = currentDate.equals(today);
                                    boolean isSunday = currentDate.getDayOfWeek() == DayOfWeek.SUNDAY;
                                    
                                    List<TrainerAvailability> dayAvailabilities = availabilityMap.get(currentDate);
                                    
                                    String cellClass = "calendar-cell";
                                    if (!isCurrentMonth) cellClass += " other-month";
                                    if (isToday) cellClass += " today";
                                    if (isSunday) cellClass += " sunday";
                            %>
                            <div class="<%= cellClass %>">
                                <div class="date-number"><%= currentDate.getDayOfMonth() %></div>
                                
                                <div class="availability-items">
                                    <% if (dayAvailabilities != null) { 
                                        int maxDisplay = 3;
                                        for (int j = 0; j < Math.min(dayAvailabilities.size(), maxDisplay); j++) {
                                            TrainerAvailability avail = dayAvailabilities.get(j);
                                    %>
                                    <div class="availability-item <%= avail.getStatus().toLowerCase() %>" 
                                         onclick="showAvailabilityDetails(<%= avail.getId() %>)">
                                        <div class="trainer-name">
                                            <%= avail.getTrainer().getFullName().split(" ")[0] %>
                                        </div>
                                        <div class="availability-time">
                                            <%= avail.getStartTime().format(timeFormatter) %>-<%= avail.getEndTime().format(timeFormatter) %>
                                        </div>
                                    </div>
                                    <% } 
                                        if (dayAvailabilities.size() > maxDisplay) { %>
                                    <div class="more-indicator">
                                        +<%= dayAvailabilities.size() - maxDisplay %> thêm
                                    </div>
                                    <% } %>
                                    <% } else if (isSunday && isCurrentMonth) { %>
                                    <div class="availability-item" style="background: #fed7d7; color: #9b2c2c; border-color: #feb2b2;">
                                        <div class="trainer-name">
                                            <i class="fas fa-ban me-1"></i>
                                            Gym nghỉ
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Availability Details Modal -->
    <div class="modal fade" id="availabilityModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-calendar-check me-2"></i>
                        Chi tiết lịch sẵn sàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="modalBody">
                    <!-- Content will be loaded dynamically -->
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

    <script>
        // Initialize toasts
        document.addEventListener('DOMContentLoaded', function() {
            const toastElements = document.querySelectorAll('.toast');
            toastElements.forEach(function(toastElement) {
                const toast = new bootstrap.Toast(toastElement, {
                    delay: 5000
                });
                toast.show();
            });
        });

        // Show availability details
        function showAvailabilityDetails(availabilityId) {
            // Find availability data from page
            const availabilityData = getAvailabilityData(availabilityId);
            
            if (!availabilityData) {
                alert('Không tìm thấy thông tin lịch sẵn sàng');
                return;
            }

            const modal = new bootstrap.Modal(document.getElementById('availabilityModal'));
            
            // Build modal content with real data
            let statusBadge = '';
            
            switch(availabilityData.status.toLowerCase()) {
                case 'pending':
                    statusBadge = '<span class="badge bg-warning">Chờ duyệt</span>';
                    break;
                case 'approved':
                    statusBadge = '<span class="badge bg-success">Đã duyệt</span>';
                    break;
                case 'rejected':
                    statusBadge = '<span class="badge bg-danger">Từ chối</span>';
                    break;
            }

            let modalContent = '<div class="availability-details">';
            modalContent += '<div class="detail-row">';
            modalContent += '<span class="detail-label">ID:</span>';
            modalContent += '<span class="detail-value">#' + availabilityData.id + '</span>';
            modalContent += '</div>';
            
            modalContent += '<div class="detail-row">';
            modalContent += '<span class="detail-label">Personal Trainer:</span>';
            modalContent += '<span class="detail-value">' + availabilityData.trainerName + '</span>';
            modalContent += '</div>';
            
            modalContent += '<div class="detail-row">';
            modalContent += '<span class="detail-label">Email PT:</span>';
            modalContent += '<span class="detail-value">' + availabilityData.trainerEmail + '</span>';
            modalContent += '</div>';
            
            modalContent += '<div class="detail-row">';
            modalContent += '<span class="detail-label">Ngày:</span>';
            modalContent += '<span class="detail-value">' + availabilityData.date + '</span>';
            modalContent += '</div>';
            
            modalContent += '<div class="detail-row">';
            modalContent += '<span class="detail-label">Thời gian:</span>';
            modalContent += '<span class="detail-value">' + availabilityData.startTime + ' - ' + availabilityData.endTime + '</span>';
            modalContent += '</div>';
            
            modalContent += '<div class="detail-row">';
            modalContent += '<span class="detail-label">Trạng thái:</span>';
            modalContent += '<span class="detail-value">' + statusBadge + '</span>';
            modalContent += '</div>';
            
            modalContent += '<div class="detail-row">';
            modalContent += '<span class="detail-label">Đăng ký lúc:</span>';
            modalContent += '<span class="detail-value">' + availabilityData.createdAt + '</span>';
            modalContent += '</div>';
            
            if (availabilityData.updatedAt) {
                modalContent += '<div class="detail-row">';
                modalContent += '<span class="detail-label">Cập nhật lúc:</span>';
                modalContent += '<span class="detail-value">' + availabilityData.updatedAt + '</span>';
                modalContent += '</div>';
            }
            
            modalContent += '</div>';
            modalContent += '<div class="mt-3 d-flex gap-2">';
            modalContent += '<a href="admin-pt-availability?action=list" class="btn btn-secondary">';
            modalContent += '<i class="fas fa-list me-1"></i> Duyệt lịch</a>';
            
            // Admin action buttons
            if (availabilityData.status === 'PENDING') {
                modalContent += '<button type="button" class="btn btn-success" onclick="approveAvailability(' + availabilityData.id + ')">';
                modalContent += '<i class="fas fa-check me-1"></i> Duyệt</button>';
                
                modalContent += '<button type="button" class="btn btn-warning" onclick="rejectAvailability(' + availabilityData.id + ')">';
                modalContent += '<i class="fas fa-times me-1"></i> Từ chối</button>';
            }
            
            if (availabilityData.canCancel) {
                modalContent += '<button type="button" class="btn btn-danger" onclick="confirmCancel(' + availabilityData.id + ')">';
                modalContent += '<i class="fas fa-trash me-1"></i> Hủy lịch</button>';
            }
            
            modalContent += '</div>';
            
            document.getElementById('modalBody').innerHTML = modalContent;
            modal.show();
        }

        // Get availability data from page context
        function getAvailabilityData(availabilityId) {
            // Find the availability from monthlyAvailabilities array
            <% if (monthlyAvailabilities != null && !monthlyAvailabilities.isEmpty()) { %>
            const availabilities = [
                <% for (TrainerAvailability avail : monthlyAvailabilities) { %>
                {
                    id: <%= avail.getId() %>,
                    trainerName: '<%= avail.getTrainer().getFullName() %>',
                    trainerEmail: '<%= avail.getTrainer().getEmail() %>',
                    date: '<%= avail.getAvailabilityDate().format(dateFormatter) %>',
                    startTime: '<%= avail.getStartTime().format(timeFormatter) %>',
                    endTime: '<%= avail.getEndTime().format(timeFormatter) %>',
                    status: '<%= avail.getStatus() %>',
                    createdAt: '<%= avail.getCreatedAt().toString().substring(0, 19).replace("T", " ") %>',
                    updatedAt: '<%= avail.getUpdatedAt() != null ? avail.getUpdatedAt().toString().substring(0, 19).replace("T", " ") : "" %>',
                    canCancel: <%= canAdminCancelAvailability(avail) %>
                },
                <% } %>
            ];
            <% } else { %>
            const availabilities = [];
            <% } %>
            
            return availabilities.find(a => a.id === availabilityId);
        }

        // Admin actions
        function approveAvailability(availabilityId) {
            if (confirm('Bạn có chắc chắn muốn duyệt lịch sẵn sàng này không?')) {
                submitAction('approve', availabilityId);
            }
        }

        function rejectAvailability(availabilityId) {
            if (confirm('Bạn có chắc chắn muốn từ chối lịch sẵn sàng này không?')) {
                submitAction('reject', availabilityId);
            }
        }

        function confirmCancel(availabilityId) {
            if (confirm('Bạn có chắc chắn muốn hủy lịch sẵn sàng này không? Hành động này không thể hoàn tác.')) {
                submitAction('cancel', availabilityId);
            }
        }

        function submitAction(action, availabilityId) {
            // Create form and submit
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'admin-pt-availability';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = action;
            form.appendChild(actionInput);
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = availabilityId;
            form.appendChild(idInput);
            
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</body>
</html>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.TrainerAvailability" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Kiểm tra quyền PT
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null || !"Personal Trainer".equals(currentUser.getRole())) {
        response.sendRedirect("login");
        return;
    }

    List<TrainerAvailability> availabilities = (List<TrainerAvailability>) request.getAttribute("availabilities");
    if (availabilities == null) {
        availabilities = new java.util.ArrayList<>();
    }

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

    // Tính toán stats
    int pendingCount = 0, approvedCount = 0, rejectedCount = 0;
    for (TrainerAvailability avail : availabilities) {
        switch (avail.getStatus()) {
            case "PENDING": pendingCount++; break;
            case "APPROVED": approvedCount++; break;
            case "REJECTED": rejectedCount++; break;
        }
    }
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Danh sách lịch sẵn sàng - CGMS PT</title>
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

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            border-left: 4px solid;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: var(--hover-transform);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .stat-card.pending {
            border-left-color: #f59e0b;
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.05) 0%, rgba(245, 158, 11, 0.1) 100%);
        }

        .stat-card.approved {
            border-left-color: #10b981;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.05) 0%, rgba(16, 185, 129, 0.1) 100%);
        }

        .stat-card.rejected {
            border-left-color: #ef4444;
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.05) 0%, rgba(239, 68, 68, 0.1) 100%);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #64748b;
            font-weight: 500;
            font-size: 0.875rem;
        }

        .availability-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .availability-card:hover {
            transform: var(--hover-transform);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .availability-card.pending {
            border-left-color: #f59e0b;
        }

        .availability-card.approved {
            border-left-color: #10b981;
        }

        .availability-card.rejected {
            border-left-color: #ef4444;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .card-info h5 {
            margin: 0 0 0.5rem 0;
            color: #2d3748;
            font-weight: 600;
        }

        .card-meta {
            color: #64748b;
            font-size: 0.875rem;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-badge.pending {
            background: rgba(245, 158, 11, 0.15);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }

        .status-badge.approved {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .status-badge.rejected {
            background: rgba(239, 68, 68, 0.15);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .card-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #4a5568;
        }

        .detail-icon {
            color: #667eea;
            width: 16px;
            text-align: center;
        }

        .card-actions {
            display: flex;
            gap: 0.5rem;
            justify-content: flex-end;
        }

        .btn-cancel {
            background: var(--danger-gradient);
            border: none;
            border-radius: 8px;
            padding: 0.5rem 1rem;
            color: white;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-cancel:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(250, 112, 154, 0.4);
        }

        .btn-calendar {
            background: var(--info-gradient);
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

        .btn-calendar:hover {
            transform: var(--hover-transform);
            box-shadow: 0 10px 25px rgba(79, 172, 254, 0.4);
            color: white;
            text-decoration: none;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #cbd5e0;
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

        /* Responsive */
        @media (max-width: 768px) {
            .card-header {
                flex-direction: column;
                gap: 1rem;
            }
            
            .card-actions {
                justify-content: flex-start;
            }
            
            .stats-row {
                grid-template-columns: 1fr;
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
    <%@ include file="pt_sidebar.jsp" %>

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
                        <a class="nav-link" href="pt-availability?action=calendar">
                            <i class="fas fa-calendar me-2"></i>
                            Lịch sẵn sàng
                        </a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link active" href="#list-tab" data-bs-toggle="tab" role="tab">
                            <i class="fas fa-list me-2"></i>
                            Danh sách đăng ký
                        </a>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content">
                    <div class="tab-pane fade show active" id="list-tab" role="tabpanel">
                        <!-- Quick Actions -->
                        <a href="pt-availability?action=calendar" class="btn-calendar">
                            <i class="fas fa-calendar-alt"></i>
                            Xem lịch tháng
                        </a>

                        <!-- Stats Row -->
                        <div class="stats-row">
                            <div class="stat-card pending">
                                <div class="stat-value" style="color: #f59e0b;"><%= pendingCount %></div>
                                <div class="stat-label">
                                    <i class="fas fa-clock me-1"></i>
                                    Chờ duyệt
                                </div>
                            </div>
                            <div class="stat-card approved">
                                <div class="stat-value" style="color: #10b981;"><%= approvedCount %></div>
                                <div class="stat-label">
                                    <i class="fas fa-check-circle me-1"></i>
                                    Đã duyệt
                                </div>
                            </div>
                            <div class="stat-card rejected">
                                <div class="stat-value" style="color: #ef4444;"><%= rejectedCount %></div>
                                <div class="stat-label">
                                    <i class="fas fa-times-circle me-1"></i>
                                    Từ chối
                                </div>
                            </div>
                        </div>

                        <!-- Availability List -->
                        <% if (availabilities.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fas fa-calendar-times"></i>
                            <h5>Chưa có lịch sẵn sàng nào</h5>
                            <p>Bạn chưa đăng ký lịch sẵn sàng nào. Hãy bắt đầu đăng ký để có thể nhận lịch tập với thành viên.</p>
                            <a href="pt-availability?action=register" class="btn btn-primary mt-3">
                                <i class="fas fa-plus me-2"></i>
                                Đăng ký lịch mới
                            </a>
                        </div>
                        <% } else { %>
                        <% for (TrainerAvailability availability : availabilities) { 
                            String statusClass = availability.getStatus().toLowerCase();
                            boolean canCancel = ("PENDING".equals(availability.getStatus()) || "APPROVED".equals(availability.getStatus())) 
                                               && availability.getAvailabilityDate().isAfter(java.time.LocalDate.now());
                        %>
                        <div class="availability-card <%= statusClass %>">
                            <div class="card-header">
                                <div class="card-info">
                                    <h5>
                                        <i class="fas fa-calendar-check me-2"></i>
                                        Lịch ngày <%= availability.getAvailabilityDate().format(dateFormatter) %>
                                    </h5>
                                    <div class="card-meta">
                                        ID: #<%= availability.getId() %> • 
                                        Đăng ký: <%= availability.getCreatedAt().toString().substring(0, 19).replace("T", " ") %>
                                    </div>
                                </div>
                                <div class="status-badge <%= statusClass %>">
                                    <% if ("PENDING".equals(availability.getStatus())) { %>
                                        <i class="fas fa-clock me-1"></i> Chờ duyệt
                                    <% } else if ("APPROVED".equals(availability.getStatus())) { %>
                                        <i class="fas fa-check me-1"></i> Đã duyệt
                                    <% } else if ("REJECTED".equals(availability.getStatus())) { %>
                                        <i class="fas fa-times me-1"></i> Từ chối
                                    <% } %>
                                </div>
                            </div>

                            <div class="card-details">
                                <div class="detail-item">
                                    <i class="fas fa-clock detail-icon"></i>
                                    <span>
                                        <%= availability.getStartTime().format(timeFormatter) %> - 
                                        <%= availability.getEndTime().format(timeFormatter) %>
                                    </span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-calendar detail-icon"></i>
                                    <span>
                                        <%= availability.getAvailabilityDate().getDayOfWeek().toString() %>
                                    </span>
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-stopwatch detail-icon"></i>
                                    <span>
                                        <%= java.time.Duration.between(availability.getStartTime(), availability.getEndTime()).toHours() %> giờ
                                    </span>
                                </div>
                            </div>

                            <% if (canCancel) { %>
                            <div class="card-actions">
                                <button class="btn-cancel" onclick="confirmCancel(<%= availability.getId() %>, '<%= availability.getAvailabilityDate().format(dateFormatter) %>')">
                                    <i class="fas fa-times me-1"></i>
                                    Hủy lịch
                                </button>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Cancel Confirmation Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Xác nhận hủy lịch
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn hủy lịch sẵn sàng cho ngày <strong id="cancelDate"></strong>?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Hành động này không thể hoàn tác!
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" id="confirmCancelBtn">
                        <i class="fas fa-trash me-2"></i>
                        Xác nhận hủy
                    </button>
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

        let cancelId = null;

        function confirmCancel(availabilityId, date) {
            cancelId = availabilityId;
            document.getElementById('cancelDate').textContent = date;
            const modal = new bootstrap.Modal(document.getElementById('cancelModal'));
            modal.show();
        }

        document.getElementById('confirmCancelBtn').addEventListener('click', function() {
            if (cancelId) {
                window.location.href = 'pt-availability?action=cancel&id=' + cancelId;
            }
        });
    </script>
</body>
</html>
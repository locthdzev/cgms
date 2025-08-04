<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.TrainerAvailability" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Kiểm tra quyền Admin
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
        response.sendRedirect("login");
        return;
    }

    List<TrainerAvailability> pendingAvailabilities = (List<TrainerAvailability>) request.getAttribute("pendingAvailabilities");
    if (pendingAvailabilities == null) {
        pendingAvailabilities = new java.util.ArrayList<>();
    }

    List<User> trainers = (List<User>) request.getAttribute("trainers");
    if (trainers == null) {
        trainers = new java.util.ArrayList<>();
    }

    Integer selectedTrainerId = (Integer) request.getAttribute("selectedTrainerId");

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

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Quản lý lịch PT - CGMS Admin</title>
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

        .stats-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            border-left: 4px solid #f59e0b;
            transition: all 0.3s ease;
            margin-bottom: 2rem;
        }

        .stats-card:hover {
            transform: var(--hover-transform);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #f59e0b;
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
            border-left: 4px solid #f59e0b;
        }

        .availability-card:hover {
            transform: var(--hover-transform);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .trainer-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .trainer-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--primary-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 1.25rem;
        }

        .trainer-details h6 {
            margin: 0;
            color: #2d3748;
            font-weight: 600;
        }

        .trainer-details small {
            color: #64748b;
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
            background: rgba(245, 158, 11, 0.15);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.3);
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
            gap: 0.75rem;
            justify-content: flex-end;
        }

        .btn-approve {
            background: var(--success-gradient);
            border: none;
            border-radius: 8px;
            padding: 0.75rem 1.25rem;
            color: white;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-approve:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(17, 153, 142, 0.4);
        }

        .btn-reject {
            background: var(--danger-gradient);
            border: none;
            border-radius: 8px;
            padding: 0.75rem 1.25rem;
            color: white;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-reject:hover {
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
                        <a class="nav-link" href="admin-pt-availability?action=calendar">
                            <i class="fas fa-calendar me-2"></i>
                            Lịch PT
                        </a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link active" href="#approval-tab" data-bs-toggle="tab" role="tab">
                            <i class="fas fa-tasks me-2"></i>
                            Duyệt lịch
                        </a>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content">
                    <div class="tab-pane fade show active" id="approval-tab" role="tabpanel">
                        <!-- Quick Actions -->
                        <a href="admin-pt-availability?action=calendar" class="btn-calendar">
                            <i class="fas fa-calendar-alt"></i>
                            Xem lịch tổng quan
                        </a>

                        <!-- Filter Section -->
                        <div class="filter-section">
                            <div class="filter-title">
                                <i class="fas fa-filter"></i>
                                Lọc theo PT
                            </div>
                            <form class="filter-form" method="get" action="admin-pt-availability">
                                <input type="hidden" name="action" value="list">
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
                                    <a href="admin-pt-availability" class="btn-clear">
                                        <i class="fas fa-times"></i>
                                        Xóa bộ lọc
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Stats Card -->
                        <div class="stats-card">
                            <div class="stat-value"><%= pendingAvailabilities.size() %></div>
                            <div class="stat-label">
                                <i class="fas fa-clock me-1"></i>
                                Lịch chờ duyệt
                                <% if (selectedTrainerId != null) { %>
                                - Đã lọc theo PT
                                <% } %>
                            </div>
                        </div>

                        <!-- Pending Availabilities List -->
                        <% if (pendingAvailabilities.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fas fa-calendar-check"></i>
                            <h5>Không có lịch chờ duyệt</h5>
                            <% if (selectedTrainerId != null) { %>
                            <p>PT được chọn không có lịch nào chờ duyệt.</p>
                            <% } else { %>
                            <p>Tất cả lịch sẵn sàng đã được xử lý.</p>
                            <% } %>
                        </div>
                        <% } else { %>
                        <% for (TrainerAvailability availability : pendingAvailabilities) { %>
                        <div class="availability-card">
                            <!-- Trainer Info -->
                            <div class="trainer-info">
                                <div class="trainer-avatar">
                                    <%= availability.getTrainer().getFullName().substring(0, 1).toUpperCase() %>
                                </div>
                                <div class="trainer-details">
                                    <h6><%= availability.getTrainer().getFullName() %></h6>
                                    <small><%= availability.getTrainer().getEmail() %></small>
                                </div>
                            </div>

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
                                <div class="status-badge">
                                    <i class="fas fa-clock me-1"></i> Chờ duyệt
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

                            <div class="card-actions">
                                <form method="post" action="admin-pt-availability" style="display: inline;">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="id" value="<%= availability.getId() %>">
                                    <button type="submit" class="btn-approve">
                                        <i class="fas fa-check me-1"></i>
                                        Duyệt
                                    </button>
                                </form>
                                <form method="post" action="admin-pt-availability" style="display: inline;">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="id" value="<%= availability.getId() %>">
                                    <button type="submit" class="btn-reject">
                                        <i class="fas fa-times me-1"></i>
                                        Từ chối
                                    </button>
                                </form>
                            </div>
                        </div>
                        <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </main>

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
    </script>
</body>
</html>
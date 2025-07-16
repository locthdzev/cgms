<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quartz Scheduler Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <style>
        .job-card {
            transition: all 0.3s ease;
        }
        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.3rem 0.6rem;
        }
        .job-actions {
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row mb-4">
            <div class="col">
                <h1 class="display-5 fw-bold text-primary">
                    <i class="bi bi-clock-history me-2"></i>Quartz Scheduler Dashboard
                </h1>
                <p class="lead text-muted">Quản lý và giám sát các scheduled jobs</p>
            </div>
        </div>

        <!-- Scheduler Status -->
        <div class="row mb-4">
            <div class="col">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="bi bi-info-circle me-2"></i>Trạng thái Scheduler
                        </h5>
                        <div class="d-flex align-items-center mt-3">
                            <div class="bg-${schedulerRunning ? 'success' : 'danger'} rounded-circle p-2 me-3">
                                <i class="bi bi-${schedulerRunning ? 'play-fill' : 'stop-fill'} text-white"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">${schedulerRunning ? 'Đang chạy' : 'Đã dừng'}</h6>
                                <small class="text-muted">Từ: ${runningSince}</small>
                            </div>
                            <div class="ms-auto">
                                <span class="badge bg-primary rounded-pill">
                                    <i class="bi bi-check-circle me-1"></i>${jobsExecuted} jobs đã thực thi
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Jobs List -->
        <div class="row mb-4">
            <div class="col">
                <h2 class="h4 mb-3">
                    <i class="bi bi-list-task me-2"></i>Danh sách Jobs
                </h2>
                
                <c:forEach var="job" items="${jobs}">
                    <div class="card job-card border-0 shadow-sm mb-3">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-4">
                                    <h5 class="card-title mb-1">${job.name}</h5>
                                    <p class="card-text text-muted mb-0 small">Group: ${job.group}</p>
                                </div>
                                <div class="col-md-3">
                                    <div class="mb-2">
                                        <small class="text-muted d-block">Lần chạy tiếp theo:</small>
                                        <span>${job.nextFireTime != null ? job.nextFireTime : 'N/A'}</span>
                                    </div>
                                    <div>
                                        <small class="text-muted d-block">Lần chạy trước:</small>
                                        <span>${job.previousFireTime != null ? job.previousFireTime : 'N/A'}</span>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <span class="badge bg-${job.state == 'NORMAL' ? 'success' : (job.state == 'PAUSED' ? 'warning' : 'secondary')} status-badge">
                                        ${job.state}
                                    </span>
                                </div>
                                <div class="col-md-3">
                                    <div class="job-actions">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/scheduler/trigger/${job.triggerPath}">
                                            <button type="submit" class="btn btn-primary btn-sm">
                                                <i class="bi bi-play-fill me-1"></i>Trigger Now
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        
        <!-- Logs Section -->
        <div class="row">
            <div class="col">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="bi bi-journal-text me-2"></i>Nhật ký hoạt động
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Thời gian</th>
                                        <th>Job</th>
                                        <th>Kết quả</th>
                                        <th>Thời gian thực thi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="log" items="${executionLogs}">
                                        <tr>
                                            <td>${log.timestamp}</td>
                                            <td>${log.jobName}</td>
                                            <td>
                                                <span class="badge bg-${log.success ? 'success' : 'danger'}">
                                                    ${log.success ? 'Thành công' : 'Thất bại'}
                                                </span>
                                            </td>
                                            <td>${log.executionTime}ms</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty executionLogs}">
                                        <tr>
                                            <td colspan="4" class="text-center">Chưa có nhật ký thực thi</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto refresh page every 30 seconds
        setTimeout(function() {
            location.reload();
        }, 30000);
    </script>
</body>
</html> 
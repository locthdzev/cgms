<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scheduler Status</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <style>
        .status-card {
            border-left: 5px solid #0d6efd;
        }
        .status-item {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .status-item:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row mb-4">
            <div class="col">
                <h1 class="display-5 fw-bold text-primary">
                    <i class="bi bi-info-circle me-2"></i>Scheduler Status
                </h1>
                <p class="lead text-muted">Thông tin chi tiết về trạng thái của Quartz Scheduler</p>
            </div>
        </div>
        
        <div class="row">
            <div class="col">
                <div class="card border-0 shadow-sm status-card">
                    <div class="card-body">
                        <div class="status-item">
                            <strong>Scheduler Name:</strong>
                            <span class="ms-2">${metaData.schedulerName}</span>
                        </div>
                        <div class="status-item">
                            <strong>Scheduler Instance ID:</strong>
                            <span class="ms-2">${metaData.schedulerInstanceId}</span>
                        </div>
                        <div class="status-item">
                            <strong>Version:</strong>
                            <span class="ms-2">${metaData.version}</span>
                        </div>
                        <div class="status-item">
                            <strong>Running Since:</strong>
                            <span class="ms-2">${metaData.runningSince}</span>
                        </div>
                        <div class="status-item">
                            <strong>Number of Jobs Executed:</strong>
                            <span class="ms-2">${metaData.numberOfJobsExecuted}</span>
                        </div>
                        <div class="status-item">
                            <strong>Thread Pool Size:</strong>
                            <span class="ms-2">${metaData.threadPoolSize}</span>
                        </div>
                        <div class="status-item">
                            <strong>Is Scheduler Remote:</strong>
                            <span class="ms-2 badge ${metaData.schedulerRemote ? 'bg-success' : 'bg-danger'}">${metaData.schedulerRemote}</span>
                        </div>
                        <div class="status-item">
                            <strong>Is Started:</strong>
                            <span class="ms-2 badge ${metaData.started ? 'bg-success' : 'bg-danger'}">${metaData.started}</span>
                        </div>
                        <div class="status-item">
                            <strong>Is Shutdown:</strong>
                            <span class="ms-2 badge ${metaData.shutdown ? 'bg-danger' : 'bg-success'}">${metaData.shutdown}</span>
                        </div>
                        <div class="status-item">
                            <strong>Is Standby Mode:</strong>
                            <span class="ms-2 badge ${metaData.inStandbyMode ? 'bg-warning' : 'bg-success'}">${metaData.inStandbyMode}</span>
                        </div>
                    </div>
                </div>
                
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/admin/scheduler/" class="btn btn-primary">
                        <i class="bi bi-arrow-left me-2"></i>Quay lại Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
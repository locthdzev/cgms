<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.Package" %>
<%@ page import="java.util.List" %>
<%
    List<Package> packageList = (List<Package>) request.getAttribute("packages");
    
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
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png"/>
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png"/>
    <title>CoreFit Gym Management System</title>
        <!-- Fonts and icons -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet"/>
        <!-- Nucleo Icons -->
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet"/>
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet"/>
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <!-- CSS Files -->
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet"/>
    <style>
        .package-card {
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .package-card .card-body {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .package-card .card-footer {
            margin-top: auto;
        }

        .package-image {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }

        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 2;
        }
        
        .package-actions {
            position: absolute;
            top: 10px;
            left: 10px;
            z-index: 2;
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
        
        .detail-label {
            font-weight: 600;
            color: #344767;
        }
        
        .package-detail-img {
            max-height: 300px;
            object-fit: cover;
            border-radius: 10px;
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
                <jsp:param name="pageTitle" value="Gói tập Gym" />
                <jsp:param name="parentPage" value="Dashboard" />
                <jsp:param name="parentPageUrl" value="dashboard.jsp" />
                <jsp:param name="currentPage" value="Gói tập Gym" />
            </jsp:include>
            
            <div class="container-fluid py-4">
                <div class="row mb-4">
                    <div class="col-12 d-flex justify-content-between align-items-center">
                        <h4 class="text-white mb-0">Danh sách gói tập</h4>
                        <div>
                            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <a href="addPackage" class="btn btn-primary btn-sm">
                                <i class="fas fa-plus me-2"></i>Thêm gói tập mới
                            </a>
                        </div>
                    </div>
                </div>
                            
                <div class="row">
                    <% if (packageList != null && !packageList.isEmpty()) {
                        for (Package pkg : packageList) { %>
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card package-card">
                            <% if ("Active".equals(pkg.getStatus())) { %>
                            <span class="badge bg-gradient-success status-badge">Hoạt động</span>
                            <% } else { %>
                            <span class="badge bg-gradient-secondary status-badge">Không hoạt động</span>
                            <% } %>
                            
                            <div class="package-actions">
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-icon-only bg-gradient-light text-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-ellipsis-v"></i>
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="editPackage?id=<%= pkg.getId() %>"><i class="fas fa-edit me-2"></i>Chỉnh sửa</a></li>
                                        <li>
                                            <a class="dropdown-item view-details-btn" href="#" 
                                               data-id="<%= pkg.getId() %>" 
                                               data-name="<%= pkg.getName() %>" 
                                               data-price="<%= String.format("%,.0f", pkg.getPrice()) %>" 
                                               data-duration="<%= pkg.getDuration() %>" 
                                               data-sessions="<%= pkg.getSessions() != null ? pkg.getSessions() : "Không giới hạn" %>" 
                                               data-description="<%= pkg.getDescription() != null ? pkg.getDescription() : "Không có mô tả" %>" 
                                               data-status="<%= pkg.getStatus() %>"
                                               data-created="<%= pkg.getCreatedAt() != null ? pkg.getCreatedAt() : "N/A" %>"
                                               data-updated="<%= pkg.getUpdatedAt() != null ? pkg.getUpdatedAt() : "N/A" %>">
                                                <i class="fas fa-eye me-2"></i>Xem chi tiết
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item toggle-status-btn" href="#" 
                                               data-id="<%= pkg.getId() %>" 
                                               data-name="<%= pkg.getName() %>" 
                                               data-status="<%= pkg.getStatus() %>">
                                                <i class="fas fa-<%= "Active".equals(pkg.getStatus()) ? "ban" : "check" %> me-2"></i>
                                                <%= "Active".equals(pkg.getStatus()) ? "Vô hiệu hóa" : "Kích hoạt" %>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            
                            <img src="assets/svg/rain-7750488.svg"
                                 class="card-img-top package-image" alt="<%= pkg.getName() %>">
                            <div class="card-body">
                                <h5 class="card-title"><%= pkg.getName() %></h5>
                                <p class="card-text text-sm mb-2"><%= pkg.getDescription() %></p>
                                <div class="d-flex justify-content-between align-items-center mt-2">
                                    <span class="text-dark font-weight-bold"><%= String.format("%,.0f", pkg.getPrice()) %> VNĐ</span>
                                    <span class="badge bg-gradient-info"><%= pkg.getDuration() %> ngày</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }
                    } else { %>
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <h5>Không có gói tập nào.</h5>
                                <p>Hãy thêm gói tập mới để bắt đầu.</p>
                                <a href="addPackage" class="btn btn-primary mt-3">
                                    <i class="fas fa-plus me-2"></i>Thêm gói tập mới
                                </a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>

        <!-- Modal xác nhận thay đổi trạng thái gói tập -->
        <div class="modal fade" id="toggleStatusModal" tabindex="-1" aria-labelledby="toggleStatusModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="toggleStatusModalLabel">Xác nhận thay đổi trạng thái</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn <span id="actionType"></span> gói tập <span id="packageName" class="fw-bold"></span>?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <a href="#" id="confirmToggleBtn" class="btn btn-primary">Xác nhận</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal xem chi tiết gói tập -->
        <div class="modal fade" id="packageDetailModal" tabindex="-1" aria-labelledby="packageDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="packageDetailModalLabel">Chi tiết gói tập</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-5 mb-3">
                                <img src="assets/svg/rain-7750488.svg" class="img-fluid package-detail-img" id="packageDetailImage" alt="Package Image">
                            </div>
                            <div class="col-md-7">
                                <h4 id="packageDetailName" class="mb-3"></h4>
                                <div class="mb-2">
                                    <span id="packageDetailStatus" class="badge"></span>
                                </div>
                                <div class="mb-2">
                                    <span class="detail-label">Giá:</span> 
                                    <span id="packageDetailPrice" class="ms-2"></span> VNĐ
                                </div>
                                <div class="mb-2">
                                    <span class="detail-label">Thời hạn:</span> 
                                    <span id="packageDetailDuration" class="ms-2"></span> tháng
                                </div>
                                <div class="mb-2">
                                    <span class="detail-label">Số buổi tập:</span> 
                                    <span id="packageDetailSessions" class="ms-2"></span>
                                </div>
                                <div class="mb-3">
                                    <span class="detail-label">Mô tả:</span>
                                    <p id="packageDetailDescription" class="mt-1"></p>
                                </div>
                                <div class="mb-2 small text-muted">
                                    <span class="detail-label">Ngày tạo:</span> 
                                    <span id="packageDetailCreated" class="ms-2"></span>
                                </div>
                                <div class="small text-muted">
                                    <span class="detail-label">Cập nhật lần cuối:</span> 
                                    <span id="packageDetailUpdated" class="ms-2"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <a href="#" id="editPackageBtn" class="btn btn-primary">Chỉnh sửa</a>
                    </div>
                </div>
            </div>
        </div>

        <!--   Core JS Files   -->
        <script src="./assets/js/core/popper.min.js"></script>
        <script src="./assets/js/core/bootstrap.min.js"></script>
        <script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="./assets/js/plugins/smooth-scrollbar.min.js"></script>
        <script>
            var win = navigator.platform.indexOf('Win') > -1;
            if (win && document.querySelector('#sidenav-scrollbar')) {
                var options = {
                    damping: '0.5'
                }
                Scrollbar.init(document.querySelector('#sidenav-scrollbar'), options);
            }
            
            document.addEventListener('DOMContentLoaded', function() {
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
                
                // Xử lý sự kiện click cho các nút thay đổi trạng thái
                document.querySelectorAll('.toggle-status-btn').forEach(function(button) {
                    button.addEventListener('click', function(e) {
                        e.preventDefault();
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        const status = this.getAttribute('data-status');
                        const newStatus = status === 'Active' ? 'Inactive' : 'Active';
                        const actionText = status === 'Active' ? 'vô hiệu hóa' : 'kích hoạt';
                        
                        document.getElementById('packageName').textContent = name;
                        document.getElementById('actionType').textContent = actionText;
                        document.getElementById('confirmToggleBtn').href = 'updatePackageStatus?id=' + id + '&status=' + newStatus;
                        
                        var toggleModal = new bootstrap.Modal(document.getElementById('toggleStatusModal'));
                        toggleModal.show();
                    });
                });
                
                // Xử lý sự kiện click cho nút xem chi tiết
                document.querySelectorAll('.view-details-btn').forEach(function(button) {
                    button.addEventListener('click', function(e) {
                        e.preventDefault();
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        const price = this.getAttribute('data-price');
                        const duration = this.getAttribute('data-duration');
                        const sessions = this.getAttribute('data-sessions');
                        const description = this.getAttribute('data-description');
                        const status = this.getAttribute('data-status');
                        const created = this.getAttribute('data-created');
                        const updated = this.getAttribute('data-updated');
                        
                        // Cập nhật nội dung modal
                        document.getElementById('packageDetailName').textContent = name;
                        document.getElementById('packageDetailPrice').textContent = price;
                        document.getElementById('packageDetailDuration').textContent = duration;
                        document.getElementById('packageDetailSessions').textContent = sessions;
                        document.getElementById('packageDetailDescription').textContent = description;
                        document.getElementById('packageDetailCreated').textContent = formatDateWithTime(created) || 'N/A';
                        document.getElementById('packageDetailUpdated').textContent = formatDateWithTime(updated) || 'N/A';
                        
                        // Cập nhật trạng thái
                        const statusBadge = document.getElementById('packageDetailStatus');
                        if (status === 'Active') {
                            statusBadge.className = 'badge bg-gradient-success';
                            statusBadge.textContent = 'Hoạt động';
                        } else {
                            statusBadge.className = 'badge bg-gradient-secondary';
                            statusBadge.textContent = 'Không hoạt động';
                        }
                        
                        // Cập nhật link chỉnh sửa
                        document.getElementById('editPackageBtn').href = 'editPackage?id=' + id;
                        
                        // Hiển thị modal
                        var detailModal = new bootstrap.Modal(document.getElementById('packageDetailModal'));
                        detailModal.show();
                    });
                });
            });
            
            // Hàm định dạng ngày tháng kèm giờ phút giây
            function formatDateWithTime(dateStr) {
                if (!dateStr || dateStr === 'N/A') return 'N/A';
                try {
                    // Xử lý định dạng timestamp kiểu ISO
                    if (dateStr.includes('T') && dateStr.includes('Z')) {
                        const date = new Date(dateStr);
                        if (!isNaN(date.getTime())) {
                            return date.getDate().toString().padStart(2, '0') + '/' + 
                                (date.getMonth() + 1).toString().padStart(2, '0') + '/' + 
                                date.getFullYear() + ' ' +
                                date.getHours().toString().padStart(2, '0') + ':' +
                                date.getMinutes().toString().padStart(2, '0') + ':' +
                                date.getSeconds().toString().padStart(2, '0');
                        }
                    }
                    
                    // Xử lý định dạng timestamp khác
                    if (dateStr.includes('/')) {
                        const parts = dateStr.split('/');
                        if (parts.length >= 3) {
                            // Định dạng như 18T23:13:59.830Z/06/2025
                            const dayPart = parts[0].split('T');
                            const day = dayPart[0];
                            const month = parts[1];
                            const year = parts[2];
                            
                            // Nếu có thông tin giờ
                            if (dayPart.length > 1) {
                                const timePart = dayPart[1].split(':');
                                if (timePart.length >= 3) {
                                    const hour = timePart[0];
                                    const minute = timePart[1];
                                    const second = timePart[2].split('.')[0]; // Loại bỏ mili giây
                                    return day.padStart(2, '0') + '/' + month.padStart(2, '0') + '/' + year + ' ' +
                                        hour.padStart(2, '0') + ':' + minute.padStart(2, '0') + ':' + second.padStart(2, '0');
                                }
                            }
                            
                            return day.padStart(2, '0') + '/' + month.padStart(2, '0') + '/' + year;
                        }
                    }
                    
                    // Xử lý định dạng yyyy-MM-dd
                    const parts = dateStr.split('-');
                    if (parts.length === 3) {
                        return parts[2] + '/' + parts[1] + '/' + parts[0];
                    }
                    
                    return dateStr;
                } catch (e) {
                    return dateStr;
                }
            }
        </script>
    </body>
</html>






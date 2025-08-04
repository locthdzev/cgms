<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Package" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    if (session.getAttribute("loggedInUser") == null || 
        !"Admin".equals(((User) session.getAttribute("loggedInUser")).getRole())) {
        response.sendRedirect("login");
        return;
    }

    List<User> members = (List<User>) request.getAttribute("members");
    List<Package> packages = (List<Package>) request.getAttribute("packages");
    
    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    boolean hasSuccessMessage = (successMessage != null);
    boolean hasErrorMessage = (errorMessage != null);
    
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm gói thành viên - CORE-FIT GYM</title>
    
    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/argon-dashboard.css">
    
    <style>
        :root {
            --primary-color: #ff6b35;
            --secondary-color: #1a1a2e;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
        }

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-radius: 12px;
        }

        .card-header {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-bottom: 1px solid #dee2e6;
            border-radius: 12px 12px 0 0 !important;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #d1d3e2;
            padding: 0.75rem 1rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 107, 53, 0.25);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), #ff8a65);
            border: none;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
        }

        .btn-secondary {
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
        }

        .package-info-card {
            background: linear-gradient(135deg, #e3f2fd, #f3e5f5);
            border: none;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1rem;
            display: none;
        }

        .package-info-card.show {
            display: block;
            animation: fadeIn 0.3s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #333;
        }

        .info-value {
            color: var(--primary-color);
            font-weight: 700;
        }

        .payment-methods {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1rem;
        }

        .form-check {
            padding: 1rem;
            background: white;
            border-radius: 8px;
            margin-bottom: 0.75rem;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .form-check:hover {
            border-color: var(--primary-color);
            box-shadow: 0 2px 8px rgba(255, 107, 53, 0.15);
        }

        .form-check-input:checked + .form-check-label {
            color: var(--primary-color);
            font-weight: 600;
        }

        .member-warning {
            animation: slideDown 0.3s ease-in;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
    <!-- Toast Container -->
    <div class="toast-container"></div>
    
    <!-- Sidebar -->
    <%@ include file="sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <%@ include file="navbar.jsp" %>

        <div class="container-fluid py-4">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="text-white mb-0">
                        <i class="fas fa-plus me-2"></i>
                        Thêm gói thành viên
                    </h2>
                    <p class="text-white opacity-8 mb-0">Tạo gói tập mới cho thành viên</p>
                </div>
                <a href="admin-member-packages" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>
                    Quay lại danh sách
                </a>
            </div>

            <!-- Create Form -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="mb-0">
                                <i class="fas fa-user-plus me-2"></i>
                                Thông tin gói thành viên
                            </h4>
                        </div>
                        <div class="card-body">
                            <form method="post" action="admin-member-packages" id="createPackageForm">
                                <input type="hidden" name="action" value="create">
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="memberId" class="form-label">
                                                <i class="fas fa-user me-2"></i>
                                                Chọn thành viên <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="memberId" name="memberId" required onchange="updateMemberPackages()">
                                                <option value="">-- Chọn thành viên --</option>
                                                <% if (members != null && !members.isEmpty()) { %>
                                                    <% for (User member : members) { %>
                                                        <option value="<%= member.getId() %>">
                                                            <%= member.getFullName() != null ? member.getFullName() : member.getUserName() %> 
                                                            (<%= member.getEmail() %>)
                                                        </option>
                                                    <% } %>
                                                <% } %>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="packageId" class="form-label">
                                                <i class="fas fa-box me-2"></i>
                                                Chọn gói tập <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="packageId" name="packageId" required onchange="updatePackageInfo()">
                                                <option value="">-- Chọn gói tập --</option>
                                                <% if (packages != null && !packages.isEmpty()) { %>
                                                    <% for (Package pkg : packages) { %>
                                                        <option value="<%= pkg.getId() %>" 
                                                                data-price="<%= pkg.getPrice() %>"
                                                                data-duration="<%= pkg.getDuration() %>"
                                                                data-sessions="<%= pkg.getSessions() != null ? pkg.getSessions() : 0 %>"
                                                                data-description="<%= pkg.getDescription() != null ? pkg.getDescription() : "" %>">
                                                            <%= pkg.getName() %> - <%= formatter.format(pkg.getPrice().longValue()) %> VNĐ
                                                        </option>
                                                    <% } %>
                                                <% } %>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Package Info Display -->
                                <div id="packageInfoCard" class="package-info-card">
                                    <h5 class="mb-3">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Thông tin gói tập
                                    </h5>
                                    <div class="info-item">
                                        <span class="info-label">Tên gói:</span>
                                        <span class="info-value" id="packageName">-</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Giá:</span>
                                        <span class="info-value" id="packagePrice">-</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Thời hạn:</span>
                                        <span class="info-value" id="packageDuration">-</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Số buổi tập:</span>
                                        <span class="info-value" id="packageSessions">-</span>
                                    </div>
                                    <div class="info-item" id="packageDescriptionItem" style="display: none;">
                                        <span class="info-label">Mô tả:</span>
                                        <span class="info-value" id="packageDescription">-</span>
                                    </div>
                                </div>

                                <!-- Payment Method -->
                                <div class="payment-methods">
                                    <h5 class="mb-3">
                                        <i class="fas fa-credit-card me-2"></i>
                                        Phương thức thanh toán
                                    </h5>
                                    
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="paymentMethod" id="cashPayment" value="CASH" checked>
                                        <label class="form-check-label" for="cashPayment">
                                            <i class="fas fa-money-bill text-success me-2"></i>
                                            <strong>Tiền mặt</strong>
                                            <br>
                                            <small class="text-muted">Thanh toán trực tiếp tại quầy</small>
                                        </label>
                                    </div>
                                    
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="paymentMethod" id="payosPayment" value="PAYOS">
                                        <label class="form-check-label" for="payosPayment">
                                            <i class="fas fa-credit-card text-info me-2"></i>
                                            <strong>PayOS (Chuyển khoản)</strong>
                                            <br>
                                            <small class="text-muted">Thanh toán qua ngân hàng trực tuyến</small>
                                        </label>
                                    </div>
                                </div>

                                <!-- Submit Buttons -->
                                <div class="d-flex justify-content-end gap-3 mt-4">
                                    <a href="admin-member-packages" class="btn btn-secondary">
                                        <i class="fas fa-times me-2"></i>
                                        Hủy
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>
                                        Tạo gói thành viên
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-lightbulb me-2"></i>
                                Hướng dẫn
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Lưu ý:</strong>
                                <ul class="mb-0 mt-2">
                                    <li>Chọn thành viên và gói tập phù hợp</li>
                                    <li>Kiểm tra thông tin trước khi tạo</li>
                                    <li>Thanh toán tiền mặt sẽ kích hoạt ngay</li>
                                    <li>PayOS cần hoàn tất thanh toán để kích hoạt</li>
                                </ul>
                            </div>
                            
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Chú ý:</strong>
                                Nếu thành viên đã có gói tập đang hoạt động, gói cũ sẽ được hủy tự động.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Show toast messages on page load
        document.addEventListener('DOMContentLoaded', function() {
            <% if (hasSuccessMessage) { %>
                showToast('success', '<%= successMessage %>');
            <% } %>
            
            <% if (hasErrorMessage) { %>
                showToast('error', '<%= errorMessage %>');
            <% } %>
        });

        // Update package info when package is selected
        function updatePackageInfo() {
            const packageSelect = document.getElementById('packageId');
            const selectedOption = packageSelect.options[packageSelect.selectedIndex];
            const packageInfoCard = document.getElementById('packageInfoCard');
            
            if (packageSelect.value && selectedOption) {
                const price = selectedOption.getAttribute('data-price');
                const duration = selectedOption.getAttribute('data-duration');
                const sessions = selectedOption.getAttribute('data-sessions');
                const description = selectedOption.getAttribute('data-description');
                
                // Format price
                const formatter = new Intl.NumberFormat('vi-VN');
                
                // Update info
                document.getElementById('packageName').textContent = selectedOption.textContent.split(' - ')[0];
                document.getElementById('packagePrice').textContent = formatter.format(price) + ' VNĐ';
                document.getElementById('packageDuration').textContent = duration + ' ngày';
                document.getElementById('packageSessions').textContent = sessions + ' buổi';
                
                // Show/hide description
                const descriptionItem = document.getElementById('packageDescriptionItem');
                if (description && description.trim() !== '') {
                    document.getElementById('packageDescription').textContent = description;
                    descriptionItem.style.display = 'flex';
                } else {
                    descriptionItem.style.display = 'none';
                }
                
                packageInfoCard.classList.add('show');
            } else {
                packageInfoCard.classList.remove('show');
            }
        }

        // Check active packages when member is selected
        function updateMemberPackages() {
            const memberId = document.getElementById('memberId').value;
            if (!memberId) {
                // Remove existing warning
                const existingWarning = document.querySelector('.member-warning');
                if (existingWarning) {
                    existingWarning.remove();
                }
                return;
            }

            // Get member's active packages
            fetch('admin-member-packages?action=getActivePackages&memberId=' + memberId, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success && data.activePackages && data.activePackages.length > 0) {
                    // Build package list HTML using standard JavaScript
                    var packageListHtml = '';
                    for (var i = 0; i < data.activePackages.length; i++) {
                        var pkg = data.activePackages[i];
                        packageListHtml += '<li>' + pkg.packageName + ' (' + pkg.startDate + ' - ' + pkg.endDate + ')</li>';
                    }
                    
                    // Show warning about existing active packages
                    const warningDiv = document.createElement('div');
                    warningDiv.className = 'alert alert-warning mt-3 member-warning';
                    warningDiv.innerHTML = 
                        '<i class="fas fa-exclamation-triangle me-2"></i>' +
                        '<strong>Cảnh báo:</strong> Thành viên này đang có ' + data.activePackages.length + ' gói tập hoạt động. ' +
                        'Khi tạo gói mới, các gói cũ sẽ được hủy tự động.' +
                        '<ul class="mt-2 mb-0">' + packageListHtml + '</ul>';
                    
                    // Remove existing warning
                    const existingWarning = document.querySelector('.member-warning');
                    if (existingWarning) {
                        existingWarning.remove();
                    }
                    
                    // Add new warning
                    document.getElementById('memberId').parentNode.appendChild(warningDiv);
                } else {
                    // Remove warning if no active packages
                    const existingWarning = document.querySelector('.member-warning');
                    if (existingWarning) {
                        existingWarning.remove();
                    }
                }
            })
            .catch(error => {
                console.error('Error checking active packages:', error);
            });
        }

        // Form validation
        document.getElementById('createPackageForm').addEventListener('submit', function(e) {
            const memberId = document.getElementById('memberId').value;
            const packageId = document.getElementById('packageId').value;
            
            if (!memberId || !packageId) {
                e.preventDefault();
                showToast('error', 'Vui lòng chọn đầy đủ thông tin thành viên và gói tập');
                return false;
            }
        });

        // Toast notification function
        function showToast(type, message) {
            const toastContainer = document.querySelector('.toast-container');
            const toast = document.createElement('div');
            toast.className = 'toast align-items-center text-white bg-' + (type === 'success' ? 'success' : 'danger') + ' border-0';
            toast.setAttribute('role', 'alert');
            toast.innerHTML = 
                '<div class="d-flex">' +
                    '<div class="toast-body">' +
                        '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle') + ' me-2"></i>' + message +
                    '</div>' +
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
                '</div>';
            
            toastContainer.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            // Remove toast element after it's hidden
            toast.addEventListener('hidden.bs.toast', function() {
                toast.remove();
            });
        }
    </script>
</body>
</html>
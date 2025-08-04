<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%@ page import="Models.MemberPackage" %>
<%@ page import="Models.Package" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    // Không khai báo lại loggedInUser vì navbar.jsp đã khai báo
    if (session.getAttribute("loggedInUser") == null || 
        !"Admin".equals(((User) session.getAttribute("loggedInUser")).getRole())) {
        response.sendRedirect("login");
        return;
    }

    List<MemberPackage> memberPackages = (List<MemberPackage>) request.getAttribute("memberPackages");
    List<User> members = (List<User>) request.getAttribute("members");
    List<Package> packages = (List<Package>) request.getAttribute("packages");
    String statusFilter = (String) request.getAttribute("statusFilter");
    
    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
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
    <title>Quản lý gói thành viên - CORE-FIT GYM</title>
    
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.success {
            background: linear-gradient(135deg, #28a745, #20c997);
        }

        .stat-card.warning {
            background: linear-gradient(135deg, #ffc107, #fd7e14);
        }

        .stat-card.danger {
            background: linear-gradient(135deg, #dc3545, #e83e8c);
        }

        .stat-card.info {
            background: linear-gradient(135deg, #17a2b8, #6f42c1);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .filter-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
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

        .status-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-expired {
            background: #f8d7da;
            color: #721c24;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .btn-action {
            padding: 0.375rem 0.75rem;
            margin: 0.125rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-view {
            background: var(--info-color);
            color: white;
        }

        .btn-view:hover {
            background: #138496;
            transform: translateY(-1px);
        }

        .btn-cancel {
            background: var(--danger-color);
            color: white;
        }

        .btn-cancel:hover {
            background: #c82333;
            transform: translateY(-1px);
        }

        .btn-payment {
            background: var(--success-color);
            color: white;
        }

        .btn-payment:hover {
            background: #218838;
            transform: translateY(-1px);
        }

        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), #ff8a65);
            color: white;
            border-bottom: none;
        }

        .modal-header .btn-close {
            filter: brightness(0) invert(1);
        }

        .membership-card-preview {
            max-height: 600px;
            overflow: hidden;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .modal-lg {
            max-width: 800px;
        }

        .modal-body {
            padding: 0;
        }

        .modal-footer {
            border-top: 1px solid #dee2e6;
            background: #f8f9fa;
        }

        /* Member layout style */
        .member-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color), #ff8a65);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 0.75rem;
        }

        .member-info {
            flex: 1;
        }

        .member-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 0.25rem;
        }

        .member-email {
            color: #666;
            font-size: 0.875rem;
        }

        .package-info {
            flex: 1;
        }

        .package-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 0.25rem;
        }

        .package-duration {
            color: #666;
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .table-responsive {
                font-size: 0.875rem;
            }
            
            .btn-action {
                padding: 0.25rem 0.5rem;
                font-size: 0.7rem;
            }
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
                        <i class="fas fa-id-card me-2"></i>
                        Quản lý gói thành viên
                    </h2>
                    <p class="text-white opacity-8 mb-0">Quản lý toàn bộ gói tập của thành viên</p>
                </div>
                <a href="admin-member-packages?action=create" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>
                    Thêm gói thành viên
                </a>
            </div>

            <!-- Statistics Cards -->
            <%
                int totalPackages = memberPackages != null ? memberPackages.size() : 0;
                int activePackages = 0;
                int pendingPackages = 0;
                int expiredPackages = 0;
                int cancelledPackages = 0;
                
                if (memberPackages != null) {
                    for (MemberPackage mp : memberPackages) {
                        String status = mp.getStatus();
                        if ("ACTIVE".equals(status)) activePackages++;
                        else if ("PENDING".equals(status)) pendingPackages++;
                        else if ("EXPIRED".equals(status)) expiredPackages++;
                        else if ("CANCELLED".equals(status)) cancelledPackages++;
                    }
                }
            %>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><%= totalPackages %></div>
                    <div class="stat-label">Tổng số gói</div>
                </div>
                
                <div class="stat-card success">
                    <div class="stat-number"><%= activePackages %></div>
                    <div class="stat-label">Đang hoạt động</div>
                </div>
                
                <div class="stat-card warning">
                    <div class="stat-number"><%= pendingPackages %></div>
                    <div class="stat-label">Chờ thanh toán</div>
                </div>
                
                <div class="stat-card info">
                    <div class="stat-number"><%= expiredPackages %></div>
                    <div class="stat-label">Đã hết hạn</div>
                </div>
                
                <div class="stat-card danger">
                    <div class="stat-number"><%= cancelledPackages %></div>
                    <div class="stat-label">Đã hủy</div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <form method="get" action="admin-member-packages">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label">Lọc theo trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="ALL" <%= "ALL".equals(statusFilter) ? "selected" : "" %>>Tất cả</option>
                                <option value="ACTIVE" <%= "ACTIVE".equals(statusFilter) ? "selected" : "" %>>Đang hoạt động</option>
                                <option value="PENDING" <%= "PENDING".equals(statusFilter) ? "selected" : "" %>>Chờ thanh toán</option>
                                <option value="EXPIRED" <%= "EXPIRED".equals(statusFilter) ? "selected" : "" %>>Đã hết hạn</option>
                                <option value="CANCELLED" <%= "CANCELLED".equals(statusFilter) ? "selected" : "" %>>Đã hủy</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter me-2"></i>Lọc
                            </button>
                            <a href="admin-member-packages" class="btn btn-secondary ms-2">
                                <i class="fas fa-refresh me-2"></i>Reset
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Member Packages Table -->
            <div class="card">
                <div class="card-header pb-0">
                    <h4 class="mb-0">
                        <i class="fas fa-list me-2"></i>
                        Danh sách gói thành viên
                    </h4>
                </div>

                <div class="card-body px-0 pt-0 pb-2">
                    <div class="table-responsive p-0">
                        <table class="table align-items-center mb-0">
                            <thead>
                                <tr>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Thành viên</th>
                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Gói tập</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Giá</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Thời hạn</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Buổi còn lại</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                    <th class="text-secondary opacity-7">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (memberPackages != null && !memberPackages.isEmpty()) { %>
                                    <% for (MemberPackage mp : memberPackages) { 
                                        String statusClass = "";
                                        String statusText = "";
                                        
                                        switch (mp.getStatus()) {
                                            case "ACTIVE":
                                                statusClass = "status-active";
                                                statusText = "Đang hoạt động";
                                                break;
                                            case "PENDING":
                                                statusClass = "status-pending";
                                                statusText = "Chờ thanh toán";
                                                break;
                                            case "EXPIRED":
                                                statusClass = "status-expired";
                                                statusText = "Đã hết hạn";
                                                break;
                                            case "CANCELLED":
                                                statusClass = "status-cancelled";
                                                statusText = "Đã hủy";
                                                break;
                                            default:
                                                statusClass = "status-pending";
                                                statusText = mp.getStatus();
                                        }
                                        
                                        String memberName = mp.getMember().getFullName();
                                        if (memberName == null || memberName.trim().isEmpty()) {
                                            memberName = mp.getMember().getUserName();
                                        }
                                        String memberInitial = memberName.substring(0, 1).toUpperCase();
                                    %>
                                    <tr>
                                        <td>
                                            <div class="d-flex px-2 py-1">
                                                <div class="member-avatar">
                                                    <%= memberInitial %>
                                                </div>
                                                <div class="member-info">
                                                    <div class="member-name">
                                                        <%= memberName %>
                                                    </div>
                                                    <div class="member-email">
                                                        <%= mp.getMember().getEmail() %>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="package-info">
                                                <div class="package-name">
                                                    <%= mp.getPackageField().getName() %>
                                                </div>
                                                <div class="package-duration">
                                                    <%= mp.getPackageField().getDuration() %> ngày
                                                </div>
                                            </div>
                                        </td>
                                        <td class="align-middle text-center text-sm">
                                            <span class="text-xs font-weight-bold">
                                                <%= formatter.format(mp.getTotalPrice().longValue()) %> VNĐ
                                            </span>
                                        </td>
                                        <td class="align-middle text-center">
                                            <span class="text-secondary text-xs font-weight-bold">
                                                <%= mp.getStartDate().format(dateFormatter) %><br>
                                                <small>đến</small><br>
                                                <%= mp.getEndDate().format(dateFormatter) %>
                                            </span>
                                        </td>
                                        <td class="align-middle text-center text-sm">
                                            <span class="badge badge-sm bg-gradient-info">
                                                <%= mp.getRemainingSessions() %> buổi
                                            </span>
                                        </td>
                                        <td class="align-middle text-center text-sm">
                                            <span class="status-badge <%= statusClass %>">
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td class="align-middle">
                                            <button class="btn-action btn-view" 
                                                    onclick="viewMembershipCard(<%= mp.getId() %>)"
                                                    title="Xem thẻ">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            
                                            <% if ("PENDING".equals(mp.getStatus())) { %>
                                            <button class="btn-action btn-payment" 
                                                    onclick="showPaymentModal(<%= mp.getId() %>)"
                                                    title="Thanh toán">
                                                <i class="fas fa-credit-card"></i>
                                            </button>
                                            <% } %>
                                            
                                            <% if (!"CANCELLED".equals(mp.getStatus()) && !"EXPIRED".equals(mp.getStatus())) { %>
                                            <button class="btn-action btn-cancel" 
                                                    onclick="cancelMemberPackage(<%= mp.getId() %>)"
                                                    title="Hủy">
                                                <i class="fas fa-times"></i>
                                            </button>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="7" class="text-center py-4">
                                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">Không có gói thành viên nào</h5>
                                            <p class="text-muted">Hãy thêm gói thành viên đầu tiên</p>
                                            <a href="admin-member-packages?action=create" class="btn btn-primary">
                                                <i class="fas fa-plus me-2"></i>Thêm gói thành viên
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Membership Card Modal -->
    <div class="modal fade" id="membershipCardModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-id-card me-2"></i>
                        Thẻ thành viên
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="membershipCardContent" class="membership-card-preview">
                        <!-- Membership card will be loaded here -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary" onclick="printMembershipCard()">
                        <i class="fas fa-print me-2"></i>In thẻ
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Payment Modal -->
    <div class="modal fade" id="paymentModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-credit-card me-2"></i>
                        Xử lý thanh toán
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="paymentForm" method="post" action="admin-member-packages">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="payment">
                        <input type="hidden" name="memberPackageId" id="paymentMemberPackageId">
                        
                        <div class="mb-3">
                            <label class="form-label">Phương thức thanh toán</label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="cashPayment" value="CASH" checked>
                                <label class="form-check-label" for="cashPayment">
                                    <i class="fas fa-money-bill text-success me-2"></i>
                                    Tiền mặt
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="payosPayment" value="PAYOS">
                                <label class="form-check-label" for="payosPayment">
                                    <i class="fas fa-credit-card text-info me-2"></i>
                                    PayOS (Chuyển khoản)
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-check me-2"></i>Xác nhận thanh toán
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Cancel Confirmation Modal -->
    <div class="modal fade" id="cancelConfirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Xác nhận hủy gói tập
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-3">
                        <i class="fas fa-times-circle text-danger" style="font-size: 3rem;"></i>
                    </div>
                    <h6 class="text-center mb-3">Bạn có chắc chắn muốn hủy gói tập này không?</h6>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Hành động này không thể hoàn tác. Gói tập sẽ được chuyển sang trạng thái "Đã hủy".
                    </div>
                    <input type="hidden" id="cancelMemberPackageId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Không, giữ lại
                    </button>
                    <button type="button" class="btn btn-danger" onclick="confirmCancellation()">
                        <i class="fas fa-check me-2"></i>Có, hủy gói tập
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let currentMemberPackageId = null;

        // Show toast messages on page load
        document.addEventListener('DOMContentLoaded', function() {
            <% if (hasSuccessMessage) { %>
                showToast('success', '<%= successMessage %>');
            <% } %>
            
            <% if (hasErrorMessage) { %>
                showToast('error', '<%= errorMessage %>');
            <% } %>
        });

        // View membership card
        function viewMembershipCard(memberPackageId) {
            currentMemberPackageId = memberPackageId;
            
            // Show loading
            document.getElementById('membershipCardContent').innerHTML = 
                '<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x"></i><br>Đang tải thẻ thành viên...</div>';
            
            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('membershipCardModal'));
            modal.show();
            
            // Load membership card
            fetch('admin-membership-card?action=view&id=' + memberPackageId, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Create iframe to display the card properly
                    const iframe = document.createElement('iframe');
                    iframe.style.width = '100%';
                    iframe.style.height = '600px';
                    iframe.style.border = 'none';
                    iframe.style.borderRadius = '8px';
                    
                    document.getElementById('membershipCardContent').innerHTML = '';
                    document.getElementById('membershipCardContent').appendChild(iframe);
                    
                    // Write the HTML content to iframe
                    iframe.contentDocument.open();
                    iframe.contentDocument.write(data.html);
                    iframe.contentDocument.close();
                } else {
                    document.getElementById('membershipCardContent').innerHTML = 
                        '<div class="alert alert-danger">Không thể tải thẻ thành viên</div>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('membershipCardContent').innerHTML = 
                    '<div class="alert alert-danger">Có lỗi xảy ra khi tải thẻ thành viên</div>';
            });
        }

        // Print membership card - open new window with auto-print
        function printMembershipCard() {
            if (currentMemberPackageId) {
                window.open('admin-membership-card?action=print&id=' + currentMemberPackageId, '_blank');
            }
        }

        // Show payment modal
        function showPaymentModal(memberPackageId) {
            document.getElementById('paymentMemberPackageId').value = memberPackageId;
            new bootstrap.Modal(document.getElementById('paymentModal')).show();
        }

        // Cancel member package with confirmation modal
        function cancelMemberPackage(memberPackageId) {
            // Set the member package ID for cancellation
            document.getElementById('cancelMemberPackageId').value = memberPackageId;
            
            // Show confirmation modal
            new bootstrap.Modal(document.getElementById('cancelConfirmModal')).show();
        }

        // Confirm cancellation
        function confirmCancellation() {
            const memberPackageId = document.getElementById('cancelMemberPackageId').value;
            
            const form = document.createElement('form');
            form.method = 'post';
            form.action = 'admin-member-packages';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'cancel';
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'memberPackageId';
            idInput.value = memberPackageId;
            
            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }

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
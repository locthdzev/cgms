<%-- 
    Document   : order
    Created on : Jul 15, 2025, 8:56:00 PM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="Models.User"%>
<%@page import="Models.Order"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    List<Order> orders = (List<Order>) request.getAttribute("orderList");
    
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
%>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <link rel="apple-touch-icon" sizes="76x76" href="${pageContext.request.contextPath}/assets/img/icons8-gym-96.png" />
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/icons8-gym-96.png" />
        <title>CORE-FIT GYM</title>

        <!-- Fonts and icons -->
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link id="pagestyle" href="${pageContext.request.contextPath}/assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
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

            .order-detail-img {
                max-height: 300px;
                object-fit: cover;
                border-radius: 10px;
            }

            /* Delete button style */
            .delete-action {
                color: #f5365c !important;
            }

            .delete-action:hover {
                background-color: #ffeef1 !important;
            }

            /* Filter styles */
            .filter-section {
                background-color: #f8f9fa;
                padding: 1rem;
                border-radius: 10px;
                margin-bottom: 1rem;
            }

            /* Status badges */
            .status-pending {
                background-color: #ffc107 !important;
            }

            .status-confirmed {
                background-color: #17a2b8 !important;
            }

            .status-processing {
                background-color: #6f42c1 !important;
            }

            .status-shipped {
                background-color: #fd7e14 !important;
            }

            .status-delivered {
                background-color: #28a745 !important;
            }

            .status-cancelled {
                background-color: #dc3545 !important;
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

        <!-- Main Content -->
        <main class="main-content position-relative border-radius-lg">
            <!-- Include Navbar Component with parameters -->
            <jsp:include page="navbar.jsp">
                <jsp:param name="pageTitle" value="Quản lý Đơn hàng" />
                <jsp:param name="parentPage" value="Dashboard" />
                <jsp:param name="parentPageUrl" value="dashboard.jsp" />
                <jsp:param name="currentPage" value="Quản lý Đơn hàng" />
            </jsp:include>

            <!-- Page Content -->
            <div class="container-fluid py-4">
                <!-- Filter Section -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="filter-section">
                            <h6 class="mb-3">Bộ lọc</h6>
                            <div class="row">
                                <div class="col-md-4">
                                    <form method="get" action="${pageContext.request.contextPath}/order">
                                        <input type="hidden" name="action" value="filterByStatus">
                                        <div class="form-group">
                                            <label for="statusFilter">Lọc theo trạng thái:</label>
                                            <select name="status" id="statusFilter" class="form-control" onchange="this.form.submit()">
                                                <option value="">Tất cả trạng thái</option>
                                                <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                                                <option value="Confirmed" ${param.status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                                <option value="Processing" ${param.status == 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                                                <option value="Shipped" ${param.status == 'Shipped' ? 'selected' : ''}>Đã giao</option>
                                                <option value="Delivered" ${param.status == 'Delivered' ? 'selected' : ''}>Đã nhận</option>
                                                <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                            </select>
                                        </div>
                                    </form>
                                </div>
                                <div class="col-md-4">
                                    <form method="get" action="${pageContext.request.contextPath}/order">
                                        <input type="hidden" name="action" value="filterByMember">
                                        <div class="form-group">
                                            <label for="memberFilter">Lọc theo thành viên:</label>
                                            <select name="memberId" id="memberFilter" class="form-control" onchange="this.form.submit()">
                                                <option value="">Tất cả thành viên</option>
                                                <c:forEach var="user" items="${userList}">
                                                    <option value="${user.id}" ${param.memberId == user.id ? 'selected' : ''}>${user.fullName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </form>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/order?action=list" class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-refresh me-2"></i>Xóa bộ lọc
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order List -->
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6>Danh sách Đơn hàng</h6>
                        <div>
                            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <a href="${pageContext.request.contextPath}/order?action=create" class="btn btn-primary btn-sm">
                                <i class="fas fa-plus me-2"></i>Tạo đơn hàng mới
                            </a>

                        </div>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                    <tr>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">ID</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Thành viên</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Ngày đặt</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Tổng tiền</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Voucher</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Trạng thái</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orderList}">
                                        <tr>
                                            <td class="text-center"><h6 class="mb-0 text-sm">${order.id}</h6></td>
                                            <td class="ps-2">
                                                <h6 class="mb-0 text-sm">${order.member.fullName}</h6>
                                                <p class="text-xs text-secondary mb-0">${order.member.email}</p>
                                            </td>
                                            <td class="ps-2">
                                                <h6 class="mb-0 text-sm">
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" />
                                                </h6>
                                            </td>
                                            <td class="ps-2">
                                                <h6 class="mb-0 text-sm">
                                                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0" /> VNĐ
                                                </h6>
                                            </td>
                                            <td class="ps-2">
                                                <h6 class="mb-0 text-sm">
                                                    <c:choose>
                                                        <c:when test="${order.voucher != null}">
                                                            <span class="badge badge-sm bg-gradient-info">${order.voucher.code}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-secondary">Không có</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h6>
                                            </td>
                                            <td class="ps-2">
                                                <c:choose>
                                                    <c:when test="${order.status == 'Pending'}">
                                                        <span class="badge badge-sm status-pending">Chờ xử lý</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'Confirmed'}">
                                                        <span class="badge badge-sm status-confirmed">Đã xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'Processing'}">
                                                        <span class="badge badge-sm status-processing">Đang xử lý</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'Shipped'}">
                                                        <span class="badge badge-sm status-shipped">Đã giao</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'Delivered'}">
                                                        <span class="badge badge-sm status-delivered">Đã nhận</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'Cancelled'}">
                                                        <span class="badge badge-sm status-cancelled">Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-sm bg-gradient-secondary">${order.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-icon-only text-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                        <i class="fas fa-ellipsis-v"></i>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end">
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/order?action=view&id=${order.id}"><i class="fas fa-eye me-2"></i>Xem chi tiết</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/order?action=edit&id=${order.id}"><i class="fas fa-edit me-2"></i>Chỉnh sửa</a></li>
                                                        <li>
                                                            <a class="dropdown-item view-order-btn" href="#" 
                                                               data-id="${order.id}" 
                                                               data-member-name="${order.member.fullName}" 
                                                               data-member-email="${order.member.email}" 
                                                               data-order-date="${order.orderDate}" 
                                                               data-total-amount="${order.totalAmount}" 
                                                               data-voucher-code="${order.voucher != null ? order.voucher.code : ''}"
                                                               data-status="${order.status}"
                                                               data-created="${order.createdAt}"
                                                               data-updated="${order.updatedAt}">
                                                                <i class="fas fa-info-circle me-2"></i>Thông tin nhanh
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Modal xem thông tin nhanh đơn hàng -->
        <div class="modal fade" id="orderQuickViewModal" tabindex="-1" aria-labelledby="orderQuickViewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="orderQuickViewModalLabel">Thông tin đơn hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-5 mb-3">
                                <img src="assets/svg/order-package.svg" class="img-fluid order-detail-img" id="orderDetailImage" alt="Order Image">
                            </div>
                            <div class="col-md-7">
                                <h4 id="orderDetailId" class="mb-3"></h4>
                                <div class="mb-2">
                                    <span id="orderDetailStatus" class="badge"></span>
                                </div>
                                <div class="mb-2">
                                    <span class="detail-label">Thành viên:</span> 
                                    <span id="orderDetailMemberName" class="ms-2"></span>
                                </div>
                                <div class="mb-2">
                                    <span class="detail-label">Email:</span> 
                                    <span id="orderDetailMemberEmail" class="ms-2"></span>
                                </div>
                                <div class="mb-2">
                                    <span class="detail-label">Ngày đặt hàng:</span> 
                                    <span id="orderDetailOrderDate" class="ms-2"></span>
                                </div>
                                <div class="mb-2">
                                    <span class="detail-label">Tổng tiền:</span> 
                                    <span id="orderDetailTotalAmount" class="ms-2"></span> VNĐ
                                </div>
                                <div class="mb-2">
                                    <span class="detail-label">Voucher:</span> 
                                    <span id="orderDetailVoucherCode" class="ms-2"></span>
                                </div>
                                <div class="mb-2 small text-muted">
                                    <span class="detail-label">Ngày tạo:</span> 
                                    <span id="orderDetailCreated" class="ms-2"></span>
                                </div>
                                <div class="small text-muted">
                                    <span class="detail-label">Cập nhật lần cuối:</span> 
                                    <span id="orderDetailUpdated" class="ms-2"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <a href="#" id="viewOrderBtn" class="btn btn-info">Xem chi tiết</a>
                        <a href="#" id="editOrderBtn" class="btn btn-primary">Chỉnh sửa</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/assets/js/core/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/core/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins/smooth-scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/argon-dashboard.min.js?v=2.1.0"></script>
        <script>
                                                document.addEventListener('DOMContentLoaded', function () {
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

                                                    // Hàm định dạng số
                                                    function formatNumber(num) {
                                                        if (!num)
                                                            return '0';
                                                        return parseFloat(num).toString().replace(/\.0+$/, '');
                                                    }

                                                    // Hàm định dạng ngày tháng
                                                    function formatDate(dateStr) {
                                                        if (!dateStr)
                                                            return 'N/A';
                                                        try {
                                                            if (dateStr.includes('T') && dateStr.includes('Z')) {
                                                                const date = new Date(dateStr);
                                                                if (!isNaN(date.getTime())) {
                                                                    return date.getDate().toString().padStart(2, '0') + '/' +
                                                                            (date.getMonth() + 1).toString().padStart(2, '0') + '/' +
                                                                            date.getFullYear();
                                                                }
                                                            }

                                                            if (dateStr.includes('/')) {
                                                                const parts = dateStr.split('/');
                                                                if (parts.length >= 3) {
                                                                    const day = parts[0].split('T')[0];
                                                                    const month = parts[1];
                                                                    const year = parts[2];
                                                                    return day.padStart(2, '0') + '/' + month.padStart(2, '0') + '/' + year;
                                                                }
                                                            }

                                                            const parts = dateStr.split('-');
                                                            if (parts.length === 3) {
                                                                return parts[2] + '/' + parts[1] + '/' + parts[0];
                                                            }

                                                            return dateStr;
                                                        } catch (e) {
                                                            return dateStr;
                                                        }
                                                    }

                                                    // Hàm định dạng ngày tháng kèm giờ phút giây
                                                    function formatDateWithTime(dateStr) {
                                                        if (!dateStr)
                                                            return 'N/A';
                                                        try {
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

                                                            if (dateStr.includes('/')) {
                                                                const parts = dateStr.split('/');
                                                                if (parts.length >= 3) {
                                                                    const dayPart = parts[0].split('T');
                                                                    const day = dayPart[0];
                                                                    const month = parts[1];
                                                                    const year = parts[2];

                                                                    if (dayPart.length > 1) {
                                                                        const timePart = dayPart[1].split(':');
                                                                        if (timePart.length >= 3) {
                                                                            const hour = timePart[0];
                                                                            const minute = timePart[1];
                                                                            const second = timePart[2].split('.')[0];
                                                                            return day.padStart(2, '0') + '/' + month.padStart(2, '0') + '/' + year + ' ' +
                                                                                    hour.padStart(2, '0') + ':' + minute.padStart(2, '0') + ':' + second.padStart(2, '0');
                                                                        }
                                                                    }

                                                                    return day.padStart(2, '0') + '/' + month.padStart(2, '0') + '/' + year;
                                                                }
                                                            }

                                                            const parts = dateStr.split('-');
                                                            if (parts.length === 3) {
                                                                return parts[2] + '/' + parts[1] + '/' + parts[0];
                                                            }

                                                            return dateStr;
                                                        } catch (e) {
                                                            return dateStr;
                                                        }
                                                    }

                                                    // Hàm lấy tên trạng thái tiếng Việt
                                                    function getStatusText(status) {
                                                        switch (status) {
                                                            case 'Pending':
                                                                return 'Chờ xử lý';
                                                            case 'Confirmed':
                                                                return 'Đã xác nhận';
                                                            case 'Processing':
                                                                return 'Đang xử lý';
                                                            case 'Shipped':
                                                                return 'Đã giao';
                                                            case 'Delivered':
                                                                return 'Đã nhận';
                                                            case 'Cancelled':
                                                                return 'Đã hủy';
                                                            default:
                                                                return status;
                                                        }
                                                    }

                                                    // Hàm lấy class CSS cho trạng thái
                                                    function getStatusBadgeClass(status) {
                                                        switch (status) {
                                                            case 'Pending':
                                                                return 'badge status-pending';
                                                            case 'Confirmed':
                                                                return 'badge status-confirmed';
                                                            case 'Processing':
                                                                return 'badge status-processing';
                                                            case 'Shipped':
                                                                return 'badge status-shipped';
                                                            case 'Delivered':
                                                                return 'badge status-delivered';
                                                            case 'Cancelled':
                                                                return 'badge status-cancelled';
                                                            default:
                                                                return 'badge bg-gradient-secondary';
                                                        }
                                                    }

                                                    // Xử lý sự kiện click nút xem thông tin nhanh đơn hàng
                                                    document.querySelectorAll('.view-order-btn').forEach(function (button) {
                                                        button.addEventListener('click', function (e) {
                                                            e.preventDefault();
                                                            const id = this.getAttribute('data-id');
                                                            const memberName = this.getAttribute('data-member-name');
                                                            const memberEmail = this.getAttribute('data-member-email');
                                                            const orderDate = this.getAttribute('data-order-date');
                                                            const totalAmount = this.getAttribute('data-total-amount');
                                                            const voucherCode = this.getAttribute('data-voucher-code');
                                                            const status = this.getAttribute('data-status');
                                                            const created = this.getAttribute('data-created');
                                                            const updated = this.getAttribute('data-updated');

                                                            // Cập nhật nội dung modal
                                                            document.getElementById('orderDetailId').textContent = 'Đơn hàng #' + id;
                                                            document.getElementById('orderDetailMemberName').textContent = memberName;
                                                            document.getElementById('orderDetailMemberEmail').textContent = memberEmail;
                                                            document.getElementById('orderDetailOrderDate').textContent = formatDate(orderDate);
                                                            document.getElementById('orderDetailTotalAmount').textContent = new Intl.NumberFormat('vi-VN').format(formatNumber(totalAmount));
                                                            document.getElementById('orderDetailVoucherCode').textContent = voucherCode || 'Không có';
                                                            document.getElementById('orderDetailCreated').textContent = formatDateWithTime(created) || 'N/A';
                                                            document.getElementById('orderDetailUpdated').textContent = formatDateWithTime(updated) || 'N/A';

                                                            // Cập nhật trạng thái
                                                            const statusBadge = document.getElementById('orderDetailStatus');
                                                            statusBadge.className = getStatusBadgeClass(status);
                                                            statusBadge.textContent = getStatusText(status);

                                                            // Cập nhật links
                                                            document.getElementById('viewOrderBtn').href = '${pageContext.request.contextPath}/order?action=view&id=' + id;
                                                            document.getElementById('editOrderBtn').href = '${pageContext.request.contextPath}/order?action=edit&id=' + id;

                                                            // Hiển thị modal
                                                            var quickViewModal = new bootstrap.Modal(document.getElementById('orderQuickViewModal'));
                                                            quickViewModal.show();
                                                        });
                                                    });
                                                });
        </script>
    </body>
</html>

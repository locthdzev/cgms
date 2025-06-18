<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="Models.User"%>
<%@page import="Models.Voucher"%>
<%@page import="java.util.List"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
    
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
<c:set var="uri" value="${pageContext.request.requestURI}" />
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <link rel="apple-touch-icon" sizes="76x76" href="${pageContext.request.contextPath}/assets/img/weightlifting.png" />
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/weightlifting.png" />
  <title>Quản lý Voucher - CGMS</title>

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
    
    .voucher-detail-img {
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

  <!-- Main Content -->
  <main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Quản lý Voucher" />
        <jsp:param name="parentPage" value="Dashboard" />
        <jsp:param name="parentPageUrl" value="dashboard.jsp" />
        <jsp:param name="currentPage" value="Quản lý Voucher" />
    </jsp:include>

    <!-- Page Content -->
    <div class="container-fluid py-4">
      <div class="card mb-4">
        <div class="card-header pb-0 d-flex justify-content-between align-items-center">
          <h6>Danh sách Voucher</h6>
          <div>
            <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                <i class="fas fa-arrow-left me-2"></i>Quay lại
            </a>
            <a href="${pageContext.request.contextPath}/voucher?action=create" class="btn btn-primary btn-sm">
                <i class="fas fa-plus me-2"></i>Tạo Voucher mới
            </a>
          </div>
        </div>
        <div class="card-body px-0 pt-0 pb-2">
          <div class="table-responsive p-0">
            <table class="table align-items-center mb-0">
              <thead>
                <tr>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">ID</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Mã</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Giảm giá</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Loại</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Giá trị tối thiểu</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Ngày hết hạn</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Trạng thái</th>
                  <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 text-center">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="v" items="${voucherList}">
                  <tr>
                    <td class="text-center"><h6 class="mb-0 text-sm">${v.id}</h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">${v.code}</h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">${v.discountValue}</h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">
                      <c:choose>
                        <c:when test="${v.discountType == 'Percent'}">Phần trăm</c:when>
                        <c:when test="${v.discountType == 'Amount'}">Số tiền cố định</c:when>
                        <c:otherwise>${v.discountType}</c:otherwise>
                      </c:choose>
                    </h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">${v.minPurchase}</h6></td>
                    <td class="ps-2"><h6 class="mb-0 text-sm">${v.expiryDate}</h6></td>
                    <td class="ps-2">
                      <c:choose>
                        <c:when test="${v.status == 'Active'}">
                          <span class="badge badge-sm bg-gradient-success">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-sm bg-gradient-secondary">Không hoạt động</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="text-center">
                      <div class="dropdown">
                        <button class="btn btn-sm btn-icon-only text-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                          <i class="fas fa-ellipsis-v"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/voucher?action=edit&id=${v.id}"><i class="fas fa-edit me-2"></i>Chỉnh sửa</a></li>
                          <li>
                            <a class="dropdown-item view-voucher-btn" href="#" 
                               data-id="${v.id}" 
                               data-code="${v.code}" 
                               data-discount="${v.discountValue}" 
                               data-type="${v.discountType}" 
                               data-min-purchase="${v.minPurchase}" 
                               data-expiry="${v.expiryDate}" 
                               data-status="${v.status}"
                               data-created="${v.createdAt}"
                               data-updated="${v.updatedAt}">
                              <i class="fas fa-eye me-2"></i>Xem chi tiết
                            </a>
                          </li>
                          <li><a class="dropdown-item delete-voucher-btn" href="#" data-id="${v.id}" data-code="${v.code}"><i class="fas fa-trash me-2"></i>Xóa</a></li>
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

  <!-- Modal xác nhận xóa voucher -->
  <div class="modal fade" id="deleteVoucherModal" tabindex="-1" aria-labelledby="deleteVoucherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteVoucherModalLabel">Xác nhận xóa voucher</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <p>Bạn có chắc chắn muốn xóa voucher <span id="voucherCode" class="fw-bold"></span>?</p>
          <p class="text-danger">Hành động này không thể hoàn tác.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xác nhận xóa</a>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Modal xem chi tiết voucher -->
  <div class="modal fade" id="voucherDetailModal" tabindex="-1" aria-labelledby="voucherDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="voucherDetailModalLabel">Chi tiết Voucher</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-5 mb-3">
                        <img src="assets/svg/voucher-discount.svg" class="img-fluid voucher-detail-img" id="voucherDetailImage" alt="Voucher Image">
                    </div>
                    <div class="col-md-7">
                        <h4 id="voucherDetailCode" class="mb-3"></h4>
                        <div class="mb-2">
                            <span id="voucherDetailStatus" class="badge"></span>
                        </div>
                        <div class="mb-2">
                            <span class="detail-label">Giá trị giảm giá:</span> 
                            <span id="voucherDetailDiscount" class="ms-2"></span>
                        </div>
                        <div class="mb-2">
                            <span class="detail-label">Loại giảm giá:</span> 
                            <span id="voucherDetailType" class="ms-2"></span>
                        </div>
                        <div class="mb-2">
                            <span class="detail-label">Giá trị đơn hàng tối thiểu:</span> 
                            <span id="voucherDetailMinPurchase" class="ms-2"></span> VNĐ
                        </div>
                        <div class="mb-2">
                            <span class="detail-label">Ngày hết hạn:</span> 
                            <span id="voucherDetailExpiry" class="ms-2"></span>
                        </div>
                        <div class="mb-2 small text-muted">
                            <span class="detail-label">Ngày tạo:</span> 
                            <span id="voucherDetailCreated" class="ms-2"></span>
                        </div>
                        <div class="small text-muted">
                            <span class="detail-label">Cập nhật lần cuối:</span> 
                            <span id="voucherDetailUpdated" class="ms-2"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <a href="#" id="editVoucherBtn" class="btn btn-primary">Chỉnh sửa</a>
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
      
      // Xử lý sự kiện click nút xóa voucher
      document.querySelectorAll('.delete-voucher-btn').forEach(function(button) {
        button.addEventListener('click', function() {
          const id = this.getAttribute('data-id');
          const code = this.getAttribute('data-code');
          
          document.getElementById('voucherCode').textContent = code;
          document.getElementById('confirmDeleteBtn').href = '${pageContext.request.contextPath}/voucher?action=delete&id=' + id;
          
          var deleteModal = new bootstrap.Modal(document.getElementById('deleteVoucherModal'));
          deleteModal.show();
        });
      });
      
      // Xử lý sự kiện click nút xem chi tiết voucher
      document.querySelectorAll('.view-voucher-btn').forEach(function(button) {
        button.addEventListener('click', function(e) {
          e.preventDefault();
          const id = this.getAttribute('data-id');
          const code = this.getAttribute('data-code');
          const discount = this.getAttribute('data-discount');
          const type = this.getAttribute('data-type');
          const minPurchase = this.getAttribute('data-min-purchase');
          const expiry = this.getAttribute('data-expiry');
          const status = this.getAttribute('data-status');
          const created = this.getAttribute('data-created');
          const updated = this.getAttribute('data-updated');
          
          // Cập nhật nội dung modal
          document.getElementById('voucherDetailCode').textContent = code;
          
          // Format discount value based on type
          if (type === 'Percent') {
            document.getElementById('voucherDetailDiscount').textContent = discount + '%';
            document.getElementById('voucherDetailType').textContent = 'Phần trăm';
          } else {
            document.getElementById('voucherDetailDiscount').textContent = new Intl.NumberFormat('vi-VN').format(discount) + ' VNĐ';
            document.getElementById('voucherDetailType').textContent = 'Số tiền cố định';
          }
          
          document.getElementById('voucherDetailMinPurchase').textContent = new Intl.NumberFormat('vi-VN').format(minPurchase);
          document.getElementById('voucherDetailExpiry').textContent = expiry;
          document.getElementById('voucherDetailCreated').textContent = created || 'N/A';
          document.getElementById('voucherDetailUpdated').textContent = updated || 'N/A';
          
          // Cập nhật trạng thái
          const statusBadge = document.getElementById('voucherDetailStatus');
          if (status === 'Active') {
            statusBadge.className = 'badge bg-gradient-success';
            statusBadge.textContent = 'Hoạt động';
          } else {
            statusBadge.className = 'badge bg-gradient-secondary';
            statusBadge.textContent = 'Không hoạt động';
          }
          
          // Cập nhật link chỉnh sửa
          document.getElementById('editVoucherBtn').href = '${pageContext.request.contextPath}/voucher?action=edit&id=' + id;
          
          // Hiển thị modal
          var detailModal = new bootstrap.Modal(document.getElementById('voucherDetailModal'));
          detailModal.show();
        });
      });
    });
  </script>
</body>
</html>

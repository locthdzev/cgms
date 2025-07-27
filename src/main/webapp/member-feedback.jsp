<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page import="Models.User"%>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Xử lý thông báo
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    boolean hasSuccessMessage = successMessage != null && !successMessage.trim().isEmpty();
    boolean hasErrorMessage = errorMessage != null && !errorMessage.trim().isEmpty();
    
    if (hasSuccessMessage) session.removeAttribute("successMessage");
    if (hasErrorMessage) session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
        <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
        <title>Feedback - CGMS</title>
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link id="pagestyle" href="${pageContext.request.contextPath}/assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="g-sidenav-show bg-gray-100">
        <div class="min-height-300 bg-dark position-absolute w-100"></div>

        <!-- Include Sidebar -->
        <jsp:include page="member_sidebar.jsp" />

        <!-- Main Content -->
        <main class="main-content position-relative border-radius-lg">
            <!-- Include Navbar -->
            <jsp:include page="navbar.jsp">
                <jsp:param name="pageTitle" value="" />
                <jsp:param name="parentPage" value="Dashboard" />
                <jsp:param name="parentPageUrl" value="member-dashboard" />
                <jsp:param name="currentPage" value="Feedback" />
            </jsp:include>

            <div class="container-fluid py-4">
                <!-- Toast Container -->
                <div class="position-fixed top-0 end-0 p-3" style="z-index: 9999;">
                    <% if (hasSuccessMessage) { %>
                    <div class="toast align-items-center text-white bg-success border-0" role="alert" id="successToast">
                        <div class="d-flex">
                            <div class="toast-body">
                                <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
                            </div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                        </div>
                    </div>
                    <% } %>
                    <% if (hasErrorMessage) { %>
                    <div class="toast align-items-center text-white bg-danger border-0" role="alert" id="errorToast">
                        <div class="d-flex">
                            <div class="toast-body">
                                <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
                            </div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                        </div>
                    </div>
                    <% } %>
                </div>

                <!-- Header với nút gửi feedback -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                                <h6>Quản lý Feedback</h6>
                                <div>
                                    <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#sendFeedbackModal">
                                        <i class="fas fa-plus me-2"></i>Gửi Feedback
                                    </button>
                                    <button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#sendScheduleFeedbackModal">
                                        <i class="fas fa-calendar-check me-2"></i>Feedback Buổi Tập
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Danh sách feedback đã gửi -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header pb-0">
                                <h6>Feedback đã gửi</h6>
                            </div>
                            <div class="card-body px-0 pt-0 pb-2">
                                <c:if test="${empty memberFeedbacks}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Bạn chưa gửi feedback nào.</p>
                                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#sendFeedbackModal">
                                            Gửi feedback đầu tiên
                                        </button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty memberFeedbacks}">
                                    <div class="table-responsive p-0">
                                        <table class="table align-items-center mb-0">
                                            <thead>
                                                <tr>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">ID</th>
                                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Nội dung</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày gửi</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="fb" items="${memberFeedbacks}">
                                                    <tr>
                                                        <td class="text-center">
                                                            <h6 class="mb-0 text-sm">#${fb.id}</h6>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex px-2 py-1">
                                                                <div class="d-flex flex-column justify-content-center">
                                                                    <h6 class="mb-0 text-sm">
                                                                        <c:choose>
                                                                            <c:when test="${fn:length(fb.content) > 50}">
                                                                                ${fn:substring(fb.content, 0, 50)}...
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${fb.content}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </h6>
                                                                    <p class="text-xs text-secondary mb-0">${fb.guestEmail}</p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${fb.status eq 'Pending'}">
                                                                    <span class="badge badge-sm bg-gradient-warning">Đang chờ</span>
                                                                </c:when>
                                                                <c:when test="${fb.status eq 'Responded'}">
                                                                    <span class="badge badge-sm bg-gradient-success">Đã phản hồi</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-sm bg-gradient-secondary">${fb.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="text-secondary text-xs font-weight-bold">
                                                                <c:if test="${not empty fb.createdAt}">
                                                                    <jsp:useBean id="createdDate" class="java.util.Date"/>
                                                                    <jsp:setProperty name="createdDate" property="time" value="${fb.createdAt.toEpochMilli()}"/>
                                                                    <fmt:formatDate value="${createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                                                </c:if>
                                                            </span>
                                                        </td>
                                                        <td class="text-center">
                                                            <button class="btn btn-sm btn-outline-info view-detail-btn" 
                                                                    data-id="${fb.id}"
                                                                    data-content="${fb.content}"
                                                                    data-status="${fb.status}"
                                                                    data-response="${fb.response}"
                                                                    data-email="${fb.guestEmail}">
                                                                <i class="fas fa-eye me-1"></i>Chi tiết
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal gửi feedback chung -->
            <div class="modal fade" id="sendFeedbackModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/member-feedback" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Gửi Feedback</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="sendFeedback">
                            <div class="mb-3">
                                <label for="guestEmail" class="form-label">Email liên hệ</label>
                                <input type="email" class="form-control" id="guestEmail" name="guestEmail" 
                                       value="<%= loggedInUser.getEmail() %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="content" class="form-label">Nội dung feedback</label>
                                <textarea class="form-control" id="content" name="content" rows="4" 
                                          placeholder="Chia sẻ ý kiến của bạn về dịch vụ..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Gửi Feedback</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal gửi feedback cho buổi tập -->
            <div class="modal fade" id="sendScheduleFeedbackModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/member-feedback" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Feedback Buổi Tập</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="sendScheduleFeedback">
                            <div class="mb-3">
                                <label for="scheduleGuestEmail" class="form-label">Email liên hệ</label>
                                <input type="email" class="form-control" id="scheduleGuestEmail" name="guestEmail" 
                                       value="<%= loggedInUser.getEmail() %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="scheduleId" class="form-label">Chọn buổi tập</label>
                                <select class="form-control" id="scheduleId" name="scheduleId" required>
                                    <option value="">-- Chọn buổi tập --</option>
                                    <c:forEach var="schedule" items="${completedSchedules}">
                                        <option value="${schedule.id}">
                                            Buổi #${schedule.id} - ${schedule.scheduleDate} - ${schedule.scheduleTime}
                                        </option>
                                    </c:forEach>
                                </select>

                            </div>
                            <div class="mb-3">
                                <label for="scheduleContent" class="form-label">Đánh giá buổi tập</label>
                                <textarea class="form-control" id="scheduleContent" name="content" rows="4" 
                                          placeholder="Chia sẻ cảm nhận về buổi tập này..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Gửi Feedback</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal xem chi tiết feedback -->
            <div class="modal fade" id="viewDetailModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Chi tiết Feedback</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <div class="d-flex align-items-center">
                                        <div class="avatar avatar-xl rounded-circle bg-gradient-primary me-3 d-flex align-items-center justify-content-center">
                                            <i class="fas fa-user text-white"></i>
                                        </div>
                                        <div>
                                            <h6 class="mb-0" id="detailEmail"></h6>
                                            <span id="detailStatus" class="badge mt-1"></span>
                                        </div>
                                        <div class="ms-auto text-end">
                                            <p class="text-xs text-secondary mb-0">ID: <span id="detailId"></span></p>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-12 mb-3">
                                    <div class="card border-0 bg-light">
                                        <div class="card-body">
                                            <h6 class="mb-3 text-uppercase">Nội dung feedback</h6>
                                            <p id="detailContent" class="mb-0"></p>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-12" id="responseSection" style="display: none;">
                                    <div class="card border-0 bg-gradient-light">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="avatar avatar-sm rounded-circle bg-gradient-success me-3 d-flex align-items-center justify-content-center">
                                                    <i class="fas fa-comment-dots text-white"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 text-uppercase">Phản hồi từ CGMS</h6>
                                                </div>
                                            </div>
                                            <p id="detailResponse" class="mb-0 ps-5"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Core JS Files -->
        <script src="${pageContext.request.contextPath}/assets/js/core/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/core/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins/smooth-scrollbar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/argon-dashboard.min.js?v=2.1.0"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Khởi tạo tất cả modal
                var modals = document.querySelectorAll('.modal');
                modals.forEach(function (modal) {
                    new bootstrap.Modal(modal);
                });

                // Hiển thị toast
                if (document.getElementById('successToast')) {
                    var successToast = new bootstrap.Toast(document.getElementById('successToast'), {delay: 5000});
                    successToast.show();
                }
                if (document.getElementById('errorToast')) {
                    var errorToast = new bootstrap.Toast(document.getElementById('errorToast'), {delay: 5000});
                    errorToast.show();
                }

                // Xử lý nút xem chi tiết
                document.querySelectorAll('.view-detail-btn').forEach(function (button) {
                    button.addEventListener('click', function (e) {
                        e.preventDefault();

                        const id = this.getAttribute('data-id');
                        const content = this.getAttribute('data-content');
                        const status = this.getAttribute('data-status');
                        const response = this.getAttribute('data-response');
                        const email = this.getAttribute('data-email');

                        // Cập nhật modal content
                        document.getElementById('detailId').textContent = id;
                        document.getElementById('detailEmail').textContent = email;
                        document.getElementById('detailContent').textContent = content;

                        // Cập nhật status badge
                        const statusBadge = document.getElementById('detailStatus');
                        if (status === 'Responded') {
                            statusBadge.className = 'badge bg-gradient-success';
                            statusBadge.textContent = 'Đã phản hồi';
                        } else if (status === 'Pending') {
                            statusBadge.className = 'badge bg-gradient-warning';
                            statusBadge.textContent = 'Đang chờ';
                        } else {
                            statusBadge.className = 'badge bg-gradient-secondary';
                            statusBadge.textContent = status;
                        }

                        // Hiển thị response nếu có
                        const responseSection = document.getElementById('responseSection');
                        if (response && response !== 'null' && response.trim() !== '') {
                            responseSection.style.display = 'block';
                            document.getElementById('detailResponse').textContent = response;
                        } else {
                            responseSection.style.display = 'none';
                        }

                        // Hiển thị modal
                        var viewModal = new bootstrap.Modal(document.getElementById('viewDetailModal'));
                        viewModal.show();
                    });
                });
            });
        </script>
    </body>
</html>








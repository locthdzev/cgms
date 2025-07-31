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
    </head>
    <body class="g-sidenav-show bg-gray-100">
        <div class="min-height-300 bg-dark position-absolute w-100"></div>

        <!-- Include Sidebar -->
        <jsp:include page="member_sidebar.jsp" />

        <!-- Main Content -->
        <main class="main-content position-relative border-radius-lg">
            <!-- Include Navbar -->
            <jsp:include page="navbar.jsp">
                <jsp:param name="pageTitle" value="Feedback" />
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

                <!-- Header Card -->
                <div class="row">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header pb-0">
                                <div class="d-flex align-items-center">
                                    <div class="icon icon-shape icon-lg bg-gradient-primary shadow text-center border-radius-xl mt-n4 me-3">
                                        <i class="fas fa-comment-alt text-white opacity-10"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">Quản lý Feedback</h6>
                                        <p class="text-sm mb-0">Gửi phản hồi và theo dõi trạng thái</p>
                                    </div>
                                    <div class="ms-auto">
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
                </div>

                <!-- Feedback List -->
                <div class="row">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header pb-0">
                                <h6>Feedback đã gửi</h6>
                            </div>
                            <div class="card-body px-0 pt-0 pb-2">
                                <c:if test="${empty memberFeedbacks}">
                                    <div class="text-center py-5">
                                        <div class="icon icon-shape icon-xxl bg-gradient-secondary shadow text-center border-radius-xl mt-n4 mb-4 mx-auto">
                                            <i class="fas fa-comment-slash text-white opacity-10"></i>
                                        </div>
                                        <h5 class="text-muted mb-3">Chưa có feedback nào</h5>
                                        <p class="text-muted mb-4">Bạn chưa gửi feedback nào. Hãy chia sẻ ý kiến của bạn về dịch vụ!</p>
                                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#sendFeedbackModal">
                                            <i class="fas fa-plus me-2"></i>Gửi feedback đầu tiên
                                        </button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty memberFeedbacks}">
                                    <div class="table-responsive p-0">
                                        <table class="table align-items-center mb-0">
                                            <thead>
                                                <tr>
                                                    <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Feedback</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày gửi</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="fb" items="${memberFeedbacks}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex px-2 py-1">
                                                                <div class="avatar avatar-sm rounded-circle bg-gradient-primary me-3 d-flex align-items-center justify-content-center">
                                                                    <i class="fas fa-comment text-white text-xs"></i>
                                                                </div>
                                                                <div class="d-flex flex-column justify-content-center">
                                                                    <h6 class="mb-0 text-sm">
                                                                        <c:choose>
                                                                            <c:when test="${fn:length(fb.content) > 60}">
                                                                                ${fn:substring(fb.content, 0, 60)}...
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${fb.content}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </h6>
                                                                    <p class="text-xs text-secondary mb-0">
                                                                        <i class="fas fa-envelope me-1"></i>${fb.guestEmail}
                                                                    </p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${fb.status eq 'Pending'}">
                                                                    <span class="badge badge-sm bg-gradient-warning">
                                                                        <i class="fas fa-clock me-1"></i>Đang chờ
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${fb.status eq 'Responded'}">
                                                                    <span class="badge badge-sm bg-gradient-success">
                                                                        <i class="fas fa-check me-1"></i>Đã phản hồi
                                                                    </span>
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
                                                                    <i class="fas fa-calendar-alt me-1"></i>
                                                                    <fmt:formatDate value="${createdDate}" pattern="dd/MM/yyyy" /><br>
                                                                    <i class="fas fa-clock me-1"></i>
                                                                    <fmt:formatDate value="${createdDate}" pattern="HH:mm" />
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

                <!-- Footer -->
                <footer class="footer pt-3">
                    <div class="container-fluid">
                        <div class="row align-items-center justify-content-lg-between">
                            <div class="col-lg-6 mb-lg-0 mb-4">
                                <div class="copyright text-center text-sm text-muted text-lg-start">
                                    © <script>document.write(new Date().getFullYear())</script>,
                                    made with <i class="fa fa-heart"></i> by
                                    <a href="#" class="font-weight-bold" target="_blank">SWP391_07</a>
                                    for a better gym management.
                                </div>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>

            <!-- Modal gửi feedback chung -->
            <div class="modal fade" id="sendFeedbackModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/member-feedback" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <i class="fas fa-comment-alt me-2"></i>Gửi Feedback
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="sendFeedback">
                            <div class="mb-3">
                                <label for="guestEmail" class="form-label">
                                    <i class="fas fa-envelope me-2"></i>Email liên hệ
                                </label>
                                <input type="email" class="form-control" id="guestEmail" name="guestEmail" 
                                       value="<%= loggedInUser.getEmail() %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="content" class="form-label">
                                    <i class="fas fa-edit me-2"></i>Nội dung feedback
                                </label>
                                <textarea class="form-control" id="content" name="content" rows="4" 
                                          placeholder="Chia sẻ ý kiến của bạn về dịch vụ..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>Hủy
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane me-2"></i>Gửi Feedback
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal gửi feedback cho buổi tập -->
            <div class="modal fade" id="sendScheduleFeedbackModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/member-feedback" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <i class="fas fa-calendar-check me-2"></i>Feedback Buổi Tập
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="sendScheduleFeedback">
                            <div class="mb-3">
                                <label for="scheduleGuestEmail" class="form-label">
                                    <i class="fas fa-envelope me-2"></i>Email liên hệ
                                </label>
                                <input type="email" class="form-control" id="scheduleGuestEmail" name="guestEmail" 
                                       value="<%= loggedInUser.getEmail() %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="scheduleId" class="form-label">
                                    <i class="fas fa-dumbbell me-2"></i>Chọn buổi tập
                                </label>
                                <select class="form-control" id="scheduleId" name="scheduleId" required>
                                    <option value="">-- Chọn buổi tập --</option>
                                    <c:forEach var="schedule" items="${completedSchedules}">
                                        <option value="${schedule.id}">
                                            Buổi tập #${schedule.id} - 
                                            <fmt:formatDate value="${schedule.date}" pattern="dd/MM/yyyy" />
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="scheduleContent" class="form-label">
                                    <i class="fas fa-star me-2"></i>Đánh giá buổi tập
                                </label>
                                <textarea class="form-control" id="scheduleContent" name="content" rows="4" 
                                          placeholder="Chia sẻ cảm nhận về buổi tập này..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>Hủy
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane me-2"></i>Gửi Feedback
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal xem chi tiết feedback -->
            <div class="modal fade" id="viewDetailModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <i class="fas fa-info-circle me-2"></i>Chi tiết Feedback
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12 mb-4">
                                    <div class="card border-0 bg-gradient-light">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="avatar avatar-lg rounded-circle bg-gradient-primary me-3 d-flex align-items-center justify-content-center">
                                                    <i class="fas fa-user text-white"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-0" id="detailEmail"></h6>
                                                    <span id="detailStatus" class="badge mt-1"></span>
                                                </div>
                                                <div class="text-end">
                                                    <small class="text-muted">
                                                        <i class="fas fa-hashtag me-1"></i>
                                                        <span id="detailId"></span>
                                                    </small>
                                                </div>
                                            </div>
                                            <div class="border-top pt-3">
                                                <h6 class="text-uppercase text-xs font-weight-bolder mb-2">
                                                    <i class="fas fa-comment me-2"></i>Nội dung feedback
                                                </h6>
                                                <p id="detailContent" class="mb-0"></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-12" id="responseSection" style="display: none;">
                                    <div class="card border-0 bg-gradient-success">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="avatar avatar-sm rounded-circle bg-white me-3 d-flex align-items-center justify-content-center">
                                                    <i class="fas fa-reply text-success"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 text-white">Phản hồi từ CGMS</h6>
                                                    <small class="text-white opacity-8">Đội ngũ hỗ trợ khách hàng</small>
                                                </div>
                                            </div>
                                            <p id="detailResponse" class="mb-0 text-white"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>Đóng
                            </button>
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
                // Hiển thị toast
                const successToast = document.getElementById('successToast');
                const errorToast = document.getElementById('errorToast');
                
                if (successToast) {
                    const toast = new bootstrap.Toast(successToast, {delay: 5000});
                    toast.show();
                }
                if (errorToast) {
                    const toast = new bootstrap.Toast(errorToast, {delay: 5000});
                    toast.show();
                }

                // Xử lý nút xem chi tiết
                document.querySelectorAll('.view-detail-btn').forEach(function (button) {
                    button.addEventListener('click', function (e) {
                        e.preventDefault();
                        e.stopPropagation();

                        const id = this.getAttribute('data-id');
                        const content = this.getAttribute('data-content');
                        const status = this.getAttribute('data-status');
                        const response = this.getAttribute('data-response');
                        const email = this.getAttribute('data-email');

                        // Cập nhật modal content
                        const detailId = document.getElementById('detailId');
                        const detailEmail = document.getElementById('detailEmail');
                        const detailContent = document.getElementById('detailContent');
                        
                        if (detailId) detailId.textContent = id;
                        if (detailEmail) detailEmail.textContent = email;
                        if (detailContent) detailContent.textContent = content;

                        // Cập nhật status badge
                        const statusBadge = document.getElementById('detailStatus');
                        if (statusBadge) {
                            if (status === 'Responded') {
                                statusBadge.className = 'badge bg-gradient-success';
                                statusBadge.innerHTML = '<i class="fas fa-check me-1"></i>Đã phản hồi';
                            } else if (status === 'Pending') {
                                statusBadge.className = 'badge bg-gradient-warning';
                                statusBadge.innerHTML = '<i class="fas fa-clock me-1"></i>Đang chờ';
                            } else {
                                statusBadge.className = 'badge bg-gradient-secondary';
                                statusBadge.textContent = status;
                            }
                        }

                        // Hiển thị response nếu có
                        const responseSection = document.getElementById('responseSection');
                        const detailResponse = document.getElementById('detailResponse');
                        
                        if (responseSection && detailResponse) {
                            if (response && response !== 'null' && response.trim() !== '') {
                                responseSection.style.display = 'block';
                                detailResponse.textContent = response;
                            } else {
                                responseSection.style.display = 'none';
                            }
                        }

                        // Hiển thị modal
                        const modalElement = document.getElementById('viewDetailModal');
                        if (modalElement) {
                            const detailModal = new bootstrap.Modal(modalElement);
                            detailModal.show();
                        }
                    });
                });
            });
        </script>
    </body>
</html>

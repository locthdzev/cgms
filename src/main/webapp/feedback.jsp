<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="Models.User"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.List"%>
<%@page import="Models.Feedback"%>
<%@page import="java.time.ZoneId"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
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
    
    // Format cho ngày tháng
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
        <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
        <title>Quản lý Feedback - CGMS</title>
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
        <style>
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

            .feedback-detail-img {
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

        <!-- MAIN CONTENT -->
        <main class="main-content position-relative border-radius-lg">
            <!-- Include Navbar Component with parameters -->
            <jsp:include page="navbar.jsp">
                <jsp:param name="pageTitle" value="Quản lý Feedback" />
                <jsp:param name="parentPage" value="Dashboard" />
                <jsp:param name="parentPageUrl" value="dashboard.jsp" />
                <jsp:param name="currentPage" value="Quản lý Feedback" />
            </jsp:include>

            <!-- Feedback Table -->
            <div class="container-fluid py-4">
                <div class="row">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                                <h6>Danh sách phản hồi từ khách hàng</h6>
                                <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                                </a>
                            </div>
                            <div class="card-body px-0 pt-0 pb-2">
                                <div class="table-responsive p-0">
                                    <c:if test="${empty feedbacks}">
                                        <div class="text-center py-4 text-muted">
                                            <em>Hiện tại chưa có phản hồi nào cho PT này.</em>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty feedbacks}">
                                        <table class="table align-items-center mb-0">
                                            <thead>
                                                <tr>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">ID</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Email</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày tạo</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày phản hồi</th>
                                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="fb" items="${feedbacks}">
                                                    <tr>
                                                        <td class="text-center"><h6 class="mb-0 text-sm">${fb.id}</h6></td>
                                                        <td class="text-center"><h6 class="mb-0 text-sm">${fb.guestEmail}</h6></td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${fb.status eq 'Pending'}">
                                                                    <span class="badge badge-sm bg-gradient-warning">Đang chờ</span>
                                                                </c:when>
                                                                <c:when test="${fb.status eq 'Responded'}">
                                                                    <span class="badge badge-sm bg-gradient-success">Đã phản hồi</span>
                                                                </c:when>
                                                                <c:when test="${fb.status eq 'Replied'}">
                                                                    <span class="badge badge-sm bg-gradient-info">Đã trả lời</span>
                                                                </c:when>
                                                                <c:when test="${fb.status eq 'Resolved'}">
                                                                    <span class="badge badge-sm bg-gradient-success">Đã giải quyết</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-sm bg-gradient-secondary">${fb.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <h6 class="mb-0 text-sm">
                                                                <c:if test="${not empty fb.createdAt}">
                                                                    <jsp:useBean id="createdDate" class="java.util.Date"/>
                                                                    <jsp:setProperty name="createdDate" property="time" value="${fb.createdAt.toEpochMilli()}"/>
                                                                    <fmt:formatDate value="${createdDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                                </c:if>
                                                            </h6>
                                                        </td>
                                                        <td class="text-center">
                                                            <h6 class="mb-0 text-sm">
                                                                <c:if test="${not empty fb.respondedAt}">
                                                                    <jsp:useBean id="respondedDate" class="java.util.Date"/>
                                                                    <jsp:setProperty name="respondedDate" property="time" value="${fb.respondedAt.toEpochMilli()}"/>
                                                                    <fmt:formatDate value="${respondedDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                                </c:if>
                                                                <c:if test="${empty fb.respondedAt}">
                                                                    <span class="text-xs text-secondary">Chưa phản hồi</span>
                                                                </c:if>
                                                            </h6>
                                                        </td>
                                                        <td class="text-center">
                                                            <div class="dropdown">
                                                                <button class="btn btn-sm btn-icon-only text-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                                    <i class="fas fa-ellipsis-v"></i>
                                                                </button>
                                                                <ul class="dropdown-menu dropdown-menu-end">
                                                                    <li>
                                                                        <a class="dropdown-item view-feedback-btn" href="#" 
                                                                           data-id="${fb.id}"
                                                                           data-email="${fb.guestEmail}"
                                                                           data-content="${fb.content}"
                                                                           data-status="${fb.status}"
                                                                           data-response="${fb.response}"
                                                                           data-created-at="<c:if test="${not empty fb.createdAt}"><jsp:useBean id="modalCreatedDate" class="java.util.Date"/><jsp:setProperty name="modalCreatedDate" property="time" value="${fb.createdAt.toEpochMilli()}"/><fmt:formatDate value="${modalCreatedDate}" pattern="dd/MM/yyyy HH:mm:ss" /></c:if>"
                                                                           data-responded-at="<c:if test="${not empty fb.respondedAt}"><jsp:useBean id="modalRespondedDate" class="java.util.Date"/><jsp:setProperty name="modalRespondedDate" property="time" value="${fb.respondedAt.toEpochMilli()}"/><fmt:formatDate value="${modalRespondedDate}" pattern="dd/MM/yyyy HH:mm:ss" /></c:if>">
                                                                               <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                                           </a>
                                                                        </li>
                                                                        <li>
                                                                            <a class="dropdown-item text-danger delete-feedback-btn" href="#" 
                                                                               data-id="${fb.id}"
                                                                            data-email="${fb.guestEmail}">
                                                                            <i class="fas fa-trash me-2"></i>Xóa
                                                                        </a>
                                                                        <!-- Nút Respond -->
                                                                        <a class="dropdown-item text-primary respond-feedback-btn" href="#"
                                                                           data-id="${fb.id}" data-email="${fb.guestEmail}">
                                                                            <i class="fas fa-reply me-2"></i>Phản hồi
                                                                        </a>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal xem chi tiết feedback -->
            <div class="modal fade" id="viewFeedbackModal" tabindex="-1" aria-labelledby="viewFeedbackModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="viewFeedbackModalLabel">Chi tiết đánh giá</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <!-- Thông tin cơ bản -->
                                <div class="col-md-12 mb-4">
                                    <div class="d-flex align-items-center">
                                        <div class="avatar avatar-xl rounded-circle bg-gradient-primary me-3 d-flex align-items-center justify-content-center">
                                            <i class="fas fa-user text-white"></i>
                                        </div>
                                        <div>
                                            <h6 class="mb-0 text-sm" id="feedbackEmail"></h6>
                                            <span id="viewFeedbackStatus" class="badge mt-1"></span>
                                        </div>
                                        <div class="ms-auto text-end">
                                            <p class="text-xs text-secondary mb-0">ID: <span id="feedbackId"></span></p>
                                            <p class="text-xs text-secondary mb-0">Ngày tạo: <span id="feedbackCreatedAt"></span></p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Nội dung đánh giá -->
                                <div class="col-md-12 mb-4">
                                    <div class="card border-0 bg-light">
                                        <div class="card-body">
                                            <h6 class="mb-3 text-sm text-uppercase">Nội dung đánh giá</h6>
                                            <p id="feedbackContent" class="mb-0 text-dark"></p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Phản hồi -->
                                <div class="col-md-12 mb-3" id="responseSection">
                                    <div class="card border-0 bg-gradient-light">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="avatar avatar-sm rounded-circle bg-gradient-success me-3 d-flex align-items-center justify-content-center">
                                                    <i class="fas fa-comment-dots text-white"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 text-sm text-uppercase">Phản hồi từ CGMS</h6>
                                                    <p class="text-xs text-secondary mb-0">Ngày phản hồi: <span id="feedbackRespondedAt"></span></p>
                                                </div>
                                            </div>
                                            <p id="feedbackResponse" class="mb-0 text-dark ps-5"></p>
                                        </div>
                                    </div>
                                </div>

                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal xác nhận xóa feedback -->
            <div class="modal fade" id="deleteFeedbackModal" tabindex="-1" aria-labelledby="deleteFeedbackModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteFeedbackModalLabel">Xác nhận xóa</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body text-center">
                            <div class="icon icon-shape icon-xxl bg-gradient-danger shadow-danger text-center border-radius-xl mt-n4 mb-3 mx-auto">
                                <i class="fas fa-exclamation-triangle text-white opacity-10"></i>
                            </div>
                            <h4 class="mb-3">Xác nhận xóa phản hồi?</h4>
                            <p class="mb-0">Bạn có chắc chắn muốn xóa phản hồi từ <span id="deleteEmail" class="fw-bold"></span>?</p>
                            <p>Hành động này không thể hoàn tác.</p>
                            <form id="deleteFeedbackForm" action="feedback" method="post">
                                <input type="hidden" id="deleteFeedbackId" name="id">
                                <input type="hidden" name="action" value="delete">
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Xác nhận xóa</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Modal phản hồi -->
            <div class="modal fade" id="respondModal" tabindex="-1">
                <div class="modal-dialog">
                    <form id="respondForm" action="feedback" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Phản hồi Feedback</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="respond"/>
                            <input type="hidden" id="respondId" name="id"/>
                            <div class="mb-3">
                                <label for="response" class="form-label">Nội dung phản hồi</label>
                                <textarea id="response" name="response" class="form-control" rows="4" required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Gửi phản hồi</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                document.querySelectorAll('.respond-feedback-btn').forEach(btn => {
                    btn.addEventListener('click', e => {
                        const id = btn.getAttribute('data-id');
                        document.getElementById('respondId').value = id;
                        new bootstrap.Modal(document.getElementById('respondModal')).show();
                    });
                });
            </script>

        </main>

        <!-- Core JS Files -->
        <script src="./assets/js/core/popper.min.js"></script>
        <script src="./assets/js/core/bootstrap.min.js"></script>
        <script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="./assets/js/plugins/smooth-scrollbar.min.js"></script>
        <script src="./assets/js/argon-dashboard.min.js?v=2.1.0"></script>

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

        // Thêm sự kiện click cho các nút xem chi tiết
        document.querySelectorAll('.view-feedback-btn').forEach(function (button) {
            button.addEventListener('click', function () {
                const id = this.getAttribute('data-id');
                const email = this.getAttribute('data-email');
                const content = this.getAttribute('data-content');
                const status = this.getAttribute('data-status');
                const response = this.getAttribute('data-response');
                const createdAt = this.getAttribute('data-created-at');
                const respondedAt = this.getAttribute('data-responded-at');

                // Cập nhật thông tin cơ bản
                document.getElementById('feedbackId').textContent = id;
                document.getElementById('feedbackEmail').textContent = email;
                document.getElementById('feedbackContent').textContent = content || 'Không có nội dung';
                document.getElementById('feedbackCreatedAt').textContent = createdAt || 'Không xác định';

                // Xử lý hiển thị phản hồi
                const responseSection = document.getElementById('responseSection');
                if (response && response !== 'Chưa có phản hồi') {
                    responseSection.style.display = 'block';
                    document.getElementById('feedbackResponse').textContent = response;
                    document.getElementById('feedbackRespondedAt').textContent = respondedAt || 'Không xác định';
                } else {
                    responseSection.style.display = 'none';
                }

                // Cập nhật trạng thái với badge
                const statusBadge = document.getElementById('viewFeedbackStatus');
                if (status === 'Responded') {
                    statusBadge.className = 'badge bg-gradient-success';
                    statusBadge.textContent = 'Đã phản hồi';
                } else if (status === 'Pending') {
                    statusBadge.className = 'badge bg-gradient-warning';
                    statusBadge.textContent = 'Đang chờ';
                } else if (status === 'Replied') {
                    statusBadge.className = 'badge bg-gradient-info';
                    statusBadge.textContent = 'Đã trả lời';
                } else if (status === 'Resolved') {
                    statusBadge.className = 'badge bg-gradient-success';
                    statusBadge.textContent = 'Đã giải quyết';
                } else {
                    statusBadge.className = 'badge bg-gradient-secondary';
                    statusBadge.textContent = status;
                }

                var viewModal = new bootstrap.Modal(document.getElementById('viewFeedbackModal'));
                viewModal.show();
            });
        });

        // Thêm sự kiện click cho các nút xóa
        document.querySelectorAll('.delete-feedback-btn').forEach(function (button) {
            button.addEventListener('click', function () {
                const id = this.getAttribute('data-id');
                const email = this.getAttribute('data-email');

                document.getElementById('deleteFeedbackId').value = id;
                document.getElementById('deleteEmail').textContent = email;

                var deleteModal = new bootstrap.Modal(document.getElementById('deleteFeedbackModal'));
                deleteModal.show();
            });
        });

        // Xử lý nút xác nhận xóa
        document.getElementById('confirmDeleteBtn').addEventListener('click', function () {
            document.getElementById('deleteFeedbackForm').submit();
        });
    });
        </script>
    </body>
</html> 
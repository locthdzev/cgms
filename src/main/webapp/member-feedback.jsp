<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="Models.User, Models.Feedback, java.util.List" %>
<%
    // Fetch the logged-in user
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String pageName = "member-feedback.jsp";
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Quản lý Feedback - CGMS</title>

        <!-- Fonts and icons -->
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
        <link href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link id="pagestyle" href="assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />

        <style>
            .feedback-card {
                transition: all 0.3s ease;
                border: none;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
            }

            .feedback-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            }

            .status-badge {
                font-size: 0.75rem;
                padding: 0.375rem 0.75rem;
                border-radius: 0.5rem;
            }

            .status-pending {
                background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
                color: #2d3436;
            }

            .status-responded {
                background: linear-gradient(135deg, #00b894, #00cec9);
                color: white;
            }

            .feedback-content {
                max-height: 100px;
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
            }

            .action-buttons .btn {
                margin: 0 2px;
                padding: 0.375rem 0.75rem;
                font-size: 0.875rem;
            }

            .modal-content {
                border-radius: 1rem;
                border: none;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            }

            .modal-header {
                border-bottom: 1px solid #e9ecef;
                border-radius: 1rem 1rem 0 0;
            }

            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
            }

            .toast {
                min-width: 300px;
                margin-bottom: 10px;
                border-radius: 0.5rem;
                padding: 1rem;
                color: white;
                animation: slideIn 0.3s ease;
            }

            .toast.success {
                background: linear-gradient(135deg, #00b894, #00cec9);
            }

            .toast.error {
                background: linear-gradient(135deg, #e17055, #d63031);
            }

            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            .empty-state {
                text-align: center;
                padding: 3rem;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 4rem;
                margin-bottom: 1rem;
                opacity: 0.5;
            }
        </style>
    </head>

    <body class="g-sidenav-show bg-gray-100">
        <!-- Toast Notifications -->
        <div class="toast-container">
            <c:if test="${not empty successMessage}">
                <div class="toast success">
                    <i class="fas fa-check-circle me-2"></i>
                    ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="toast error">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    ${errorMessage}
                </div>
            </c:if>
        </div>

        <!-- Sidebar -->
        <jsp:include page="member_sidebar.jsp" />

        <!-- Main content -->
        <main class="main-content position-relative border-radius-lg">
            <!-- Navbar -->
            <nav class="navbar navbar-main navbar-expand-lg px-0 mx-4 shadow-none border-radius-xl" id="navbarBlur" data-scroll="false">
                <div class="container-fluid py-1 px-3">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb bg-transparent mb-0 pb-0 pt-1 px-0 me-sm-6 me-5">
                            <li class="breadcrumb-item text-sm">
                                <a class="opacity-5 text-white" href="member-dashboard">Trang chủ</a>
                            </li>
                            <li class="breadcrumb-item text-sm text-white active" aria-current="page">Feedback</li>
                        </ol>
                        <h6 class="font-weight-bolder text-white mb-0">Quản lý Feedback</h6>
                    </nav>
                    <div class="collapse navbar-collapse mt-sm-0 mt-2 me-md-0 me-sm-4" id="navbar">
                        <div class="ms-md-auto pe-md-3 d-flex align-items-center">
                            <!-- Search can be added here if needed -->
                        </div>
                        <ul class="navbar-nav justify-content-end">
                            <li class="nav-item px-3 d-flex align-items-center">
                                <div class="user-welcome">
                                    <p class="user-name mb-0"><%= loggedInUser.getFullName() %></p>
                                    <p class="user-email mb-0"><%= loggedInUser.getEmail() %></p>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Page content -->
            <div class="container-fluid py-4">
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-0">Danh sách Feedback của tôi</h6>
                                    <p class="text-sm mb-0">Quản lý và theo dõi các feedback bạn đã gửi</p>
                                </div>
                                <div>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#newFeedbackModal">
                                        <i class="fas fa-plus me-2"></i>Gửi Feedback mới
                                    </button>
                                </div>
                            </div>
                            <div class="card-body px-0 pt-0 pb-2">
                                <c:choose>
                                    <c:when test="${empty memberFeedbacks}">
                                        <div class="empty-state">
                                            <i class="fas fa-comments"></i>
                                            <h5>Chưa có feedback nào</h5>
                                            <p>Bạn chưa gửi feedback nào. Hãy chia sẻ ý kiến của bạn với chúng tôi!</p>
                                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newFeedbackModal">
                                                <i class="fas fa-plus me-2"></i>Gửi Feedback đầu tiên
                                            </button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive p-0">
                                            <table class="table align-items-center mb-0">
                                                <thead>
                                                    <tr>
                                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">ID</th>
                                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Nội dung</th>
                                                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày gửi</th>
                                                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày phản hồi</th>
                                                        <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="feedback" items="${memberFeedbacks}">
                                                        <tr>
                                                            <td class="ps-4">
                                                                <p class="text-xs font-weight-bold mb-0">#${feedback.id}</p>
                                                            </td>
                                                            <td class="ps-2">
                                                                <div class="feedback-content">
                                                                    <p class="text-xs mb-0">${feedback.content}</p>
                                                                </div>
                                                            </td>
                                                            <td class="text-center">
                                                                <c:choose>
                                                                    <c:when test="${feedback.status == 'Pending'}">
                                                                        <span class="badge status-badge status-pending">
                                                                            <i class="fas fa-clock me-1"></i>Chờ phản hồi
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge status-badge status-responded">
                                                                            <i class="fas fa-check me-1"></i>Đã phản hồi
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-center">
                                                                <span class="text-secondary text-xs font-weight-bold">
                                                                    <fmt:formatDate value="${feedback.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                                </span>
                                                            </td>
                                                            <td class="text-center">
                                                                <span class="text-secondary text-xs font-weight-bold">
                                                                    <c:choose>
                                                                        <c:when test="${feedback.respondedAt != null}">
                                                                            <fmt:formatDate value="${feedback.respondedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">Chưa có</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </td>
                                                            <td class="text-center">
                                                                <div class="action-buttons">
                                                                    <button class="btn btn-info btn-sm view-feedback-btn" 
                                                                            data-id="${feedback.id}" 
                                                                            data-content="${feedback.content}"
                                                                            data-status="${feedback.status} "
                                                                            data-response="${feedback.response}" 
                                                                            data-bs-toggle="modal" 
                                                                            data-bs-target="#viewFeedbackModal">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
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
                                © <script>document.write(new Date().getFullYear())</script>, CoreFit Gym Management System
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
        </main>

        <!-- New Feedback Modal -->
        <div class="modal fade" id="newFeedbackModal" tabindex="-1" aria-labelledby="newFeedbackModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="newFeedbackModalLabel">Gửi Feedback mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="member/feedback">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="sendFeedback">
                            <div class="mb-3">
                                <label for="guestEmail" class="form-label">Email (tùy chọn)</label>
                                <input type="email" class="form-control" id="guestEmail" name="guestEmail" placeholder="Nhập email của bạn">
                            </div>
                            <div class="mb-3">
                                <label for="content" class="form-label">Nội dung feedback <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="content" name="content" rows="4" placeholder="Nhập nội dung feedback..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Gửi Feedback</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- View Feedback Modal -->
        <div class="modal fade" id="viewFeedbackModal" tabindex="-1" aria-labelledby="viewFeedbackModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="viewFeedbackModalLabel">Chi tiết Feedback</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nội dung:</label>
                            <p id="modalFeedbackContent" class="form-control-plaintext border p-2 rounded bg-light"></p>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Trạng thái:</label>
                            <div id="modalFeedbackStatus"></div>
                        </div>
                        <div id="responseSection" style="display: none;">
                            <label class="form-label fw-bold">Phản hồi từ quản lý:</label>
                            <p id="modalFeedbackResponse" class="form-control-plaintext border p-2 rounded bg-light"></p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Core JS Files -->
        <script src="assets/js/core/popper.min.js"></script>
        <script src="assets/js/core/bootstrap.min.js"></script>
        <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
        <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

        <script>
            // Auto-hide toasts after 5 seconds
            setTimeout(function() {
                const toasts = document.querySelectorAll('.toast');
                if (toasts) {
                    toasts.forEach(function(toast) {
                        if (toast) {
                            toast.style.display = 'none';
                        }
                    });
                }
            }, 5000);

            // Function to show toast messages
            function showToast(message, type) {
                const toastContainer = document.querySelector('.toast-container');
                if (toastContainer) {
                    const toast = document.createElement('div');
                    toast.className = `toast ${type}`;
                    toast.innerHTML = `
                        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'} me-2"></i>
                        ${message}
                    `;
                    toastContainer.appendChild(toast);
                    
                    setTimeout(() => {
                        if (toast && toast.parentNode) {
                            toast.remove();
                        }
                    }, 5000);
                }
            }

            // Wait for DOM to be fully loaded
            document.addEventListener('DOMContentLoaded', function() {
                // Handle form submission
                const feedbackForm = document.querySelector('#newFeedbackModal form');
                if (feedbackForm) {
                    feedbackForm.addEventListener('submit', function(e) {
                        e.preventDefault();
                        
                        const formData = new FormData(this);
                        
                        fetch('member/feedback', {
                            method: 'POST',
                            body: formData
                        })
                        .then(response => response.text())
                        .then(data => {
                            // Close modal
                            const modalElement = document.getElementById('newFeedbackModal');
                            if (modalElement) {
                                const modal = bootstrap.Modal.getInstance(modalElement);
                                if (modal) {
                                    modal.hide();
                                } else {
                                    // Create new modal instance if not exists
                                    const newModal = new bootstrap.Modal(modalElement);
                                    newModal.hide();
                                }
                            }
                            
                            // Clear form
                            this.reset();
                            
                            // Show success message
                            showToast('Gửi feedback thành công!', 'success');
                            
                            // Reload page to show new feedback
                            setTimeout(() => {
                                window.location.reload();
                            }, 1500);
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showToast('Gửi feedback thất bại!', 'error');
                        });
                    });
                }

                // Handle view feedback modal
                const viewButtons = document.querySelectorAll('.view-feedback-btn');
                if (viewButtons) {
                    viewButtons.forEach(function (button) {
                        if (button) {
                            button.addEventListener('click', function () {
                                const content = button.getAttribute('data-content');
                                const status = button.getAttribute('data-status');
                                const response = button.getAttribute('data-response');

                                const contentElement = document.getElementById('modalFeedbackContent');
                                if (contentElement && content) {
                                    contentElement.textContent = content;
                                }

                                // Update status display
                                const statusElement = document.getElementById('modalFeedbackStatus');
                                if (statusElement && status) {
                                    const trimmedStatus = status.trim();
                                    if (trimmedStatus === 'Pending') {
                                        statusElement.innerHTML = '<span class="badge status-badge status-pending"><i class="fas fa-clock me-1"></i>Chờ phản hồi</span>';
                                    } else {
                                        statusElement.innerHTML = '<span class="badge status-badge status-responded"><i class="fas fa-check me-1"></i>Đã phản hồi</span>';
                                    }
                                }

                                // Show response if available
                                const responseSection = document.getElementById('responseSection');
                                const responseElement = document.getElementById('modalFeedbackResponse');
                                if (responseSection && responseElement) {
                                    if (response && response.trim() !== '' && response !== 'null') {
                                        responseElement.textContent = response;
                                        responseSection.style.display = 'block';
                                    } else {
                                        responseSection.style.display = 'none';
                                    }
                                }
                            });
                        }
                    });
                }
            });
        </script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Models.User, Models.Schedule, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png">
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png">
    <title>Tạo lịch tập mới - Personal Trainer</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <%@ include file="pt_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Tạo lịch tập mới" />
            <jsp:param name="parentPage" value="Quản lý lịch tập" />
            <jsp:param name="parentPageUrl" value="pt_schedule" />
            <jsp:param name="currentPage" value="Tạo lịch tập mới" />
        </jsp:include>

        <div class="container-fluid py-4">
            <!-- Header Section -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="text-white mb-0">Tạo lịch tập mới</h4>
                        <a href="${pageContext.request.contextPath}/pt_schedule" class="btn btn-outline-white btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>
            </div>

            <!-- Form Section -->
            <div class="row">
                <div class="col-12">
                    <div class="card shadow-lg">
                        <div class="card-header pb-0">
                            <h6>Thông tin lịch tập</h6>
                        </div>
                        <div class="card-body">
                            <% if (request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i> <%= request.getAttribute("errorMessage") %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <% } %>

                            <form action="${pageContext.request.contextPath}/pt_schedule/create" method="post">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="memberId" class="form-control-label">Hội viên <span class="text-danger">*</span></label>
                                            <select class="form-control" id="memberId" name="memberId" required>
                                                <option value="">-- Chọn hội viên --</option>
                                                <c:if test="${empty members}">
                                                    <option disabled>Không có hội viên nào</option>
                                                </c:if>
                                                <c:forEach var="member" items="${members}">
                                                    <option value="${member.id}" title="Email: ${member.email} - Có gói tập hiện tại">
                                                        ${member.fullName != null ? member.fullName : member.userName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="scheduleDate" class="form-control-label">Ngày tập <span class="text-danger">*</span></label>
                                            <input class="form-control" type="date" id="scheduleDate" name="scheduleDate" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="scheduleTime" class="form-control-label">Thời gian bắt đầu <span class="text-danger">*</span></label>
                                            <input class="form-control" type="time" id="scheduleTime" name="scheduleTime" required min="07:00" max="22:00">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="durationHours" class="form-control-label">Thời lượng <span class="text-danger">*</span></label>
                                            <select class="form-control" id="durationHours" name="durationHours" required>
                                                <option value="">-- Chọn thời lượng --</option>
                                                <option value="0.5">30 phút</option>
                                                <option value="1.0">1 giờ</option>
                                                <option value="1.5">1 giờ 30 phút</option>
                                                <option value="2.0">2 giờ</option>
                                                <option value="2.5">2 giờ 30 phút</option>
                                                <option value="3.0">3 giờ</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-12">
                                        <div class="form-group">
                                            <label for="notes" class="form-control-label">Ghi chú</label>
                                            <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Ghi chú về buổi tập..."></textarea>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Tạo lịch tập
                                    </button>
                                </div>
                            </form>
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
                            © <script>document.write(new Date().getFullYear())</script>,
                            made by <a href="#" class="font-weight-bold">SWP391_07</a>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    </main>

    <script src="./assets/js/core/popper.min.js"></script>
    <script src="./assets/js/core/bootstrap.min.js"></script>
    <script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="./assets/js/plugins/smooth-scrollbar.min.js"></script>
    <script src="./assets/js/argon-dashboard.min.js?v=2.1.0"></script>
    
    <script>
        // Set minimum date to today
        document.getElementById('scheduleDate').min = new Date().toISOString().split('T')[0];
    </script>
</body>
</html>



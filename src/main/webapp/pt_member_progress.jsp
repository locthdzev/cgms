<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User, Models.Schedule, java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="${pageContext.request.contextPath}/assets/img/icons8-gym-96.png">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/icons8-gym-96.png">
    <title>Tiến độ hội viên - Personal Trainer</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="${pageContext.request.contextPath}/assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

   
    <%@ include file="pt_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Tiến độ thành viên" />
            <jsp:param name="parentPage" value="Quản lý lịch tập" />
            <jsp:param name="parentPageUrl" value="pt_schedule" />
            <jsp:param name="currentPage" value="Tiến độ thành viên" />
        </jsp:include>

        <div class="container-fluid py-4">
            <!-- Header Section -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="text-white mb-0">Tiến độ thành viên - ${schedule.member.fullName}</h4>
                        <a href="${pageContext.request.contextPath}/pt_schedule" class="btn btn-outline-white btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>
            </div>

            <!-- Member Info Card -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card shadow-lg">
                        <div class="card-header pb-0">
                            <h6>Thông tin hội viên</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="d-flex align-items-center">
                                        <div class="avatar avatar-xl me-3">
                                            <img src="${pageContext.request.contextPath}/assets/img/team-2.jpg" alt="profile_image" class="w-100 border-radius-lg shadow-sm">
                                        </div>
                                        <div>
                                            <h6 class="mb-0">Hội viên ID: ${memberId}</h6>
                                            <p class="text-sm text-secondary mb-0">Tổng số buổi tập: ${memberSchedules.size()}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <div class="d-flex flex-column">
                                        <span class="text-sm text-secondary">Buổi hoàn thành</span>
                                        <h5 class="font-weight-bolder mb-0">
                                            <c:set var="completedCount" value="0" />
                                            <c:forEach var="schedule" items="${memberSchedules}">
                                                <c:if test="${schedule.status == 'Completed'}">
                                                    <c:set var="completedCount" value="${completedCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${completedCount}/${memberSchedules.size()}
                                        </h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Progress Statistics -->
            <div class="row mb-4">
                <div class="col-lg-3 col-md-6">
                    <div class="card">
                        <div class="card-body p-3">
                            <div class="row">
                                <div class="col-8">
                                    <div class="numbers">
                                        <p class="text-sm mb-0 text-uppercase font-weight-bold">Hoàn thành</p>
                                        <h5 class="font-weight-bolder">
                                            ${completedCount}
                                        </h5>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <div class="icon icon-shape bg-gradient-success shadow-success text-center rounded-circle">
                                        <i class="ni ni-check-bold text-lg opacity-10"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card">
                        <div class="card-body p-3">
                            <div class="row">
                                <div class="col-8">
                                    <div class="numbers">
                                        <p class="text-sm mb-0 text-uppercase font-weight-bold">Đã xác nhận</p>
                                        <h5 class="font-weight-bolder">
                                            <c:set var="confirmedCount" value="0" />
                                            <c:forEach var="schedule" items="${memberSchedules}">
                                                <c:if test="${schedule.status == 'Confirmed'}">
                                                    <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${confirmedCount}
                                        </h5>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <div class="icon icon-shape bg-gradient-info shadow-info text-center rounded-circle">
                                        <i class="ni ni-calendar-grid-58 text-lg opacity-10"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card">
                        <div class="card-body p-3">
                            <div class="row">
                                <div class="col-8">
                                    <div class="numbers">
                                        <p class="text-sm mb-0 text-uppercase font-weight-bold">Chờ xử lý</p>
                                        <h5 class="font-weight-bolder">
                                            <c:set var="pendingCount" value="0" />
                                            <c:forEach var="schedule" items="${memberSchedules}">
                                                <c:if test="${schedule.status == 'Pending'}">
                                                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${pendingCount}
                                        </h5>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <div class="icon icon-shape bg-gradient-warning shadow-warning text-center rounded-circle">
                                        <i class="ni ni-time-alarm text-lg opacity-10"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card">
                        <div class="card-body p-3">
                            <div class="row">
                                <div class="col-8">
                                    <div class="numbers">
                                        <p class="text-sm mb-0 text-uppercase font-weight-bold">Đã hủy</p>
                                        <h5 class="font-weight-bolder">
                                            <c:set var="cancelledCount" value="0" />
                                            <c:forEach var="schedule" items="${memberSchedules}">
                                                <c:if test="${schedule.status == 'Cancelled'}">
                                                    <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${cancelledCount}
                                        </h5>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <div class="icon icon-shape bg-gradient-danger shadow-danger text-center rounded-circle">
                                        <i class="ni ni-fat-remove text-lg opacity-10"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Schedule History Table -->
            <div class="row">
                <div class="col-12">
                    <div class="card shadow-lg">
                        <div class="card-header pb-0">
                            <h6>Lịch sử tập luyện</h6>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="table-responsive p-0">
                                <table class="table align-items-center mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">NGÀY TẬP</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">THỜI GIAN</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">THỜI LƯỢNG</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">TRẠNG THÁI</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">GHI CHÚ</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="schedule" items="${memberSchedules}">
                                            <tr>
                                                <td class="ps-4">
                                                    <p class="text-xs font-weight-bold mb-0">${schedule.scheduleDate}</p>
                                                </td>
                                                <td>
                                                    <p class="text-xs font-weight-bold mb-0">${schedule.scheduleTime}</p>
                                                </td>
                                                <td>
                                                    <p class="text-xs font-weight-bold mb-0">${schedule.durationHours} giờ</p>
                                                </td>
                                                <td>
                                                    <span class="badge badge-sm ${schedule.status == 'Completed' ? 'bg-gradient-success' : 
                                                                                 schedule.status == 'Confirmed' ? 'bg-gradient-info' : 
                                                                                 schedule.status == 'Cancelled' ? 'bg-gradient-danger' : 'bg-gradient-warning'}">
                                                        ${schedule.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <p class="text-xs text-secondary mb-0">
                                                        ${schedule.notes != null ? schedule.notes : 'Không có ghi chú'}
                                                    </p>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty memberSchedules}">
                                            <tr>
                                                <td colspan="5" class="text-center py-4">
                                                    <p class="text-sm text-secondary mb-0">Chưa có lịch tập nào</p>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
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

    <script src="${pageContext.request.contextPath}/assets/js/core/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/core/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/plugins/smooth-scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html>



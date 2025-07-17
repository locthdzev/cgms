<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Models.Schedule, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png">
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png">
    <title>Quản lý lịch tập - Personal Trainer</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <!-- Include PT Sidebar -->
    <%@ include file="pt_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <!-- Include Navbar Component -->
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Quản lý lịch tập" />
            <jsp:param name="parentPage" value="Dashboard" />
            <jsp:param name="parentPageUrl" value="pt_dashboard.jsp" />
            <jsp:param name="currentPage" value="Quản lý lịch tập" />
        </jsp:include>

        <div class="container-fluid py-4">
            <!-- Header Section -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="text-white mb-0">Danh sách lịch tập</h4>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/pt_dashboard.jsp" class="btn btn-outline-white btn-sm">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/pt-add-schedule.jsp" class="btn btn-white btn-sm">
                                <i class="fas fa-plus me-2"></i>Tạo lịch mới
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                    <div class="card">
                        <div class="card-body p-3">
                            <div class="row">
                                <div class="col-8">
                                    <div class="numbers">
                                        <p class="text-sm mb-0 text-uppercase font-weight-bold">Tổng lịch tập</p>
                                        <h5 class="font-weight-bolder">${schedules.size()}</h5>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <div class="icon icon-shape bg-gradient-primary shadow-primary text-center rounded-circle">
                                        <i class="fas fa-calendar-alt text-lg opacity-10"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                    <div class="card">
                        <div class="card-body p-3">
                            <div class="row">
                                <div class="col-8">
                                    <div class="numbers">
                                        <p class="text-sm mb-0 text-uppercase font-weight-bold">Đã hoàn thành</p>
                                        <h5 class="font-weight-bolder">
                                            <c:set var="completed" value="0"/>
                                            <c:forEach var="schedule" items="${schedules}">
                                                <c:if test="${schedule.status == 'Completed'}">
                                                    <c:set var="completed" value="${completed + 1}"/>
                                                </c:if>
                                            </c:forEach>
                                            ${completed}
                                        </h5>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <div class="icon icon-shape bg-gradient-success shadow-success text-center rounded-circle">
                                        <i class="fas fa-check text-lg opacity-10"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Section -->
            <div class="row">
                <div class="col-12">
                    <div class="card shadow-lg">
                        <div class="card-header pb-0">
                            <h6>Danh sách lịch tập của tôi</h6>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="table-responsive p-0">
                                <table class="table align-items-center mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">ID</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">HỘI VIÊN</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">NGÀY</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">THỜI GIAN</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">TRẠNG THÁI</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">THAO TÁC</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="schedule" items="${schedules}">
                                            <tr>
                                                <td class="ps-4">
                                                    <p class="text-xs font-weight-bold mb-0">${schedule.id}</p>
                                                </td>
                                                <td>
                                                    <div class="d-flex px-2 py-1">
                                                        <div class="d-flex flex-column justify-content-center">
                                                            <h6 class="mb-0 text-sm">
                                                                ${schedule.member.fullName != null ? schedule.member.fullName : schedule.member.userName}
                                                            </h6>
                                                            <p class="text-xs text-secondary mb-0">${schedule.member.email}</p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <p class="text-xs font-weight-bold mb-0">${schedule.scheduleDate}</p>
                                                </td>
                                                <td>
                                                    <p class="text-xs font-weight-bold mb-0">${schedule.scheduleTime}</p>
                                                </td>
                                                <td>
                                                    <span class="badge badge-sm ${schedule.status == 'Completed' ? 'bg-gradient-success' : 
                                                                                 schedule.status == 'Confirmed' ? 'bg-gradient-info' : 
                                                                                 schedule.status == 'Cancelled' ? 'bg-gradient-danger' : 'bg-gradient-warning'}">
                                                        ${schedule.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/pt_schedule_members.jsp?scheduleId=${schedule.id}" 
                                                       class="btn btn-link text-dark px-3 mb-0">
                                                        <i class="fas fa-eye text-secondary me-2"></i>Chi tiết
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/pt_member_progress.jsp?scheduleId=${schedule.id}" 
                                                       class="btn btn-link text-dark px-3 mb-0">
                                                        <i class="fas fa-chart-line text-info me-2"></i>Tiến độ
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
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

    <!-- Core JS Files -->
    <script src="./assets/js/core/popper.min.js"></script>
    <script src="./assets/js/core/bootstrap.min.js"></script>
    <script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="./assets/js/plugins/smooth-scrollbar.min.js"></script>
    <script src="./assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html>














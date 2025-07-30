<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User, Models.Schedule, Services.ScheduleService, Services.UserService"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="${pageContext.request.contextPath}/assets/img/icons8-gym-96.png">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/icons8-gym-96.png">
    <title>CORE-FIT GYM</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="${pageContext.request.contextPath}/assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
    <%@ include file="pt_sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Chi tiết lịch tập" />
            <jsp:param name="parentPage" value="Quản lý lịch tập" />
            <jsp:param name="parentPageUrl" value="pt_schedule" />
            <jsp:param name="currentPage" value="Chi tiết lịch tập" />
        </jsp:include>

        <div class="container-fluid py-4">
            <!-- Header Section -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="text-white mb-0">Chi tiết lịch tập #${schedule.id}</h4>
                        <a href="${pageContext.request.contextPath}/pt_schedule" class="btn btn-outline-white btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>
            </div>

            <!-- Schedule Information Card -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card shadow-lg">
                        <div class="card-header pb-0">
                            <h6>Thông tin lịch tập</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label">Ngày tập</label>
                                        <input type="text" class="form-control" value="${schedule.scheduleDate != null ? schedule.scheduleDate : 'Chưa xác định'}" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label">Thời gian</label>
                                        <input type="text" class="form-control" value="${schedule.scheduleTime != null ? schedule.scheduleTime : 'Chưa xác định'}" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label">Thời lượng</label>
                                        <input type="text" class="form-control" value="${schedule.durationHours != null ? schedule.durationHours.concat(' giờ') : 'Chưa xác định'}" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-control-label">Trạng thái</label>
                                        <div class="mt-2">
                                            <c:choose>
                                                <c:when test="${schedule.status == 'Completed'}">
                                                    <span class="badge badge-lg bg-gradient-success">Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${schedule.status == 'Confirmed'}">
                                                    <span class="badge badge-lg bg-gradient-info">Đã xác nhận</span>
                                                </c:when>
                                                <c:when test="${schedule.status == 'Cancelled'}">
                                                    <span class="badge badge-lg bg-gradient-danger">Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-lg bg-gradient-warning">Chờ xử lý</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <c:if test="${schedule.notes != null && !empty schedule.notes}">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="form-group">
                                            <label class="form-control-label">Ghi chú</label>
                                            <textarea class="form-control" rows="3" readonly>${schedule.notes}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Member Information Card -->
            <div class="row">
                <div class="col-12">
                    <div class="card shadow-lg">
                        <div class="card-header pb-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6>Thông tin hội viên</h6>
                                <c:if test="${schedule.member != null}">
                                    <a href="${pageContext.request.contextPath}/pt_schedule/member-progress?memberId=${schedule.member.id}" 
                                       class="btn btn-primary btn-sm">
                                        <i class="fas fa-chart-line me-2"></i>Xem tiến độ
                                    </a>
                                </c:if>
                            </div>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${schedule.member != null}">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="avatar avatar-xl me-3">
                                                    <img src="${pageContext.request.contextPath}/assets/img/team-2.jpg" alt="profile_image" class="w-100 border-radius-lg shadow-sm">
                                                </div>
                                                <div>
                                                    <h6 class="mb-0">
                                                        ${schedule.member.fullName != null && !empty schedule.member.fullName ? schedule.member.fullName : schedule.member.userName}
                                                    </h6>
                                                    <p class="text-sm text-secondary mb-0">
                                                        ${schedule.member.email != null ? schedule.member.email : 'Chưa có email'}
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-control-label">Số điện thoại</label>
                                                <input type="text" class="form-control" 
                                                       value="${schedule.member.phoneNumber != null && !empty schedule.member.phoneNumber ? schedule.member.phoneNumber : 'Chưa cập nhật'}" readonly>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-control-label">Địa chỉ</label>
                                                <input type="text" class="form-control" 
                                                       value="${schedule.member.address != null && !empty schedule.member.address ? schedule.member.address : 'Chưa cập nhật'}" readonly>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-control-label">Giới tính</label>
                                                <input type="text" class="form-control" 
                                                       value="${schedule.member.gender != null && !empty schedule.member.gender ? schedule.member.gender : 'Chưa xác định'}" readonly>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <p class="text-muted">Không có thông tin hội viên</p>
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

<%@page import="Services.ScheduleService, Services.UserService"%>
<%
    String scheduleIdParam = request.getParameter("scheduleId");
    if (scheduleIdParam != null) {
        ScheduleService scheduleService = new ScheduleService();
        UserService userService = new UserService();
        
        int scheduleId = Integer.parseInt(scheduleIdParam);
        Schedule schedule = scheduleService.getScheduleById(scheduleId);
        
        if (schedule != null && schedule.getMember() != null) {
            User fullMember = userService.getUserById(schedule.getMember().getId());
            schedule.setMember(fullMember);
        }
        
        request.setAttribute("schedule", schedule);
    }
%>



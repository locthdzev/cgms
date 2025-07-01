
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Checkin" %>
<%@ page import="Models.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    List<Checkin> checkinList = (List<Checkin>) request.getAttribute("checkinList");
    User member = (checkinList != null && !checkinList.isEmpty()) ? checkinList.get(0).getMember() : null;
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Lịch sử Check-In - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>
<body class="g-sidenav-show bg-gray-100">
<div class="min-height-300 bg-dark position-absolute w-100"></div>

<!-- Include Sidebar Component -->
<%@ include file="sidebar.jsp" %>

<main class="main-content position-relative border-radius-lg">
    <!-- Include Navbar Component with parameters -->
    <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Lịch sử Check-In" />
        <jsp:param name="parentPage" value="Quản lý lịch tập" />
        <jsp:param name="parentPageUrl" value="schedule" />
        <jsp:param name="currentPage" value="Lịch sử Check-In" />
    </jsp:include>

    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <div class="card mb-4">
                    <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0"><i class="fas fa-history me-2"></i>Lịch sử Check-In
                        <% if (member != null) { %>
                            - <span class="text-primary"><%= member.getFullName() != null ? member.getFullName() : member.getUserName() %></span>
                        <% } %>
                        </h6>
                        <a href="schedule" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại quản lý lịch
                        </a>
                    </div>
                    <div class="card-body px-0 pt-0 pb-2">
                        <div class="table-responsive p-0">
                            <table class="table align-items-center mb-0">
                                <thead>
                                    <tr>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">STT</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày Check-In</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Giờ Check-In</th>
                                        <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% if (checkinList != null && !checkinList.isEmpty()) {
                                    int stt = 1;
                                    for (Checkin c : checkinList) { %>
                                        <tr>
                                            <td><%= stt++ %></td>
                                            <td><%= c.getCheckinDate() != null ? c.getCheckinDate().format(dateFormatter) : "" %></td>
                                            <td><%= c.getCheckinTime() != null ? c.getCheckinTime().format(timeFormatter) : "" %></td>
                                            <td>
                                                <% if (c.getStatus() != null) { %>
                                                    <span class="badge bg-gradient-info"><%= c.getStatus() %></span>
                                                <% } %>
                                            </td>
                                        </tr>
                                <%   }
                                   } else { %>
                                    <tr><td colspan="4" class="text-center py-4">Không có dữ liệu check-in</td></tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Core JS Files -->
<script src="./assets/js/core/popper.min.js"></script>
<script src="./assets/js/core/bootstrap.min.js"></script>
<script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
<script src="./assets/js/plugins/smooth-scrollbar.min.js"></script>
<script src="./assets/js/argon-dashboard.min.js?v=2.1.0"></script>

</body>
</html>

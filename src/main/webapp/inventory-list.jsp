<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="Models.Inventory"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png"/>
        <link rel="icon" type="image/png" href="assets/img/weightlifting.png"/>
        <title>CoreFit Gym Management System</title>
        <!-- Fonts and icons -->
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet"/>
        <!-- Nucleo Icons -->
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet"/>
        <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet"/>
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <!-- CSS Files -->
        <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet"/>    <style>
            /* Toast styles */
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
            }
        </style>
    </head>
    <body class="g-sidenav-show bg-gray-100">
        <div class="min-height-300 bg-dark position-absolute w-100"></div>

        <!-- Toast Container -->
        <div class="toast-container">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true" id="successToast">
                    <div class="d-flex">
                        <div class="toast-body">
                            <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
                <% session.removeAttribute("successMessage"); %>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" id="errorToast">
                    <div class="d-flex">
                        <div class="toast-body">
                            <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMessage}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            </c:if>
        </div>

        <!-- Include Sidebar Component -->
        <%@ include file="sidebar.jsp" %>

        <!-- MAIN CONTENT -->
        <main class="main-content position-relative border-radius-lg">
            <div class="container-fluid py-4">
                <h1 class="mb-4">Quản lý kho hàng</h1>
                <a href="${pageContext.request.contextPath}/inventory?action=add" class="btn btn-success mb-3">+ Nhập hàng mới</a>

                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách sản phẩm trong kho</h5>
                    </div>
                    <div class="card-body">
                        <table class="table align-items-center mb-0">
                            <thead>
                                <tr>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">ID</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Sản phẩm</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Số lượng tồn kho</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Cập nhật lần cuối</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                    <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${inventoryList}" var="item">
                                    <tr>
                                        <td class="text-center"><h6 class="mb-0 text-sm">${item.id}</h6></td>
                                        <td class="text-center"><h6 class="mb-0 text-sm">${item.product.name}</h6></td>
                                        <td class="text-center"><h6 class="mb-0 text-sm">${item.quantity}</h6></td>
                                        <td class="text-center">
                                            <h6 class="mb-0 text-sm">
                                                <c:if test="${not empty item.lastUpdated}">
                                                    <jsp:useBean id="lastUpdatedDate" class="java.util.Date"/>
                                                    <jsp:setProperty name="lastUpdatedDate" property="time" value="${item.lastUpdated.toEpochMilli()}"/>
                                                    <fmt:formatDate value="${lastUpdatedDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                </c:if>
                                            </h6>
                                        </td>
                                        <td class="text-center">
                                            <h6 class="mb-0 text-sm">${item.status}</h6>
                                        </td>
                                        <td class="text-center">
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-icon-only text-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                    <i class="fas fa-ellipsis-v"></i>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end">
                                                    <li>
                                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/inventory?action=edit&productId=${item.product.id}">
                                                            <i class="fas fa-edit me-2"></i>Cập nhật số lượng
                                                        </a>
                                                    </li>
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
        </main>

        <!-- Core JS Files -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
            });
        </script>
    </body>
</html>
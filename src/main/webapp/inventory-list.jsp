<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Models.Inventory" %>
<%@ page import="Models.Product" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
    <title>Quản lý kho hàng - CoreFit Gym</title>
    <!-- Fonts and icons -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <!-- Font Awesome Icons -->
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
    <!-- CSS Files -->
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>

<body class="g-sidenav-show bg-gray-100">
        <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
    <!-- Sidebar -->
    <%@ include file="sidebar.jsp" %>
    
    <!-- Main content -->
    <main class="main-content position-relative border-radius-lg">
        <!-- Include Navbar Component -->
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Quản lý kho hàng" />
            <jsp:param name="parentPage" value="Dashboard" />
            <jsp:param name="parentPageUrl" value="dashboard" />
            <jsp:param name="currentPage" value="Quản lý kho hàng" />
        </jsp:include>

        <div class="container-fluid py-4">
            <!-- Header Section -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="text-white mb-0">Danh sách Kho hàng</h4>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-white btn-sm">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <a href="${pageContext.request.contextPath}/inventory?action=add" class="btn btn-white btn-sm">
                                <i class="fas fa-plus me-2"></i>Nhập hàng mới
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Section -->
            <div class="row">
                <div class="col-12">
                    <div class="card shadow-lg">
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="table-responsive p-0">
                                <table class="table align-items-center mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">ID</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">SẢN PHẨM</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">SỐ LƯỢNG</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">TRẠNG THÁI</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">THAO TÁC</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="inventory" items="${inventoryList}">
                                            <tr>
                                                <td class="ps-4">
                                                    <p class="text-xs font-weight-bold mb-0">${inventory.id}</p>
                                                </td>
                                                <td>
                                                    <p class="text-xs font-weight-bold mb-0">${inventory.product.name}</p>
                                                </td>
                                                <td>
                                                    <p class="text-xs font-weight-bold mb-0">${inventory.quantity}</p>
                                                </td>
                                                <td>
                                                    <span class="badge badge-sm ${inventory.quantity > 0 ? 'bg-gradient-success' : 'bg-gradient-danger'}">
                                                        ${inventory.quantity > 0 ? 'Còn hàng' : 'Hết hàng'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/inventory?action=edit&productId=${inventory.product.id}" 
                                                       class="btn btn-link text-dark px-3 mb-0">
                                                        <i class="fas fa-pencil-alt text-dark me-2"></i>Sửa
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
    </main>

    <!-- Core JS Files -->
    <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
    <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
    <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html>



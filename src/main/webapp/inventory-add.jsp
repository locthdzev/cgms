<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Models.Product" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Nhập hàng mới - CoreFit Gym</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
    <link id="pagestyle" href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    <%@ include file="sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Nhập hàng mới" />
            <jsp:param name="parentPage" value="Quản lý kho hàng" />
            <jsp:param name="parentPageUrl" value="inventory" />
            <jsp:param name="currentPage" value="Nhập hàng mới" />
        </jsp:include>

        <div class="container-fluid py-4">
            <div class="row mb-4">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">Nhập hàng mới</h4>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-secondary btn-sm">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <!-- Form to add inventory -->
                            <form method="post" action="${pageContext.request.contextPath}/inventory">
                                <input type="hidden" name="action" value="add">

                                <!-- Product selection -->
                                <div class="mb-3">
                                    <label for="productId" class="form-label">Sản phẩm *</label>
                                    <select id="productId" name="productId" class="form-select" required>
                                        <option value="">-- Chọn sản phẩm --</option>
                                        <c:forEach items="${products}" var="product">
                                            <option value="${product.id}">${product.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <!-- Quantity input -->
                                <div class="mb-3">
                                    <label for="quantity" class="form-label">Số lượng nhập *</label>
                                    <input type="number" id="quantity" name="quantity" class="form-control" min="1" required>
                                </div>

                                <!-- Supplier Name -->
                                <div class="mb-3">
                                    <label for="supplierName" class="form-label">Nhà cung cấp *</label>
                                    <input type="text" id="supplierName" name="supplierName" class="form-control" required>
                                </div>

                                <!-- Tax Code -->
                                <div class="mb-3">
                                    <label for="taxCode" class="form-label">Mã số thuế *</label>
                                    <input type="text" id="taxCode" name="taxCode" class="form-control" required>
                                </div>

                                <!-- Status -->
                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái *</label>
                                    <select id="status" name="status" class="form-select" required>
                                        <option value="AVAILABLE">Còn hàng</option>
                                        <option value="OUT_OF_STOCK">Hết hàng</option>
                                    </select>
                                </div>

                                <!-- Imported Date -->
                                <div class="mb-3">
                                    <label for="importedDate" class="form-label">Ngày nhập kho *</label>
                                    <input type="date" id="importedDate" name="importedDate" class="form-control" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">Nhập hàng</button>
                                    <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary">Hủy</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
    <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
    <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html>

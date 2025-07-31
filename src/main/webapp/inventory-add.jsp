<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Models.Product" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.List" %>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || (!"Admin".equals(loggedInUser.getRole()) && !"Staff".equals(loggedInUser.getRole()))) {
        response.sendRedirect("login");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Thêm sản phẩm vào kho - CGMS</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="./assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="./assets/css/nucleo-svg.css" rel="stylesheet" />
    <link href="./assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp" />
    
    <main class="main-content position-relative border-radius-lg">
        <!-- Include Navbar -->
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Thêm sản phẩm vào kho" />
            <jsp:param name="parentPage" value="Kho hàng" />
            <jsp:param name="currentPage" value="Thêm mới" />
        </jsp:include>
        
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-lg-8 mx-auto">
                    <div class="card">
                        <div class="card-header pb-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6>Thêm sản phẩm vào kho</h6>
                                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <form method="POST" action="${pageContext.request.contextPath}/inventory">
                                <input type="hidden" name="action" value="add">
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="productId" class="form-control-label">Sản phẩm <span class="text-danger">*</span></label>
                                            <select class="form-control" id="productId" name="productId" required>
                                                <option value="">-- Chọn sản phẩm --</option>
                                                <% if (products != null) {
                                                    for (Product product : products) { %>
                                                        <option value="<%= product.getId() %>">
                                                            <%= product.getName() %> (ID: <%= product.getId() %>)
                                                        </option>
                                                <% }
                                                } %>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="quantity" class="form-control-label">Số lượng <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="quantity" name="quantity" 
                                                   min="1" required placeholder="Nhập số lượng">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="supplierName" class="form-control-label">Nhà cung cấp <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="supplierName" name="supplierName" 
                                                   required placeholder="Tên nhà cung cấp">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="taxCode" class="form-control-label">Mã số thuế <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="taxCode" name="taxCode" 
                                                   required placeholder="Mã số thuế">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="status" class="form-control-label">Trạng thái <span class="text-danger">*</span></label>
                                            <select class="form-control" id="status" name="status" required>
                                                <option value="">-- Chọn trạng thái --</option>
                                                <option value="AVAILABLE">Có sẵn</option>
                                                <option value="OUT_OF_STOCK">Hết hàng</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="importedDate" class="form-control-label">Ngày nhập kho <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" id="importedDate" name="importedDate" 
                                                   required value="<%= java.time.LocalDate.now() %>">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-12">
                                        <div class="d-flex justify-content-end">
                                            <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary me-2">
                                                <i class="fas fa-times me-1"></i>Hủy
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-1"></i>Thêm vào kho
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Toast Messages -->
    <% String successMessage = (String) session.getAttribute("successMessage");
       String errorMessage = (String) session.getAttribute("errorMessage");
       if (successMessage != null) {
           session.removeAttribute("successMessage"); %>
        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-check-circle me-2"></i><%= successMessage %>
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>
    <% }
       if (errorMessage != null) {
           session.removeAttribute("errorMessage"); %>
        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="errorToast" class="toast align-items-center text-white bg-danger border-0" role="alert">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-exclamation-circle me-2"></i><%= errorMessage %>
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>
    <% } %>

    <!-- Core JS Files -->
    <script src="./assets/js/core/popper.min.js"></script>
    <script src="./assets/js/core/bootstrap.min.js"></script>
    <script src="./assets/js/argon-dashboard.min.js?v=2.1.0"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Show toast messages
            if (document.getElementById('successToast')) {
                var successToast = new bootstrap.Toast(document.getElementById('successToast'));
                successToast.show();
            }
            
            if (document.getElementById('errorToast')) {
                var errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
                errorToast.show();
            }
        });
    </script>
</body>
</html>






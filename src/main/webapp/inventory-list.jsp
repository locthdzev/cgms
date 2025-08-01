<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Inventory" %>
<%@page import="Models.User" %>
<%@page import="java.util.List" %>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || (!"Admin".equals(loggedInUser.getRole()) && !"Staff".equals(loggedInUser.getRole()))) {
        response.sendRedirect("login");
        return;
    }

    List<Inventory> inventoryList = (List<Inventory>) request.getAttribute("inventoryList");
    Integer totalValue = (Integer) request.getAttribute("totalValue");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    Boolean isLowStock = (Boolean) request.getAttribute("isLowStock");
    Integer threshold = (Integer) request.getAttribute("threshold");
    
    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Quản lý kho - CGMS</title>
    
    <!-- Fonts and icons -->
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
            <jsp:param name="pageTitle" value="Quản lý kho" />
            <jsp:param name="parentPage" value="Kho hàng" />
            <jsp:param name="currentPage" value="Danh sách kho" />
        </jsp:include>
        
        <div class="container-fluid py-4">
            
            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
                    <div class="card">
                        <div class="card-body p-3">
                            <div class="row">
                                <div class="col-8">
                                    <div class="numbers">
                                        <p class="text-sm mb-0 text-uppercase font-weight-bold">Tổng sản phẩm</p>
                                        <h5 class="font-weight-bolder">
                                            <%= inventoryList != null ? inventoryList.size() : 0 %>
                                        </h5>
                                    </div>
                                </div>
                                <div class="col-4 text-end">
                                    <div class="icon icon-shape bg-gradient-primary shadow-primary text-center rounded-circle">
                                        <i class="ni ni-box-2 text-lg opacity-10" aria-hidden="true"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Inventory Table -->
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="card-header pb-0 d-flex justify-content-between align-items-center">
                            <h6>
                                <% if (isLowStock != null && isLowStock) { %>
                                    Sản phẩm sắp hết (dưới <%= threshold %> sản phẩm)
                                <% } else if (searchKeyword != null && !searchKeyword.isEmpty()) { %>
                                    Kết quả tìm kiếm: "<%= searchKeyword %>"
                                <% } else { %>
                                    Danh sách kho hàng
                                <% } %>
                            </h6>
                            <div class="d-flex align-items-center">
                                <form method="GET" action="${pageContext.request.contextPath}/inventory" class="me-3" style="min-width: 300px;">
                                    <input type="hidden" name="action" value="search">
                                    <div class="input-group input-group-sm">
                                        <input type="text" name="keyword" class="form-control" 
                                               placeholder="Tìm kiếm sản phẩm..." value="<%= searchKeyword != null ? searchKeyword : "" %>">
                                        <button class="btn btn-outline-primary" type="submit">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </form>
                                <a href="dashboard.jsp" class="btn btn-outline-secondary btn-sm me-2">
                                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                                </a>
                                <a href="${pageContext.request.contextPath}/inventory?action=lowstock" class="btn btn-warning btn-sm me-2">
                                    <i class="fas fa-exclamation-triangle me-1"></i>Hàng sắp hết
                                </a>
                                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary btn-sm me-2">
                                    <i class="fas fa-list me-1"></i>Tất cả
                                </a>
                                <a href="${pageContext.request.contextPath}/inventory?action=add" class="btn btn-primary btn-sm">
                                    <i class="fas fa-plus me-1"></i>Thêm sản phẩm
                                </a>
                            </div>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="table-responsive p-0">
                                <table class="table align-items-center mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Sản phẩm</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">Số lượng</th>
                                            <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Nhà cung cấp</th>
                                            <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                            <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày nhập</th>
                                            <th class="text-secondary opacity-7"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (inventoryList != null && !inventoryList.isEmpty()) { %>
                                            <% for (Inventory inventory : inventoryList) { %>
                                                <tr>
                                                    <td>
                                                        <div class="d-flex px-2 py-1">
                                                            <div class="d-flex flex-column justify-content-center">
                                                                <h6 class="mb-0 text-sm">
                                                                    <%= inventory.getProduct() != null ? inventory.getProduct().getName() : "N/A" %>
                                                                </h6>
                                                                <p class="text-xs text-secondary mb-0">
                                                                    ID: <%= inventory.getProduct() != null ? inventory.getProduct().getId() : "N/A" %>
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <p class="text-xs font-weight-bold mb-0"><%= inventory.getQuantity() %></p>
                                                        <% if (inventory.getQuantity() < 10) { %>
                                                            <p class="text-xs text-danger mb-0">Sắp hết</p>
                                                        <% } %>
                                                    </td>
                                                    <td class="align-middle text-center text-sm">
                                                        <span class="text-xs font-weight-bold">
                                                            <%= inventory.getSupplierName() != null ? inventory.getSupplierName() : "N/A" %>
                                                        </span>
                                                    </td>
                                                    <td class="align-middle text-center">
                                                        <% if ("AVAILABLE".equals(inventory.getStatus())) { %>
                                                            <span class="badge badge-sm bg-gradient-success">Có sẵn</span>
                                                        <% } else if ("OUT_OF_STOCK".equals(inventory.getStatus())) { %>
                                                            <span class="badge badge-sm bg-gradient-danger">Hết hàng</span>
                                                        <% } else { %>
                                                            <span class="badge badge-sm bg-gradient-secondary"><%= inventory.getStatus() %></span>
                                                        <% } %>
                                                    </td>
                                                    <td class="align-middle text-center">
                                                        <span class="text-secondary text-xs font-weight-bold">
                                                            <%= inventory.getImportedDate() != null ? 
                                                                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")
                                                                .format(inventory.getImportedDate().atZone(java.time.ZoneId.systemDefault()).toLocalDate()) : "N/A" %>
                                                        </span>
                                                    </td>
                                                    <td class="align-middle">
                                                        <a href="${pageContext.request.contextPath}/inventory?action=view&id=<%= inventory.getId() %>" 
                                                           class="btn btn-sm btn-outline-primary me-1">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/inventory?action=delete&id=<%= inventory.getId() %>" 
                                                           class="btn btn-sm btn-outline-danger"
                                                           onclick="return confirm('Bạn có chắc chắn muốn xóa?')">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            <% } %>
                                        <% } else { %>
                                            <tr>
                                                <td colspan="6" class="text-center py-4">
                                                    <div class="text-center">
                                                        <i class="fas fa-box-open fa-3x text-secondary mb-3"></i>
                                                        <p class="text-secondary mb-0">Không có dữ liệu kho hàng</p>
                                                    </div>
                                                </td>
                                            </tr>
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

    <!-- Toast Messages -->
    <% String successMessage = (String) session.getAttribute("successMessage");
       if (successMessage != null) { 
           session.removeAttribute("successMessage"); %>
        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert">
                <div class="d-flex">
                    <div class="toast-body"><%= successMessage %></div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>
    <% } %>

    <% String errorMessage = (String) session.getAttribute("errorMessage");
       if (errorMessage != null) { 
           session.removeAttribute("errorMessage"); %>
        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="errorToast" class="toast align-items-center text-white bg-danger border-0" role="alert">
                <div class="d-flex">
                    <div class="toast-body"><%= errorMessage %></div>
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







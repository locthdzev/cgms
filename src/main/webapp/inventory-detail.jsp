<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Models.Inventory" %>
<%@ page import="Models.User" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || (!"Admin".equals(loggedInUser.getRole()) && !"Staff".equals(loggedInUser.getRole()))) {
        response.sendRedirect("login");
        return;
    }

    Inventory inventory = (Inventory) request.getAttribute("inventory");
    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Chi tiết kho hàng - CGMS</title>
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
            <jsp:param name="pageTitle" value="Chi tiết kho hàng" />
            <jsp:param name="parentPage" value="Kho hàng" />
            <jsp:param name="currentPage" value="Chi tiết" />
        </jsp:include>
        
        <div class="container-fluid py-4">
            <% if (inventory != null) { %>
            <!-- Inventory Details -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header pb-0">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6>Thông tin kho hàng</h6>
                                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">ID Kho:</label>
                                        <p class="text-sm mb-0"><%= inventory.getId() %></p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">ID Sản phẩm:</label>
                                        <p class="text-sm mb-0"><%= inventory.getProduct() != null ? inventory.getProduct().getId() : "N/A" %></p>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">Tên sản phẩm:</label>
                                        <p class="text-sm mb-0"><%= inventory.getProduct() != null ? inventory.getProduct().getName() : "N/A" %></p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">Số lượng:</label>
                                        <p class="text-sm mb-0 <%= inventory.getQuantity() < 10 ? "text-danger" : "text-success" %>">
                                            <%= inventory.getQuantity() %>
                                            <% if (inventory.getQuantity() < 10) { %>
                                                <span class="badge badge-sm bg-gradient-warning ms-2">Sắp hết</span>
                                            <% } %>
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">Nhà cung cấp:</label>
                                        <p class="text-sm mb-0"><%= inventory.getSupplierName() != null ? inventory.getSupplierName() : "N/A" %></p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">Mã số thuế:</label>
                                        <p class="text-sm mb-0"><%= inventory.getTaxCode() != null ? inventory.getTaxCode() : "N/A" %></p>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">Trạng thái:</label>
                                        <p class="text-sm mb-0">
                                            <% if ("AVAILABLE".equals(inventory.getStatus())) { %>
                                                <span class="badge badge-sm bg-gradient-success">Có sẵn</span>
                                            <% } else if ("OUT_OF_STOCK".equals(inventory.getStatus())) { %>
                                                <span class="badge badge-sm bg-gradient-danger">Hết hàng</span>
                                            <% } else { %>
                                                <span class="badge badge-sm bg-gradient-secondary"><%= inventory.getStatus() %></span>
                                            <% } %>
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">Ngày nhập kho:</label>
                                        <p class="text-sm mb-0">
                                            <%= inventory.getImportedDate() != null ? 
                                                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")
                                                .format(inventory.getImportedDate().atZone(java.time.ZoneId.systemDefault()).toLocalDate()) : "N/A" %>
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-12">
                                    <div class="mb-3">
                                        <label class="form-label text-sm font-weight-bold">Cập nhật lần cuối:</label>
                                        <p class="text-sm mb-0">
                                            <%= inventory.getLastUpdated() != null ? 
                                                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
                                                .format(inventory.getLastUpdated().atZone(java.time.ZoneId.systemDefault())) : "N/A" %>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product Info & Actions -->
                <div class="col-lg-4">
                    <% if (inventory.getProduct() != null) { %>
                    <div class="card mb-4">
                        <div class="card-header pb-0">
                            <h6>Thông tin sản phẩm</h6>
                        </div>
                        <div class="card-body">
                            <% if (inventory.getProduct().getImageUrl() != null) { %>
                            <div class="text-center mb-3">
                                <img src="<%= inventory.getProduct().getImageUrl() %>" 
                                     alt="<%= inventory.getProduct().getName() %>" 
                                     class="img-fluid rounded" 
                                     style="max-height: 200px;">
                            </div>
                            <% } %>
                            
                            <div class="mb-3">
                                <label class="form-label text-sm font-weight-bold">Mô tả:</label>
                                <p class="text-sm mb-0"><%= inventory.getProduct().getDescription() != null ? inventory.getProduct().getDescription() : "Không có mô tả" %></p>
                            </div>
                            
                            <% if (inventory.getProduct().getPrice() != null) { %>
                            <div class="mb-3">
                                <label class="form-label text-sm font-weight-bold">Giá:</label>
                                <p class="text-sm mb-0 text-success font-weight-bold">
                                    <%= formatter.format(inventory.getProduct().getPrice()) %> VNĐ
                                </p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <!-- Actions Card -->
                    <div class="card">
                        <div class="card-header pb-0">
                            <h6>Thao tác</h6>
                        </div>
                        <div class="card-body">
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/inventory?action=delete&id=<%= inventory.getId() %>" 
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa?')">
                                    <i class="fas fa-trash me-2"></i>Xóa
                                </a>
                                <a href="${pageContext.request.contextPath}/inventory" 
                                   class="btn btn-secondary btn-sm">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="row">
                <div class="col-12">
                    <div class="alert alert-warning">
                        <h6>Không tìm thấy thông tin kho hàng!</h6>
                        <p class="mb-0">Vui lòng kiểm tra lại ID hoặc quay lại danh sách.</p>
                        <a href="${pageContext.request.contextPath}/inventory" class="btn btn-primary btn-sm mt-2">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </main>

    <!-- Core JS Files -->
    <script src="./assets/js/core/popper.min.js"></script>
    <script src="./assets/js/core/bootstrap.min.js"></script>
    <script src="./assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html>



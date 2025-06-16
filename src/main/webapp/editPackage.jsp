<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Package"%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Cập nhật gói tập - CoreFit Gym</title>
        <!-- Fonts and icons -->
<!--        <link href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,800" rel="stylesheet" />
        <link href="assets/css/nucleo-icons.css" rel="stylesheet" />
        <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>-->
        <!-- CSS Files -->
        <!--<link id="pagestyle" href="assets/css/soft-design-system.css" rel="stylesheet" />-->
    </head>
    <body>
        <!-- Header/Navigation would go here -->
        
        <div class="container mt-5 pt-5">
            <div class="row">
                <div class="col-12 d-flex justify-content-between align-items-center mb-4">
                    <h2>Cập nhật gói tập</h2>
                    <a href="listPackage" class="btn btn-outline-primary btn-round">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                    </a>
                </div>
            </div>
            
            <!-- Hiển thị thông báo lỗi nếu có -->
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
            
            <% 
                // Lấy thông tin gói tập cần cập nhật
                Package pkg = (Package) request.getAttribute("package");
                if (pkg == null) {
                    response.sendRedirect("listPackage?error=Không+tìm+thấy+gói+tập");
                    return;
                }
            %>
            
            <div class="card">
                <div class="card-body">
                    <!-- Form cập nhật gói tập -->
                    <form action="editPackage" method="post">
                        <input type="hidden" name="id" value="<%= pkg.getId() %>">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">Tên gói tập *</label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="<%= pkg.getName() %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label">Giá (VNĐ) *</label>
                                <input type="number" class="form-control" id="price" name="price" 
                                       value="<%= pkg.getPrice() %>" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="duration" class="form-label">Thời hạn (ngày) *</label>
                                <input type="number" class="form-control" id="duration" name="duration" 
                                       value="<%= pkg.getDuration() %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="sessions" class="form-label">Số buổi tập</label>
                                <input type="number" class="form-control" id="sessions" name="sessions" 
                                       value="<%= pkg.getSessions() != null ? pkg.getSessions() : "" %>">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3"><%= pkg.getDescription() != null ? pkg.getDescription() : "" %></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="status" class="form-label">Trạng thái</label>
                            <input type="text" class="form-control" id="status" value="<%= "Active".equals(pkg.getStatus()) ? "Hoạt động" : "Không hoạt động" %>" readonly>
                            <input type="hidden" name="status" value="<%= pkg.getStatus() %>">
                        </div>
                        <div class="d-flex justify-content-end mt-4">
                            <button type="reset" class="btn btn-light me-2">Làm mới</button>
                            <button type="submit" class="btn btn-primary">Cập nhật gói tập</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Footer would go here -->
        
        <!-- Core JS Files -->
        <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
        <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/js/soft-design-system.min.js" type="text/javascript"></script>
    </body>
</html>



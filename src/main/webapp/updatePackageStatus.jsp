<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Package"%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>CORE-FIT GYM</title>
    </head>
    <body>
        <div class="container mt-5 pt-5">
            <div class="row">
                <div class="col-12 d-flex justify-content-between align-items-center mb-4">
                    <h2>Cập nhật trạng thái gói tập</h2>
                    <a href="listPackage" class="btn btn-outline-primary btn-round">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                    </a>
                </div>
            </div>
            
            <!-- Hiển thị thông báo lỗi nếu có -->
            <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getParameter("error") %>
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
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5>Thông tin gói tập</h5>
                            <p><strong>ID:</strong> <%= pkg.getId() %></p>
                            <p><strong>Tên gói tập:</strong> <%= pkg.getName() %></p>
                            <p><strong>Trạng thái hiện tại:</strong> 
                                <% if ("Active".equals(pkg.getStatus())) { %>
                                    <span class="badge bg-success">Hoạt động</span>
                                <% } else { %>
                                    <span class="badge bg-secondary">Không hoạt động</span>
                                <% } %>
                            </p>
                        </div>
                    </div>
                    
                    <!-- Form cập nhật trạng thái -->
                    <form action="updatePackageStatus" method="post">
                        <input type="hidden" name="id" value="<%= pkg.getId() %>">
                        
                        <div class="mb-3">
                            <label for="status" class="form-label">Trạng thái mới</label>
                            <select class="form-control" id="status" name="status" required>
                                <option value="Active" <%= "Active".equals(pkg.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                                <option value="Inactive" <%= "Inactive".equals(pkg.getStatus()) ? "selected" : "" %>>Không hoạt động</option>
                            </select>
                        </div>
                        
                        <div class="d-flex justify-content-end mt-4">
                            <a href="listPackage" class="btn btn-light me-2">Hủy</a>
                            <button type="submit" class="btn btn-primary">Cập nhật trạng thái</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Core JS Files -->
        <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
        <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/js/soft-design-system.min.js" type="text/javascript"></script>
    </body>
</html>
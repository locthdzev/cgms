<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.Package"%>
<%@page import="DAOs.PackageDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Danh sách gói tập - CoreFit Gym</title>
        <!-- Fonts and icons -->
       <!-- <link href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,800" rel="stylesheet" />
        <link href="assets/css/nucleo-icons.css" rel="stylesheet" />
        <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script> -->
        <!-- CSS Files --> 
        <!-- <link id="pagestyle" href="assets/css/soft-design-system.css" rel="stylesheet" /> -->
    </head>
    <body>
        <!-- Header/Navigation would go here -->
        
        <!-- Hiển thị thông báo thành công/lỗi -->
        <% if (request.getParameter("message") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert" id="successAlert">
                <% if ("add_success".equals(request.getParameter("message"))) { %>
                    <i class="fas fa-check-circle me-2"></i> Thêm gói tập mới thành công!
                <% } else if ("update_success".equals(request.getParameter("message"))) { %>
                    <i class="fas fa-check-circle me-2"></i> Cập nhật gói tập thành công!
                <% } else if ("status_update_success".equals(request.getParameter("message"))) { %>
                    <i class="fas fa-check-circle me-2"></i> Cập nhật trạng thái gói tập thành công!
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            
            <script>
                // Tự động đóng thông báo sau 1 giây
                setTimeout(function() {
                    var alert = document.getElementById('successAlert');
                    if (alert) {
                        var bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                }, 1000);
            </script>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="container mt-5 pt-5">
            <div class="row">
                <div class="col-12 d-flex justify-content-between align-items-center mb-4">
                    <h2>Danh sách gói tập</h2>
                    <a href="addPackage.jsp" class="btn btn-primary btn-round">
                        <i class="fas fa-plus me-2"></i>Thêm gói tập mới
                    </a>
                </div>
            </div>
            <!-- Thêm form tìm kiếm -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <form action="listPackage" method="get" class="d-flex">
                        <input type="text" name="search" class="form-control me-2" placeholder="Tìm kiếm theo tên..." 
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>
                </div>
                <div class="col-md-6 text-end">
                    <select name="status" class="form-select d-inline-block w-auto" onchange="window.location.href='listPackage?status='+this.value">
                        <option value="">Tất cả trạng thái</option>
                        <option value="Active" <%= "Active".equals(request.getParameter("status")) ? "selected" : "" %>>Hoạt động</option>
                        <option value="Inactive" <%= "Inactive".equals(request.getParameter("status")) ? "selected" : "" %>>Không hoạt động</option>
                    </select>
                </div>
            </div>
            <div class="card">
                <div class="table-responsive">
                    <table class="table align-items-center mb-0">
                        <thead>
                            <tr>
                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">ID</th>
                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Tên gói tập</th>
                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Giá</th>
                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Thời gian</th>
                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Số buổi tập</th>
                                <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Package> packages = (List<Package>) request.getAttribute("packages");
                                if (packages != null) {
                                    for(Package pkg : packages) {
                            %>
                            <tr>
                                <td>
                                    <div class="d-flex px-2 py-1">
                                        <div class="d-flex flex-column justify-content-center">
                                            <h6 class="mb-0 text-sm"><%= pkg.getId() %></h6>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex px-2 py-1">
                                        <div class="d-flex flex-column justify-content-center">
                                            <h6 class="mb-0 text-sm"><%= pkg.getName() %></h6>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex px-2 py-1">
                                        <div class="d-flex flex-column justify-content-center">
                                            <h6 class="mb-0 text-sm">
                                                <% 
                                                    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                                    String formattedPrice = currencyFormat.format(pkg.getPrice());
                                                %>
                                                <%= formattedPrice %>
                                            </h6>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex px-2 py-1">
                                        <div class="d-flex flex-column justify-content-center">
                                            <h6 class="mb-0 text-sm"><%= pkg.getDuration() %> ngày</h6>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex px-2 py-1">
                                        <div class="d-flex flex-column justify-content-center">
                                            <h6 class="mb-0 text-sm"><%= pkg.getSessions() %></h6>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <% if ("Active".equals(pkg.getStatus())) { %>
                                        <span class="badge badge-sm bg-gradient-success">Hoạt động</span>
                                    <% } else { %>
                                        <span class="badge badge-sm bg-gradient-secondary">Không hoạt động</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="editPackage?id=<%= pkg.getId() %>" class="btn btn-link text-secondary mb-0" title="Chỉnh sửa">
                                        <i class="fa fa-edit text-xs">Cập nhật gói</i>
                                    </a>
                                    <a href="javascript:void(0)" onclick="openUpdateStatusModal(<%= pkg.getId() %>, '<%= pkg.getName() %>', '<%= pkg.getStatus() %>')" class="btn btn-link text-info mb-0" title="Cập nhật trạng thái">
                                        <i class="fa fa-refresh text-xs"> Cập nhật trạng thái</i>
                                    </a>
                                    <a href="#" class="btn btn-link text-danger mb-0" title="Xóa">
                                        <i class="fa fa-trash text-xs"></i>
                                    </a>
                                </td>
                            </tr>
                            <% 
                                    }
                                } 
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Modal cập nhật trạng thái gói tập -->
        <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateStatusModalLabel">Cập nhật trạng thái gói tập</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="updateStatusForm" action="updatePackageStatus" method="post">
                        <div class="modal-body">
                            <input type="hidden" id="packageId" name="id" value="">
                            <div class="mb-3">
                                <label class="form-label">Tên gói tập:</label>
                                <p id="packageName" class="form-control-static fw-bold"></p>
                            </div>
                            <div class="mb-3">
                                <label for="statusSelect" class="form-label">Trạng thái mới:</label>
                                <select class="form-control" id="statusSelect" name="status" required>
                                    <option value="Active">Hoạt động</option>
                                    <option value="Inactive">Không hoạt động</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- JavaScript xử lý modal -->
        <script>
            function openUpdateStatusModal(id, name, status) {
                document.getElementById('packageId').value = id;
                document.getElementById('packageName').textContent = name;
                document.getElementById('statusSelect').value = status;
                
                // Mở modal
                var myModal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
                myModal.show();
            }
        </script>
        
        <!-- Core JS Files -->
        <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
        <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
        <script src="assets/js/soft-design-system.min.js" type="text/javascript"></script>
    </body>
</html>



























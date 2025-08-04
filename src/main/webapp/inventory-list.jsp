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

    <style>
        .search-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .search-input-group {
            position: relative;
            max-width: 500px;
            margin: 0 auto;
        }

        .search-input {
            border: none;
            border-radius: 25px;
            padding: 12px 50px 12px 20px;
            font-size: 16px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
        }

        .search-input:focus {
            outline: none;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        .search-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .search-btn:hover {
            transform: translateY(-50%) scale(1.05);
        }

        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .action-btn {
            border-radius: 8px;
            padding: 8px 12px;
            margin: 0 2px;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            transform: translateY(-2px);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
        }

        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-update {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
            font-weight: 600;
        }

        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
    </style>
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
            <!-- Search Section -->
            <div class="search-container">
                <div class="text-center mb-3">
                    <h4 class="text-white mb-1">
                        <i class="fas fa-search me-2"></i>Tìm kiếm kho hàng
                    </h4>
                    <p class="text-white mb-0">Nhập tên sản phẩm hoặc mã sản phẩm để tìm kiếm</p>
                </div>
                <form method="GET" action="${pageContext.request.contextPath}/inventory">
                    <input type="hidden" name="action" value="search" />
                    <div class="search-input-group">
                        <input type="text" name="keyword" class="search-input"
                                placeholder="Tìm kiếm sản phẩm..." 
                                value="<%= searchKeyword != null ? searchKeyword : "" %>">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>

                <% if (searchKeyword != null && !searchKeyword.isEmpty()) { %>
                <div class="text-center mt-3">
                    <span class="badge bg-white text-primary px-3 py-2">
                        Kết quả cho: "<%= searchKeyword %>"
                    </span>
                    <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-light btn-sm ms-2">
                        <i class="fas fa-times me-1"></i>Xóa bộ lọc
                    </a>
                </div>
                <% } %>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stats-card text-center">
                        <div class="icon icon-shape bg-gradient-primary shadow mx-auto mb-3" style="width: 60px; height: 60px;">
                            <i class="fas fa-boxes text-lg opacity-10"></i>
                        </div>
                        <h3 class="font-weight-bolder text-primary mb-1">
                            <%= inventoryList != null ? inventoryList.size() : 0 %>
                        </h3>
                        <p class="text-sm text-muted mb-0">Tổng sản phẩm</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stats-card text-center">
                        <div class="icon icon-shape bg-gradient-success shadow mx-auto mb-3" style="width: 60px; height: 60px;">
                            <i class="fas fa-check-circle text-lg opacity-10"></i>
                        </div>
                        <h3 class="font-weight-bolder text-success mb-1">
                            <% 
                                int availableCount = 0;
                                if (inventoryList != null) {
                                    for (Inventory inv : inventoryList) {
                                        if ("Available".equals(inv.getStatus()) || "AVAILABLE".equals(inv.getStatus())) {
                                            availableCount++;
                                        }
                                    }
                                }
                            %>
                            <%= availableCount %>
                        </h3>
                        <p class="text-sm text-muted mb-0">Có sẵn</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stats-card text-center">
                        <div class="icon icon-shape bg-gradient-warning shadow mx-auto mb-3" style="width: 60px; height: 60px;">
                            <i class="fas fa-exclamation-triangle text-lg opacity-10"></i>
                        </div>
                        <h3 class="font-weight-bolder text-warning mb-1">
                            <% 
                                int lowStockCount = 0;
                                if (inventoryList != null) {
                                    for (Inventory inv : inventoryList) {
                                        if (inv.getQuantity() < 10) {
                                            lowStockCount++;
                                        }
                                    }
                                }
                            %>
                            <%= lowStockCount %>
                        </h3>
                        <p class="text-sm text-muted mb-0">Sắp hết</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stats-card text-center">
                        <div class="icon icon-shape bg-gradient-danger shadow mx-auto mb-3" style="width: 60px; height: 60px;">
                            <i class="fas fa-times-circle text-lg opacity-10"></i>
                        </div>
                        <h3 class="font-weight-bolder text-danger mb-1">
                            <% 
                                int outOfStockCount = 0;
                                if (inventoryList != null) {
                                    for (Inventory inv : inventoryList) {
                                        if ("Out of Stock".equals(inv.getStatus()) || "OUT_OF_STOCK".equals(inv.getStatus()) || inv.getQuantity() == 0) {
                                            outOfStockCount++;
                                        }
                                    }
                                }
                            %>
                            <%= outOfStockCount %>
                        </h3>
                        <p class="text-sm text-muted mb-0">Hết hàng</p>
                    </div>
                </div>
            </div>

            <!-- Inventory Table -->
            <div class="row">
                <div class="col-12">
                    <div class="table-container">
                        <div class="card-header pb-0 p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="fas fa-warehouse me-2 text-primary"></i>
                                    Danh sách kho hàng
                                </h5>
                                <a href="${pageContext.request.contextPath}/inventory?action=add" 
                                   class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Thêm sản phẩm
                                </a>
                            </div>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="table-responsive p-0">
                                <table class="table align-items-center mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">
                                                Sản phẩm
                                            </th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7 ps-2">
                                                Số lượng
                                            </th>
                                            <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">
                                                Nhà cung cấp
                                            </th>
                                            <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">
                                                Trạng thái
                                            </th>
                                            <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">
                                                Ngày nhập
                                            </th>
                                            <th class="text-center text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">
                                                Thao tác
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (inventoryList != null && !inventoryList.isEmpty()) { %>
                                            <% for (Inventory inventory : inventoryList) { %>
                                        <tr>
                                            <td>
                                                <div class="d-flex px-2 py-1">
                                                    <div class="avatar avatar-sm bg-gradient-primary rounded-circle me-3">
                                                        <i class="fas fa-box text-white opacity-10"></i>
                                                    </div>
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
                                                <p class="text-sm font-weight-bold mb-0">
                                                    <%= inventory.getQuantity() %>
                                                </p>
                                                <% if (inventory.getQuantity() < 10) { %>
                                                <p class="text-xs text-warning mb-0">
                                                    <i class="fas fa-exclamation-triangle me-1"></i>Sắp hết
                                                </p>
                                                <% } %>
                                            </td>
                                            <td class="align-middle text-center text-sm">
                                                <span class="text-xs font-weight-bold">
                                                    <%= inventory.getSupplierName() != null ? inventory.getSupplierName() : "N/A" %>
                                                </span>
                                            </td>
                                            <td class="align-middle text-center">
                                                <% 
                                                    String statusClass = "";
                                                    String statusText = "";
                                                    String status = inventory.getStatus();
                                                    
                                                    if ("Available".equals(status) || "AVAILABLE".equals(status)) {
                                                        statusClass = "bg-gradient-success";
                                                        statusText = "Có sẵn";
                                                    } else if ("Out of Stock".equals(status) || "OUT_OF_STOCK".equals(status)) {
                                                        statusClass = "bg-gradient-danger";
                                                        statusText = "Hết hàng";
                                                    } else {
                                                        statusClass = "bg-gradient-secondary";
                                                        statusText = status;
                                                    }
                                                %>
                                                <span class="status-badge <%= statusClass %>">
                                                    <%= statusText %>
                                                </span>
                                            </td>
                                            <td class="align-middle text-center">
                                                <span class="text-secondary text-xs font-weight-bold">
                                                    <%= inventory.getImportedDate() != null ? 
                                                        java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")
                                                            .format(inventory.getImportedDate().atZone(java.time.ZoneId.systemDefault()).toLocalDate()) : "N/A" %>
                                                </span>
                                            </td>
                                            <td class="align-middle text-center">
                                                <a href="${pageContext.request.contextPath}/inventory?action=view&id=<%= inventory.getId() %>" 
                                                   class="btn btn-sm btn-outline-primary action-btn me-1"
                                                   title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <button type="button" 
                                                        class="btn btn-sm btn-outline-warning action-btn me-1"
                                                        title="Cập nhật trạng thái"
                                                        onclick="openUpdateModal(<%= inventory.getId() %>)">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/inventory?action=delete&id=<%= inventory.getId() %>" 
                                                   class="btn btn-sm btn-outline-danger action-btn"
                                                   title="Xóa"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                            <% } %>
                                        <% } else { %>
                                        <tr>
                                            <td colspan="6" class="text-center py-5">
                                                <div class="text-center">
                                                    <i class="fas fa-box-open fa-3x text-secondary mb-3"></i>
                                                    <h6 class="text-secondary mb-2">Không có dữ liệu kho hàng</h6>
                                                    <p class="text-sm text-muted">
                                                        <% if (searchKeyword != null && !searchKeyword.isEmpty()) { %>
                                                            Không tìm thấy sản phẩm nào với từ khóa "<%= searchKeyword %>"
                                                        <% } else { %>
                                                            Hãy thêm sản phẩm đầu tiên vào kho
                                                        <% } %>
                                                    </p>
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

    <!-- Update Status Modal -->
    <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateStatusModalLabel">
                        <i class="fas fa-edit me-2"></i>Cập nhật trạng thái kho
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="updateStatusForm" action="inventory" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="inventoryId" id="modalInventoryId">

                        <!-- Product Info -->
                        <div class="alert alert-info d-flex align-items-center mb-4">
                            <i class="fas fa-info-circle me-3 fa-2x"></i>
                            <div>
                                <h6 class="mb-1" id="modalProductName">Tên sản phẩm</h6>
                                <small class="text-muted">
                                    ID: <span id="modalProductId"></span> | 
                                    Số lượng hiện tại: <span id="modalCurrentQuantity"></span>
                                </small>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">
                                <i class="fas fa-tag me-2"></i>Trạng thái mới <span class="text-danger">*</span>
                            </label>
                            <select class="form-select form-select-lg" name="status" id="modalStatus" required>
                                <option value="">-- Chọn trạng thái --</option>
                                <option value="AVAILABLE">
                                    <i class="fas fa-check-circle"></i> Có sẵn
                                </option>
                                <option value="OUT_OF_STOCK">
                                    <i class="fas fa-times-circle"></i> Hết hàng
                                </option>
                            </select>
                            <div class="form-text">
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Chỉ cập nhật trạng thái, các thông tin khác giữ nguyên
                                </small>
                            </div>
                        </div>

                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lưu ý:</strong> Việc thay đổi trạng thái sẽ ảnh hưởng đến khả năng bán hàng của sản phẩm này.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-update text-white">
                            <i class="fas fa-save me-2"></i>Cập nhật trạng thái
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

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
        // Show toast messages
        document.addEventListener('DOMContentLoaded', function() {
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

        // Open update modal
        function openUpdateModal(inventoryId) {
            console.log('Opening modal for inventory ID:', inventoryId);

            var url = window.location.origin + window.location.pathname + '?action=updateStatus&id=' + inventoryId;
            console.log('Fetching URL:', url);

            fetch(url, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(function(response) {
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);

                if (!response.ok) {
                    return response.text().then(function(text) {
                        console.log('Error response text:', text);
                        throw new Error('HTTP error! status: ' + response.status + ', text: ' + text);
                    });
                }
                return response.text();
            })
            .then(function(text) {
                console.log('Raw response text:', text);

                var data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    console.error('JSON parse error:', e);
                    throw new Error('Invalid JSON response: ' + text);
                }

                console.log('Parsed data:', data);

                if (data.error) {
                    alert('Lỗi: ' + data.error);
                    return;
                }

                // Fill modal with data
                document.getElementById('modalInventoryId').value = data.id;
                document.getElementById('modalProductName').textContent = data.productName;
                document.getElementById('modalProductId').textContent = data.productId;
                document.getElementById('modalCurrentQuantity').textContent = data.quantity;
                document.getElementById('modalStatus').value = data.status;

                // Show modal
                var modal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
                modal.show();
            })
            .catch(function(error) {
                console.error('Fetch error:', error);
                alert('Có lỗi xảy ra khi tải dữ liệu: ' + error.message);
            });
        }

        // Form validation - Removed confirm dialog
        document.getElementById('updateStatusForm').addEventListener('submit', function(e) {
            var status = document.getElementById('modalStatus').value;

            if (!status) {
                e.preventDefault();
                alert('Vui lòng chọn trạng thái!');
                return;
            }

            // No confirm dialog needed - modal is already the confirmation
        });
    </script>
</body>
</html>
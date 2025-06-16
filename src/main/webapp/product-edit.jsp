<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xóa sản phẩm - CoreFit Gym Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin: 2rem auto;
            max-width: 600px;
            padding: 2rem;
        }
        .header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .header h1 {
            color: #dc3545;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .header .subtitle {
            color: #666;
            font-size: 1.1rem;
        }
        .product-info {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            border: 2px solid #e9ecef;
        }
        .product-info h4 {
            color: #333;
            margin-bottom: 1rem;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #dee2e6;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #666;
        }
        .info-value {
            color: #333;
            text-align: right;
        }
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-discontinued {
            background-color: #fff3cd;
            color: #856404;
        }
        .warning-box {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            border: 2px solid #ffc107;
            border-radius: 15px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            text-align: center;
        }
        .warning-box i {
            font-size: 3rem;
            color: #f39c12;
            margin-bottom: 1rem;
        }
        .warning-box h5 {
            color: #856404;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .warning-box p {
            color: #856404;
            margin-bottom: 0;
        }
        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #c82333);
            border: none;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(220, 53, 69, 0.3);
        }
        .btn-secondary {
            background: #6c757d;
            border: none;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        .back-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link:hover {
            color: #764ba2;
        }
        .alert {
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-container">
            <div class="header">
                <h1><i class="fas fa-trash-alt me-2"></i>Xóa sản phẩm</h1>
                <p class="subtitle">CoreFit Gym Management System</p>
            </div>

            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/products" class="back-link">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách sản phẩm
                </a>
            </div>

            <!-- Error/Success Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Product Information -->
            <div class="product-info">
                <h4><i class="fas fa-info-circle me-2"></i>Thông tin sản phẩm</h4>
                
                <div class="info-row">
                    <span class="info-label">ID:</span>
                    <span class="info-value">${product.productId}</span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Tên sản phẩm:</span>
                    <span class="info-value">${product.name}</span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Giá:</span>
                    <span class="info-value">${product.price} VNĐ</span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Trạng thái:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${product.status == 'active'}">
                                <span class="status-badge status-active">Hoạt động</span>
                            </c:when>
                            <c:when test="${product.status == 'inactive'}">
                                <span class="status-badge status-inactive">Không hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-discontinued">Ngừng kinh doanh</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                
                <c:if test="${not empty product.description}">
                    <div class="info-row">
                        <span class="info-label">Mô tả:</span>
                        <span class="info-value">${product.description}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty product.createdAt}">
                    <div class="info-row">
                        <span class="info-label">Ngày tạo:</span>
                        <span class="info-value">${product.createdAt}</span>
                    </div>
                </c:if>
            </div>

            <!-- Warning Box -->
            <div class="warning-box">
                <i class="fas fa-exclamation-triangle"></i>
                <h5>Cảnh báo!</h5>
                <p>Hành động này không thể hoàn tác. Sản phẩm sẽ bị xóa vĩnh viễn khỏi hệ thống.</p>
            </div>

            <!-- Delete Confirmation Form -->
            <form id="deleteProductForm" method="post" action="${pageContext.request.contextPath}/products/${product.productId}">
                <input type="hidden" name="_method" value="DELETE">
                
                <div class="d-flex gap-3 justify-content-center">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Hủy
                    </a>
                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal">
                        <i class="fas fa-trash-alt me-2"></i>Xác nhận xóa
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 15px;">
                <div class="modal-header" style="border-bottom: 2px solid #dee2e6;">
                    <h5 class="modal-title text-danger" id="confirmDeleteModalLabel">
                        <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa sản phẩm
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <p class="mb-3">Bạn có chắc chắn muốn xóa sản phẩm:</p>
                    <h6 class="text-primary">"${product.name}"</h6>
                    <p class="text-muted mt-3">Hành động này không thể hoàn tác!</p>
                </div>
                <div class="modal-footer justify-content-center" style="border-top: 2px solid #dee2e6;">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">
                        <i class="fas fa-trash-alt me-2"></i>Xóa sản phẩm
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            const productId = ${product.productId};
            
            fetch(`${pageContext.request.contextPath}/products/${productId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => {
                if (response.ok) {
                    // Close modal
                    const modal = bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal'));
                    modal.hide();
                    
                    // Show success message
                    const alertDiv = document.createElement('div');
                    alertDiv.className = 'alert alert-success alert-dismissible fade show';
                    alertDiv.innerHTML = `
                        <i class="fas fa-check-circle me-2"></i>Xóa sản phẩm thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    `;
                    document.querySelector('.main-container').insertBefore(alertDiv, document.querySelector('.product-info'));
                    
                    // Redirect after 2 seconds
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/products';
                    }, 2000);
                } else {
                    return response.json().then(err => Promise.reject(err));
                }
            })
            .catch(error => {
                // Close modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal'));
                modal.hide();
                
                // Show error message
                const alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-danger alert-dismissible fade show';
                alertDiv.innerHTML = `
                    <i class="fas fa-exclamation-triangle me-2"></i>${error.error || 'Có lỗi xảy ra khi xóa sản phẩm'}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;
                document.querySelector('.main-container').insertBefore(alertDiv, document.querySelector('.product-info'));
            });
        });
    </script>
</body>
</html>
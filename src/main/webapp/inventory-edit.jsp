<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Models.Inventory" %>
<%@ page import="Models.Product" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Cập nhật số lượng tồn kho</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
</head>
<body class="container py-4">

<h1>Cập nhật số lượng tồn kho</h1>

<c:if test="${not empty sessionScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% session.removeAttribute("errorMessage"); %>
</c:if>

<div class="card">
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/inventory">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="productId" value="${product.id}">
            
            <div class="mb-3">
                <label class="form-label">Sản phẩm</label>
                <input type="text" class="form-control" value="${product.name}" readonly>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Số lượng hiện tại</label>
                <input type="text" class="form-control" value="${inventory.quantity}" readonly>
            </div>
            
            <div class="mb-3">
                <label for="quantity" class="form-label">Số lượng mới *</label>
                <input type="number" id="quantity" name="quantity" class="form-control" min="0" value="${inventory.quantity}" required>
            </div>
            
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
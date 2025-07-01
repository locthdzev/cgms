<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Product" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Nhập hàng mới</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
</head>
<body class="container py-4">

<h1>Nhập hàng mới</h1>

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
            <input type="hidden" name="action" value="add">
            
            <div class="mb-3">
                <label for="productId" class="form-label">Sản phẩm *</label>
                <select id="productId" name="productId" class="form-select" required>
                    <option value="">-- Chọn sản phẩm --</option>
                    <c:forEach items="${products}" var="product">
                        <option value="${product.id}">${product.name}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="mb-3">
                <label for="quantity" class="form-label">Số lượng nhập *</label>
                <input type="number" id="quantity" name="quantity" class="form-control" min="1" required>
            </div>
            
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">Nhập hàng</button>
                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${voucher.id == null ? "Create Voucher" : "Edit Voucher"}</title>
</head>
<body>
<h2>${voucher.id == null ? "Create Voucher" : "Edit Voucher"}</h2>

<c:if test="${not empty error}">
    <p style="color: red">${error}</p>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/admin/voucher">
    <!-- Chỉ gửi ID khi chỉnh sửa -->
    <c:if test="${voucher.id != null}">
        <input type="hidden" name="id" value="${voucher.id}" />
    </c:if>

    Code: <input type="text" name="code" value="${voucher.code}" required/><br/>
    Discount Value: <input type="number" step="0.01" name="discountValue" value="${voucher.discountValue}" required/><br/>
    Discount Type: 
    <select name="discountType" required>
        <option value="">-- Select --</option>
        <option value="Percent" ${voucher.discountType == 'Percent' ? 'selected' : ''}>Percent</option>
        <option value="Amount" ${voucher.discountType == 'Amount' ? 'selected' : ''}>Amount</option>
    </select><br/>

    Min Purchase: <input type="number" step="0.01" name="minPurchase" value="${voucher.minPurchase}" /><br/>
    Expiry Date: <input type="date" name="expiryDate" value="${voucher.expiryDate}" required/><br/>
    Status:
    <select name="status" required>
        <option value="Active" ${voucher.status == 'Active' ? 'selected' : ''}>Active</option>
        <option value="Inactive" ${voucher.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
    </select><br/>

    <input type="submit" value="Save"/>
</form>

<a href="${pageContext.request.contextPath}/admin/voucher">Back to list</a>
</body>
</html>

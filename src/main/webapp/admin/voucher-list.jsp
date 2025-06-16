<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Voucher List</title>
</head>
<body>
<h2>Voucher List</h2>
<a href="${pageContext.request.contextPath}/admin/voucher?action=create">Create New Voucher</a>
<table border="1">
    <tr>
        <th>ID</th>
        <th>Code</th>
        <th>Discount</th>
        <th>Type</th>
        <th>Min Purchase</th>
        <th>Expiry</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    <c:forEach var="v" items="${voucherList}">
        <tr>
            <td>${v.id}</td>
            <td>${v.code}</td>
            <td>${v.discountValue}</td>
            <td>${v.discountType}</td>
            <td>${v.minPurchase}</td>
            <td>${v.expiryDate}</td>
            <td>${v.status}</td>
            <td>
                <a href="${pageContext.request.contextPath}/admin/voucher?action=edit&id=${v.id}">Edit</a> |
                <a href="${pageContext.request.contextPath}/admin/voucher?action=delete&id=${v.id}" onclick="return confirm('Are you sure?')">Delete</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>

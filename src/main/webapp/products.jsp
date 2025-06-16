<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Product" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Product List</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
</head>
<body class="container py-4">

<h1>Product List</h1>

<a href="product-form.jsp" class="btn btn-success mb-3">+ Add New Product</a>

<table class="table table-bordered">
    <thead>
    <tr>
        <th>ID</th><th>Name</th><th>Price</th><th>Status</th><th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${products}" var="p">
        <tr>
            <td>${p.productId}</td>
            <td>${p.name}</td>
            <td>${p.price}</td>
            <td>${p.status}</td>
            <td>
                <a href="products/${p.productId}" class="btn btn-sm btn-info">View</a>
                <a href="product-edit.jsp?id=${p.productId}" class="btn btn-sm btn-warning">Edit</a>
                <form action="products/${p.productId}" method="post" style="display:inline;" onsubmit="return confirm('Delete this product?')">
                    <input type="hidden" name="_method" value="delete"/>
                    <button class="btn btn-sm btn-danger">Delete</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>

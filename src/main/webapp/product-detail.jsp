<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="Models.Product" %>
<%
    Product product = (Product) request.getAttribute("product");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Product Detail</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
</head>
<body class="container py-4">

<h2>Product Detail</h2>

<% if (product != null) { %>
    <table class="table table-bordered">
        <tr><th>ID</th><td><%=product.getProductId()%></td></tr>
        <tr><th>Name</th><td><%=product.getName()%></td></tr>
        <tr><th>Description</th><td><%=product.getDescription()%></td></tr>
        <tr><th>Price</th><td><%=product.getPrice()%></td></tr>
        <tr><th>Status</th><td><%=product.getStatus()%></td></tr>
        <tr><th>Created At</th><td><%=product.getCreatedAt()%></td></tr>
        <tr><th>Updated At</th><td><%=product.getUpdatedAt()%></td></tr>
    </table>
    <a href="../products" class="btn btn-secondary">Back to List</a>
<% } else { %>
    <div class="alert alert-danger">Product not found.</div>
<% } %>

</body>
</html>

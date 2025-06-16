<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Product" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Browse Products</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
</head>
<body class="container py-4">

<h2>All Products</h2>

<table class="table table-striped">
    <thead>
    <tr>
        <th>Name</th><th>Price</th><th>Status</th><th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        if (products != null) {
            for (Product p : products) {
    %>
    <tr>
        <td><%= p.getName() %></td>
        <td><%= p.getPrice() %> $</td>
        <td><%= p.getStatus() %></td>
        <td>
            <a href="products/<%= p.getProductId() %>" class="btn btn-info btn-sm">View</a>
            <form action="cart" method="post" style="display:inline;">
                <input type="hidden" name="productId" value="<%= p.getProductId() %>"/>
                <input type="hidden" name="action" value="add"/>
                <button class="btn btn-sm btn-success">Add to Cart</button>
            </form>
            <form action="cart" method="post" style="display:inline;">
                <input type="hidden" name="productId" value="<%= p.getProductId() %>"/>
                <input type="hidden" name="action" value="buy"/>
                <button class="btn btn-sm btn-primary">Buy Now</button>
            </form>
        </td>
    </tr>
    <%
            }
        }
    %>
    </tbody>
</table>

</body>
</html>

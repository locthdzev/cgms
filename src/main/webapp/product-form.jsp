<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Product</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
</head>
<body class="container py-4">
<h2>Create New Product</h2>

<form action="products" method="post">
    <div class="mb-3">
        <label>Name *</label>
        <input type="text" name="name" required class="form-control"/>
    </div>
    <div class="mb-3">
        <label>Description</label>
        <textarea name="description" class="form-control"></textarea>
    </div>
    <div class="mb-3">
        <label>Price *</label>
        <input type="number" name="price" step="0.01" required class="form-control"/>
    </div>
    <div class="mb-3">
        <label>Status *</label>
        <select name="status" class="form-select">
            <option value="ACTIVE">ACTIVE</option>
            <option value="INACTIVE">INACTIVE</option>
            <option value="OUT_OF_STOCK">OUT_OF_STOCK</option>
        </select>
    </div>
    <button class="btn btn-primary">Save</button>
    <a href="products" class="btn btn-secondary">Cancel</a>
</form>
</body>
<a href="../java/Controllers/ProductControllers.java"></a>
</html>

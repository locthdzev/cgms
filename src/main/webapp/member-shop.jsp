<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Product" %>
<%@page import="Services.ProductService" %>
<%@page import="Models.User" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList"%>


<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"Member".equals(loggedInUser.getRole())) {
        response.sendRedirect("login");
        return;
    }

    ProductService productService = new ProductService();
    List<Product> allProducts = productService.getAllProducts();
List<Product> products = new ArrayList<>();
for (Product product : allProducts) {
    if ("Active".equalsIgnoreCase(product.getStatus())) {
        products.add(product);
    }
}


    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) session.removeAttribute("successMessage");

    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Cửa hàng - CGMS</title>
        <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <style>
            .main-content {
                margin-left: 260px;
                transition: margin-left 0.3s;
            }
            .card {
                border: none;
                border-radius: 1rem;
                box-shadow: 0 8px 24px 0 rgba(0,0,0,0.07);
                overflow: hidden;
                background: #fff;
                height: 100%;
                display: flex;
                flex-direction: column;
                transition: box-shadow 0.18s;
            }
            .product-img-wrap {
                background: #f7fafc;
                border-bottom: 1px solid #e9ecef;
                padding: 18px 12px 14px 12px;
                text-align: center;
                min-height: 160px;
                max-height: 160px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: none;
            }
            .product-img {
                width: 120px;
                height: 120px;
                object-fit: contain;
                border-radius: 18px;
                background: #fff;
                box-shadow: 0 1px 6px 0 rgba(60,60,60,0.07);
                display: block;
                margin: 0 auto;
                border: 1px solid #f1f3f4;
            }
            .info-label {
                font-weight: bold;
                color: #495057;
                letter-spacing: 0.5px;
                margin-right: 5px;
                font-size: 0.97rem;
            }
            .product-title {
                font-size: 1.09rem;
                font-weight: bold;
                color: #23272b;
                letter-spacing: 1px;
                margin-bottom: 2px;
                text-transform: none;
                display: inline;
            }
            .product-desc {
                font-size: 0.97rem;
                color: #7b8a99;
                font-weight: 500;
                display: inline;
            }
            .product-price {
                font-weight: bold;
                color: #dc3545;
                font-size: 1.08rem;
                display: inline;
            }
            .card-body {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                flex: 1;
            }
            .card-action-group {
                margin-top: auto;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            @media (max-width: 991.98px) {
                main.main-content {
                    margin-left: 0;
                }
            }
        </style>
    </head>
    <body class="g-sidenav-show bg-gray-100">
        <div class="min-height-300 bg-dark position-absolute w-100"></div>

        <!-- Toast -->
        <div class="toast-container position-fixed top-0 end-0 p-3">
            <% if (successMessage != null) { %>
            <div class="toast align-items-center text-white bg-success border-0" id="successToast" role="alert">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-check-circle me-2"></i><%= successMessage %>
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
            <% } %>
            <% if (errorMessage != null) { %>
            <div class="toast align-items-center text-white bg-danger border-0" id="errorToast" role="alert">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-exclamation-circle me-2"></i><%= errorMessage %>
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
            <% } %>
        </div>
        <%@ include file="member_sidebar.jsp" %>
        <main class="main-content position-relative border-radius-lg">
            <jsp:include page="navbar.jsp">
                <jsp:param name="pageTitle" value="Cửa hàng"/>
                <jsp:param name="parentPage" value="Dashboard"/>
                <jsp:param name="parentPageUrl" value="member-dashboard"/>
                <jsp:param name="currentPage" value="Cửa hàng"/>
            </jsp:include>

            <div class="container-fluid py-4">
                <div class="card mb-4">
                    <div class="card-header pb-0">
                        <h6 class="mb-0">
                            <i class="fas fa-dumbbell me-2"></i>Sản phẩm của phòng Gym
                        </h6>
                    </div>
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                        <% for (Product p : products) { %>
                        <div class="col">
                            <div class="card h-100">
                                <div class="product-img-wrap">
                                    <img src="<%= p.getImageUrl() != null ? p.getImageUrl() : "assets/img/no-image.png" %>" class="product-img" alt="Product">
                                </div>
                                <div class="card-body">
                                    <div>
                                        <div class="mb-1">
                                            <span class="info-label">Tên sản phẩm:</span>
                                            <span class="product-title"><%= p.getName() %></span>
                                        </div>
                                        <div class="mb-1">
                                            <span class="info-label">Mô tả:</span>
                                            <span class="product-desc"><%= p.getDescription() %></span>
                                        </div>
                                        <div class="mb-2">
                                            <span class="info-label">Giá:</span>
                                            <span class="product-price"><%= String.format("%,d", p.getPrice().longValue()) %> VNĐ</span>
                                        </div>
                                    </div>
                                    <div class="card-action-group">
                                        <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#productModal<%= p.getId() %>">
                                            <i class="fas fa-eye me-1"></i>Xem chi tiết
                                        </button>
                                        <a href="member-cart?action=add&id=<%= p.getId() %>" class="btn btn-sm btn-primary">
                                            <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Modal Chi Tiết -->
                        <div class="modal fade" id="productModal<%= p.getId() %>" tabindex="-1">
                            <div class="modal-dialog modal-lg modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title"><%= p.getName() %></h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body row">
                                        <div class="col-md-6">
                                            <img src="<%= p.getImageUrl() != null ? p.getImageUrl() : "assets/img/no-image.png" %>" class="img-fluid rounded shadow-sm" />
                                        </div>
                                        <div class="col-md-6">
                                            <p><span class="info-label">TÊN SẢN PHẨM:</span> <span class="product-title"><%= p.getName() %></span></p>
                                            <p><span class="info-label">MÔ TẢ:</span> <span class="product-desc"><%= p.getDescription() %></span></p>
                                            <p><span class="info-label">GIÁ:</span> <span class="product-price"><%= String.format("%,d", p.getPrice().longValue()) %> VNĐ</span></p>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                        <a href="member-cart?action=add&id=<%= p.getId() %>" class="btn btn-primary">
                                            <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <footer class="footer pt-3">
                <div class="container-fluid">
                    <div class="row align-items-center justify-content-lg-between">
                        <div class="col-lg-6 mb-lg-0 mb-4">
                            <div class="text-muted text-sm text-center text-lg-start">
                                © <script>document.write(new Date().getFullYear())</script>, CoreFit Gym Management System
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
        </main>

        <!-- Scripts -->
        <script src="assets/js/core/bootstrap.bundle.min.js"></script>
        <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
        <script>
                                    document.addEventListener('DOMContentLoaded', () => {
                                        if (document.getElementById('successToast'))
                                            new bootstrap.Toast('#successToast').show();
                                        if (document.getElementById('errorToast'))
                                            new bootstrap.Toast('#errorToast').show();
                                    });
        </script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Product" %>
<%@page import="Services.ProductService" %>
<%@page import="Models.User" %>
<%@page import="java.util.List" %>
<%@ include file="member_sidebar.jsp" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"Member".equals(loggedInUser.getRole())) {
        response.sendRedirect("login");
        return;
    }

    ProductService productService = new ProductService();
    List<Product> products = productService.getAllProducts();

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
            .product-img {
                height: 180px;
                object-fit: cover;
                border-radius: 0.375rem;
                width: 100%;
            }
            .card-body p, .card-body h5 {
                margin-bottom: 0.5rem;
            }
            .card {
                border: 1px solid #e9ecef;
                transition: transform 0.2s ease-in-out;
            }
            .card:hover {
                transform: scale(1.01);
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            main.main-content {
                margin-left: 250px;
                padding: 2rem 1rem;
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

        <main class="main-content position-relative border-radius-lg">
            <jsp:include page="navbar.jsp">
                <jsp:param name="pageTitle" value="Cửa hàng"/>
                <jsp:param name="parentPage" value="Dashboard"/>
                <jsp:param name="parentPageUrl" value="member-dashboard"/>
                <jsp:param name="currentPage" value="Cửa hàng"/>
            </jsp:include>

            <div class="container-fluid py-4">
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                    <% for (Product p : products) { %>
                    <div class="col">
                        <div class="card h-100">
                            <img src="<%= p.getImageUrl() != null ? p.getImageUrl() : "assets/img/no-image.png" %>" class="product-img" alt="Product">
                            <div class="card-body d-flex flex-column justify-content-between">
                                <div>
                                    <h5 class="card-title"><%= p.getName() %></h5>
                                    <p class="text-muted text-truncate"><%= p.getDescription() %></p>
                                    <p class="fw-bold text-dark mb-2">Giá: <%= p.getPrice() %> VNĐ</p>
                                </div>
                                <button class="btn btn-sm btn-outline-primary mt-auto" data-bs-toggle="modal" data-bs-target="#productModal<%= p.getId() %>">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </button>
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
                                        <p><strong>Tên sản phẩm:</strong> <%= p.getName() %></p>
                                        <p><strong>Mô tả:</strong> <%= p.getDescription() %></p>
                                        <p><strong>Giá:</strong> <%= p.getPrice() %> VNĐ</p>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    <a href="member-cart?action=add&id=<%= p.getId() %>" class="btn btn-primary">
                                        <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                                    </a>

                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
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
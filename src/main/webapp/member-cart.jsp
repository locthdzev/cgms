<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%@page import="Models.Cart"%>
<%@page import="java.util.List"%>
<%@ include file="member_sidebar.jsp" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"Member".equals(loggedInUser.getRole())) {
        response.sendRedirect("login");
        return;
    }

    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");

    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) session.removeAttribute("successMessage");

    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng - CGMS</title>
        <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <style>
            .product-img {
                height: 180px;
                object-fit: cover;
                border-radius: 0.375rem;
                width: 100%;
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
                <jsp:param name="pageTitle" value="Giỏ hàng"/>
                <jsp:param name="parentPage" value="Dashboard"/>
                <jsp:param name="parentPageUrl" value="member-dashboard"/>
                <jsp:param name="currentPage" value="Giỏ hàng"/>
            </jsp:include>

            <div class="container-fluid py-4">
                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                    <% for (Cart c : cartItems) { %>
                    <div class="col">
                        <div class="card h-100">
                            <img src="<%= c.getProduct().getImageUrl() != null ? c.getProduct().getImageUrl() : "assets/img/no-image.png" %>"
                                 class="product-img" alt="Product">
                            <div class="card-body d-flex flex-column justify-content-between">
                                <div>
                                    <h5 class="card-title"><%= c.getProduct().getName() %></h5>
                                    <p class="text-muted text-truncate"><%= c.getProduct().getDescription() %></p>
                                    <p class="fw-bold text-dark mb-1">Giá: <%= c.getProduct().getPrice() %> VNĐ</p>
                                    <p class="mb-2">Số lượng: <%= c.getQuantity() %></p>
                                </div>
                                <a href="member-cart?action=remove&id=<%= c.getId() %>" class="btn btn-sm btn-outline-danger mt-auto">
                                    <i class="fas fa-trash me-1"></i>Xoá
                                </a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="alert alert-info text-center">Giỏ hàng của bạn đang trống.</div>
                <% } %>
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

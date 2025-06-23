<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Trang thành viên - CoreFit Gym</title>
  <link href="assets/css/soft-design-system.css?v=1.1.0" rel="stylesheet" />
</head>
<body>
  <%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
      response.sendRedirect("login");
      return;
    }
  %>
  
  <div class="container py-5">
    <div class="row">
      <div class="col-12">
        <div class="card mb-4">
          <div class="card-header pb-0">
            <h6>Chào mừng, <%= loggedInUser.getFullName() %></h6>
          </div>
          <div class="card-body px-0 pt-0 pb-2">
            <div class="p-4">
              <p>Chào mừng bạn đến với CoreFit Gym Management System!</p>
              <p>Email: <%= loggedInUser.getEmail() %></p>
              <p>Vai trò: <%= loggedInUser.getRole() %></p>
              <p>Trạng thái: <%= loggedInUser.getStatus() %></p>
              
              <div class="mt-4">
                <a href="logout" class="btn btn-danger">Đăng xuất</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <script src="assets/js/core/popper.min.js"></script>
  <script src="assets/js/core/bootstrap.min.js"></script>
</body>
</html> 
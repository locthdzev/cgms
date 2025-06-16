<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Vui lòng xác thực email</title>
  <link href="assets/css/soft-design-system.css?v=1.1.0" rel="stylesheet" />
</head>
<body class="sign-in-illustration">
  <section>
    <div class="page-header min-vh-100">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-xl-4 col-lg-5 col-md-7 d-flex flex-column mx-lg-0 mx-auto">
            <div class="card card-plain mt-5">
              <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success text-center mt-4" role="alert">
                  <%= request.getAttribute("message") %>
                </div>
                <div class="text-center">
                  <a href="/login" class="btn btn-lg bg-gradient-primary w-100 mt-4 mb-0">Đăng nhập</a>
                </div>
              <% } else if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger text-center mt-4" role="alert">
                  <%= request.getAttribute("error") %>
                </div>
                <div class="text-center">
                  <a href="/login" class="btn btn-lg bg-gradient-primary w-100 mt-4 mb-0">Quay lại đăng nhập</a>
                </div>
              <% } else { %>
                <div class="card-header pb-0 text-center">
                  <h4 class="font-weight-bolder">Vui lòng xác thực email</h4>
                  <p class="mb-0">Chúng tôi đã gửi một email xác thực đến địa chỉ bạn vừa đăng ký.<br>Hãy kiểm tra email và nhấn vào liên kết xác thực để hoàn tất đăng ký.</p>
                </div>
                <div class="card-body text-center">
                  <a href="/login" class="btn btn-lg bg-gradient-primary w-100 mt-4 mb-0">Quay lại trang đăng nhập</a>
                </div>
              <% } %>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</body>
</html> 
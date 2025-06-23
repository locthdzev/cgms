<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <link
      rel="apple-touch-icon"
      sizes="76x76"
      href="assets/img/apple-icon.png"
    />
    <link rel="icon" type="image/png" href="assets/img/favicon.png" />
    <title>Đặt lại mật khẩu - CoreFit Gym Management System</title>
    <!-- Fonts and icons -->
    <link
      href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,800"
      rel="stylesheet"
    />
    <link href="assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
    <script
      src="https://kit.fontawesome.com/42d5adcbca.js"
      crossorigin="anonymous"
    ></script>
    <!-- CSS Files -->
    <link
      id="pagestyle"
      href="assets/css/soft-design-system.css"
      rel="stylesheet"
    />
    <style>
      .password-container {
        position: relative;
      }
      .password-toggle {
        position: absolute;
        top: 50%;
        right: 15px;
        transform: translateY(-50%);
        cursor: pointer;
        color: #aaa;
        width: 24px;
        height: 24px;
      }
      .password-toggle:hover {
        color: #333;
      }
      .password-toggle img {
        width: 100%;
        height: 100%;
      }
    </style>
  </head>
  <body class="sign-in-illustration">
    <section>
      <div class="page-header min-vh-100">
        <div class="container">
          <div class="row">
            <div
              class="col-xl-4 col-lg-5 col-md-7 d-flex flex-column mx-lg-0 mx-auto"
            >
              <div class="card card-plain">
                <div class="card-header pb-0 text-left">
                  <h4 class="font-weight-bolder">Đặt lại mật khẩu</h4>
                  <p class="mb-0">
                    Nhập mật khẩu mới cho tài khoản của bạn
                  </p>
                </div>
                <div class="card-body pb-3">
                  <% if (request.getAttribute("success") != null) { %>
                  <div class="alert alert-success text-white" role="alert">
                    <%= request.getAttribute("success") %>
                  </div>
                  <div class="text-center">
                    <a href="/login" class="btn btn-lg bg-gradient-primary w-100 mt-4 mb-0">Đăng nhập</a>
                  </div>
                  <% } else if (request.getAttribute("error") != null) { %>
                  <div class="alert alert-danger text-white" role="alert">
                    <%= request.getAttribute("error") %>
                  </div>
                  <div class="text-center">
                    <a href="/forgot-password" class="btn btn-lg bg-gradient-primary w-100 mt-4 mb-0">Yêu cầu đặt lại mật khẩu mới</a>
                  </div>
                  <% } else { %>
                  <form role="form" method="post" action="/reset-password" onsubmit="return validateForm()">
                    <input type="hidden" name="token" value="<%= request.getParameter("token") %>" />
                    <div class="mb-3 password-container">
                      <input
                        type="password"
                        name="password"
                        id="password"
                        class="form-control form-control-lg"
                        placeholder="Mật khẩu mới"
                        aria-label="Password"
                        required
                        minlength="6"
                      />
                      <span class="password-toggle" onclick="togglePassword('password')">
                        <img src="assets/svg/eye-show-svgrepo-com.svg" id="password-toggle-icon" alt="Show/Hide Password">
                      </span>
                    </div>
                    <div class="mb-3 password-container">
                      <input
                        type="password"
                        name="confirmPassword"
                        id="confirmPassword"
                        class="form-control form-control-lg"
                        placeholder="Xác nhận mật khẩu mới"
                        aria-label="Confirm Password"
                        required
                        minlength="6"
                      />
                      <span class="password-toggle" onclick="togglePassword('confirmPassword')">
                        <img src="assets/svg/eye-show-svgrepo-com.svg" id="confirmPassword-toggle-icon" alt="Show/Hide Password">
                      </span>
                    </div>
                    <div class="text-center">
                      <button
                        type="submit"
                        class="btn btn-lg bg-gradient-primary btn-lg w-100 mt-4 mb-0"
                      >
                        Đặt lại mật khẩu
                      </button>
                    </div>
                  </form>
                  <% } %>
                </div>
                <div class="card-footer text-center pt-0 px-lg-2 px-1">
                  <p class="mb-4 text-sm mx-auto">
                    <a
                      href="/login"
                      class="text-primary text-gradient font-weight-bold"
                      >Quay lại đăng nhập</a
                    >
                  </p>
                </div>
              </div>
            </div>
            <div
              class="col-6 d-lg-flex d-none h-100 my-auto pe-0 position-absolute top-0 end-0 text-center justify-content-center flex-column"
            >
              <div
                class="position-relative bg-gradient-primary h-100 m-3 px-7 border-radius-lg d-flex flex-column justify-content-center"
              >
                <img
                  src="assets/img/shapes/pattern-lines.svg"
                  alt="pattern-lines"
                  class="position-absolute opacity-4 start-0"
                />
                <div class="position-relative">
                  <img
                    class="max-width-500 w-100 position-relative z-index-2"
                    src="assets/img/illustrations/chat.png"
                    alt="chat-img"
                  />
                </div>
                <h4 class="mt-5 text-white font-weight-bolder">
                  CoreFit Gym Management System
                </h4>
                <p class="text-white">
                  Hệ thống quản lý phòng tập thể hình hiện đại
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Core JS Files -->
    <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
    <script
      src="assets/js/core/bootstrap.min.js"
      type="text/javascript"
    ></script>
    <script>
      function validateForm() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;
        
        if (password !== confirmPassword) {
          alert("Mật khẩu xác nhận không khớp với mật khẩu mới!");
          return false;
        }
        
        return true;
      }
      
      function togglePassword(inputId) {
        const passwordInput = document.getElementById(inputId);
        const toggleIcon = document.getElementById(inputId + '-toggle-icon');
        
        if (passwordInput.type === 'password') {
          passwordInput.type = 'text';
          toggleIcon.src = 'assets/svg/eye-off-svgrepo-com.svg';
        } else {
          passwordInput.type = 'password';
          toggleIcon.src = 'assets/svg/eye-show-svgrepo-com.svg';
        }
      }
    </script>
  </body>
</html> 
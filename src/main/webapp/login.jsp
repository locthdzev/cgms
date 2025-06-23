<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@ page
import="Utilities.ConfigUtil" %>
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
    <title>Đăng nhập - CoreFit Gym Management System</title>
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
    <!-- Google Sign-In API -->
    <script src="https://accounts.google.com/gsi/client" async defer></script>
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
                  <h4 class="font-weight-bolder">Đăng nhập</h4>
                  <p class="mb-0">
                    Nhập tên đăng nhập và mật khẩu để đăng nhập
                  </p>
                </div>
                <div class="card-body pb-3">
                  <% if (request.getAttribute("error") != null) { %>
                  <div class="alert alert-danger text-white" role="alert">
                    <%= request.getAttribute("error") %>
                  </div>
                  <% } %>
                  <form role="form" method="post" action="/login">
                    <div class="mb-3">
                      <input
                        type="text"
                        name="username"
                        class="form-control form-control-lg"
                        placeholder="Tên đăng nhập"
                        aria-label="Username"
                        aria-describedby="username-addon"
                        value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                        required
                      />
                    </div>
                    <div class="mb-3 password-container">
                      <input
                        type="password"
                        name="password"
                        id="password"
                        class="form-control form-control-lg"
                        placeholder="Mật khẩu"
                        aria-label="Password"
                        aria-describedby="password-addon"
                        required
                      />
                      <span class="password-toggle" onclick="togglePassword('password')">
                        <img src="assets/svg/eye-show-svgrepo-com.svg" id="password-toggle-icon" alt="Show/Hide Password">
                      </span>
                    </div>
                    <div class="form-check form-switch">
                      <input
                        class="form-check-input"
                        type="checkbox"
                        id="rememberMe"
                        checked
                      />
                      <label class="form-check-label" for="rememberMe"
                        >Ghi nhớ đăng nhập</label
                      >
                    </div>
                    <div class="text-center">
                      <button
                        type="submit"
                        class="btn btn-lg bg-gradient-primary btn-lg w-100 mt-4 mb-0"
                      >
                        Đăng nhập
                      </button>
                    </div>
                  </form>

                  <div class="text-center mt-3">
                    <p class="text-sm">Hoặc đăng nhập với</p>
                    <div
                      id="g_id_onload"
                      data-client_id="<%= ConfigUtil.getGoogleClientId() %>"
                      data-login_uri="http://localhost:8080/GoogleLoginController"
                      data-auto_prompt="false"
                    ></div>
                    <div
                      class="g_id_signin"
                      data-type="standard"
                      data-size="large"
                      data-theme="outline"
                      data-text="sign_in_with"
                      data-shape="rectangular"
                      data-logo_alignment="center"
                      data-width="100%"
                    ></div>
                  </div>
                </div>
                <div class="card-footer text-center pt-0 px-lg-2 px-1">
                  <p class="mb-2 text-sm mx-auto">
                    Chưa có tài khoản?
                    <a
                      href="/register"
                      class="text-primary text-gradient font-weight-bold"
                      >Đăng ký</a
                    >
                  </p>
                  <p class="mb-4 text-sm mx-auto">
                    <a
                      href="/forgot-password"
                      class="text-primary text-gradient font-weight-bold"
                      >Quên mật khẩu?</a
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

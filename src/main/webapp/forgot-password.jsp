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
    <title>Quên mật khẩu - CoreFit Gym Management System</title>
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
                  <h4 class="font-weight-bolder">Quên mật khẩu</h4>
                  <p class="mb-0">
                    Nhập tên đăng nhập hoặc email để lấy lại mật khẩu
                  </p>
                </div>
                <div class="card-body pb-3">
                  <% if (request.getAttribute("success") != null) { %>
                  <div class="alert alert-success text-white" role="alert">
                    <%= request.getAttribute("success") %>
                  </div>
                  <div class="text-center">
                    <a href="/login" class="btn btn-lg bg-gradient-primary w-100 mt-4 mb-0">Quay lại đăng nhập</a>
                  </div>
                  <% } else if (request.getAttribute("error") != null) { %>
                  <div class="alert alert-danger text-white" role="alert">
                    <%= request.getAttribute("error") %>
                  </div>
                  <form role="form" method="post" action="ForgotPasswordController">
                    <div class="mb-3">
                      <input
                        type="text"
                        name="usernameOrEmail"
                        class="form-control form-control-lg"
                        placeholder="Tên đăng nhập hoặc Email"
                        aria-label="Username or Email"
                        required
                      />
                    </div>
                    <div class="text-center">
                      <button
                        type="submit"
                        class="btn btn-lg bg-gradient-primary btn-lg w-100 mt-4 mb-0"
                      >
                        Gửi yêu cầu đặt lại mật khẩu
                      </button>
                    </div>
                  </form>
                  <% } else { %>
                  <form role="form" method="post" action="ForgotPasswordController">
                    <div class="mb-3">
                      <input
                        type="text"
                        name="usernameOrEmail"
                        class="form-control form-control-lg"
                        placeholder="Tên đăng nhập hoặc Email"
                        aria-label="Username or Email"
                        required
                      />
                    </div>
                    <div class="text-center">
                      <button
                        type="submit"
                        class="btn btn-lg bg-gradient-primary btn-lg w-100 mt-4 mb-0"
                      >
                        Gửi yêu cầu đặt lại mật khẩu
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
  </body>
</html> 
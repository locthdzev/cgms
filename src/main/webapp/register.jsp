<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Đăng ký tài khoản</title>
  <link href="assets/css/soft-design-system.css?v=1.1.0" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,800" rel="stylesheet" />
  <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
</head>
<body class="sign-in-illustration">
  <section>
    <div class="page-header min-vh-100">
      <div class="container">
        <div class="row">
          <div class="col-xl-4 col-lg-5 col-md-7 d-flex flex-column mx-lg-0 mx-auto">
            <div class="card card-plain">
              <div class="card-header pb-0 text-left">
                <h4 class="font-weight-bolder">Đăng ký tài khoản</h4>
                <p class="mb-0">Vui lòng nhập thông tin để đăng ký</p>
              </div>
              <div class="card-body">
                <form role="form" method="post" action="register">
                  <div class="mb-3">
                    <input type="text" class="form-control form-control-lg" placeholder="Họ tên" name="fullname" required>
                  </div>
                  <div class="mb-3">
                    <input type="email" class="form-control form-control-lg" placeholder="Email" name="email" required>
                  </div>
                  <div class="mb-3">
                    <input type="password" class="form-control form-control-lg" placeholder="Mật khẩu" name="password" required>
                  </div>
                  <div class="mb-3">
                    <input type="password" class="form-control form-control-lg" placeholder="Xác nhận mật khẩu" name="confirmPassword" required>
                  </div>
                  <div class="text-center">
                    <button type="submit" class="btn btn-lg bg-gradient-primary btn-lg w-100 mt-4 mb-0">Đăng ký</button>
                  </div>
                </form>
              </div>
              <div class="card-footer text-center pt-0 px-lg-2 px-1">
                <p class="mb-4 text-sm mx-auto">
                  Đã có tài khoản?
                  <a href="/login" class="text-primary text-gradient font-weight-bold">Đăng nhập</a>
                </p>
              </div>
            </div>
          </div>
          <div class="col-6 d-lg-flex d-none h-100 my-auto pe-0 position-absolute top-0 end-0 text-center justify-content-center flex-column">
            <div class="position-relative bg-gradient-primary h-100 m-3 px-7 border-radius-lg d-flex flex-column justify-content-center">
              <img src="assets/img/shapes/pattern-lines.svg" alt="pattern-lines" class="position-absolute opacity-4 start-0">
              <div class="position-relative">
                <img class="max-width-500 w-100 position-relative z-index-2" src="assets/img/illustrations/chat.png">
              </div>
              <h4 class="mt-5 text-white font-weight-bolder">"Fitness is not a destination, it is a way of life"</h4>
              <p class="text-white">Hãy bắt đầu hành trình tập luyện của bạn ngay hôm nay!</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
  <script src="assets/js/core/bootstrap.min.js" type="text/javascript"></script>
  <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
  <script src="assets/js/plugins/parallax.min.js"></script>
  <script src="assets/js/soft-design-system.min.js?v=1.1.0" type="text/javascript"></script>
</body>
</html> 
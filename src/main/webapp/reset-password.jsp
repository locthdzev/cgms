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
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
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
      .password-strength-meter {
        height: 5px;
        background-color: #f3f3f3;
        margin: 10px 0;
        border-radius: 3px;
      }
      .password-strength-meter-bar {
        height: 100%;
        border-radius: 3px;
        transition: width 0.5s ease-in-out, background-color 0.5s ease-in-out;
      }
      .password-strength-text {
        font-size: 12px;
        margin-top: 5px;
        font-weight: 600;
      }
      .strength-weak {
        background-color: #ff4d4d;
        width: 25%;
      }
      .strength-medium {
        background-color: #ffa500;
        width: 50%;
      }
      .strength-strong {
        background-color: #2dce89;
        width: 75%;
      }
      .strength-very-strong {
        background-color: #2dce89;
        width: 100%;
      }
      .password-requirements {
        font-size: 12px;
        color: #8392ab;
        margin-top: 5px;
      }
      .requirement-met {
        color: #2dce89;
      }
      .requirement-not-met {
        color: #f5365c;
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
                  <p class="mb-0">Nhập mật khẩu mới cho tài khoản của bạn</p>
                </div>
                <div class="card-body pb-3">
                  <% if (request.getAttribute("success") != null) { %>
                  <div class="alert alert-success text-white" role="alert">
                    <%= request.getAttribute("success") %>
                  </div>
                  <% } else if (request.getAttribute("error") != null) { %>
                  <div class="alert alert-danger text-white" role="alert">
                    <%= request.getAttribute("error") %>
                  </div>
                  <% } else { %>
                  <form
                    role="form"
                    method="post"
                    action="/reset-password"
                    onsubmit="return validateForm()"
                  >
                    <input type="hidden" name="token" value="<%=
                    request.getParameter("token") %>" />
                    <input
                      type="hidden"
                      name="oldPassword"
                      id="oldPassword"
                      value=""
                    />
                    <div class="mb-3 password-container">
                      <input
                        type="password"
                        name="password"
                        id="password"
                        class="form-control form-control-lg"
                        placeholder="Mật khẩu mới"
                        aria-label="Password"
                        required
                        minlength="8"
                        maxlength="32"
                        oninput="checkPasswordStrength()"
                      />
                      <span
                        class="password-toggle"
                        onclick="togglePassword('password')"
                      >
                        <img
                          src="assets/svg/eye-show-svgrepo-com.svg"
                          id="password-toggle-icon"
                          alt="Show/Hide Password"
                        />
                      </span>
                    </div>
                    <div class="password-strength-meter">
                      <div
                        id="password-strength-meter-bar"
                        class="password-strength-meter-bar"
                      ></div>
                    </div>
                    <div
                      id="password-strength-text"
                      class="password-strength-text"
                    ></div>
                    <div class="password-requirements">
                      <div id="length-check" class="requirement-not-met">
                        ✓ 8-32 ký tự
                      </div>
                      <div id="uppercase-check" class="requirement-not-met">
                        ✓ Ít nhất 1 chữ cái viết hoa
                      </div>
                      <div id="special-check" class="requirement-not-met">
                        ✓ Ít nhất 1 ký tự đặc biệt
                      </div>
                    </div>
                    <div class="mb-3 password-container mt-3">
                      <input
                        type="password"
                        name="confirmPassword"
                        id="confirmPassword"
                        class="form-control form-control-lg"
                        placeholder="Xác nhận mật khẩu mới"
                        aria-label="Confirm Password"
                        required
                        minlength="8"
                        maxlength="32"
                      />
                      <span
                        class="password-toggle"
                        onclick="togglePassword('confirmPassword')"
                      >
                        <img
                          src="assets/svg/eye-show-svgrepo-com.svg"
                          id="confirmPassword-toggle-icon"
                          alt="Show/Hide Password"
                        />
                      </span>
                    </div>
                    <div
                      id="password-match"
                      class="password-requirements mb-3"
                    ></div>
                    <div class="text-center">
                      <button
                        type="submit"
                        class="btn btn-lg bg-gradient-primary btn-lg w-100 mt-4 mb-0"
                        id="submit-button"
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
                class="position-relative h-100 m-3 border-radius-lg d-flex flex-column justify-content-center"
                style="
                  background: url('assets/img/login-bg-gym.jpg');
                  background-size: cover;
                  background-position: center;
                  background-repeat: no-repeat;
                "
              ></div>
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
        var oldPasswordValue = document.getElementById("oldPassword").value;

        // Kiểm tra mật khẩu mới có trùng với mật khẩu cũ không
        if (oldPasswordValue && password === oldPasswordValue) {
          alert("Mật khẩu mới không được trùng với mật khẩu cũ!");
          return false;
        }

        // Kiểm tra độ dài mật khẩu
        if (password.length < 8 || password.length > 32) {
          alert("Mật khẩu phải có độ dài từ 8 đến 32 ký tự!");
          return false;
        }

        // Kiểm tra có chữ hoa
        if (!/[A-Z]/.test(password)) {
          alert("Mật khẩu phải chứa ít nhất 1 chữ cái viết hoa!");
          return false;
        }

        // Kiểm tra có ký tự đặc biệt
        if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
          alert("Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt!");
          return false;
        }

        // Kiểm tra mật khẩu xác nhận
        if (password !== confirmPassword) {
          alert("Mật khẩu xác nhận không khớp với mật khẩu mới!");
          return false;
        }

        return true;
      }

      function togglePassword(inputId) {
        const passwordInput = document.getElementById(inputId);
        const toggleIcon = document.getElementById(inputId + "-toggle-icon");

        if (passwordInput.type === "password") {
          passwordInput.type = "text";
          toggleIcon.src = "assets/svg/eye-off-svgrepo-com.svg";
        } else {
          passwordInput.type = "password";
          toggleIcon.src = "assets/svg/eye-show-svgrepo-com.svg";
        }
      }

      function checkPasswordStrength() {
        const password = document.getElementById("password").value;
        const confirmPassword =
          document.getElementById("confirmPassword").value;
        const strengthMeter = document.getElementById(
          "password-strength-meter-bar"
        );
        const strengthText = document.getElementById("password-strength-text");
        const lengthCheck = document.getElementById("length-check");
        const uppercaseCheck = document.getElementById("uppercase-check");
        const specialCheck = document.getElementById("special-check");
        const passwordMatch = document.getElementById("password-match");

        // Kiểm tra độ dài
        if (password.length >= 8 && password.length <= 32) {
          lengthCheck.className = "requirement-met";
        } else {
          lengthCheck.className = "requirement-not-met";
        }

        // Kiểm tra chữ hoa
        if (/[A-Z]/.test(password)) {
          uppercaseCheck.className = "requirement-met";
        } else {
          uppercaseCheck.className = "requirement-not-met";
        }

        // Kiểm tra ký tự đặc biệt
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
          specialCheck.className = "requirement-met";
        } else {
          specialCheck.className = "requirement-not-met";
        }

        // Kiểm tra mật khẩu xác nhận
        if (confirmPassword) {
          if (password === confirmPassword) {
            passwordMatch.innerHTML = "✓ Mật khẩu xác nhận khớp";
            passwordMatch.className = "requirement-met";
          } else {
            passwordMatch.innerHTML = "✗ Mật khẩu xác nhận không khớp";
            passwordMatch.className = "requirement-not-met";
          }
        }

        // Tính điểm mật khẩu
        let strength = 0;

        // Độ dài cơ bản
        if (password.length >= 8) strength += 1;
        if (password.length >= 12) strength += 1;

        // Có chữ hoa
        if (/[A-Z]/.test(password)) strength += 1;

        // Có chữ thường
        if (/[a-z]/.test(password)) strength += 1;

        // Có số
        if (/[0-9]/.test(password)) strength += 1;

        // Có ký tự đặc biệt
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password))
          strength += 1;

        // Hiển thị độ mạnh
        strengthMeter.className = "password-strength-meter-bar";

        if (password.length === 0) {
          strengthMeter.className += " strength-weak";
          strengthMeter.style.width = "0%";
          strengthText.textContent = "";
        } else if (strength < 3) {
          strengthMeter.className += " strength-weak";
          strengthText.textContent = "Yếu";
          strengthText.style.color = "#ff4d4d";
        } else if (strength < 5) {
          strengthMeter.className += " strength-medium";
          strengthText.textContent = "Trung bình";
          strengthText.style.color = "#ffa500";
        } else if (strength < 6) {
          strengthMeter.className += " strength-strong";
          strengthText.textContent = "Mạnh";
          strengthText.style.color = "#2dce89";
        } else {
          strengthMeter.className += " strength-very-strong";
          strengthText.textContent = "Rất mạnh";
          strengthText.style.color = "#2dce89";
        }

        // Kiểm tra nút submit
        const submitButton = document.getElementById("submit-button");
        if (
          lengthCheck.className === "requirement-met" &&
          uppercaseCheck.className === "requirement-met" &&
          specialCheck.className === "requirement-met"
        ) {
          submitButton.disabled = false;
        } else {
          submitButton.disabled = true;
        }
      }

      // Kiểm tra khi nhập xác nhận mật khẩu
      document
        .getElementById("confirmPassword")
        .addEventListener("input", function () {
          checkPasswordStrength();
        });

      // Khởi tạo
      window.onload = function () {
        // Các hành động khởi tạo khác nếu cần
      };
    </script>
  </body>
</html>

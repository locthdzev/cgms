<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@page
import="Models.User"%> <% // Lấy thông tin người dùng đăng nhập từ session User
loggedInUser = (User) session.getAttribute("loggedInUser"); %>
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
      href="assets/img/icons8-gym-96.png"
    />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
    <title>CORE-FIT GYM</title>
    <link
      href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700"
      rel="stylesheet"
    />
    <link
      href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css"
      rel="stylesheet"
    />
    <link
      href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css"
      rel="stylesheet"
    />
    <script
      src="https://kit.fontawesome.com/42d5adcbca.js"
      crossorigin="anonymous"
    ></script>
    <link
      id="pagestyle"
      href="./assets/css/argon-dashboard.css?v=2.1.0"
      rel="stylesheet"
    />
    <style>
      .user-welcome {
        text-align: right;
        margin-left: auto;
      }
      .user-welcome .user-name {
        font-weight: 600;
        color: white;
        font-size: 1rem;
        margin-bottom: 0;
      }
      .user-welcome .user-email {
        color: rgba(255, 255, 255, 0.8);
        font-size: 0.875rem;
      }
      .password-strength {
        margin-top: 5px;
        height: 5px;
        border-radius: 5px;
      }
      .password-strength-text {
        font-size: 0.8rem;
        margin-top: 5px;
      }
      .very-weak {
        background-color: #dc3545;
        width: 20%;
      }
      .weak {
        background-color: #ffc107;
        width: 40%;
      }
      .medium {
        background-color: #fd7e14;
        width: 60%;
      }
      .strong {
        background-color: #20c997;
        width: 80%;
      }
      .very-strong {
        background-color: #198754;
        width: 100%;
      }
      .image-preview {
        max-width: 300px;
        max-height: 200px;
        display: none;
        margin-top: 10px;
      }
    </style>
  </head>
  <body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <!-- Include Sidebar Component -->
    <%@ include file="sidebar.jsp" %>

    <main class="main-content position-relative border-radius-lg">
      <!-- Include Navbar Component with parameters -->
      <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Thêm Personal Trainer mới" />
        <jsp:param name="parentPage" value="Danh sách Personal Trainer" />
        <jsp:param name="parentPageUrl" value="trainer" />
        <jsp:param name="currentPage" value="Thêm Personal Trainer mới" />
      </jsp:include>

      <div class="container-fluid py-4">
        <div class="row">
          <div class="col-12">
            <div class="card mb-4">
              <div
                class="card-header pb-0 d-flex justify-content-between align-items-center"
              >
                <h6>Thêm Personal Trainer mới</h6>
                <div>
                  <a
                    href="trainer"
                    class="btn btn-outline-secondary btn-sm me-2"
                  >
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                  </a>
                  <a href="addUser" class="btn btn-info btn-sm">
                    <i class="fas fa-plus me-2"></i>Thêm Member
                  </a>
                </div>
              </div>
              <div class="card-body">
                <% if (request.getAttribute("errorMessage") != null) { %>
                <div
                  class="alert alert-danger alert-dismissible fade show"
                  role="alert"
                >
                  <i class="fas fa-exclamation-circle me-2"></i> <%=
                  request.getAttribute("errorMessage") %>
                  <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert"
                    aria-label="Close"
                  ></button>
                </div>
                <% } %>
                <form
                  method="post"
                  id="addTrainerForm"
                  onsubmit="return validateForm()"
                  enctype="multipart/form-data"
                >
                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Email *</label>
                      <input
                        type="email"
                        name="email"
                        class="form-control"
                        required
                      />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Tên đăng nhập *</label>
                      <input
                        type="text"
                        name="userName"
                        class="form-control"
                        required
                      />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Họ tên *</label>
                      <input
                        type="text"
                        name="fullName"
                        class="form-control"
                        required
                      />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Số điện thoại</label>
                      <input
                        type="text"
                        name="phoneNumber"
                        class="form-control"
                      />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Địa chỉ</label>
                      <input type="text" name="address" class="form-control" />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Giới tính</label>
                      <select name="gender" class="form-control">
                        <option value="Nam">Nam</option>
                        <option value="Nữ">Nữ</option>
                      </select>
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Zalo</label>
                      <input type="text" name="zalo" class="form-control" />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Facebook</label>
                      <input type="text" name="facebook" class="form-control" />
                    </div>
                    <div class="col-md-12 mb-3">
                      <label class="form-label">Kinh nghiệm</label>
                      <textarea
                        name="experience"
                        class="form-control"
                        rows="3"
                      ></textarea>
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Ảnh chứng chỉ</label>
                      <input
                        type="file"
                        name="certificateImage"
                        class="form-control"
                        accept="image/*"
                        onchange="previewCertificateImage(this)"
                      />
                      <small class="text-muted"
                        >Chấp nhận các file hình ảnh (JPG, PNG, GIF). Tối đa
                        10MB.</small
                      >
                      <div>
                        <img
                          id="certificateImagePreview"
                          class="image-preview"
                          alt="Certificate Preview"
                        />
                      </div>
                    </div>
                    <input type="hidden" name="role" value="Personal Trainer" />
                    <input type="hidden" name="status" value="Active" />
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Ngày sinh</label>
                      <input type="date" name="dob" class="form-control" />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Mật khẩu *</label>
                      <input
                        type="password"
                        name="password"
                        id="password"
                        class="form-control"
                        required
                      />
                      <div class="password-strength mt-2"></div>
                      <div class="password-strength-text text-sm"></div>
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Xác nhận mật khẩu *</label>
                      <input
                        type="password"
                        name="confirmPassword"
                        id="confirmPassword"
                        class="form-control"
                        required
                      />
                      <div class="invalid-feedback">
                        Mật khẩu xác nhận không khớp
                      </div>
                    </div>
                  </div>
                  <div class="d-flex justify-content-end mt-4">
                    <button type="reset" class="btn btn-light me-2">
                      Làm mới
                    </button>
                    <button class="btn btn-primary" type="submit">Lưu</button>
                    <a href="trainer" class="btn btn-secondary ms-2"
                      >Quay lại</a
                    >
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
    <script src="assets/js/core/popper.min.js" type="text/javascript"></script>
    <script
      src="assets/js/core/bootstrap.min.js"
      type="text/javascript"
    ></script>
    <script
      src="assets/js/plugins/perfect-scrollbar.min.js"
      type="text/javascript"
    ></script>
    <script
      src="assets/js/plugins/smooth-scrollbar.min.js"
      type="text/javascript"
    ></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
    <script>
      // Kiểm tra độ mạnh mật khẩu
      document
        .getElementById("password")
        .addEventListener("input", function () {
          const password = this.value;
          const strengthBar = document.querySelector(".password-strength");
          const strengthText = document.querySelector(
            ".password-strength-text"
          );

          // Xóa tất cả các class
          strengthBar.className = "password-strength";

          // Kiểm tra độ mạnh
          let strength = 0;
          if (password.length >= 8) strength += 1;
          if (password.match(/[a-z]+/)) strength += 1;
          if (password.match(/[A-Z]+/)) strength += 1;
          if (password.match(/[0-9]+/)) strength += 1;
          if (password.match(/[^a-zA-Z0-9]+/)) strength += 1;

          // Hiển thị kết quả
          switch (strength) {
            case 0:
              strengthBar.classList.add("very-weak");
              strengthText.textContent = "Rất yếu";
              strengthText.style.color = "#dc3545";
              break;
            case 1:
              strengthBar.classList.add("very-weak");
              strengthText.textContent = "Rất yếu";
              strengthText.style.color = "#dc3545";
              break;
            case 2:
              strengthBar.classList.add("weak");
              strengthText.textContent = "Yếu";
              strengthText.style.color = "#ffc107";
              break;
            case 3:
              strengthBar.classList.add("medium");
              strengthText.textContent = "Trung bình";
              strengthText.style.color = "#fd7e14";
              break;
            case 4:
              strengthBar.classList.add("strong");
              strengthText.textContent = "Mạnh";
              strengthText.style.color = "#20c997";
              break;
            case 5:
              strengthBar.classList.add("very-strong");
              strengthText.textContent = "Rất mạnh";
              strengthText.style.color = "#198754";
              break;
          }
        });

      // Kiểm tra xác nhận mật khẩu
      document
        .getElementById("confirmPassword")
        .addEventListener("input", function () {
          const password = document.getElementById("password").value;
          const confirmPassword = this.value;

          if (password !== confirmPassword) {
            this.classList.add("is-invalid");
          } else {
            this.classList.remove("is-invalid");
          }
        });

      // Kiểm tra form trước khi submit
      function validateForm() {
        const password = document.getElementById("password").value;
        const confirmPassword =
          document.getElementById("confirmPassword").value;
        const strengthText = document.querySelector(
          ".password-strength-text"
        ).textContent;

        if (password !== confirmPassword) {
          alert("Mật khẩu xác nhận không khớp!");
          return false;
        }

        if (strengthText === "Rất yếu" || strengthText === "Yếu") {
          alert("Mật khẩu quá yếu! Vui lòng chọn mật khẩu mạnh hơn.");
          return false;
        }

        return true;
      }

      function previewCertificateImage(input) {
        var preview = document.getElementById("certificateImagePreview");
        if (input.files && input.files[0]) {
          var reader = new FileReader();
          reader.onload = function (e) {
            preview.src = e.target.result;
            preview.style.display = "block";
          };
          reader.readAsDataURL(input.files[0]);
        } else {
          preview.style.display = "none";
        }
      }
    </script>
  </body>
</html>

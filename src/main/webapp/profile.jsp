<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%@page import="Models.MemberPackage"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="DAOs.PackageDAO"%>
<%@page import="Models.Package"%>
<%
    // Lấy thông tin người dùng đăng nhập từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
    // Lấy thông tin người dùng hiển thị hồ sơ (có thể chính là người đăng nhập)
    User profileUser = (User) request.getAttribute("user");
    if (profileUser == null) {
        profileUser = loggedInUser;
    }
    
    // Lấy danh sách gói tập của thành viên
    List<MemberPackage> memberPackages = (List<MemberPackage>) request.getAttribute("memberPackages");
    boolean hasMemberPackages = memberPackages != null && !memberPackages.isEmpty();
    
    // Lấy thông báo từ request hoặc session
    String successMessage = (String) request.getAttribute("successMessage");
    if (successMessage == null) {
        successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            session.removeAttribute("successMessage");
        }
    }
    
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) {
        errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
            session.removeAttribute("errorMessage");
        }
    }
    
    boolean hasSuccessMessage = successMessage != null;
    boolean hasErrorMessage = errorMessage != null;
    
    // Định dạng ngày tháng
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
    // Kiểm tra xem gói tập hiện tại có phải là gói cao nhất không
    boolean isHighestTierPackage = false;
    if (hasMemberPackages) {
        // Lấy tất cả các gói tập đang hoạt động từ database
        PackageDAO packageDAO = new PackageDAO();
        List<Package> allActivePackages = packageDAO.getActivePackages();
        
        // Tìm gói tập có giá cao nhất và thời hạn dài nhất
        BigDecimal highestPrice = BigDecimal.ZERO;
        int longestDuration = 0;
        
        if (allActivePackages != null) {
            for (Package pkg : allActivePackages) {
                if (pkg.getPrice().compareTo(highestPrice) > 0) {
                    highestPrice = pkg.getPrice();
                }
                if (pkg.getDuration() > longestDuration) {
                    longestDuration = pkg.getDuration();
                }
            }
        }
        
        // Kiểm tra xem gói tập hiện tại có phải là gói cao nhất không
        for (MemberPackage memberPackage : memberPackages) {
            if ("ACTIVE".equals(memberPackage.getStatus())) {
                if (memberPackage.getPackageField().getPrice().compareTo(highestPrice) >= 0 || 
                    memberPackage.getPackageField().getDuration() >= longestDuration) {
                    isHighestTierPackage = true;
                    break;
                }
            }
        }
    }
%>
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
      href="assets/img/weightlifting.png"
    />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png" />
    <title>Hồ sơ cá nhân - CGMS</title>
    <!--     Fonts and icons     -->
    <link
      href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700"
      rel="stylesheet"
    />
    <!-- Nucleo Icons -->
    <link
      href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css"
      rel="stylesheet"
    />
    <link
      href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css"
      rel="stylesheet"
    />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <!-- CSS Files -->
    <link
      id="pagestyle"
      href="assets/css/argon-dashboard.css?v=2.1.0"
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

      /* Toast styles */
      .toast-container {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
      }

      .toast {
        min-width: 300px;
      }

      /* Adjust profile card spacing */
      .card-profile-bottom {
        margin-top: 10px !important;
        position: relative;
        z-index: 1;
      }

      /* Adjust container padding */
      .container-fluid {
        padding-top: 1rem !important;
      }
      
      /* Password styles */
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

  <body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <!-- Toast Container -->
    <div class="toast-container">
      <% if (hasSuccessMessage) { %>
      <div
        class="toast align-items-center text-white bg-success border-0"
        role="alert"
        aria-live="assertive"
        aria-atomic="true"
        id="successToast"
      >
        <div class="d-flex">
          <div class="toast-body">
            <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
          </div>
          <button
            type="button"
            class="btn-close btn-close-white me-2 m-auto"
            data-bs-dismiss="toast"
            aria-label="Close"
          ></button>
        </div>
      </div>
      <% } %>
      <% if (hasErrorMessage) { %>
      <div
        class="toast align-items-center text-white bg-danger border-0"
        role="alert"
        aria-live="assertive"
        aria-atomic="true"
        id="errorToast"
      >
        <div class="d-flex">
          <div class="toast-body">
            <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
          </div>
          <button
            type="button"
            class="btn-close btn-close-white me-2 m-auto"
            data-bs-dismiss="toast"
            aria-label="Close"
          ></button>
        </div>
      </div>
      <% } %>
    </div>

    <% if (loggedInUser != null && "Personal Trainer".equals(loggedInUser.getRole())) { %>
    <%@ include file="pt_sidebar.jsp" %>
    <% } else if (loggedInUser != null && "Member".equals(loggedInUser.getRole())) { %>
    <%@ include file="member_sidebar.jsp" %>
    <% } else { %>
    <%@ include file="sidebar.jsp" %>
    <% } %>
    <main
      class="main-content position-relative max-height-vh-100 h-100 border-radius-lg"
    >
      <!-- Navbar -->
      <jsp:include page="navbar.jsp">
        <jsp:param name="pageTitle" value="Hồ sơ cá nhân" />
        <jsp:param name="parentPage" value="Pages" />
        <jsp:param name="currentPage" value="Profile" />
      </jsp:include>
      <!-- End Navbar -->
      <div class="card shadow-lg mx-4 mt-2 card-profile-bottom">
        <div class="card-body p-3">
          <div class="row gx-4">
            <div class="col-auto">
              <div class="avatar avatar-xl position-relative">
                <img
                  src="assets/svg/user-37448.svg"
                  alt="profile_image"
                  class="w-100 border-radius-lg shadow-sm"
                />
              </div>
            </div>
            <div class="col-auto my-auto">
              <div class="h-100">
                <h5 class="mb-1"><%= profileUser.getFullName() %></h5>
                <p class="mb-0 font-weight-bold text-sm">
                  <%= profileUser.getRole() %>
                </p>
              </div>
            </div>
            <div
              class="col-lg-4 col-md-6 my-sm-auto ms-sm-auto me-sm-0 mx-auto mt-3"
            >
              <div class="nav-wrapper position-relative end-0">
                <ul class="nav nav-pills nav-fill p-1" role="tablist">
<%--                  <li class="nav-item">--%>
<%--                    <a--%>
<%--                      class="nav-link mb-0 px-0 py-1 active d-flex align-items-center justify-content-center"--%>
<%--                      data-bs-toggle="tab"--%>
<%--                      href="javascript:;"--%>
<%--                      role="tab"--%>
<%--                      aria-selected="true"--%>
<%--                    >--%>
<%--                      <i class="ni ni-app"></i>--%>
<%--                      <span class="ms-2">App</span>--%>
<%--                    </a>--%>
<%--                  </li>--%>
<%--                  <li class="nav-item">--%>
<%--                    <a--%>
<%--                      class="nav-link mb-0 px-0 py-1 d-flex align-items-center justify-content-center"--%>
<%--                      data-bs-toggle="tab"--%>
<%--                      href="javascript:;"--%>
<%--                      role="tab"--%>
<%--                      aria-selected="false"--%>
<%--                    >--%>
<%--                      <i class="ni ni-email-83"></i>--%>
<%--                      <span class="ms-2">Messages</span>--%>
<%--                    </a>--%>
<%--                  </li>--%>
                  <li class="nav-item">
                    <a
                      class="nav-link mb-0 px-0 py-1 d-flex align-items-center justify-content-center"
                      data-bs-toggle="tab"
                      href="javascript:;"
                      role="tab"
                      aria-selected="false"
                    >
                      <i class="ni ni-settings-gear-65"></i>
                      <span class="ms-2">Settings</span>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="container-fluid py-4">
        <div class="row">
          <div class="col-md-8">
            <div class="card">
              <div class="card-header pb-0">
                <div class="d-flex align-items-center">
                  <p class="mb-0">Chỉnh sửa hồ sơ</p>
                  <button type="submit" form="updateProfileForm" class="btn btn-primary btn-sm ms-auto">
                    Lưu thay đổi
                  </button>
                </div>
              </div>
              <div class="card-body">
                <form id="updateProfileForm" action="ProfileController" method="post" enctype="multipart/form-data">
                <p class="text-uppercase text-sm">Thông tin người dùng</p>
                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-control-label">Tên đăng nhập</label>
                      <input
                        class="form-control"
                        type="text"
                        name="userName"
                        value="<%= profileUser.getUserName() %>"
                      />
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-control-label">Email</label>
                      <input
                        class="form-control"
                        type="email"
                        name="email"
                        value="<%= profileUser.getEmail() %>"
                      />
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-control-label">Họ tên</label>
                      <input
                        class="form-control"
                        type="text"
                        name="fullName"
                        value="<%= profileUser.getFullName() %>"
                      />
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-control-label">Số điện thoại</label>
                      <input 
                        class="form-control" 
                        type="text" 
                        name="phoneNumber"
                        value="<%= profileUser.getPhoneNumber() != null ? profileUser.getPhoneNumber() : "" %>" 
                      />
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-control-label">Giới tính</label>
                      <select name="gender" class="form-control">
                        <option value="" <%= profileUser.getGender() == null || profileUser.getGender().isEmpty() ? "selected" : "" %>>Chọn giới tính</option>
                        <option value="Nam" <%= "Nam".equals(profileUser.getGender()) ? "selected" : "" %>>Nam</option>
                        <option value="Nữ" <%= "Nữ".equals(profileUser.getGender()) ? "selected" : "" %>>Nữ</option>
                        <option value="Khác" <%= "Khác".equals(profileUser.getGender()) ? "selected" : "" %>>Khác</option>
                      </select>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-control-label">Ngày sinh</label>
                      <input 
                        class="form-control" 
                        type="date" 
                        name="dob"
                        value="<%= profileUser.getDob() != null ? profileUser.getDob().toString() : "" %>" 
                      />
                    </div>
                  </div>
                </div>
                <hr class="horizontal dark" />
                <p class="text-uppercase text-sm">Thông tin liên hệ</p>
                <div class="row">
                  <div class="col-md-12">
                    <div class="form-group">
                      <label class="form-control-label">Địa chỉ</label>
                      <input 
                        class="form-control" 
                        type="text" 
                        name="address"
                        value="<%= profileUser.getAddress() != null ? profileUser.getAddress() : "" %>" 
                      />
                    </div>
                  </div>
                  <% if (request.getAttribute("isPersonalTrainer") != null && (Boolean)request.getAttribute("isPersonalTrainer")) { %>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-control-label">Zalo</label>
                      <input
                        class="form-control"
                        type="text"
                        name="zalo"
                        value="<%= profileUser.getZalo() != null ? profileUser.getZalo() : "" %>"
                      />
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-control-label">Facebook</label>
                      <input
                        class="form-control"
                        type="text"
                        name="facebook"
                        value="<%= profileUser.getFacebook() != null ? profileUser.getFacebook() : "" %>"
                      />
                    </div>
                  </div>
                  <% } %>
                </div>
                
                <% if (request.getAttribute("isPersonalTrainer") != null && (Boolean)request.getAttribute("isPersonalTrainer")) { %>
                <hr class="horizontal dark" />
                <p class="text-uppercase text-sm">Thông tin chuyên môn</p>
                <div class="row">
                  <div class="col-md-12">
                    <div class="form-group">
                      <label class="form-control-label">Kinh nghiệm</label>
                      <textarea
                        class="form-control"
                        name="experience"
                        rows="3"
                      ><%= profileUser.getExperience() != null ? profileUser.getExperience() : "" %></textarea>
                    </div>
                  </div>
                  <div class="col-md-12">
                    <div class="form-group">
                      <label class="form-control-label">Chứng chỉ</label>
                      <input
                        class="form-control"
                        type="file"
                        name="certificateImage"
                        accept="image/*"
                        onchange="previewCertificateImage(this)"
                      />
                      <small class="text-muted">Chấp nhận các file hình ảnh (JPG, PNG, GIF). Tối đa 10MB.</small>
                    </div>
                  </div>
                  <% if (profileUser.getCertificateImageUrl() != null && !profileUser.getCertificateImageUrl().isEmpty()) { %>
                  <div class="col-md-12 mt-3">
                    <label class="form-control-label">Chứng chỉ hiện tại</label>
                    <div>
                      <img src="<%= profileUser.getCertificateImageUrl() %>" alt="Certificate" class="img-fluid" style="max-width: 300px; max-height: 200px; border-radius: 8px;" onerror="this.onerror=null; this.src='assets/img/placeholder-image.jpg';">
                    </div>
                  </div>
                  <% } %>
                  <div class="col-md-12 mt-3">
                    <img id="certificateImagePreview" class="img-fluid" style="max-width: 300px; max-height: 200px; border-radius: 8px; display: none;" alt="Certificate Preview" />
                  </div>
                </div>
                <% } %>
                </form>
                <hr class="horizontal dark" />
                <p class="text-uppercase text-sm">Đổi mật khẩu</p>
                <form action="ChangePasswordController" method="post" id="changePasswordForm" onsubmit="return validatePasswordForm()">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label class="form-control-label">Mật khẩu hiện tại</label>
                        <div class="password-container">
                          <input class="form-control" type="password" name="currentPassword" id="currentPassword" required />
                          <span class="password-toggle" onclick="togglePassword('currentPassword')">
                            <img src="assets/svg/eye-show-svgrepo-com.svg" id="currentPassword-toggle-icon" alt="Show/Hide Password">
                          </span>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label class="form-control-label">Mật khẩu mới</label>
                        <div class="password-container">
                          <input class="form-control" type="password" name="newPassword" id="newPassword" required minlength="8" maxlength="32" oninput="checkPasswordStrength()" />
                          <span class="password-toggle" onclick="togglePassword('newPassword')">
                            <img src="assets/svg/eye-show-svgrepo-com.svg" id="newPassword-toggle-icon" alt="Show/Hide Password">
                          </span>
                        </div>
                      </div>
                      <div class="password-strength-meter">
                        <div id="password-strength-meter-bar" class="password-strength-meter-bar"></div>
                      </div>
                      <div id="password-strength-text" class="password-strength-text"></div>
                      <div class="password-requirements">
                        <div id="length-check" class="requirement-not-met">✓ 8-32 ký tự</div>
                        <div id="uppercase-check" class="requirement-not-met">✓ Ít nhất 1 chữ cái viết hoa</div>
                        <div id="special-check" class="requirement-not-met">✓ Ít nhất 1 ký tự đặc biệt</div>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="form-group">
                        <label class="form-control-label">Xác nhận mật khẩu mới</label>
                        <div class="password-container">
                          <input class="form-control" type="password" name="confirmPassword" id="confirmPassword" required minlength="8" maxlength="32" />
                          <span class="password-toggle" onclick="togglePassword('confirmPassword')">
                            <img src="assets/svg/eye-show-svgrepo-com.svg" id="confirmPassword-toggle-icon" alt="Show/Hide Password">
                          </span>
                        </div>
                      </div>
                      <div id="password-match" class="password-requirements mb-3"></div>
                    </div>
                    <div class="col-md-12 text-end">
                      <button type="submit" class="btn btn-primary btn-sm" id="submit-button">Đổi mật khẩu</button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card card-profile">
              <img
                src="assets/img/bg-profile.jpg"
                alt="Image placeholder"
                class="card-img-top"
              />
              <div class="row justify-content-center">
                <div class="col-4 col-lg-4 order-lg-2">
                  <div class="mt-n4 mt-lg-n6 mb-4 mb-lg-0">
                    <a href="javascript:;">
                      <img
                        src="assets/svg/user-37448.svg"
                        class="rounded-circle img-fluid border border-2 border-white"
                      />
                    </a>
                  </div>
                </div>
              </div>
              <div class="card-body pt-0">
                <div class="text-center mt-4">
                  <h5><%= profileUser.getFullName() %></h5>
                  <div class="h6 font-weight-300">
                    <i class="fas fa-map-marker-alt me-2"></i>
                    <%= profileUser.getAddress() != null ? profileUser.getAddress() : "Chưa cập nhật địa chỉ" %>
                  </div>
                  <div class="h6 mt-4">
                    <i class="fas fa-envelope me-2"></i>
                    <%= profileUser.getEmail() %>
                  </div>
                  <div>
                    <i class="fas fa-phone me-2"></i>
                    <%= profileUser.getPhoneNumber() != null ? profileUser.getPhoneNumber() : "Chưa cập nhật số điện thoại" %>
                  </div>
                </div>
              </div>
            </div>
            
            <% if (!("Personal Trainer".equals(profileUser.getRole())) && hasMemberPackages) { %>
            <!-- Thông tin gói tập -->
            <div class="card mt-4">
              <div class="card-header pb-0">
                <h6>Gói tập hiện tại của bạn</h6>
                <div class="d-flex justify-content-end">
                  <a href="<%= request.getContextPath() %>/package-history" class="btn btn-sm btn-outline-info">
                    <i class="fas fa-history me-1"></i>Xem lịch sử gói tập
                  </a>
                </div>
              </div>
              <div class="card-body pt-0">
                <h5 class="mb-3">Gói tập hiện tại</h5>
                <% for (MemberPackage memberPackage : memberPackages) { %>
                <% if ("ACTIVE".equals(memberPackage.getStatus())) { %>
                <div class="package-item mb-3 p-3 border rounded">
                  <h5 class="text-gradient text-primary mb-2"><%= memberPackage.getPackageField().getName() %></h5>
                  <div class="d-flex justify-content-between mb-2">
                    <span class="text-sm">Trạng thái:</span>
                    <span class="badge bg-gradient-success">Đang hoạt động</span>
                  </div>
                  <div class="d-flex justify-content-between mb-2">
                    <span class="text-sm">Ngày bắt đầu:</span>
                    <span class="text-sm font-weight-bold"><%= memberPackage.getStartDate().format(dateFormatter) %></span>
                  </div>
                  <div class="d-flex justify-content-between mb-2">
                    <span class="text-sm">Ngày kết thúc:</span>
                    <span class="text-sm font-weight-bold"><%= memberPackage.getEndDate().format(dateFormatter) %></span>
                  </div>
                  <div class="d-flex justify-content-between mb-2">
                    <span class="text-sm">Số buổi tập còn lại:</span>
                    <span class="text-sm font-weight-bold"><%= memberPackage.getRemainingSessions() %> buổi</span>
                  </div>
                  <div class="d-flex justify-content-between mb-2">
                    <span class="text-sm">Giá gói tập:</span>
                    <span class="text-sm font-weight-bold"><%= String.format("%,.0f", memberPackage.getTotalPrice()) %> VNĐ</span>
                  </div>
                  <div class="d-flex justify-content-between">
                    <% if (!isHighestTierPackage) { %>
                    <a href="<%= request.getContextPath() %>/all-packages" class="btn btn-sm btn-outline-primary">Nâng cấp gói tập</a>
                    <% } else { %>
                    <span class="text-sm text-success"><i class="fas fa-crown me-1"></i> Gói cao cấp nhất</span>
                    <% } %>
                    <button type="button" class="btn btn-sm btn-outline-danger" 
                            data-bs-toggle="modal" 
                            data-bs-target="#cancelPackageModal"
                            data-package-id="<%= memberPackage.getId() %>"
                            data-package-name="<%= memberPackage.getPackageField().getName() %>">
                        Hủy gói tập
                    </button>
                </div>
                <% } %>
                <% } %>
                
                <% if (memberPackages.stream().noneMatch(p -> "ACTIVE".equals(p.getStatus()))) { %>
                <div class="text-center py-3">
                  <p class="text-sm mb-3">Bạn chưa có gói tập nào đang hoạt động</p>
                  <a href="<%= request.getContextPath() %>/all-packages" class="btn btn-sm btn-primary">Đăng ký gói tập ngay</a>
                </div>
                <% } %>
              </div>
            </div>
            <% } %>
          </div>
        </div>
        <footer class="footer pt-3">
          <div class="container-fluid">
            <div class="row align-items-center justify-content-lg-between">
              <div class="col-lg-6 mb-lg-0 mb-4">
                <div
                  class="copyright text-center text-sm text-muted text-lg-start"
                >
                  ©
                  <script>
                    document.write(new Date().getFullYear());
                  </script>
                  , CoreFit Gym Management System
                </div>
              </div>
            </div>
          </div>
        </footer>
      </div>
    </main>
    
    <!-- Modal xác nhận hủy gói tập -->
    <div class="modal fade" id="cancelPackageModal" tabindex="-1" aria-labelledby="cancelPackageModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="cancelPackageModalLabel">Xác nhận hủy gói tập</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>Bạn có chắc chắn muốn hủy gói tập <strong id="packageNameToCancel"></strong>?</p>
            <p class="text-danger">Lưu ý: Sau khi hủy gói tập, bạn sẽ không thể sử dụng các dịch vụ của gói tập này nữa.</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            <form action="<%= request.getContextPath() %>/cancel-member-package" method="post">
              <input type="hidden" id="memberPackageIdToCancel" name="memberPackageId" value="">
              <button type="submit" class="btn btn-danger">Xác nhận hủy</button>
            </form>
          </div>
        </div>
      </div>
    </div>
    
    <div class="fixed-plugin">
      <a class="fixed-plugin-button text-dark position-fixed px-3 py-2">
        <i class="fa fa-cog py-2"> </i>
      </a>
      <div class="card shadow-lg">
        <div class="card-header pb-0 pt-3">
          <div class="float-start">
            <h5 class="mt-3 mb-0">Argon Configurator</h5>
            <p>See our dashboard options.</p>
          </div>
          <div class="float-end mt-4">
            <button
              class="btn btn-link text-dark p-0 fixed-plugin-close-button"
            >
              <i class="fa fa-close"></i>
            </button>
          </div>
          <!-- End Toggle Button -->
        </div>
        <hr class="horizontal dark my-1" />
        <div class="card-body pt-sm-3 pt-0 overflow-auto">
          <!-- Sidebar Backgrounds -->
          <div>
            <h6 class="mb-0">Sidebar Colors</h6>
          </div>
          <a href="javascript:void(0)" class="switch-trigger background-color">
            <div class="badge-colors my-2 text-start">
              <span
                class="badge filter bg-gradient-primary active"
                data-color="primary"
                onclick="sidebarColor(this)"
              ></span>
              <span
                class="badge filter bg-gradient-dark"
                data-color="dark"
                onclick="sidebarColor(this)"
              ></span>
              <span
                class="badge filter bg-gradient-info"
                data-color="info"
                onclick="sidebarColor(this)"
              ></span>
              <span
                class="badge filter bg-gradient-success"
                data-color="success"
                onclick="sidebarColor(this)"
              ></span>
              <span
                class="badge filter bg-gradient-warning"
                data-color="warning"
                onclick="sidebarColor(this)"
              ></span>
              <span
                class="badge filter bg-gradient-danger"
                data-color="danger"
                onclick="sidebarColor(this)"
              ></span>
            </div>
          </a>
          <!-- Sidenav Type -->
          <div class="mt-3">
            <h6 class="mb-0">Sidenav Type</h6>
            <p class="text-sm">Choose between 2 different sidenav types.</p>
          </div>
          <div class="d-flex">
            <button
              class="btn bg-gradient-primary w-100 px-3 mb-2 active me-2"
              data-class="bg-white"
              onclick="sidebarType(this)"
            >
              White
            </button>
            <button
              class="btn bg-gradient-primary w-100 px-3 mb-2"
              data-class="bg-default"
              onclick="sidebarType(this)"
            >
              Dark
            </button>
          </div>
          <p class="text-sm d-xl-none d-block mt-2">
            You can change the sidenav type just on desktop view.
          </p>
          <!-- Navbar Fixed -->
          <hr class="horizontal dark my-sm-4" />
          <div class="mt-2 mb-5 d-flex">
            <h6 class="mb-0">Light / Dark</h6>
            <div class="form-check form-switch ps-0 ms-auto my-auto">
              <input
                class="form-check-input mt-1 ms-auto"
                type="checkbox"
                id="dark-version"
                onclick="darkMode(this)"
              />
            </div>
          </div>
          <a
            class="btn bg-gradient-dark w-100"
            href="https://www.creative-tim.com/product/argon-dashboard"
            >Free Download</a
          >
          <a
            class="btn btn-outline-dark w-100"
            href="https://www.creative-tim.com/learning-lab/bootstrap/license/argon-dashboard"
            >View documentation</a
          >
          <div class="w-100 text-center">
            <a
              class="github-button"
              href="https://github.com/creativetimofficial/argon-dashboard"
              data-icon="octicon-star"
              data-size="large"
              data-show-count="true"
              aria-label="Star creativetimofficial/argon-dashboard on GitHub"
              >Star</a
            >
            <h6 class="mt-3">Thank you for sharing!</h6>
            <a
              href="https://twitter.com/intent/tweet?text=Check%20Argon%20Dashboard%20made%20by%20%40CreativeTim%20%23webdesign%20%23dashboard%20%23bootstrap5&amp;url=https%3A%2F%2Fwww.creative-tim.com%2Fproduct%2Fargon-dashboard"
              class="btn btn-dark mb-0 me-2"
              target="_blank"
            >
              <i class="fab fa-twitter me-1" aria-hidden="true"></i> Tweet
            </a>
            <a
              href="https://www.facebook.com/sharer/sharer.php?u=https://www.creative-tim.com/product/argon-dashboard"
              class="btn btn-dark mb-0 me-2"
              target="_blank"
            >
              <i class="fab fa-facebook-square me-1" aria-hidden="true"></i>
              Share
            </a>
          </div>
        </div>
      </div>
    </div>
    <!--   Core JS Files   -->
    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
    <script>
      var win = navigator.platform.indexOf("Win") > -1;
      if (win && document.querySelector("#sidenav-scrollbar")) {
        var options = {
          damping: "0.5",
        };
        Scrollbar.init(document.querySelector("#sidenav-scrollbar"), options);
      }
    </script>
    <!-- Github buttons -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    <!-- Control Center for Soft Dashboard: parallax effects, scripts for the example pages etc -->
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        // Hiển thị toast thông báo nếu có
        if (document.getElementById("successToast")) {
          var successToast = new bootstrap.Toast(
            document.getElementById("successToast"),
            {
              delay: 5000,
              animation: true,
            }
          );
          successToast.show();
        }

        if (document.getElementById("errorToast")) {
          var errorToast = new bootstrap.Toast(
            document.getElementById("errorToast"),
            {
              delay: 5000,
              animation: true,
            }
          );
          errorToast.show();
        }
        
        // Xử lý modal hủy gói tập
        var cancelPackageModal = document.getElementById('cancelPackageModal');
        if (cancelPackageModal) {
          cancelPackageModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var packageId = button.getAttribute('data-package-id');
            var packageName = button.getAttribute('data-package-name');
            
            document.getElementById('memberPackageIdToCancel').value = packageId;
            document.getElementById('packageNameToCancel').textContent = packageName;
          });
        }
      });
      
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
      
      function checkPasswordStrength() {
        const password = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const strengthMeter = document.getElementById('password-strength-meter-bar');
        const strengthText = document.getElementById('password-strength-text');
        const lengthCheck = document.getElementById('length-check');
        const uppercaseCheck = document.getElementById('uppercase-check');
        const specialCheck = document.getElementById('special-check');
        const passwordMatch = document.getElementById('password-match');
        
        // Kiểm tra độ dài
        if (password.length >= 8 && password.length <= 32) {
          lengthCheck.className = 'requirement-met';
        } else {
          lengthCheck.className = 'requirement-not-met';
        }
        
        // Kiểm tra chữ hoa
        if (/[A-Z]/.test(password)) {
          uppercaseCheck.className = 'requirement-met';
        } else {
          uppercaseCheck.className = 'requirement-not-met';
        }
        
        // Kiểm tra ký tự đặc biệt
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
          specialCheck.className = 'requirement-met';
        } else {
          specialCheck.className = 'requirement-not-met';
        }
        
        // Kiểm tra mật khẩu xác nhận
        if (confirmPassword) {
          if (password === confirmPassword) {
            passwordMatch.innerHTML = '✓ Mật khẩu xác nhận khớp';
            passwordMatch.className = 'requirement-met';
          } else {
            passwordMatch.innerHTML = '✗ Mật khẩu xác nhận không khớp';
            passwordMatch.className = 'requirement-not-met';
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
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) strength += 1;
        
        // Hiển thị độ mạnh
        strengthMeter.className = 'password-strength-meter-bar';
        
        if (password.length === 0) {
          strengthMeter.className += ' strength-weak';
          strengthMeter.style.width = '0%';
          strengthText.textContent = '';
        } else if (strength < 3) {
          strengthMeter.className += ' strength-weak';
          strengthText.textContent = 'Yếu';
          strengthText.style.color = '#ff4d4d';
        } else if (strength < 5) {
          strengthMeter.className += ' strength-medium';
          strengthText.textContent = 'Trung bình';
          strengthText.style.color = '#ffa500';
        } else if (strength < 6) {
          strengthMeter.className += ' strength-strong';
          strengthText.textContent = 'Mạnh';
          strengthText.style.color = '#2dce89';
        } else {
          strengthMeter.className += ' strength-very-strong';
          strengthText.textContent = 'Rất mạnh';
          strengthText.style.color = '#2dce89';
        }
        
        // Kiểm tra nút submit
        const submitButton = document.getElementById('submit-button');
        if (lengthCheck.className === 'requirement-met' && 
            uppercaseCheck.className === 'requirement-met' && 
            specialCheck.className === 'requirement-met') {
          submitButton.disabled = false;
        } else {
          submitButton.disabled = true;
        }
      }
      
      // Kiểm tra khi nhập xác nhận mật khẩu
      document.addEventListener('DOMContentLoaded', function() {
        if (document.getElementById('confirmPassword')) {
          document.getElementById('confirmPassword').addEventListener('input', function() {
            checkPasswordStrength();
          });
        }
      });
      
      function validatePasswordForm() {
        const currentPassword = document.getElementById('currentPassword').value;
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        // Kiểm tra mật khẩu hiện tại
        if (!currentPassword) {
          alert('Vui lòng nhập mật khẩu hiện tại!');
          return false;
        }
        
        // Kiểm tra độ dài mật khẩu
        if (newPassword.length < 8 || newPassword.length > 32) {
          alert('Mật khẩu phải có độ dài từ 8 đến 32 ký tự!');
          return false;
        }
        
        // Kiểm tra có chữ hoa
        if (!/[A-Z]/.test(newPassword)) {
          alert('Mật khẩu phải chứa ít nhất 1 chữ cái viết hoa!');
          return false;
        }
        
        // Kiểm tra có ký tự đặc biệt
        if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(newPassword)) {
          alert('Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt!');
          return false;
        }
        
        // Kiểm tra mật khẩu xác nhận
        if (newPassword !== confirmPassword) {
          alert('Mật khẩu xác nhận không khớp với mật khẩu mới!');
          return false;
        }
        
        return true;
      }
    </script>
    <script>
      // Thêm hàm xem trước ảnh chứng chỉ
      function previewCertificateImage(input) {
          var preview = document.getElementById('certificateImagePreview');
          if (input.files && input.files[0]) {
              var reader = new FileReader();
              reader.onload = function(e) {
                  preview.src = e.target.result;
                  preview.style.display = 'block';
              }
              reader.readAsDataURL(input.files[0]);
          } else {
              preview.style.display = 'none';
          }
      }
    </script>
  </body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>
<%
  // Lấy thông tin người dùng từ session
  User loggedInUser = (User) session.getAttribute("loggedInUser");
%>
<!--
=========================================================
* Argon Dashboard 3 - v2.1.0
=========================================================

* Product Page: https://www.creative-tim.com/product/argon-dashboard
* Copyright 2024 Creative Tim (https://www.creative-tim.com)
* Licensed under MIT (https://www.creative-tim.com/license)
* Coded by Creative Tim

=========================================================

* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-->
<!DOCTYPE html>
<html lang="en">
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
  <title>CoreFit Gym Management System</title>
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
    .dashboard-stats-row {
      display: flex;
      flex-wrap: wrap;
    }
    .dashboard-stats-row > [class^="col-"] {
      display: flex;
      flex-direction: column;
    }
    .dashboard-stats-row .card {
      flex: 1 1 100%;
      height: 100%;
      min-height: 160px;
      display: flex;
      flex-direction: column;
      justify-content: stretch;
    }
    .dashboard-stats-row .card-body {
      flex: 1 1 auto;
      display: flex;
      flex-direction: column;
      justify-content: center;
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
    <jsp:param name="pageTitle" value="Dashboard" />
    <jsp:param name="currentPage" value="Dashboard" />
  </jsp:include>

  <div class="container-fluid py-4">
    <div class="row dashboard-stats-row">
      <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
        <div class="card">
          <div class="card-body p-3">
            <div class="row">
              <div class="col-8">
                <div class="numbers">
                  <p class="text-sm mb-0 text-uppercase font-weight-bold">
                    Thành viên đang hoạt động
                  </p>
                  <h5 class="font-weight-bolder">120</h5>
                  <p class="mb-0">
                        <span class="text-success text-sm font-weight-bolder"
                        >+10%</span
                        >
                    so với tháng trước
                  </p>
                </div>
              </div>
              <div class="col-4 text-end">
                <div
                        class="icon icon-shape bg-gradient-primary shadow-primary text-center rounded-circle"
                >
                  <i
                          class="ni ni-money-coins text-lg opacity-10"
                          aria-hidden="true"
                  ></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
        <div class="card">
          <div class="card-body p-3">
            <div class="row">
              <div class="col-8">
                <div class="numbers">
                  <p class="text-sm mb-0 text-uppercase font-weight-bold">
                    Huấn luyện viên
                  </p>
                  <h5 class="font-weight-bolder">15</h5>
                  <p class="mb-0">
                        <span class="text-success text-sm font-weight-bolder"
                        >+1</span
                        >
                    mới trong tháng
                  </p>
                </div>
              </div>
              <div class="col-4 text-end">
                <div
                        class="icon icon-shape bg-gradient-danger shadow-danger text-center rounded-circle"
                >
                  <i
                          class="ni ni-world text-lg opacity-10"
                          aria-hidden="true"
                  ></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
        <div class="card">
          <div class="card-body p-3">
            <div class="row">
              <div class="col-8">
                <div class="numbers">
                  <p class="text-sm mb-0 text-uppercase font-weight-bold">
                    Gói tập đang bán
                  </p>
                  <h5 class="font-weight-bolder">8</h5>
                  <p class="mb-0">
                        <span class="text-danger text-sm font-weight-bolder"
                        >+2</span
                        >
                    gói mới
                  </p>
                </div>
              </div>
              <div class="col-4 text-end">
                <div
                        class="icon icon-shape bg-gradient-success shadow-success text-center rounded-circle"
                >
                  <i
                          class="ni ni-paper-diploma text-lg opacity-10"
                          aria-hidden="true"
                  ></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-sm-6">
        <div class="card">
          <div class="card-body p-3">
            <div class="row">
              <div class="col-8">
                <div class="numbers">
                  <p class="text-sm mb-0 text-uppercase font-weight-bold">
                    Doanh thu tháng này
                  </p>
                  <h5 class="font-weight-bolder">35.000.000đ</h5>
                  <p class="mb-0">
                        <span class="text-success text-sm font-weight-bolder"
                        >+5%</span
                        >
                    so với tháng trước
                  </p>
                </div>
              </div>
              <div class="col-4 text-end">
                <div
                        class="icon icon-shape bg-gradient-warning shadow-warning text-center rounded-circle"
                >
                  <i
                          class="ni ni-cart text-lg opacity-10"
                          aria-hidden="true"
                  ></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="row mt-4">
      <div class="col-lg-7 mb-lg-0 mb-4">
        <div class="card">
          <div class="card-header pb-0 p-3">
            <div class="d-flex justify-content-between">
              <h6 class="mb-2">Thống kê hoạt động thành viên</h6>
            </div>
          </div>
          <div class="card-body p-3">
            <div class="chart">
              <canvas id="member-activity-chart" class="chart-canvas" height="300"></canvas>
            </div>
            <div class="row mt-4">
              <div class="col-6">
                <div class="d-flex align-items-center">
                  <span class="badge badge-sm bg-gradient-primary me-2"></span>
                  <span class="text-xs">Tập luyện cá nhân (40%)</span>
                </div>
                <div class="d-flex align-items-center mt-2">
                  <span class="badge badge-sm bg-gradient-success me-2"></span>
                  <span class="text-xs">Tập luyện nhóm (25%)</span>
                </div>
              </div>
              <div class="col-6">
                <div class="d-flex align-items-center">
                  <span class="badge badge-sm bg-gradient-info me-2"></span>
                  <span class="text-xs">PT cá nhân (20%)</span>
                </div>
                <div class="d-flex align-items-center mt-2">
                  <span class="badge badge-sm bg-gradient-warning me-2"></span>
                  <span class="text-xs">Yoga/Pilates (15%)</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-5">
        <div class="card card-carousel overflow-hidden h-100 p-0">
          <div
                  id="carouselExampleCaptions"
                  class="carousel slide h-100"
                  data-bs-ride="carousel"
          >
            <div class="carousel-inner border-radius-lg h-100">
              <div
                      class="carousel-item h-100 active"
                      style="
                      background-color: #1a1a2e;
                      background-size: cover;
                    "
              >
                <object type="image/svg+xml" data="./assets/img/svg/fitness-workout.svg" class="w-100 h-100">
                  Your browser does not support SVG
                </object>
                <div
                        class="carousel-caption d-none d-md-block bottom-0 text-start start-0 ms-5"
                >
                  <div
                          class="icon icon-shape icon-sm bg-white text-center border-radius-md mb-3"
                  >
                    <i
                            class="ni ni-trophy text-dark opacity-10"
                    ></i>
                  </div>
                  <h5 class="text-white mb-1">Tập luyện sức mạnh</h5>
                  <p>
                    Xây dựng cơ thể khỏe mạnh với các bài tập sức mạnh tại phòng gym của chúng tôi.
                  </p>
                </div>
              </div>
              <div
                      class="carousel-item h-100"
                      style="
                      background-color: #003049;
                      background-size: cover;
                    "
              >
                <object type="image/svg+xml" data="./assets/img/svg/cardio-training.svg" class="w-100 h-100">
                  Your browser does not support SVG
                </object>
                <div
                        class="carousel-caption d-none d-md-block bottom-0 text-start start-0 ms-5"
                >
                  <div
                          class="icon icon-shape icon-sm bg-white text-center border-radius-md mb-3"
                  >
                    <i class="ni ni-bulb-61 text-dark opacity-10"></i>
                  </div>
                  <h5 class="text-white mb-1">
                    Luyện tập tim mạch
                  </h5>
                  <p>
                    Cải thiện sức khỏe tim mạch với các bài tập cardio hiệu quả.
                  </p>
                </div>
              </div>
              <div
                      class="carousel-item h-100"
                      style="
                      background-color: #2b2d42;
                      background-size: cover;
                    "
              >
                <object type="image/svg+xml" data="./assets/img/svg/yoga-fitness.svg" class="w-100 h-100">
                  Your browser does not support SVG
                </object>
                <div
                        class="carousel-caption d-none d-md-block bottom-0 text-start start-0 ms-5"
                >
                  <div
                          class="icon icon-shape icon-sm bg-white text-center border-radius-md mb-3"
                  >
                    <i class="ni ni-satisfied text-dark opacity-10"></i>
                  </div>
                  <h5 class="text-white mb-1">
                    Yoga & Thiền
                  </h5>
                  <p>
                    Tìm thấy sự cân bằng nội tại với các lớp yoga và thiền định.
                  </p>
                </div>
              </div>
            </div>
            <button
                    class="carousel-control-prev w-5 me-3"
                    type="button"
                    data-bs-target="#carouselExampleCaptions"
                    data-bs-slide="prev"
            >
                  <span
                          class="carousel-control-prev-icon"
                          aria-hidden="true"
                  ></span>
              <span class="visually-hidden">Previous</span>
            </button>
            <button
                    class="carousel-control-next w-5 me-3"
                    type="button"
                    data-bs-target="#carouselExampleCaptions"
                    data-bs-slide="next"
            >
                  <span
                          class="carousel-control-next-icon"
                          aria-hidden="true"
                  ></span>
              <span class="visually-hidden">Next</span>
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="row mt-4">
      <div class="col-lg-7 mb-lg-0 mb-4">
        <div class="card">
          <div class="card-header pb-0 p-3">
            <div class="d-flex justify-content-between">
              <h6 class="mb-2">Thống kê lớp tập phổ biến</h6>
            </div>
          </div>
          <div class="card-body p-3">
            <div class="chart">
              <canvas id="class-attendance-chart" class="chart-canvas" height="300"></canvas>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-5">
        <div class="card">
          <div class="card-header pb-0 p-3">
            <h6 class="mb-0">Danh mục dịch vụ</h6>
          </div>
          <div class="card-body p-3">
            <ul class="list-group">
              <li
                      class="list-group-item border-0 d-flex justify-content-between ps-0 mb-2 border-radius-lg"
              >
                <a
                        href="listPackage"
                        class="d-flex align-items-center justify-content-between w-100 text-dark"
                        style="text-decoration: none"
                >
                  <div class="d-flex align-items-center">
                    <div
                            class="icon icon-shape icon-sm me-3 bg-gradient-dark shadow text-center"
                    >
                      <i
                              class="ni ni-mobile-button text-white opacity-10"
                      ></i>
                    </div>
                    <div class="d-flex flex-column">
                      <h6 class="mb-1 text-dark text-sm">Gói tập Gym</h6>
                      <span class="text-xs"
                      >50 đang hoạt động,
                            <span class="font-weight-bold"
                            >200+ đã bán</span
                            ></span
                      >
                    </div>
                  </div>
                  <div class="d-flex">
                    <button
                            class="btn btn-link btn-icon-only btn-rounded btn-sm text-dark icon-move-right my-auto"
                    >
                      <i class="ni ni-bold-right" aria-hidden="true"></i>
                    </button>
                  </div>
                </a>
              </li>
              <li
                      class="list-group-item border-0 d-flex justify-content-between ps-0 mb-2 border-radius-lg"
              >
                <div class="d-flex align-items-center">
                  <div
                          class="icon icon-shape icon-sm me-3 bg-gradient-dark shadow text-center"
                  >
                    <i class="ni ni-tag text-white opacity-10"></i>
                  </div>
                  <div class="d-flex flex-column">
                    <h6 class="mb-1 text-dark text-sm">
                      Huấn luyện viên cá nhân
                    </h6>
                    <span class="text-xs"
                    >10 đang hoạt động,
                          <span class="font-weight-bold"
                          >30+ khách hàng</span
                          ></span
                    >
                  </div>
                </div>
                <div class="d-flex">
                  <button
                          class="btn btn-link btn-icon-only btn-rounded btn-sm text-dark icon-move-right my-auto"
                  >
                    <i class="ni ni-bold-right" aria-hidden="true"></i>
                  </button>
                </div>
              </li>
              <li
                      class="list-group-item border-0 d-flex justify-content-between ps-0 mb-2 border-radius-lg"
              >
                <div class="d-flex align-items-center">
                  <div
                          class="icon icon-shape icon-sm me-3 bg-gradient-dark shadow text-center"
                  >
                    <i class="ni ni-box-2 text-white opacity-10"></i>
                  </div>
                  <div class="d-flex flex-column">
                    <h6 class="mb-1 text-dark text-sm">Lớp nhóm</h6>
                    <span class="text-xs"
                    >5 lớp đang mở,
                          <span class="font-weight-bold"
                          >100+ học viên</span
                          ></span
                    >
                  </div>
                </div>
                <div class="d-flex">
                  <button
                          class="btn btn-link btn-icon-only btn-rounded btn-sm text-dark icon-move-right my-auto"
                  >
                    <i class="ni ni-bold-right" aria-hidden="true"></i>
                  </button>
                </div>
              </li>
              <li
                      class="list-group-item border-0 d-flex justify-content-between ps-0 border-radius-lg"
              >
                <div class="d-flex align-items-center">
                  <div
                          class="icon icon-shape icon-sm me-3 bg-gradient-dark shadow text-center"
                  >
                    <i class="ni ni-satisfied text-white opacity-10"></i>
                  </div>
                  <div class="d-flex flex-column">
                    <h6 class="mb-1 text-dark text-sm">
                      Khách hàng hài lòng
                    </h6>
                    <span class="text-xs font-weight-bold">+ 430</span>
                  </div>
                </div>
                <div class="d-flex">
                  <button
                          class="btn btn-link btn-icon-only btn-rounded btn-sm text-dark icon-move-right my-auto"
                  >
                    <i class="ni ni-bold-right" aria-hidden="true"></i>
                  </button>
                </div>
              </li>
            </ul>
          </div>
        </div>
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
              , made with <i class="fa fa-heart"></i> by
              <a
                      href="https://www.creative-tim.com"
                      class="font-weight-bold"
                      target="_blank"
              >SWP391_07</a
              >
            </div>
          </div>
          <!-- <div class="col-lg-6">
            <ul
              class="nav nav-footer justify-content-center justify-content-lg-end"
            >
              <li class="nav-item">
                <a
                  href="https://www.creative-tim.com"
                  class="nav-link text-muted"
                  target="_blank"
                  >Creative Tim</a
                >
              </li>
              <li class="nav-item">
                <a
                  href="https://www.creative-tim.com/presentation"
                  class="nav-link text-muted"
                  target="_blank"
                  >About Us</a
                >
              </li>
              <li class="nav-item">
                <a
                  href="https://www.creative-tim.com/blog"
                  class="nav-link text-muted"
                  target="_blank"
                  >Blog</a
                >
              </li>
              <li class="nav-item">
                <a
                  href="https://www.creative-tim.com/license"
                  class="nav-link pe-0 text-muted"
                  target="_blank"
                  >License</a
                >
              </li>
            </ul>
          </div> -->
        </div>
      </div>
    </footer>
  </div>
</main>
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
      <div class="d-flex my-3">
        <h6 class="mb-0">Navbar Fixed</h6>
        <div class="form-check form-switch ps-0 ms-auto my-auto">
          <input
                  class="form-check-input mt-1 ms-auto"
                  type="checkbox"
                  id="navbarFixed"
                  onclick="navbarFixed(this)"
          />
        </div>
      </div>
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
<script src="./assets/js/core/popper.min.js"></script>
<script src="./assets/js/core/bootstrap.min.js"></script>
<script src="./assets/js/plugins/perfect-scrollbar.min.js"></script>
<script src="./assets/js/plugins/smooth-scrollbar.min.js"></script>
<script src="./assets/js/plugins/chartjs.min.js"></script>
<script>
  var ctx1 = document.getElementById("chart-line").getContext("2d");

  var gradientStroke1 = ctx1.createLinearGradient(0, 230, 0, 50);

  gradientStroke1.addColorStop(1, "rgba(94, 114, 228, 0.2)");
  gradientStroke1.addColorStop(0.2, "rgba(94, 114, 228, 0.0)");
  gradientStroke1.addColorStop(0, "rgba(94, 114, 228, 0)");
  new Chart(ctx1, {
    type: "line",
    data: {
      labels: [
        "Tháng 1",
        "Tháng 2",
        "Tháng 3",
        "Tháng 4",
        "Tháng 5",
        "Tháng 6",
        "Tháng 7",
        "Tháng 8",
        "Tháng 9",
      ],
      datasets: [
        {
          label: "Doanh thu (triệu đồng)",
          tension: 0.4,
          borderWidth: 0,
          pointRadius: 0,
          borderColor: "#5e72e4",
          backgroundColor: gradientStroke1,
          borderWidth: 3,
          fill: true,
          data: [25, 28, 32, 30, 35, 40, 42, 45, 50],
          maxBarThickness: 6,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
      interaction: {
        intersect: false,
        mode: "index",
      },
      scales: {
        y: {
          grid: {
            drawBorder: false,
            display: true,
            drawOnChartArea: true,
            drawTicks: false,
            borderDash: [5, 5],
          },
          ticks: {
            display: true,
            padding: 10,
            color: "#fbfbfb",
            font: {
              size: 11,
              family: "Open Sans",
              style: "normal",
              lineHeight: 2,
            },
          },
        },
        x: {
          grid: {
            drawBorder: false,
            display: false,
            drawOnChartArea: false,
            drawTicks: false,
            borderDash: [5, 5],
          },
          ticks: {
            display: true,
            color: "#ccc",
            padding: 20,
            font: {
              size: 11,
              family: "Open Sans",
              style: "normal",
              lineHeight: 2,
            },
          },
        },
      },
    },
  });
</script>
<script>
  var win = navigator.platform.indexOf("Win") > -1;
  if (win && document.querySelector("#sidenav-scrollbar")) {
    var options = {
      damping: "0.5",
    };
    Scrollbar.init(document.querySelector("#sidenav-scrollbar"), options);
  }
</script>

<!-- Member Activity Chart -->
<script>
  var ctx2 = document.getElementById("member-activity-chart").getContext("2d");

  new Chart(ctx2, {
    type: "doughnut",
    data: {
      labels: ["Tập luyện cá nhân", "Tập luyện nhóm", "PT cá nhân", "Yoga/Pilates"],
      datasets: [{
        label: "Phân bố hoạt động",
        weight: 9,
        cutout: 60,
        tension: 0.9,
        pointRadius: 2,
        borderWidth: 2,
        backgroundColor: ["#5e72e4", "#2dce89", "#11cdef", "#fb6340"],
        data: [40, 25, 20, 15],
        fill: false
      }],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        }
      },
      interaction: {
        intersect: false,
        mode: "index"
      }
    },
  });
</script>

<!-- Class Attendance Chart -->
<script>
  var ctx3 = document.getElementById("class-attendance-chart").getContext("2d");

  new Chart(ctx3, {
    type: "bar",
    data: {
      labels: ["Yoga", "HIIT", "Zumba", "Spinning", "Boxing", "Pilates"],
      datasets: [{
        label: "Số người tham gia",
        weight: 5,
        borderWidth: 0,
        borderRadius: 4,
        backgroundColor: "#5e72e4",
        data: [35, 42, 28, 32, 25, 20],
        fill: false,
        maxBarThickness: 35
      }],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        }
      },
      scales: {
        y: {
          grid: {
            drawBorder: false,
            display: true,
            drawOnChartArea: true,
            drawTicks: false,
            borderDash: [5, 5]
          },
          ticks: {
            display: true,
            padding: 10,
            color: "#9ca2b7"
          }
        },
        x: {
          grid: {
            drawBorder: false,
            display: false,
            drawOnChartArea: false,
            drawTicks: true,
          },
          ticks: {
            display: true,
            color: "#9ca2b7",
            padding: 10
          }
        },
      },
    },
  });
</script>

<!-- GitHub buttons -->
<script async defer src="https://buttons.github.io/buttons.js"></script>
<!-- Control Center for Soft Dashboard: parallax effects, scripts for the example pages etc -->
<script src="./assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@page
import="Models.User, Models.Schedule, java.util.List"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <% User loggedInUser = (User)
session.getAttribute("loggedInUser"); if (loggedInUser == null) {
response.sendRedirect("login.jsp"); return; } List<Schedule>
  schedules = (List<Schedule
    >) request.getAttribute("schedules"); Integer totalSchedules = (Integer)
    request.getAttribute("totalSchedules"); Integer completedCount = (Integer)
    request.getAttribute("completedCount"); Integer confirmedCount = (Integer)
    request.getAttribute("confirmedCount"); Integer pendingCount = (Integer)
    request.getAttribute("pendingCount"); Integer cancelledCount = (Integer)
    request.getAttribute("cancelledCount"); String successMessage = (String)
    request.getAttribute("successMessage"); String errorMessage = (String)
    request.getAttribute("errorMessage"); %>

    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1, shrink-to-fit=no"
        />
        <title>CORE-FIT GYM</title>
        <link
          rel="apple-touch-icon"
          sizes="76x76"
          href="assets/img/icons8-gym-96.png"
        />
        <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png" />
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
        <link
          rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
        />
        <link
          id="pagestyle"
          href="assets/css/argon-dashboard.css?v=2.1.0"
          rel="stylesheet"
        />
        <style>
          .schedule-card {
            transition: all 0.3s ease;
          }

          .schedule-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
          }

          .status-badge {
            font-size: 0.75rem;
            padding: 0.35em 0.65em;
            border-radius: 0.375rem;
          }

          .status-Completed {
            background-color: #2dce89;
            color: white;
          }

          .status-Confirmed {
            background-color: #11cdef;
            color: white;
          }

          .status-Pending {
            background-color: #fb6340;
            color: white;
          }

          .status-Cancelled {
            background-color: #f5365c;
            color: white;
          }

          .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
          }
        </style>
      </head>

      <body class="g-sidenav-show bg-gray-100">
        <div class="min-height-300 bg-dark position-absolute w-100"></div>

        <!-- Sidebar -->
        <%@ include file="member_sidebar.jsp" %>

        <main class="main-content position-relative border-radius-lg">
          <!-- Navbar -->
          <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Lịch tập và tiến độ" />
            <jsp:param name="parentPage" value="Trang chủ" />
            <jsp:param name="parentPageUrl" value="member-dashboard" />
            <jsp:param name="currentPage" value="Lịch tập và tiến độ" />
          </jsp:include>

          <!-- Toast Container -->
          <div class="toast-container">
            <% if (successMessage != null) { %>
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
            <% } %> <% if (errorMessage != null) { %>
            <div
              class="toast align-items-center text-white bg-danger border-0"
              role="alert"
              aria-live="assertive"
              aria-atomic="true"
              id="errorToast"
            >
              <div class="d-flex">
                <div class="toast-body">
                  <i class="fas fa-exclamation-circle me-2"></i> <%=
                  errorMessage %>
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

          <div class="container-fluid py-4">
            <!-- Progress Statistics -->
            <div class="row mb-4">
              <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                <div class="card">
                  <div class="card-body p-3">
                    <div class="row">
                      <div class="col-8">
                        <div class="numbers">
                          <p
                            class="text-sm mb-0 text-uppercase font-weight-bold"
                          >
                            Hoàn thành
                          </p>
                          <h5 class="font-weight-bolder mb-0">
                            <%= completedCount %>
                            <span
                              class="text-success text-sm font-weight-bolder"
                            >
                              <%= totalSchedules > 0 ? String.format("(%.1f%%)",
                              (completedCount * 100.0 / totalSchedules)) :
                              "(0%)" %>
                            </span>
                          </h5>
                        </div>
                      </div>
                      <div class="col-4 text-end">
                        <div
                          class="icon icon-shape bg-gradient-success shadow-success text-center rounded-circle"
                        >
                          <i class="fas fa-check-circle text-lg opacity-10"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                <div class="card">
                  <div class="card-body p-3">
                    <div class="row">
                      <div class="col-8">
                        <div class="numbers">
                          <p
                            class="text-sm mb-0 text-uppercase font-weight-bold"
                          >
                            Đã xác nhận
                          </p>
                          <h5 class="font-weight-bolder mb-0">
                            <%= confirmedCount %>
                            <span class="text-info text-sm font-weight-bolder">
                              <%= totalSchedules > 0 ? String.format("(%.1f%%)",
                              (confirmedCount * 100.0 / totalSchedules)) :
                              "(0%)" %>
                            </span>
                          </h5>
                        </div>
                      </div>
                      <div class="col-4 text-end">
                        <div
                          class="icon icon-shape bg-gradient-info shadow-info text-center rounded-circle"
                        >
                          <i
                            class="fas fa-calendar-check text-lg opacity-10"
                          ></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                <div class="card">
                  <div class="card-body p-3">
                    <div class="row">
                      <div class="col-8">
                        <div class="numbers">
                          <p
                            class="text-sm mb-0 text-uppercase font-weight-bold"
                          >
                            Chờ xử lý
                          </p>
                          <h5 class="font-weight-bolder mb-0">
                            <%= pendingCount %>
                            <span
                              class="text-warning text-sm font-weight-bolder"
                            >
                              <%= totalSchedules > 0 ? String.format("(%.1f%%)",
                              (pendingCount * 100.0 / totalSchedules)) : "(0%)"
                              %>
                            </span>
                          </h5>
                        </div>
                      </div>
                      <div class="col-4 text-end">
                        <div
                          class="icon icon-shape bg-gradient-warning shadow-warning text-center rounded-circle"
                        >
                          <i
                            class="fas fa-hourglass-half text-lg opacity-10"
                          ></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6">
                <div class="card">
                  <div class="card-body p-3">
                    <div class="row">
                      <div class="col-8">
                        <div class="numbers">
                          <p
                            class="text-sm mb-0 text-uppercase font-weight-bold"
                          >
                            Đã hủy
                          </p>
                          <h5 class="font-weight-bolder mb-0">
                            <%= cancelledCount %>
                            <span
                              class="text-danger text-sm font-weight-bolder"
                            >
                              <%= totalSchedules > 0 ? String.format("(%.1f%%)",
                              (cancelledCount * 100.0 / totalSchedules)) :
                              "(0%)" %>
                            </span>
                          </h5>
                        </div>
                      </div>
                      <div class="col-4 text-end">
                        <div
                          class="icon icon-shape bg-gradient-danger shadow-danger text-center rounded-circle"
                        >
                          <i class="fas fa-times-circle text-lg opacity-10"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Progress Bar -->
            <div class="row mb-4">
              <div class="col-12">
                <div class="card">
                  <div class="card-header pb-0">
                    <h6>Tiến độ tổng quan</h6>
                  </div>
                  <div class="card-body">
                    <div class="progress-wrapper">
                      <div class="progress-info">
                        <div class="progress-percentage">
                          <span class="text-sm font-weight-bold">
                            <%= totalSchedules > 0 ? String.format("%.1f%%",
                            (completedCount * 100.0 / totalSchedules)) : "0%" %>
                          </span>
                        </div>
                      </div>
                      <div class="progress">
                        <div
                          class="progress-bar bg-success"
                          role="progressbar"
                          aria-valuenow="<%= completedCount %>"
                          aria-valuemin="0"
                          aria-valuemax="<%= totalSchedules %>"
                          <%
                          if
                          (totalSchedules
                        >
                          0) { %> style="width: <%= String.format("%.1f",
                          (completedCount * 100.0 / totalSchedules)) %>%" <% }
                          else { %> style="width: 0%" <% } %> >
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Schedule List -->
            <div class="row">
              <div class="col-12">
                <div class="card mb-4">
                  <div class="card-header pb-0">
                    <div
                      class="d-flex justify-content-between align-items-center"
                    >
                      <h6>Lịch tập của tôi</h6>
                      <div class="btn-group" role="group">
                        <button
                          type="button"
                          class="btn btn-sm btn-outline-primary active"
                          id="btn-all"
                        >
                          Tất cả
                        </button>
                        <button
                          type="button"
                          class="btn btn-sm btn-outline-success"
                          id="btn-completed"
                        >
                          Hoàn thành
                        </button>
                        <button
                          type="button"
                          class="btn btn-sm btn-outline-info"
                          id="btn-confirmed"
                        >
                          Đã xác nhận
                        </button>
                        <button
                          type="button"
                          class="btn btn-sm btn-outline-warning"
                          id="btn-pending"
                        >
                          Chờ xử lý
                        </button>
                        <button
                          type="button"
                          class="btn btn-sm btn-outline-danger"
                          id="btn-cancelled"
                        >
                          Đã hủy
                        </button>
                      </div>
                    </div>
                  </div>
                  <div class="card-body px-0 pt-0 pb-2">
                    <div class="table-responsive p-0">
                      <table class="table align-items-center mb-0">
                        <thead>
                          <tr>
                            <th
                              class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                            >
                              Huấn luyện viên
                            </th>
                            <th
                              class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                            >
                              Ngày
                            </th>
                            <th
                              class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                            >
                              Giờ
                            </th>
                            <th
                              class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                            >
                              Thời lượng
                            </th>
                            <th
                              class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                            >
                              Trạng thái
                            </th>
                            <th
                              class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7"
                            >
                              Hành động
                            </th>
                          </tr>
                        </thead>
                        <tbody>
                          <% if (schedules != null && !schedules.isEmpty()) {
                          for (Schedule schedule : schedules) { %>
                          <tr class="schedule-row <%= schedule.getStatus() %>">
                            <td>
                              <div class="d-flex px-3 py-1">
                                <div
                                  class="d-flex flex-column justify-content-center"
                                >
                                  <h6 class="mb-0 text-sm">
                                    <%= schedule.getTrainer().getFullName() %>
                                  </h6>
                                  <p class="text-xs text-secondary mb-0">
                                    <%= schedule.getTrainer().getUserName() %>
                                  </p>
                                </div>
                              </div>
                            </td>
                            <td>
                              <div class="d-flex px-3 py-1">
                                <div
                                  class="d-flex flex-column justify-content-center"
                                >
                                  <h6 class="mb-0 text-sm">
                                    <%= schedule.getScheduleDate() %>
                                  </h6>
                                </div>
                              </div>
                            </td>
                            <td>
                              <div class="d-flex px-3 py-1">
                                <div
                                  class="d-flex flex-column justify-content-center"
                                >
                                  <h6 class="mb-0 text-sm">
                                    <%= schedule.getScheduleTime() %>
                                  </h6>
                                </div>
                              </div>
                            </td>
                            <td>
                              <div class="d-flex px-3 py-1">
                                <div
                                  class="d-flex flex-column justify-content-center"
                                >
                                  <h6 class="mb-0 text-sm">
                                    <%= schedule.getDurationHours() %> giờ
                                  </h6>
                                </div>
                              </div>
                            </td>
                            <td>
                              <div class="d-flex px-3 py-1">
                                <span
                                  class="badge status-<%= schedule.getStatus() %>"
                                >
                                  <%= "Completed".equals(schedule.getStatus()) ?
                                  "Hoàn thành" :
                                  "Confirmed".equals(schedule.getStatus()) ? "Đã
                                  xác nhận" :
                                  "Pending".equals(schedule.getStatus()) ? "Chờ
                                  xử lý" :
                                  "Cancelled".equals(schedule.getStatus()) ? "Đã
                                  hủy" : schedule.getStatus() %>
                                </span>
                              </div>
                            </td>
                            <td>
                              <div class="d-flex px-3 py-1">
                                <% if ("Pending".equals(schedule.getStatus()) ||
                                "Confirmed".equals(schedule.getStatus())) { %>
                                <button
                                  type="button"
                                  class="btn btn-sm btn-danger"
                                  data-bs-toggle="modal"
                                  data-bs-target="#cancelModal"
                                  data-schedule-id="<%= schedule.getId() %>"
                                  data-schedule-date="<%= schedule.getScheduleDate() %>"
                                  data-schedule-time="<%= schedule.getScheduleTime() %>"
                                  data-trainer-name="<%= schedule.getTrainer().getFullName() %>"
                                >
                                  Hủy lịch
                                </button>
                                <% } else { %>
                                <span class="text-xs text-secondary"
                                  >Không có hành động</span
                                >
                                <% } %>
                              </div>
                            </td>
                          </tr>
                          <% } } else { %>
                          <tr>
                            <td colspan="6" class="text-center py-4">
                              Không có dữ liệu lịch tập
                            </td>
                          </tr>
                          <% } %>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Footer -->
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
                      CGMS - Gym Management System
                    </div>
                  </div>
                </div>
              </div>
            </footer>
          </div>
        </main>

        <!-- Cancel Confirmation Modal -->
        <div
          class="modal fade"
          id="cancelModal"
          tabindex="-1"
          aria-labelledby="cancelModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
              <div class="modal-header bg-danger">
                <h5 class="modal-title text-white" id="cancelModalLabel">
                  Xác nhận hủy lịch tập
                </h5>
                <button
                  type="button"
                  class="btn-close btn-close-white"
                  data-bs-dismiss="modal"
                  aria-label="Close"
                ></button>
              </div>
              <div class="modal-body">
                <p>Bạn có chắc chắn muốn hủy lịch tập này?</p>
                <div class="alert alert-warning">
                  <div class="d-flex">
                    <div class="me-3">
                      <i class="fas fa-exclamation-triangle fa-2x"></i>
                    </div>
                    <div>
                      <h5 class="alert-heading">Lưu ý quan trọng!</h5>
                      <p class="mb-0">
                        Sau khi hủy, bạn sẽ không thể khôi phục lại lịch tập
                        này.
                      </p>
                    </div>
                  </div>
                </div>
                <div class="mt-3">
                  <p><strong>Thông tin lịch tập:</strong></p>
                  <ul class="list-group">
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      Huấn luyện viên
                      <span
                        id="modal-trainer-name"
                        class="badge bg-primary rounded-pill"
                      ></span>
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      Ngày
                      <span
                        id="modal-schedule-date"
                        class="badge bg-info rounded-pill"
                      ></span>
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      Giờ
                      <span
                        id="modal-schedule-time"
                        class="badge bg-info rounded-pill"
                      ></span>
                    </li>
                  </ul>
                </div>
              </div>
              <div class="modal-footer">
                <button
                  type="button"
                  class="btn btn-secondary"
                  data-bs-dismiss="modal"
                >
                  Đóng
                </button>
                <form
                  id="cancelForm"
                  action="member-training-schedule/cancel"
                  method="get"
                >
                  <input type="hidden" name="id" id="schedule-id-input" />
                  <button type="submit" class="btn btn-danger">
                    Xác nhận hủy
                  </button>
                </form>
              </div>
            </div>
          </div>
        </div>

        <!-- Core JS Files -->
        <script src="assets/js/core/popper.min.js"></script>
        <script src="assets/js/core/bootstrap.min.js"></script>
        <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>

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

            // Xử lý lọc lịch tập theo trạng thái
            document
              .getElementById("btn-all")
              .addEventListener("click", function () {
                filterSchedules("all");
                setActiveButton(this);
              });

            document
              .getElementById("btn-completed")
              .addEventListener("click", function () {
                filterSchedules("Completed");
                setActiveButton(this);
              });

            document
              .getElementById("btn-confirmed")
              .addEventListener("click", function () {
                filterSchedules("Confirmed");
                setActiveButton(this);
              });

            document
              .getElementById("btn-pending")
              .addEventListener("click", function () {
                filterSchedules("Pending");
                setActiveButton(this);
              });

            document
              .getElementById("btn-cancelled")
              .addEventListener("click", function () {
                filterSchedules("Cancelled");
                setActiveButton(this);
              });

            // Xử lý modal hủy lịch
            var cancelModal = document.getElementById("cancelModal");
            if (cancelModal) {
              cancelModal.addEventListener("show.bs.modal", function (event) {
                var button = event.relatedTarget;
                var scheduleId = button.getAttribute("data-schedule-id");
                var scheduleDate = button.getAttribute("data-schedule-date");
                var scheduleTime = button.getAttribute("data-schedule-time");
                var trainerName = button.getAttribute("data-trainer-name");

                document.getElementById("schedule-id-input").value = scheduleId;
                document.getElementById("modal-trainer-name").textContent =
                  trainerName;
                document.getElementById("modal-schedule-date").textContent =
                  scheduleDate;
                document.getElementById("modal-schedule-time").textContent =
                  scheduleTime;
              });
            }
          });

          function setActiveButton(button) {
            document
              .querySelectorAll(".btn-group .btn")
              .forEach(function (btn) {
                btn.classList.remove("active");
              });
            button.classList.add("active");
          }

          function filterSchedules(status) {
            var rows = document.querySelectorAll(".schedule-row");
            rows.forEach(function (row) {
              if (status === "all" || row.classList.contains(status)) {
                row.style.display = "";
              } else {
                row.style.display = "none";
              }
            });
          }
        </script>
      </body>
    </html>
  </Schedule></Schedule
>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Models.User" %>

<%
    // Kiểm tra quyền PT
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null || !"Personal Trainer".equals(currentUser.getRole())) {
        response.sendRedirect("login");
        return;
    }

    String errorMessage = (String) session.getAttribute("errorMessage");
    boolean hasErrorMessage = (errorMessage != null);
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    String successMessage = (String) session.getAttribute("successMessage");
    boolean hasSuccessMessage = (successMessage != null);
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }

    // Lấy ngày được chọn từ calendar (nếu có)
    String preselectedDate = request.getParameter("preselectedDate");
    String todayDate = java.time.LocalDate.now().toString();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đăng ký lịch sẵn sàng - CGMS PT</title>
    <link rel="stylesheet" href="assets/css/argon-dashboard.css?v=2.1.0"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            --warning-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --info-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --danger-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            --hover-transform: translateY(-2px);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .register-container {
            background: white;
            border-radius: 24px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .register-header {
            background: var(--primary-gradient);
            padding: 2rem;
            text-align: center;
            color: white;
            position: relative;
        }

        .register-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><g fill="%23ffffff" fill-opacity="0.1"><polygon points="36 34 18 14 18 26 34 26"/></g></g></svg>') repeat;
        }

        .register-header h2 {
            position: relative;
            z-index: 2;
            margin: 0;
            font-size: 1.75rem;
            font-weight: 700;
        }

        .register-header p {
            position: relative;
            z-index: 2;
            margin: 0.5rem 0 0 0;
            opacity: 0.9;
        }

        .register-form {
            padding: 2.5rem;
        }

        .back-button {
            background: var(--info-gradient);
            border: none;
            border-radius: 12px;
            padding: 0.75rem 1.5rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            margin-bottom: 2rem;
        }

        .back-button:hover {
            transform: var(--hover-transform);
            box-shadow: 0 8px 20px rgba(79, 172, 254, 0.4);
            color: white;
            text-decoration: none;
        }

        .form-group {
            margin-bottom: 2rem;
        }

        .form-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8fafc;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: white;
        }

        .form-control.is-invalid {
            border-color: #ef4444;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }

        .invalid-feedback {
            color: #ef4444;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .time-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .submit-button {
            background: var(--success-gradient);
            border: none;
            border-radius: 16px;
            padding: 1rem 2rem;
            color: white;
            font-weight: 700;
            font-size: 1.1rem;
            width: 100%;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .submit-button:hover:not(:disabled) {
            transform: var(--hover-transform);
            box-shadow: 0 15px 35px rgba(17, 153, 142, 0.4);
        }

        .submit-button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .help-section {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-radius: 16px;
            padding: 1.5rem;
            margin-top: 2rem;
            border-left: 4px solid #667eea;
        }

        .help-title {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .help-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .help-list li {
            padding: 0.5rem 0;
            color: #4a5568;
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
        }

        .help-list li i {
            color: #667eea;
            margin-top: 0.1rem;
            width: 16px;
        }

        .date-info {
            background: linear-gradient(135deg, #ebf8ff 0%, #bee3f8 100%);
            border: 1px solid #90cdf4;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            color: #2c5282;
        }

        .toast-container {
            position: fixed;
            top: 2rem;
            right: 2rem;
            z-index: 9999;
        }

        .toast {
            margin-bottom: 1rem;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .register-form {
                padding: 1.5rem;
            }
            
            .time-grid {
                grid-template-columns: 1fr;
            }
            
            .register-header h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>

    <!-- Toast Container -->
    <div class="toast-container">
        <% if (hasSuccessMessage) { %>
        <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true" id="successToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= successMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <% } %>

        <% if (hasErrorMessage) { %>
        <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" id="errorToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <% } %>
    </div>

    <!-- Sidebar -->
    <%@ include file="pt_sidebar.jsp" %>

    <!-- Main content -->
    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <%@ include file="navbar.jsp" %>

        <!-- Content -->
        <div class="container-fluid py-4">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-xl-6">
                    <div class="register-container">
                        <!-- Header -->
                        <div class="register-header">
                            <h2>
                                <i class="fas fa-calendar-plus me-2"></i>
                                Đăng ký lịch sẵn sàng
                            </h2>
                            <p>Đăng ký lịch để có thể nhận lịch tập với thành viên</p>
                        </div>

                        <!-- Form -->
                        <div class="register-form">
                            <!-- Back Button -->
                            <a href="pt-availability" class="back-button">
                                <i class="fas fa-arrow-left"></i>
                                Quay lại danh sách
                            </a>

                            <% if (preselectedDate != null) { %>
                            <div class="date-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Ngày được chọn:</strong> <%= preselectedDate %>
                                <br>
                                <small>Bạn có thể thay đổi ngày này nếu cần thiết.</small>
                            </div>
                            <% } %>

                            <form id="registerForm" method="post" action="pt-availability">
                                <input type="hidden" name="action" value="register">

                                <!-- Ngày sẵn sàng -->
                                <div class="form-group">
                                    <label for="availabilityDate" class="form-label">
                                        <i class="fas fa-calendar"></i>
                                        Ngày sẵn sàng *
                                    </label>
                                    <input type="date" 
                                           class="form-control" 
                                           id="availabilityDate" 
                                           name="availabilityDate" 
                                           value="<%= preselectedDate != null ? preselectedDate : "" %>"
                                           min="<%= todayDate %>" 
                                           required>
                                    <div class="invalid-feedback" id="dateError"></div>
                                </div>

                                <!-- Thời gian -->
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-clock"></i>
                                        Thời gian làm việc *
                                    </label>
                                    <div class="time-grid">
                                        <div>
                                            <label for="startTime" class="form-label text-sm">Bắt đầu</label>
                                            <input type="time" 
                                                   class="form-control" 
                                                   id="startTime" 
                                                   name="startTime" 
                                                   value="08:00" 
                                                   required>
                                            <div class="invalid-feedback" id="startTimeError"></div>
                                        </div>
                                        <div>
                                            <label for="endTime" class="form-label text-sm">Kết thúc</label>
                                            <input type="time" 
                                                   class="form-control" 
                                                   id="endTime" 
                                                   name="endTime" 
                                                   value="17:00" 
                                                   required>
                                            <div class="invalid-feedback" id="endTimeError"></div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Submit Button -->
                                <button type="submit" class="submit-button" id="submitBtn">
                                    <i class="fas fa-plus-circle"></i>
                                    Đăng ký lịch sẵn sàng
                                </button>
                            </form>

                            <!-- Help Section -->
                            <div class="help-section">
                                <div class="help-title">
                                    <i class="fas fa-lightbulb"></i>
                                    Lưu ý quan trọng
                                </div>
                                <ul class="help-list">
                                    <li>
                                        <i class="fas fa-check"></i>
                                        <span>Bạn chỉ có thể đăng ký <strong>1 lịch cho mỗi ngày</strong></span>
                                    </li>
                                    <li>
                                        <i class="fas fa-ban"></i>
                                        <span>Gym <strong>không hoạt động vào Chủ nhật</strong></span>
                                    </li>
                                    <li>
                                        <i class="fas fa-clock"></i>
                                        <span>Thời gian kết thúc phải sau thời gian bắt đầu</span>
                                    </li>
                                    <li>
                                        <i class="fas fa-user-check"></i>
                                        <span>Lịch cần được admin duyệt trước khi có hiệu lực</span>
                                    </li>
                                    <li>
                                        <i class="fas fa-edit"></i>
                                        <span>Bạn có thể hủy lịch trước ít nhất 1 ngày</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Scripts -->
    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>

    <script>
        // Initialize toasts
        document.addEventListener('DOMContentLoaded', function() {
            const toastElements = document.querySelectorAll('.toast');
            toastElements.forEach(function(toastElement) {
                const toast = new bootstrap.Toast(toastElement, {
                    delay: 5000
                });
                toast.show();
            });

            // Validate form on load
            validateForm();
        });

        // Form validation
        function validateForm() {
            const dateInput = document.getElementById('availabilityDate');
            const startTimeInput = document.getElementById('startTime');
            const endTimeInput = document.getElementById('endTime');
            const submitBtn = document.getElementById('submitBtn');

            function validate() {
                let isValid = true;
                
                // Clear previous errors
                clearErrors();

                // Validate date
                const selectedDate = new Date(dateInput.value);
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                if (!dateInput.value) {
                    showError('availabilityDate', 'dateError', 'Vui lòng chọn ngày');
                    isValid = false;
                } else if (selectedDate < today) {
                    showError('availabilityDate', 'dateError', 'Không thể chọn ngày trong quá khứ');
                    isValid = false;
                } else if (selectedDate.getDay() === 0) { // Sunday = 0
                    showError('availabilityDate', 'dateError', 'Gym không hoạt động vào Chủ nhật');
                    isValid = false;
                }

                // Validate time
                const startTime = startTimeInput.value;
                const endTime = endTimeInput.value;

                if (!startTime) {
                    showError('startTime', 'startTimeError', 'Vui lòng chọn giờ bắt đầu');
                    isValid = false;
                }

                if (!endTime) {
                    showError('endTime', 'endTimeError', 'Vui lòng chọn giờ kết thúc');
                    isValid = false;
                }

                if (startTime && endTime && startTime >= endTime) {
                    showError('endTime', 'endTimeError', 'Giờ kết thúc phải sau giờ bắt đầu');
                    isValid = false;
                }

                // Update submit button
                submitBtn.disabled = !isValid;
                return isValid;
            }

            function showError(inputId, errorId, message) {
                const input = document.getElementById(inputId);
                const error = document.getElementById(errorId);
                input.classList.add('is-invalid');
                error.textContent = message;
                error.style.display = 'flex';
            }

            function clearErrors() {
                const inputs = ['availabilityDate', 'startTime', 'endTime'];
                const errors = ['dateError', 'startTimeError', 'endTimeError'];

                inputs.forEach(id => {
                    document.getElementById(id).classList.remove('is-invalid');
                });

                errors.forEach(id => {
                    const error = document.getElementById(id);
                    error.textContent = '';
                    error.style.display = 'none';
                });
            }

            // Add event listeners
            dateInput.addEventListener('change', validate);
            startTimeInput.addEventListener('change', validate);
            endTimeInput.addEventListener('change', validate);

            // Form submit validation
            document.getElementById('registerForm').addEventListener('submit', function(e) {
                if (!validate()) {
                    e.preventDefault();
                    return false;
                }

                // Show loading state
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang đăng ký...';
                submitBtn.disabled = true;
            });
        }
    </script>
</body>
</html>
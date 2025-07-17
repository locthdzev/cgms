<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.User"%>
<%@page import="Models.Payment"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.ZoneId"%>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    
    // Format tiền tệ
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    
    // Format thời gian
    SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lịch sử thanh toán - CGMS</title>
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/weightlifting.png" />
    <link rel="icon" type="image/png" href="assets/img/weightlifting.png">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="https://demos.creative-tim.com/argon-dashboard-pro/assets/css/nucleo-svg.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link id="pagestyle" href="assets/css/argon-dashboard.css?v=2.1.0" rel="stylesheet" />
</head>

<body class="g-sidenav-show bg-gray-100">
    <div class="min-height-300 bg-dark position-absolute w-100"></div>
    
    <!-- Sidebar -->
    <%@ include file="member_sidebar.jsp" %>
    
    <main class="main-content position-relative border-radius-lg">
        <!-- Navbar -->
        <jsp:include page="navbar.jsp">
            <jsp:param name="pageTitle" value="Lịch sử thanh toán" />
            <jsp:param name="parentPage" value="Trang chủ" />
            <jsp:param name="parentPageUrl" value="member-dashboard" />
            <jsp:param name="currentPage" value="Lịch sử thanh toán" />
        </jsp:include>
        
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="card-header pb-0">
                            <h6>Lịch sử thanh toán</h6>
                        </div>
                        <div class="card-body px-0 pt-0 pb-2">
                            <div class="table-responsive p-0">
                                <table class="table align-items-center mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">ID</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Ngày thanh toán</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Số tiền</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Phương thức</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Trạng thái</th>
                                            <th class="text-uppercase text-secondary text-xxs font-weight-bolder opacity-7">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (payments != null && !payments.isEmpty()) { 
                                            for (Payment payment : payments) { %>
                                                <tr>
                                                    <td>
                                                        <div class="d-flex px-3 py-1">
                                                            <div class="d-flex flex-column justify-content-center">
                                                                <h6 class="mb-0 text-sm"><%= payment.getId() %></h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex px-3 py-1">
                                                            <div class="d-flex flex-column justify-content-center">
                                                                <h6 class="mb-0 text-sm"><%= payment.getPaymentDate() != null ? dateFormatter.format(java.util.Date.from(payment.getPaymentDate())) : "N/A" %></h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex px-3 py-1">
                                                            <div class="d-flex flex-column justify-content-center">
                                                                <h6 class="mb-0 text-sm"><%= currencyFormatter.format(payment.getAmount()) %></h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex px-3 py-1">
                                                            <div class="d-flex flex-column justify-content-center">
                                                                <h6 class="mb-0 text-sm"><%= payment.getPaymentMethod() %></h6>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex px-3 py-1">
                                                            <span class="badge badge-sm bg-gradient-<%= "COMPLETED".equals(payment.getStatus()) ? "success" : "PENDING".equals(payment.getStatus()) ? "warning" : "danger" %>">
                                                                <%= payment.getStatus() %>
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex px-3 py-1">
                                                            <button type="button" class="btn btn-sm btn-info" data-payment-id="<%= payment.getId() %>">
                                                                Chi tiết
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            <% } 
                                        } else { %>
                                            <tr>
                                                <td colspan="6" class="text-center py-4">Không có dữ liệu thanh toán</td>
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
                            <div class="copyright text-center text-sm text-muted text-lg-start">
                                © <script>
                                    document.write(new Date().getFullYear())
                                </script> CGMS - Gym Management System
                            </div>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </main>
    
    <!-- Payment Detail Modal -->
    <div class="modal fade" id="paymentDetailModal" tabindex="-1" role="dialog" aria-labelledby="paymentDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="paymentDetailModalLabel">Chi tiết thanh toán</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="payment-details">
                        <p><strong>ID:</strong> <span id="modal-payment-id"></span></p>
                        <p><strong>Ngày thanh toán:</strong> <span id="modal-payment-date"></span></p>
                        <p><strong>Số tiền:</strong> <span id="modal-payment-amount"></span></p>
                        <p><strong>Phương thức:</strong> <span id="modal-payment-method"></span></p>
                        <p><strong>Trạng thái:</strong> <span id="modal-payment-status"></span></p>
                        <p><strong>Mã giao dịch:</strong> <span id="modal-transaction-id"></span></p>
                        <hr>
                        <p><strong>Thông tin gói tập:</strong></p>
                        <div id="package-info">
                            <p>Đang tải...</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn bg-gradient-secondary" data-bs-dismiss="modal">Đóng</button>
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
        // Kiểm tra Font Awesome
        document.addEventListener('DOMContentLoaded', function() {
            // Kiểm tra xem Font Awesome đã được tải đúng chưa
            if (typeof FontAwesome === 'undefined') {
                console.log('Font Awesome not loaded properly, reloading...');
                // Tải lại Font Awesome từ CDN
                var fontAwesomeLink = document.createElement('link');
                fontAwesomeLink.rel = 'stylesheet';
                fontAwesomeLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css';
                fontAwesomeLink.integrity = 'sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==';
                fontAwesomeLink.crossOrigin = 'anonymous';
                fontAwesomeLink.referrerPolicy = 'no-referrer';
                document.head.appendChild(fontAwesomeLink);
                
                // Tải lại script Font Awesome
                var fontAwesomeScript = document.createElement('script');
                fontAwesomeScript.src = 'https://kit.fontawesome.com/42d5adcbca.js';
                fontAwesomeScript.crossOrigin = 'anonymous';
                document.head.appendChild(fontAwesomeScript);
            }
            
            // Thêm event listener cho tất cả các nút chi tiết
            document.querySelectorAll('.btn-info[data-payment-id]').forEach(function(button) {
                button.addEventListener('click', function() {
                    var paymentId = this.getAttribute('data-payment-id');
                    showPaymentDetails(paymentId);
                });
            });
        });
        
        function showPaymentDetails(paymentId) {
            // Hiển thị modal trước để người dùng biết đang tải
            var modal = new bootstrap.Modal(document.getElementById('paymentDetailModal'));
            modal.show();
            
            // Đặt trạng thái đang tải
            document.getElementById('package-info').innerHTML = '<p>Đang tải dữ liệu...</p>';
            
            // Sử dụng đường dẫn tuyệt đối
            fetch(window.location.pathname + '/detail?id=' + paymentId)
                .then(function(response) {
                    console.log('Response status:', response.status);
                    if (!response.ok) {
                        return response.text().then(function(text) {
                            try {
                                // Thử phân tích JSON
                                var jsonError = JSON.parse(text);
                                throw new Error('Lỗi ' + response.status + ': ' + (jsonError.error || text));
                            } catch (e) {
                                // Nếu không phải JSON, trả về text
                                throw new Error('Lỗi ' + response.status + ': ' + text);
                            }
                        });
                    }
                    return response.text().then(function(text) {
                        console.log('Raw response text:', text);
                        try {
                            return JSON.parse(text);
                        } catch (e) {
                            console.error('JSON parse error:', e, text);
                            throw new Error('Lỗi phân tích JSON: ' + e.message);
                        }
                    });
                })
                .then(function(data) {
                    console.log('Data received:', data);
                    var payment = data.payment;
                    console.log('Payment object:', payment);
                    
                    // Populate modal with basic info
                    document.getElementById('modal-payment-id').textContent = payment.id || 'N/A';
                    document.getElementById('modal-payment-method').textContent = payment.paymentMethod || 'N/A';
                    document.getElementById('modal-payment-status').textContent = payment.status || 'N/A';
                    document.getElementById('modal-transaction-id').textContent = payment.transactionId || 'N/A';
                    
                    // Format date
                    try {
                        if (payment.paymentDate) {
                            var paymentDate = new Date(payment.paymentDate);
                            console.log('Payment date:', paymentDate);
                            if (!isNaN(paymentDate.getTime())) {
                                var formattedDate = paymentDate.toLocaleDateString('vi-VN') + ' ' + paymentDate.toLocaleTimeString('vi-VN');
                                document.getElementById('modal-payment-date').textContent = formattedDate;
                            } else {
                                document.getElementById('modal-payment-date').textContent = 'Ngày không hợp lệ';
                            }
                        } else {
                            document.getElementById('modal-payment-date').textContent = 'N/A';
                        }
                    } catch (e) {
                        console.error('Error formatting date:', e);
                        document.getElementById('modal-payment-date').textContent = 'Lỗi định dạng ngày';
                    }
                    
                    // Format currency
                    try {
                        if (payment.amount) {
                            var formatter = new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            });
                            document.getElementById('modal-payment-amount').textContent = formatter.format(payment.amount);
                        } else {
                            document.getElementById('modal-payment-amount').textContent = 'N/A';
                        }
                    } catch (e) {
                        console.error('Error formatting amount:', e);
                        document.getElementById('modal-payment-amount').textContent = 'Lỗi định dạng số tiền';
                    }
                    
                    // Package info
                    var packageHtml = '';
                    console.log('Member package:', payment.memberPackage);
                    try {
                        if (payment.memberPackage) {
                            var pkg = payment.memberPackage;
                            packageHtml = '<p><strong>Tên gói:</strong> ' + (pkg.packageName || 'N/A') + '</p>' +
                                         '<p><strong>Thời hạn:</strong> ' + (pkg.duration || 'N/A') + ' tháng</p>' +
                                         '<p><strong>Giá gốc:</strong> ' + formatter.format(pkg.price || 0) + '</p>';
                                         
                            // Thêm thông tin tổng giá nếu có
                            if (pkg.totalPrice) {
                                packageHtml += '<p><strong>Tổng giá sau giảm giá:</strong> ' + formatter.format(pkg.totalPrice) + '</p>';
                            }
                        } else {
                            packageHtml = '<p>Không có thông tin gói tập</p>';
                        }
                    } catch (e) {
                        console.error('Error formatting package info:', e);
                        packageHtml = '<p class="text-danger">Lỗi hiển thị thông tin gói tập: ' + e.message + '</p>';
                    }
                    document.getElementById('package-info').innerHTML = packageHtml;
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    document.getElementById('package-info').innerHTML = '<p class="text-danger">Lỗi: ' + error.message + '</p>';
                });
        }
    </script>
</body>
</html> 
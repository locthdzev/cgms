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
    <link rel="apple-touch-icon" sizes="76x76" href="assets/img/icons8-gym-96.png" />
    <link rel="icon" type="image/png" href="assets/img/icons8-gym-96.png">
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
                                                            <span class="badge badge-sm bg-gradient-success">
                                                                <%= "COMPLETED".equals(payment.getStatus()) ? "Đã hoàn thành" : 
                                                                    "PENDING".equals(payment.getStatus()) ? "Đang chờ" : 
                                                                    "FAILED".equals(payment.getStatus()) ? "Thất bại" : 
                                                                    "CANCELLED".equals(payment.getStatus()) ? "Đã hủy" : payment.getStatus() %>
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

    <!-- Core JS Files -->
    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="assets/js/plugins/perfect-scrollbar.min.js"></script>
    <script src="assets/js/plugins/smooth-scrollbar.min.js"></script>
    <script src="assets/js/plugins/chartjs.min.js"></script>
    
    <!-- Payment Detail Modal -->
    <div class="modal fade" id="paymentDetailModal" tabindex="-1" aria-labelledby="paymentDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="paymentDetailModalLabel">Chi tiết thanh toán</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="paymentDetailContent">
                    <!-- Payment details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <script>
        var win = navigator.platform.indexOf('Win') > -1;
        if (win && document.querySelector('#sidenav-scrollbar')) {
            var options = {
                damping: '0.5'
            }
            Scrollbar.init(document.querySelector('#sidenav-scrollbar'), options);
        }

        // Handle payment detail buttons
        document.querySelectorAll('[data-payment-id]').forEach(button => {
            button.addEventListener('click', function() {
                const paymentId = this.getAttribute('data-payment-id');
                
                // Show modal
                const modal = new bootstrap.Modal(document.getElementById('paymentDetailModal'));
                modal.show();
                
                // Load payment details
                fetch('payment-history/detail?id=' + paymentId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(result => {
                        console.log('Response:', result); // Debug log
                        
                        // Truy cập data từ result.payment
                        const data = result.payment;
                        
                        if (!data) {
                            throw new Error('No payment data found');
                        }
                        
                        const content = document.getElementById('paymentDetailContent');
                        
                        // Format tiền tệ - kiểm tra data.amount có tồn tại không
                        let formattedAmount = 'N/A';
                        if (data.amount && !isNaN(data.amount)) {
                            formattedAmount = new Intl.NumberFormat('vi-VN', {
                                style: 'currency', 
                                currency: 'VND'
                            }).format(data.amount);
                        }
                        
                        // Format ngày tháng - kiểm tra data.paymentDate có tồn tại không
                        let formattedDate = 'N/A';
                        if (data.paymentDate) {
                            try {
                                formattedDate = new Date(data.paymentDate).toLocaleString('vi-VN');
                            } catch (e) {
                                console.error('Date parsing error:', e);
                                formattedDate = data.paymentDate; // Fallback to raw string
                            }
                        }
                        
                        // Tạo HTML content
                        let html = '<div class="row">';
                        html += '<div class="col-md-6">';
                        html += '<p><strong>ID thanh toán:</strong> ' + (data.id || 'N/A') + '</p>';
                        html += '<p><strong>Số tiền:</strong> ' + formattedAmount + '</p>';
                        html += '<p><strong>Phương thức:</strong> ' + (data.paymentMethod || 'N/A') + '</p>';
                        html += '<p><strong>Trạng thái:</strong> <span class="badge bg-success">Đã hoàn thành</span></p>';
                        html += '</div>';
                        html += '<div class="col-md-6">';
                        html += '<p><strong>Ngày thanh toán:</strong> ' + formattedDate + '</p>';
                        html += '<p><strong>Mã giao dịch:</strong> ' + (data.transactionId || 'N/A') + '</p>';
                        
                        // Kiểm tra memberPackage data
                        if (data.memberPackage && data.memberPackage.packageName) {
                            html += '<p><strong>Gói tập:</strong> ' + data.memberPackage.packageName + '</p>';
                        }
                        
                        html += '</div>';
                        html += '</div>';
                        
                        content.innerHTML = html;
                    })
                    .catch(error => {
                        console.error('Error loading payment details:', error);
                        document.getElementById('paymentDetailContent').innerHTML = 
                            '<div class="alert alert-danger">Không thể tải thông tin chi tiết thanh toán: ' + error.message + '</div>';
                    });
            });
        });
    </script>

    <!-- Github buttons -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    <!-- Control Center for Soft Dashboard: parallax effects, scripts for the example pages etc -->
    <script src="assets/js/argon-dashboard.min.js?v=2.1.0"></script>
</body>
</html>
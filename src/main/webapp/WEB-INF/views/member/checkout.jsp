<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - CGMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <style>
        .payment-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .qr-container {
            text-align: center;
            margin: 20px 0;
        }
        .qr-code {
            max-width: 300px;
            margin: 0 auto;
        }
        .payment-info {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .payment-status {
            font-size: 18px;
            font-weight: bold;
            margin-top: 20px;
            text-align: center;
        }
        .countdown {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    
    <div class="container mt-5 mb-5">
        <div class="payment-container">
            <h2 class="text-center mb-4">Thanh toán gói tập</h2>
            
            <div class="payment-info">
                <h4>Thông tin gói tập</h4>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Tên gói:</strong> ${memberPackage.packageField.name}</p>
                        <p><strong>Thời hạn:</strong> ${memberPackage.packageField.duration} ngày</p>
                        <c:if test="${memberPackage.packageField.sessions != null}">
                            <p><strong>Số buổi tập:</strong> ${memberPackage.packageField.sessions}</p>
                        </c:if>
                        <p><strong>Ngày bắt đầu:</strong> ${memberPackage.startDate}</p>
                        <p><strong>Ngày kết thúc:</strong> ${memberPackage.endDate}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Giá gốc:</strong> <fmt:formatNumber value="${memberPackage.packageField.price}" type="currency" currencySymbol="₫"/></p>
                        
                        <c:if test="${memberPackage.voucher != null}">
                            <p><strong>Mã giảm giá:</strong> ${memberPackage.voucher.code}</p>
                            <p><strong>Giảm giá:</strong> 
                                <c:if test="${memberPackage.voucher.discountType == 'PERCENTAGE'}">
                                    ${memberPackage.voucher.discountValue}%
                                </c:if>
                                <c:if test="${memberPackage.voucher.discountType == 'FIXED'}">
                                    <fmt:formatNumber value="${memberPackage.voucher.discountValue}" type="currency" currencySymbol="₫"/>
                                </c:if>
                            </p>
                        </c:if>
                        
                        <p><strong>Tổng thanh toán:</strong> <fmt:formatNumber value="${memberPackage.totalPrice}" type="currency" currencySymbol="₫"/></p>
                    </div>
                </div>
            </div>
            
            <div class="qr-container">
                <h4>Quét mã QR để thanh toán</h4>
                <p>Thời gian còn lại: <span id="countdown" class="countdown">15:00</span></p>
                
                <div class="qr-code">
                    <c:if test="${not empty paymentLink}">
                        <img src="${paymentLink.qrCode}" alt="Mã QR thanh toán" class="img-fluid">
                    </c:if>
                    <c:if test="${empty paymentLink}">
                        <div class="alert alert-danger">Không thể tạo mã QR thanh toán. Vui lòng thử lại sau.</div>
                    </c:if>
                </div>
                
                <div class="payment-status mt-4" id="paymentStatus">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Đang chờ thanh toán...</span>
                    </div>
                    <p>Đang chờ thanh toán...</p>
                </div>
                
                <div class="mt-4">
                    <a href="${paymentLink.paymentLinkUrl}" target="_blank" class="btn btn-primary">Mở link thanh toán</a>
                    <a href="${pageContext.request.contextPath}/member-packages-controller" class="btn btn-outline-secondary ms-2">Hủy</a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp"/>
    
    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Đếm ngược 15 phút
            let totalSeconds = 15 * 60;
            const countdownElement = document.getElementById('countdown');
            
            const countdownInterval = setInterval(function() {
                const minutes = Math.floor(totalSeconds / 60);
                const seconds = totalSeconds % 60;
                
                countdownElement.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
                
                if (totalSeconds <= 0) {
                    clearInterval(countdownInterval);
                    countdownElement.textContent = "00:00";
                    $('#paymentStatus').html('<div class="alert alert-danger">Hết thời gian thanh toán</div>');
                }
                
                totalSeconds--;
            }, 1000);
            
            // Kiểm tra trạng thái thanh toán mỗi 5 giây
            const memberPackageId = ${memberPackage.id};
            const checkPaymentStatus = function() {
                $.ajax({
                    url: '${pageContext.request.contextPath}/payment/check-status',
                    method: 'GET',
                    data: { memberPackageId: memberPackageId },
                    success: function(response) {
                        if (response.status === 'COMPLETED') {
                            clearInterval(paymentCheckInterval);
                            clearInterval(countdownInterval);
                            $('#paymentStatus').html('<div class="alert alert-success">Thanh toán thành công!</div>');
                            
                            // Chuyển hướng sau 3 giây
                            setTimeout(function() {
                                window.location.href = '${pageContext.request.contextPath}/member-packages-controller?message=payment_success';
                            }, 3000);
                        } else if (response.status === 'CANCELLED') {
                            clearInterval(paymentCheckInterval);
                            $('#paymentStatus').html('<div class="alert alert-warning">Thanh toán đã bị hủy</div>');
                        }
                    },
                    error: function() {
                        console.log('Lỗi khi kiểm tra trạng thái thanh toán');
                    }
                });
            };
            
            const paymentCheckInterval = setInterval(checkPaymentStatus, 5000);
            
            // Kiểm tra ngay khi trang được tải
            checkPaymentStatus();
        });
    </script>
</body>
</html> 
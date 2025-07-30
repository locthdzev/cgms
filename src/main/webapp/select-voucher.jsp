<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Models.User" %>
<%@ page import="Models.Voucher" %>
<%@ page import="Models.MemberPackage" %>
<%@ page import="DAOs.VoucherDAO" %>
<%@ page import="DAOs.MemberPackageDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%!
    // Hàm định dạng phần trăm giảm giá (bỏ số 0 sau dấu phẩy)
    String formatDiscountPercent(BigDecimal value) {
        String formatted = value.stripTrailingZeros().toPlainString();
        return formatted;
    }
    
    // Hàm định dạng số tiền
    String formatCurrency(BigDecimal value) {
        return String.format("%,.0f", value);
    }
%>

<%
    // Kiểm tra người dùng đã đăng nhập chưa
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"Member".equals(loggedInUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Lấy memberPackageId từ session
    Integer memberPackageId = (Integer) session.getAttribute("checkoutMemberPackageId");
    if (memberPackageId == null) {
        response.sendRedirect(request.getContextPath() + "/member-packages-controller?error=invalid_session");
        return;
    }
    
    // Lấy thông tin gói tập
    MemberPackageDAO memberPackageDAO = new MemberPackageDAO();
    MemberPackage memberPackage = memberPackageDAO.getMemberPackageById(memberPackageId);
    if (memberPackage == null) {
        response.sendRedirect(request.getContextPath() + "/member-packages-controller?error=package_not_found");
        return;
    }
    
    // Lấy danh sách voucher hợp lệ
    VoucherDAO voucherDAO = new VoucherDAO();
    List<Voucher> validVouchers = voucherDAO.getValidVouchersForMember(loggedInUser.getId());
    
    // Lấy thông báo lỗi nếu có
    String error = request.getParameter("error");
    String errorMessage = "";
    if (error != null) {
        switch (error) {
            case "invalid_voucher":
                errorMessage = "Mã voucher không hợp lệ";
                break;
            case "expired_voucher":
                errorMessage = "Voucher đã hết hạn";
                break;
            case "unauthorized_voucher":
                errorMessage = "Bạn không được phép sử dụng voucher này";
                break;
            case "min_purchase_not_met":
                String minPurchase = request.getParameter("min");
                errorMessage = "Giá trị đơn hàng phải từ " + minPurchase + " VND trở lên để sử dụng voucher này";
                break;
            default:
                errorMessage = "Có lỗi xảy ra, vui lòng thử lại";
                break;
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CORE-FIT GYM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .container {
            padding-top: 30px;
            padding-bottom: 30px;
        }
        
        .card {
            border: none;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            border-radius: 0.75rem;
        }
        
        .card-header {
            border-top-left-radius: 0.75rem !important;
            border-top-right-radius: 0.75rem !important;
            background: linear-gradient(135deg, #0d6efd, #0a58ca);
        }
        
        .voucher-card {
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            background: #fff;
        }
        
        .voucher-card:hover {
            border-color: #0d6efd;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .voucher-card.selected {
            border-color: #0d6efd;
            background-color: #f0f7ff;
            box-shadow: 0 0 15px rgba(13, 110, 253, 0.25);
        }
        
        .voucher-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -5px;
            height: 100%;
            width: 10px;
            background: repeating-linear-gradient(
                0deg,
                #fff,
                #fff 5px,
                #f8f9fa 5px,
                #f8f9fa 10px
            );
        }
        
        .voucher-card::after {
            content: '';
            position: absolute;
            top: 0;
            right: -5px;
            height: 100%;
            width: 10px;
            background: repeating-linear-gradient(
                0deg,
                #fff,
                #fff 5px,
                #f8f9fa 5px,
                #f8f9fa 10px
            );
        }
        
        .discount-badge {
            font-size: 1.4rem;
            font-weight: bold;
            color: #dc3545;
            display: flex;
            align-items: center;
        }
        
        .discount-badge i {
            margin-right: 8px;
            font-size: 1.2rem;
        }
        
        .discount-info {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .voucher-code {
            background-color: #f8f9fa;
            border: 1px dashed #ced4da;
            border-radius: 5px;
            padding: 5px 10px;
            font-family: monospace;
            font-weight: bold;
            display: inline-block;
            margin-top: 10px;
        }
        
        .expiry-date {
            font-size: 0.85rem;
            color: #6c757d;
            display: flex;
            align-items: center;
            margin-top: 8px;
        }
        
        .expiry-date i {
            margin-right: 5px;
            color: #dc3545;
        }
        
        .min-purchase {
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            margin-top: 5px;
        }
        
        .min-purchase i {
            margin-right: 5px;
        }
        
        .voucher-card.disabled {
            cursor: not-allowed;
            opacity: 0.7;
        }
        
        .final-price {
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px dashed #ddd;
            font-weight: 500;
            color: #198754;
        }
        
        .final-price strong {
            font-size: 1.1rem;
        }
        
        .select-voucher-btn {
            border-radius: 50px;
            padding: 6px 15px;
            transition: all 0.3s;
        }
        
        .select-voucher-btn:hover {
            transform: scale(1.05);
        }
        
        .days-left {
            font-size: 0.75rem;
            background-color: #f8f9fa;
            border-radius: 20px;
            padding: 2px 8px;
            margin-left: 8px;
        }
        
        .urgent {
            color: #dc3545;
        }
        
        .summary-box {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 4px solid #0d6efd;
        }
        
        .summary-box p {
            margin-bottom: 8px;
        }
        
        .summary-box p:last-child {
            margin-bottom: 0;
        }
        
        .input-group .form-control {
            border-radius: 50px 0 0 50px;
            padding-left: 20px;
        }
        
        .input-group .btn {
            border-radius: 0 50px 50px 0;
            padding-right: 20px;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white py-3">
                        <h4 class="mb-0"><i class="fas fa-ticket-alt me-2"></i>Chọn Voucher</h4>
                    </div>
                    <div class="card-body p-4">
                        <% if (!errorMessage.isEmpty()) { %>
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <%= errorMessage %>
                            </div>
                        <% } %>
                        
                        <div class="summary-box mb-4">
                            <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>Thông tin thanh toán</h5>
                            <p><strong><i class="fas fa-dumbbell me-2"></i>Gói tập:</strong> <%= memberPackage.getPackageField().getName() %></p>
                            <p><strong><i class="fas fa-tag me-2"></i>Giá gốc:</strong> <%= formatCurrency(memberPackage.getTotalPrice()) %> VND</p>
                            <p id="discountAmount" style="display:none;" class="text-success"><strong><i class="fas fa-percentage me-2"></i>Giảm giá:</strong> <span class="fw-bold"></span></p>
                            <p id="discountedPrice" style="display:none;" class="text-danger"><strong><i class="fas fa-money-bill-wave me-2"></i>Giá sau khi giảm:</strong> <span class="fw-bold"></span></p>
                        </div>
                        
                        <form action="<%= request.getContextPath() %>/payment/process-payment" method="post" id="voucherForm">
                            <input type="hidden" name="memberPackageId" value="<%= memberPackageId %>" />
                            <div class="mb-4">
                                <h5 class="mb-3"><i class="fas fa-keyboard me-2"></i>Nhập mã voucher</h5>
                                <div class="input-group mb-3">
                                    <input type="text" class="form-control shadow-sm" name="voucherCode" id="voucherCodeInput" placeholder="Nhập mã voucher">
                                    <button class="btn btn-primary" type="button" id="applyVoucherBtn">
                                        <i class="fas fa-check me-1"></i>Áp dụng
                                    </button>
                                </div>
                            </div>
                            
                            <% if (!validVouchers.isEmpty()) { %>
                                <div class="mb-4">
                                    <h5 class="mb-3"><i class="fas fa-tags me-2"></i>Voucher có sẵn</h5>
                                    <div class="voucher-list">
                                        <% 
                                        BigDecimal totalPrice = memberPackage.getTotalPrice();
                                        for (Voucher voucher : validVouchers) { 
                                            boolean isEligible = voucher.getMinPurchase() == null || 
                                                                totalPrice.compareTo(voucher.getMinPurchase()) >= 0;
                                            String cardClass = isEligible ? "voucher-card" : "voucher-card disabled";
                                            
                                            // Tính số ngày còn lại
                                            long daysLeft = ChronoUnit.DAYS.between(LocalDate.now(), voucher.getExpiryDate());
                                            String daysLeftClass = daysLeft <= 7 ? "urgent" : "";
                                        %>
                                            <div class="<%= cardClass %>" data-voucher-code="<%= voucher.getCode() %>" 
                                                 data-discount-type="<%= voucher.getDiscountType() %>" 
                                                 data-discount-value="<%= voucher.getDiscountValue() %>"
                                                 data-eligible="<%= isEligible %>">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <div class="discount-badge">
                                                            <% if ("PERCENT".equals(voucher.getDiscountType()) || "Percent".equals(voucher.getDiscountType())) { %>
                                                                <i class="fas fa-percent"></i>
                                                                Giảm <%= formatDiscountPercent(voucher.getDiscountValue()) %>%
                                                                <% if (isEligible) { %>
                                                                    <span class="text-muted small ms-2">
                                                                        (-<%= formatCurrency(memberPackage.getTotalPrice().multiply(voucher.getDiscountValue()).divide(new BigDecimal(100))) %> VND)
                                                                    </span>
                                                                <% } %>
                                                            <% } else { %>
                                                                <i class="fas fa-money-bill-wave"></i>
                                                                -<%= formatCurrency(voucher.getDiscountValue()) %> VND
                                                            <% } %>
                                                        </div>
                                                        
                                                        <div class="voucher-code">
                                                            <i class="fas fa-barcode me-1"></i>
                                                            <%= voucher.getCode() %>
                                                        </div>
                                                        
                                                        <% if (voucher.getMinPurchase() != null) { %>
                                                            <div class="min-purchase <%= isEligible ? "text-success" : "text-danger" %>">
                                                                <i class="<%= isEligible ? "fas fa-check-circle" : "fas fa-exclamation-circle" %>"></i>
                                                                Đơn tối thiểu: <%= formatCurrency(voucher.getMinPurchase()) %> VND
                                                            </div>
                                                        <% } %>
                                                        
                                                        <div class="expiry-date">
                                                            <i class="far fa-calendar-alt"></i>
                                                            Hết hạn: <%= voucher.getExpiryDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
                                                            <span class="days-left <%= daysLeftClass %>">
                                                                <% if (daysLeft == 0) { %>
                                                                    Hết hạn hôm nay
                                                                <% } else { %>
                                                                    Còn <%= daysLeft %> ngày
                                                                <% } %>
                                                            </span>
                                                        </div>
                                                        
                                                        <% if (isEligible) { %>
                                                            <div class="final-price">
                                                                <% 
                                                                BigDecimal finalPrice = memberPackage.getTotalPrice();
                                                                if ("PERCENT".equals(voucher.getDiscountType()) || "Percent".equals(voucher.getDiscountType())) {
                                                                    BigDecimal discountAmount = memberPackage.getTotalPrice().multiply(voucher.getDiscountValue()).divide(new BigDecimal(100));
                                                                    finalPrice = memberPackage.getTotalPrice().subtract(discountAmount);
                                                                } else {
                                                                    finalPrice = memberPackage.getTotalPrice().subtract(voucher.getDiscountValue());
                                                                    if (finalPrice.compareTo(BigDecimal.ZERO) < 0) {
                                                                        finalPrice = BigDecimal.ZERO;
                                                                    }
                                                                }
                                                                %>
                                                                <i class="fas fa-hand-holding-usd me-1"></i>
                                                                Giá cuối: <strong><%= formatCurrency(finalPrice) %> VND</strong>
                                                            </div>
                                                        <% } %>
                                                    </div>
                                                    <div>
                                                        <button type="button" class="btn btn-outline-primary select-voucher-btn" 
                                                                <%= isEligible ? "" : "disabled" %>>
                                                            <i class="fas fa-check me-1"></i>Chọn
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        <% } %>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="alert alert-info d-flex align-items-center" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Hiện không có voucher nào khả dụng cho bạn.
                                </div>
                            <% } %>
                            
                            <div class="d-flex justify-content-between mt-4">
                                <a href="<%= request.getContextPath() %>/member-packages-controller" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-shopping-cart me-1"></i>Tiếp tục thanh toán
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const voucherCards = document.querySelectorAll('.voucher-card');
            const voucherCodeInput = document.getElementById('voucherCodeInput');
            const selectVoucherBtns = document.querySelectorAll('.select-voucher-btn');
            const applyVoucherBtn = document.getElementById('applyVoucherBtn');
            const discountedPriceElement = document.getElementById('discountedPrice');
            const discountedPriceSpan = discountedPriceElement.querySelector('span');
            const discountAmountElement = document.getElementById('discountAmount');
            const discountAmountSpan = discountAmountElement.querySelector('span');
            const originalPrice = parseFloat('<%= memberPackage.getTotalPrice() %>');
            
            // Hàm tính giá sau khi áp dụng voucher
            function calculateDiscountedPrice(discountType, discountValue) {
                let finalPrice = originalPrice;
                discountValue = parseFloat(discountValue);
                
                if ((discountType === 'PERCENT') || (discountType === 'Percent')) {
                    const discountAmount = originalPrice * (discountValue / 100);
                    finalPrice = originalPrice - discountAmount;
                } else if ((discountType === 'FIXED') || (discountType === 'Amount')) {
                    finalPrice = originalPrice - discountValue;
                    if (finalPrice < 0) {
                        finalPrice = 0;
                    }
                }
                
                return finalPrice;
            }
            
            // Hàm định dạng số tiền
            function formatCurrency(value) {
                return new Intl.NumberFormat('vi-VN').format(value) + ' VND';
            }
            
            // Hàm hiển thị giá sau khi giảm
            function updateDiscountedPrice(voucherCard) {
                if (!voucherCard || voucherCard.dataset.eligible === 'false') {
                    discountedPriceElement.style.display = 'none';
                    discountAmountElement.style.display = 'none';
                    return;
                }
                
                const discountType = voucherCard.dataset.discountType;
                const discountValue = parseFloat(voucherCard.dataset.discountValue);
                
                const finalPrice = calculateDiscountedPrice(discountType, discountValue);
                discountedPriceSpan.textContent = formatCurrency(finalPrice);
                discountedPriceElement.style.display = 'block';

                let discountAmount = 0;
                if ((discountType === 'PERCENT') || (discountType === 'Percent')) {
                    discountAmount = originalPrice * (discountValue / 100);
                } else if ((discountType === 'FIXED') || (discountType === 'Amount')) {
                    discountAmount = discountValue;
                }
                discountAmountSpan.textContent = '-' + formatCurrency(discountAmount);
                discountAmountElement.style.display = 'block';
            }
            
            // Xử lý khi click vào nút "Chọn" của voucher
            selectVoucherBtns.forEach(function(btn) {
                btn.addEventListener('click', function() {
                    if (this.disabled) return;
                    
                    const voucherCard = this.closest('.voucher-card');
                    const voucherCode = voucherCard.dataset.voucherCode;
                    
                    // Bỏ chọn tất cả các voucher khác
                    voucherCards.forEach(function(card) {
                        card.classList.remove('selected');
                    });
                    
                    // Chọn voucher hiện tại
                    voucherCard.classList.add('selected');
                    
                    // Cập nhật mã voucher vào input
                    voucherCodeInput.value = voucherCode;
                    
                    // Hiển thị giá sau khi giảm
                    updateDiscountedPrice(voucherCard);
                });
            });
            
            // Xử lý khi click vào thẻ voucher
            voucherCards.forEach(function(card) {
                card.addEventListener('click', function(e) {
                    if (this.dataset.eligible === 'false' || e.target.classList.contains('btn')) {
                        return;
                    }
                    
                    const voucherCode = this.dataset.voucherCode;
                    
                    // Bỏ chọn tất cả các voucher khác
                    voucherCards.forEach(function(c) {
                        c.classList.remove('selected');
                    });
                    
                    // Chọn voucher hiện tại
                    this.classList.add('selected');
                    
                    // Cập nhật mã voucher vào input
                    voucherCodeInput.value = voucherCode;
                    
                    // Hiển thị giá sau khi giảm
                    updateDiscountedPrice(this);
                });
            });
            
            // Xử lý khi click nút "Áp dụng"
            applyVoucherBtn.addEventListener('click', function() {
                const voucherCode = voucherCodeInput.value.trim();
                let selectedCard = null;
                
                if (voucherCode) {
                    // Bỏ chọn tất cả các voucher
                    voucherCards.forEach(function(card) {
                        if (card.dataset.voucherCode === voucherCode) {
                            if (card.dataset.eligible === 'true') {
                                card.classList.add('selected');
                                selectedCard = card;
                            }
                        } else {
                            card.classList.remove('selected');
                        }
                    });
                } else {
                    // Nếu không có mã voucher, bỏ chọn tất cả
                    voucherCards.forEach(function(card) {
                        card.classList.remove('selected');
                    });
                }
                
                // Hiển thị giá sau khi giảm
                updateDiscountedPrice(selectedCard);
            });
        });
    </script>
</body>
</html> 
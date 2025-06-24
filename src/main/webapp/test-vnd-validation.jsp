<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Utilities.VNDPriceValidator"%>
<%@page import="java.math.BigDecimal"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Test VND Price Validation - CGMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4><i class="fas fa-money-bill-wave me-2"></i>Test VND Price Validation</h4>
                    <small>Kiểm tra logic validation giá tiền VND cho gói tập</small>
                </div>
                <div class="card-body">
                    
                    <!-- Test Cases -->
                    <div class="row">
                        <div class="col-md-6">
                            <h6>✅ Test Cases Hợp Lệ:</h6>
                            <div class="list-group">
                                <%
                                String[] validPrices = {"50000", "100,000", "500000", "1,500,000", "10000000"};
                                for (String price : validPrices) {
                                    VNDPriceValidator.ValidationResult result = VNDPriceValidator.validatePriceString(price);
                                %>
                                <div class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span><strong><%= price %></strong></span>
                                        <% if (result.isValid()) { %>
                                            <span class="badge bg-success">
                                                <i class="fas fa-check"></i> <%= VNDPriceValidator.formatVNDWithUnit(result.getValidatedPrice()) %>
                                            </span>
                                        <% } else { %>
                                            <span class="badge bg-danger">
                                                <i class="fas fa-times"></i> <%= result.getErrorMessage() %>
                                            </span>
                                        <% } %>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <h6>❌ Test Cases Không Hợp Lệ:</h6>
                            <div class="list-group">
                                <%
                                String[] invalidPrices = {"0", "49999", "100000000000", "abc", "50.5", "45000"};
                                for (String price : invalidPrices) {
                                    VNDPriceValidator.ValidationResult result = VNDPriceValidator.validatePriceString(price);
                                %>
                                <div class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span><strong><%= price %></strong></span>
                                        <% if (result.isValid()) { %>
                                            <span class="badge bg-success">
                                                <i class="fas fa-check"></i> Valid
                                            </span>
                                        <% } else { %>
                                            <span class="badge bg-danger">
                                                <i class="fas fa-times"></i> <%= result.getErrorMessage() %>
                                            </span>
                                        <% } %>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Package Type Validation -->
                    <div class="mt-4">
                        <h6>🎯 Test Package Type Validation:</h6>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Giá</th>
                                        <th>Thời hạn (ngày)</th>
                                        <th>Số buổi</th>
                                        <th>Kết quả</th>
                                        <th>Thông báo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    Object[][] testCases = {
                                        {new BigDecimal("500000"), 30, 10},
                                        {new BigDecimal("100000"), 60, null},  // Too cheap for long duration
                                        {new BigDecimal("1000000"), 7, null},  // Too expensive for short duration
                                        {new BigDecimal("50000"), 5, 1},       // Too cheap per session
                                        {new BigDecimal("2000000"), 30, 5}     // Too expensive per session
                                    };
                                    
                                    for (Object[] testCase : testCases) {
                                        BigDecimal price = (BigDecimal) testCase[0];
                                        Integer duration = (Integer) testCase[1];
                                        Integer sessions = (Integer) testCase[2];
                                        
                                        VNDPriceValidator.ValidationResult result = 
                                            VNDPriceValidator.validatePriceForPackageType(price, duration, sessions);
                                    %>
                                    <tr>
                                        <td><%= VNDPriceValidator.formatVNDWithUnit(price) %></td>
                                        <td><%= duration %></td>
                                        <td><%= sessions != null ? sessions : "N/A" %></td>
                                        <td>
                                            <% if (result.isValid()) { %>
                                                <span class="badge bg-success"><i class="fas fa-check"></i> Hợp lệ</span>
                                            <% } else { %>
                                                <span class="badge bg-danger"><i class="fas fa-times"></i> Không hợp lệ</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (!result.isValid()) { %>
                                                <small class="text-danger"><%= result.getErrorMessage() %></small>
                                            <% } else { %>
                                                <small class="text-success">Giá hợp lý cho loại gói này</small>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <!-- Price Suggestions -->
                    <div class="mt-4">
                        <h6>💡 Test Price Suggestions:</h6>
                        <div class="row">
                            <%
                            Object[][] suggestionCases = {
                                {30, null},
                                {60, null},
                                {30, 12},
                                {90, 24}
                            };
                            
                            for (Object[] suggestionCase : suggestionCases) {
                                Integer duration = (Integer) suggestionCase[0];
                                Integer sessions = (Integer) suggestionCase[1];
                                String suggestion = VNDPriceValidator.suggestPrice(duration, sessions);
                            %>
                            <div class="col-md-6 mb-3">
                                <div class="card border-info">
                                    <div class="card-body">
                                        <h6 class="card-title">
                                            <i class="fas fa-calendar-alt me-2"></i><%= duration %> ngày
                                            <% if (sessions != null) { %>
                                                <i class="fas fa-dumbbell ms-2 me-1"></i><%= sessions %> buổi
                                            <% } %>
                                        </h6>
                                        <p class="card-text text-info"><%= suggestion %></p>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Interactive Test -->
                    <div class="mt-4">
                        <h6>🧪 Interactive Test:</h6>
                        <form id="testForm">
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="form-label">Giá (VNĐ):</label>
                                    <input type="text" class="form-control" id="testPrice" placeholder="Nhập giá...">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Thời hạn (ngày):</label>
                                    <input type="number" class="form-control" id="testDuration" placeholder="30">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Số buổi (tùy chọn):</label>
                                    <input type="number" class="form-control" id="testSessions" placeholder="12">
                                </div>
                            </div>
                            <div class="mt-3">
                                <button type="button" class="btn btn-primary" onclick="testValidation()">
                                    <i class="fas fa-play me-2"></i>Test Validation
                                </button>
                                <button type="button" class="btn btn-info" onclick="getSuggestion()">
                                    <i class="fas fa-lightbulb me-2"></i>Gợi ý giá
                                </button>
                            </div>
                            <div id="testResult" class="mt-3"></div>
                        </form>
                    </div>
                    
                    <div class="mt-4 text-center">
                        <a href="addPackage" class="btn btn-success me-2">
                            <i class="fas fa-plus me-2"></i>Test với form thật
                        </a>
                        <a href="listPackage" class="btn btn-secondary">
                            <i class="fas fa-list me-2"></i>Về danh sách gói
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function testValidation() {
    const price = document.getElementById('testPrice').value;
    const duration = document.getElementById('testDuration').value;
    const sessions = document.getElementById('testSessions').value;
    
    if (!price) {
        showResult('Vui lòng nhập giá', 'danger');
        return;
    }
    
    // Simple client-side validation (server-side is more comprehensive)
    const cleanPrice = price.replace(/[^\d]/g, '');
    const priceValue = parseInt(cleanPrice);
    
    if (isNaN(priceValue)) {
        showResult('Giá không hợp lệ', 'danger');
        return;
    }
    
    if (priceValue < 50000) {
        showResult('Giá tối thiểu là 50,000 VNĐ', 'danger');
        return;
    }
    
    if (priceValue > 100000000) {
        showResult('Giá tối đa là 100,000,000 VNĐ', 'danger');
        return;
    }
    
    if (priceValue % 1000 !== 0) {
        showResult('Giá nên là bội số của 1,000 VNĐ', 'warning');
        return;
    }
    
    showResult('Giá hợp lệ: ' + priceValue.toLocaleString('vi-VN') + ' VNĐ', 'success');
}

function getSuggestion() {
    const duration = parseInt(document.getElementById('testDuration').value) || 0;
    const sessions = parseInt(document.getElementById('testSessions').value) || 0;
    
    if (duration <= 0) {
        showResult('Vui lòng nhập thời hạn để có gợi ý giá', 'warning');
        return;
    }
    
    let suggestedPrice;
    
    if (sessions > 0) {
        suggestedPrice = sessions * 50000;
    } else {
        suggestedPrice = duration * 10000;
    }
    
    // Round up to nearest 10,000
    suggestedPrice = Math.ceil(suggestedPrice / 10000) * 10000;
    
    showResult('Gợi ý: ' + suggestedPrice.toLocaleString('vi-VN') + ' VNĐ', 'info');
    document.getElementById('testPrice').value = suggestedPrice.toLocaleString('vi-VN');
}

function showResult(message, type) {
    const resultDiv = document.getElementById('testResult');
    resultDiv.innerHTML = `<div class="alert alert-${type}">${message}</div>`;
}
</script>

</body>
</html>

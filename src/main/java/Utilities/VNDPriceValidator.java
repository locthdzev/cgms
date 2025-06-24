package Utilities;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.regex.Pattern;

/**
 * Utility class để xử lý và validate giá tiền theo chuẩn VND
 */
public class VNDPriceValidator {
    
    // Giá tối thiểu cho gói tập (50,000 VND)
    public static final BigDecimal MIN_PACKAGE_PRICE = new BigDecimal("50000");
    
    // Giá tối đa cho gói tập (100,000,000 VND = 100 triệu)
    public static final BigDecimal MAX_PACKAGE_PRICE = new BigDecimal("100000000");
    
    // Pattern để validate số tiền VND (chỉ chấp nhận số nguyên, không có phần thập phân)
    private static final Pattern VND_PRICE_PATTERN = Pattern.compile("^[1-9]\\d*$");
    
    // Formatter cho hiển thị tiền VND
    private static final DecimalFormat VND_FORMATTER = new DecimalFormat("#,###");
    
    /**
     * Validate chuỗi giá tiền đầu vào
     * @param priceStr Chuỗi giá tiền cần validate
     * @return ValidationResult chứa kết quả validation
     */
    public static ValidationResult validatePriceString(String priceStr) {
        ValidationResult result = new ValidationResult();
        
        // Kiểm tra null hoặc empty
        if (priceStr == null || priceStr.trim().isEmpty()) {
            result.setValid(false);
            result.setErrorMessage("Giá không được để trống");
            return result;
        }
        
        // Loại bỏ khoảng trắng và dấu phẩy (nếu user nhập có format)
        String cleanPrice = priceStr.trim().replaceAll("[,\\s]", "");
        
        // Kiểm tra format số
        if (!VND_PRICE_PATTERN.matcher(cleanPrice).matches()) {
            result.setValid(false);
            result.setErrorMessage("Giá phải là số nguyên dương (không có phần thập phân)");
            return result;
        }
        
        try {
            BigDecimal price = new BigDecimal(cleanPrice);
            return validatePriceValue(price);
        } catch (NumberFormatException e) {
            result.setValid(false);
            result.setErrorMessage("Giá không hợp lệ");
            return result;
        }
    }
    
    /**
     * Validate giá trị BigDecimal
     * @param price Giá trị cần validate
     * @return ValidationResult chứa kết quả validation
     */
    public static ValidationResult validatePriceValue(BigDecimal price) {
        ValidationResult result = new ValidationResult();
        
        if (price == null) {
            result.setValid(false);
            result.setErrorMessage("Giá không được null");
            return result;
        }
        
        // Kiểm tra giá tối thiểu
        if (price.compareTo(MIN_PACKAGE_PRICE) < 0) {
            result.setValid(false);
            result.setErrorMessage("Giá gói tập tối thiểu là " + formatVND(MIN_PACKAGE_PRICE) + " VNĐ");
            return result;
        }
        
        // Kiểm tra giá tối đa
        if (price.compareTo(MAX_PACKAGE_PRICE) > 0) {
            result.setValid(false);
            result.setErrorMessage("Giá gói tập tối đa là " + formatVND(MAX_PACKAGE_PRICE) + " VNĐ");
            return result;
        }
        
        // Kiểm tra phần thập phân (VND không có phần lẻ)
        if (price.scale() > 0 && price.remainder(BigDecimal.ONE).compareTo(BigDecimal.ZERO) != 0) {
            result.setValid(false);
            result.setErrorMessage("Giá VND không được có phần thập phân");
            return result;
        }
        
        // Kiểm tra tính hợp lý của giá (phải chia hết cho 1000)
        if (price.remainder(new BigDecimal("1000")).compareTo(BigDecimal.ZERO) != 0) {
            result.setValid(false);
            result.setErrorMessage("Giá nên là bội số của 1,000 VNĐ để dễ thanh toán");
            return result;
        }
        
        result.setValid(true);
        result.setValidatedPrice(price);
        return result;
    }
    
    /**
     * Parse chuỗi giá thành BigDecimal
     * @param priceStr Chuỗi giá cần parse
     * @return BigDecimal hoặc null nếu không parse được
     */
    public static BigDecimal parsePrice(String priceStr) {
        ValidationResult result = validatePriceString(priceStr);
        return result.isValid() ? result.getValidatedPrice() : null;
    }
    
    /**
     * Format giá tiền theo chuẩn VND
     * @param price Giá cần format
     * @return Chuỗi đã format (ví dụ: "1,500,000")
     */
    public static String formatVND(BigDecimal price) {
        if (price == null) return "0";
        return VND_FORMATTER.format(price);
    }
    
    /**
     * Format giá tiền với đơn vị VNĐ
     * @param price Giá cần format
     * @return Chuỗi đã format với đơn vị (ví dụ: "1,500,000 VNĐ")
     */
    public static String formatVNDWithUnit(BigDecimal price) {
        return formatVND(price) + " VNĐ";
    }
    
    /**
     * Kiểm tra giá có phù hợp cho loại gói tập không
     * @param price Giá cần kiểm tra
     * @param duration Thời hạn gói (ngày)
     * @param sessions Số buổi tập (có thể null)
     * @return ValidationResult với thông tin chi tiết
     */
    public static ValidationResult validatePriceForPackageType(BigDecimal price, Integer duration, Integer sessions) {
        ValidationResult result = validatePriceValue(price);
        if (!result.isValid()) {
            return result;
        }
        
        // Tính giá trung bình mỗi ngày
        BigDecimal pricePerDay = price.divide(new BigDecimal(duration), 2, BigDecimal.ROUND_HALF_UP);
        
        // Giá quá thấp cho thời hạn dài
        if (duration > 30 && pricePerDay.compareTo(new BigDecimal("5000")) < 0) {
            result.setValid(false);
            result.setErrorMessage("Giá quá thấp cho gói tập dài hạn (tối thiểu 5,000 VNĐ/ngày)");
            return result;
        }
        
        // Giá quá cao cho thời hạn ngắn
        if (duration <= 7 && pricePerDay.compareTo(new BigDecimal("50000")) > 0) {
            result.setValid(false);
            result.setErrorMessage("Giá quá cao cho gói tập ngắn hạn (tối đa 50,000 VNĐ/ngày)");
            return result;
        }
        
        // Nếu có số buổi tập, kiểm tra giá mỗi buổi
        if (sessions != null && sessions > 0) {
            BigDecimal pricePerSession = price.divide(new BigDecimal(sessions), 2, BigDecimal.ROUND_HALF_UP);
            
            if (pricePerSession.compareTo(new BigDecimal("20000")) < 0) {
                result.setValid(false);
                result.setErrorMessage("Giá quá thấp cho số buổi tập (tối thiểu 20,000 VNĐ/buổi)");
                return result;
            }
            
            if (pricePerSession.compareTo(new BigDecimal("200000")) > 0) {
                result.setValid(false);
                result.setErrorMessage("Giá quá cao cho số buổi tập (tối đa 200,000 VNĐ/buổi)");
                return result;
            }
        }
        
        result.setValid(true);
        return result;
    }
    
    /**
     * Gợi ý giá hợp lý dựa trên thời hạn và số buổi
     * @param duration Thời hạn (ngày)
     * @param sessions Số buổi (có thể null)
     * @return Chuỗi gợi ý giá
     */
    public static String suggestPrice(Integer duration, Integer sessions) {
        if (duration == null || duration <= 0) {
            return "Vui lòng nhập thời hạn để có gợi ý giá";
        }
        
        BigDecimal suggestedPrice;
        
        if (sessions != null && sessions > 0) {
            // Tính theo số buổi: 50,000 VNĐ/buổi
            suggestedPrice = new BigDecimal(sessions).multiply(new BigDecimal("50000"));
        } else {
            // Tính theo ngày: 10,000 VNĐ/ngày
            suggestedPrice = new BigDecimal(duration).multiply(new BigDecimal("10000"));
        }
        
        // Làm tròn lên đến bội số của 10,000
        BigDecimal roundUp = new BigDecimal("10000");
        suggestedPrice = suggestedPrice.divide(roundUp, 0, BigDecimal.ROUND_UP).multiply(roundUp);
        
        return "Gợi ý: " + formatVNDWithUnit(suggestedPrice);
    }
    
    /**
     * Class chứa kết quả validation
     */
    public static class ValidationResult {
        private boolean valid;
        private String errorMessage;
        private BigDecimal validatedPrice;
        
        public ValidationResult() {
            this.valid = false;
        }
        
        public boolean isValid() {
            return valid;
        }
        
        public void setValid(boolean valid) {
            this.valid = valid;
        }
        
        public String getErrorMessage() {
            return errorMessage;
        }
        
        public void setErrorMessage(String errorMessage) {
            this.errorMessage = errorMessage;
        }
        
        public BigDecimal getValidatedPrice() {
            return validatedPrice;
        }
        
        public void setValidatedPrice(BigDecimal validatedPrice) {
            this.validatedPrice = validatedPrice;
        }
    }
}

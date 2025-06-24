package Utilities;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.Locale;

/**
 * Utility class để xử lý định dạng tiền tệ VND
 * Sử dụng dấu chấm (.) làm phân cách hàng nghìn theo chuẩn Việt Nam
 * 
 * @author Admin
 */
public class VNDUtils {
    
    // Định dạng VND chuẩn: 1.000.000 (dấu chấm phân cách hàng nghìn, không có số thập phân)
    private static final DecimalFormat VND_FORMAT;
    
    // Giá trị tối thiểu và tối đa cho gói tập gym (VND)
    public static final BigDecimal MIN_PRICE = new BigDecimal("10000");      // 10.000 VND
    public static final BigDecimal MAX_PRICE = new BigDecimal("50000000");   // 50.000.000 VND
    
    static {
        // Tạo DecimalFormatSymbols với dấu chấm làm phân cách hàng nghìn
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(','); // Không sử dụng nhưng set để tránh lỗi
        
        // Tạo format với pattern không có số thập phân
        VND_FORMAT = new DecimalFormat("#,##0", symbols);
        VND_FORMAT.setGroupingUsed(true);
        VND_FORMAT.setGroupingSize(3);
    }
    
    /**
     * Định dạng số tiền thành chuỗi VND chuẩn
     * Ví dụ: 1000000 -> "1.000.000"
     * 
     * @param amount Số tiền cần định dạng
     * @return Chuỗi đã định dạng theo chuẩn VND
     */
    public static String formatVND(BigDecimal amount) {
        if (amount == null) {
            return "0";
        }
        return VND_FORMAT.format(amount);
    }
    
    /**
     * Định dạng số tiền thành chuỗi VND chuẩn với đơn vị
     * Ví dụ: 1000000 -> "1.000.000 VNĐ"
     * 
     * @param amount Số tiền cần định dạng
     * @return Chuỗi đã định dạng theo chuẩn VND kèm đơn vị
     */
    public static String formatVNDWithUnit(BigDecimal amount) {
        return formatVND(amount) + " VNĐ";
    }
    
    /**
     * Parse chuỗi VND thành BigDecimal
     * Hỗ trợ các định dạng: "1.000.000", "1000000", "1.000.000 VNĐ"
     * 
     * @param vndString Chuỗi VND cần parse
     * @return BigDecimal tương ứng
     * @throws ParseException Nếu chuỗi không hợp lệ
     */
    public static BigDecimal parseVND(String vndString) throws ParseException {
        if (vndString == null || vndString.trim().isEmpty()) {
            throw new ParseException("Chuỗi VND không được để trống", 0);
        }
        
        // Loại bỏ khoảng trắng và đơn vị VNĐ
        String cleanString = vndString.trim()
                .replace("VNĐ", "")
                .replace("VND", "")
                .replace("đ", "")
                .trim();
        
        // Nếu chuỗi chỉ chứa số (không có dấu chấm phân cách)
        if (cleanString.matches("\\d+")) {
            return new BigDecimal(cleanString);
        }
        
        // Nếu chuỗi có dấu chấm phân cách
        if (cleanString.matches("[\\d\\.]+")) {
            // Loại bỏ tất cả dấu chấm phân cách
            String numberString = cleanString.replace(".", "");
            return new BigDecimal(numberString);
        }
        
        throw new ParseException("Định dạng VND không hợp lệ: " + vndString, 0);
    }
    
    /**
     * Kiểm tra tính hợp lệ của giá tiền
     * 
     * @param amount Số tiền cần kiểm tra
     * @return true nếu hợp lệ, false nếu không
     */
    public static boolean isValidPrice(BigDecimal amount) {
        if (amount == null) {
            return false;
        }
        
        return amount.compareTo(MIN_PRICE) >= 0 && amount.compareTo(MAX_PRICE) <= 0;
    }
    
    /**
     * Kiểm tra tính hợp lệ của chuỗi VND
     * 
     * @param vndString Chuỗi VND cần kiểm tra
     * @return true nếu hợp lệ, false nếu không
     */
    public static boolean isValidVNDString(String vndString) {
        try {
            BigDecimal amount = parseVND(vndString);
            return isValidPrice(amount);
        } catch (ParseException e) {
            return false;
        }
    }
    
    /**
     * Lấy thông báo lỗi cho giá tiền không hợp lệ
     * 
     * @param amount Số tiền
     * @return Thông báo lỗi tiếng Việt
     */
    public static String getValidationMessage(BigDecimal amount) {
        if (amount == null) {
            return "Giá tiền không được để trống";
        }
        
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            return "Giá tiền phải lớn hơn 0";
        }
        
        if (amount.compareTo(MIN_PRICE) < 0) {
            return "Giá tiền tối thiểu là " + formatVNDWithUnit(MIN_PRICE);
        }
        
        if (amount.compareTo(MAX_PRICE) > 0) {
            return "Giá tiền tối đa là " + formatVNDWithUnit(MAX_PRICE);
        }
        
        return null; // Hợp lệ
    }
    
    /**
     * Lấy thông báo lỗi cho chuỗi VND không hợp lệ
     * 
     * @param vndString Chuỗi VND
     * @return Thông báo lỗi tiếng Việt
     */
    public static String getValidationMessage(String vndString) {
        if (vndString == null || vndString.trim().isEmpty()) {
            return "Giá tiền không được để trống";
        }
        
        try {
            BigDecimal amount = parseVND(vndString);
            return getValidationMessage(amount);
        } catch (ParseException e) {
            return "Định dạng giá tiền không hợp lệ. Vui lòng nhập số tiền hợp lệ (ví dụ: 1.000.000)";
        }
    }
    
    /**
     * Chuyển đổi số nguyên thành BigDecimal
     * 
     * @param amount Số nguyên
     * @return BigDecimal tương ứng
     */
    public static BigDecimal toBigDecimal(long amount) {
        return new BigDecimal(amount);
    }
    
    /**
     * Chuyển đổi chuỗi số thành BigDecimal với validation
     * 
     * @param amountString Chuỗi số
     * @return BigDecimal tương ứng
     * @throws NumberFormatException Nếu chuỗi không phải là số hợp lệ
     */
    public static BigDecimal toBigDecimal(String amountString) throws NumberFormatException {
        if (amountString == null || amountString.trim().isEmpty()) {
            throw new NumberFormatException("Chuỗi số không được để trống");
        }
        
        try {
            return new BigDecimal(amountString.trim());
        } catch (NumberFormatException e) {
            throw new NumberFormatException("Chuỗi không phải là số hợp lệ: " + amountString);
        }
    }
}

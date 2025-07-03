package Services;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import DAOs.VoucherDAO;
import Models.Voucher;

public class VoucherService {

    private final VoucherDAO voucherDAO = new VoucherDAO();

    public List<Voucher> getAllVouchers() {
        return voucherDAO.getAllVouchers();
    }

    public Voucher getVoucherById(int id) {
        return voucherDAO.getVoucherById(id);
    }

    public void saveVoucher(Voucher voucher) {
        voucherDAO.saveVoucher(voucher);
    }

    public void updateVoucher(Voucher voucher) {
        voucherDAO.updateVoucher(voucher);
    }

    public void deleteVoucher(int id) {
        voucherDAO.deleteVoucher(id);
    }

    /**
     * Validate voucher data before saving/updating
     *
     * @param voucher The voucher to validate
     * @return List of error messages, empty if valid
     */
    public List<String> validateVoucher(Voucher voucher) {
        List<String> errors = new ArrayList<>();

        // Validate code
        if (voucher.getCode() == null || voucher.getCode().trim().isEmpty()) {
            errors.add("Mã voucher không được để trống");
        } else {
            if (voucher.getCode().length() > 20) {
                errors.add("Mã voucher không được vượt quá 20 ký tự");
            }
            if (!voucher.getCode().matches("^[A-Za-z0-9_-]+$")) {
                errors.add("Mã voucher chỉ được chứa chữ cái, số, dấu gạch dưới và dấu gạch ngang");
            }
            // Check if code already exists (for new vouchers or different voucher)
            if (isCodeExists(voucher.getCode(), voucher.getId())) {
                errors.add("Mã voucher đã tồn tại");
            }
        }

        // Validate discount value
        if (voucher.getDiscountValue() == null) {
            errors.add("Giá trị giảm không được để trống");
        } else {
            if (voucher.getDiscountValue().compareTo(BigDecimal.ZERO) < 0) {
                errors.add("Giá trị giảm không được âm");
            } else if (voucher.getDiscountValue().compareTo(BigDecimal.ZERO) == 0) {
                if ("Percent".equals(voucher.getDiscountType())) {
                    errors.add("Giá trị giảm phần trăm phải lớn hơn 0");
                } else if ("Amount".equals(voucher.getDiscountType())) {
                    errors.add("Giá trị giảm tiền cố định phải lớn hơn 0");
                } else {
                    errors.add("Giá trị giảm phải lớn hơn 0");
                }
            }

            if ("Percent".equals(voucher.getDiscountType())
                    && voucher.getDiscountValue().compareTo(new BigDecimal("100")) > 0) {
                errors.add("Giá trị giảm theo phần trăm không được vượt quá 100%");
            }

            if (voucher.getDiscountValue().compareTo(new BigDecimal("999999999.99")) > 0) {
                errors.add("Giá trị giảm quá lớn");
            }
        }

        // Validate discount type
        if (voucher.getDiscountType() == null || voucher.getDiscountType().trim().isEmpty()) {
            errors.add("Loại giảm giá không được để trống");
        } else {
            if (!voucher.getDiscountType().equals("Percent") && !voucher.getDiscountType().equals("Amount")) {
                errors.add("Loại giảm giá không hợp lệ");
            }
        }

        // Validate min purchase (optional field)
        if (voucher.getMinPurchase() != null) {
            if (voucher.getMinPurchase().compareTo(BigDecimal.ZERO) < 0) {
                errors.add("Giá trị đơn hàng tối thiểu không được âm");
            }
            if (voucher.getMinPurchase().compareTo(new BigDecimal("999999999.99")) > 0) {
                errors.add("Giá trị đơn hàng tối thiểu quá lớn");
            }
        }

        // Validate expiry date
        if (voucher.getExpiryDate() == null) {
            errors.add("Ngày hết hạn không được để trống");
        } else {
            if (voucher.getExpiryDate().isBefore(LocalDate.now())) {
                errors.add("Ngày hết hạn phải từ hôm nay trở đi");
            }
        }

        // Validate status
        if (voucher.getStatus() == null || voucher.getStatus().trim().isEmpty()) {
            errors.add("Trạng thái không được để trống");
        } else {
            if (!voucher.getStatus().equals("Active") && !voucher.getStatus().equals("Inactive")) {
                errors.add("Trạng thái không hợp lệ");
            }
        }

        return errors;
    }

    /**
     * Check if voucher code already exists
     *
     * @param code The code to check
     * @param currentVoucherId The current voucher ID (null for new voucher)
     * @return true if code exists, false otherwise
     */
    private boolean isCodeExists(String code, Integer currentVoucherId) {
        try {
            List<Voucher> allVouchers = voucherDAO.getAllVouchers();
            for (Voucher v : allVouchers) {
                if (v.getCode().equals(code)
                        && (currentVoucherId == null || !v.getId().equals(currentVoucherId))) {
                    return true;
                }
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }
}

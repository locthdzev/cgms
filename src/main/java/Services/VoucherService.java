package Services;

import DAOs.VoucherDAO;
import Models.Voucher;

import java.util.List;

public class VoucherService {
    private VoucherDAO voucherDAO = new VoucherDAO();

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
}
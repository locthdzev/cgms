package Services;

import DAOs.MemberPackageDAO;
import Models.MemberPackage;
import java.time.LocalDate;
import java.util.List;

public class MemberPackageService {
    private MemberPackageDAO memberPackageDAO = new MemberPackageDAO();

    /**
     * Lấy gói tập hiện tại đang hoạt động của member
     */
    public MemberPackage getCurrentActivePackage(int memberId) {
        try {
            List<MemberPackage> memberPackages = memberPackageDAO.getMemberPackagesByMemberId(memberId);

            LocalDate today = LocalDate.now();

            // Tìm gói tập đang hoạt động (chưa hết hạn và có status Active)
            for (MemberPackage memberPackage : memberPackages) {
                if ("Active".equals(memberPackage.getStatus()) &&
                        memberPackage.getEndDate().isAfter(today)) {
                    return memberPackage;
                }
            }

            return null; // Không có gói tập nào đang hoạt động
        } catch (Exception e) {
            System.err.println("Error getting current active package: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Lấy tất cả gói tập của member
     */
    public List<MemberPackage> getMemberPackages(int memberId) {
        try {
            return memberPackageDAO.getMemberPackagesByMemberId(memberId);
        } catch (Exception e) {
            System.err.println("Error getting member packages: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
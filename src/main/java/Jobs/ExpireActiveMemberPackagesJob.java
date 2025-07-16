package Jobs;

import DAOs.MemberPackageDAO;
import DbConnection.DbConnection;
import Models.MemberPackage;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Job để tự động cập nhật trạng thái các gói tập ACTIVE đã hết hạn (EndDate <
 * ngày hiện tại)
 */
public class ExpireActiveMemberPackagesJob implements Job {
    private static final Logger LOGGER = Logger.getLogger(ExpireActiveMemberPackagesJob.class.getName());
    private final MemberPackageDAO memberPackageDAO;

    public ExpireActiveMemberPackagesJob() {
        this.memberPackageDAO = new MemberPackageDAO();
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        String jobName = this.getClass().getSimpleName();
        Instant startTime = JobLogger.logJobStart(jobName);

        try {
            // In ra thời gian hiện tại để debug
            LocalDate today = LocalDate.now();
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LOGGER.info("Ngày hiện tại: " + today.format(dateFormatter));

            // Lấy danh sách các gói tập ACTIVE đã hết hạn
            List<MemberPackage> expiredActivePackages = getExpiredActiveMemberPackages();

            if (expiredActivePackages.isEmpty()) {
                LOGGER.info("Không có gói tập ACTIVE nào hết hạn");
                JobLogger.logJobSuccess(jobName, startTime, "Không có gói tập ACTIVE nào hết hạn");
                return;
            }

            LOGGER.info("Tìm thấy " + expiredActivePackages.size() + " gói tập ACTIVE đã hết hạn");

            // Cập nhật trạng thái của các gói tập đã hết hạn
            int updatedCount = 0;
            for (MemberPackage memberPackage : expiredActivePackages) {
                boolean updated = memberPackageDAO.updateMemberPackageStatus(memberPackage.getId(), "EXPIRED");
                if (updated) {
                    LOGGER.info("Đã cập nhật trạng thái gói tập ID " + memberPackage.getId() + " thành EXPIRED");
                    updatedCount++;
                } else {
                    LOGGER.warning("Không thể cập nhật trạng thái gói tập ID " + memberPackage.getId());
                }
            }

            String message = "Đã cập nhật " + updatedCount + "/" + expiredActivePackages.size()
                    + " gói tập ACTIVE thành EXPIRED";
            LOGGER.info("Hoàn thành kiểm tra và cập nhật các gói tập ACTIVE đã hết hạn");
            JobLogger.logJobSuccess(jobName, startTime, message);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xử lý các gói tập ACTIVE đã hết hạn", e);
            JobLogger.logJobFailure(jobName, startTime, e);
            throw new JobExecutionException(e);
        }
    }

    /**
     * Lấy danh sách các gói tập ACTIVE đã hết hạn (EndDate < ngày hiện tại)
     * 
     * @return Danh sách các gói tập ACTIVE đã hết hạn
     */
    private List<MemberPackage> getExpiredActiveMemberPackages() {
        List<MemberPackage> expiredPackages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();

            // Lấy các gói tập ACTIVE để kiểm tra
            String sql = "SELECT mp.MemberPackageId, mp.Status, mp.EndDate FROM Member_Packages mp " +
                    "WHERE mp.Status = 'ACTIVE'";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            // Ngày hiện tại
            LocalDate today = LocalDate.now();

            while (rs.next()) {
                int memberPackageId = rs.getInt("MemberPackageId");
                Date endDate = rs.getDate("EndDate");

                if (endDate != null) {
                    LocalDate packageEndDate = endDate.toLocalDate();

                    // Log thông tin để debug
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    LOGGER.info("Gói tập ID " + memberPackageId +
                            ", Ngày hết hạn: " + packageEndDate.format(formatter) +
                            ", Ngày hiện tại: " + today.format(formatter));

                    // Nếu EndDate < ngày hiện tại
                    if (packageEndDate.isBefore(today)) {
                        MemberPackage memberPackage = new MemberPackage();
                        memberPackage.setId(memberPackageId);
                        memberPackage.setStatus(rs.getString("Status"));
                        memberPackage.setEndDate(packageEndDate);
                        expiredPackages.add(memberPackage);

                        LOGGER.info("Gói tập ID " + memberPackageId + " đã hết hạn sử dụng");
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách gói tập ACTIVE đã hết hạn", e);
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối database", e);
            }
        }

        return expiredPackages;
    }
}
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
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Job để tự động cập nhật trạng thái các gói tập PENDING đã quá thời gian chờ
 * thanh toán
 */
public class ExpirePendingMemberPackagesJob implements Job {
    private static final Logger LOGGER = Logger.getLogger(ExpirePendingMemberPackagesJob.class.getName());
    private static final int PAYMENT_EXPIRATION_MINUTES = 3; // Thời gian hết hạn thanh toán (phút)
    private final MemberPackageDAO memberPackageDAO;

    public ExpirePendingMemberPackagesJob() {
        this.memberPackageDAO = new MemberPackageDAO();
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        String jobName = this.getClass().getSimpleName();
        Instant startTime = JobLogger.logJobStart(jobName);

        try {
            // In ra thời gian hiện tại để debug
            Instant now = Instant.now();
            LocalDateTime nowDateTime = LocalDateTime.ofInstant(now, ZoneId.systemDefault());
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LOGGER.info("Thời gian hiện tại: " + nowDateTime.format(formatter));

            // Lấy danh sách các gói tập PENDING đã hết hạn thanh toán
            List<MemberPackage> expiredPendingPackages = getExpiredPendingMemberPackages();

            if (expiredPendingPackages.isEmpty()) {
                LOGGER.info("Không có gói tập PENDING nào hết hạn thanh toán");
                JobLogger.logJobSuccess(jobName, startTime, "Không có gói tập PENDING nào hết hạn thanh toán");
                return;
            }

            LOGGER.info("Tìm thấy " + expiredPendingPackages.size() + " gói tập PENDING đã hết hạn thanh toán");

            // Cập nhật trạng thái của các gói tập đã hết hạn thanh toán
            int updatedCount = 0;
            for (MemberPackage memberPackage : expiredPendingPackages) {
                boolean updated = memberPackageDAO.updateMemberPackageStatus(memberPackage.getId(), "PAYMENT_EXPIRED");
                if (updated) {
                    LOGGER.info(
                            "Đã cập nhật trạng thái gói tập ID " + memberPackage.getId() + " thành PAYMENT_EXPIRED");
                    updatedCount++;
                } else {
                    LOGGER.warning("Không thể cập nhật trạng thái gói tập ID " + memberPackage.getId());
                }
            }

            String message = "Đã cập nhật " + updatedCount + "/" + expiredPendingPackages.size()
                    + " gói tập PENDING thành PAYMENT_EXPIRED";
            LOGGER.info("Hoàn thành kiểm tra và cập nhật các gói tập PENDING đã hết hạn thanh toán");
            JobLogger.logJobSuccess(jobName, startTime, message);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xử lý các gói tập PENDING đã hết hạn thanh toán", e);
            JobLogger.logJobFailure(jobName, startTime, e);
            throw new JobExecutionException(e);
        }
    }

    /**
     * Lấy danh sách các gói tập PENDING đã quá thời gian chờ thanh toán
     * 
     * @return Danh sách các gói tập PENDING đã hết hạn thanh toán
     */
    private List<MemberPackage> getExpiredPendingMemberPackages() {
        List<MemberPackage> expiredPackages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();

            // Lấy tất cả các gói tập PENDING để kiểm tra
            String sql = "SELECT mp.MemberPackageId, mp.Status, mp.CreatedAt FROM Member_Packages mp " +
                    "WHERE mp.Status = 'PENDING'";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            // Thời gian hiện tại
            Instant now = Instant.now();

            while (rs.next()) {
                int memberPackageId = rs.getInt("MemberPackageId");
                Timestamp createdAt = rs.getTimestamp("CreatedAt");

                if (createdAt != null) {
                    Instant createdInstant = createdAt.toInstant();

                    // Tính khoảng thời gian từ lúc tạo đến hiện tại (phút)
                    long minutesElapsed = ChronoUnit.MINUTES.between(createdInstant, now);

                    // Log thông tin để debug
                    LocalDateTime createdDateTime = LocalDateTime.ofInstant(createdInstant, ZoneId.systemDefault());
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                    LOGGER.info("Gói tập ID " + memberPackageId +
                            ", Thời gian tạo: " + createdDateTime.format(formatter) +
                            ", Đã qua: " + minutesElapsed + " phút");

                    // Nếu đã quá thời gian chờ thanh toán
                    if (minutesElapsed > PAYMENT_EXPIRATION_MINUTES) {
                        MemberPackage memberPackage = new MemberPackage();
                        memberPackage.setId(memberPackageId);
                        memberPackage.setStatus(rs.getString("Status"));
                        expiredPackages.add(memberPackage);

                        LOGGER.info("Gói tập ID " + memberPackageId + " đã hết hạn thanh toán");
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách gói tập PENDING đã hết hạn thanh toán", e);
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
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
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import Models.Package;

/**
 * Job để tự động cập nhật RemainingSessions của Member_Packages dựa trên thời
 * gian còn lại
 */
public class UpdateRemainingSessionsJob implements Job {
    private static final Logger LOGGER = Logger.getLogger(UpdateRemainingSessionsJob.class.getName());
    private final MemberPackageDAO memberPackageDAO;

    public UpdateRemainingSessionsJob() {
        this.memberPackageDAO = new MemberPackageDAO();
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        String jobName = this.getClass().getSimpleName();
        Instant startTime = JobLogger.logJobStart(jobName);

        try {
            // In ra ngày hiện tại để debug
            LocalDate today = LocalDate.now();
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LOGGER.info("Ngày hiện tại: " + today.format(dateFormatter));

            // Lấy danh sách các gói tập ACTIVE để cập nhật RemainingSessions
            List<MemberPackage> activePackages = getActivePackagesForUpdate();

            if (activePackages.isEmpty()) {
                LOGGER.info("Không có gói tập ACTIVE nào cần cập nhật RemainingSessions");
                JobLogger.logJobSuccess(jobName, startTime,
                        "Không có gói tập ACTIVE nào cần cập nhật RemainingSessions");
                return;
            }

            LOGGER.info("Tìm thấy " + activePackages.size() + " gói tập ACTIVE cần cập nhật RemainingSessions");

            // Cập nhật RemainingSessions cho các gói tập
            int updatedCount = 0;
            for (MemberPackage memberPackage : activePackages) {
                boolean updated = updateRemainingSessions(memberPackage);
                if (updated) {
                    LOGGER.info("Đã cập nhật RemainingSessions của gói tập ID " + memberPackage.getId() +
                            " thành " + memberPackage.getRemainingSessions());
                    updatedCount++;
                } else {
                    LOGGER.warning("Không thể cập nhật RemainingSessions của gói tập ID " + memberPackage.getId());
                }
            }

            String message = "Đã cập nhật RemainingSessions cho " + updatedCount + "/" + activePackages.size()
                    + " gói tập ACTIVE";
            LOGGER.info("Hoàn thành cập nhật RemainingSessions cho các gói tập ACTIVE");
            JobLogger.logJobSuccess(jobName, startTime, message);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật RemainingSessions cho các gói tập ACTIVE", e);
            JobLogger.logJobFailure(jobName, startTime, e);
            throw new JobExecutionException(e);
        }
    }

    /**
     * Lấy danh sách các gói tập ACTIVE để cập nhật RemainingSessions
     * 
     * @return Danh sách các gói tập ACTIVE
     */
    private List<MemberPackage> getActivePackagesForUpdate() {
        List<MemberPackage> activePackages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();

            // Lấy các gói tập ACTIVE có EndDate > ngày hiện tại
            String sql = "SELECT mp.MemberPackageId, mp.PackageId, mp.StartDate, mp.EndDate, mp.RemainingSessions, p.Sessions "
                    +
                    "FROM Member_Packages mp " +
                    "JOIN Packages p ON mp.PackageId = p.PackageId " +
                    "WHERE mp.Status = 'ACTIVE' AND mp.EndDate > CONVERT(DATE, GETDATE())";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            // Ngày hiện tại
            LocalDate today = LocalDate.now();

            while (rs.next()) {
                int memberPackageId = rs.getInt("MemberPackageId");
                int packageId = rs.getInt("PackageId");
                Date startDate = rs.getDate("StartDate");
                Date endDate = rs.getDate("EndDate");
                int currentRemainingSessions = rs.getInt("RemainingSessions");
                int totalSessions = rs.getInt("Sessions");

                if (startDate != null && endDate != null) {
                    LocalDate packageStartDate = startDate.toLocalDate();
                    LocalDate packageEndDate = endDate.toLocalDate();

                    // Log thông tin để debug
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    LOGGER.info("Gói tập ID " + memberPackageId +
                            ", Ngày bắt đầu: " + packageStartDate.format(formatter) +
                            ", Ngày kết thúc: " + packageEndDate.format(formatter) +
                            ", Sessions: " + totalSessions +
                            ", RemainingSessions hiện tại: " + currentRemainingSessions);

                    // Tạo đối tượng MemberPackage
                    MemberPackage memberPackage = new MemberPackage();
                    memberPackage.setId(memberPackageId);
                    memberPackage.setStartDate(packageStartDate);
                    memberPackage.setEndDate(packageEndDate);
                    memberPackage.setRemainingSessions(currentRemainingSessions);

                    // Khởi tạo đối tượng Package và gán vào memberPackage
                    Package packageObj = new Package();
                    packageObj.setId(packageId);
                    packageObj.setSessions(totalSessions);
                    memberPackage.setPackageField(packageObj);

                    activePackages.add(memberPackage);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách gói tập ACTIVE để cập nhật RemainingSessions", e);
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

        return activePackages;
    }

    /**
     * Cập nhật RemainingSessions cho một gói tập dựa trên thời gian còn lại
     * 
     * @param memberPackage Gói tập cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    private boolean updateRemainingSessions(MemberPackage memberPackage) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Tính toán RemainingSessions mới dựa trên thời gian còn lại
            LocalDate today = LocalDate.now();
            LocalDate startDate = memberPackage.getStartDate();
            LocalDate endDate = memberPackage.getEndDate();

            // Kiểm tra nếu ngày hiện tại là ngày bắt đầu gói tập
            if (today.isEqual(startDate)) {
                // Nếu là ngày đầu tiên, giữ nguyên tổng số buổi tập
                int totalSessions = memberPackage.getPackageField().getSessions();

                // Nếu RemainingSessions khác với tổng số buổi tập, cập nhật
                if (memberPackage.getRemainingSessions() != totalSessions) {
                    conn = DbConnection.getConnection();
                    String sql = "UPDATE Member_Packages SET RemainingSessions = ?, UpdatedAt = ? WHERE MemberPackageId = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, totalSessions);
                    stmt.setTimestamp(2, java.sql.Timestamp.from(Instant.now()));
                    stmt.setInt(3, memberPackage.getId());

                    int affectedRows = stmt.executeUpdate();

                    LOGGER.info("Gói tập ID " + memberPackage.getId() + ": Đặt lại RemainingSessions thành " +
                            totalSessions + " (ngày bắt đầu gói tập)");

                    // Cập nhật giá trị mới vào đối tượng
                    memberPackage.setRemainingSessions(totalSessions);

                    return affectedRows > 0;
                } else {
                    LOGGER.info("Gói tập ID " + memberPackage.getId() + ": RemainingSessions không thay đổi (" +
                            memberPackage.getRemainingSessions() + ")");
                    return true;
                }
            }

            // Tính số ngày còn lại
            long remainingDays = java.time.temporal.ChronoUnit.DAYS.between(today, endDate);

            // Đảm bảo remainingDays không âm
            remainingDays = Math.max(0, remainingDays);

            // Số buổi còn lại chính xác bằng số ngày còn lại
            int newRemainingSessions = (int) remainingDays;

            // Đảm bảo có ít nhất 1 buổi còn lại nếu gói tập chưa hết hạn
            if (today.isBefore(endDate) && newRemainingSessions < 1) {
                newRemainingSessions = 1;
            }

            LOGGER.info("Gói tập ID " + memberPackage.getId() +
                    ": Ngày bắt đầu=" + startDate +
                    ", Ngày kết thúc=" + endDate +
                    ", Ngày hiện tại=" + today +
                    ", Ngày còn lại=" + remainingDays +
                    ", Buổi còn lại=" + newRemainingSessions);

            // Nếu RemainingSessions mới khác với hiện tại, cập nhật vào database
            if (newRemainingSessions != memberPackage.getRemainingSessions()) {
                conn = DbConnection.getConnection();
                String sql = "UPDATE Member_Packages SET RemainingSessions = ?, UpdatedAt = ? WHERE MemberPackageId = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, newRemainingSessions);
                stmt.setTimestamp(2, java.sql.Timestamp.from(Instant.now()));
                stmt.setInt(3, memberPackage.getId());

                int affectedRows = stmt.executeUpdate();

                // Cập nhật giá trị mới vào đối tượng
                int oldRemainingSessions = memberPackage.getRemainingSessions();
                memberPackage.setRemainingSessions(newRemainingSessions);

                LOGGER.info("Gói tập ID " + memberPackage.getId() + ": Cập nhật RemainingSessions từ " +
                        oldRemainingSessions + " thành " + newRemainingSessions);

                return affectedRows > 0;
            } else {
                LOGGER.info("Gói tập ID " + memberPackage.getId() + ": RemainingSessions không thay đổi (" +
                        memberPackage.getRemainingSessions() + ")");
                return true; // Không cần cập nhật vì giá trị không thay đổi
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật RemainingSessions cho gói tập ID " + memberPackage.getId(), e);
            return false;
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối database", e);
            }
        }
    }
}
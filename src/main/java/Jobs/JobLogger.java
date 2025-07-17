package Jobs;

import DAOs.JobExecutionLogDAO;
import Models.JobExecutionLog;

import java.time.Instant;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Lớp tiện ích để ghi log thực thi job
 */
public class JobLogger {
    private static final Logger LOGGER = Logger.getLogger(JobLogger.class.getName());
    private static final JobExecutionLogDAO jobExecutionLogDAO = new JobExecutionLogDAO();

    /**
     * Ghi log bắt đầu thực thi job
     * 
     * @param jobName Tên job
     * @return Thời điểm bắt đầu thực thi
     */
    public static Instant logJobStart(String jobName) {
        Instant startTime = Instant.now();
        LOGGER.info("Job " + jobName + " bắt đầu thực thi lúc " + startTime);
        return startTime;
    }

    /**
     * Ghi log kết thúc thực thi job thành công
     * 
     * @param jobName   Tên job
     * @param startTime Thời điểm bắt đầu thực thi
     * @param message   Thông điệp kết quả
     */
    public static void logJobSuccess(String jobName, Instant startTime, String message) {
        Instant endTime = Instant.now();
        long durationMillis = endTime.toEpochMilli() - startTime.toEpochMilli();

        LOGGER.info("Job " + jobName + " thực thi thành công trong " + durationMillis + "ms. " + message);

        try {
            JobExecutionLog log = new JobExecutionLog(
                    jobName,
                    startTime,
                    true,
                    message,
                    durationMillis);
            jobExecutionLogDAO.createLog(log);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi ghi log thực thi job " + jobName, e);
        }
    }

    /**
     * Ghi log kết thúc thực thi job thất bại
     * 
     * @param jobName   Tên job
     * @param startTime Thời điểm bắt đầu thực thi
     * @param error     Lỗi xảy ra
     */
    public static void logJobFailure(String jobName, Instant startTime, Exception error) {
        Instant endTime = Instant.now();
        long durationMillis = endTime.toEpochMilli() - startTime.toEpochMilli();

        String errorMessage = error != null ? error.getMessage() : "Unknown error";
        LOGGER.log(Level.SEVERE,
                "Job " + jobName + " thực thi thất bại trong " + durationMillis + "ms. Lỗi: " + errorMessage, error);

        try {
            JobExecutionLog log = new JobExecutionLog(
                    jobName,
                    startTime,
                    false,
                    errorMessage,
                    durationMillis);
            jobExecutionLogDAO.createLog(log);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi ghi log thực thi job " + jobName, e);
        }
    }

    /**
     * Đảm bảo bảng Job_Execution_Logs tồn tại
     */
    public static void ensureLogTableExists() {
        try {
            jobExecutionLogDAO.createTableIfNotExists();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo bảng Job_Execution_Logs", e);
        }
    }
}
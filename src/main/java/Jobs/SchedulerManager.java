package Jobs;

import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Quản lý các scheduled jobs trong ứng dụng
 */
public class SchedulerManager {
    private static final Logger LOGGER = Logger.getLogger(SchedulerManager.class.getName());
    private static Scheduler scheduler;

    /**
     * Khởi tạo và bắt đầu scheduler
     */
    public static void start() {
        try {
            // Đảm bảo bảng log tồn tại
            JobLogger.ensureLogTableExists();

            // Tạo scheduler
            scheduler = StdSchedulerFactory.getDefaultScheduler();

            // Đăng ký các jobs
            registerJobs();

            // Bắt đầu scheduler
            scheduler.start();
            LOGGER.info("Scheduler đã được khởi động");
        } catch (SchedulerException e) {
            LOGGER.log(Level.SEVERE, "Không thể khởi động scheduler", e);
        }
    }

    /**
     * Dừng scheduler
     */
    public static void shutdown() {
        try {
            if (scheduler != null && !scheduler.isShutdown()) {
                scheduler.shutdown(true);
                LOGGER.info("Scheduler đã được dừng lại");
            }
        } catch (SchedulerException e) {
            LOGGER.log(Level.SEVERE, "Không thể dừng scheduler", e);
        }
    }

    /**
     * Đăng ký các jobs vào scheduler
     */
    private static void registerJobs() throws SchedulerException {
        // Đăng ký job kiểm tra và cập nhật các gói tập PENDING đã hết hạn
        registerExpirePendingMemberPackagesJob();

        // Đăng ký job kiểm tra và cập nhật các gói tập ACTIVE đã hết hạn
        registerExpireActiveMemberPackagesJob();

        // Đăng ký job cập nhật RemainingSessions của các gói tập ACTIVE
        registerUpdateRemainingSessionsJob();
    }

    /**
     * Đăng ký job kiểm tra và cập nhật các gói tập PENDING đã hết hạn
     */
    private static void registerExpirePendingMemberPackagesJob() throws SchedulerException {
        // Tạo JobDetail
        JobDetail jobDetail = JobBuilder.newJob(ExpirePendingMemberPackagesJob.class)
                .withIdentity("expirePendingMemberPackagesJob", "memberPackages")
                .build();

        // Lập lịch chạy job mỗi 1 phút
        Trigger trigger = TriggerBuilder.newTrigger()
                .withIdentity("expirePendingMemberPackagesTrigger", "memberPackages")
                .startNow()
                .withSchedule(SimpleScheduleBuilder.simpleSchedule()
                        .withIntervalInMinutes(1)
                        .repeatForever())
                .build();

        // Đăng ký job và trigger với scheduler
        scheduler.scheduleJob(jobDetail, trigger);
        LOGGER.info("Đã đăng ký job kiểm tra và cập nhật các gói tập PENDING đã hết hạn thanh toán");
    }

    /**
     * Đăng ký job kiểm tra và cập nhật các gói tập ACTIVE đã hết hạn
     */
    private static void registerExpireActiveMemberPackagesJob() throws SchedulerException {
        // Tạo JobDetail
        JobDetail jobDetail = JobBuilder.newJob(ExpireActiveMemberPackagesJob.class)
                .withIdentity("expireActiveMemberPackagesJob", "memberPackages")
                .build();

        // Lập lịch chạy job mỗi ngày vào lúc 00:01
        Trigger trigger = TriggerBuilder.newTrigger()
                .withIdentity("expireActiveMemberPackagesTrigger", "memberPackages")
                .startNow()
                .withSchedule(CronScheduleBuilder.dailyAtHourAndMinute(0, 1))
                .build();

        // Đăng ký job và trigger với scheduler
        scheduler.scheduleJob(jobDetail, trigger);
        LOGGER.info("Đã đăng ký job kiểm tra và cập nhật các gói tập ACTIVE đã hết hạn");
    }

    /**
     * Đăng ký job cập nhật RemainingSessions của các gói tập ACTIVE
     */
    private static void registerUpdateRemainingSessionsJob() throws SchedulerException {
        // Tạo JobDetail
        JobDetail jobDetail = JobBuilder.newJob(UpdateRemainingSessionsJob.class)
                .withIdentity("updateRemainingSessionsJob", "memberPackages")
                .build();

        // Lập lịch chạy job mỗi ngày vào lúc 00:05
        Trigger trigger = TriggerBuilder.newTrigger()
                .withIdentity("updateRemainingSessionsTrigger", "memberPackages")
                .startNow()
                .withSchedule(CronScheduleBuilder.dailyAtHourAndMinute(0, 5))
                .build();

        // Đăng ký job và trigger với scheduler
        scheduler.scheduleJob(jobDetail, trigger);
        LOGGER.info("Đã đăng ký job cập nhật RemainingSessions của các gói tập ACTIVE");
    }

    /**
     * Lấy đối tượng Scheduler
     * 
     * @return Đối tượng Scheduler
     */
    public static Scheduler getScheduler() {
        return scheduler;
    }
}
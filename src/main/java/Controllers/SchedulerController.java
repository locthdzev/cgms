package Controllers;

import DAOs.JobExecutionLogDAO;
import Jobs.ExpireActiveMemberPackagesJob;
import Jobs.ExpirePendingMemberPackagesJob;
import Jobs.SchedulerManager;
import Models.JobExecutionLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
import org.quartz.impl.matchers.GroupMatcher;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/scheduler/*")
public class SchedulerController extends HttpServlet {

    private Scheduler scheduler;
    private JobExecutionLogDAO jobExecutionLogDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            scheduler = SchedulerManager.getScheduler();
            if (scheduler == null) {
                scheduler = StdSchedulerFactory.getDefaultScheduler();
            }
            jobExecutionLogDAO = new JobExecutionLogDAO();
        } catch (SchedulerException e) {
            throw new ServletException("Không thể khởi tạo scheduler", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Hiển thị trang chủ với danh sách jobs
            showDashboard(request, response);
        } else if (pathInfo.equals("/status")) {
            // Hiển thị trạng thái scheduler
            showStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin đường dẫn");
            return;
        }

        try {
            JobKey jobKey = null;
            String jobName = null;

            if (pathInfo.equals("/trigger/pending")) {
                // Trigger job ExpirePendingMemberPackagesJob
                jobKey = new JobKey("expirePendingMemberPackagesJob", "memberPackages");
                jobName = "ExpirePendingMemberPackagesJob";
            } else if (pathInfo.equals("/trigger/active")) {
                // Trigger job ExpireActiveMemberPackagesJob
                jobKey = new JobKey("expireActiveMemberPackagesJob", "memberPackages");
                jobName = "ExpireActiveMemberPackagesJob";
            } else if (pathInfo.equals("/trigger/remaining")) {
                // Trigger job UpdateRemainingSessionsJob
                jobKey = new JobKey("updateRemainingSessionsJob", "memberPackages");
                jobName = "UpdateRemainingSessionsJob";
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            if (jobKey != null) {
                // Kích hoạt job
                scheduler.triggerJob(jobKey);

                // Thêm log thủ công để đảm bảo UI hiển thị ngay lập tức
                JobExecutionLog manualLog = new JobExecutionLog();
                manualLog.setJobName(jobName);
                manualLog.setExecutionTime(Instant.now());
                manualLog.setSuccess(true);
                manualLog.setMessage("Kích hoạt thủ công bởi người dùng");
                manualLog.setExecutionDuration(0L); // Sửa thành Long
                manualLog.setCreatedAt(Instant.now());

                // Lưu log vào database
                jobExecutionLogDAO.createLog(manualLog);

                response.sendRedirect(request.getContextPath() + "/admin/scheduler/");
            }
        } catch (SchedulerException e) {
            throw new ServletException("Lỗi khi thực hiện thao tác với scheduler", e);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin scheduler
            boolean schedulerRunning = scheduler != null && scheduler.isStarted() && !scheduler.isShutdown();
            SchedulerMetaData metaData = scheduler.getMetaData();

            request.setAttribute("schedulerRunning", schedulerRunning);
            request.setAttribute("runningSince", formatDate(metaData.getRunningSince()));

            // Lấy số lượng jobs đã thực thi từ database thay vì từ scheduler
            int jobsExecutedCount = jobExecutionLogDAO.getExecutionCount();
            request.setAttribute("jobsExecuted", jobsExecutedCount);

            // Lấy danh sách jobs
            List<Map<String, Object>> jobs = new ArrayList<>();
            Map<String, Map<String, Object>> uniqueJobs = new HashMap<>();

            for (String groupName : scheduler.getJobGroupNames()) {
                for (JobKey jobKey : scheduler.getJobKeys(GroupMatcher.jobGroupEquals(groupName))) {
                    String jobName = jobKey.getName();
                    String jobGroup = jobKey.getGroup();

                    // Tạo thông tin job cơ bản
                    Map<String, Object> jobInfo = new HashMap<>();
                    jobInfo.put("name", jobName);
                    jobInfo.put("group", jobGroup);
                    jobInfo.put("nextFireTime", null);
                    jobInfo.put("previousFireTime", null);
                    jobInfo.put("state", "NONE");

                    // Thêm đường dẫn trigger tương ứng
                    if (jobName.equals("expirePendingMemberPackagesJob")) {
                        jobInfo.put("triggerPath", "pending");
                        jobInfo.put("displayName", "Cập nhật gói tập PENDING hết hạn thanh toán");
                    } else if (jobName.equals("expireActiveMemberPackagesJob")) {
                        jobInfo.put("triggerPath", "active");
                        jobInfo.put("displayName", "Cập nhật gói tập ACTIVE hết hạn sử dụng");
                    } else if (jobName.equals("updateRemainingSessionsJob")) {
                        jobInfo.put("triggerPath", "remaining");
                        jobInfo.put("displayName", "Cập nhật số buổi tập còn lại");
                    } else {
                        jobInfo.put("displayName", jobName);
                    }

                    // Lấy triggers cho job
                    List<? extends Trigger> triggers = scheduler.getTriggersOfJob(jobKey);

                    if (triggers != null && !triggers.isEmpty()) {
                        // Lấy thông tin từ trigger đầu tiên (chính)
                        Trigger primaryTrigger = triggers.get(0);
                        Trigger.TriggerState triggerState = scheduler.getTriggerState(primaryTrigger.getKey());

                        jobInfo.put("nextFireTime", formatDate(primaryTrigger.getNextFireTime()));
                        jobInfo.put("previousFireTime", formatDate(primaryTrigger.getPreviousFireTime()));
                        jobInfo.put("state", triggerState.toString());

                        // Kiểm tra các trigger khác để lấy thông tin lần chạy gần nhất
                        if (triggers.size() > 1) {
                            Date latestPreviousFireTime = primaryTrigger.getPreviousFireTime();

                            for (int i = 1; i < triggers.size(); i++) {
                                Trigger trigger = triggers.get(i);
                                Date prevFireTime = trigger.getPreviousFireTime();

                                if (prevFireTime != null && (latestPreviousFireTime == null ||
                                        prevFireTime.after(latestPreviousFireTime))) {
                                    latestPreviousFireTime = prevFireTime;
                                }
                            }

                            jobInfo.put("previousFireTime", formatDate(latestPreviousFireTime));
                        }
                    }

                    // Lưu job vào danh sách
                    uniqueJobs.put(jobName, jobInfo);
                }
            }

            // Chuyển từ Map sang List để hiển thị
            jobs.addAll(uniqueJobs.values());

            request.setAttribute("jobs", jobs);

            // Lấy danh sách log thực thi job
            List<JobExecutionLog> executionLogs = jobExecutionLogDAO.getRecentLogs(20);
            List<Map<String, Object>> formattedLogs = new ArrayList<>();

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
            for (JobExecutionLog log : executionLogs) {
                Map<String, Object> formattedLog = new HashMap<>();

                // Định dạng thời gian
                LocalDateTime executionDateTime = LocalDateTime.ofInstant(log.getExecutionTime(),
                        ZoneId.systemDefault());
                formattedLog.put("timestamp", executionDateTime.format(formatter));

                // Định dạng tên job
                String jobName = log.getJobName();
                if (jobName.equals("ExpirePendingMemberPackagesJob")) {
                    formattedLog.put("jobName", "Cập nhật gói tập PENDING hết hạn thanh toán");
                } else if (jobName.equals("ExpireActiveMemberPackagesJob")) {
                    formattedLog.put("jobName", "Cập nhật gói tập ACTIVE hết hạn sử dụng");
                } else if (jobName.equals("UpdateRemainingSessionsJob")) {
                    formattedLog.put("jobName", "Cập nhật số buổi tập còn lại");
                } else {
                    formattedLog.put("jobName", jobName);
                }

                formattedLog.put("success", log.isSuccess());
                formattedLog.put("message", log.getMessage());
                formattedLog.put("executionTime", log.getExecutionDuration());

                formattedLogs.add(formattedLog);
            }

            request.setAttribute("executionLogs", formattedLogs);

            // Chuyển đến trang JSP
            request.getRequestDispatcher("/WEB-INF/views/admin/scheduler/dashboard.jsp").forward(request, response);

        } catch (SchedulerException e) {
            throw new ServletException("Lỗi khi lấy thông tin scheduler", e);
        }
    }

    private void showStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin chi tiết về scheduler
            SchedulerMetaData metaData = scheduler.getMetaData();

            request.setAttribute("metaData", metaData);
            request.getRequestDispatcher("/WEB-INF/views/admin/scheduler/status.jsp").forward(request, response);

        } catch (SchedulerException e) {
            throw new ServletException("Lỗi khi lấy thông tin scheduler", e);
        }
    }

    private String formatDate(Date date) {
        if (date == null) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        return sdf.format(date);
    }
}
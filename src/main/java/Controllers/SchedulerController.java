package Controllers;

import Jobs.ExpireActiveMemberPackagesJob;
import Jobs.ExpirePendingMemberPackagesJob;
import Jobs.SchedulerManager;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/scheduler/*")
public class SchedulerController extends HttpServlet {

    private Scheduler scheduler;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            scheduler = StdSchedulerFactory.getDefaultScheduler();
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
            if (pathInfo.equals("/trigger/pending")) {
                // Trigger job ExpirePendingMemberPackagesJob
                JobKey jobKey = new JobKey("expirePendingMemberPackagesJob", "memberPackages");
                scheduler.triggerJob(jobKey);
                response.sendRedirect(request.getContextPath() + "/admin/scheduler/");
            } else if (pathInfo.equals("/trigger/active")) {
                // Trigger job ExpireActiveMemberPackagesJob
                JobKey jobKey = new JobKey("expireActiveMemberPackagesJob", "memberPackages");
                scheduler.triggerJob(jobKey);
                response.sendRedirect(request.getContextPath() + "/admin/scheduler/");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
            request.setAttribute("jobsExecuted", metaData.getNumberOfJobsExecuted());

            // Lấy danh sách jobs
            List<Map<String, Object>> jobs = new ArrayList<>();

            for (String groupName : scheduler.getJobGroupNames()) {
                for (JobKey jobKey : scheduler.getJobKeys(GroupMatcher.jobGroupEquals(groupName))) {
                    String jobName = jobKey.getName();
                    String jobGroup = jobKey.getGroup();

                    // Lấy triggers cho job
                    List<? extends Trigger> triggers = scheduler.getTriggersOfJob(jobKey);

                    if (triggers != null && !triggers.isEmpty()) {
                        for (Trigger trigger : triggers) {
                            Trigger.TriggerState triggerState = scheduler.getTriggerState(trigger.getKey());
                            Date nextFireTime = trigger.getNextFireTime();
                            Date previousFireTime = trigger.getPreviousFireTime();

                            Map<String, Object> jobInfo = new HashMap<>();
                            jobInfo.put("name", jobName);
                            jobInfo.put("group", jobGroup);
                            jobInfo.put("nextFireTime", formatDate(nextFireTime));
                            jobInfo.put("previousFireTime", formatDate(previousFireTime));
                            jobInfo.put("state", triggerState.toString());

                            // Thêm đường dẫn trigger tương ứng
                            if (jobName.equals("expirePendingMemberPackagesJob")) {
                                jobInfo.put("triggerPath", "pending");
                            } else if (jobName.equals("expireActiveMemberPackagesJob")) {
                                jobInfo.put("triggerPath", "active");
                            }

                            jobs.add(jobInfo);
                        }
                    } else {
                        Map<String, Object> jobInfo = new HashMap<>();
                        jobInfo.put("name", jobName);
                        jobInfo.put("group", jobGroup);
                        jobInfo.put("nextFireTime", null);
                        jobInfo.put("previousFireTime", null);
                        jobInfo.put("state", "NONE");

                        jobs.add(jobInfo);
                    }
                }
            }

            request.setAttribute("jobs", jobs);

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
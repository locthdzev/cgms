package Models;

import java.time.Instant;

public class JobExecutionLog {
    private Integer id;
    private String jobName;
    private Instant executionTime;
    private boolean success;
    private String message;
    private Long executionDuration; // Thời gian thực thi (ms)
    private Instant createdAt;

    public JobExecutionLog() {
    }

    public JobExecutionLog(String jobName, Instant executionTime, boolean success, String message,
            Long executionDuration) {
        this.jobName = jobName;
        this.executionTime = executionTime;
        this.success = success;
        this.message = message;
        this.executionDuration = executionDuration;
        this.createdAt = Instant.now();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getJobName() {
        return jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public Instant getExecutionTime() {
        return executionTime;
    }

    public void setExecutionTime(Instant executionTime) {
        this.executionTime = executionTime;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Long getExecutionDuration() {
        return executionDuration;
    }

    public void setExecutionDuration(Long executionDuration) {
        this.executionDuration = executionDuration;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }
}
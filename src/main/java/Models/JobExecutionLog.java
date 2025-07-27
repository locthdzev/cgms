package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "Job_Execution_Logs")
public class JobExecutionLog {
    @Id
    @Column(name = "LogId", nullable = false)
    private Integer id;

    @Nationalized
    @Column(name = "JobName", nullable = false, length = 100)
    private String jobName;

    @Column(name = "ExecutionTime", nullable = false)
    private Instant executionTime;

    @Column(name = "Success", nullable = false)
    private Boolean success = false;

    @Nationalized
    @Column(name = "Message", length = 500)
    private String message;

    @Column(name = "ExecutionDuration")
    private Long executionDuration;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    public JobExecutionLog() {
    }

    public JobExecutionLog(String jobName, Instant executionTime, boolean success, String message,
            long executionDuration) {
        this.jobName = jobName;
        this.executionTime = executionTime;
        this.success = success;
        this.message = message;
        this.executionDuration = executionDuration;
        this.createdAt = Instant.now();
    }

    public boolean isSuccess() {
        return success != null && success;
    }
}
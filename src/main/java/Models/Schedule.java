package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@Entity
@Table(name = "Schedules", uniqueConstraints = {
        @UniqueConstraint(name = "UQ_Trainer_Schedule", columnNames = {"TrainerId", "ScheduleDate", "ScheduleTime"})
})
public class Schedule {
    @Id
    @Column(name = "ScheduleId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "TrainerId", nullable = false)
    private User trainer;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "MemberId", nullable = false)
    private User member;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AvailabilityId")
    private TrainerAvailability availability;

    @Column(name = "ScheduleDate", nullable = false)
    private LocalDate scheduleDate;

    @Column(name = "ScheduleTime", nullable = false)
    private LocalTime scheduleTime;

    @Column(name = "DurationHours", nullable = false, precision = 4, scale = 2)
    private BigDecimal durationHours;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
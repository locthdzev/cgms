package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@Entity
@Table(name = "Trainer_Availability", uniqueConstraints = {
        @UniqueConstraint(name = "UQ_Trainer_Availability", columnNames = {"TrainerId", "AvailabilityDate", "StartTime"})
})
public class TrainerAvailability {
    @Id
    @Column(name = "AvailabilityId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "TrainerId", nullable = false)
    private User trainer;

    @Column(name = "AvailabilityDate", nullable = false)
    private LocalDate availabilityDate;

    @Column(name = "StartTime", nullable = false)
    private LocalTime startTime;

    @Column(name = "EndTime", nullable = false)
    private LocalTime endTime;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
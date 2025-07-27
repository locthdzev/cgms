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
@Table(name = "Checkins", uniqueConstraints = {
        @UniqueConstraint(name = "UQ_Member_Checkin", columnNames = {"MemberId", "CheckinDate"})
})
public class Checkin {
    @Id
    @Column(name = "CheckinId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "MemberId", nullable = false)
    private User member;

    @Column(name = "CheckinDate", nullable = false)
    private LocalDate checkinDate;

    @Column(name = "CheckinTime", nullable = false)
    private LocalTime checkinTime;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
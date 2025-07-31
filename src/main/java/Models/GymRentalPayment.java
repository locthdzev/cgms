package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "Gym_Rental_Payments", indexes = {
        @Index(name = "IX_Gym_Rental_Payments_TrainerId", columnList = "TrainerId")
})
public class GymRentalPayment {
    @Id
    @Column(name = "RentalPaymentId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "TrainerId", nullable = false)
    private User trainer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ScheduleId")
    private Schedule schedule;

    @Column(name = "Amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal amount;

    @Nationalized
    @Column(name = "RentalType", nullable = false, length = 20)
    private String rentalType;

    @Column(name = "PaymentDate", nullable = false)
    private LocalDate paymentDate;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
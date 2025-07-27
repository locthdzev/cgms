package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "Payments", indexes = {
        @Index(name = "IX_Payments_MemberPackageId", columnList = "MemberPackageId"),
        @Index(name = "IX_Payments_OrderId", columnList = "OrderId")
}, uniqueConstraints = {
        @UniqueConstraint(name = "UQ__Payments__55433A6A9E224754", columnNames = {"TransactionId"})
})
public class Payment {
    @Id
    @Column(name = "PaymentId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MemberPackageId")
    private MemberPackage memberPackage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OrderId")
    private Order order;

    @Column(name = "Amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal amount;

    @Nationalized
    @Column(name = "PaymentMethod", nullable = false, length = 50)
    private String paymentMethod;

    @Column(name = "PaymentDate", nullable = false)
    private Instant paymentDate;

    @Nationalized
    @Lob
    @Column(name = "PaymentData")
    private String paymentData;

    @Nationalized
    @Lob
    @Column(name = "CallbackData")
    private String callbackData;

    @Nationalized
    @Column(name = "TransactionId", length = 100)
    private String transactionId;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

}
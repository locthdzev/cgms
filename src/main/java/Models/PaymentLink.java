package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "Payment_Links")
public class PaymentLink {
    @Id
    @Column(name = "PaymentLinkId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "PaymentId", nullable = false)
    private Payment payment;

    @Nationalized
    @Column(name = "OrderCode", nullable = false, length = 100)
    private String orderCode;

    @Nationalized
    @Column(name = "PaymentLinkUrl", nullable = false, length = 500)
    private String paymentLinkUrl;

    @Column(name = "ExpireTime", nullable = false)
    private Instant expireTime;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
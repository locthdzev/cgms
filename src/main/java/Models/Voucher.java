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
@Table(name = "Vouchers", uniqueConstraints = {
        @UniqueConstraint(name = "UQ__Vouchers__A25C5AA79A644FC7", columnNames = {"Code"})
})
public class Voucher {
    @Id
    @Column(name = "VoucherId", nullable = false)
    private Integer id;

    @Nationalized
    @Column(name = "Code", nullable = false, length = 20)
    private String code;

    @Column(name = "DiscountValue", nullable = false, precision = 10, scale = 2)
    private BigDecimal discountValue;

    @Nationalized
    @Column(name = "DiscountType", nullable = false, length = 20)
    private String discountType;

    @Column(name = "MinPurchase", precision = 10, scale = 2)
    private BigDecimal minPurchase;

    @Column(name = "ExpiryDate", nullable = false)
    private LocalDate expiryDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MemberId")
    private User member;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
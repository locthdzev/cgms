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
@Table(name = "Member_Purchase_History", indexes = {
        @Index(name = "IX_Member_Purchase_History_MemberId", columnList = "MemberId")
})
public class MemberPurchaseHistory {
    @Id
    @Column(name = "PurchaseId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "MemberId", nullable = false)
    private User member;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MemberPackageId")
    private MemberPackage memberPackage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SaleId")
    private ProductSale sale;

    @Nationalized
    @Column(name = "PurchaseType", nullable = false, length = 20)
    private String purchaseType;

    @Column(name = "PurchaseAmount", nullable = false, precision = 10, scale = 2)
    private BigDecimal purchaseAmount;

    @Column(name = "PurchaseDate", nullable = false)
    private LocalDate purchaseDate;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
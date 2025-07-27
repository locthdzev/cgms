package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "Cart", indexes = {
        @Index(name = "IX_Cart_MemberId", columnList = "MemberId"),
        @Index(name = "IX_Cart_ProductId", columnList = "ProductId")
}, uniqueConstraints = {
        @UniqueConstraint(name = "UQ_Cart_MemberId_ProductId_Status", columnNames = {"MemberId", "ProductId", "Status"})
})
public class Cart {
    @Id
    @Column(name = "CartId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "MemberId", nullable = false)
    private User member;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ProductId", nullable = false)
    private Product product;

    @Column(name = "Quantity", nullable = false)
    private Integer quantity;

    @Column(name = "AddedAt", nullable = false)
    private Instant addedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
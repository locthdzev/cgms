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
@Table(name = "Product_Sales", indexes = {
        @Index(name = "IX_Product_Sales_MemberId", columnList = "MemberId"),
        @Index(name = "IX_Product_Sales_ProductId", columnList = "ProductId")
})
public class ProductSale {
    @Id
    @Column(name = "SaleId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "MemberId", nullable = false)
    private User member;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ProductId", nullable = false)
    private Product product;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VoucherId")
    private Voucher voucher;

    @Column(name = "Quantity", nullable = false)
    private Integer quantity;

    @Column(name = "TotalPrice", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalPrice;

    @Column(name = "SaleDate", nullable = false)
    private LocalDate saleDate;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "Inventory", indexes = {
        @Index(name = "IX_Inventory_ProductId", columnList = "ProductId")
})
public class Inventory {
    @Id
    @Column(name = "InventoryId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ProductId", nullable = false)
    private Product product;

    @Column(name = "Quantity", nullable = false)
    private Integer quantity;

    @Nationalized
    @Column(name = "SupplierName", nullable = false, length = 100)
    private String supplierName;

    @Nationalized
    @Column(name = "TaxCode", nullable = false, length = 50)
    private String taxCode;

    @Column(name = "ImportedDate", nullable = false)
    private Instant importedDate;

    @Column(name = "LastUpdated", nullable = false)
    private Instant lastUpdated;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
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

    @Column(name = "ImportedDate", nullable = false)
    private Instant importedDate;  // Ngày nhập kho

    @Nationalized  // Hỗ trợ đa ngôn ngữ cho tên nhà cung cấp
    @Column(name = "SupplierName", nullable = false, length = 100)  // Tên nhà cung cấp
    private String supplierName;

    @Column(name = "TaxCode", nullable = false, length = 50)  // Mã số thuế
    private String taxCode;

    @Nationalized  // Hỗ trợ đa ngôn ngữ cho tình trạng
    @Column(name = "Status", nullable = false, length = 20)  // Tình trạng
    private String status;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Instant getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Instant lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
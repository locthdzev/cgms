package Models;

import org.hibernate.annotations.Nationalized;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "Member_Levels")
public class MemberLevel {
    @Id
    @Column(name = "LevelId", nullable = false)
    private Integer id;

    @Nationalized
    @Column(name = "LevelName", nullable = false, length = 50)
    private String levelName;

    @Column(name = "MinPurchases", nullable = false)
    private Integer minPurchases;

    @Column(name = "MinSpending", nullable = false, precision = 10, scale = 2)
    private BigDecimal minSpending;

    @Nationalized
    @Column(name = "Benefits", length = 500)
    private String benefits;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public Integer getMinPurchases() {
        return minPurchases;
    }

    public void setMinPurchases(Integer minPurchases) {
        this.minPurchases = minPurchases;
    }

    public BigDecimal getMinSpending() {
        return minSpending;
    }

    public void setMinSpending(BigDecimal minSpending) {
        this.minSpending = minSpending;
    }

    public String getBenefits() {
        return benefits;
    }

    public void setBenefits(String benefits) {
        this.benefits = benefits;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
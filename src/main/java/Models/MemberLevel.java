package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.math.BigDecimal;
import java.time.Instant;

@Getter
@Setter
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

}
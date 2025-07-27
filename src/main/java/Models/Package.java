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
@Table(name = "Packages")
public class Package {
    @Id
    @Column(name = "PackageId", nullable = false)
    private Integer id;

    @Nationalized
    @Column(name = "Name", nullable = false, length = 100)
    private String name;

    @Column(name = "Price", nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(name = "Duration", nullable = false)
    private Integer duration;

    @Column(name = "Sessions")
    private Integer sessions;

    @Nationalized
    @Column(name = "Description", length = 500)
    private String description;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
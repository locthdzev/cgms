package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "PasswordResetTokens", uniqueConstraints = {
        @UniqueConstraint(name = "UQ__Password__1EB4F81734058E0B", columnNames = {"Token"})
})
public class PasswordResetToken {
    @Id
    @Column(name = "TokenId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "UserId", nullable = false)
    private User user;

    @Nationalized
    @Column(name = "Token", nullable = false, length = 100)
    private String token;

    @Column(name = "ExpiryDate", nullable = false)
    private Instant expiryDate;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
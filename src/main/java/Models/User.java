package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "Users", uniqueConstraints = {
        @UniqueConstraint(name = "UQ__Users__A9D105345CDDE0FD", columnNames = {"Email"}),
        @UniqueConstraint(name = "UQ__Users__C9F2845647410A01", columnNames = {"UserName"})
})
public class User {
    @Id
    @Column(name = "UserId", nullable = false)
    private Integer id;

    @Nationalized
    @Column(name = "Email", nullable = false, length = 100)
    private String email;

    @Nationalized
    @Column(name = "Password")
    private String password;

    @Nationalized
    @Column(name = "Salt", length = 50)
    private String salt;

    @Nationalized
    @Column(name = "UserName", nullable = false, length = 50)
    private String userName;

    @Nationalized
    @Column(name = "GoogleId", length = 100)
    private String googleId;

    @Nationalized
    @Column(name = "Role", nullable = false, length = 50)
    private String role;

    @Nationalized
    @Column(name = "FullName", nullable = false, length = 100)
    private String fullName;

    @Nationalized
    @Column(name = "PhoneNumber", length = 20)
    private String phoneNumber;

    @Nationalized
    @Column(name = "Address", length = 200)
    private String address;

    @Nationalized
    @Column(name = "Gender", length = 20)
    private String gender;

    @Column(name = "DOB")
    private LocalDate dob;

    @Nationalized
    @Column(name = "Zalo", length = 20)
    private String zalo;

    @Nationalized
    @Column(name = "Facebook", length = 100)
    private String facebook;

    @Nationalized
    @Column(name = "Experience", length = 300)
    private String experience;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "LevelId", nullable = false)
    private MemberLevel level;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

    @Nationalized
    @Column(name = "CertificateImageUrl")
    private String certificateImageUrl;

}
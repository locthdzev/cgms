package Models;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "Feedbacks")
public class Feedback {
    @Id
    @Column(name = "FeedbackId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UserId")
    private User user;

    @Nationalized
    @Column(name = "GuestEmail", length = 100)
    private String guestEmail;

    @Nationalized
    @Column(name = "Content", nullable = false, length = 1000)
    private String content;

    @Nationalized
    @Column(name = "Response", length = 1000)
    private String response;

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "RespondedAt")
    private Instant respondedAt;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

}
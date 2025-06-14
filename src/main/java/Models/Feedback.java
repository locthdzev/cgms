package Models;

import org.hibernate.annotations.Nationalized;

import javax.persistence.*;
import java.time.Instant;

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

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getGuestEmail() {
        return guestEmail;
    }

    public void setGuestEmail(String guestEmail) {
        this.guestEmail = guestEmail;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public Instant getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(Instant respondedAt) {
        this.respondedAt = respondedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
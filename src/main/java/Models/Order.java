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
@Table(name = "\"Order\"", indexes = {
        @Index(name = "IX_Order_MemberId", columnList = "MemberId")
})
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderId", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "MemberId", nullable = false)
    private User member;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VoucherId")
    private Voucher voucher;

    @Column(name = "TotalAmount", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "OrderDate", nullable = false)
    private LocalDate orderDate;

    @Nationalized
    @Column(name = "Status", nullable = false, length = 50)
    private String status; // PENDING, CONFIRMED, SHIPPING, COMPLETED, CANCELLED

    @Column(name = "CreatedAt", nullable = false)
    private Instant createdAt;

    @Column(name = "UpdatedAt")
    private Instant updatedAt;

    // Thông tin địa chỉ giao hàng
    @Nationalized
    @Column(name = "ShippingAddress", length = 500)
    private String shippingAddress;

    @Nationalized
    @Column(name = "ReceiverName", length = 100)
    private String receiverName;

    @Nationalized
    @Column(name = "ReceiverPhone", length = 20)
    private String receiverPhone;

    // Phương thức thanh toán
    @Nationalized
    @Column(name = "PaymentMethod", length = 50)
    private String paymentMethod; // CASH, PAYOS

    // Ghi chú đơn hàng
    @Nationalized
    @Column(name = "Notes", length = 1000)
    private String notes;

    // ID của admin tạo đơn (nếu admin tạo đơn cho member)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CreatedByAdminId")
    private User createdByAdmin;

    // Mã đơn hàng PayOS (nếu có)
    @Nationalized
    @Column(name = "PayOSOrderCode", length = 100)
    private String payOSOrderCode;

}
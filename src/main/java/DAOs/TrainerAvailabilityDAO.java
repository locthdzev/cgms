package DAOs;

import Models.TrainerAvailability;
import Models.User;
import DbConnection.DbConnection;

import java.sql.*;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class TrainerAvailabilityDAO {

    /**
     * Tạo lịch sẵn sàng mới cho PT
     */
    public int createAvailability(TrainerAvailability availability) {
        String sql = "INSERT INTO Trainer_Availability (TrainerId, AvailabilityDate, StartTime, EndTime, Status, CreatedAt) "
                +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, availability.getTrainer().getId());
            stmt.setDate(2, Date.valueOf(availability.getAvailabilityDate()));
            stmt.setTime(3, Time.valueOf(availability.getStartTime()));
            stmt.setTime(4, Time.valueOf(availability.getEndTime()));
            stmt.setString(5, availability.getStatus());
            stmt.setTimestamp(6, Timestamp.from(availability.getCreatedAt()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Lấy tất cả lịch sẵn sàng chờ duyệt (PENDING)
     */
    public List<TrainerAvailability> getPendingAvailabilities() {
        List<TrainerAvailability> availabilities = new ArrayList<>();
        String sql = "SELECT ta.*, u.UserId, u.FullName, u.Email, u.Role " +
                "FROM Trainer_Availability ta " +
                "JOIN Users u ON ta.TrainerId = u.UserId " +
                "WHERE ta.Status = 'PENDING' " +
                "ORDER BY ta.AvailabilityDate, ta.StartTime";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                TrainerAvailability availability = mapResultSetToAvailability(rs);
                availabilities.add(availability);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availabilities;
    }

    /**
     * Lấy lịch sẵn sàng của PT theo TrainerId
     */
    public List<TrainerAvailability> getAvailabilitiesByTrainerId(int trainerId) {
        List<TrainerAvailability> availabilities = new ArrayList<>();
        String sql = "SELECT ta.*, u.UserId, u.FullName, u.Email, u.Role " +
                "FROM Trainer_Availability ta " +
                "JOIN Users u ON ta.TrainerId = u.UserId " +
                "WHERE ta.TrainerId = ? " +
                "ORDER BY ta.AvailabilityDate, ta.StartTime";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, trainerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    TrainerAvailability availability = mapResultSetToAvailability(rs);
                    availabilities.add(availability);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availabilities;
    }

    /**
     * Lấy lịch sẵn sàng đã được duyệt (APPROVED) của PT theo ngày
     */
    public List<TrainerAvailability> getApprovedAvailabilities(int trainerId, LocalDate date) {
        List<TrainerAvailability> availabilities = new ArrayList<>();
        String sql = "SELECT ta.*, u.UserId, u.FullName, u.Email, u.Role " +
                "FROM Trainer_Availability ta " +
                "JOIN Users u ON ta.TrainerId = u.UserId " +
                "WHERE ta.TrainerId = ? AND ta.AvailabilityDate = ? AND ta.Status = 'APPROVED' " +
                "ORDER BY ta.StartTime";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, trainerId);
            stmt.setDate(2, Date.valueOf(date));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    TrainerAvailability availability = mapResultSetToAvailability(rs);
                    availabilities.add(availability);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availabilities;
    }

    /**
     * Cập nhật trạng thái lịch sẵn sàng
     */
    public boolean updateAvailabilityStatus(int availabilityId, String status) {
        String sql = "UPDATE Trainer_Availability SET Status = ?, UpdatedAt = ? WHERE AvailabilityId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.from(Instant.now()));
            stmt.setInt(3, availabilityId);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra xem PT có sẵn sàng trong khoảng thời gian không
     */
    public boolean isTrainerAvailable(int trainerId, LocalDate date, LocalTime startTime, LocalTime endTime) {
        String sql = "SELECT COUNT(*) FROM Trainer_Availability " +
                "WHERE TrainerId = ? AND AvailabilityDate = ? AND Status = 'APPROVED' " +
                "AND StartTime <= ? AND EndTime >= ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, trainerId);
            stmt.setDate(2, Date.valueOf(date));
            stmt.setTime(3, Time.valueOf(startTime));
            stmt.setTime(4, Time.valueOf(endTime));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa lịch sẵn sàng
     */
    public boolean deleteAvailability(int availabilityId) {
        String sql = "DELETE FROM Trainer_Availability WHERE AvailabilityId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, availabilityId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy availability theo ID
     */
    public TrainerAvailability getAvailabilityById(int availabilityId) {
        String sql = "SELECT ta.*, u.UserId, u.FullName, u.Email, u.Role " +
                "FROM Trainer_Availability ta " +
                "JOIN Users u ON ta.TrainerId = u.UserId " +
                "WHERE ta.AvailabilityId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, availabilityId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAvailability(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy availabilities của PT theo ngày cụ thể
     */
    public List<TrainerAvailability> getAvailabilitiesByTrainerAndDate(int trainerId, java.time.LocalDate date) {
        String sql = "SELECT ta.*, u.UserId, u.FullName, u.Email, u.Role " +
                "FROM Trainer_Availability ta " +
                "JOIN Users u ON ta.TrainerId = u.UserId " +
                "WHERE ta.TrainerId = ? AND ta.AvailabilityDate = ?";

        List<TrainerAvailability> availabilities = new ArrayList<>();

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, trainerId);
            stmt.setDate(2, Date.valueOf(date));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    availabilities.add(mapResultSetToAvailability(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availabilities;
    }

    /**
     * Lấy availabilities của PT theo khoảng thời gian (cho calendar view)
     */
    public List<TrainerAvailability> getAvailabilitiesByTrainerAndDateRange(int trainerId,
            java.time.LocalDate startDate, java.time.LocalDate endDate) {
        String sql = "SELECT ta.*, u.UserId, u.FullName, u.Email, u.Role " +
                "FROM Trainer_Availability ta " +
                "JOIN Users u ON ta.TrainerId = u.UserId " +
                "WHERE ta.TrainerId = ? AND ta.AvailabilityDate >= ? AND ta.AvailabilityDate <= ? " +
                "ORDER BY ta.AvailabilityDate, ta.StartTime";

        List<TrainerAvailability> availabilities = new ArrayList<>();

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, trainerId);
            stmt.setDate(2, Date.valueOf(startDate));
            stmt.setDate(3, Date.valueOf(endDate));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    availabilities.add(mapResultSetToAvailability(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availabilities;
    }

    /**
     * Lấy tất cả pending availabilities với filter theo trainer (cho admin)
     */
    public List<TrainerAvailability> getPendingAvailabilitiesByTrainer(Integer trainerId) {
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT ta.*, u.UserId, u.FullName, u.Email, u.Role ");
        sqlBuilder.append("FROM Trainer_Availability ta ");
        sqlBuilder.append("JOIN Users u ON ta.TrainerId = u.UserId ");
        sqlBuilder.append("WHERE ta.Status = 'PENDING'");

        if (trainerId != null) {
            sqlBuilder.append(" AND ta.TrainerId = ?");
        }

        sqlBuilder.append(" ORDER BY ta.CreatedAt DESC");

        List<TrainerAvailability> availabilities = new ArrayList<>();

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString())) {

            int paramIndex = 1;
            if (trainerId != null) {
                stmt.setInt(paramIndex, trainerId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    availabilities.add(mapResultSetToAvailability(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availabilities;
    }

    /**
     * Lấy tất cả availabilities trong khoảng thời gian (tất cả trainer)
     */
    public List<TrainerAvailability> getAllAvailabilitiesInDateRange(java.time.LocalDate startDate,
            java.time.LocalDate endDate) {
        String sql = "SELECT ta.*, u.UserId, u.FullName, u.Email, u.Role " +
                "FROM Trainer_Availability ta " +
                "JOIN Users u ON ta.TrainerId = u.UserId " +
                "WHERE ta.AvailabilityDate >= ? AND ta.AvailabilityDate <= ? " +
                "ORDER BY ta.AvailabilityDate, ta.StartTime, u.FullName";

        List<TrainerAvailability> availabilities = new ArrayList<>();

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    availabilities.add(mapResultSetToAvailability(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availabilities;
    }

    /**
     * Map ResultSet to TrainerAvailability object
     */
    private TrainerAvailability mapResultSetToAvailability(ResultSet rs) throws SQLException {
        TrainerAvailability availability = new TrainerAvailability();
        availability.setId(rs.getInt("AvailabilityId"));
        availability.setAvailabilityDate(rs.getDate("AvailabilityDate").toLocalDate());
        availability.setStartTime(rs.getTime("StartTime").toLocalTime());
        availability.setEndTime(rs.getTime("EndTime").toLocalTime());
        availability.setStatus(rs.getString("Status"));
        availability.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            availability.setUpdatedAt(updatedAt.toInstant());
        }

        // Map trainer info
        User trainer = new User();
        trainer.setId(rs.getInt("UserId"));
        trainer.setFullName(rs.getString("FullName"));
        trainer.setEmail(rs.getString("Email"));
        trainer.setRole(rs.getString("Role"));
        availability.setTrainer(trainer);

        return availability;
    }
}
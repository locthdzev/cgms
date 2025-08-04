package DAOs;

import Models.Schedule;
import Models.User;
import DbConnection.DbConnection;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    public List<Schedule> getAllSchedules() {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "t.UserId as TrainerId, t.Username as TrainerUsername, t.FullName as TrainerFullName, " +
                "m.UserId as MemberId, m.Username as MemberUsername, m.FullName as MemberFullName " +
                "FROM Schedules s " +
                "LEFT JOIN Users t ON s.TrainerId = t.UserId " +
                "LEFT JOIN Users m ON s.MemberId = m.UserId " +
                "ORDER BY s.ScheduleDate DESC, s.ScheduleTime DESC";

        try (Connection conn = DbConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public Schedule getScheduleById(int id) {
        String sql = "SELECT s.*, " +
                "t.UserId as TrainerId, t.Username as TrainerUsername, t.FullName as TrainerFullName, " +
                "m.UserId as MemberId, m.Username as MemberUsername, m.FullName as MemberFullName " +
                "FROM Schedules s " +
                "LEFT JOIN Users t ON s.TrainerId = t.UserId " +
                "LEFT JOIN Users m ON s.MemberId = m.UserId " +
                "WHERE s.ScheduleId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSchedule(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Schedule> getSchedulesByTrainerId(int trainerId) {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "t.UserId as TrainerId, t.Username as TrainerUsername, t.FullName as TrainerFullName, " +
                "m.UserId as MemberId, m.Username as MemberUsername, m.FullName as MemberFullName " +
                "FROM Schedules s " +
                "LEFT JOIN Users t ON s.TrainerId = t.UserId " +
                "LEFT JOIN Users m ON s.MemberId = m.UserId " +
                "WHERE s.TrainerId = ? " +
                "ORDER BY s.ScheduleDate DESC, s.ScheduleTime DESC";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, trainerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Schedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public List<Schedule> getSchedulesByMemberId(int memberId) {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "t.UserId as TrainerId, t.Username as TrainerUsername, t.FullName as TrainerFullName, " +
                "m.UserId as MemberId, m.Username as MemberUsername, m.FullName as MemberFullName " +
                "FROM Schedules s " +
                "LEFT JOIN Users t ON s.TrainerId = t.UserId " +
                "LEFT JOIN Users m ON s.MemberId = m.UserId " +
                "WHERE s.MemberId = ? " +
                "ORDER BY s.ScheduleDate DESC, s.ScheduleTime DESC";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, memberId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Schedule schedule = mapResultSetToSchedule(rs);
                    schedules.add(schedule);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public void saveSchedule(Schedule schedule) {
        String sql = "INSERT INTO Schedules (TrainerId, MemberId, AvailabilityId, ScheduleDate, " +
                "ScheduleTime, DurationHours, CreatedAt, Status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, schedule.getTrainer().getId());
            if (schedule.getMember() != null && schedule.getMember().getId() != null) {
                stmt.setInt(2, schedule.getMember().getId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }

            if (schedule.getAvailability() != null) {
                stmt.setInt(3, schedule.getAvailability().getId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }

            stmt.setDate(4, Date.valueOf(schedule.getScheduleDate()));
            stmt.setTime(5, Time.valueOf(schedule.getScheduleTime()));
            stmt.setBigDecimal(6, schedule.getDurationHours());

            if (schedule.getCreatedAt() == null) {
                schedule.setCreatedAt(Instant.now());
            }
            stmt.setTimestamp(7, Timestamp.from(schedule.getCreatedAt()));
            stmt.setString(8, schedule.getStatus());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi lưu lịch tập", e);
        }
    }

    public void updateSchedule(Schedule schedule) {
        String sql = "UPDATE Schedules SET TrainerId = ?, MemberId = ?, AvailabilityId = ?, " +
                "ScheduleDate = ?, ScheduleTime = ?, DurationHours = ?, UpdatedAt = ?, Status = ? " +
                "WHERE ScheduleId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, schedule.getTrainer().getId());
            if (schedule.getMember() != null && schedule.getMember().getId() != null) {
                stmt.setInt(2, schedule.getMember().getId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }

            if (schedule.getAvailability() != null) {
                stmt.setInt(3, schedule.getAvailability().getId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }

            stmt.setDate(4, Date.valueOf(schedule.getScheduleDate()));
            stmt.setTime(5, Time.valueOf(schedule.getScheduleTime()));
            stmt.setBigDecimal(6, schedule.getDurationHours());

            schedule.setUpdatedAt(Instant.now());
            stmt.setTimestamp(7, Timestamp.from(schedule.getUpdatedAt()));
            stmt.setString(8, schedule.getStatus());
            stmt.setInt(9, schedule.getId());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi cập nhật lịch tập", e);
        }
    }

    public void deleteSchedule(int id) {
        String sql = "DELETE FROM Schedules WHERE ScheduleId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi xóa lịch tập", e);
        }
    }

    /**
     * Kiểm tra xem có lịch tập nào trùng thời gian không
     */
    public boolean hasConflictingSchedule(int trainerId, java.time.LocalDate date, java.time.LocalTime startTime,
            java.time.LocalTime endTime) {
        String sql = "SELECT COUNT(*) FROM Schedules " +
                "WHERE TrainerId = ? AND ScheduleDate = ? " +
                "AND ((ScheduleTime <= ? AND DATEADD(hour, DurationHours, CAST(CONCAT(ScheduleDate, ' ', ScheduleTime) AS datetime)) > ?) "
                +
                "OR (ScheduleTime < ? AND DATEADD(hour, DurationHours, CAST(CONCAT(ScheduleDate, ' ', ScheduleTime) AS datetime)) >= ?)) "
                +
                "AND Status NOT IN ('CANCELLED', 'COMPLETED')";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, trainerId);
            stmt.setDate(2, Date.valueOf(date));
            stmt.setTime(3, Time.valueOf(startTime));
            stmt.setTime(4, Time.valueOf(startTime));
            stmt.setTime(5, Time.valueOf(endTime));
            stmt.setTime(6, Time.valueOf(endTime));

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
     * Kiểm tra PT có lịch tập với member vào ngày cụ thể không
     */
    public boolean hasScheduleOnDate(int trainerId, java.time.LocalDate date) {
        String sql = "SELECT COUNT(*) FROM Schedules " +
                "WHERE TrainerId = ? AND ScheduleDate = ? " +
                "AND Status NOT IN ('CANCELLED', 'COMPLETED')";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, trainerId);
            stmt.setDate(2, Date.valueOf(date));

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

    // Helper method to map ResultSet to Schedule object
    private Schedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        Schedule schedule = new Schedule();
        schedule.setId(rs.getInt("ScheduleId"));

        // Map trainer
        User trainer = new User();
        trainer.setId(rs.getInt("TrainerId"));
        trainer.setUserName(rs.getString("TrainerUsername"));
        trainer.setFullName(rs.getString("TrainerFullName"));
        schedule.setTrainer(trainer);

        // Map member
        int memberId = rs.getInt("MemberId");
        if (rs.wasNull()) {
            schedule.setMember(null);
        } else {
            User member = new User();
            member.setId(memberId);
            member.setUserName(rs.getString("MemberUsername"));
            member.setFullName(rs.getString("MemberFullName"));
            schedule.setMember(member);
        }

        schedule.setScheduleDate(rs.getDate("ScheduleDate").toLocalDate());
        schedule.setScheduleTime(rs.getTime("ScheduleTime").toLocalTime());
        schedule.setDurationHours(rs.getBigDecimal("DurationHours"));

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            schedule.setCreatedAt(createdAt.toInstant());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            schedule.setUpdatedAt(updatedAt.toInstant());
        }

        schedule.setStatus(rs.getString("Status"));
        return schedule;
    }
}

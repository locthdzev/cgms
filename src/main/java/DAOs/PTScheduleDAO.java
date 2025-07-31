package DAOs;

import Models.Schedule;
import Models.User;
import DbConnection.DbConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PTScheduleDAO {
    
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

    public List<Schedule> getSchedulesByTrainerAndDateRange(int trainerId, LocalDate startDate, LocalDate endDate) {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, " +
                "t.UserId as TrainerId, t.Username as TrainerUsername, t.FullName as TrainerFullName, " +
                "m.UserId as MemberId, m.Username as MemberUsername, m.FullName as MemberFullName " +
                "FROM Schedules s " +
                "LEFT JOIN Users t ON s.TrainerId = t.UserId " +
                "LEFT JOIN Users m ON s.MemberId = m.UserId " +
                "WHERE s.TrainerId = ? AND s.ScheduleDate BETWEEN ? AND ? " +
                "ORDER BY s.ScheduleDate ASC, s.ScheduleTime ASC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, trainerId);
            stmt.setDate(2, Date.valueOf(startDate));
            stmt.setDate(3, Date.valueOf(endDate));
            
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

    public Schedule getScheduleById(int scheduleId) {
        String sql = "SELECT s.*, " +
                "t.UserId as TrainerId, t.Username as TrainerUsername, t.FullName as TrainerFullName, " +
                "m.UserId as MemberId, m.Username as MemberUsername, m.FullName as MemberFullName " +
                "FROM Schedules s " +
                "LEFT JOIN Users t ON s.TrainerId = t.UserId " +
                "LEFT JOIN Users m ON s.MemberId = m.UserId " +
                "WHERE s.ScheduleId = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, scheduleId);
            
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
            stmt.setTimestamp(7, Timestamp.from(schedule.getCreatedAt()));
            stmt.setString(8, schedule.getStatus());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi lưu lịch tập", e);
        }
    }

    public void updateSchedule(Schedule schedule) {
        String sql = "UPDATE Schedules SET MemberId = ?, ScheduleDate = ?, " +
                "ScheduleTime = ?, DurationHours = ?, UpdatedAt = ?, Status = ? " +
                "WHERE ScheduleId = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (schedule.getMember() != null && schedule.getMember().getId() != null) {
                stmt.setInt(1, schedule.getMember().getId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }

            stmt.setDate(2, Date.valueOf(schedule.getScheduleDate()));
            stmt.setTime(3, Time.valueOf(schedule.getScheduleTime()));
            stmt.setBigDecimal(4, schedule.getDurationHours());
            stmt.setTimestamp(5, Timestamp.from(schedule.getUpdatedAt()));
            stmt.setString(6, schedule.getStatus());
            stmt.setInt(7, schedule.getId());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi cập nhật lịch tập", e);
        }
    }

    public List<Schedule> getAllSchedulesByTrainer(int trainerId) {
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
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Schedule schedule = mapResultSetToSchedule(rs);
                schedules.add(schedule);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return schedules;
    }

    public void deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM Schedules WHERE ScheduleId = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, scheduleId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi xóa lịch tập", e);
        }
    }

    private Schedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        Schedule schedule = new Schedule();
        schedule.setId(rs.getInt("ScheduleId"));
        schedule.setScheduleDate(rs.getDate("ScheduleDate").toLocalDate());
        schedule.setScheduleTime(rs.getTime("ScheduleTime").toLocalTime());
        schedule.setDurationHours(rs.getBigDecimal("DurationHours"));
        schedule.setStatus(rs.getString("Status"));
        
        if (rs.getTimestamp("CreatedAt") != null) {
            schedule.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
        }
        if (rs.getTimestamp("UpdatedAt") != null) {
            schedule.setUpdatedAt(rs.getTimestamp("UpdatedAt").toInstant());
        }

        // Map trainer
        User trainer = new User();
        trainer.setId(rs.getInt("TrainerId"));
        trainer.setUserName(rs.getString("TrainerUsername"));
        trainer.setFullName(rs.getString("TrainerFullName"));
        schedule.setTrainer(trainer);

        // Map member
        int memberId = rs.getInt("MemberId");
        if (!rs.wasNull()) {
            User member = new User();
            member.setId(memberId);
            member.setUserName(rs.getString("MemberUsername"));
            member.setFullName(rs.getString("MemberFullName"));
            schedule.setMember(member);
        }

        return schedule;
    }
}

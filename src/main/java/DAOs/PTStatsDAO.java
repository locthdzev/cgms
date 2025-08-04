package DAOs;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import DbConnection.DbConnection;

public class PTStatsDAO {

    /**
     * Đếm số lịch hẹn hôm nay của PT (chưa hoàn thành)
     */
    public int getTodaySchedulesCount(int trainerId) {
        String sql = "SELECT COUNT(*) FROM Schedules WHERE TrainerId = ? AND ScheduleDate = ? AND Status IN ('Pending', 'Confirmed')";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, trainerId);
            ps.setDate(2, Date.valueOf(LocalDate.now()));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm tổng số khách hàng của PT
     */
    public int getTotalClientsCount(int trainerId) {
        String sql = "SELECT COUNT(DISTINCT MemberId) FROM Schedules WHERE TrainerId = ? AND MemberId IS NOT NULL";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, trainerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm số lịch hẹn tuần này của PT (chưa hoàn thành)
     */
    public int getThisWeekSchedulesCount(int trainerId) {
        String sql = "SELECT COUNT(*) FROM Schedules WHERE TrainerId = ? AND ScheduleDate >= ? AND ScheduleDate <= ? AND Status IN ('Pending', 'Confirmed')";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            LocalDate today = LocalDate.now();
            LocalDate startOfWeek = today.minusDays(today.getDayOfWeek().getValue() - 1);
            LocalDate endOfWeek = startOfWeek.plusDays(6);

            ps.setInt(1, trainerId);
            ps.setDate(2, Date.valueOf(startOfWeek));
            ps.setDate(3, Date.valueOf(endOfWeek));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm số lịch đã hoàn thành của PT
     */
    public int getCompletedSchedulesCount(int trainerId) {
        String sql = "SELECT COUNT(*) FROM Schedules WHERE TrainerId = ? AND Status = 'Completed'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, trainerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy thống kê theo tuần (7 ngày gần nhất) - tất cả lịch không bị hủy
     */
    public List<Integer> getWeeklyScheduleStats(int trainerId) {
        List<Integer> stats = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM Schedules WHERE TrainerId = ? AND ScheduleDate = ? AND Status != 'Cancelled'";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            LocalDate today = LocalDate.now();
            for (int i = 6; i >= 0; i--) {
                LocalDate date = today.minusDays(i);
                ps.setInt(1, trainerId);
                ps.setDate(2, Date.valueOf(date));

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.add(rs.getInt(1));
                    } else {
                        stats.add(0);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Trả về 7 ngày với giá trị 0
            for (int i = 0; i < 7; i++) {
                stats.add(0);
            }
        }
        return stats;
    }

    /**
     * Lấy thống kê theo tháng (4 tuần gần nhất) - tất cả lịch không bị hủy
     */
    public List<Integer> getMonthlyScheduleStats(int trainerId) {
        List<Integer> stats = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM Schedules WHERE TrainerId = ? AND ScheduleDate >= ? AND ScheduleDate <= ? AND Status != 'Cancelled'";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            LocalDate today = LocalDate.now();
            for (int week = 3; week >= 0; week--) {
                LocalDate startOfWeek = today.minusDays(week * 7 + today.getDayOfWeek().getValue() - 1);
                LocalDate endOfWeek = startOfWeek.plusDays(6);

                ps.setInt(1, trainerId);
                ps.setDate(2, Date.valueOf(startOfWeek));
                ps.setDate(3, Date.valueOf(endOfWeek));

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.add(rs.getInt(1));
                    } else {
                        stats.add(0);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Trả về 4 tuần với giá trị 0
            for (int i = 0; i < 4; i++) {
                stats.add(0);
            }
        }
        return stats;
    }

    /**
     * Lấy thống kê khách hàng theo mục tiêu (dữ liệu mẫu)
     */
    public List<Integer> getClientGoalStats(int trainerId) {
        List<Integer> stats = new ArrayList<>();
        // Tạm thời trả về dữ liệu mẫu, có thể mở rộng sau
        stats.add(35); // Giảm cân
        stats.add(30); // Tăng cơ
        stats.add(25); // Sức khỏe
        stats.add(10); // Phục hồi chấn thương
        return stats;
    }
}
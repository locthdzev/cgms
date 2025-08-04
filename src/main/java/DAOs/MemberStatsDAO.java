package DAOs;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import DbConnection.DbConnection;

public class MemberStatsDAO {

    /**
     * Đếm số buổi tập đã hoàn thành của member
     */
    public int getCompletedSessionsCount(int memberId) {
        String sql = "SELECT COUNT(*) FROM Schedules WHERE MemberId = ? AND Status = 'Completed'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, memberId);

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
     * Đếm số buổi tập sắp tới của member (Pending, Confirmed)
     */
    public int getUpcomingSessionsCount(int memberId) {
        String sql = "SELECT COUNT(*) FROM Schedules WHERE MemberId = ? AND Status IN ('Pending', 'Confirmed') AND ScheduleDate >= ?";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, memberId);
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
     * Đếm số đơn hàng đã hoàn thành của member
     */
    public int getTotalOrdersCount(int memberId) {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE MemberId = ? AND Status = 'COMPLETED'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, memberId);

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
     * Lấy điểm tích lũy của member (tạm thời tính dựa trên số buổi tập đã hoàn
     * thành)
     */
    public int getLoyaltyPoints(int memberId) {
        // Tạm thời tính 10 điểm cho mỗi buổi tập hoàn thành
        int completedSessions = getCompletedSessionsCount(memberId);
        return completedSessions * 10;
    }

    /**
     * Lấy hoạt động gần đây của member (lịch tập và đơn hàng)
     */
    public List<Map<String, Object>> getRecentActivities(int memberId) {
        List<Map<String, Object>> activities = new ArrayList<>();

        // Lấy lịch tập gần đây (đã hoàn thành)
        String schedulesSql = "SELECT TOP 5 'schedule' as type, s.ScheduleDate as date, s.Status, " +
                "t.FullName as trainerName, s.CreatedAt " +
                "FROM Schedules s " +
                "LEFT JOIN Users t ON s.TrainerId = t.UserId " +
                "WHERE s.MemberId = ? AND s.Status = 'Completed' " +
                "ORDER BY s.ScheduleDate DESC";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(schedulesSql)) {

            ps.setInt(1, memberId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("type", "schedule");
                    activity.put("title", "Hoàn thành buổi tập với PT");
                    activity.put("description", "Bạn đã hoàn thành buổi tập với PT " + rs.getString("trainerName"));
                    activity.put("date", rs.getDate("date").toLocalDate());
                    activity.put("createdAt", rs.getTimestamp("CreatedAt").toInstant());
                    activity.put("icon", "fas fa-dumbbell");
                    activity.put("iconColor", "bg-gradient-primary");
                    activities.add(activity);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Lấy đơn hàng gần đây
        String ordersSql = "SELECT TOP 3 'order' as type, o.OrderDate as date, o.TotalAmount, o.Status, o.CreatedAt " +
                "FROM [Order] o " +
                "WHERE o.MemberId = ? " +
                "ORDER BY o.OrderDate DESC";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(ordersSql)) {

            ps.setInt(1, memberId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("type", "order");
                    activity.put("title", "Mua sản phẩm");
                    activity.put("description", "Bạn đã đặt đơn hàng trị giá " + rs.getBigDecimal("TotalAmount") + "đ");
                    activity.put("date", rs.getDate("date").toLocalDate());
                    activity.put("createdAt", rs.getTimestamp("CreatedAt").toInstant());
                    activity.put("icon", "fas fa-shopping-cart");
                    activity.put("iconColor", "bg-gradient-success");
                    activities.add(activity);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Sắp xếp theo thời gian tạo (mới nhất trước)
        activities.sort(
                (a, b) -> ((java.time.Instant) b.get("createdAt")).compareTo((java.time.Instant) a.get("createdAt")));

        return activities;
    }

    /**
     * Lấy thống kê buổi tập theo tuần (7 ngày gần đây)
     */
    public List<Integer> getWeeklyWorkoutStats(int memberId) {
        List<Integer> weeklyStats = new ArrayList<>();
        LocalDate today = LocalDate.now();

        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            String sql = "SELECT COUNT(*) FROM Schedules WHERE MemberId = ? AND ScheduleDate = ? AND Status = 'Completed'";

            try (Connection conn = DbConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, memberId);
                ps.setDate(2, Date.valueOf(date));

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        weeklyStats.add(rs.getInt(1));
                    } else {
                        weeklyStats.add(0);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                weeklyStats.add(0);
            }
        }

        return weeklyStats;
    }

    /**
     * Lấy thống kê chi tiêu theo tháng (4 tuần gần đây)
     */
    public List<Double> getMonthlySpendingStats(int memberId) {
        List<Double> monthlyStats = new ArrayList<>();
        LocalDate today = LocalDate.now();

        for (int i = 3; i >= 0; i--) {
            LocalDate startWeek = today.minusWeeks(i + 1);
            LocalDate endWeek = today.minusWeeks(i);

            String sql = "SELECT COALESCE(SUM(TotalAmount), 0) FROM [Order] WHERE MemberId = ? AND OrderDate BETWEEN ? AND ? AND Status = 'COMPLETED'";

            try (Connection conn = DbConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, memberId);
                ps.setDate(2, Date.valueOf(startWeek));
                ps.setDate(3, Date.valueOf(endWeek));

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        monthlyStats.add(rs.getDouble(1));
                    } else {
                        monthlyStats.add(0.0);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                monthlyStats.add(0.0);
            }
        }

        return monthlyStats;
    }

    /**
     * Lấy thống kê tiến độ gói tập
     */
    public Map<String, Object> getPackageProgressStats(int memberId) {
        Map<String, Object> stats = new HashMap<>();

        String sql = "SELECT TOP 1 mp.StartDate, mp.EndDate, mp.RemainingSessions, p.Sessions, p.Name " +
                "FROM Member_Packages mp " +
                "LEFT JOIN Packages p ON mp.PackageId = p.PackageId " +
                "WHERE mp.MemberId = ? AND mp.Status = 'Active' AND mp.EndDate >= ? " +
                "ORDER BY mp.EndDate DESC";

        System.out.println("=== DEBUG getPackageProgressStats ===");
        System.out.println("Member ID: " + memberId);
        System.out.println("SQL: " + sql);
        System.out.println("Today: " + LocalDate.now());

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            ps.setDate(2, Date.valueOf(LocalDate.now()));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LocalDate startDate = rs.getDate("StartDate").toLocalDate();
                    LocalDate endDate = rs.getDate("EndDate").toLocalDate();
                    int remainingSessions = rs.getInt("RemainingSessions");
                    int totalSessions = rs.getInt("Sessions");
                    String packageName = rs.getString("Name");

                    System.out.println("Found package: " + packageName);
                    System.out.println("Start Date: " + startDate);
                    System.out.println("End Date: " + endDate);
                    System.out.println("Remaining Sessions: " + remainingSessions);
                    System.out.println("Total Sessions: " + totalSessions);

                    int usedSessions = totalSessions - remainingSessions;
                    int sessionProgress = totalSessions > 0 ? (usedSessions * 100) / totalSessions : 0;

                    long totalDays = java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate);
                    long usedDays = java.time.temporal.ChronoUnit.DAYS.between(startDate, LocalDate.now());
                    int timeProgress = totalDays > 0 ? (int) ((usedDays * 100) / totalDays) : 0;

                    if (timeProgress > 100)
                        timeProgress = 100;
                    if (timeProgress < 0)
                        timeProgress = 0;

                    stats.put("hasPackage", true);
                    stats.put("packageName", packageName);
                    stats.put("sessionProgress", sessionProgress);
                    stats.put("timeProgress", timeProgress);
                    stats.put("usedSessions", usedSessions);
                    stats.put("totalSessions", totalSessions);
                    stats.put("remainingSessions", remainingSessions);

                    System.out.println("Package stats created successfully");
                } else {
                    System.out.println("No active package found for member " + memberId);
                    stats.put("hasPackage", false);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getPackageProgressStats: " + e.getMessage());
            e.printStackTrace();
            stats.put("hasPackage", false);
        }

        System.out.println("Final stats: " + stats);
        System.out.println("=== END DEBUG ===");

        return stats;
    }
}
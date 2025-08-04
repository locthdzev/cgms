package Services;

import DAOs.MemberStatsDAO;
import java.util.List;
import java.util.Map;

public class MemberStatsService {
    private MemberStatsDAO memberStatsDAO = new MemberStatsDAO();

    /**
     * Lấy số buổi tập đã hoàn thành của member
     */
    public int getCompletedSessionsCount(int memberId) {
        return memberStatsDAO.getCompletedSessionsCount(memberId);
    }

    /**
     * Lấy số buổi tập sắp tới của member
     */
    public int getUpcomingSessionsCount(int memberId) {
        return memberStatsDAO.getUpcomingSessionsCount(memberId);
    }

    /**
     * Lấy tổng số đơn hàng của member
     */
    public int getTotalOrdersCount(int memberId) {
        return memberStatsDAO.getTotalOrdersCount(memberId);
    }

    /**
     * Lấy điểm tích lũy của member
     */
    public int getLoyaltyPoints(int memberId) {
        return memberStatsDAO.getLoyaltyPoints(memberId);
    }

    /**
     * Lấy hoạt động gần đây của member
     */
    public List<Object> getRecentActivities(int memberId) {
        List<Map<String, Object>> activities = memberStatsDAO.getRecentActivities(memberId);
        return (List<Object>) (List<?>) activities;
    }

    /**
     * Lấy thống kê buổi tập theo tuần
     */
    public List<Integer> getWeeklyWorkoutStats(int memberId) {
        return memberStatsDAO.getWeeklyWorkoutStats(memberId);
    }

    /**
     * Lấy thống kê chi tiêu theo tháng
     */
    public List<Double> getMonthlySpendingStats(int memberId) {
        return memberStatsDAO.getMonthlySpendingStats(memberId);
    }

    /**
     * Lấy thống kê tiến độ gói tập
     */
    public Map<String, Object> getPackageProgressStats(int memberId) {
        return memberStatsDAO.getPackageProgressStats(memberId);
    }
}
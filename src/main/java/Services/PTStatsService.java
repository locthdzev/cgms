package Services;

import DAOs.PTStatsDAO;
import java.util.List;

public class PTStatsService {
    private PTStatsDAO ptStatsDAO = new PTStatsDAO();

    /**
     * Lấy số lịch hẹn hôm nay của PT
     */
    public int getTodaySchedulesCount(int trainerId) {
        return ptStatsDAO.getTodaySchedulesCount(trainerId);
    }

    /**
     * Lấy tổng số khách hàng của PT
     */
    public int getTotalClientsCount(int trainerId) {
        return ptStatsDAO.getTotalClientsCount(trainerId);
    }

    /**
     * Lấy số lịch hẹn tuần này của PT
     */
    public int getThisWeekSchedulesCount(int trainerId) {
        return ptStatsDAO.getThisWeekSchedulesCount(trainerId);
    }

    /**
     * Lấy số lịch đã hoàn thành của PT
     */
    public int getCompletedSchedulesCount(int trainerId) {
        return ptStatsDAO.getCompletedSchedulesCount(trainerId);
    }

    /**
     * Lấy thống kê theo tuần (7 ngày gần nhất)
     */
    public List<Integer> getWeeklyScheduleStats(int trainerId) {
        return ptStatsDAO.getWeeklyScheduleStats(trainerId);
    }

    /**
     * Lấy thống kê theo tháng (4 tuần gần nhất)
     */
    public List<Integer> getMonthlyScheduleStats(int trainerId) {
        return ptStatsDAO.getMonthlyScheduleStats(trainerId);
    }

    /**
     * Lấy thống kê khách hàng theo mục tiêu
     */
    public List<Integer> getClientGoalStats(int trainerId) {
        return ptStatsDAO.getClientGoalStats(trainerId);
    }
}
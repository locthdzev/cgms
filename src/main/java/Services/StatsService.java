package Services;

import DAOs.StatsDAO;

public class StatsService {
    private StatsDAO statsDAO = new StatsDAO();

    /**
     * Lấy số lượng thành viên đang hoạt động
     * 
     * @return Số lượng thành viên Active
     */
    public int getActiveMembersCount() {
        return statsDAO.countActiveMembers();
    }

    /**
     * Lấy số lượng huấn luyện viên đang hoạt động
     * 
     * @return Số lượng huấn luyện viên Active
     */
    public int getActiveTrainersCount() {
        return statsDAO.countActiveTrainers();
    }

    /**
     * Lấy số lượng gói tập đang hoạt động
     * 
     * @return Số lượng gói tập Active
     */
    public int getActivePackagesCount() {
        return statsDAO.countActivePackages();
    }
}
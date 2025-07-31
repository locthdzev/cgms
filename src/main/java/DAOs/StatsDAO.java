package DAOs;

import java.sql.*;
import DbConnection.DbConnection;

public class StatsDAO {

    /**
     * Đếm số lượng thành viên đang hoạt động
     * 
     * @return Số lượng thành viên có trạng thái Active và role là Member
     */
    public int countActiveMembers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE Status = 'Active' AND Role = 'Member'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm số lượng huấn luyện viên đang hoạt động
     * 
     * @return Số lượng huấn luyện viên có trạng thái Active và role là Personal
     *         Trainer
     */
    public int countActiveTrainers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE Status = 'Active' AND Role = 'Personal Trainer'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm số lượng gói tập đang hoạt động
     * 
     * @return Số lượng gói tập có trạng thái Active
     */
    public int countActivePackages() {
        String sql = "SELECT COUNT(*) FROM Packages WHERE Status = 'Active'";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
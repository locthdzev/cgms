package DAOs;

import Models.Checkin;
import Models.User;
import DbConnection.DbConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class CheckinDAO {
    public List<Checkin> getCheckinHistoryByMemberId(int memberId) {
        List<Checkin> list = new ArrayList<>();
        String sql = "SELECT c.*, u.FullName, u.UserName FROM Checkins c JOIN Users u ON c.MemberId = u.UserId WHERE c.MemberId = ? ORDER BY c.CheckinDate DESC, c.CheckinTime DESC";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Checkin c = new Checkin();
                c.setId(rs.getInt("CheckinId"));
                User member = new User();
                member.setId(rs.getInt("MemberId"));
                member.setFullName(rs.getString("FullName"));
                member.setUserName(rs.getString("UserName"));
                c.setMember(member);
                c.setCheckinDate(rs.getDate("CheckinDate").toLocalDate());
                c.setCheckinTime(rs.getTime("CheckinTime").toLocalTime());
                c.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                c.setStatus(rs.getString("Status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Checkin> getAllCheckins() {
        List<Checkin> list = new ArrayList<>();
        String sql = "SELECT c.*, u.FullName, u.UserName FROM Checkins c JOIN Users u ON c.MemberId = u.UserId ORDER BY c.CheckinDate DESC, c.CheckinTime DESC";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Checkin c = new Checkin();
                c.setId(rs.getInt("CheckinId"));
                User member = new User();
                member.setId(rs.getInt("MemberId"));
                member.setFullName(rs.getString("FullName"));
                member.setUserName(rs.getString("UserName"));
                c.setMember(member);
                c.setCheckinDate(rs.getDate("CheckinDate").toLocalDate());
                c.setCheckinTime(rs.getTime("CheckinTime").toLocalTime());
                c.setCreatedAt(rs.getTimestamp("CreatedAt").toInstant());
                c.setStatus(rs.getString("Status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void createCheckinForUser(int userId) {
        String sql = "INSERT INTO Checkins (MemberId, CheckinDate, CheckinTime, CreatedAt, Status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, java.sql.Date.valueOf(LocalDate.now()));
            ps.setTime(3, java.sql.Time.valueOf(LocalTime.now()));
            ps.setTimestamp(4, Timestamp.from(Instant.now()));
            ps.setString(5, "Đã check-in");
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

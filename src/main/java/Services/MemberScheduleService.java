package Services;

import DAOs.ScheduleDAO;
import Models.Schedule;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MemberScheduleService {
    private ScheduleDAO scheduleDAO = new ScheduleDAO();

    /**
     * Lấy lịch tập sắp tới của member (7 ngày tới)
     */
    public List<Schedule> getUpcomingSchedules(int memberId) {
        try {
            List<Schedule> allSchedules = scheduleDAO.getSchedulesByMemberId(memberId);
            List<Schedule> upcomingSchedules = new ArrayList<>();

            LocalDate today = LocalDate.now();
            LocalDate nextWeek = today.plusDays(7);

            for (Schedule schedule : allSchedules) {
                // Chỉ lấy lịch sắp tới chưa hoàn thành (Pending, Confirmed)
                if ((schedule.getScheduleDate().isEqual(today) || schedule.getScheduleDate().isAfter(today)) &&
                        schedule.getScheduleDate().isBefore(nextWeek.plusDays(1)) &&
                        ("Pending".equals(schedule.getStatus()) || "Confirmed".equals(schedule.getStatus()))) {
                    upcomingSchedules.add(schedule);
                }
            }

            // Sắp xếp theo ngày và giờ
            upcomingSchedules.sort((a, b) -> {
                int dateCompare = a.getScheduleDate().compareTo(b.getScheduleDate());
                if (dateCompare != 0) {
                    return dateCompare;
                }
                return a.getScheduleTime().compareTo(b.getScheduleTime());
            });

            return upcomingSchedules;
        } catch (Exception e) {
            System.err.println("Error getting upcoming schedules for member: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
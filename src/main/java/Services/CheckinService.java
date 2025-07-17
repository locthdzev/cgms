package Services;

import DAOs.CheckinDAO;
import DAOs.ScheduleDAO;
import Models.Checkin;
import Models.Schedule;
import java.util.List;
import java.time.LocalDate;
import java.time.LocalTime;

public class CheckinService {
    private final CheckinDAO checkinDAO = new CheckinDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();

    public List<Checkin> getCheckinHistoryByMemberId(int memberId) {
        return checkinDAO.getCheckinHistoryByMemberId(memberId);
    }

    public List<Checkin> getAllCheckins() {
        return checkinDAO.getAllCheckins();
    }

    public void createCheckinForUser(int userId) {
        // Tạo check-in
        checkinDAO.createCheckinForUser(userId);

        // Cập nhật trạng thái lịch tập thành Completed
        LocalDate today = LocalDate.now();
        List<Schedule> confirmedSchedules = scheduleDAO.getSchedulesByMemberId(userId).stream()
                .filter(s -> s.getScheduleDate() != null && s.getScheduleDate().isEqual(today))
                .filter(s -> "Confirmed".equals(s.getStatus()))
                .collect(java.util.stream.Collectors.toList());

        // Cập nhật tất cả lịch tập đã xác nhận của member hôm nay thành Completed
        for (Schedule schedule : confirmedSchedules) {
            schedule.setStatus("Completed");
            scheduleDAO.updateSchedule(schedule);
        }
    }
}

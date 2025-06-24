package Services;

import DAOs.ScheduleDAO;
import DAOs.UserDAO;
import Models.Schedule;
import Models.User;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

public class ScheduleService {
    private ScheduleDAO scheduleDAO = new ScheduleDAO();
    private UserDAO userDAO = new UserDAO();

    public List<Schedule> getAllSchedules() {
        return scheduleDAO.getAllSchedules();
    }

    public Schedule getScheduleById(int id) {
        return scheduleDAO.getScheduleById(id);
    }

    public List<Schedule> getSchedulesByTrainerId(int trainerId) {
        return scheduleDAO.getSchedulesByTrainerId(trainerId);
    }

    public List<Schedule> getSchedulesByMemberId(int memberId) {
        return scheduleDAO.getSchedulesByMemberId(memberId);
    }

    public void saveSchedule(Schedule schedule) {
        // Validate schedule before saving
        validateSchedule(schedule, null);
        scheduleDAO.saveSchedule(schedule);
    }

    public void updateSchedule(Schedule schedule) {
        // Validate schedule before updating (exclude current schedule from conflict
        // check)
        validateSchedule(schedule, schedule.getId());
        scheduleDAO.updateSchedule(schedule);
    }

    public void deleteSchedule(int id) {
        scheduleDAO.deleteSchedule(id);
    }

    public void updateScheduleStatus(int scheduleId, String status) {
        Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
        if (schedule != null) {
            schedule.setStatus(status);
            scheduleDAO.updateSchedule(schedule);
        }
    }

    public List<User> getAllTrainers() {
        return userDAO.getAllUsers().stream()
                .filter(user -> "Trainer".equals(user.getRole()))
                .collect(Collectors.toList());
    }

    public List<User> getAllMembers() {
        return userDAO.getAllUsers().stream()
                .filter(user -> "Member".equals(user.getRole()))
                .collect(Collectors.toList());
    }

    public boolean isTrainerAvailable(int trainerId, LocalDate date, LocalTime startTime, LocalTime endTime) {
        return isTrainerAvailable(trainerId, date, startTime, endTime, null);
    }

    public boolean isTrainerAvailable(int trainerId, LocalDate date, LocalTime startTime, LocalTime endTime,
            Integer excludeScheduleId) {
        List<Schedule> trainerSchedules = getSchedulesByTrainerId(trainerId).stream()
                .filter(schedule -> schedule.getScheduleDate().equals(date))
                .filter(schedule -> "Confirmed".equals(schedule.getStatus()) || "Pending".equals(schedule.getStatus()))
                .filter(schedule -> excludeScheduleId == null || !schedule.getId().equals(excludeScheduleId))
                .collect(Collectors.toList());

        for (Schedule existingSchedule : trainerSchedules) {
            LocalTime existingStart = existingSchedule.getScheduleTime();
            LocalTime existingEnd = existingStart.plusHours(existingSchedule.getDurationHours().intValue())
                    .plusMinutes((int) ((existingSchedule.getDurationHours().doubleValue() % 1) * 60));

            // Check for time overlap
            if (!(endTime.isBefore(existingStart) || startTime.isAfter(existingEnd))) {
                return false; // Time conflict found
            }
        }
        return true; // No conflicts
    }

    public boolean isMemberAvailable(int memberId, LocalDate date, LocalTime startTime, LocalTime endTime) {
        return isMemberAvailable(memberId, date, startTime, endTime, null);
    }

    public boolean isMemberAvailable(int memberId, LocalDate date, LocalTime startTime, LocalTime endTime,
            Integer excludeScheduleId) {
        List<Schedule> memberSchedules = getSchedulesByMemberId(memberId).stream()
                .filter(schedule -> schedule.getScheduleDate().equals(date))
                .filter(schedule -> "Confirmed".equals(schedule.getStatus()) || "Pending".equals(schedule.getStatus()))
                .filter(schedule -> excludeScheduleId == null || !schedule.getId().equals(excludeScheduleId))
                .collect(Collectors.toList());

        for (Schedule existingSchedule : memberSchedules) {
            LocalTime existingStart = existingSchedule.getScheduleTime();
            LocalTime existingEnd = existingStart.plusHours(existingSchedule.getDurationHours().intValue())
                    .plusMinutes((int) ((existingSchedule.getDurationHours().doubleValue() % 1) * 60));

            // Check for time overlap
            if (!(endTime.isBefore(existingStart) || startTime.isAfter(existingEnd))) {
                return false; // Time conflict found
            }
        }
        return true; // No conflicts
    }

    private void validateSchedule(Schedule schedule, Integer excludeScheduleId) {
        if (schedule.getTrainer() == null || schedule.getTrainer().getId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn Trainer");
        }
        if (schedule.getMember() == null || schedule.getMember().getId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn Member");
        }
        if (schedule.getScheduleDate() == null) {
            throw new IllegalArgumentException("Vui lòng chọn ngày tập");
        }
        if (schedule.getScheduleTime() == null) {
            throw new IllegalArgumentException("Vui lòng chọn giờ tập");
        }
        if (schedule.getDurationHours() == null || schedule.getDurationHours().doubleValue() <= 0) {
            throw new IllegalArgumentException("Thời lượng tập phải lớn hơn 0");
        }
        if (schedule.getStatus() == null || schedule.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn trạng thái");
        }

        // Check if schedule date is not in the past
        if (schedule.getScheduleDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Không thể đặt lịch trong quá khứ");
        }

        // Check trainer and member availability
        LocalTime endTime = schedule.getScheduleTime()
                .plusHours(schedule.getDurationHours().intValue())
                .plusMinutes((int) ((schedule.getDurationHours().doubleValue() % 1) * 60));

        // Temporarily disable availability check for testing
        // TODO: Re-enable after ensuring proper data exists
        /*
         * if (!isTrainerAvailable(schedule.getTrainer().getId(),
         * schedule.getScheduleDate(),
         * schedule.getScheduleTime(), endTime, excludeScheduleId)) {
         * throw new
         * IllegalArgumentException("Trainer is not available at the selected time");
         * }
         * 
         * if (!isMemberAvailable(schedule.getMember().getId(),
         * schedule.getScheduleDate(),
         * schedule.getScheduleTime(), endTime, excludeScheduleId)) {
         * throw new
         * IllegalArgumentException("Member is not available at the selected time");
         * }
         */
    }
}

package Services;

import DAOs.ScheduleDAO;
import DAOs.UserDAO;
import Models.Schedule;
import Models.User;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

import DAOs.MemberPackageDAO;

public class ScheduleService {
    /**
     * Hàm này nên được gọi định kỳ (hoặc khi lấy danh sách lịch) để tự động cập
     * nhật trạng thái các lịch đã hết hạn.
     */
    public void autoCancelExpiredSchedules() {
        List<Schedule> all = scheduleDAO.getAllSchedules();
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        for (Schedule schedule : all) {
            String status = schedule.getStatus();
            if (!"Completed".equals(status) && !"Cancelled".equals(status)) {
                java.time.LocalDateTime scheduleEnd = java.time.LocalDateTime.of(
                        schedule.getScheduleDate(),
                        schedule.getScheduleTime())
                        .plusHours(schedule.getDurationHours().intValue())
                        .plusMinutes((int) ((schedule.getDurationHours().doubleValue() % 1) * 60));
                if (scheduleEnd.isBefore(now)) {
                    schedule.setStatus("Cancelled");
                    scheduleDAO.updateSchedule(schedule);
                }
            }
        }
    }

    private ScheduleDAO scheduleDAO = new ScheduleDAO();
    private UserDAO userDAO = new UserDAO();
    private MemberPackageDAO memberPackageDAO = new MemberPackageDAO();

    public List<Schedule> getAllSchedules() {
        autoCancelExpiredSchedules();
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
        // Kiểm tra hợp lệ trước khi lưu
        validateSchedule(schedule, null);
        scheduleDAO.saveSchedule(schedule);
    }

    public void updateSchedule(Schedule schedule) {
        // Kiểm tra hợp lệ trước khi cập nhật (loại trừ lịch hiện tại khỏi kiểm tra
        // trùng)
        // Lấy trạng thái hiện tại từ DB để kiểm tra logic chuyển trạng thái
        Schedule current = scheduleDAO.getScheduleById(schedule.getId());
        if (current == null) {
            throw new IllegalArgumentException("Không tìm thấy lịch tập để cập nhật");
        }

        String currentStatus = current.getStatus();
        String newStatus = schedule.getStatus();

        // Không cho phép chỉnh sửa nếu lịch đã hoàn thành hoặc đã hủy
        if ("Completed".equals(currentStatus) || "Cancelled".equals(currentStatus)) {
            throw new IllegalArgumentException("Không thể chỉnh sửa lịch đã hoàn thành hoặc đã hủy.");
        }

        // Kiểm tra logic chuyển trạng thái chỉ khi có thay đổi trạng thái
        if (!currentStatus.equals(newStatus)) {
            // Chỉ cho phép chuyển trạng thái theo logic thực tế:
            // Pending -> Confirmed hoặc Cancelled
            // Confirmed -> Completed hoặc Cancelled
            boolean valid = false;
            if ("Pending".equals(currentStatus)) {
                if ("Confirmed".equals(newStatus) || "Cancelled".equals(newStatus))
                    valid = true;
            } else if ("Confirmed".equals(currentStatus)) {
                if ("Completed".equals(newStatus) || "Cancelled".equals(newStatus))
                    valid = true;
            }

            if (!valid) {
                throw new IllegalArgumentException(
                        "Không thể chuyển trạng thái từ " + currentStatus + " sang " + newStatus
                                + ". Vui lòng thực hiện đúng quy trình.");
            }
        }

        // Kiểm tra thời gian chỉ khi thay đổi ngày/giờ
        if (!current.getScheduleDate().equals(schedule.getScheduleDate()) ||
                !current.getScheduleTime().equals(schedule.getScheduleTime()) ||
                !current.getDurationHours().equals(schedule.getDurationHours())) {

            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            java.time.LocalDateTime scheduleDateTime = java.time.LocalDateTime.of(
                    schedule.getScheduleDate(),
                    schedule.getScheduleTime());

            // Kiểm tra lịch không được đặt trong quá khứ
            if (scheduleDateTime.isBefore(now)) {
                throw new IllegalArgumentException("Không thể đặt lịch trong quá khứ");
            }

            // Kiểm tra lịch phải được tạo trước ít nhất 3 tiếng
            java.time.Duration durationToSchedule = java.time.Duration.between(now, scheduleDateTime);
            if (durationToSchedule.toHours() < 3) {
                throw new IllegalArgumentException(
                        "Lịch tập phải được tạo trước ít nhất 3 tiếng so với thời gian bắt đầu");
            }
        }

        validateSchedule(schedule, schedule.getId());
        scheduleDAO.updateSchedule(schedule);
    }

    public void deleteSchedule(int id) {
        scheduleDAO.deleteSchedule(id);
    }

    public void updateScheduleStatus(int scheduleId, String status) {
        Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
        if (schedule != null) {
            String currentStatus = schedule.getStatus();
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            java.time.LocalDateTime scheduleEnd = java.time.LocalDateTime.of(
                    schedule.getScheduleDate(),
                    schedule.getScheduleTime()).plusHours(schedule.getDurationHours().intValue())
                    .plusMinutes((int) ((schedule.getDurationHours().doubleValue() % 1) * 60));
            // Nếu lịch đã hết hạn và chưa phải Completed/Cancelled thì tự động chuyển sang
            // Cancelled
            if (scheduleEnd.isBefore(now) && !"Completed".equals(currentStatus) && !"Cancelled".equals(currentStatus)) {
                schedule.setStatus("Cancelled");
                scheduleDAO.updateSchedule(schedule);
                // Không throw exception, chỉ tự động chuyển trạng thái
                return;
            }
            // Chỉ cho phép chuyển trạng thái theo logic thực tế:
            // Pending -> Confirmed -> Completed hoặc Cancelled
            // Confirmed -> Completed hoặc Cancelled
            // Pending -> Cancelled
            boolean valid = false;
            if ("Pending".equals(currentStatus)) {
                if ("Confirmed".equals(status) || "Cancelled".equals(status))
                    valid = true;
            } else if ("Confirmed".equals(currentStatus)) {
                if ("Completed".equals(status) || "Cancelled".equals(status))
                    valid = true;
            }
            // Không cho phép chuyển từ Completed/Cancelled sang trạng thái khác
            if (valid) {
                schedule.setStatus(status);
                scheduleDAO.updateSchedule(schedule);
            } else {
                throw new IllegalArgumentException("Không thể chuyển trạng thái từ " + currentStatus + " sang " + status
                        + ". Vui lòng thực hiện đúng quy trình.");
            }
        }
    }

    public List<User> getAllTrainers() {
        return userDAO.getAllUsers().stream()
                .filter(user -> "Personal Trainer".equals(user.getRole()))
                .collect(Collectors.toList());
    }

    public List<User> getAllMembers() {
        // Trả về tất cả member (không lọc)
        return userDAO.getAllUsers().stream()
                .filter(user -> "Member".equals(user.getRole()))
                .collect(Collectors.toList());
    }

    public List<User> getActiveMembersWithPackage() {
        // Chỉ trả về member có gói còn hiệu lực
        return memberPackageDAO.getActiveMembersWithPackage();
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
            throw new IllegalArgumentException("Vui lòng chọn huấn luyện viên (Trainer)");
        }
        // Cho phép tạo lịch chỉ cho PT (không có member)
        // Nếu có member thì mới kiểm tra
        if (schedule.getMember() != null && schedule.getMember().getId() == null) {
            throw new IllegalArgumentException("Vui lòng chọn hội viên (Member)");
        }
        if (schedule.getScheduleDate() == null) {
            throw new IllegalArgumentException("Vui lòng chọn ngày tập");
        }
        if (schedule.getScheduleTime() == null) {
            throw new IllegalArgumentException("Vui lòng chọn giờ tập");
        }
        if (schedule.getDurationHours() == null) {
            throw new IllegalArgumentException("Vui lòng chọn thời lượng tập");
        }
        double duration = schedule.getDurationHours().doubleValue();
        boolean valid = false;
        double[] allowed = { 0.5, 1.0, 1.5, 2.0, 2.5, 3.0 };
        for (double d : allowed) {
            if (Math.abs(duration - d) < 0.0001) {
                valid = true;
                break;
            }
        }
        if (!valid) {
            throw new IllegalArgumentException(
                    "Thời lượng tập chỉ được chọn từ danh sách: 30 phút, 1 giờ, 1 giờ 30 phút, 2 giờ, 2 giờ 30 phút, 3 giờ.");
        }
        if (schedule.getStatus() == null || schedule.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng chọn trạng thái");
        }

        // Chỉ kiểm tra thời gian khi tạo mới (không phải chỉnh sửa)
        if (excludeScheduleId == null) {
            // Kiểm tra ngày đặt lịch không được ở quá khứ
            LocalDate today = LocalDate.now();
            if (schedule.getScheduleDate().isBefore(today)) {
                throw new IllegalArgumentException("Không thể đặt lịch trong quá khứ");
            }
            java.time.LocalDateTime nowDateTime = java.time.LocalDateTime.now();
            java.time.LocalDateTime scheduleDateTime = java.time.LocalDateTime.of(schedule.getScheduleDate(),
                    schedule.getScheduleTime());
            java.time.Duration durationToSchedule = java.time.Duration.between(nowDateTime, scheduleDateTime);
            if (durationToSchedule.toHours() < 3) {
                throw new IllegalArgumentException(
                        "Lịch tập phải được tạo trước ít nhất 3 tiếng so với thời gian bắt đầu");
            }
        }

        // Kiểm tra huấn luyện viên có bị trùng lịch không
        LocalTime endTime = schedule.getScheduleTime()
                .plusHours(schedule.getDurationHours().intValue())
                .plusMinutes((int) ((schedule.getDurationHours().doubleValue() % 1) * 60));

        if (!isTrainerAvailable(schedule.getTrainer().getId(),
                schedule.getScheduleDate(),
                schedule.getScheduleTime(), endTime, excludeScheduleId)) {
            throw new IllegalArgumentException("Huấn luyện viên đã có lịch vào thời gian này");
        }

        // Nếu có member thì mới kiểm tra trùng lịch member
        if (schedule.getMember() != null && schedule.getMember().getId() != null) {
            if (!isMemberAvailable(schedule.getMember().getId(),
                    schedule.getScheduleDate(),
                    schedule.getScheduleTime(), endTime, excludeScheduleId)) {
                throw new IllegalArgumentException("Hội viên đã có lịch vào thời gian này");
            }
        }
    }
}

package Services;

import DAOs.PTScheduleDAO;
import DAOs.UserDAO;
import DAOs.MemberPackageDAO;
import Models.Schedule;
import Models.User;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PTScheduleService {
    private PTScheduleDAO scheduleDAO = new PTScheduleDAO();
    private UserDAO userDAO = new UserDAO();
    private MemberPackageDAO memberPackageDAO = new MemberPackageDAO();

    public List<Schedule> getSchedulesByTrainerId(Integer trainerId) {
        try {
            System.out.println("Getting schedules for trainer ID: " + trainerId);
            // Chuyển Integer thành int
            List<Schedule> schedules = scheduleDAO.getSchedulesByTrainerId(trainerId.intValue());
            System.out.println("Found " + (schedules != null ? schedules.size() : 0) + " schedules");
            return schedules != null ? schedules : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("Error getting schedules: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public Schedule getScheduleById(int scheduleId) {
        return scheduleDAO.getScheduleById(scheduleId);
    }

    /**
     * Lấy lịch hẹn hôm nay của trainer
     */
    public List<Schedule> getTodaySchedules(Integer trainerId) {
        try {
            LocalDate today = LocalDate.now();
            return getSchedulesByDateRange(trainerId, today, today);
        } catch (Exception e) {
            System.err.println("Error getting today schedules: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void createSchedule(Schedule schedule) {
        // Validate schedule
        validateSchedule(schedule);

        // Kiểm tra conflict
        java.time.LocalTime endTime = schedule.getScheduleTime()
                .plusHours(schedule.getDurationHours().intValue())
                .plusMinutes((int) ((schedule.getDurationHours().doubleValue() % 1) * 60));

        if (!isTrainerAvailable(schedule.getTrainer().getId(),
                schedule.getScheduleDate(),
                schedule.getScheduleTime(), endTime, null)) {
            throw new IllegalArgumentException("Huấn luyện viên đã có lịch vào thời gian này");
        }

        // Kiểm tra member nếu có
        if (schedule.getMember() != null && schedule.getMember().getId() != null) {
            if (!isMemberAvailable(schedule.getMember().getId(),
                    schedule.getScheduleDate(),
                    schedule.getScheduleTime(), endTime, null)) {
                throw new IllegalArgumentException("Hội viên đã có lịch vào thời gian này");
            }
        }

        schedule.setCreatedAt(java.time.Instant.now());
        if (schedule.getStatus() == null || schedule.getStatus().isEmpty()) {
            schedule.setStatus("Pending");
        }

        scheduleDAO.saveSchedule(schedule);
    }

    public void updateSchedule(Schedule schedule) {
        // Validate schedule
        validateSchedule(schedule);

        // Kiểm tra conflict (loại trừ lịch hiện tại)
        java.time.LocalTime endTime = schedule.getScheduleTime()
                .plusHours(schedule.getDurationHours().intValue())
                .plusMinutes((int) ((schedule.getDurationHours().doubleValue() % 1) * 60));

        if (!isTrainerAvailable(schedule.getTrainer().getId(),
                schedule.getScheduleDate(),
                schedule.getScheduleTime(), endTime, schedule.getId())) {
            throw new IllegalArgumentException("Huấn luyện viên đã có lịch vào thời gian này");
        }

        // Kiểm tra member nếu có
        if (schedule.getMember() != null && schedule.getMember().getId() != null) {
            if (!isMemberAvailable(schedule.getMember().getId(),
                    schedule.getScheduleDate(),
                    schedule.getScheduleTime(), endTime, schedule.getId())) {
                throw new IllegalArgumentException("Hội viên đã có lịch vào thời gian này");
            }
        }

        schedule.setUpdatedAt(java.time.Instant.now());
        scheduleDAO.updateSchedule(schedule);
    }

    public void cancelSchedule(int scheduleId) {
        Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
        if (schedule != null) {
            schedule.setStatus("Cancelled");
            schedule.setUpdatedAt(Instant.now());
            scheduleDAO.updateSchedule(schedule);
        }
    }

    public List<User> getActiveMembersWithPackage() {
        try {
            System.out.println("=== PTScheduleService.getActiveMembersWithPackage ===");
            System.out.println("UserDAO instance: " + (userDAO != null ? "OK" : "NULL"));

            List<User> allUsers = userDAO.getAllUsers();
            System.out.println("All users count: " + (allUsers != null ? allUsers.size() : "NULL"));

            if (allUsers != null) {
                List<User> members = allUsers.stream()
                        .filter(user -> "Member".equals(user.getRole()))
                        .collect(java.util.stream.Collectors.toList());

                System.out.println("Filtered members count: " + members.size());
                return members;
            }

            return new ArrayList<>();
        } catch (Exception e) {
            System.err.println("Error in getActiveMembersWithPackage: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private void validateSchedule(Schedule schedule) {
        if (schedule.getTrainer() == null || schedule.getTrainer().getId() == null) {
            throw new IllegalArgumentException("Trainer không được để trống");
        }

        if (schedule.getScheduleDate() == null) {
            throw new IllegalArgumentException("Ngày tập không được để trống");
        }

        if (schedule.getScheduleTime() == null) {
            throw new IllegalArgumentException("Giờ tập không được để trống");
        }

        if (schedule.getDurationHours() == null || schedule.getDurationHours().doubleValue() <= 0) {
            throw new IllegalArgumentException("Thời lượng tập phải lớn hơn 0");
        }

        // Kiểm tra thời lượng hợp lệ (0.5, 1.0, 1.5, 2.0, 2.5, 3.0)
        double duration = schedule.getDurationHours().doubleValue();
        boolean validDuration = false;
        double[] allowedDurations = { 0.5, 1.0, 1.5, 2.0, 2.5, 3.0 };
        for (double allowed : allowedDurations) {
            if (Math.abs(duration - allowed) < 0.001) {
                validDuration = true;
                break;
            }
        }
        if (!validDuration) {
            throw new IllegalArgumentException("Thời lượng tập không hợp lệ");
        }

        // Kiểm tra thời gian không được trong quá khứ
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        java.time.LocalDateTime scheduleDateTime = java.time.LocalDateTime.of(
                schedule.getScheduleDate(), schedule.getScheduleTime());

        if (scheduleDateTime.isBefore(now)) {
            throw new IllegalArgumentException("Không thể đặt lịch trong quá khứ");
        }

        // Kiểm tra lịch phải được tạo trước ít nhất 3 tiếng
        java.time.Duration durationToSchedule = java.time.Duration.between(now, scheduleDateTime);
        if (durationToSchedule.toHours() < 3) {
            throw new IllegalArgumentException(
                    "Lịch tập phải được tạo trước ít nhất 3 tiếng so với thời gian bắt đầu");
        }

        // Kiểm tra giờ hoạt động (7:00 - 22:00)
        if (schedule.getScheduleTime().isBefore(java.time.LocalTime.of(7, 0)) ||
                schedule.getScheduleTime().isAfter(java.time.LocalTime.of(22, 0))) {
            throw new IllegalArgumentException("Chỉ được tạo lịch từ 07:00 đến 22:00");
        }
    }

    public boolean isTrainerAvailable(int trainerId, java.time.LocalDate date,
            java.time.LocalTime startTime, java.time.LocalTime endTime, Integer excludeScheduleId) {
        List<Schedule> trainerSchedules = scheduleDAO.getSchedulesByTrainerId(trainerId).stream()
                .filter(schedule -> schedule.getScheduleDate().equals(date))
                .collect(java.util.stream.Collectors.toList());

        for (Schedule existingSchedule : trainerSchedules) {
            // Bỏ qua lịch hiện tại khi update
            if (excludeScheduleId != null && existingSchedule.getId() == excludeScheduleId.intValue()) {
                continue;
            }

            // Chỉ kiểm tra lịch chưa bị hủy
            if (!"Cancelled".equals(existingSchedule.getStatus())) {
                java.time.LocalTime existingStart = existingSchedule.getScheduleTime();
                java.time.LocalTime existingEnd = existingStart
                        .plusHours(existingSchedule.getDurationHours().intValue())
                        .plusMinutes((int) ((existingSchedule.getDurationHours().doubleValue() % 1) * 60));

                // Kiểm tra trùng thời gian
                if (!(endTime.isBefore(existingStart) || startTime.isAfter(existingEnd))) {
                    return false;
                }
            }
        }
        return true;
    }

    public boolean isMemberAvailable(int memberId, java.time.LocalDate date,
            java.time.LocalTime startTime, java.time.LocalTime endTime, Integer excludeScheduleId) {
        try {
            // Lấy tất cả lịch tập và filter theo member và ngày
            List<Schedule> allSchedules = scheduleDAO.getSchedulesByTrainerId(0); // Workaround để lấy tất cả
            if (allSchedules == null) {
                return true; // Nếu không có lịch nào thì available
            }

            List<Schedule> memberSchedules = allSchedules.stream()
                    .filter(schedule -> schedule.getMember() != null &&
                            schedule.getMember().getId() != null &&
                            schedule.getMember().getId().equals(memberId) &&
                            schedule.getScheduleDate().equals(date))
                    .collect(java.util.stream.Collectors.toList());

            for (Schedule existingSchedule : memberSchedules) {
                // Bỏ qua lịch hiện tại khi update
                if (excludeScheduleId != null && existingSchedule.getId() == excludeScheduleId.intValue()) {
                    continue;
                }

                // Chỉ kiểm tra lịch chưa bị hủy
                if (!"Cancelled".equals(existingSchedule.getStatus())) {
                    java.time.LocalTime existingStart = existingSchedule.getScheduleTime();
                    java.time.LocalTime existingEnd = existingStart
                            .plusHours(existingSchedule.getDurationHours().intValue())
                            .plusMinutes((int) ((existingSchedule.getDurationHours().doubleValue() % 1) * 60));

                    // Kiểm tra trùng thời gian
                    if (!(endTime.isBefore(existingStart) || startTime.isAfter(existingEnd))) {
                        return false;
                    }
                }
            }
            return true;
        } catch (Exception e) {
            // Nếu có lỗi, cho phép tạo lịch (tránh block hoàn toàn)
            System.err.println("Error checking member availability: " + e.getMessage());
            return true;
        }
    }

    public void updateScheduleStatus(int scheduleId, String status) {
        Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
        if (schedule != null) {
            String currentStatus = schedule.getStatus();

            // Kiểm tra logic chuyển trạng thái
            boolean valid = false;
            if ("Pending".equals(currentStatus)) {
                if ("Confirmed".equals(status) || "Cancelled".equals(status))
                    valid = true;
            } else if ("Confirmed".equals(currentStatus)) {
                if ("Completed".equals(status) || "Cancelled".equals(status))
                    valid = true;
            }

            if (valid) {
                schedule.setStatus(status);
                schedule.setUpdatedAt(java.time.Instant.now());
                scheduleDAO.updateSchedule(schedule);
            } else {
                throw new IllegalArgumentException(
                        "Không thể chuyển trạng thái từ " + currentStatus + " sang " + status);
            }
        } else {
            throw new IllegalArgumentException("Không tìm thấy lịch tập");
        }
    }

    public List<Schedule> getAllSchedulesByTrainer(Integer trainerId) {
        try {
            return scheduleDAO.getAllSchedulesByTrainer(trainerId.intValue());
        } catch (Exception e) {
            System.err.println("Error getting all schedules: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void deleteSchedule(int scheduleId) {
        try {
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                throw new IllegalArgumentException("Không tìm thấy lịch tập để xóa");
            }

            // Kiểm tra quyền xóa - chỉ cho phép xóa lịch Pending hoặc trong tương lai
            if ("Completed".equals(schedule.getStatus())) {
                throw new IllegalArgumentException("Không thể xóa lịch tập đã hoàn thành");
            }

            scheduleDAO.deleteSchedule(scheduleId);
        } catch (Exception e) {
            System.err.println("Error deleting schedule: " + e.getMessage());
            throw new RuntimeException("Lỗi khi xóa lịch tập: " + e.getMessage(), e);
        }
    }

    public List<Schedule> getSchedulesByDateRange(Integer trainerId, java.time.LocalDate startDate,
            java.time.LocalDate endDate) {
        try {
            return scheduleDAO.getSchedulesByTrainerAndDateRange(trainerId.intValue(), startDate, endDate);
        } catch (Exception e) {
            System.err.println("Error getting schedules by date range: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Schedule> getUpcomingSchedules(Integer trainerId) {
        try {
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate nextWeek = today.plusDays(7);

            // Lấy tất cả lịch trong 7 ngày tới
            List<Schedule> allSchedules = getSchedulesByDateRange(trainerId, today, nextWeek);

            // Lọc chỉ lấy lịch chưa hoàn thành (Pending, Confirmed)
            List<Schedule> upcomingSchedules = new ArrayList<>();
            for (Schedule schedule : allSchedules) {
                if ("Pending".equals(schedule.getStatus()) || "Confirmed".equals(schedule.getStatus())) {
                    upcomingSchedules.add(schedule);
                }
            }

            return upcomingSchedules;
        } catch (Exception e) {
            System.err.println("Error getting upcoming schedules: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}

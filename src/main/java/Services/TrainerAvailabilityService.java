package Services;

import DAOs.TrainerAvailabilityDAO;
import DAOs.MemberPackageDAO;
import DAOs.ScheduleDAO;
import Models.TrainerAvailability;
import Models.User;
import Models.MemberPackage;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.ArrayList;

public class TrainerAvailabilityService {

    private final TrainerAvailabilityDAO availabilityDAO = new TrainerAvailabilityDAO();
    private final MemberPackageDAO memberPackageDAO = new MemberPackageDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();

    /**
     * PT đăng ký lịch sẵn sàng
     */
    public boolean registerAvailability(TrainerAvailability availability) {
        try {
            // 1. Kiểm tra gym không hoạt động chủ nhật
            if (availability.getAvailabilityDate().getDayOfWeek() == java.time.DayOfWeek.SUNDAY) {
                System.out.println("Cannot register availability on Sunday - gym is closed");
                return false;
            }

            // 2. Kiểm tra PT đã đăng ký lịch cho ngày này chưa (bất kể trạng thái)
            if (isTrainerAlreadyRegisteredForDate(availability.getTrainer().getId(),
                    availability.getAvailabilityDate())) {
                System.out.println("Trainer already has availability registered for this date");
                return false;
            }

            // 3. Kiểm tra thời gian hợp lệ
            if (availability.getStartTime().isAfter(availability.getEndTime()) ||
                    availability.getStartTime().equals(availability.getEndTime())) {
                System.out.println("Invalid time range");
                return false;
            }

            // 4. Tạo availability mới
            availability.setStatus("PENDING");
            availability.setCreatedAt(java.time.Instant.now());

            int id = availabilityDAO.createAvailability(availability);
            return id > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Admin duyệt lịch sẵn sàng
     */
    public boolean approveAvailability(int availabilityId) {
        return availabilityDAO.updateAvailabilityStatus(availabilityId, "APPROVED");
    }

    /**
     * Admin từ chối lịch sẵn sàng
     */
    public boolean rejectAvailability(int availabilityId) {
        return availabilityDAO.updateAvailabilityStatus(availabilityId, "REJECTED");
    }

    /**
     * Lấy tất cả lịch chờ duyệt
     */
    public List<TrainerAvailability> getPendingAvailabilities() {
        return availabilityDAO.getPendingAvailabilities();
    }

    /**
     * Lấy lịch sẵn sàng của PT
     */
    public List<TrainerAvailability> getTrainerAvailabilities(int trainerId) {
        return availabilityDAO.getAvailabilitiesByTrainerId(trainerId);
    }

    /**
     * Kiểm tra PT có sẵn sàng để tạo lịch tập không
     */
    public boolean canCreateSchedule(int trainerId, int memberId, LocalDate date, LocalTime startTime,
            LocalTime endTime) {
        // 1. Kiểm tra PT có lịch sẵn sàng được duyệt không
        boolean trainerAvailable = availabilityDAO.isTrainerAvailable(trainerId, date, startTime, endTime);
        if (!trainerAvailable) {
            return false;
        }

        // 2. Kiểm tra member có gói tập active không
        boolean memberHasActivePackage = hasActiveMemberPackage(memberId);
        if (!memberHasActivePackage) {
            return false;
        }

        // 3. Kiểm tra xem đã có lịch tập nào trùng thời gian chưa
        boolean hasConflictingSchedule = scheduleDAO.hasConflictingSchedule(trainerId, date, startTime, endTime);
        if (hasConflictingSchedule) {
            return false;
        }

        return true;
    }

    /**
     * Lấy các lịch sẵn sàng đã được duyệt của PT theo ngày
     */
    public List<TrainerAvailability> getApprovedAvailabilities(int trainerId, LocalDate date) {
        return availabilityDAO.getApprovedAvailabilities(trainerId, date);
    }

    /**
     * Xóa lịch sẵn sàng
     */
    public boolean deleteAvailability(int availabilityId) {
        return availabilityDAO.deleteAvailability(availabilityId);
    }

    /**
     * Kiểm tra xem lịch sẵn sàng đã tồn tại chưa
     */
    private boolean isAvailabilityExists(int trainerId, LocalDate date, LocalTime startTime) {
        List<TrainerAvailability> existingAvailabilities = availabilityDAO.getAvailabilitiesByTrainerId(trainerId);
        return existingAvailabilities.stream()
                .anyMatch(a -> a.getAvailabilityDate().equals(date) &&
                        a.getStartTime().equals(startTime) &&
                        !"REJECTED".equals(a.getStatus()));
    }

    /**
     * Kiểm tra member có gói tập active không
     */
    private boolean hasActiveMemberPackage(int memberId) {
        try {
            List<MemberPackage> activePackages = memberPackageDAO.getActiveMemberPackagesByMemberId(memberId);
            return !activePackages.isEmpty();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Kiểm tra PT đã đăng ký lịch cho ngày này chưa
     */
    private boolean isTrainerAlreadyRegisteredForDate(int trainerId, java.time.LocalDate date) {
        try {
            List<TrainerAvailability> existingAvailabilities = availabilityDAO
                    .getAvailabilitiesByTrainerAndDate(trainerId, date);
            return !existingAvailabilities.isEmpty();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Hủy lịch sẵn sàng với các ràng buộc
     */
    public String cancelAvailability(int availabilityId, int trainerId) {
        try {
            TrainerAvailability availability = availabilityDAO.getAvailabilityById(availabilityId);

            if (availability == null) {
                return "Không tìm thấy lịch sẵn sàng";
            }

            // Kiểm tra quyền sở hữu
            if (availability.getTrainer().getId() != trainerId) {
                return "Bạn không có quyền hủy lịch này";
            }

            // Chỉ cho phép hủy lịch PENDING hoặc APPROVED
            if (!"PENDING".equals(availability.getStatus()) && !"APPROVED".equals(availability.getStatus())) {
                return "Chỉ có thể hủy lịch đang chờ duyệt hoặc đã được duyệt";
            }

            // Kiểm tra thời gian: phải hủy trước ít nhất 1 ngày
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate availabilityDate = availability.getAvailabilityDate();

            if (availabilityDate.isBefore(today.plusDays(1))) {
                return "Chỉ có thể hủy lịch trước ít nhất 1 ngày";
            }

            // Kiểm tra có lịch tập với member không (chỉ với APPROVED)
            if ("APPROVED".equals(availability.getStatus())) {
                boolean hasScheduleWithMember = scheduleDAO.hasScheduleOnDate(trainerId, availabilityDate);
                if (hasScheduleWithMember) {
                    return "Không thể hủy vì có lịch tập với member. Vui lòng hủy lịch tập trước";
                }
            }

            // Thực hiện hủy
            boolean success = availabilityDAO.deleteAvailability(availabilityId);
            return success ? "success" : "Có lỗi xảy ra khi hủy lịch";

        } catch (Exception e) {
            e.printStackTrace();
            return "Có lỗi hệ thống xảy ra";
        }
    }

    /**
     * Lấy lịch theo tháng để hiển thị calendar
     */
    public List<TrainerAvailability> getAvailabilitiesByMonth(int trainerId, int year, int month) {
        try {
            java.time.LocalDate startDate = java.time.LocalDate.of(year, month, 1);
            java.time.LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());

            return availabilityDAO.getAvailabilitiesByTrainerAndDateRange(trainerId, startDate, endDate);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Lấy pending availabilities với filter theo trainer (cho admin)
     */
    public List<TrainerAvailability> getPendingAvailabilitiesByTrainer(Integer trainerId) {
        try {
            return availabilityDAO.getPendingAvailabilitiesByTrainer(trainerId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Lấy tất cả availabilities trong tháng (tất cả trainer)
     */
    public List<TrainerAvailability> getAllAvailabilitiesInMonth(int year, int month) {
        try {
            java.time.LocalDate startDate = java.time.LocalDate.of(year, month, 1);
            java.time.LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());

            return availabilityDAO.getAllAvailabilitiesInDateRange(startDate, endDate);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Enum cho trạng thái lịch sẵn sàng
     */
    public static class AvailabilityStatus {
        public static final String PENDING = "PENDING";
        public static final String APPROVED = "APPROVED";
        public static final String REJECTED = "REJECTED";
    }
}
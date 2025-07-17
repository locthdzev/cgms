package Controllers;

import Models.Schedule;
import Models.User;
import Services.ScheduleService;
import Services.UserService;
import DAOs.MemberPackageDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet({"/pt_schedule", "/pt_schedule/*"})
public class PTScheduleManagementController extends HttpServlet {
    private ScheduleService scheduleService = new ScheduleService();
    private UserService userService = new UserService();
    private MemberPackageDAO memberPackageDAO = new MemberPackageDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("loggedInUser");
        
        // Kiểm tra đăng nhập và quyền
        if (currentUser == null || !"Personal Trainer".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        if (pathInfo == null || "/".equals(pathInfo)) {
            // View all schedules for this PT
            List<Schedule> schedules = scheduleService.getSchedulesByTrainerId(currentUser.getId());
            req.setAttribute("schedules", schedules);
            req.getRequestDispatcher("/pt_schedule_management.jsp").forward(req, resp);
            
        } else if ("/add".equals(pathInfo)) {
            try {
                System.out.println("=== DEBUG: Getting members with packages ===");
                
                // Bước 1: Lấy members có gói ACTIVE/PENDING
                List<User> membersWithPackage = memberPackageDAO.getMembersWithCurrentPackage();
                System.out.println("Members with current package: " + membersWithPackage.size());
                
                // Bước 2: Nếu rỗng, lấy tất cả members có gói (bất kỳ status nào)
                if (membersWithPackage.isEmpty()) {
                    membersWithPackage = memberPackageDAO.getMembersHavingPackages();
                    System.out.println("Members having any packages: " + membersWithPackage.size());
                }
                
                // Bước 3: Nếu vẫn rỗng, lấy tất cả members
                if (membersWithPackage.isEmpty()) {
                    List<User> allMembers = userService.getAllUsers();
                    for (User user : allMembers) {
                        if ("Member".equals(user.getRole())) {
                            membersWithPackage.add(user);
                        }
                    }
                    System.out.println("All members: " + membersWithPackage.size());
                }
                
                // Debug: in ra thông tin members
                for (User member : membersWithPackage) {
                    System.out.println("Member: " + member.getFullName() + " (" + member.getUserName() + ") - " + member.getEmail());
                }
                
                req.setAttribute("members", membersWithPackage);
                req.getRequestDispatcher("/pt-add-schedule.jsp").forward(req, resp);
                
            } catch (Exception e) {
                System.out.println("Error getting members: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi khi tải danh sách hội viên: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/pt_schedule");
            }
        } else if (pathInfo != null && pathInfo.startsWith("/view/")) {
            // View schedule details
            try {
                String scheduleIdStr = pathInfo.substring(6);
                int scheduleId = Integer.parseInt(scheduleIdStr);
                
                Schedule schedule = scheduleService.getScheduleById(scheduleId);
                if (schedule == null) {
                    session.setAttribute("errorMessage", "Không tìm thấy lịch tập");
                    resp.sendRedirect(req.getContextPath() + "/pt_schedule");
                    return;
                }
                
                if (schedule.getMember() != null) {
                    User fullMember = userService.getUserById(schedule.getMember().getId());
                    schedule.setMember(fullMember);
                }
                
                req.setAttribute("schedule", schedule);
                req.getRequestDispatcher("/pt_schedule_members.jsp").forward(req, resp);
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi khi tải chi tiết lịch tập: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/pt_schedule");
            }
        } else if (pathInfo != null && pathInfo.startsWith("/progress/")) {
            // View member progress
            try {
                String scheduleIdStr = pathInfo.substring(10);
                int scheduleId = Integer.parseInt(scheduleIdStr);
                
                Schedule schedule = scheduleService.getScheduleById(scheduleId);
                if (schedule == null) {
                    session.setAttribute("errorMessage", "Không tìm thấy lịch tập");
                    resp.sendRedirect(req.getContextPath() + "/pt_schedule");
                    return;
                }
                
                if (schedule.getMember() != null) {
                    User fullMember = userService.getUserById(schedule.getMember().getId());
                    schedule.setMember(fullMember);
                }
                
                req.setAttribute("schedule", schedule);
                req.getRequestDispatcher("/pt_member_progress.jsp").forward(req, resp);
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi khi tải tiến độ thành viên: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/pt_schedule");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("loggedInUser");
        
        if (currentUser == null || !"Personal Trainer".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        if ("/create".equals(pathInfo)) {
            try {
                System.out.println("=== DEBUG: Creating new schedule ===");
                
                Schedule schedule = new Schedule();
                schedule.setTrainer(currentUser);
                
                String memberIdStr = req.getParameter("memberId");
                System.out.println("Member ID from form: " + memberIdStr);
                
                if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                    User member = new User();
                    member.setId(Integer.parseInt(memberIdStr));
                    schedule.setMember(member);
                }
                
                String scheduleDateStr = req.getParameter("scheduleDate");
                if (scheduleDateStr != null && !scheduleDateStr.trim().isEmpty()) {
                    schedule.setScheduleDate(java.time.LocalDate.parse(scheduleDateStr));
                }
                
                String scheduleTimeStr = req.getParameter("scheduleTime");
                if (scheduleTimeStr != null && !scheduleTimeStr.trim().isEmpty()) {
                    schedule.setScheduleTime(java.time.LocalTime.parse(scheduleTimeStr));
                }
                
                String durationStr = req.getParameter("durationHours");
                if (durationStr != null && !durationStr.trim().isEmpty()) {
                    schedule.setDurationHours(new java.math.BigDecimal(durationStr));
                }
                
                schedule.setStatus("Pending");
                schedule.setCreatedAt(java.time.Instant.now());
                
                scheduleService.saveSchedule(schedule);
                session.setAttribute("successMessage", "Tạo lịch tập mới thành công!");
                resp.sendRedirect(req.getContextPath() + "/pt_schedule");
                
            } catch (Exception e) {
                System.out.println("Error creating schedule: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi khi tạo lịch tập: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/pt_schedule/add");
            }
        }
    }
}











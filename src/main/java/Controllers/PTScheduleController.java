package Controllers;

import Services.PTScheduleService;
import Models.Schedule;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "PTScheduleController", urlPatterns = {"/pt-schedule", "/pt-schedule/*"})
public class PTScheduleController extends HttpServlet {
    private PTScheduleService ptScheduleService = new PTScheduleService();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");
        
        if (loggedInUser == null || !"Personal Trainer".equals(loggedInUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        try {
            System.out.println("=== PTScheduleController Debug ===");
            System.out.println("Trainer ID: " + loggedInUser.getId());
            System.out.println("Service: " + ptScheduleService);
            
            // Lấy schedules theo trainer ID
            List<Schedule> scheduleList = ptScheduleService.getSchedulesByTrainerId(loggedInUser.getId());
            List<User> members = ptScheduleService.getActiveMembersWithPackage();
            
            System.out.println("Schedule list size: " + (scheduleList != null ? scheduleList.size() : "null"));
            System.out.println("Members list size: " + (members != null ? members.size() : "null"));
            
            req.setAttribute("scheduleList", scheduleList);
            req.setAttribute("members", members);
            
            req.getRequestDispatcher("/pt-schedule.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.err.println("Error in PTScheduleController: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            req.setAttribute("scheduleList", new ArrayList<>());
            req.setAttribute("members", new ArrayList<>());
            req.getRequestDispatcher("/pt-schedule.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        User loggedInUser = (User) req.getSession().getAttribute("loggedInUser");
        
        if (loggedInUser == null || !"Personal Trainer".equals(loggedInUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String formAction = req.getParameter("formAction");
        
        try {
            if ("create".equals(formAction)) {
                // Create new schedule
                Schedule schedule = new Schedule();
                User trainer = new User();
                trainer.setId(loggedInUser.getId());
                schedule.setTrainer(trainer);
                
                // Set member if provided
                String memberIdStr = req.getParameter("memberId");
                if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                    User member = new User();
                    member.setId(Integer.parseInt(memberIdStr));
                    schedule.setMember(member);
                }
                
                // Set schedule details
                schedule.setScheduleDate(LocalDate.parse(req.getParameter("scheduleDate")));
                schedule.setScheduleTime(LocalTime.parse(req.getParameter("scheduleTime")));
                schedule.setDurationHours(new BigDecimal(req.getParameter("durationHours")));
                schedule.setStatus(req.getParameter("status"));
                
                ptScheduleService.createSchedule(schedule);
                req.getSession().setAttribute("successMessage", "Tạo lịch tập thành công!");
                
            } else if ("edit".equals(formAction)) {
                // Update existing schedule
                int scheduleId = Integer.parseInt(req.getParameter("id"));
                Schedule schedule = ptScheduleService.getScheduleById(scheduleId);
                
                if (schedule != null && schedule.getTrainer().getId().equals(loggedInUser.getId())) {
                    // Set member if provided
                    String memberIdStr = req.getParameter("memberId");
                    if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                        User member = new User();
                        member.setId(Integer.parseInt(memberIdStr));
                        schedule.setMember(member);
                    } else {
                        schedule.setMember(null);
                    }
                    
                    // Update schedule details
                    schedule.setScheduleDate(LocalDate.parse(req.getParameter("scheduleDate")));
                    schedule.setScheduleTime(LocalTime.parse(req.getParameter("scheduleTime")));
                    schedule.setDurationHours(new BigDecimal(req.getParameter("durationHours")));
                    schedule.setStatus(req.getParameter("status"));
                    
                    ptScheduleService.updateSchedule(schedule);
                    req.getSession().setAttribute("successMessage", "Cập nhật lịch tập thành công!");
                } else {
                    req.getSession().setAttribute("errorMessage", "Không tìm thấy lịch tập hoặc bạn không có quyền chỉnh sửa!");
                }
                
            } else if ("updateStatus".equals(formAction)) {
                // Update schedule status
                int scheduleId = Integer.parseInt(req.getParameter("id"));
                String newStatus = req.getParameter("status");
                
                Schedule schedule = ptScheduleService.getScheduleById(scheduleId);
                if (schedule != null && schedule.getTrainer().getId().equals(loggedInUser.getId())) {
                    ptScheduleService.updateScheduleStatus(scheduleId, newStatus);
                    req.getSession().setAttribute("successMessage", "Cập nhật trạng thái thành công!");
                } else {
                    req.getSession().setAttribute("errorMessage", "Không có quyền thay đổi trạng thái lịch tập này!");
                }
                
            } else if ("delete".equals(formAction)) {
                // Delete schedule
                int scheduleId = Integer.parseInt(req.getParameter("id"));
                
                Schedule schedule = ptScheduleService.getScheduleById(scheduleId);
                if (schedule != null && schedule.getTrainer().getId().equals(loggedInUser.getId())) {
                    ptScheduleService.deleteSchedule(scheduleId);
                    req.getSession().setAttribute("successMessage", "Xóa lịch tập thành công!");
                } else {
                    req.getSession().setAttribute("errorMessage", "Không có quyền xóa lịch tập này!");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/pt-schedule");
    }
}








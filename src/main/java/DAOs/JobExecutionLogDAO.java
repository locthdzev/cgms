package DAOs;

import DbConnection.DbConnection;
import Models.JobExecutionLog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class JobExecutionLogDAO {
    private static final Logger LOGGER = Logger.getLogger(JobExecutionLogDAO.class.getName());

    /**
     * Tạo bảng Job_Execution_Logs nếu chưa tồn tại
     */
    public void createTableIfNotExists() {
        Connection conn = null;
        Statement stmt = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.createStatement();

            // Tạo bảng Job_Execution_Logs nếu chưa tồn tại
            String sql = "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Job_Execution_Logs]') AND type in (N'U')) "
                    +
                    "BEGIN " +
                    "CREATE TABLE [dbo].[Job_Execution_Logs]( " +
                    "[LogId] [int] IDENTITY(1,1) NOT NULL, " +
                    "[JobName] [nvarchar](100) NOT NULL, " +
                    "[ExecutionTime] [datetime2](7) NOT NULL, " +
                    "[Success] [bit] NOT NULL, " +
                    "[Message] [nvarchar](500) NULL, " +
                    "[ExecutionDuration] [bigint] NULL, " +
                    "[CreatedAt] [datetime2](7) NOT NULL, " +
                    "CONSTRAINT [PK_Job_Execution_Logs] PRIMARY KEY CLUSTERED ([LogId] ASC) " +
                    ") " +
                    "END";

            stmt.executeUpdate(sql);
            LOGGER.info("Đã tạo bảng Job_Execution_Logs nếu chưa tồn tại");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo bảng Job_Execution_Logs", e);
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối database", e);
            }
        }
    }

    /**
     * Thêm một log mới vào bảng Job_Execution_Logs
     * 
     * @param log Đối tượng JobExecutionLog cần thêm
     * @return ID của log vừa thêm, hoặc -1 nếu có lỗi
     */
    public int createLog(JobExecutionLog log) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            String sql = "INSERT INTO Job_Execution_Logs (JobName, ExecutionTime, Success, Message, ExecutionDuration, CreatedAt) "
                    +
                    "VALUES (?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, log.getJobName());
            stmt.setTimestamp(2, Timestamp.from(log.getExecutionTime()));
            stmt.setBoolean(3, log.isSuccess());
            stmt.setString(4, log.getMessage());

            if (log.getExecutionDuration() != null) {
                stmt.setLong(5, log.getExecutionDuration());
            } else {
                stmt.setNull(5, java.sql.Types.BIGINT);
            }

            stmt.setTimestamp(6, Timestamp.from(log.getCreatedAt()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                return -1;
            }

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return -1;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm log vào bảng Job_Execution_Logs", e);
            return -1;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối database", e);
            }
        }
    }

    /**
     * Lấy danh sách log thực thi job, sắp xếp theo thời gian thực thi giảm dần
     * 
     * @param limit Số lượng log tối đa cần lấy
     * @return Danh sách log thực thi job
     */
    public List<JobExecutionLog> getRecentLogs(int limit) {
        List<JobExecutionLog> logs = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            String sql = "SELECT TOP (?) LogId, JobName, ExecutionTime, Success, Message, ExecutionDuration, CreatedAt "
                    +
                    "FROM Job_Execution_Logs " +
                    "ORDER BY ExecutionTime DESC";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();

            while (rs.next()) {
                JobExecutionLog log = new JobExecutionLog();
                log.setId(rs.getInt("LogId"));
                log.setJobName(rs.getString("JobName"));

                Timestamp executionTime = rs.getTimestamp("ExecutionTime");
                if (executionTime != null) {
                    log.setExecutionTime(executionTime.toInstant());
                }

                log.setSuccess(rs.getBoolean("Success"));
                log.setMessage(rs.getString("Message"));
                log.setExecutionDuration(rs.getLong("ExecutionDuration"));

                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                if (createdAt != null) {
                    log.setCreatedAt(createdAt.toInstant());
                }

                logs.add(log);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách log thực thi job", e);
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối database", e);
            }
        }

        return logs;
    }
}
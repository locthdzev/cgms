/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DbConnection.DbConnection;
import Models.Package;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class PackageDAO {
    /**
     * Thêm một gói tập mới vào cơ sở dữ liệu
     * 
     * @param pkg Đối tượng Package chứa thông tin gói tập cần thêm
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean addPackage(Package pkg) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnection.getConnection();

            // Set createdAt to current time if not already set
            if (pkg.getCreatedAt() == null) {
                pkg.setCreatedAt(Instant.now());
            }

            String sql = "INSERT INTO Packages (Name, Price, Duration, Sessions, Description, CreatedAt, Status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, pkg.getName());
            stmt.setBigDecimal(2, pkg.getPrice());
            stmt.setInt(3, pkg.getDuration());

            // Handle null sessions
            if (pkg.getSessions() != null) {
                stmt.setInt(4, pkg.getSessions());
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }

            stmt.setString(5, pkg.getDescription());
            stmt.setTimestamp(6, java.sql.Timestamp.from(pkg.getCreatedAt()));
            stmt.setString(7, pkg.getStatus());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Lỗi khi thêm gói tập: " + e.getMessage());
            return false;
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Lấy tất cả các gói tập từ cơ sở dữ liệu
     * 
     * @return Danh sách các gói tập
     */
    public List<Package> getAllPackages() {
        List<Package> packages = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM Packages");

            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("PackageId"));
                pkg.setName(rs.getString("Name"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));
                pkg.setSessions(rs.getObject("Sessions") != null ? rs.getInt("Sessions") : null);
                pkg.setDescription(rs.getString("Description"));
                pkg.setCreatedAt(
                        rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toInstant() : null);
                pkg.setUpdatedAt(
                        rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toInstant() : null);
                pkg.setStatus(rs.getString("Status"));

                packages.add(pkg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return packages;
    }

    /**
     * Tìm kiếm gói tập theo tên
     * 
     * @param searchTerm Từ khóa tìm kiếm
     * @return Danh sách các gói tập phù hợp
     */
    public List<Package> searchPackages(String searchTerm) {
        List<Package> packages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            String sql = "SELECT * FROM Packages WHERE Name LIKE ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + searchTerm + "%");
            rs = stmt.executeQuery();

            while (rs.next()) {
                Package pkg = new Package();
                // Populate package object as in getAllPackages()
                pkg.setId(rs.getInt("PackageId"));
                pkg.setName(rs.getString("Name"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));
                pkg.setSessions(rs.getObject("Sessions") != null ? rs.getInt("Sessions") : null);
                pkg.setDescription(rs.getString("Description"));
                pkg.setCreatedAt(
                        rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toInstant() : null);
                pkg.setUpdatedAt(
                        rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toInstant() : null);
                pkg.setStatus(rs.getString("Status"));

                packages.add(pkg);
            }

            return packages;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            // Close resources
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Lấy gói tập theo trạng thái
     * 
     * @param status Trạng thái cần lọc
     * @return Danh sách các gói tập có trạng thái tương ứng
     */
    public List<Package> getPackagesByStatus(String status) {
        List<Package> packages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            String sql = "SELECT * FROM Packages WHERE Status = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Package pkg = new Package();
                // Populate package object
                pkg.setId(rs.getInt("PackageId"));
                pkg.setName(rs.getString("Name"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));
                pkg.setSessions(rs.getObject("Sessions") != null ? rs.getInt("Sessions") : null);
                pkg.setDescription(rs.getString("Description"));
                pkg.setCreatedAt(
                        rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toInstant() : null);
                pkg.setUpdatedAt(
                        rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toInstant() : null);
                pkg.setStatus(rs.getString("Status"));

                packages.add(pkg);
            }

            return packages;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            // Close resources
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Lấy tất cả các gói tập đang hoạt động từ cơ sở dữ liệu
     * 
     * @return Danh sách các gói tập đang hoạt động
     */
    public List<Package> getAllActivePackages() {
        List<Package> packages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            String sql = "SELECT * FROM Packages WHERE Status = 'Active'";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("PackageId"));
                pkg.setName(rs.getString("Name"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));
                pkg.setSessions(rs.getObject("Sessions") != null ? rs.getInt("Sessions") : null);
                pkg.setDescription(rs.getString("Description"));
                pkg.setCreatedAt(
                        rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toInstant() : null);
                pkg.setUpdatedAt(
                        rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toInstant() : null);
                pkg.setStatus(rs.getString("Status"));

                packages.add(pkg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return packages;
    }

    public List<Package> getActivePackages() {
        String sql = "SELECT * FROM Packages WHERE Status = 'ACTIVE'";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Package> packages = new ArrayList<>();

        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("PackageId"));
                pkg.setName(rs.getString("Name"));
                pkg.setDescription(rs.getString("Description"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));
                pkg.setSessions(rs.getInt("Sessions"));
                pkg.setStatus(rs.getString("Status"));

                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                if (createdAt != null) {
                    pkg.setCreatedAt(createdAt.toInstant());
                }

                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
                if (updatedAt != null) {
                    pkg.setUpdatedAt(updatedAt.toInstant());
                }

                packages.add(pkg);
            }

            return packages;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Lấy thông tin gói tập theo ID
     * 
     * @param id ID của gói tập cần lấy
     * @return Đối tượng Package chứa thông tin gói tập, hoặc null nếu không tìm
     *         thấy
     * @throws Exception nếu có lỗi xảy ra
     */
    public Package getPackageById(int id) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnection.getConnection();
            if (conn == null) {
                throw new Exception("Không thể kết nối đến cơ sở dữ liệu");
            }

            String sql = "SELECT * FROM Packages WHERE PackageId = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("PackageId"));
                pkg.setName(rs.getString("Name"));
                pkg.setPrice(rs.getBigDecimal("Price"));
                pkg.setDuration(rs.getInt("Duration"));

                // Xử lý trường hợp Sessions có thể null
                Object sessionsObj = rs.getObject("Sessions");
                if (sessionsObj != null && !rs.wasNull()) {
                    pkg.setSessions(rs.getInt("Sessions"));
                } else {
                    pkg.setSessions(null);
                }

                pkg.setDescription(rs.getString("Description"));

                // Xử lý trường hợp timestamps có thể null
                java.sql.Timestamp createdTs = rs.getTimestamp("CreatedAt");
                if (createdTs != null) {
                    pkg.setCreatedAt(createdTs.toInstant());
                }

                java.sql.Timestamp updatedTs = rs.getTimestamp("UpdatedAt");
                if (updatedTs != null) {
                    pkg.setUpdatedAt(updatedTs.toInstant());
                }

                pkg.setStatus(rs.getString("Status"));

                return pkg;
            }

            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Lỗi khi truy vấn dữ liệu: " + e.getMessage());
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Cập nhật thông tin gói tập
     * 
     * @param pkg Đối tượng Package chứa thông tin cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updatePackage(Package pkg) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnection.getConnection();

            // Set updatedAt to current time
            pkg.setUpdatedAt(Instant.now());

            String sql = "UPDATE Packages SET Name = ?, Price = ?, Duration = ?, Sessions = ?, " +
                    "Description = ?, UpdatedAt = ?, Status = ? WHERE PackageId = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, pkg.getName());
            stmt.setBigDecimal(2, pkg.getPrice());
            stmt.setInt(3, pkg.getDuration());

            // Handle null sessions
            if (pkg.getSessions() != null) {
                stmt.setInt(4, pkg.getSessions());
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }

            stmt.setString(5, pkg.getDescription());
            stmt.setTimestamp(6, java.sql.Timestamp.from(pkg.getUpdatedAt()));
            stmt.setString(7, pkg.getStatus());
            stmt.setInt(8, pkg.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Lỗi khi cập nhật gói tập: " + e.getMessage());
            return false;
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                if (conn != null)
                    DbConnection.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

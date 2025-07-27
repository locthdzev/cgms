package DAOs;

import Models.Inventory;
import Models.Product;
import DbConnection.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    // Lấy tất cả tồn kho
    public List<Inventory> getAllInventory() {
        List<Inventory> inventoryList = new ArrayList<>();
        String sql = "SELECT i.InventoryId, i.ProductId, i.Quantity, i.LastUpdated, i.Status, i.SupplierName, i.TaxCode, i.ImportedDate, p.Name as ProductName "
                + "FROM Inventory i "
                + "JOIN Products p ON i.ProductId = p.ProductId ORDER BY i.InventoryId";

        try (Connection conn = DbConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                inventoryList.add(mapResultSetToInventory(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return inventoryList;
    }

    // Lấy tồn kho theo ProductId
    public Inventory getInventoryByProductId(int productId) {
        String sql = "SELECT i.InventoryId, i.ProductId, i.Quantity, i.LastUpdated, i.Status, i.SupplierName, i.TaxCode, i.ImportedDate, p.Name as ProductName "
                + "FROM Inventory i JOIN Products p ON i.ProductId = p.ProductId WHERE i.ProductId = ?";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInventory(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm tồn kho mới
    public boolean addInventory(Inventory inventory) {
        String sql = "INSERT INTO Inventory (ProductId, Quantity, LastUpdated, Status, SupplierName, TaxCode, ImportedDate) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventory.getProduct().getId());
            stmt.setInt(2, inventory.getQuantity());
            stmt.setTimestamp(3, Timestamp.from(inventory.getLastUpdated()));
            stmt.setString(4, inventory.getStatus());
            stmt.setString(5, inventory.getSupplierName());
            stmt.setString(6, inventory.getTaxCode());
            stmt.setTimestamp(7, Timestamp.from(inventory.getImportedDate()));

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Thêm tồn kho thành công.");
                return true;
            } else {
                System.out.println("Không có bản ghi nào được thêm.");
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Lỗi khi thêm tồn kho: " + e.getMessage());
            return false;
        }
    }

    // Cập nhật tồn kho
    public boolean updateInventory(Inventory inventory) {
        String sql = "UPDATE Inventory SET Quantity = ?, LastUpdated = ?, Status = ?, SupplierName = ?, TaxCode = ?, ImportedDate = ? WHERE InventoryId = ?";

        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventory.getQuantity());
            stmt.setTimestamp(2, Timestamp.from(inventory.getLastUpdated()));
            stmt.setString(3, inventory.getStatus());
            stmt.setString(4, inventory.getSupplierName());
            stmt.setString(5, inventory.getTaxCode());
            stmt.setTimestamp(6, Timestamp.from(inventory.getImportedDate()));
            stmt.setInt(7, inventory.getId());

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Map kết quả từ ResultSet vào Inventory object
    private Inventory mapResultSetToInventory(ResultSet rs) throws SQLException {
        Inventory inventory = new Inventory();
        inventory.setId(rs.getInt("InventoryId"));

        Product product = new Product();
        product.setId(rs.getInt("ProductId"));
        product.setName(rs.getString("ProductName"));

        inventory.setProduct(product);
        inventory.setQuantity(rs.getInt("Quantity"));
        inventory.setLastUpdated(rs.getTimestamp("LastUpdated").toInstant());
        inventory.setStatus(rs.getString("Status"));
        inventory.setSupplierName(rs.getString("SupplierName"));
        inventory.setTaxCode(rs.getString("TaxCode"));
        inventory.setImportedDate(rs.getTimestamp("ImportedDate").toInstant());

        return inventory;
    }
}

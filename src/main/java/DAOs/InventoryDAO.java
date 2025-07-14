package DAOs;

import Models.Inventory;
import Models.Product;
import DbConnection.DbConnection;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    public List<Inventory> getAllInventory() {
        List<Inventory> inventoryList = new ArrayList<>();
        String sql = "SELECT i.*, p.Name as ProductName FROM Inventory i " +
                "JOIN Products p ON i.ProductId = p.ProductId ORDER BY i.InventoryId";

        try (Connection conn = DbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                inventoryList.add(mapResultSetToInventory(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return inventoryList;
    }

    public Inventory getInventoryByProductId(int productId) {
        String sql = "SELECT i.*, p.Name as ProductName FROM Inventory i " +
                "JOIN Products p ON i.ProductId = p.ProductId WHERE i.ProductId = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

    public boolean addInventory(Inventory inventory) {
        String sql = "INSERT INTO Inventory (ProductId, Quantity, LastUpdated, Status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventory.getProduct().getId());
            stmt.setInt(2, inventory.getQuantity());
            stmt.setTimestamp(3, Timestamp.from(inventory.getLastUpdated()));
            stmt.setString(4, inventory.getStatus());

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateInventory(Inventory inventory) {
        String sql = "UPDATE Inventory SET Quantity = ?, LastUpdated = ?, Status = ? WHERE InventoryId = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventory.getQuantity());
            stmt.setTimestamp(2, Timestamp.from(inventory.getLastUpdated()));
            stmt.setString(3, inventory.getStatus());
            stmt.setInt(4, inventory.getId());

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

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
        
        return inventory;
    }
}
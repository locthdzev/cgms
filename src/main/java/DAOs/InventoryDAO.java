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
        String sql = "SELECT i.*, p.Name, p.Description, p.Price, p.ImageUrl, p.Status as ProductStatus " +
                    "FROM Inventory i LEFT JOIN Products p ON i.ProductId = p.ProductId " +
                    "ORDER BY i.LastUpdated DESC";
        
        try (Connection conn = DbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Inventory inventory = mapResultSetToInventory(rs);
                inventoryList.add(inventory);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return inventoryList;
    }

    public Inventory getInventoryById(int inventoryId) {
        String sql = "SELECT i.*, p.Name, p.Description, p.Price, p.ImageUrl, p.Status as ProductStatus " +
                    "FROM Inventory i LEFT JOIN Products p ON i.ProductId = p.ProductId " +
                    "WHERE i.InventoryId = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, inventoryId);
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

    public Inventory getInventoryByProductId(int productId) {
        String sql = "SELECT i.*, p.Name, p.Description, p.Price, p.ImageUrl, p.Status as ProductStatus " +
                    "FROM Inventory i LEFT JOIN Products p ON i.ProductId = p.ProductId " +
                    "WHERE i.ProductId = ?";
        
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

    public void saveInventory(Inventory inventory) {
        String sql = "INSERT INTO Inventory (ProductId, Quantity, SupplierName, TaxCode, ImportedDate, LastUpdated, Status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, inventory.getProduct().getId());
            stmt.setInt(2, inventory.getQuantity());
            stmt.setString(3, inventory.getSupplierName());
            stmt.setString(4, inventory.getTaxCode());
            
            if (inventory.getImportedDate() == null) {
                inventory.setImportedDate(Instant.now());
            }
            stmt.setTimestamp(5, Timestamp.from(inventory.getImportedDate()));
            
            if (inventory.getLastUpdated() == null) {
                inventory.setLastUpdated(Instant.now());
            }
            stmt.setTimestamp(6, Timestamp.from(inventory.getLastUpdated()));
            stmt.setString(7, inventory.getStatus());
            
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error saving inventory", e);
        }
    }

    public void updateInventory(Inventory inventory) {
        String sql = "UPDATE Inventory SET ProductId = ?, Quantity = ?, SupplierName = ?, TaxCode = ?, " +
                    "ImportedDate = ?, LastUpdated = ?, Status = ? WHERE InventoryId = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, inventory.getProduct().getId());
            stmt.setInt(2, inventory.getQuantity());
            stmt.setString(3, inventory.getSupplierName());
            stmt.setString(4, inventory.getTaxCode());
            stmt.setTimestamp(5, Timestamp.from(inventory.getImportedDate()));
            
            inventory.setLastUpdated(Instant.now());
            stmt.setTimestamp(6, Timestamp.from(inventory.getLastUpdated()));
            stmt.setString(7, inventory.getStatus());
            stmt.setInt(8, inventory.getId());
            
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating inventory", e);
        }
    }

    public void deleteInventory(int inventoryId) {
        String sql = "DELETE FROM Inventory WHERE InventoryId = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, inventoryId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting inventory", e);
        }
    }

    public List<Inventory> getLowStockInventory(int threshold) {
        List<Inventory> inventoryList = new ArrayList<>();
        String sql = "SELECT i.*, p.Name, p.Description, p.Price, p.ImageUrl, p.Status as ProductStatus " +
                    "FROM Inventory i LEFT JOIN Products p ON i.ProductId = p.ProductId " +
                    "WHERE i.Quantity <= ? ORDER BY i.Quantity ASC";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, threshold);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Inventory inventory = mapResultSetToInventory(rs);
                    inventoryList.add(inventory);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return inventoryList;
    }

    public List<Inventory> searchInventory(String keyword) {
        List<Inventory> inventoryList = new ArrayList<>();
        String sql = "SELECT i.*, p.Name, p.Description, p.Price, p.ImageUrl, p.Status as ProductStatus " +
                    "FROM Inventory i LEFT JOIN Products p ON i.ProductId = p.ProductId " +
                    "WHERE i.SupplierName LIKE ? OR p.Name LIKE ? ORDER BY i.LastUpdated DESC";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Inventory inventory = mapResultSetToInventory(rs);
                    inventoryList.add(inventory);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return inventoryList;
    }

    public boolean isProductInInventory(int productId) {
        String sql = "SELECT COUNT(*) FROM Inventory WHERE ProductId = ?";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Inventory mapResultSetToInventory(ResultSet rs) throws SQLException {
        Inventory inventory = new Inventory();
        inventory.setId(rs.getInt("InventoryId"));
        inventory.setQuantity(rs.getInt("Quantity"));
        inventory.setSupplierName(rs.getString("SupplierName"));
        inventory.setTaxCode(rs.getString("TaxCode"));
        inventory.setStatus(rs.getString("Status"));
        
        Timestamp importedTimestamp = rs.getTimestamp("ImportedDate");
        if (importedTimestamp != null) {
            inventory.setImportedDate(importedTimestamp.toInstant());
        }
        
        Timestamp lastUpdatedTimestamp = rs.getTimestamp("LastUpdated");
        if (lastUpdatedTimestamp != null) {
            inventory.setLastUpdated(lastUpdatedTimestamp.toInstant());
        }
        
        // Map Product với đầy đủ thông tin
        Product product = new Product();
        product.setId(rs.getInt("ProductId"));
        try {
            product.setName(rs.getString("Name"));
            product.setDescription(rs.getString("Description"));
            product.setPrice(rs.getBigDecimal("Price"));
            product.setImageUrl(rs.getString("ImageUrl"));
            product.setStatus(rs.getString("ProductStatus"));
        } catch (SQLException e) {
            // Column not found, ignore
        }
        inventory.setProduct(product);
        
        return inventory;
    }
}

package DAOs;

import Models.Product;
import DbConnection.DbConnection;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Lấy danh sách tất cả sản phẩm
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products ORDER BY ProductId";

        try (Connection conn = DbConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    // Lấy 1 sản phẩm theo ID
    public Product getProductById(int id) {
        String sql = "SELECT * FROM Products WHERE ProductId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lưu sản phẩm mới
    public void saveProduct(Product product) {
        String sql = "INSERT INTO Products (Name, Description, Price, ImageUrl, CreatedAt, Status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setString(4, product.getImageUrl());

            if (product.getCreatedAt() == null) {
                product.setCreatedAt(Instant.now());
            }
            stmt.setTimestamp(5, Timestamp.from(product.getCreatedAt()));
            stmt.setString(6, product.getStatus());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error saving product", e);
        }
    }

    // Cập nhật sản phẩm
    public void updateProduct(Product product) {
        String sql = "UPDATE Products SET Name = ?, Description = ?, Price = ?, " +
                "ImageUrl = ?, UpdatedAt = ?, Status = ? WHERE ProductId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setString(4, product.getImageUrl());

            product.setUpdatedAt(Instant.now());
            stmt.setTimestamp(5, Timestamp.from(product.getUpdatedAt()));
            stmt.setString(6, product.getStatus());
            stmt.setInt(7, product.getId());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating product", e);
        }
    }

    // Xoá sản phẩm
    public void deleteProduct(int id) {
        String sql = "DELETE FROM Products WHERE ProductId = ?";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting product", e);
        }
    }

    // Helper method to map ResultSet to Product object
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("ProductId"));
        product.setName(rs.getString("Name"));
        product.setDescription(rs.getString("Description"));
        product.setPrice(rs.getBigDecimal("Price"));
        product.setImageUrl(rs.getString("ImageUrl"));

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            product.setCreatedAt(createdAt.toInstant());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            product.setUpdatedAt(updatedAt.toInstant());
        }

        product.setStatus(rs.getString("Status"));
        return product;
    }
}

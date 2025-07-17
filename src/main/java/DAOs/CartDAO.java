package DAOs;

import Models.Cart;
import Models.Product;
import DbConnection.DbConnection;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<Cart> getCartByMemberId(int memberId) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT c.*, p.* FROM Cart c "
                + "JOIN Products p ON c.ProductId = p.ProductId "
                + "WHERE c.MemberId = ? AND c.Status = 'Active'";
        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Cart cart = new Cart();
                    Product p = new Product();

                    cart.setId(rs.getInt("CartId"));
                    cart.setQuantity(rs.getInt("Quantity"));
                    cart.setAddedAt(rs.getTimestamp("AddedAt").toInstant());
                    cart.setStatus(rs.getString("Status"));

                    p.setId(rs.getInt("ProductId"));
                    p.setName(rs.getString("Name"));
                    p.setDescription(rs.getString("Description"));
                    p.setPrice(rs.getBigDecimal("Price"));
                    p.setImageUrl(rs.getString("ImageUrl"));

                    cart.setProduct(p);
                    cartItems.add(cart);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public void addToCart(int memberId, int productId) {
        String checkSql = "SELECT * FROM Cart WHERE MemberId = ? AND ProductId = ?";
        try (Connection conn = DbConnection.getConnection(); PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, memberId);
            checkStmt.setInt(2, productId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                int cartId = rs.getInt("CartId");
                int quantity = rs.getInt("Quantity") + 1;
                String updateSql = "UPDATE Cart SET Quantity = ?, AddedAt = ? WHERE CartId = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, quantity);
                    updateStmt.setTimestamp(2, Timestamp.from(Instant.now()));
                    updateStmt.setInt(3, cartId);
                    updateStmt.executeUpdate();
                }
            } else {
                String insertSql = "INSERT INTO Cart (MemberId, ProductId, Quantity, AddedAt, Status) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, memberId);
                    insertStmt.setInt(2, productId);
                    insertStmt.setInt(3, 1);
                    insertStmt.setTimestamp(4, Timestamp.from(Instant.now()));
                    insertStmt.setString(5, "Active");
                    insertStmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void removeItem(int cartId) {
        String sql = "DELETE FROM Cart WHERE CartId = ?";
        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy 1 cart item theo cartId
    public Cart getCartById(int cartId) {
        String sql = "SELECT c.*, p.* FROM Cart c JOIN Products p ON c.ProductId = p.ProductId WHERE c.CartId = ?";
        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Cart cart = new Cart();
                    Product p = new Product();
                    cart.setId(rs.getInt("CartId"));
                    cart.setQuantity(rs.getInt("Quantity"));
                    cart.setAddedAt(rs.getTimestamp("AddedAt").toInstant());
                    cart.setStatus(rs.getString("Status"));
                    p.setId(rs.getInt("ProductId"));
                    p.setName(rs.getString("Name"));
                    p.setDescription(rs.getString("Description"));
                    p.setPrice(rs.getBigDecimal("Price"));
                    p.setImageUrl(rs.getString("ImageUrl"));
                    cart.setProduct(p);
                    return cart;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update số lượng cho 1 cart item
    public void updateCartQuantity(int cartId, int newQuantity) {
        String sql = "UPDATE Cart SET Quantity = ? WHERE CartId = ?";
        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newQuantity);
            stmt.setInt(2, cartId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int changeQuantity(int cartId, int diff) {
        Cart cart = getCartById(cartId);
        if (cart == null) {
            return -1;
        }
        int newQuantity = cart.getQuantity() + diff;
        if (newQuantity <= 0) {
            removeItem(cartId);
            return 0;
        } else {
            updateCartQuantity(cartId, newQuantity);
            return newQuantity;
        }
    }

    public int setQuantity(int cartId, int quantity) {
        if (quantity <= 0) {
            removeItem(cartId);
            return 0;
        }
        updateCartQuantity(cartId, quantity);
        return quantity;
    }
}

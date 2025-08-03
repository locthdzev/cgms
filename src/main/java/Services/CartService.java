package Services;

import DAOs.CartDAO;
import Models.Cart;

import java.util.List;

public class CartService {

    private final CartDAO cartDAO = new CartDAO();

    public List<Cart> getCartByMemberId(int memberId) {
        return cartDAO.getCartByMemberId(memberId);
    }

    public void addToCart(int memberId, int productId) {
        cartDAO.addToCart(memberId, productId);
    }

    public void removeItem(int cartId) {
        cartDAO.removeItem(cartId);
    }

    public int changeQuantity(int cartId, int diff) {
        return cartDAO.changeQuantity(cartId, diff);
    }

    public long getCartTotal(int memberId) {
        List<Cart> items = getCartByMemberId(memberId);
        long total = 0;
        for (Cart c : items) {
            total += c.getProduct().getPrice().longValue() * c.getQuantity();
        }
        return total;
    }

    public int setQuantity(int cartId, int quantity) {
        return cartDAO.setQuantity(cartId, quantity);
    }

    public Cart getCartById(int cartId) {
        return cartDAO.getCartById(cartId);
    }
}

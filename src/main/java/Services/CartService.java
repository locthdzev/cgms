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
}

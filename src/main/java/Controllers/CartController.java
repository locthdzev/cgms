package Controllers;

import Models.User;
import Services.CartService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/member-cart")
public class CartController extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("loggedInUser");
        String action = req.getParameter("action");

        if (user == null || !"Member".equals(user.getRole())) {
            resp.sendRedirect("login");
            return;
        }

        if ("add".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("id"));
            cartService.addToCart(user.getId(), productId);
            req.getSession().setAttribute("successMessage", "Đã thêm vào giỏ hàng!");
            resp.sendRedirect("member-shop.jsp");
        } else if ("remove".equals(action)) {
            int cartId = Integer.parseInt(req.getParameter("id"));
            cartService.removeItem(cartId);
            req.getSession().setAttribute("successMessage", "Đã xóa sản phẩm khỏi giỏ!");
            resp.sendRedirect("member-cart");
        } else if ("increase".equals(action)) {
            int cartId = Integer.parseInt(req.getParameter("id"));
            cartService.changeQuantity(cartId, 1); // tăng
            resp.sendRedirect("member-cart");
        } else if ("decrease".equals(action)) {
            int cartId = Integer.parseInt(req.getParameter("id"));
            cartService.changeQuantity(cartId, -1); // giảm
            resp.sendRedirect("member-cart");
        } else {
            req.setAttribute("cartItems", cartService.getCartByMemberId(user.getId()));
            req.getRequestDispatcher("member-cart.jsp").forward(req, resp);
        }
    }
}

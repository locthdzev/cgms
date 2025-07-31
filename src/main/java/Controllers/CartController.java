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

    private boolean isAjax(HttpServletRequest req) {
        String requestedWith = req.getHeader("X-Requested-With");
        return requestedWith != null && requestedWith.equals("XMLHttpRequest");
    }

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
            long cartTotal = cartService.getCartTotal(user.getId());
            if (isAjax(req)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String json = "{\"success\": true, \"cartTotal\": " + cartTotal + "}";
                resp.getWriter().write(json);
                return;
            } else {
                req.getSession().setAttribute("successMessage", "Đã xóa sản phẩm khỏi giỏ!");
                resp.sendRedirect("member-cart");
            }
        } else if ("increase".equals(action) || "decrease".equals(action)) {
            int cartId = Integer.parseInt(req.getParameter("id"));
            int delta = "increase".equals(action) ? 1 : -1;
            int newQuantity = cartService.changeQuantity(cartId, delta);
            long cartTotal = cartService.getCartTotal(user.getId());

            if (isAjax(req)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String json = "{\"success\": true, \"newQuantity\": " + newQuantity + ", \"cartTotal\": " + cartTotal
                        + "}";
                resp.getWriter().write(json);
                return;
            } else {
                resp.sendRedirect("member-cart");
            }
        } else if ("setquantity".equals(action)) {
            int cartId = Integer.parseInt(req.getParameter("id"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            if (quantity < 1) {
                quantity = 1;
            }

            int newQuantity = cartService.setQuantity(cartId, quantity);
            long cartTotal = cartService.getCartTotal(user.getId());

            if (isAjax(req)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String json = "{\"success\": true, \"newQuantity\": " + newQuantity + ", \"cartTotal\": " + cartTotal
                        + "}";
                resp.getWriter().write(json);
                return;
            } else {
                resp.sendRedirect("member-cart");
            }
        } else {
            req.setAttribute("cartItems", cartService.getCartByMemberId(user.getId()));
            req.getRequestDispatcher("member-cart.jsp").forward(req, resp);
        }
    }
}

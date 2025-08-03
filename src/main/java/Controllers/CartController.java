package Controllers;

import Models.User;
import Models.Inventory;
import Services.CartService;
import Services.InventoryService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;
import Models.Cart;

@WebServlet("/member-cart")
public class CartController extends HttpServlet {

    private final CartService cartService = new CartService();
    private final InventoryService inventoryService = new InventoryService();

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
            String quantityParam = req.getParameter("quantity");
            int quantity = 1;
            if (quantityParam != null && !quantityParam.isEmpty()) {
                try {
                    quantity = Integer.parseInt(quantityParam);
                    if (quantity < 1)
                        quantity = 1;
                } catch (NumberFormatException e) {
                    quantity = 1;
                }
            }

            // Kiểm tra số lượng tồn kho
            Inventory inventory = inventoryService.getInventoryByProductId(productId);
            if (inventory == null) {
                if (isAjax(req)) {
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    String json = "{\"success\": false, \"message\": \"Sản phẩm không có trong kho!\"}";
                    resp.getWriter().write(json);
                    return;
                } else {
                    req.getSession().setAttribute("errorMessage", "Sản phẩm không có trong kho!");
                    resp.sendRedirect("member-shop");
                    return;
                }
            }

            // Check if product already exists in cart
            List<Cart> cartItems = cartService.getCartByMemberId(user.getId());
            Cart existingItem = null;
            for (Cart item : cartItems) {
                if (item.getProduct().getId().equals(productId)) {
                    existingItem = item;
                    break;
                }
            }

            int currentCartQuantity = existingItem != null ? existingItem.getQuantity() : 0;
            int totalRequestedQuantity = currentCartQuantity + quantity;
            int maxCanAdd = inventory.getQuantity() - currentCartQuantity;

            // Kiểm tra không vượt quá số lượng tồn kho
            if (totalRequestedQuantity > inventory.getQuantity()) {
                if (maxCanAdd <= 0) {
                    // Không thể thêm gì thêm
                    String errorMsg = "Bạn đã có tối đa " + currentCartQuantity + " sản phẩm trong giỏ hàng. " +
                            "Kho chỉ còn " + inventory.getQuantity() + " sản phẩm!";
                    if (isAjax(req)) {
                        resp.setContentType("application/json");
                        resp.setCharacterEncoding("UTF-8");
                        String json = "{\"success\": false, \"message\": \"" + errorMsg + "\"}";
                        resp.getWriter().write(json);
                        return;
                    } else {
                        req.getSession().setAttribute("errorMessage", errorMsg);
                        resp.sendRedirect("member-shop");
                        return;
                    }
                } else {
                    // Tự động thêm số lượng tối đa có thể
                    quantity = maxCanAdd;
                    totalRequestedQuantity = currentCartQuantity + quantity;

                    String warningMsg = "Chỉ có thể thêm " + quantity + " sản phẩm. " +
                            "Kho còn " + inventory.getQuantity() + " sản phẩm, bạn đã có " + currentCartQuantity
                            + " trong giỏ hàng.";

                    if (existingItem != null) {
                        // Product exists, add to existing quantity
                        cartService.setQuantity(existingItem.getId(), totalRequestedQuantity);
                    } else {
                        // New product, add to cart
                        cartService.addToCart(user.getId(), productId);
                        if (quantity > 1) {
                            // Update quantity if more than 1
                            List<Cart> updatedCartItems = cartService.getCartByMemberId(user.getId());
                            for (Cart item : updatedCartItems) {
                                if (item.getProduct().getId().equals(productId)) {
                                    cartService.setQuantity(item.getId(), quantity);
                                    break;
                                }
                            }
                        }
                    }

                    // Get updated cart info
                    long cartTotal = cartService.getCartTotal(user.getId());
                    int cartItemCount = cartService.getCartByMemberId(user.getId()).size();

                    if (isAjax(req)) {
                        resp.setContentType("application/json");
                        resp.setCharacterEncoding("UTF-8");
                        String json = "{\"success\": true, \"message\": \"" + warningMsg + "\", \"cartTotal\": "
                                + cartTotal +
                                ", \"cartItemCount\": " + cartItemCount + ", \"isPartial\": true}";
                        resp.getWriter().write(json);
                        return;
                    } else {
                        req.getSession().setAttribute("successMessage", warningMsg);
                        resp.sendRedirect("member-shop");
                        return;
                    }
                }
            }

            if (existingItem != null) {
                // Product exists, add to existing quantity
                cartService.setQuantity(existingItem.getId(), totalRequestedQuantity);
            } else {
                // New product, add to cart
                cartService.addToCart(user.getId(), productId);
                if (quantity > 1) {
                    // Update quantity if more than 1
                    cartItems = cartService.getCartByMemberId(user.getId());
                    for (Cart item : cartItems) {
                        if (item.getProduct().getId().equals(productId)) {
                            cartService.setQuantity(item.getId(), quantity);
                            break;
                        }
                    }
                }
            }

            // Get updated cart info
            long cartTotal = cartService.getCartTotal(user.getId());
            int cartItemCount = cartService.getCartByMemberId(user.getId()).size();

            if (isAjax(req)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String json = "{\"success\": true, \"message\": \"Đã thêm " + quantity
                        + " sản phẩm vào giỏ hàng!\", \"cartTotal\": " + cartTotal + ", \"cartItemCount\": "
                        + cartItemCount + "}";
                resp.getWriter().write(json);
                return;
            } else {
                req.getSession().setAttribute("successMessage", "Đã thêm " + quantity + " sản phẩm vào giỏ hàng!");
                resp.sendRedirect("member-shop");
            }
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

            // Kiểm tra số lượng kho nếu là increase
            if ("increase".equals(action)) {
                Cart cartItem = cartService.getCartById(cartId);
                if (cartItem != null) {
                    Inventory inventory = inventoryService.getInventoryByProductId(cartItem.getProduct().getId());
                    if (inventory != null && cartItem.getQuantity() >= inventory.getQuantity()) {
                        if (isAjax(req)) {
                            resp.setContentType("application/json");
                            resp.setCharacterEncoding("UTF-8");
                            String json = "{\"success\": false, \"message\": \"Không thể tăng thêm. Chỉ còn " +
                                    inventory.getQuantity() + " sản phẩm trong kho!\"}";
                            resp.getWriter().write(json);
                            return;
                        }
                    }
                }
            }

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

            // Kiểm tra số lượng kho
            Cart cartItem = cartService.getCartById(cartId);
            if (cartItem != null) {
                Inventory inventory = inventoryService.getInventoryByProductId(cartItem.getProduct().getId());
                if (inventory != null && quantity > inventory.getQuantity()) {
                    if (isAjax(req)) {
                        resp.setContentType("application/json");
                        resp.setCharacterEncoding("UTF-8");
                        String json = "{\"success\": false, \"message\": \"Chỉ còn " + inventory.getQuantity() +
                                " sản phẩm trong kho!\"}";
                        resp.getWriter().write(json);
                        return;
                    }
                }
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
        } else if ("count".equals(action)) {
            // API endpoint to get cart count
            int cartItemCount = cartService.getCartByMemberId(user.getId()).size();
            long cartTotal = cartService.getCartTotal(user.getId());

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            String json = "{\"success\": true, \"cartItemCount\": " + cartItemCount + ", \"cartTotal\": " + cartTotal
                    + "}";
            resp.getWriter().write(json);
            return;
        } else {
            req.setAttribute("cartItems", cartService.getCartByMemberId(user.getId()));
            req.getRequestDispatcher("member-cart.jsp").forward(req, resp);
        }
    }
}

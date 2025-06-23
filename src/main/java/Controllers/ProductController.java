package Controllers;

import Models.Product;
import Services.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@WebServlet({ "/product", "/addProduct", "/editProduct" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 30 // 30MB
)
public class ProductController extends HttpServlet {
    private final ProductService service = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        String action = req.getParameter("action");

        if ("/addProduct".equals(servletPath)) {
            // Hiển thị form thêm sản phẩm
            req.setAttribute("product", new Product());
            req.setAttribute("formAction", "create");
            req.getRequestDispatcher("/product.jsp").forward(req, resp);
        } else if ("/editProduct".equals(servletPath)) {
            // Hiển thị form chỉnh sửa sản phẩm
            String idStr = req.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Product product = service.getProductById(id);
                req.setAttribute("product", product);
                req.setAttribute("formAction", "edit");
                req.getRequestDispatcher("/product.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/product");
            }
        } else if ("/product".equals(servletPath)) {
            if (action == null) {
                // Hiển thị danh sách sản phẩm
                List<Product> list = service.getAllProducts();
                req.setAttribute("productList", list);
                req.getRequestDispatcher("/product.jsp").forward(req, resp);
            } else if ("delete".equals(action)) {
                // Xóa sản phẩm
                try {
                    service.deleteProduct(Integer.parseInt(req.getParameter("id")));
                    HttpSession session = req.getSession();
                    session.setAttribute("successMessage", "Xóa sản phẩm thành công!");
                } catch (Exception e) {
                    HttpSession session = req.getSession();
                    session.setAttribute("errorMessage", "Lỗi khi xóa sản phẩm: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/product");
            } else if ("view".equals(action)) {
                // Xem chi tiết sản phẩm
                int id = Integer.parseInt(req.getParameter("id"));
                Product product = service.getProductById(id);
                req.setAttribute("product", product);
                req.setAttribute("formAction", "view");
                req.getRequestDispatcher("/product.jsp").forward(req, resp);
            } else {
                // Mặc định hiển thị danh sách
                List<Product> list = service.getAllProducts();
                req.setAttribute("productList", list);
                req.getRequestDispatcher("/product.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String servletPath = req.getServletPath();
        String formAction = req.getParameter("formAction");
        String idStr = req.getParameter("id");
        HttpSession session = req.getSession();
        Product product = new Product();

        try {
            if (idStr != null && !idStr.trim().isEmpty()) {
                // Update
                product = service.getProductById(Integer.parseInt(idStr));
                product.setUpdatedAt(Instant.now());
            } else {
                // Create
                product.setCreatedAt(Instant.now());
            }

            product.setName(req.getParameter("name"));
            product.setDescription(req.getParameter("description"));

            String priceStr = req.getParameter("price");
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                product.setPrice(new BigDecimal(priceStr));
            }

            product.setStatus(req.getParameter("status"));

            // Handle file upload
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String contentType = filePart.getContentType();

                // Upload to MinIO and get URL
                String imageUrl = service.uploadProductImage(filePart.getInputStream(), fileName, contentType);
                product.setImageUrl(imageUrl);
            }

            if (idStr != null && !idStr.trim().isEmpty()) {
                service.updateProduct(product);
                session.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
            } else {
                service.saveProduct(product);
                session.setAttribute("successMessage", "Tạo sản phẩm mới thành công!");
            }

            resp.sendRedirect(req.getContextPath() + "/product");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            req.setAttribute("product", product);
            req.setAttribute("formAction", formAction);
            req.getRequestDispatcher("/product.jsp").forward(req, resp);
        }
    }
}
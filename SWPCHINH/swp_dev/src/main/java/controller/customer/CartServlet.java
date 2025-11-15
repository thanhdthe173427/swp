package controller.customer;

import dao.CartDao;
import dao.ProductDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/Cart")
public class CartServlet extends HttpServlet {

    private CartDao cartDao = new CartDao();
    private ProductDAO productDao = new ProductDAO(); // ✅ dùng để lấy tên và ảnh sản phẩm

    // ✅ Hiển thị giỏ hàng
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        Cart cart = cartDao.getCartByUserId(user.getId());
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/Customer/cart.jsp").forward(request, response);
    }

    // ✅ Xử lý thêm, cập nhật, xóa sản phẩm
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");

        if (productIdStr == null || productIdStr.isEmpty()) {
            System.err.println("⚠️ Thiếu productId trong request!");
            response.sendRedirect(request.getContextPath() + "/Cart");
            return;
        }

        long productId = Long.parseLong(productIdStr);

        // 🔹 Lấy giỏ hàng người dùng
        Cart cart = cartDao.getCartByUserId(user.getId());
        if (cart == null) {
            cart = new Cart();
            cart.setUserId(user.getId());
            cartDao.insertCart(cart);
        }

        try {
            switch (action) {

                // 🛒 Thêm sản phẩm
                case "add": {
                    String quantityStr = request.getParameter("quantity");
                    String priceStr = request.getParameter("price");

                    if (quantityStr == null || priceStr == null) {
                        throw new IllegalArgumentException("Thiếu quantity hoặc price khi thêm vào giỏ hàng.");
                    }

                    int quantity = Integer.parseInt(quantityStr);
                    BigDecimal price = new BigDecimal(priceStr);
                    boolean buyNow = "true".equals(request.getParameter("buyNow"));

                    // ✅ Lấy thông tin sản phẩm từ DB
                    Product product = productDao.getProductById(productId);
                    if (product == null) {
                        throw new IllegalArgumentException("Không tìm thấy sản phẩm ID = " + productId);
                    }

                    // ✅ Tạo CartItem theo constructor mới
                    CartItem item = new CartItem(
                        0,
                        cart.getId(),
                        productId,
                        product.getName(),
                        product.getUrl(),
                        quantity,
                        price
                    );

                    // ✅ Thêm sản phẩm vào giỏ hàng
                    cartDao.addItemToCart(cart.getId(), item);

                    if (buyNow) {
                        response.sendRedirect(request.getContextPath() + "/Cart");
                        return;
                    } else {
                        request.setAttribute("successMsg", "✅ Đã thêm vào giỏ hàng!");
                        response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId);
                        return;
                    }
                }

                // ➕ Tăng số lượng
                case "increase":
                    cartDao.updateItemQuantity(cart.getId(), productId, 1);
                    break;

                // ➖ Giảm số lượng
                case "decrease":
                    cartDao.updateItemQuantity(cart.getId(), productId, -1);
                    break;

                // ❌ Xóa sản phẩm
                case "remove":
                    cartDao.removeItem(cart.getId(), productId);
                    break;

                default:
                    System.err.println("⚠️ Hành động không hợp lệ: " + action);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Lỗi xử lý giỏ hàng: " + e.getMessage());
        }

        // ✅ Sau khi xử lý → load lại trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/Cart");
    }
}

package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.CartDao;
import model.Cart;
import model.CartItem;
import model.User;

/**
 * Servlet điều hướng đến trang thanh toán (checkout.jsp)
 * Kiểm tra giỏ hàng trước khi tiến hành thanh toán.
 * Chỉ hiển thị các sản phẩm được chọn từ giỏ hàng.
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/Checkout"})
public class CheckoutServlet extends HttpServlet {

    private final CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        // 🔹 Lấy giỏ hàng người dùng
        Cart cart = cartDao.getCartByUserId(user.getId());


        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            // Nếu giỏ hàng trống → quay lại trang giỏ hàng
            request.setAttribute("errorMessage", "Giỏ hàng của bạn đang trống. Vui lòng thêm sản phẩm trước khi thanh toán!");
            request.getRequestDispatcher("/Customer/cart.jsp").forward(request, response);
            return;
        }

        // ✅ Lấy danh sách ID sản phẩm được chọn từ form (VD: "12,15,18")
        String selectedParam = request.getParameter("selectedItems");
        List<CartItem> selectedItems = new ArrayList<>();

        if (selectedParam != null && !selectedParam.isEmpty()) {
            String[] selectedIds = selectedParam.split(",");
            for (String idStr : selectedIds) {
                try {
                    long productId = Long.parseLong(idStr.trim());
                    for (CartItem item : cart.getItems()) {
                        if (item.getProductId() == productId) {
                            selectedItems.add(item);
                            break;
                        }
                    }
                } catch (NumberFormatException e) {
                    System.err.println("⚠️ Lỗi định dạng productId: " + idStr);
                }
            }
        }

        // ⚙️ Nếu không chọn gì thì báo lỗi
        if (selectedItems.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ít nhất một sản phẩm để thanh toán!");
            request.getRequestDispatcher("/Customer/cart.jsp").forward(request, response);
            return;
        }

        // ✅ Tạo giỏ hàng tạm chỉ chứa sản phẩm được chọn
        Cart selectedCart = new Cart();
        selectedCart.setItems(selectedItems);

        // Lưu vào session (để sử dụng trong bước thanh toán)
        session.setAttribute("selectedCart", selectedCart);

        // Chuyển sang trang checkout.jsp
        request.setAttribute("cart", selectedCart);
        request.getRequestDispatcher("/Customer/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

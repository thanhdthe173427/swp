package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.CartDao;
import dao.OrderDao;
import model.Cart;
import model.User;
import model.Order;

import java.io.IOException;

@WebServlet(name = "ConfirmOrderServlet", urlPatterns = {"/ConfirmOrder"})
public class ConfirmOrderServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 🔒 Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        // 🧾 Lấy mã đơn hàng từ request
        String orderCode = request.getParameter("orderCode");
        if (orderCode == null || orderCode.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Customer/cart.jsp?error=missing_order_code");
            return;
        }

        // 📦 Lấy đơn hàng từ DB theo mã
        Order order = orderDao.getOrderByCode(orderCode);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/Customer/cart.jsp?error=order_not_found");
            return;
        }

        // 🧹 Xóa giỏ hàng của người dùng sau khi đặt
        // 🧹 Sau khi thanh toán thành công → chỉ xóa sản phẩm được chọn
   
        String selectedItems = (String) session.getAttribute("selectedItems");

        if (selectedItems != null && !selectedItems.isEmpty()) {
            CartDao cartDao = new CartDao();
            Cart cart = cartDao.getCartByUserId(user.getId());

            for (String pid : selectedItems.split(",")) {
                cartDao.removeItem(cart.getId(), Long.parseLong(pid));
            }

            // ✅ Xóa khỏi session để không bị xóa lần nữa
            session.removeAttribute("selectedItems");
            System.out.println("🧹 Đã xóa các sản phẩm đã thanh toán (COD) khỏi giỏ hàng.");
        }

        // 🪄 Xoá giỏ trong session (nếu có)
        session.removeAttribute("selectedCart");

        // ✅ Gửi đơn hàng sang trang xác nhận
        request.setAttribute("order", order);
        request.getRequestDispatcher("/Customer/confirmOrder.jsp").forward(request, response);
    }

    // Nếu POST đến ConfirmOrder cũng gọi GET (đề phòng)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

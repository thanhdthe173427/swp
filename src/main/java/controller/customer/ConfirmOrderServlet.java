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
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ConfirmOrderServlet", urlPatterns = {"/ConfirmOrder"})
public class ConfirmOrderServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final CartDao cartDao = new CartDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 🔒 Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }

        // 🛒 Lấy giỏ hàng
        Cart cart = cartDao.getCartByUserId(user.getId());
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Customer/cart.jsp?error=empty_cart");
            return;
        }

        // 📝 Lấy thông tin người nhận từ form checkout
        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String receiverAddress = request.getParameter("receiverAddress");
        String note = request.getParameter("note");

        // 💳 Thanh toán COD
        String paymentMethod = "COD";

        // 🧾 Tạo đơn hàng
        Order order = new Order();
        order.setOrderCode("ORD" + System.currentTimeMillis());
        order.setUserId(user.getId());
        order.setCustomerName(receiverName != null ? receiverName : user.getFullName());
        order.setCustomerPhone(receiverPhone != null ? receiverPhone : user.getPhone());
        order.setBillingAddressId(1L); // Có thể thay bằng ID thực tế từ bảng addresses
        order.setShippingAddressId(1L);
        order.setVoucherCode(null);
        order.setStatus("Ordered");
        order.setPaymentStatus("Paid");
        order.setSubtotal(cart.getTotalAmount() != null ? cart.getTotalAmount() : BigDecimal.ZERO);
        order.setDiscountTotal(BigDecimal.ZERO);
        order.setShippingFee(BigDecimal.ZERO);
        order.setTaxTotal(BigDecimal.ZERO);
        order.setGrandTotal(cart.getTotalAmount() != null ? cart.getTotalAmount() : BigDecimal.ZERO);
        order.setNote(note);
        order.setPlacedAt(new Date());
        order.setCreatedAt(new Date());
        order.setUpdatedAt(new Date());

        // 🧾 Tạo danh sách OrderItem
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem item : cart.getItems()) {
            OrderItem oi = new OrderItem();
            oi.setProductId(item.getProductId());
            oi.setQuantity(item.getQuantity());
            oi.setUnitPrice(item.getUnitPrice());
            oi.setTotalPrice(item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            orderItems.add(oi);
        }

        // ✅ Lưu đơn hàng và chi tiết
        long orderId = orderDao.createOrder(order, orderItems);

        if (orderId > 0) {
            // 🧹 Xoá giỏ hàng sau khi đặt
            cartDao.clearCart(cart.getId());

            // 🪄 Xoá giỏ trong session
            session.removeAttribute("selectedCart");

            // ✅ Gửi sang trang xác nhận
            order.setId(orderId);
            request.setAttribute("order", order);
            request.getRequestDispatcher("/Customer/confirmOrder.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Đặt hàng thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("/Customer/checkout.jsp").forward(request, response);
        }
    }
}

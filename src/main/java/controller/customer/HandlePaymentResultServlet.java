package controller.customer;

import dao.OrderDao;
import dao.CartDao;
import model.User;
import model.Cart;
import utils.Config;
import utils.EmailUtil;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "HandlePaymentResultServlet", urlPatterns = {"/handle-payment-result"})
public class HandlePaymentResultServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        boolean isSuccess = false;
        String message;

        // ✅ Lấy mã trạng thái giao dịch từ VNPay
        String transactionStatus = request.getParameter("vnp_TransactionStatus");

        // ✅ Lấy mã đơn hàng từ VNPay callback
        String orderCode = request.getParameter("vnp_TxnRef");

        if ("00".equals(transactionStatus)) {
            isSuccess = true;
            message = "✅ Thanh toán VNPay thành công!";

            // ✅ Cập nhật trạng thái đơn hàng trong DB
            orderDao.updateOrderStatus(Config.orderID, "Submitted");

            // ✅ Lấy thông tin user hiện tại
            User user = (User) request.getSession().getAttribute("user");

            if (user != null) {
                double amount = 0;
                try {
                    amount = Double.parseDouble(request.getParameter("vnp_Amount")) / 100;
                } catch (NumberFormatException ignored) {
                }

                String transactionNo = request.getParameter("vnp_TransactionNo");

                // 📨 Gửi email xác nhận thanh toán
                EmailUtil.sendPaymentConfirmation(
                        user.getEmail(),
                        orderCode,
                        amount,
                        transactionNo
                );

                // 🧹 Sau khi thanh toán thành công → chỉ xóa sản phẩm được chọn
                HttpSession session = request.getSession();
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

                // 🧽 Xóa giỏ hàng trong session (nếu có)
                request.getSession().removeAttribute("selectedCart");
            }

        } else {
            message = "❌ Giao dịch không thành công! (Mã lỗi: " + transactionStatus + ")";
            orderDao.updateOrderStatus(Config.orderID, "Wait for Pay");
        }

        // ✅ Truyền dữ liệu sang JSP hiển thị
        request.setAttribute("isSuccess", isSuccess);
        request.setAttribute("message", message);

        // ✅ Chuyển tiếp đến trang kết quả
        request.getRequestDispatcher("/Customer/paymentResult.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}

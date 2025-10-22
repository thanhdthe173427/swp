package controller.customer;

import dao.OrderDao;
import model.User;
import utils.Config;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.EmailUtil;

@WebServlet(name = "HandlePaymentResultServlet", urlPatterns = {"/handle-payment-result"})
public class HandlePaymentResultServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        boolean isSuccess = false;
        String message;

        // ✅ Lấy mã trạng thái giao dịch từ VNPay
        String transactionStatus = request.getParameter("vnp_TransactionStatus");

        if ("00".equals(transactionStatus)) {
            isSuccess = true;
            message = "✅ Thanh toán VNPay thành công!";

            // ✅ Cập nhật trạng thái đơn hàng trong DB
            new OrderDao().updateOrderStatus(Config.orderID, "Submitted");

            // ✅ Gửi email xác nhận cho khách hàng
            User user = (User) request.getSession().getAttribute("user");
            if (user != null) {
                double amount = 0;
                try {
                    amount = Double.parseDouble(request.getParameter("vnp_Amount")) / 100;
                } catch (NumberFormatException ignored) {}

                String orderCode = request.getParameter("vnp_TxnRef");
                String transactionNo = request.getParameter("vnp_TransactionNo");

                // 📨 Gửi email xác nhận thanh toán
                EmailUtil.sendPaymentConfirmation(
                        user.getEmail(),
                        orderCode,
                        amount,
                        transactionNo
                );
            }

        } else {
            message = "❌ Giao dịch không thành công! (Mã lỗi: " + transactionStatus + ")";
            new OrderDao().updateOrderStatus(Config.orderID, "Wait for Pay");
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

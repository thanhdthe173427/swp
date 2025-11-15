package controller.customer;

import dao.OrderDao;
import dao.CartDao;
import dao.DBContext;
import dao.FormulaDAO;
import dao.InventoryDAO;
import dao.OrderItemDao;
import dao.ProductDAO;
import model.OrderItem;
import model.User;
import model.Cart;
import utils.Config;
import utils.EmailUtil;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.SQLException;
import model.Formula;
import model.Order;

@WebServlet(name = "HandlePaymentResultServlet", urlPatterns = {"/handle-payment-result"})
public class HandlePaymentResultServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final CartDao cartDao = new CartDao();
    private final FormulaDAO formulaDao = new FormulaDAO(); // ✅ THÊM
    private final InventoryDAO inventoryDao = new InventoryDAO(); // ✅ THÊM

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        boolean isSuccess = false;
        String message;

        // ✅ Lấy mã trạng thái giao dịch và mã đơn hàng TỪ VNPAY
        String transactionStatus = request.getParameter("vnp_TransactionStatus");
        String orderCode = request.getParameter("vnp_TxnRef"); // <-- Dùng cái này, không dùng Config.orderID

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (orderCode == null || orderCode.isEmpty()) {
            message = "❌ Giao dịch lỗi: Không tìm thấy mã đơn hàng (vnp_TxnRef).";
            request.setAttribute("isSuccess", false);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/Customer/paymentResult.jsp").forward(request, response);
            return;
        }

        // Lấy đơn hàng từ DB
        Order order = orderDao.getOrderByCode(orderCode);
        if (order == null) {
            message = "❌ Giao dịch lỗi: Không tìm thấy đơn hàng #" + orderCode + " trong hệ thống.";
            request.setAttribute("isSuccess", false);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/Customer/paymentResult.jsp").forward(request, response);
            return;
        }

        // 1. THANH TOÁN THÀNH CÔNG
        if ("00".equals(transactionStatus)) {

            Connection conn = null;
            try {
                // ✅ BẮT ĐẦU TRANSACTION
                conn = new DBContext().getConnection();
                conn.setAutoCommit(false);

                // 1. TRỪ KHO (Logic giống hệt ConfirmOrderServlet)
                List<OrderItem> orderItems = orderDao.getOrderItemsByOrderId(order.getId(), conn);
                for (OrderItem item : orderItems) {
                    List<Formula> formulaItems = formulaDao.getFormulaForProduct(conn, item.getProductId());
                    for (Formula formulaItem : formulaItems) {
                        long materialId = formulaItem.getMaterialId();
                        int totalMaterialNeeded = formulaItem.getQuantity() * item.getQuantity();
                        if (totalMaterialNeeded > 0) {
                            inventoryDao.deductStock(conn, materialId, totalMaterialNeeded);
                        }
                    }
                }

                // 2. XÓA GIỎ HÀNG (Bên trong transaction)
                String selectedItems = (String) session.getAttribute("selectedItems");
                if (user != null && selectedItems != null && !selectedItems.isEmpty()) {
                    Cart cart = cartDao.getCartByUserId(user.getId(), conn); // Dùng conn
                    if (cart != null) {
                        for (String pid : selectedItems.split(",")) {
                            cartDao.removeItem(cart.getId(), Long.parseLong(pid), conn); // Dùng conn
                        }
                    }
                }

                // 3. CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG
                // (Bạn nên tạo một hàm updateStatus(long id, String status, String paymentStatus, Connection conn))
                // Tạm thời gọi hàm cũ (nó sẽ mở connection riêng, không tốt lắm nhưng chạy được)
                orderDao.updateOrderStatus(order.getId(), "Ordered");
                // TODO: Tạo hàm updatePaymentStatus(order.getId(), "Paid", conn)

                // 4. COMMIT GIAO DỊCH
                conn.commit();

                isSuccess = true;
                message = "✅ Thanh toán VNPay thành công cho đơn hàng #" + orderCode;

                // 5. GỬI EMAIL (Sau khi commit)
                if (user != null) {
                    double amount = Double.parseDouble(request.getParameter("vnp_Amount")) / 100;
                    String transactionNo = request.getParameter("vnp_TransactionNo");
                    EmailUtil.sendPaymentConfirmation(user.getEmail(), orderCode, amount, transactionNo);
                }

                // 6. Xóa session không cần nữa
                session.removeAttribute("selectedItems");
                session.removeAttribute("selectedCart");

            } catch (Exception e) {
                // LỖI (VD: HẾT HÀNG)
                isSuccess = false;
                message = "❌ Thanh toán thành công, NHƯNG có lỗi khi xử lý kho (VD: hết hàng). Vui lòng liên hệ shop với mã đơn #" + orderCode;
                e.printStackTrace();

                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }

                // Cập nhật trạng thái: Đã trả tiền nhưng kho lỗi
                orderDao.updateOrderStatus(order.getId(), "Paid_OutOfStock");

            } finally {
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }

            // 2. THANH TOÁN THẤT BẠI
        } else {
            message = "❌ Giao dịch VNPay không thành công! (Mã lỗi: " + transactionStatus + ")";
            // Cập nhật đơn hàng (đã tạo ở bước PaymentController) về trạng thái thất bại
            orderDao.updateOrderStatus(order.getId(), "FailedPayment");
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

package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.CartDao;
import dao.DBContext;
import dao.OrderDao;
import model.Cart;
import model.User;
import model.Order;
import model.OrderItem;
import model.Formula;
import dao.FormulaDAO;
import dao.InventoryDAO;

import java.io.IOException;
import java.io.PrintWriter; // Dùng để in stack trace
import java.io.StringWriter; // Dùng để in stack trace
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ConfirmOrderServlet", urlPatterns = {"/ConfirmOrder"})
public class ConfirmOrderServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final CartDao cartDao = new CartDao();
    private final FormulaDAO formulaDao = new FormulaDAO();
    private final InventoryDAO inventoryDao = new InventoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StringBuilder logBuilder = new StringBuilder();
        logBuilder.append("--- DEBUG: ConfirmOrderServlet BẮT ĐẦU ---\n");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 🔒 1. Kiểm tra đăng nhập
        if (user == null) {
            logBuilder.append("DEBUG: Lỗi - User chưa đăng nhập.\n");
            session.setAttribute("debugLog", logBuilder.toString());
            response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
            return;
        }
        logBuilder.append("DEBUG: User đã đăng nhập: ").append(user.getEmail()).append("\n");

        // 🧾 2. Lấy mã đơn hàng
        String orderCode = request.getParameter("orderCode");
        if (orderCode == null || orderCode.trim().isEmpty()) {
            logBuilder.append("DEBUG: Lỗi - Không tìm thấy 'orderCode' từ parameter.\n");
            session.setAttribute("debugLog", logBuilder.toString());
            response.sendRedirect(request.getContextPath() + "/Customer/cart.jsp?error=missing_order_code");
            return;
        }
        logBuilder.append("DEBUG: Đã lấy được orderCode: ").append(orderCode).append("\n");

        // 📦 3. Lấy đơn hàng từ DB
        Order order = orderDao.getOrderByCode(orderCode);
        if (order == null) {
            logBuilder.append("DEBUG: Lỗi - Không tìm thấy đơn hàng với code: ").append(orderCode).append("\n");
            session.setAttribute("debugLog", logBuilder.toString());
            response.sendRedirect(request.getContextPath() + "/Customer/cart.jsp?error=order_not_found");
            return;
        }
        logBuilder.append("DEBUG: Đã lấy được Order ID: ").append(order.getId()).append(" | Trạng thái: ").append(order.getStatus()).append("\n");

        // ====================================================================
        // ✅ BƯỚC KIỂM TRA TRẠNG THÁI (TRÁNH RELOAD)
        // ====================================================================
        
        // CHỈ CHẠY LOGIC TRỪ KHO NẾU ĐƠN HÀNG ĐANG "PENDING"
        if ("Pending".equalsIgnoreCase(order.getStatus())) {
            logBuilder.append("DEBUG: Đơn hàng là 'Pending'. Bắt đầu xử lý trừ kho...\n");
            
            Connection conn = null;
            try {
                // 4. Mở Connection (Chế độ AutoCommit=true)
                conn = new DBContext().getConnection();
                logBuilder.append("DEBUG: (TRY) Đã mở connection (AutoCommit=true).\n");

                // 5. Lấy danh sách sản phẩm
                List<OrderItem> orderItems = orderDao.getOrderItemsByOrderId(order.getId(), conn);
                logBuilder.append("DEBUG: Tìm thấy ").append(orderItems.size()).append(" sản phẩm.\n");

                // 6. Lặp qua từng sản phẩm để trừ kho
                for (OrderItem item : orderItems) {
                    logBuilder.append("  > Đang xử lý ProductID: ").append(item.getProductId())
                            .append(", Số lượng đặt: ").append(item.getQuantity()).append("\n");

                    List<Formula> formulaItems = formulaDao.getFormulaForProduct(conn, item.getProductId());
                    logBuilder.append("    >> Tìm thấy ").append(formulaItems.size()).append(" nguyên liệu.\n");

                    for (Formula formulaItem : formulaItems) {
                        long materialId = formulaItem.getMaterialId();
                        int qtyPerProduct = formulaItem.getQuantity();
                        int totalMaterialNeeded = qtyPerProduct * item.getQuantity();

                        logBuilder.append("      >> Cần MaterialID: ").append(materialId)
                                .append(" | SL công thức: ").append(qtyPerProduct).append("\n");
                        logBuilder.append("      >> TỔNG CẦN TRỪ: ").append(totalMaterialNeeded).append("\n");

                        if (totalMaterialNeeded > 0) {
                            logBuilder.append("      >> GỌI inventoryDao.deductStock (trừ ngay lập tức)\n");
                            inventoryDao.deductStock(conn, materialId, totalMaterialNeeded);
                            logBuilder.append("      >> GỌI deductStock XONG.\n");
                        } else {
                            logBuilder.append("      >> BỎ QUA vì totalMaterialNeeded = 0\n");
                        }
                    }
                }
                logBuilder.append("DEBUG: Đã xử lý trừ kho xong.\n");

                // 7. Xóa giỏ hàng
                String selectedItems = (String) session.getAttribute("selectedItems");
                logBuilder.append("DEBUG: Lấy selectedItems từ session: ").append(selectedItems).append("\n");

                if (selectedItems != null && !selectedItems.isEmpty()) {
                    logBuilder.append("DEBUG: Bắt đầu xóa giỏ hàng (xóa ngay lập tức)\n");
                    Cart cart = cartDao.getCartByUserId(user.getId(), conn);

                    if (cart == null) {
                        logBuilder.append("DEBUG: Lỗi - Không tìm thấy giỏ hàng.\n");
                        throw new SQLException("Không tìm thấy giỏ hàng của user.");
                    }

                    for (String pid : selectedItems.split(",")) {
                        logBuilder.append("  > Xóa PID: ").append(pid).append(" khỏi CartID: ").append(cart.getId()).append("\n");
                        cartDao.removeItem(cart.getId(), Long.parseLong(pid), conn);
                    }
                    logBuilder.append("🧹 Đã xóa giỏ hàng.\n");
                }
                
                // 8. ✅ CẬP NHẬT TRẠNG THÁI SAU KHI XONG
                logBuilder.append("DEBUG: Cập nhật trạng thái đơn hàng -> Ordered & Paid\n");
                orderDao.updateOrderAndPaymentStatus(order.getId(), "Ordered", "Paid");

                logBuilder.append("✅ (SUCCESS) Đã thực thi xong.\n");

            } catch (Exception e) {
                // 9. Nếu có lỗi (KHÔNG THỂ ROLLBACK)
                logBuilder.append("\n--- DEBUG: (CATCH) LỖI XẢY RA ---\n");
                logBuilder.append("Lỗi: ").append(e.getMessage()).append("\n");

                StringWriter sw = new StringWriter();
                e.printStackTrace(new PrintWriter(sw));
                logBuilder.append(sw.toString()).append("\n");
                
                logBuilder.append("DEBUG: Lỗi xảy ra, đơn hàng vẫn là 'Pending'.\n");

                session.setAttribute("debugLog", logBuilder.toString());

                String errorMsg = e.getMessage() != null ? e.getMessage() : "stock_deduction_failed";
                response.sendRedirect(request.getContextPath() + "/Customer/cart.jsp?error=" + URLEncoder.encode(errorMsg, "UTF-8"));
                return;

            } finally {
                // 10. Đóng kết nối
                if (conn != null) {
                    try {
                        conn.close();
                        logBuilder.append("DEBUG: (FINALLY) Đã đóng connection.\n");
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        
        } else {
            // ✅ Nếu trạng thái KHÔNG PHẢI "Pending" (ví dụ là "Ordered")
            logBuilder.append("DEBUG: Đơn hàng đã được xử lý trước đó (Status: ").append(order.getStatus()).append("). Bỏ qua trừ kho.\n");
        }

        // ====================================================================
        // ✅ KẾT THÚC LOGIC
        // ====================================================================
        
        // 11. Xóa các thuộc tính session (chỉ xóa nếu xử lý thành công)
        if (!"Pending".equalsIgnoreCase(order.getStatus()) || logBuilder.toString().contains("SUCCESS")) {
            logBuilder.append("DEBUG: Xóa selectedItems và selectedCart khỏi session.\n");
            session.removeAttribute("selectedItems");
            session.removeAttribute("selectedCart");
        }

        // 12. Gửi đơn hàng sang trang xác nhận
        logBuilder.append("DEBUG: Forward sang /Customer/confirmOrder.jsp\n");
        request.setAttribute("debugLog", logBuilder.toString());
        
        // Lấy lại order MỚI NHẤT (đã được cập nhật status) để hiển thị
        Order updatedOrder = orderDao.getOrderByCode(orderCode);
        request.setAttribute("order", updatedOrder); 
        
        request.getRequestDispatcher("/Customer/confirmOrder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
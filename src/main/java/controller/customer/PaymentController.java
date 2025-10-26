package controller.customer;

import dao.CartDao;
import dao.OrderDao;
import model.Cart;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.User;
import utils.Config;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "PaymentController", urlPatterns = {"/payment"})
public class PaymentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🛒 1️⃣ Lấy danh sách sản phẩm được chọn
        String selectedIds = request.getParameter("selectedProductIds");
        List<Long> selectedIdsList = new ArrayList<>();
        if (selectedIds != null && !selectedIds.isEmpty()) {
            for (String idStr : selectedIds.split(",")) {
                try {
                    selectedIdsList.add(Long.parseLong(idStr.trim()));
                } catch (NumberFormatException ignored) {}
            }
        }

        // 💰 2️⃣ Lấy tổng tiền thanh toán
        BigDecimal amount;
        try {
            amount = new BigDecimal(request.getParameter("amount"));
        } catch (Exception e) {
            response.sendRedirect("../Customer/cart.jsp?error=invalid_amount");
            return;
        }

        // 💳 3️⃣ Kiểm tra đăng nhập
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("../Common/login.jsp");
            return;
        }

        // 🔹 4️⃣ Phương thức thanh toán
        String method = request.getParameter("paymentMethod");
        if (method == null || method.isEmpty()) method = "COD";

        // 🧺 5️⃣ Lấy giỏ hàng người dùng
        CartDao cartDao = new CartDao();
        Cart cart = cartDao.getCartByUserId(user.getId());
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("../Customer/cart.jsp?error=empty_cart");
            return;
        }

        List<CartItem> selectedItems = cart.getItems().stream()
                .filter(i -> selectedIdsList.contains(i.getProductId()))
                .collect(Collectors.toList());

        if (selectedItems.isEmpty()) {
            response.sendRedirect("../Customer/cart.jsp?error=no_selected_items");
            return;
        }

        // 🧾 6️⃣ Tạo danh sách OrderItem
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem item : selectedItems) {
            OrderItem oi = new OrderItem();
            oi.setProductId(item.getProductId());
            oi.setQuantity(item.getQuantity());
            oi.setUnitPrice(item.getUnitPrice());
            oi.setTotalPrice(item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            orderItems.add(oi);
        }

        // 🧾 7️⃣ Tạo đơn hàng
        Order order = new Order();
        order.setOrderCode(Config.getRandomNumber(10));
        order.setUserId(user.getId());
        order.setCustomerName(user.getFullName());
        order.setCustomerPhone(user.getPhone());
        order.setBillingAddressId(1L);
        order.setShippingAddressId(1L);
        order.setVoucherCode(null);
        order.setStatus(method.equalsIgnoreCase("vnpay") ? "Pending" : "Ordered");
        order.setPaymentStatus(method.equalsIgnoreCase("vnpay") ? "Unpaid" : "Paid");
        order.setSubtotal(amount);
        order.setDiscountTotal(BigDecimal.ZERO);
        order.setShippingFee(BigDecimal.ZERO);
        order.setTaxTotal(BigDecimal.ZERO);
        order.setGrandTotal(amount);
        order.setNote("Đơn hàng của " + user.getFullName());
        order.setPlacedAt(new Date());
        order.setCreatedAt(new Date());
        order.setUpdatedAt(new Date());

        OrderDao orderDao = new OrderDao();
        long orderId = orderDao.createOrder(order, orderItems); // ✅ trả về ID đơn hàng

        if (orderId <= 0) {
            response.sendRedirect("../Customer/cart.jsp?error=create_order_failed");
            return;
        }

        // ✅ Lưu ID đơn hàng để xử lý sau trong Config (VD: khi VNPay trả kết quả)
        Config.orderID = (int) orderId;
        System.out.println("✅ Đã tạo đơn hàng ID = " + orderId + ", lưu vào Config.orderID");

        // 🔑 8️⃣ Nếu là VNPay → tạo URL thanh toán
        if (method.equalsIgnoreCase("vnpay")) {
            int amountVnpay = amount.multiply(BigDecimal.valueOf(100)).intValue(); // ✅ nhân 100 theo yêu cầu VNPay

            Map<String, String> vnp_Params = new LinkedHashMap<>();
            vnp_Params.put("vnp_Version", "2.1.0");
            vnp_Params.put("vnp_Command", "pay");
            vnp_Params.put("vnp_TmnCode", Config.vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amountVnpay));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", order.getOrderCode()); // ✅ dùng orderCode làm mã giao dịch
            vnp_Params.put("vnp_OrderInfo", "Thanh toán đơn hàng #" + order.getOrderCode());
            vnp_Params.put("vnp_OrderType", "other");
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl); // ✅ đúng tên biến trong Config
            vnp_Params.put("vnp_IpAddr", Config.getIpAddress(request));

            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));

            // 🔒 Tạo chuỗi query & hash
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);

            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            for (Iterator<String> itr = fieldNames.iterator(); itr.hasNext();) {
                String fieldName = itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if (fieldValue != null && !fieldValue.isEmpty()) {
                    hashData.append(fieldName).append('=')
                            .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.name()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.name()))
                            .append('=')
                            .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.name()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }

            String vnp_SecureHash = Config.hmacSHA512(Config.vnp_HashSecret, hashData.toString());
            query.append("&vnp_SecureHash=").append(vnp_SecureHash);
            String paymentUrl = Config.vnp_PayUrl + "?" + query;

            // ✅ Log URL ra console
            System.out.println("🔗 Redirect VNPay Sandbox URL: " + paymentUrl);

            response.sendRedirect(paymentUrl);
            return;
        }

       // 🚀 9️⃣ Thanh toán COD → chuyển qua ConfirmOrderServlet
response.sendRedirect(request.getContextPath() + "/ConfirmOrder?orderCode=" + order.getOrderCode());


    }
}

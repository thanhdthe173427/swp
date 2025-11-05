<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Cart, model.CartItem, model.User, model.Address, java.util.*, java.math.BigDecimal" %>

<jsp:include page="/Trang/header.jsp" />

<div style="display:flex; gap:20px; max-width:1200px; margin:20px auto;">
    <jsp:include page="/Trang/lap3.jsp" />

    <div style="flex:1; background-color:#fff; border-radius:10px; padding:30px; box-shadow:0 4px 10px rgba(0,0,0,0.1);">
        <h3 style="color:#e60073;">Xác nhận thanh toán</h3>

        <%
            // Lấy dữ liệu từ Servlet
            Cart cart = (Cart) request.getAttribute("cart");
            if (cart == null) {
                cart = (Cart) session.getAttribute("selectedCart");
            }

            User customer = (User) request.getAttribute("customer");
            Address defaultAddress = (Address) request.getAttribute("defaultAddress");

            double total = (cart != null) ? cart.calculateTotalAmount().doubleValue() : 0;
        %>

        <% if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) { %>
            <p style="margin-top:15px; color:#777;">Không có sản phẩm nào được chọn để thanh toán 💨</p>
            <a href="<%= request.getContextPath() %>/Cart"
               style="display:inline-block; margin-top:15px; text-decoration:none; background-color:#e60073; color:white; padding:10px 18px; border-radius:6px;">
               🛍️ Quay lại giỏ hàng
            </a>
        <% } else { %>

        <!-- 🧾 Danh sách sản phẩm đã chọn -->
        <div style="margin-top:20px; border:1px solid #ffd1dc; border-radius:10px; padding:15px; background-color:#fff8fb;">
            <h4 style="color:#8b0057;">🛒 Sản phẩm đã chọn:</h4>
            <table style="width:100%; border-collapse:collapse; margin-top:10px;">
                <tr style="background-color:#ffe6f2; color:#8b0057;">
                    <th style="padding:10px; text-align:left;">Sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Tổng</th>
                </tr>

                <% for (CartItem item : cart.getItems()) { %>
                <tr style="border-bottom:1px solid #ffd1dc;">
                    <td style="padding:10px;">
                        <img src="<%= item.getProductImage() != null ? item.getProductImage() : "https://cdn-icons-png.flaticon.com/512/3081/3081559.png" %>"
                             alt="Ảnh sản phẩm" style="width:60px; height:60px; border-radius:6px; vertical-align:middle; margin-right:10px;">
                        <%= item.getProductName() %>
                    </td>
                    <td><%= String.format("%,.0f", item.getUnitPrice()) %> đ</td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= String.format("%,.0f", item.getUnitPrice().doubleValue() * item.getQuantity()) %> đ</td>
                </tr>
                <% } %>
            </table>
        </div>

        <!-- 🧍‍♀️ Form xác nhận thông tin thanh toán -->
        <form id="checkoutForm" method="post" action="<%= request.getContextPath() %>/payment" style="margin-top:25px;">
            <div style="background-color:#fff0f6; padding:20px; border-radius:10px; border:1px solid #ffcce0;">
                <h4 style="color:#8b0057; margin-bottom:15px;">Thông tin người nhận hàng</h4>

                <label>Họ và tên người nhận:</label><br>
                <input type="text" name="receiverName" required placeholder="Nhập họ và tên"
                       value="<%= (customer != null && customer.getFullName() != null) ? customer.getFullName() : "" %>"
                       style="width:100%; padding:10px; margin-bottom:12px; border:1px solid #ffb6c1; border-radius:6px;">

                <label>Số điện thoại:</label><br>
                <input type="tel" name="receiverPhone" pattern="[0-9]{10,11}" required placeholder="VD: 0909123456"
                       value="<%= (customer != null && customer.getPhone() != null) ? customer.getPhone() : "" %>"
                       style="width:100%; padding:10px; margin-bottom:12px; border:1px solid #ffb6c1; border-radius:6px;">

                <label>Địa chỉ nhận hàng:</label><br>
                <textarea name="receiverAddress" required placeholder="Nhập địa chỉ cụ thể"
                          style="width:100%; padding:10px; height:80px; border:1px solid #ffb6c1; border-radius:6px; resize:none; margin-bottom:12px;"><%= 
                    (defaultAddress != null && defaultAddress.getFullAddress() != null) ? defaultAddress.getFullAddress() : "" 
                %></textarea>

                <label>Ghi chú giao hoa (tuỳ chọn):</label><br>
                <textarea name="deliveryNote" placeholder="Ví dụ: Giao hoa vào buổi sáng, vui lòng không gọi trước"
                          style="width:100%; padding:10px; height:60px; border:1px solid #ffb6c1; border-radius:6px; resize:none; margin-bottom:12px;"></textarea>
            </div>

            <input type="hidden" name="selectedProductIds" value="<%= 
                cart.getItems().stream()
                    .map(i -> String.valueOf(i.getProductId()))
                    .collect(java.util.stream.Collectors.joining(",")) 
            %>">

            <div style="margin-top:25px;">
                <p><strong>Tổng tiền cần thanh toán:</strong>
                    <span style="color:#e60073; font-size:18px;">
                        <%= String.format("%,.0f", total) %> đ
                    </span>
                </p>

                <label><strong>Chọn phương thức thanh toán:</strong></label><br><br>

                <label style="display:flex; align-items:center; gap:10px;">
                    <input type="radio" name="paymentMethod" value="VNPAY" required>
                    <img src="https://sandbox.vnpayment.vn/paymentv2/images/icons/logo.svg"
                         alt="VNPAY" style="height:24px;"> Thanh toán qua VNPAY
                </label>

                <label style="display:flex; align-items:center; gap:10px; margin-top:10px;">
                    <input type="radio" name="paymentMethod" value="COD">
                    <img src="https://cdn-icons-png.flaticon.com/512/2920/2920290.png"
                         alt="COD" style="height:24px;"> Thanh toán khi nhận hàng (COD)
                </label>

                <input type="hidden" name="amount" value="<%= total %>">

                <br><br>
                <button type="submit"
                        style="background-color:#e60073; color:white; border:none; padding:10px 22px; border-radius:8px; cursor:pointer;">
                    Xác nhận thanh toán
                </button>
            </div>
        </form>

        <script>
            // ✅ Kiểm tra người dùng đã chọn phương thức thanh toán
            document.getElementById("checkoutForm").addEventListener("submit", function (e) {
                const selected = document.querySelector('input[name="paymentMethod"]:checked');
                if (!selected) {
                    alert("Vui lòng chọn phương thức thanh toán!");
                    e.preventDefault();
                }
            });
        </script>

        <% } %>
    </div>
</div>

<jsp:include page="/Trang/footer.jsp" />

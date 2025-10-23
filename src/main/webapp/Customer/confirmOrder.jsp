<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.OrderDao, model.Order, model.OrderItem, java.util.*" %>

<jsp:include page="/Trang/header.jsp" />

<div style="max-width:900px; margin:30px auto; background-color:#fff; border-radius:10px; padding:30px; box-shadow:0 4px 10px rgba(0,0,0,0.1);">
    <h3 style="color:#e60073;">🎉 Đặt hàng thành công!</h3>

    <%
        // ✅ Lấy mã đơn hàng từ URL
        String orderCode = request.getParameter("orderCode");
        if (orderCode == null || orderCode.isEmpty()) {
    %>
        <p>Không tìm thấy mã đơn hàng.</p>
        <a href="<%= request.getContextPath() %>/Customer/cart.jsp"
           style="display:inline-block; margin-top:15px; text-decoration:none; background-color:#e60073; color:white; padding:10px 18px; border-radius:6px;">
           🛒 Quay lại giỏ hàng
        </a>
    <%
        } else {
            dao.OrderDao orderDao = new dao.OrderDao();
            model.Order order = orderDao.getOrderByCode(orderCode);
            if (order == null) {
    %>
                <p>Không tìm thấy thông tin đơn hàng #<%= orderCode %>.</p>
    <%
            } else {
                List<model.OrderItem> items = orderDao.getOrderItemsByOrderId(order.getId());
    %>

                <p><strong>Mã đơn hàng:</strong> <%= order.getOrderCode() %></p>
                <p><strong>Tên khách hàng:</strong> <%= order.getCustomerName() %></p>
                <p><strong>Số điện thoại:</strong> <%= order.getCustomerPhone() %></p>
                <p><strong>Phương thức thanh toán:</strong> COD</p>
                <p><strong>Trạng thái:</strong> <%= order.getStatus() %></p>

                <table border="1" cellspacing="0" cellpadding="8" width="100%" style="margin-top:15px; border-collapse:collapse;">
                    <tr style="background-color:#ffe6f2;">
                        <th>Sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Tổng</th>
                    </tr>
                    <% for (model.OrderItem i : items) { %>
                    <tr>
                        <td><%= i.getProductName() != null ? i.getProductName() : ("#" + i.getProductId()) %></td>
                        <td><%= String.format("%,.0f", i.getUnitPrice()) %> đ</td>
                        <td><%= i.getQuantity() %></td>
                        <td><%= String.format("%,.0f", i.getTotalPrice()) %> đ</td>
                    </tr>
                    <% } %>
                </table>

                <p style="margin-top:15px; font-size:18px;">
                    <strong>Tổng tiền:</strong> 
                    <span style="color:#e60073;"><%= String.format("%,.0f", order.getGrandTotal()) %> đ</span>
                </p>

                <div style="text-align:center; margin-top:20px;">
                    <p>💖 Cảm ơn bạn đã mua sắm tại <b>FlowerShop</b>!</p>
                    <a href="<%= request.getContextPath() %>/Homepage"
                       style="text-decoration:none; background-color:#e60073; color:white; padding:10px 18px; border-radius:6px;">
                        🏠 Quay lại trang chủ
                    </a>
                </div>

    <%
            }
        }
    %>
</div>

<jsp:include page="/Trang/footer.jsp" />

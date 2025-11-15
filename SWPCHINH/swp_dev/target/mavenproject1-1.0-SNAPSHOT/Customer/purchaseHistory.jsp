<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Order, java.util.*" %>

<jsp:include page="/Trang/header.jsp" />

<div style="max-width:1100px; margin:30px auto; background-color:#fff; border-radius:10px; padding:30px; box-shadow:0 4px 10px rgba(0,0,0,0.1);">
    <h2 style="color:#e60073; text-align:center;">🛍️ Lịch sử mua hàng của bạn</h2>

    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        if (orders == null || orders.isEmpty()) {
    %>
        <p style="text-align:center; margin-top:20px; color:#888;">Bạn chưa có đơn hàng nào 💨</p>
        <div style="text-align:center; margin-top:20px;">
            <a href="<%= request.getContextPath() %>/Homepage"
               style="background-color:#e60073; color:white; padding:10px 20px; text-decoration:none; border-radius:6px;">
               🏠 Quay lại trang chủ
            </a>
        </div>
    <%
        } else {
    %>

    <table style="width:100%; border-collapse:collapse; margin-top:25px;">
        <tr style="background-color:#ffe6f2; color:#8b0057;">
            <th style="padding:12px; text-align:left;">Mã đơn hàng</th>
            <th>Ngày đặt</th>
            <th>Tổng tiền</th>
            <th>Trạng thái</th>
            <th>Thanh toán</th>
            <th></th>
        </tr>

        <% for (Order o : orders) { %>
        <tr style="border-bottom:1px solid #ffd6e8;">
            <td style="padding:10px;"><%= o.getOrderCode() %></td>
            <td style="text-align:center;"><%= (o.getPlacedAt() != null) ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(o.getPlacedAt()) : "-" %></td>
            <td style="text-align:center;"><%= String.format("%,.0f", o.getGrandTotal()) %> đ</td>
            <td style="text-align:center;"><%= o.getStatus() != null ? o.getStatus() : "Đang xử lý" %></td>
            <td style="text-align:center;"><%= o.getPaymentStatus() != null ? o.getPaymentStatus() : "Chưa thanh toán" %></td>
            <td style="text-align:center;">
                <a href="<%= request.getContextPath() %>/Customer/confirmOrder.jsp?orderCode=<%= o.getOrderCode() %>"
                   style="text-decoration:none; background-color:#e60073; color:white; padding:6px 12px; border-radius:6px;">
                   🔍 Xem chi tiết
                </a>
            </td>
        </tr>
        <% } %>
    </table>

    <% } %>
</div>

<jsp:include page="/Trang/footer.jsp" />

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Cart, model.CartItem, java.util.*, java.math.BigDecimal" %>

<jsp:include page="/Trang/header.jsp" />

<%
    Cart cart = (Cart) request.getAttribute("cart");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng của bạn</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: "Poppins", sans-serif;
                background: #fff0f5;
                margin: 0;
                padding: 0;
                color: #333;
            }

            .cart-container {
                max-width: 1100px;
                margin: 40px auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 16px rgba(255, 182, 193, 0.3);
                padding: 30px 40px;
            }

            .cart-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 2px solid #ffe6f2;
                padding-bottom: 10px;
                margin-bottom: 25px;
            }

            .cart-header h2 {
                color: #e60073;
                font-size: 24px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th {
                background-color: #ffe6f2;
                color: #8b0057;
                padding: 12px;
                font-weight: 600;
                border-bottom: 2px solid #ffb6c1;
            }

            td {
                padding: 12px;
                border-bottom: 1px solid #ffe6f2;
                text-align: center;
                vertical-align: middle;
            }

            .product-info {
                display: flex;
                align-items: center;
                gap: 15px;
                text-align: left;
            }

            .product-info img {
                width: 70px;
                height: 70px;
                border-radius: 8px;
                object-fit: cover;
                border: 1px solid #ffb6c1;
            }

            .quantity-box {
                display: inline-flex;
                align-items: center;
                border: 1px solid #ffb6c1;
                border-radius: 6px;
                overflow: hidden;
            }

            .quantity-box button {
                background-color: #ffe6f2;
                border: none;
                color: #e60073;
                font-size: 18px;
                width: 32px;
                height: 32px;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .quantity-box button:hover {
                background-color: #ffb6c1;
            }

            .quantity-value {
                width: 50px;
                border: none;
                text-align: center;
                font-size: 15px;
                height: 32px;
                outline: none;
                background: #fff;
            }

            .btn-remove {
                background: none;
                border: none;
                color: #e60073;
                font-size: 18px;
                cursor: pointer;
            }

            .btn-remove:hover {
                color: #cc005f;
                transform: scale(1.1);
            }

            .cart-summary {
                text-align: right;
                margin-top: 25px;
                font-size: 18px;
            }

            .btn-checkout {
                background-color: #e60073;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .btn-checkout:hover {
                background-color: #cc005f;
            }
        </style>
    </head>

    <body>
        <div class="cart-container">
            <div class="cart-header">
                <h2>🛍️ Giỏ hàng của bạn</h2>
                <a href="<%= request.getContextPath()%>/Homepage" style="color:#e60073;text-decoration:none;">⬅️ Tiếp tục mua sắm</a>
            </div>

            <% if (cart == null || cart.getItems().isEmpty()) { %>
            <p style="text-align:center;color:#888;">Giỏ hàng trống 💨</p>
            <% } else { %>
            <table>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Tổng</th>
                    <th></th>
                </tr>

                <% for (CartItem item : cart.getItems()) {%>
                <tr>
                    <!-- Cột sản phẩm -->
                    <td class="product-info">
                        <img src="<%= item.getProductImage() != null ? item.getProductImage() : "https://cdn-icons-png.flaticon.com/512/3081/3081559.png"%>" alt="Ảnh sản phẩm">
                        <span><%= item.getProductName()%></span>
                    </td>

                    <!-- Cột giá -->
                    <td><%= String.format("%,.0f", item.getUnitPrice())%> đ</td>

                    <!-- Cột số lượng -->
                    <td>
                        <div class="quantity-box">
                            <!-- Giảm -->
                            <form action="<%= request.getContextPath()%>/Cart" method="post">
                                <input type="hidden" name="productId" value="<%= item.getProductId()%>">
                                <input type="hidden" name="action" value="decrease">
                                <button type="submit">−</button>
                            </form>

                            <input type="text" class="quantity-value" value="<%= item.getQuantity()%>" readonly>

                            <!-- Tăng -->
                            <form action="<%= request.getContextPath()%>/Cart" method="post">
                                <input type="hidden" name="productId" value="<%= item.getProductId()%>">
                                <input type="hidden" name="action" value="increase">
                                <button type="submit">+</button>
                            </form>

                        </div>
                    </td>

                    <!-- Cột tổng -->
                    <td><%= String.format("%,.0f", item.getUnitPrice().multiply(new BigDecimal(item.getQuantity())))%> đ</td>

                    <!-- Xóa -->
                    <td>
                        <form action="<%= request.getContextPath()%>/Cart" method="post">
                            <input type="hidden" name="productId" value="<%= item.getProductId()%>">
                            <input type="hidden" name="action" value="remove">
                            <button type="submit" class="btn-remove">✖</button>
                        </form>

                    </td>
                </tr>
                <% }%>
            </table>

            <div class="cart-summary">
                <p><strong>Tổng cộng:</strong> <%= String.format("%,.0f", cart.calculateTotalAmount())%> đ</p>
                <form action="<%= request.getContextPath()%>/Checkout" method="get">
                    <button type="submit" class="btn-checkout">💳 Thanh toán ngay</button>
                </form>
            </div>
            <% }%>
        </div>

        <jsp:include page="/Trang/footer.jsp" />
    </body>
</html>

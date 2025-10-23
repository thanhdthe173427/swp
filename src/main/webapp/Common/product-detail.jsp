<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Product, model.User" %>

<%
    Product p = (Product) request.getAttribute("product");
    if (p == null) {
        out.println("<h3 style='color:red;'>Không tìm thấy sản phẩm!</h3>");
        return;
    }

    HttpSession sessionObj = request.getSession(false);
    User user = null;
    if (sessionObj != null) {
        user = (User) sessionObj.getAttribute("user");
    }

    String successMsg = (String) request.getAttribute("successMsg");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= p.getName() %> - Flower Shop</title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(to right, #fff, #fff0f5);
            margin: 0;
            padding: 0;
            color: #333;
        }

        .main-content-wrapper {
            display: flex;
            gap: 25px;
            padding: 40px 60px;
        }

        .main-content {
            flex-grow: 1;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
            padding: 30px 40px;
            border: 1px solid #ffcce0;
        }

        .success-message {
            background-color: #e8ffe8;
            color: #2b7a0b;
            border: 1px solid #b6f2b6;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-weight: 500;
            text-align: center;
            animation: fadeIn 0.4s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ===== PRODUCT DETAIL ===== */
        .product-detail {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            align-items: flex-start;
        }

        .image-section {
            flex: 0 0 320px;
            text-align: center;
        }

        .image-section img {
            width: 320px;
            height: auto;
            border-radius: 12px;
            border: 2px solid #ffd6e8;
            box-shadow: 0 3px 10px rgba(231, 84, 128, 0.2);
            transition: transform 0.3s ease;
        }

        .image-section img:hover {
            transform: scale(1.05);
        }

        .info-section {
            flex: 1;
            min-width: 300px;
        }

        .info-section h2 {
            color: #e60073;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .info-section p {
            font-size: 15px;
            margin: 6px 0;
        }

        .info-section strong {
            color: #8b0057;
        }

        .price {
            color: #e60073;
            font-weight: bold;
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .btn {
            background-color: #e60073;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: 0.3s;
            font-weight: 500;
        }

        .btn:hover {
            background-color: #cc0066;
        }

        .buy-now {
            background-color: #ff0066;
        }

        .buy-now:hover {
            background-color: #c20050;
        }

        .description-box {
            margin-top: 20px;
            border-top: 1px solid #ffd6e8;
            padding-top: 15px;
            font-size: 14px;
            line-height: 1.6;
        }

        .description-box ul {
            padding-left: 18px;
        }

        .description-box li {
            margin-bottom: 6px;
        }

    </style>
</head>

<body>
    <jsp:include page="/Trang/header.jsp" />

    <div class="main-content-wrapper">
        <jsp:include page="/Trang/lap3.jsp" />

        <main class="main-content">
            <% if (successMsg != null) { %>
            <div class="success-message"><%= successMsg %></div>
            <% } %>

            <div class="product-detail">
                <div class="image-section">
                    <img src="<%= (p.getUrl() != null && !p.getUrl().isEmpty()) 
                            ? p.getUrl() 
                            : request.getContextPath() + "/images/default-flower.jpg" %>"
                         alt="<%= p.getName() %>"
                         onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/images/default-flower.jpg';">
                </div>

                <div class="info-section">
                    <h2><%= p.getName() %></h2>
                    <p><strong>Mã sản phẩm:</strong> <%= p.getSku() %></p>
                    <p><strong>Giá:</strong> <span class="price"><%= String.format("%,.0f", p.getBasePrice()) %> đ</span></p>
                    <p><strong>Đơn vị:</strong> <%= p.getUnit() != null ? p.getUnit() : "Bó" %></p>
                    <div class="description-box">
                        <p><strong>Mô tả:</strong></p>
                        <ul>
                            <li><%= p.getDescription() != null ? p.getDescription() : "Hiện chưa có mô tả chi tiết cho sản phẩm này." %></li>
                            <li>🎁 Quý khách được tặng kèm thiệp chúc mừng miễn phí.</li>
                            <li>🚚 Giao hàng nhanh trong ngày tại TP.HCM.</li>
                            <li>💐 Hoa tươi mới 100%, cắm theo mẫu thực tế.</li>
                        </ul>
                    </div>

                    <div class="btn-group">
                        <!-- ⚡ Mua ngay -->
                        <form action="<%= request.getContextPath() %>/Cart" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="<%= p.getId() %>">
                            <input type="hidden" name="quantity" value="1">
                            <input type="hidden" name="price" value="<%= p.getBasePrice() %>">
                            <input type="hidden" name="buyNow" value="true">
                            <button type="submit" class="btn buy-now">⚡ Mua ngay</button>
                        </form>

                        <!-- 🛒 Thêm vào giỏ -->
                        <form action="<%= request.getContextPath() %>/Cart" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="<%= p.getId() %>">
                            <input type="hidden" name="quantity" value="1">
                            <input type="hidden" name="price" value="<%= p.getBasePrice() %>">
                            <button type="submit" class="btn">🛒 Thêm vào giỏ</button>
                        </form>

                        <!-- 💖 Yêu thích -->
                        <form action="<%= request.getContextPath() %>/Wishlist" method="post">
                            <input type="hidden" name="productId" value="<%= p.getId() %>">
                            <button type="submit" class="btn">💖 Yêu thích</button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/Trang/footer.jsp" />

    <script>
        // ✅ Ẩn thông báo sau 3s
        setTimeout(() => {
            const msg = document.querySelector('.success-message');
            if (msg)
                msg.style.display = 'none';
        }, 3000);
    </script>
</body>
</html>

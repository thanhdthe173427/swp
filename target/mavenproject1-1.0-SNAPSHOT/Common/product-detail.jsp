<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Product, model.User" %>

<%
    Product p = (Product) request.getAttribute("product");
    if (p == null) {
        out.println("<h3 style='color:red; text-align:center; margin-top:100px;'>Không tìm thấy sản phẩm!</h3>");
        return;
    }

    HttpSession sessionObj = request.getSession(false);
    User user = sessionObj != null ? (User) sessionObj.getAttribute("user") : null;
    String successMsg = (String) request.getAttribute("successMsg");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= p.getName() %> - FlowerShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@600&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        /* ====== RESET & BASE ====== */
        * {
            box-sizing: border-box;
        }

        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(135deg, #fff0f5, #ffffff);
            margin: 0;
            color: #333;
        }

        /* ====== MAIN WRAPPER ====== */
        .main-content-wrapper {
            display: flex;
            gap: 30px;
            padding: 40px 60px 80px;
            flex-wrap: wrap;
        }

        .main-content {
            flex-grow: 1;
            background-color: #fff;
            border-radius: 18px;
            box-shadow: 0 6px 25px rgba(255, 182, 193, 0.3);
            padding: 40px 50px;
            border: 1px solid #ffcce0;
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ====== SUCCESS MESSAGE ====== */
        .success-message {
            background: #e9ffe9;
            border: 1px solid #a5f1a5;
            color: #1b7a1b;
            padding: 10px 15px;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
            margin-bottom: 20px;
            animation: fadeIn 0.4s ease;
        }

        /* ====== PRODUCT DETAIL ====== */
        .product-detail {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
            align-items: flex-start;
        }

        .image-section {
            flex: 0 0 350px;
            text-align: center;
        }

        .image-section img {
            width: 100%;
            max-width: 350px;
            border-radius: 14px;
            border: 2px solid #ffd6e8;
            box-shadow: 0 5px 15px rgba(231, 84, 128, 0.25);
            transition: transform 0.3s ease;
        }

        .image-section img:hover {
            transform: scale(1.05);
        }

        /* ====== INFO SECTION ====== */
        .info-section {
            flex: 1;
            min-width: 300px;
        }

        .info-section h2 {
            font-size: 28px;
            color: #e60073;
            margin-bottom: 10px;
            font-family: "Dancing Script", cursive;
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
            font-size: 20px;
        }

        /* ====== BUTTON GROUP ====== */
        .btn-group {
            display: flex;
            gap: 14px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .btn {
            background: linear-gradient(90deg, #e60073, #ff66a3);
            color: white;
            padding: 10px 22px;
            border-radius: 8px;
            border: none;
            text-decoration: none;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: 0.3s;
            box-shadow: 0 3px 8px rgba(230, 0, 115, 0.2);
        }

        .btn:hover {
            background: linear-gradient(90deg, #cc0066, #ff4081);
            transform: translateY(-2px);
        }

        .buy-now {
            background: linear-gradient(90deg, #ff0066, #ff80aa);
        }

        .buy-now:hover {
            background: linear-gradient(90deg, #d40058, #ff6699);
        }

        /* ====== DESCRIPTION BOX ====== */
        .description-box {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #ffd6e8;
            line-height: 1.7;
            font-size: 15px;
        }

        .description-box p {
            color: #8b0057;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .description-box ul {
            padding-left: 18px;
            color: #555;
        }

        .description-box li {
            margin-bottom: 6px;
        }

        /* ====== RESPONSIVE ====== */
        @media (max-width: 900px) {
            .main-content-wrapper {
                flex-direction: column;
                padding: 30px 20px;
            }

            .main-content {
                padding: 25px 20px;
            }

            .product-detail {
                flex-direction: column;
                align-items: center;
            }

            .image-section img {
                max-width: 280px;
            }

            .info-section h2 {
                text-align: center;
            }

            .btn-group {
                justify-content: center;
            }
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
                <!-- IMAGE SECTION -->
                <div class="image-section">
                    <img src="<%= (p.getUrl() != null && !p.getUrl().isEmpty()) 
                            ? p.getUrl() 
                            : request.getContextPath() + "/images/default-flower.jpg" %>"
                         alt="<%= p.getName() %>"
                         onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/images/default-flower.jpg';">
                </div>

                <!-- INFO SECTION -->
                <div class="info-section">
                    <h2><%= p.getName() %></h2>
                    <p><strong>Mã sản phẩm:</strong> <%= p.getSku() %></p>
                    <p><strong>Giá:</strong> <span class="price"><%= String.format("%,.0f", p.getBasePrice()) %> đ</span></p>
                    <p><strong>Đơn vị:</strong> <%= p.getUnit() != null ? p.getUnit() : "Bó" %></p>

                    <div class="description-box">
                        <p>Mô tả sản phẩm:</p>
                        <ul>
                            <li><%= p.getDescription() != null ? p.getDescription() : "Hiện chưa có mô tả chi tiết cho sản phẩm này." %></li>
                            <li>🎁 Quý khách được tặng kèm thiệp chúc mừng miễn phí.</li>
                            <li>🚚 Giao hàng nhanh trong ngày tại TP.HCM.</li>
                            <li>💐 Hoa tươi 100%, cắm theo mẫu thực tế.</li>
                        </ul>
                    </div>

                    <!-- BUTTONS -->
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
        // Ẩn thông báo sau 3s
        setTimeout(() => {
            const msg = document.querySelector('.success-message');
            if (msg) msg.style.display = 'none';
        }, 3000);
    </script>

</body>
</html>

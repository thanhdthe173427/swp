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
        <title><%= p.getName()%> - Flower Shop</title>
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
        </style>
    </head>

    <body>
        <jsp:include page="/Trang/header.jsp" />

        <div class="main-content-wrapper">
            <jsp:include page="/Trang/lap3.jsp" />

            <main class="main-content">
                <% if (successMsg != null) {%>
                <div class="success-message"><%= successMsg%></div>
                <% }%>

                <div class="product-detail">
                    <div class="image-section">
                        <img src="<%= p.getUrl() != null ? p.getUrl() : "img/default.jpg"%>" alt="<%= p.getName()%>">
                    </div>

                    <div class="info-section">
                        <h2><%= p.getName()%></h2>
                        <p><strong>Mã sản phẩm:</strong> <%= p.getSku()%></p>
                        <p><strong>Giá:</strong> <%= String.format("%,.0f", p.getBasePrice())%> đ / <%= p.getUnit()%></p>
                        <p><strong>Mô tả:</strong> <%= p.getDescription()%></p>

                        <div class="btn-group">
                            <!-- ⚡ Mua ngay -->
                            <form action="<%= request.getContextPath()%>/Cart" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="<%= p.getId()%>">
                                <input type="hidden" name="quantity" value="1">
                                <input type="hidden" name="price" value="<%= p.getBasePrice()%>">
                                <input type="hidden" name="buyNow" value="true">
                                <button type="submit" class="btn buy-now">⚡ Mua ngay</button>
                            </form>

                            <!-- 🛒 Thêm vào giỏ -->
                            <form action="<%= request.getContextPath()%>/Cart" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="<%= p.getId()%>">
                                <input type="hidden" name="quantity" value="1">
                                <input type="hidden" name="price" value="<%= p.getBasePrice()%>">
                                <button type="submit" class="btn">🛒 Thêm vào giỏ</button>
                            </form>

                            <!-- 💖 Yêu thích -->
                            <form action="<%= request.getContextPath()%>/Wishlist" method="post">
                                <input type="hidden" name="productId" value="<%= p.getId()%>">
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

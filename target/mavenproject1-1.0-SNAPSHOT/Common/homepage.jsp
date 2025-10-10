<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Flower Shop - Trang Chủ" %></title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* ===== HEADER ===== */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ffb6c1;
            padding: 10px 60px;
            box-shadow: 0 2px 8px rgba(231, 84, 128, 0.4);
            font-family: "Poppins", sans-serif;
            border-radius: 0 0 10px 10px;
            margin-bottom: 5px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #8b0057;
        }
        .logo span {
            font-family: "Dancing Script", cursive;
            font-size: 26px;
            margin-left: 5px;
        }

        .menu {
            list-style: none;
            display: flex;
            flex: 1;
            justify-content: center;
            gap: 25px;
            margin: 0;
            padding: 0;
        }
        .menu a {
            text-decoration: none;
            color: #4b0057;
            font-size: 15px;
            font-weight: 500;
            transition: 0.3s;
            padding: 8px 12px;
            border-radius: 6px;
        }
        .menu a:hover {
            background-color: #ff99aa;
            color: #8b0057;
        }

        /* AUTH BUTTONS */
        .auth-buttons {
            display: flex;
            gap: 12px;
        }
        .auth-buttons a {
            text-decoration: none;
            background-color: #e60073;
            color: white;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: 0.3s;
        }
        .auth-buttons a:hover {
            background-color: #cc0066;
            transform: translateY(-1px);
        }

        .divider {
            border: none;
            border-top: 2px solid #e75480;
            margin: 0;
        }

        /* ===== SUBMENU ===== */
        .submenu {
            background-color: #fce4ec;
            padding: 10px 60px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(231, 84, 128, 0.2);
            border-radius: 0 0 8px 8px;
            margin-bottom: 25px;
        }
        .submenu ul {
            list-style: none;
            display: flex;
            justify-content: center;
            gap: 30px;
            padding: 0;
            margin: 0;
        }
        .submenu a {
            text-decoration: none;
            color: #8b0057;
            font-weight: 500;
            font-size: 14px;
            padding: 5px 10px;
            border-radius: 5px;
            transition: 0.3s;
        }
        .submenu a:hover {
            background-color: #ffcfe2;
            color: #e60073;
        }

        /* ===== MAIN ===== */
        .main-content-wrapper {
            display: flex;
            gap: 25px;
            padding: 0 60px 40px 60px;
        }
        .sidebar {
            width: 250px;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
            padding: 25px 0;
            border: 1px solid #ffcce0;
        }
        .sidebar h3 {
            color: #e60073;
            font-size: 18px;
            padding: 0 25px;
            border-bottom: 1px solid #ffe6f2;
            padding-bottom: 10px;
        }
        .sidebar li a {
            display: block;
            padding: 12px 25px;
            text-decoration: none;
            color: #555;
            font-size: 14px;
            transition: 0.3s;
        }
        .sidebar li a:hover {
            background-color: #fff0f5;
            color: #e60073;
            border-left: 3px solid #e60073;
        }

        .main-content {
            flex-grow: 1;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
            padding: 30px 40px;
            border: 1px solid #ffcce0;
        }

        .section-title {
            color: #e60073;
            font-family: "Dancing Script", cursive;
            font-size: 26px;
            margin-bottom: 15px;
            text-align: center;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .product {
            border: 1px solid #ffe6f2;
            border-radius: 10px;
            padding: 10px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(231, 84, 128, 0.1);
            transition: 0.2s;
        }
        .product:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(231, 84, 128, 0.3);
        }
        .product img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-radius: 10px;
        }
        .product h4 {
            font-size: 15px;
            color: #8b0057;
            margin: 10px 0 5px;
        }
        .price {
            color: #e60073;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .buy-btn {
            background-color: #e60073;
            color: white;
            padding: 6px 14px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
        }
        .buy-btn:hover {
            background-color: #cc0066;
        }

        /* ===== FOOTER ===== */
        .footer {
            background-color: #ffb6c1;
            color: #8b0057;
            padding: 30px 60px;
            border-radius: 10px 10px 0 0;
            box-shadow: 0 -2px 8px rgba(231, 84, 128, 0.4);
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            gap: 20px;
            font-size: 14px;
        }
        .footer-section h4 {
            color: #e60073;
            border-bottom: 1px solid #ffcce0;
            padding-bottom: 8px;
        }
        .footer-section a {
            color: #6a004a;
            text-decoration: none;
            display: block;
            margin-bottom: 8px;
        }
        .footer-section a:hover {
            color: #e60073;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<header>
    <jsp:include page="/Trang/header.jsp" />
</header>

<div class="main-content-wrapper">
    <aside class="sidebar">
        <h3>Danh mục sản phẩm</h3>
        <ul>
            <li><a href="#">Hoa bó</a></li>
            <li><a href="#">Hoa sinh nhật</a></li>
            <li><a href="#">Hoa chia buồn</a></li>
            <li><a href="#">Hoa khai trương</a></li>
            <li><a href="#">Hoa chúc mừng</a></li>
            <li><a href="#">Hoa tình yêu</a></li>
            <li><a href="#">Hoa tốt nghiệp</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <h3 class="section-title">🌸 Sản phẩm nổi bật 🌸</h3>

        <div class="product-grid">
          

            <%
                List<Product> list = (List<Product>) request.getAttribute("productList");
                if (list != null && !list.isEmpty()) {
                    for (Product p : list) {
            %>
                <div class="product">
                    <img src="<%= p.getUrl() %>" alt="<%= p.getName() %>">
                    <h4><%= p.getName() %></h4>
                    <p class="price"><%= p.getBasePrice() %> đ</p>
                    <a href="product-detail?id=<%= p.getId() %>" class="buy-btn">Xem chi tiết</a>
                </div>
            <%
                    }
                } else {
            %>
                <p>Không có sản phẩm nào để hiển thị.</p>
            <% } %>
        </div>
    </main>
</div>

<footer class="footer">
    <div class="footer-section">
        <h4>Liên hệ</h4>
        <p>Email: contact@flowershop.com</p>
        <p>Địa chỉ: 123 Đường Hoa Hồng, TP. HCM</p>
    </div>
    <div class="footer-section">
        <h4>Phản hồi</h4>
        <a href="#">Gửi phản hồi</a>
        <a href="#">Câu hỏi thường gặp</a>
    </div>
    <div class="footer-section">
        <h4>Chính sách</h4>
        <a href="#">Chính sách thanh toán</a>
        <a href="#">Chính sách vận chuyển</a>
        <a href="#">Chính sách đổi trả</a>
    </div>
    <div class="footer-section">
        <h4>Mạng xã hội</h4>
        <a href="#"><img src="https://img.icons8.com/ios-filled/20/8b0057/facebook-new.png"> Facebook</a>
        <a href="#"><img src="https://img.icons8.com/ios-filled/20/8b0057/zalo.png"> Zalo</a>
    </div>
</footer>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Flower Shop - Trang Chủ" %></title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            margin: 0;
            padding: 0;
            color: #333;
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

        /* ===== PRODUCT GRID ===== */
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
            background-color: #fff;
        }
        .product:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(231, 84, 128, 0.3);
        }

        .product img {
            width: 100%;
            height: 230px;
            object-fit: cover;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(231, 84, 128, 0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .product img:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 15px rgba(231, 84, 128, 0.3);
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
            transition: 0.3s;
        }
        .buy-btn:hover {
            background-color: #cc0066;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<jsp:include page="/Trang/header.jsp" />

<div class="main-content-wrapper">
    <jsp:include page="/Trang/lap3.jsp" />

    <main class="main-content">
        <h3 class="section-title">🌸 Sản phẩm nổi bật 🌸</h3>

        <div class="product-grid">
            <%
                List<Product> list = (List<Product>) request.getAttribute("productList");
                if (list != null && !list.isEmpty()) {
                    for (Product p : list) {
            %>
                <div class="product">
                    <img 
                        src="<%= (p.getUrl() != null && !p.getUrl().trim().isEmpty()) 
                                ? p.getUrl() 
                                : request.getContextPath() + "/images/default-flower.jpg" %>" 
                        alt="<%= p.getName() %>"
                        onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/images/default-flower.jpg';"
                    />
                    <h4><%= p.getName() %></h4>
                    <p class="price"><%= String.format("%,.0f", p.getBasePrice()) %> đ</p>
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
    <jsp:include page="/Trang/footer.jsp" />
</footer>

</body>
</html>

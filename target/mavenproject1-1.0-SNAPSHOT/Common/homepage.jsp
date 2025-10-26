<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Flower Shop - Trang Chủ" %></title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@600&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* ===== RESET ===== */
        * {
            box-sizing: border-box;
        }

        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(120deg, #fff0f5, #ffffff);
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* ===== MAIN WRAPPER ===== */
        .main-content-wrapper {
            display: flex;
            gap: 25px;
            padding: 0 60px 60px 60px;
            flex-wrap: wrap;
        }

        /* ===== SIDEBAR ===== */
        .sidebar {
            width: 250px;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(255, 182, 193, 0.3);
            padding: 25px 0;
            border: 1px solid #ffcce0;
            height: fit-content;
            position: sticky;
            top: 30px;
        }

        .sidebar h3 {
            color: #e60073;
            font-size: 18px;
            padding: 0 25px 10px;
            border-bottom: 2px solid #ffe6f2;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar li a {
            display: block;
            padding: 12px 25px;
            text-decoration: none;
            color: #555;
            font-size: 15px;
            transition: all 0.3s;
        }

        .sidebar li a:hover {
            background-color: #fff0f5;
            color: #e60073;
            border-left: 4px solid #e60073;
            font-weight: 500;
            transform: translateX(3px);
        }

        /* ===== MAIN CONTENT ===== */
        .main-content {
            flex-grow: 1;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(255, 182, 193, 0.3);
            padding: 40px 50px;
            border: 1px solid #ffcce0;
        }

        .section-title {
            color: #e60073;
            font-family: "Dancing Script", cursive;
            font-size: 34px;
            margin-bottom: 30px;
            text-align: center;
        }

        /* ===== PRODUCT GRID ===== */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
        }

        .product {
            border: 1px solid #ffe6f2;
            border-radius: 15px;
            padding: 15px;
            text-align: center;
            background-color: #fff;
            box-shadow: 0 4px 12px rgba(231, 84, 128, 0.1);
            transition: 0.3s ease-in-out;
        }

        .product:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 20px rgba(231, 84, 128, 0.25);
        }

        .product img {
            width: 100%;
            height: 230px;
            object-fit: cover;
            border-radius: 12px;
            margin-bottom: 10px;
            transition: all 0.4s ease;
        }

        .product img:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(231, 84, 128, 0.3);
        }

        .product h4 {
            font-size: 16px;
            color: #8b0057;
            margin: 10px 0 5px;
            font-weight: 600;
        }

        .price {
            color: #e60073;
            font-weight: bold;
            font-size: 15px;
            margin-bottom: 12px;
        }

        .buy-btn {
            background: linear-gradient(90deg, #e60073, #ff66a3);
            color: white;
            padding: 8px 18px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: 0.3s;
            box-shadow: 0 3px 8px rgba(230, 0, 115, 0.2);
        }

        .buy-btn:hover {
            background: linear-gradient(90deg, #cc0066, #ff4081);
            transform: translateY(-2px);
        }

        /* ===== EMPTY STATE ===== */
        .no-product {
            text-align: center;
            font-size: 16px;
            color: #777;
            margin-top: 40px;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 900px) {
            .main-content-wrapper {
                flex-direction: column;
                padding: 20px;
            }

            .sidebar {
                width: 100%;
                position: static;
            }

            .main-content {
                padding: 25px;
            }

            .section-title {
                font-size: 28px;
            }
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
                <p class="no-product">Không có sản phẩm nào để hiển thị.</p>
            <% } %>
        </div>
    </main>
</div>

<footer class="footer">
    <jsp:include page="/Trang/footer.jsp" />
</footer>

</body>
</html>

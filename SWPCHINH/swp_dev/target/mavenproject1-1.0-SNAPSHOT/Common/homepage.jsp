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
        /* ===== RESET & BASE ===== */
        * { box-sizing: border-box; }
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(120deg, #fff0f5, #ffffff);
            margin: 0; padding: 0; color: #333;
        }

        .main-content-wrapper { display: flex; gap: 25px; padding: 0 60px 60px; flex-wrap: wrap; }
        .main-content {
            flex-grow: 1; background: #fff; border-radius: 15px;
            box-shadow: 0 4px 20px rgba(255,182,193,0.3);
            padding: 40px 50px; border: 1px solid #ffcce0;
        }
        .section-title {
            color: #e60073; font-family: "Dancing Script", cursive;
            font-size: 34px; margin-bottom: 30px; text-align: center;
        }

        /* ===== PRODUCTS ===== */
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 25px; }
        .product { border: 1px solid #ffe6f2; border-radius: 15px; padding: 15px; text-align: center;
                   box-shadow: 0 4px 12px rgba(231,84,128,0.1); transition: 0.3s ease; background: #fff; }
        .product:hover { transform: translateY(-6px); box-shadow: 0 8px 20px rgba(231,84,128,0.25); }
        .product img { width: 100%; height: 230px; object-fit: cover; border-radius: 12px; margin-bottom: 10px; transition: 0.4s; }
        .product img:hover { transform: scale(1.05); box-shadow: 0 4px 12px rgba(231,84,128,0.3); }
        .product h4 { font-size: 16px; color: #8b0057; margin: 10px 0 5px; font-weight: 600; }
        .price { color: #e60073; font-weight: bold; font-size: 15px; margin-bottom: 12px; }
        .buy-btn {
            background: linear-gradient(90deg, #e60073, #ff66a3);
            color: #fff; padding: 8px 18px; border-radius: 6px;
            text-decoration: none; font-size: 14px; font-weight: 500;
            transition: 0.3s; box-shadow: 0 3px 8px rgba(230,0,115,0.2);
        }
        .buy-btn:hover { background: linear-gradient(90deg, #cc0066, #ff4081); transform: translateY(-2px); }

        /* ===== PAGINATION ===== */
        .pagination { text-align: center; margin-top: 40px; }
        .page-number {
            display: inline-block; margin: 0 6px; padding: 8px 14px; border-radius: 8px;
            background: #ffe6f2; color: #e60073; font-weight: 500; text-decoration: none;
            transition: 0.3s; box-shadow: 0 2px 6px rgba(230,0,115,0.1);
        }
        .page-number:hover { background: #ffb6c1; color: #fff; }
        .page-number.active {
            background: linear-gradient(90deg, #e60073, #ff66a3);
            color: #fff; font-weight: 600; box-shadow: 0 3px 8px rgba(230,0,115,0.3);
        }
        .page-number.nav { background: #fff0f5; color: #cc0066; font-weight: 500; padding: 8px 16px; }
        .page-number.nav:hover { background: #ffb6c1; color: white; }

        @media (max-width: 900px) {
            .main-content-wrapper { flex-direction: column; padding: 20px; }
            .main-content { padding: 25px; }
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
                    <img src="<%= (p.getUrl()!=null && !p.getUrl().trim().isEmpty())?p.getUrl():request.getContextPath()+"/images/default-flower.jpg" %>"
                         alt="<%= p.getName() %>"
                         onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/images/default-flower.jpg';" />
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

        <!-- ==== PHÂN TRANG ==== -->
        <%
            int currentPage = (request.getAttribute("currentPage") != null) ? (Integer) request.getAttribute("currentPage") : 1;
            int totalProducts = (request.getAttribute("totalProducts") != null) ? (Integer) request.getAttribute("totalProducts") : 0;
            int totalPages = (int) Math.ceil((double) totalProducts / 18);
        %>
        <div class="pagination">
            <%
                if (totalPages > 1) {
                    if (currentPage > 1) {
            %>
                <a class="page-number nav" href="Homepage?page=<%= currentPage - 1 %>">&laquo; Trang trước</a>
            <%
                    }
                    for (int i = 1; i <= totalPages; i++) {
                        if (i == currentPage) {
            %>
                <span class="page-number active"><%= i %></span>
            <%
                        } else {
            %>
                <a class="page-number" href="Homepage?page=<%= i %>"><%= i %></a>
            <%
                        }
                    }
                    if (currentPage < totalPages) {
            %>
                <a class="page-number nav" href="Homepage?page=<%= currentPage + 1 %>">Trang sau &raquo;</a>
            <%
                    }
                }
            %>
        </div>
    </main>
</div>

<footer class="footer">
    <jsp:include page="/Trang/footer.jsp" />
</footer>

</body>
</html>

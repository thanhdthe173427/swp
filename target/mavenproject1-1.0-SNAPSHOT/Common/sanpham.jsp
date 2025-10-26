<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="model.Product" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giới thiệu sản phẩm - FlowerShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            margin: 0;
            padding: 0;
            color: #333;
        }

        .section-title {
            color: #e60073;
            font-family: "Dancing Script", cursive;
            font-size: 32px;
            margin: 40px 0 10px;
            text-align: center;
        }

        .intro-text {
            text-align: justify;
            margin: 0 auto 25px;
            max-width: 850px;
            font-size: 15px;
            color: #555;
            line-height: 1.6;
        }

        .main-content-wrapper {
            display: flex;
            gap: 25px;
            padding: 0 60px 40px 60px;
        }

        .main-content {
            flex-grow: 1;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
            padding: 30px 40px;
            border: 1px solid #ffcce0;
        }

        /* === CARD GRID === */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .product-card {
            border: 1px solid #ffe6f2;
            border-radius: 12px;
            overflow: hidden;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(231, 84, 128, 0.1);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            text-decoration: none;
            color: inherit;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(231, 84, 128, 0.25);
        }

        .product-card img {
            width: 100%;
            height: 230px;
            object-fit: cover;
            display: block;
        }

        .product-info {
            padding: 12px 14px;
            text-align: center;
        }

        .product-info h4 {
            font-size: 15px;
            color: #8b0057;
            margin: 8px 0 6px;
            font-weight: 600;
        }

        .price {
            color: #e60073;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .buy-btn {
            display: inline-block;
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

        .see-more {
            display: block;
            width: fit-content;
            margin: 20px auto;
            padding: 8px 20px;
            background-color: #e60073;
            color: white;
            border-radius: 6px;
            text-decoration: none;
            transition: 0.3s;
        }

        .see-more:hover {
            background-color: #cc0066;
        }
    </style>
</head>
<body>

<jsp:include page="/Trang/header.jsp" />

<div class="main-content-wrapper">
    <jsp:include page="/Trang/lap3.jsp" />

    <main class="main-content">

        <!-- 🕊 HOA CHIA BUỒN -->
        <h2 class="section-title">Hoa Chia Buồn</h2>
        <div class="intro-text">
            Hoa chia buồn là lời tiễn biệt chân thành gửi đến những người đã khuất, thể hiện sự trân trọng và sẻ chia nỗi đau với gia quyến. 
            Mỗi vòng hoa được thiết kế trang nhã, thể hiện lòng thành kính và thương nhớ sâu sắc.
        </div>
        <div class="product-grid">
            <%
                ProductDAO dao = new ProductDAO();
                List<Product> funeralList = dao.getProductsByCategory("funeral");
                if (funeralList != null && !funeralList.isEmpty()) {
                    for (Product p : funeralList) {
            %>
                <!-- Thẻ card -->
                <a href="<%= request.getContextPath() %>/product-detail?id=<%= p.getId() %>" class="product-card">
                    <img src="<%= (p.getUrl() != null && !p.getUrl().trim().isEmpty()) 
                                ? p.getUrl() 
                                : request.getContextPath() + "/images/default-flower.jpg" %>" 
                         alt="<%= p.getName() %>">
                    <div class="product-info">
                        <h4><%= p.getName() %></h4>
                        <p class="price"><%= String.format("%,.0f", p.getBasePrice()) %> đ</p>
                        <span class="buy-btn">Xem chi tiết</span>
                    </div>
                </a>
            <% } } %>
        </div>
        <a href="<%= request.getContextPath() %>/CategoryProduct?category=funeral" class="see-more">
            Xem thêm các sản phẩm Hoa Chia Buồn
        </a>

        <!-- 🎉 HOA KHAI TRƯƠNG -->
        <h2 class="section-title">Hoa Khai Trương</h2>
        <div class="intro-text">
            Ngày khai trương là cột mốc quan trọng đánh dấu khởi đầu mới. 
            Một lẵng hoa khai trương tươi tắn, sang trọng sẽ gửi gắm lời chúc may mắn, thịnh vượng và thành công đến người nhận.
        </div>
        <div class="product-grid">
            <%
                List<Product> openingList = dao.getProductsByCategory("opening");
                if (openingList != null && !openingList.isEmpty()) {
                    for (Product p : openingList) {
            %>
                <a href="<%= request.getContextPath() %>/product-detail?id=<%= p.getId() %>" class="product-card">
                    <img src="<%= p.getUrl() %>" alt="<%= p.getName() %>">
                    <div class="product-info">
                        <h4><%= p.getName() %></h4>
                        <p class="price"><%= String.format("%,.0f", p.getBasePrice()) %> đ</p>
                        <span class="buy-btn">Xem chi tiết</span>
                    </div>
                </a>
            <% } } %>
        </div>
        <a href="<%= request.getContextPath() %>/CategoryProduct?category=opening" class="see-more">
            Xem thêm các sản phẩm Hoa Khai Trương
        </a>

        <!-- 🎁 HOA CHÚC MỪNG -->
        <h2 class="section-title">Hoa Chúc Mừng</h2>
        <div class="intro-text">
            Những bó hoa chúc mừng tươi rực rỡ là biểu tượng của niềm vui và thành công. 
            Dành tặng hoa trong những dịp đặc biệt như sinh nhật, kỷ niệm hay sự kiện quan trọng là cách thể hiện tình cảm tinh tế và chân thành nhất.
        </div>
        <div class="product-grid">
            <%
                List<Product> congratsList = dao.getProductsByCategory("congrats");
                if (congratsList != null && !congratsList.isEmpty()) {
                    for (Product p : congratsList) {
            %>
                <a href="<%= request.getContextPath() %>/product-detail?id=<%= p.getId() %>" class="product-card">
                    <img src="<%= p.getUrl() %>" alt="<%= p.getName() %>">
                    <div class="product-info">
                        <h4><%= p.getName() %></h4>
                        <p class="price"><%= String.format("%,.0f", p.getBasePrice()) %> đ</p>
                        <span class="buy-btn">Xem chi tiết</span>
                    </div>
                </a>
            <% } } %>
        </div>
        <a href="<%= request.getContextPath() %>/CategoryProduct?category=congrats" class="see-more">
            Xem thêm các sản phẩm Hoa Chúc Mừng
        </a>

        <!-- 🎓 HOA TỐT NGHIỆP -->
        <h2 class="section-title">Hoa Tốt Nghiệp</h2>
        <div class="intro-text">
            Khoảnh khắc tốt nghiệp là cột mốc đáng nhớ, khép lại hành trình học tập đầy nỗ lực. 
            Một bó hoa tươi thắm sẽ thay lời chúc mừng, thể hiện niềm tự hào và lời chúc thành công trên con đường tương lai.
        </div>
        <div class="product-grid">
            <%
                List<Product> gradList = dao.getProductsByCategory("graduation");
                if (gradList != null && !gradList.isEmpty()) {
                    for (Product p : gradList) {
            %>
                <a href="<%= request.getContextPath() %>/product-detail?id=<%= p.getId() %>" class="product-card">
                    <img src="<%= p.getUrl() %>">
                    <div class="product-info">
                        <h4><%= p.getName() %></h4>
                        <p class="price"><%= String.format("%,.0f", p.getBasePrice()) %> đ</p>
                        <span class="buy-btn">Xem chi tiết</span>
                    </div>
                </a>
            <% } } %>
        </div>
        <a href="<%= request.getContextPath() %>/CategoryProduct?category=graduation" class="see-more">
            Xem thêm các sản phẩm Hoa Tốt Nghiệp
        </a>

        <!-- 💖 HOA VALENTINE -->
        <h2 class="section-title">Hoa Tặng Valentine 14/2</h2>
        <div class="intro-text">
            Ngày Valentine là dịp để bày tỏ tình yêu ngọt ngào. 
            Một bó hoa hồng rực rỡ hay bó tulip tinh tế sẽ giúp bạn gửi gắm trọn vẹn lời yêu thương đến người đặc biệt trong cuộc đời.
        </div>
        <div class="product-grid">
            <%
                List<Product> valList = dao.getProductsByCategory("love");
                if (valList != null && !valList.isEmpty()) {
                    for (Product p : valList) {
            %>
                <a href="<%= request.getContextPath() %>/product-detail?id=<%= p.getId() %>" class="product-card">
                    <img src="<%= p.getUrl() %>">
                    <div class="product-info">
                        <h4><%= p.getName() %></h4>
                        <p class="price"><%= String.format("%,.0f", p.getBasePrice()) %> đ</p>
                        <span class="buy-btn">Xem chi tiết</span>
                    </div>
                </a>
            <% } } %>
        </div>
        <a href="<%= request.getContextPath() %>/CategoryProduct?category=love" class="see-more">
            Xem thêm các sản phẩm Hoa Valentine
        </a>

    </main>
</div>

<footer>
    <jsp:include page="/Trang/footer.jsp" />
</footer>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Product" %>

<%
    Product p = (Product) request.getAttribute("product");
    if (p == null) {
        out.println("<h3 style='color:red;'>Không tìm thấy sản phẩm!</h3>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= p.getName() %> - Flower Shop</title>
    <link rel="stylesheet" href="../styles.css">
</head>
<body>


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
        <div class="product-detail" style="display: flex; gap: 40px;">
            <div class="image-section">
                <img src="<%= p.getUrl() != null ? p.getUrl() : "img/default.jpg" %>"
                     alt="<%= p.getName() %>"
                     style="width:350px;height:350px;border-radius:12px;">
            </div>

            <div class="info-section">
                <h2><%= p.getName() %></h2>
                <p><strong>Mã sản phẩm (SKU):</strong> <%= p.getSku() %></p>
                <p><strong>Giá bán:</strong>
                    <%= String.format("%,.0f", p.getBasePrice()) %> đ / <%= p.getUnit() %>
                </p>
                <p><strong>Mô tả:</strong> <%= p.getDescription() %></p>
                <p><strong>Trạng thái:</strong>
                    <%= p.isIsActive() ? "Còn hàng" : "Ngừng kinh doanh" %>
                </p>

                <a href="cart?action=add&id=<%= p.getId() %>" class="buy-btn">🛒 Đặt mua</a>
            </div>
        </div>

        <hr>
        <h3>Bình luận</h3>
        <form action="comment" method="post">
            <textarea name="content" placeholder="Nhập bình luận của bạn..."
                      style="width:100%;height:100px;"></textarea>
            <button type="submit" class="buy-btn">Gửi bình luận</button>
        </form>
    </main>
</div>


</body>
</html>

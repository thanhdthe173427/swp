<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.WishlistItem, java.util.*, dao.ProductDAO, model.Product" %>

<jsp:include page="/Trang/header.jsp" />

<%
    List<WishlistItem> wishlist = (List<WishlistItem>) request.getAttribute("wishlist");
    ProductDAO productDao = new ProductDAO();
%>

<div class="main-content" style="padding: 40px;">
    <h2>💖 Sản phẩm yêu thích của bạn</h2>

    <% if (wishlist == null || wishlist.isEmpty()) { %>
        <p>Bạn chưa thêm sản phẩm nào vào danh sách yêu thích 🌸</p>
    <% } else { %>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:20px;">
            <% for (WishlistItem w : wishlist) {
                Product p = productDao.getProductById(w.getProductId());
                if (p != null) {
            %>
            <div style="border:1px solid #ffcce0;border-radius:10px;padding:10px;text-align:center;">
                <img src="<%= p.getUrl() %>" alt="<%= p.getName() %>"
                     style="width:100%;height:200px;object-fit:cover;border-radius:8px;">
                <h4 style="color:#8b0057;"><%= p.getName() %></h4>
                <p style="color:#e60073;font-weight:bold;">
                    <%= p.getBasePrice() %> đ
                </p>
                <form action="<%= request.getContextPath() %>/Wishlist" method="post">
                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                    <button type="submit" style="background:#e60073;color:white;border:none;padding:8px 16px;border-radius:6px;cursor:pointer;">
                        💔 Xóa khỏi yêu thích
                    </button>
                </form>
            </div>
            <% } } %>
        </div>
    <% } %>
</div>

<jsp:include page="/Trang/footer.jsp" />

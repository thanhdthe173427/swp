<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Product, java.util.*" %>

<jsp:include page="/Trang/header.jsp" />

<div style="max-width:1200px; margin:30px auto; padding:20px;">
    <h2 style="color:#e60073; text-align:center;">
        🌸 Gợi ý hoa cho dịp 
        <%= request.getAttribute("occasion") %>
    </h2>

    <%
        List<Product> products = (List<Product>) request.getAttribute("products");
        if (products == null || products.isEmpty()) {
    %>
        <p style="text-align:center; margin-top:20px;">Chưa có sản phẩm phù hợp dịp này 💐</p>
    <%
        } else {
    %>
    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(240px,1fr)); gap:20px; margin-top:30px;">
        <% for (Product p : products) { %>
            <div style="border:1px solid #ffd1dc; border-radius:10px; overflow:hidden; background:#fff;">
                <img src="<%= p.getUrl() %>" alt="<%= p.getName() %>"
                     style="width:100%; height:220px; object-fit:cover;">
                <div style="padding:15px;">
                    <h4 style="color:#8b0057;"><%= p.getName() %></h4>
                    <p style="color:#e60073; font-weight:600;"><%= String.format("%,.0f", p.getBasePrice()) %> đ</p>
                    <p style="color:#666; font-size:14px;"><%= p.getDescription() %></p>
                </div>
            </div>
        <% } %>
    </div>
    <% } %>
</div>

<jsp:include page="/Trang/footer.jsp" />

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
%>

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
        <h4>Tài khoản</h4>
        <% if (user == null) { %>
            <!-- ❌ Chưa đăng nhập -->
            <a href="<%= request.getContextPath() %>/login.jsp">Đăng nhập</a>
            <a href="<%= request.getContextPath() %>/register.jsp">Đăng ký</a>
        <% } else { %>
            <!-- ✅ Đã đăng nhập -->
            <div style="display:flex; align-items:center; gap:10px;">
                <img src="<%= user.getAvatar() != null ? user.getAvatar() : "https://img.icons8.com/ios-filled/40/8b0057/user.png" %>"
                     alt="Avatar"
                     style="width:40px; height:40px; border-radius:50%; border:2px solid #e60073;">
                <span style="font-weight:bold; color:#8b0057;"><%= user.getUsername() %></span>
                <a href="<%= request.getContextPath() %>/Logout"
                   style="background-color:#e60073; color:white; padding:6px 14px; border-radius:6px; text-decoration:none;">
                   Đăng xuất
                </a>
            </div>
        <% } %>
    </div>

    <div class="footer-section">
        <h4>Mạng xã hội</h4>
        <a href="#"><img src="https://img.icons8.com/ios-filled/20/8b0057/facebook-new.png"> Facebook</a>
        <a href="#"><img src="https://img.icons8.com/ios-filled/20/8b0057/zalo.png"> Zalo</a>
    </div>
</footer>

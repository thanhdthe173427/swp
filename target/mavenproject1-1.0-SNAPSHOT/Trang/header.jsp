<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
%>

<header>
    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/Homepage" class="logo" style="text-decoration: none;">
            🌸 <span>FlowerShop</span>
        </a>
         

        <ul class="menu">
            <li><a href="<%= request.getContextPath() %>/Homepage">Trang chủ</a></li>
            <li><a href="#">Giới thiệu</a></li>
            <li><a href="#">Sản phẩm</a></li>
            <li><a href="#">Tin tức</a></li>
            <li><a href="#">Liên hệ</a></li>
        </ul>

        <div class="auth-buttons">
            <% if (user == null) { %>
                <!-- ❌ Chưa đăng nhập -->
                <a href="<%= request.getContextPath() %>/Common/login.jsp">Đăng nhập</a>
                <a href="<%= request.getContextPath() %>/register.jsp">Đăng ký</a>
            <% } else { %>
                <!-- ✅ Đã đăng nhập -->
                <div style="display: flex; align-items: center; gap: 10px;">
                    <img src="<%= (user.getAvatar() != null && !user.getAvatar().isEmpty()) 
                                ? user.getAvatar() 
                                : "https://img.icons8.com/ios-filled/40/8b0057/user.png" %>"
                         alt="Avatar"
                         style="width: 36px; height: 36px; border-radius: 50%; border: 2px solid #e60073;">

                    <span style="color:#8b0057; font-weight:600;">
                        <%= (user.getFullName() != null && !user.getFullName().isEmpty()) 
                            ? user.getFullName() 
                            : user.getEmail() %>
                    </span>

                    <a href="<%= request.getContextPath() %>/Logout"
                       style="background-color:#e60073; color:white; padding:6px 14px; border-radius:6px; text-decoration:none;">
                       Đăng xuất
                    </a>
                </div>
            <% } %>
        </div>
    </nav>

    <hr class="divider">

    <div class="submenu">
        <ul>
            <li><a href="#">Hoa bó</a></li>
            <li><a href="#">Hoa sinh nhật</a></li>
            <li><a href="#">Hoa chia buồn</a></li>
            <li><a href="#">Hoa khai trương</a></li>
            <li><a href="#">Hoa chúc mừng</a></li>
            <li><a href="#">Hoa tình yêu</a></li>
            <li><a href="#">Hoa tốt nghiệp</a></li>
        </ul>
    </div>
</header>

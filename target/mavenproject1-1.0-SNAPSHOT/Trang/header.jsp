<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User user = (sessionObj != null) ? (User) sessionObj.getAttribute("user") : null;

    String avatarUrl = "https://img.icons8.com/ios-filled/40/8b0057/user.png";
    if (user != null && user.getAvatar() != null && !user.getAvatar().trim().isEmpty()) {
        avatarUrl = user.getAvatar();
    }
%>

<style>
    /* ===== HEADER STYLE ===== */
    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #ffb6c1;
        padding: 10px 60px;
        box-shadow: 0 2px 8px rgba(231, 84, 128, 0.4);
        font-family: "Poppins", sans-serif;
        border-radius: 0 0 10px 10px;
    }

    .logo {
        font-size: 24px;
        font-weight: bold;
        color: #8b0057;
        text-decoration: none;
    }

    .logo span {
        font-family: "Dancing Script", cursive;
        font-size: 26px;
        margin-left: 5px;
    }

    .menu {
        list-style: none;
        display: flex;
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

    .auth-buttons {
        display: flex;
        align-items: center;
        gap: 12px;
        position: relative;
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

    .avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        border: 2px solid #e60073;
        cursor: pointer;
        object-fit: cover;
    }

    /* ===== DROPDOWN MENU ===== */
    .avatar-menu {
        position: absolute;
        top: 60px;
        right: 70px;
        background-color: #fff;
        border: 1px solid #ffcce0;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(231, 84, 128, 0.25);
        display: none;
        flex-direction: column;
        min-width: 200px;
        z-index: 999;
        overflow: hidden;
    }

    .avatar-menu a {
        display: block;
        padding: 10px 15px;
        text-decoration: none;
        color: #8b0057;
        font-size: 14px;
        transition: 0.2s;
    }

    .avatar-menu a:hover {
        background-color: #ffe6f2;
        color: #e60073;
    }

    .divider {
        border: none;
        border-top: 2px solid #e75480;
        margin: 0;
    }

    .submenu {
        background-color: #fce4ec;
        padding: 10px 60px;
        text-align: center;
        box-shadow: 0 2px 5px rgba(231, 84, 128, 0.2);
        border-radius: 0 0 8px 8px;
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
</style>

<header>
    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/Homepage" class="logo">
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
                <a href="<%= request.getContextPath() %>/Common/login.jsp">Đăng nhập</a>
                <a href="<%= request.getContextPath() %>/Common/register.jsp">Đăng ký</a>
            <% } else { %>
                <img id="avatarBtn" src="<%= avatarUrl %>" alt="Avatar" class="avatar">

                <!-- Menu Dropdown -->
                <div id="avatarMenu" class="avatar-menu">
                    <a href="<%= request.getContextPath() %>/ViewProfile">👤 Thông tin cá nhân</a>
                    <a href="<%= request.getContextPath() %>/Wishlist">💖 Sản phẩm yêu thích</a>
                    <a href="<%= request.getContextPath() %>/Cart">🛒 Giỏ hàng</a>
                    <a href="<%= request.getContextPath() %>/ChangePassword">🔒 Đổi mật khẩu</a>
                </div>

                <span style="color:#8b0057; font-weight:600;">
                    <%= (user.getFullName() != null && !user.getFullName().isEmpty())
                            ? user.getFullName()
                            : user.getEmail() %>
                </span>

                <!-- ✅ Đăng xuất ra ngoài -->
                <a href="<%= request.getContextPath() %>/Logout"
                   style="background-color:#e60073; color:white; padding:6px 14px; border-radius:6px; text-decoration:none;">
                    🚪 Đăng xuất
                </a>
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

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const avatarBtn = document.getElementById("avatarBtn");
        const avatarMenu = document.getElementById("avatarMenu");

        if (avatarBtn) {
            avatarBtn.addEventListener("click", function (e) {
                e.stopPropagation();
                avatarMenu.style.display =
                    avatarMenu.style.display === "flex" ? "none" : "flex";
            });
        }

        document.addEventListener("click", function (e) {
            if (avatarMenu && !avatarMenu.contains(e.target) && e.target !== avatarBtn) {
                avatarMenu.style.display = "none";
            }
        });
    });
</script>

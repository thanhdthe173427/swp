<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản - FlowerShop</title>
    <style>
        /* ===== TOÀN TRANG ===== */
        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            margin: 0;
            padding: 0;
        }

        /* ===== THANH MENU ===== */
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
        }

        .logo span {
            font-family: "Dancing Script", cursive;
            font-size: 26px;
            margin-left: 5px;
        }

        .menu {
            list-style: none;
            display: flex;
            flex: 1;
            justify-content: center;
            gap: 20px;
            margin: 0;
            padding: 0;
        }

        .menu li {
            display: inline;
        }

        .menu a {
            text-decoration: none;
            color: #4b0057;
            font-size: 15px;
            transition: 0.3s;
            padding: 5px 8px;
            border-radius: 6px;
        }

        .menu a:hover {
            background-color: #ff99aa;
            color: #8b0057;
        }

        /* ===== NÚT ĐĂNG NHẬP / ĐĂNG KÝ ===== */
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
            transition: 0.3s;
            font-weight: 500;
        }

        .auth-buttons a:hover {
            background-color: #cc0066;
            transform: translateY(-1px);
        }

        .divider {
            border: none;
            border-top: 2px solid #e75480;
            margin: 0;
            width: 100%;
        }

        /* ===== FORM ĐĂNG KÝ ===== */
        .register-container {
            background: white;
            padding: 40px 50px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(231, 84, 128, 0.2);
            width: 400px;
            text-align: center;
            border: 1px solid #ffcce0;
            margin: 70px auto;
        }

        h2 {
            color: #e60073;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 700;
        }

        label {
            display: block;
            text-align: left;
            color: #666;
            margin-bottom: 5px;
            font-size: 14px;
            font-weight: 500;
        }

        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 18px;
            border: 1px solid #ffcce0;
            border-radius: 10px;
            outline: none;
            transition: 0.3s;
            font-size: 15px;
            box-sizing: border-box;
        }

        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="email"]:focus {
            border-color: #e60073;
            box-shadow: 0 0 8px rgba(230, 0, 115, 0.25);
        }

        input[type="submit"] {
            background-color: #e60073;
            color: white;
            border: none;
            padding: 14px 0;
            width: 100%;
            border-radius: 10px;
            font-size: 17px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s, transform 0.1s;
            margin-top: 10px;
        }

        input[type="submit"]:hover {
            background-color: #cc0066;
            transform: translateY(-1px);
        }

        .back-link {
            display: block;
            margin-top: 25px;
            color: #e60073;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
        }

        .back-link:hover {
            text-decoration: underline;
            color: #cc0066;
        }
    </style>
</head>
<body>

    <!-- 🌸 THANH MENU -->
    <header>
        <nav class="navbar">
            <div class="logo">
                🌸 <span>FlowerShop</span>
            </div>

            <ul class="menu">
                <li><a href="#">Giới thiệu</a></li>
                <li><a href="#">Sản phẩm</a></li>
                <li><a href="#">Tin tức</a></li>
                <li><a href="#">Video</a></li>
                <li><a href="#">Liên hệ</a></li>
                <li><a href="#">Bản đồ</a></li>
                <li><a href="#">Giỏ hàng</a></li>
                <li><a href="#">SĐT</a></li>
            </ul>

            <!-- 🌼 Đăng nhập / Đăng ký -->
            <div class="auth-buttons">
                <a href="login.jsp">Đăng nhập</a>
                <a href="register.jsp">Đăng ký</a>
            </div>
        </nav>
        <hr class="divider">
    </header>

    <!-- 🌷 KHUNG FORM ĐĂNG KÝ -->
    <div class="register-container">
        <h2>Đăng ký tài khoản</h2>
        <form action="${pageContext.request.contextPath}/register" method="post">
            <label>Email:</label>
            <input type="email" name="email" required>

            <label>Tên đăng nhập:</label>
            <input type="text" name="username" required>

            <label>Mật khẩu:</label>
            <input type="password" name="password" required>

            <label>Họ và tên:</label>
            <input type="text" name="fullname">

            <label>Số điện thoại:</label>
            <input type="text" name="phone">

            <label>Địa chỉ:</label>
            <input type="text" name="address">

            <input type="submit" value="Đăng ký">
        </form>

        <a href="homepage.jsp" class="back-link">← Quay lại trang chủ</a>

    </div>

</body>
</html>

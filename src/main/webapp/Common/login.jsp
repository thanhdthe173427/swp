<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - FlowerShop</title>
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: "Poppins", sans-serif;
                background: linear-gradient(to right, #ffe6f2, #fff);
                min-height: 100vh;
            }

            /* ===== THANH MENU ===== */
            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #ffb6c1;
                padding: 10px 60px;
                box-shadow: 0 2px 8px rgba(231, 84, 128, 0.4);
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
                justify-content: center;
                flex: 1;
                gap: 25px;
            }

            .menu li a {
                text-decoration: none;
                color: #4b0057;
                font-weight: 500;
                font-size: 15px;
                padding: 6px 10px;
                border-radius: 6px;
                transition: 0.3s;
            }

            .menu li a:hover {
                background-color: #ff99aa;
                color: #8b0057;
            }

            .auth-buttons {
                display: flex;
                gap: 10px;
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

            /* ===== FORM ĐĂNG NHẬP ===== */
            .login-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 8px 30px rgba(231, 84, 128, 0.25);
                width: 380px;
                margin: 80px auto;
                overflow: hidden;
                border: 1px solid #ffcce0;
                animation: fadeIn 0.6s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .login-header {
                background-color: #ffb6c1;
                padding: 25px 0;
                text-align: center;
                color: #8b0057;
                border-bottom: 1px solid #ffcce0;
            }

            .login-header h1 {
                font-size: 26px;
                margin: 0;
                font-family: "Dancing Script", cursive;
            }

            .login-body {
                padding: 30px 40px;
            }

            .form-group {
                margin-bottom: 18px;
                text-align: left;
            }

            label {
                display: block;
                color: #333;
                font-weight: 500;
                font-size: 14px;
                margin-bottom: 6px;
            }

            input[type="text"], input[type="password"] {
                width: 100%;
                padding: 12px;
                border: 1px solid #ffcce0;
                border-radius: 10px;
                font-size: 15px;
                transition: border-color 0.3s, box-shadow 0.3s;
            }

            input:focus {
                border-color: #e60073;
                box-shadow: 0 0 8px rgba(230, 0, 115, 0.25);
                outline: none;
            }

            .form-options {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                font-size: 14px;
            }

            .form-options a {
                color: #e60073;
                text-decoration: none;
                font-weight: 500;
            }

            .form-options a:hover {
                text-decoration: underline;
            }

            .btn-login {
                width: 100%;
                padding: 14px;
                background-color: #e60073;
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: 0.3s;
            }

            .btn-login:hover {
                background-color: #cc0066;
                transform: translateY(-2px);
            }

            .divider-text {
                text-align: center;
                margin: 20px 0;
                color: #999;
                font-size: 14px;
            }

            .register-link {
                text-align: center;
                margin-top: 10px;
                font-size: 15px;
                color: #666;
            }

            .register-link a {
                color: #e60073;
                text-decoration: none;
                font-weight: 600;
            }

            .register-link a:hover {
                text-decoration: underline;
            }

            .back-home {
                text-align: center;
                margin-top: 15px;
            }

            .back-home a {
                color: #e60073;
                text-decoration: none;
                font-size: 14px;
            }

            .back-home a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <jsp:include page="/Trang/header.jsp" />

        <!-- 🌷 FORM ĐĂNG NHẬP -->
        <div class="login-container">
            <div class="login-header">
                <h1>Đăng Nhập</h1>
            </div>

            <div class="login-body">
                <form action="<%= request.getContextPath()%>/login" method="post">

                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) {%>
                    <p style="color:red; text-align:center; margin-bottom:10px;"><%= error%></p>
                    <% }%>

                    <div class="form-group">
                        <label for="username">Tên đăng nhập hoặc Email</label>
                        <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập hoặc email" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    </div>

                    <div class="form-options">
                        <label><input type="checkbox" name="remember"> Ghi nhớ đăng nhập</label>
                        <a href="forgot_password.jsp">Quên mật khẩu?</a>
                    </div>

                    <button type="submit" class="btn-login">Đăng Nhập</button>
                </form>

                <div class="divider-text" style="pointer-events: none; user-select: none;">HOẶC</div>


                <div class="register-link">
                    Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
                </div>

                <div class="back-home">
                    <a href="homepage.jsp">← Quay lại trang chủ</a>
                </div>
            </div>
        </div>

    </body>
</html>

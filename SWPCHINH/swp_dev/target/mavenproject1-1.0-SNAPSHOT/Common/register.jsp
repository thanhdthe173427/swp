<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản - FlowerShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@600&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        /* ===== RESET ===== */
        * {
            box-sizing: border-box;
        }

        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(135deg, #fff0f5, #ffffff);
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* ===== FORM CONTAINER ===== */
        .register-container {
            background: #fff;
            width: 420px;
            margin: 100px auto 80px;
            padding: 45px 50px 50px;
            border-radius: 18px;
            box-shadow: 0 6px 25px rgba(230, 0, 115, 0.25);
            border: 1px solid #ffcce0;
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            color: #e60073;
            font-family: "Dancing Script", cursive;
            font-size: 34px;
            text-align: center;
            margin-bottom: 30px;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        label {
            font-weight: 500;
            font-size: 14px;
            color: #555;
            margin-bottom: 5px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            border-radius: 10px;
            border: 1px solid #ffcce0;
            font-size: 15px;
            transition: 0.3s;
        }

        input:focus {
            border-color: #e60073;
            box-shadow: 0 0 8px rgba(230, 0, 115, 0.25);
            outline: none;
        }

        /* ===== BUTTON ===== */
        input[type="submit"] {
            background: linear-gradient(90deg, #e60073, #ff66a3);
            border: none;
            color: white;
            padding: 13px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 10px;
            margin-top: 10px;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 4px 10px rgba(230, 0, 115, 0.2);
        }

        input[type="submit"]:hover {
            background: linear-gradient(90deg, #cc0066, #ff4081);
            transform: translateY(-2px);
        }

        /* ===== BACK LINK ===== */
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #e60073;
            font-size: 15px;
            text-decoration: none;
            transition: 0.3s;
        }

        .back-link:hover {
            color: #cc0066;
            text-decoration: underline;
        }

        /* ===== FOOTER DECOR ===== */
        .register-footer {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #666;
        }

        .register-footer a {
            color: #e60073;
            font-weight: 600;
            text-decoration: none;
        }

        .register-footer a:hover {
            text-decoration: underline;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 500px) {
            .register-container {
                width: 90%;
                margin: 60px auto;
                padding: 30px;
            }

            h2 {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>

    <jsp:include page="/Trang/header.jsp" />

    <!-- 🌸 FORM ĐĂNG KÝ -->
    <div class="register-container">
        <h2>Đăng ký tài khoản</h2>

        <% if (request.getAttribute("error") != null) { %>
            <p style="color:#e60073; background:#fff0f5; padding:10px; border-radius:8px; text-align:center;">
                <%= request.getAttribute("error") %>
            </p>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <p style="color:#2b7a0b; background:#e8ffe8; padding:10px; border-radius:8px; text-align:center;">
                <%= request.getAttribute("success") %>
            </p>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <label>Email</label>
            <input type="email" name="email" placeholder="Nhập email của bạn" required>

            <label>Tên đăng nhập</label>
            <input type="text" name="username" placeholder="Nhập tên đăng nhập" required>

            <label>Mật khẩu</label>
            <input type="password" name="password" placeholder="Nhập mật khẩu" required>

            <label>Họ và tên</label>
            <input type="text" name="fullname" placeholder="Nguyễn Văn A">

            <label>Số điện thoại</label>
            <input type="text" name="phone" placeholder="090x xxx xxx">

            <label>Địa chỉ</label>
            <input type="text" name="address" placeholder="Số nhà, đường, quận, thành phố">

            <input type="submit" value="Đăng ký ngay">
        </form>

        <div class="register-footer">
            Đã có tài khoản? <a href="login.jsp">Đăng nhập</a>
        </div>

        <a href="homepage.jsp" class="back-link">← Quay lại trang chủ</a>
    </div>

    <jsp:include page="/Trang/footer.jsp" />
</body>
</html>

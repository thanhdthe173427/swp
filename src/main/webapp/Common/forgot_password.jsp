<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../Trang/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - FlowerShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&family=Dancing+Script:wght@600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(135deg, #fff0f5, #ffffff);
            margin: 0;
            padding: 0;
        }

        .forgot-container {
            max-width: 450px;
            margin: 80px auto 100px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 6px 25px rgba(230, 0, 115, 0.25);
            padding: 50px 40px;
            text-align: center;
            transition: 0.3s;
        }

        .forgot-container:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(230, 0, 115, 0.3);
        }

        h2 {
            font-family: "Dancing Script", cursive;
            color: #e60073;
            font-size: 32px;
            margin-bottom: 5px;
        }

        p {
            font-size: 15px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
        }

        input[type="email"] {
            width: 90%;
            padding: 12px 14px;
            border: 1px solid #ffcce0;
            border-radius: 10px;
            outline: none;
            font-size: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 0 0 transparent;
        }

        input[type="email"]:focus {
            border-color: #e60073;
            box-shadow: 0 0 6px rgba(230, 0, 115, 0.3);
        }

        button {
            width: 60%;
            padding: 12px;
            background: linear-gradient(90deg, #e60073, #ff6699);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 3px 10px rgba(230, 0, 115, 0.3);
        }

        button:hover {
            background: linear-gradient(90deg, #cc0066, #ff4081);
            transform: translateY(-2px);
        }

        .message {
            margin-top: 20px;
            color: #4b004b;
            font-weight: 500;
            font-size: 14px;
        }

        .error {
            color: #ff1744;
            font-weight: 600;
        }

        .back-login {
            margin-top: 25px;
        }

        .back-login a {
            color: #e60073;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            transition: 0.3s;
        }

        .back-login a:hover {
            color: #cc0066;
            text-decoration: underline;
        }

        /* ===== Responsive ===== */
        @media (max-width: 600px) {
            .forgot-container {
                margin: 40px 20px;
                padding: 40px 25px;
            }

            h2 {
                font-size: 28px;
            }

            p {
                font-size: 14px;
            }
        }
    </style>
</head>

<body>
    <div class="forgot-container">
        <h2>🔒 Quên mật khẩu</h2>
        <p>Nhập địa chỉ email bạn đã đăng ký để nhận liên kết đặt lại mật khẩu.</p>

        <form action="${pageContext.request.contextPath}/ForgotPassword" method="post">
            <input type="email" name="email" placeholder="Nhập email của bạn" required>
            <button type="submit">Gửi liên kết</button>
        </form>

        <% if (request.getAttribute("msg") != null) { %>
            <div class="message"><%= request.getAttribute("msg") %></div>
        <% } else if (request.getAttribute("error") != null) { %>
            <div class="message error"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="back-login">
            <a href="<%= request.getContextPath() %>/Common/login.jsp">← Quay lại trang đăng nhập</a>
        </div>
    </div>

<%@ include file="../Trang/footer.jsp" %>
</body>
</html>

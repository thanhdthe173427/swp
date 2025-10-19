<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../Trang/header.jsp" %>  <%-- Gọi phần header bạn đã gửi ở trên --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - FlowerShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fffafc;
            margin: 0;
            padding: 0;
        }

        .forgot-container {
            max-width: 480px;
            margin: 60px auto;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(230, 0, 115, 0.2);
            padding: 40px;
            text-align: center;
        }

        h2 {
            color: #8b0057;
            margin-bottom: 10px;
        }

        p {
            font-size: 14px;
            color: #555;
            margin-bottom: 25px;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        input[type="email"] {
            width: 90%;
            padding: 10px;
            border: 1px solid #e60073;
            border-radius: 8px;
            outline: none;
            margin-bottom: 20px;
            font-size: 14px;
        }

        input[type="email"]:focus {
            box-shadow: 0 0 5px #e60073;
        }

        button {
            width: 50%;
            padding: 10px;
            background-color: #e60073;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background-color: #cc0066;
            transform: translateY(-2px);
        }

        .message {
            margin-top: 20px;
            color: #8b0057;
            font-weight: 500;
        }

        .error {
            color: red;
        }

        .back-login {
            margin-top: 15px;
        }

        .back-login a {
            text-decoration: none;
            color: #e60073;
        }

        .back-login a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
<div class="forgot-container">
    <h2>Quên mật khẩu 🔒</h2>
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
        <a href="/login.jsp">← Quay lại trang đăng nhập</a>
    </div>
</div>
</body>
</html>

<%@ include file="../Trang/footer.jsp" %>  <%-- Gọi phần footer bạn đã gửi ở trên --%>

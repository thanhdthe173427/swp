<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User user = (sessionObj != null) ? (User) sessionObj.getAttribute("user") : null;
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #fff0f5;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 400px;
            margin: 100px auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(231, 84, 128, 0.3);
        }
        h2 {
            text-align: center;
            color: #e60073;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        label {
            font-weight: 500;
            color: #8b0057;
        }
        input[type="password"] {
            padding: 10px;
            border: 1px solid #ffcce0;
            border-radius: 6px;
            outline: none;
        }
        input[type="password"]:focus {
            border-color: #e60073;
        }
        button {
            background-color: #e60073;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover {
            background-color: #cc0066;
        }
        .message {
            text-align: center;
            font-size: 14px;
            margin-top: 10px;
        }
        .error {
            color: red;
        }
        .success {
            color: green;
        }
    </style>
</head>
<body>
    <jsp:include page="/Trang/header.jsp" />

    <div class="container">
        <h2>🔒 Đổi mật khẩu</h2>

        <form action="<%= request.getContextPath() %>/ChangePassword" method="post">
            <label>Mật khẩu hiện tại:</label>
            <input type="password" name="currentPassword" required>

            <label>Mật khẩu mới:</label>
            <input type="password" name="newPassword" required>

            <label>Xác nhận mật khẩu mới:</label>
            <input type="password" name="confirmPassword" required>

            <button type="submit">Cập nhật mật khẩu</button>

            <% if (request.getAttribute("error") != null) { %>
                <p class="message error"><%= request.getAttribute("error") %></p>
            <% } else if (request.getAttribute("success") != null) { %>
                <p class="message success"><%= request.getAttribute("success") %></p>
            <% } %>
        </form>
    </div>

    <jsp:include page="/Trang/footer.jsp" />
</body>
</html>

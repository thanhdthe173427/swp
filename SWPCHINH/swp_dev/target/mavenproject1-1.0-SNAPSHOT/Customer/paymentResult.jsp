<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Kết quả thanh toán VNPay</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; }
        .success { color: green; font-size: 20px; }
        .error { color: red; font-size: 20px; }
    </style>
</head>
<body>
    <h2>Kết quả thanh toán</h2>

    <%
        String msg = (String) request.getAttribute("message");
        if (msg != null) {
            boolean success = msg.contains("thành công");
    %>
        <p class="<%= success ? "success" : "error" %>"><%= msg %></p>
    <%
        } else {
    %>
        <p class="error">Không nhận được phản hồi từ VNPay.</p>
    <%
        }
    %>

    <a href="<%= request.getContextPath() %>/Homepage">⬅️ Quay lại trang chủ</a>

</body>
</html>

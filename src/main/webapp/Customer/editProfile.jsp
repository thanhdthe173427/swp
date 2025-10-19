<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    HttpSession sessionObj = request.getSession(false);
    User u = null;

    if (sessionObj != null) {
        u = (User) sessionObj.getAttribute("user");
    }

    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa hồ sơ</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            margin: 0;
            padding: 0;
        }
        .edit-container {
            width: 420px;
            margin: 80px auto;
            background-color: #fff;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        h2 {
            text-align: center;
            color: #e60073;
            margin-bottom: 20px;
        }
        label {
            font-weight: 500;
            color: #8b0057;
        }
        input[type="text"],
        input[type="email"],
        input[type="date"],
        input[type="file"] {
            width: 100%;
            padding: 8px;
            margin: 8px 0 15px;
            border: 1px solid #ffcce0;
            border-radius: 5px;
            font-size: 14px;
        }
        .btn {
            display: block;
            width: 100%;
            background-color: #e60073;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #cc0066;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #8b0057;
            font-weight: 500;
        }
        .preview {
            display: block;
            margin: 10px auto;
            border-radius: 50%;
            border: 2px solid #e60073;
            width: 100px;
            height: 100px;
            object-fit: cover;
        }
    </style>
</head>
<body>

<header>
    <jsp:include page="/Trang/header.jsp" />
</header>

<div class="edit-container">
    <h2>Chỉnh sửa hồ sơ</h2>

    <form action="<%= request.getContextPath() %>/EditProfile" method="post" enctype="multipart/form-data">
        <img id="preview" class="preview" 
             src="<%= (u.getAvatar() != null && !u.getAvatar().trim().isEmpty()) ? u.getAvatar() : "https://img.icons8.com/ios-filled/100/8b0057/user.png" %>" 
             alt="Avatar">

        <label>Ảnh đại diện:</label>
        <input type="file" name="avatar" accept="image/*" onchange="previewImage(event)">

        <label>Họ và tên:</label>
        <input type="text" name="fullName" value="<%= u.getFullName() %>" required>

        <label>Email:</label>
        <input type="email" name="email" value="<%= u.getEmail() %>" readonly>

        <label>Số điện thoại:</label>
        <input type="text" name="phone" value="<%= u.getPhone() != null ? u.getPhone() : "" %>">

        <label>Ngày sinh:</label>
        <input type="date" name="dob" value="<%= (u.getDob() != null) ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(u.getDob()) : "" %>">

        <button type="submit" class="btn">Lưu thay đổi</button>
    </form>

    <a href="<%= request.getContextPath() %>/ViewProfile" class="back-link">← Quay lại hồ sơ</a>
</div>

<footer class="footer">
    <jsp:include page="/Trang/footer.jsp" />
</footer>

<script>
    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function() {
            document.getElementById('preview').src = reader.result;
        }
        reader.readAsDataURL(event.target.files[0]);
    }
</script>

</body>
</html>

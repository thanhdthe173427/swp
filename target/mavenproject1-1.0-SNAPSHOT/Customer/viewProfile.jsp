<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    // ✅ Lấy user từ session
    HttpSession sessionObj = request.getSession(false); // Không tạo mới nếu chưa có
    User u = null;

    if (sessionObj != null) {
        u = (User) sessionObj.getAttribute("user");
    }

    // ✅ Nếu chưa đăng nhập -> chuyển hướng về trang đăng nhập
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/Common/login.jsp");
        return; // Dừng JSP lại
    }

    // ✅ Xử lý avatar (nếu không có thì dùng ảnh mặc định)
    String avatarUrl = "https://img.icons8.com/ios-filled/100/8b0057/user.png";
    if (u.getAvatar() != null && !u.getAvatar().trim().isEmpty()) {
        avatarUrl = u.getAvatar();
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông tin cá nhân</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            margin: 0;
            padding: 0;
        }
        .profile-container {
            width: 400px;
            margin: 80px auto;
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            text-align: center;
        }
        .profile-container img {
            width: 100px; height: 100px;
            border-radius: 50%;
            border: 2px solid #e60073;
            margin-bottom: 10px;
        }
        .profile-container h2 {
            color: #8b0057;
            margin-bottom: 5px;
        }
        .profile-container p {
            margin: 6px 0;
            color: #333;
        }
        a.btn {
            background-color: #e60073;
            color: #fff;
            padding: 8px 16px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }
        a.btn:hover {
            background-color: #8b0057;
        }
    </style>
</head>
<body>

<!-- HEADER -->
<header>
    <jsp:include page="/Trang/header.jsp" />
</header>

<!-- PROFILE CONTENT -->
<div class="profile-container">
    <img src="<%= avatarUrl %>" alt="Avatar">

    <h2><%= (u.getFullName() != null && !u.getFullName().isEmpty()) ? u.getFullName() : "Chưa cập nhật" %></h2>
    <p><strong>Email:</strong> <%= u.getEmail() %></p>
    <p><strong>Số điện thoại:</strong> <%= u.getPhone() != null ? u.getPhone() : "Chưa cập nhật" %></p>
    <p><strong>Ngày sinh:</strong> <%= u.getDob() != null ? u.getDob() : "Chưa cập nhật" %></p>
    <p><strong>Vai trò:</strong> <%= u.getRole() != null ? u.getRole() : "Người dùng" %></p>

 <form action="<%= request.getContextPath() %>/EditProfile" method="post" style="display:inline;">
    <button type="submit" class="btn">Chỉnh sửa hồ sơ</button>
</form>

</div>

<!-- FOOTER -->
<footer class="footer">
    <jsp:include page="/Trang/footer.jsp" />
</footer>

</body>
</html>

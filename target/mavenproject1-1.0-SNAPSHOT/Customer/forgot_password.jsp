<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quên Mật Khẩu - Flower Shop</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            /* ===== TOÀN TRANG (Giữ nguyên) ===== */
            body {
                font-family: "Segoe UI", sans-serif;
                /* Giữ background nhạt và mềm mại */
                background: linear-gradient(to right, #ffe6f2, #fff);
                margin: 0;
                padding: 0;
            }

            /* ===== THANH MENU (Tôi đang sử dụng Tùy chọn 1 đã thảo luận: Căn giữa các mục menu, logo bên trái) ===== */
            .navbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #ffb6c1; /* Light Pink */
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
                justify-content: center; /* CĂN GIỮA MENU */
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

            /* Gạch ngăn cách giữa navbar và phần nội dung */
            .divider {
                border: none;
                border-top: 2px solid #e75480;
                margin: 0;
                width: 100%;
            }

            /* ===== KHUNG CHÍNH (FORM QUÊN MẬT KHẨU) - ĐÃ CHỈNH SỬA ===== */
            .forgot-container {
                width: 400px;
                background: white;
                /* Bo tròn hơn */
                border-radius: 25px;
                /* Box shadow nhẹ nhàng, tinh tế */
                box-shadow: 0 8px 25px rgba(230, 0, 115, 0.15);
                padding: 40px; /* Tăng padding để rộng rãi hơn */
                text-align: center;
                margin: 80px auto;
                border: 1px solid #ffe6f2; /* Thêm viền nhạt */
            }

            h2 {
                /* Màu tiêu đề đậm hơn, lãng mạn hơn */
                color: #e60073;
                margin-bottom: 5px;
                font-size: 28px;
                font-weight: 700;
            }

            p {
                color: #777;
                font-size: 15px;
                margin-bottom: 25px;
                line-height: 1.5;
            }

            input[type="email"] {
                width: 100%;
                padding: 15px; /* Tăng padding cho dễ bấm */
                margin-bottom: 25px;
                border: 1px solid #ffcce0; /* Viền màu hồng nhạt */
                border-radius: 12px;
                font-size: 16px;
                box-sizing: border-box; /* Quan trọng để padding không làm tăng chiều rộng */
                transition: border-color 0.3s;
            }

            input[type="email"]:focus {
                border-color: #e60073; /* Viền sáng khi focus */
                outline: none;
                box-shadow: 0 0 5px rgba(230, 0, 115, 0.2);
            }

            button {
                width: 100%;
                padding: 15px; /* Tăng padding */
                /* Màu nút bấm hài hòa */
                background-color: #e60073;
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 17px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.3s, transform 0.1s;
            }

            button:hover {
                background-color: #cc0066;
                transform: translateY(-1px); /* Hiệu ứng nhấn nhẹ */
            }

            a {
                display: block;
                margin-top: 20px;
                color: #e60073;
                text-decoration: none;
                font-size: 15px;
            }

            a:hover {
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
            </nav>
            <hr class="divider">
        </header>

        <!-- 🌷 KHUNG QUÊN MẬT KHẨU -->
        <div class="forgot-container">
            <h2>Quên mật khẩu?</h2>
            <p>Nhập email của bạn để nhận liên kết đặt lại mật khẩu.</p>

            <form action="ForgotPassword" method="post">
                <input type="email" name="email" placeholder="Nhập email của bạn" required>
                <button type="submit">Gửi liên kết đặt lại</button>
            </form>

            <a href="login.jsp">← Quay lại đăng nhập</a>
        </div>

    </body>
</html>

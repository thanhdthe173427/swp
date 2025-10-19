<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Flower Shop - Trang Chủ</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* ===== TOÀN TRANG ===== */
        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* ===== THANH MENU CHÍNH (HEADER) ===== */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ffb6c1;
            padding: 10px 60px;
            box-shadow: 0 2px 8px rgba(231, 84, 128, 0.4);
            font-family: "Poppins", sans-serif;
            border-radius: 0 0 10px 10px;
            margin-bottom: 5px;
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
            gap: 25px;
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
            font-weight: 500;
            transition: 0.3s;
            padding: 8px 12px;
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

        /* ===== SUBMENU ===== */
        .submenu {
            background-color: #fce4ec;
            padding: 10px 60px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(231, 84, 128, 0.2);
            border-radius: 0 0 8px 8px;
            margin-bottom: 25px;
        }

        .submenu ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            justify-content: center;
            gap: 30px;
        }

        .submenu a {
            text-decoration: none;
            color: #8b0057;
            font-weight: 500;
            font-size: 14px;
            padding: 5px 10px;
            border-radius: 5px;
            transition: 0.3s;
        }

        .submenu a:hover {
            background-color: #ffcfe2;
            color: #e60073;
        }

        /* ===== KHU VỰC NỘI DUNG ===== */
        .main-content-wrapper {
            display: flex;
            gap: 25px;
            padding: 0 60px 40px 60px;
        }

        .sidebar {
            width: 250px;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
            padding: 25px 0;
            border: 1px solid #ffcce0;
        }

        .sidebar h3 {
            color: #e60073;
            font-size: 18px;
            margin-top: 0;
            margin-bottom: 20px;
            padding: 0 25px;
            text-align: left;
            border-bottom: 1px solid #ffe6f2;
            padding-bottom: 10px;
        }

        .sidebar li a {
            display: block;
            padding: 12px 25px;
            text-decoration: none;
            color: #555;
            font-size: 14px;
            transition: 0.3s;
        }

        .sidebar li a:hover {
            background-color: #fff0f5;
            color: #e60073;
            border-left: 3px solid #e60073;
            font-weight: 500;
        }

        .main-content {
            flex-grow: 1;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
            padding: 30px 40px;
            border: 1px solid #ffcce0;
        }

        .main-content h3 {
            color: #e60073;
            font-size: 22px;
            margin-top: 0;
            margin-bottom: 25px;
            text-align: left;
            border-bottom: 2px solid #ffcce0;
            padding-bottom: 10px;
        }

        .main-content li {
            background-color: #fcfcfc;
            border: 1px solid #ffe6f2;
            border-radius: 10px;
            padding: 15px 20px;
            text-align: left;
            box-shadow: 0 2px 8px rgba(231, 84, 128, 0.1);
            transition: 0.2s;
            cursor: pointer;
            color: #555;
            font-weight: 500;
        }

        .main-content li:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(231, 84, 128, 0.2);
            background-color: #fff0f5;
            color: #e60073;
        }

        
    </style>
</head>
<body>

<jsp:include page="/Trang/header.jsp" />

<div class="main-content-wrapper">
    <aside class="sidebar">
        <h3>Danh mục sản phẩm</h3>
        <ul>
            <li><a href="#">Hoa bó</a></li>
            <li><a href="#">Hoa sinh nhật</a></li>
            <li><a href="#">Hoa chia buồn</a></li>
            <li><a href="#">Hoa khai trương</a></li>
            <li><a href="#">Hoa chúc mừng</a></li>
            <li><a href="#">Hoa tình yêu</a></li>
            <li><a href="#">Hoa tốt nghiệp</a></li>
        </ul>
    </aside>

    <main class="main-content">
    <h3>Giới thiệu</h3>

    <section>
        <h4>1. Giới thiệu tổng quan</h4>
        <p>
            <strong>FlowerShop</strong> là cửa hàng hoa tươi uy tín tại TP Ha Noi, chuyên cung cấp các sản phẩm hoa nghệ thuật 
            phục vụ mọi dịp lễ, sự kiện và nhu cầu cá nhân. Với phương châm <em>"Trao gửi yêu thương bằng những đóa hoa tươi đẹp nhất"</em>, 
            chúng tôi luôn nỗ lực mang đến cho khách hàng những trải nghiệm tuyệt vời cả về chất lượng lẫn dịch vụ.
        </p>
        <p>
            Tại FlowerShop, mỗi bông hoa đều được tuyển chọn kỹ lưỡng từ các vườn hoa nổi tiếng ở Đà Lạt, đảm bảo tươi mới – 
            tinh tế – và mang đậm dấu ấn riêng của người tặng.
        </p>
    </section>

    <section>
        <h4>2. Lịch sử hình thành</h4>
        <p>
            FlowerShop được thành lập vào năm <strong>2018</strong> với khởi đầu là một cửa hàng nhỏ trên , Quận Phú Nhuận. 
            Nhờ sự tin yêu của khách hàng, đến nay chúng tôi đã mở rộng hệ thống với nhiều chi nhánh tại TP. Hồ Chí Minh 
            và phục vụ hàng nghìn đơn hàng online mỗi tháng.
        </p>
        <p>
            Trong suốt quá trình phát triển, FlowerShop không ngừng đổi mới, đầu tư công nghệ và cập nhật xu hướng thiết kế hoa hiện đại 
            để mang đến những sản phẩm tinh tế và phù hợp với mọi nhu cầu.
        </p>
    </section>

    <section>
        <h4>3. Sản phẩm - Dịch vụ</h4>
        <ul>
            <li>💐 Hoa bó tặng sinh nhật, kỷ niệm, lễ tình nhân...</li>
            <li>🌷 Hoa giỏ – Hoa hộp sang trọng cho dịp chúc mừng, khai trương.</li>
            <li>🌹 Hoa cưới, hoa cầm tay cô dâu, trang trí tiệc cưới.</li>
            <li>🌼 Hoa chia buồn, vòng hoa tang lễ lịch sự và tinh tế.</li>
            <li>🌸 Dịch vụ giao hoa tận nơi trong ngày – nhanh chóng & bảo đảm chất lượng.</li>
        </ul>
        <p>
            Ngoài ra, chúng tôi còn nhận thiết kế hoa theo yêu cầu riêng, phục vụ các sự kiện, hội nghị và doanh nghiệp.
        </p>
    </section>

    <section>
        <h4>4. Lợi thế cạnh tranh nổi bật</h4>
        <ul>
            <li>🌿 <strong>Hoa tươi 100%</strong> nhập mới mỗi ngày từ Đà Lạt.</li>
            <li>🎀 <strong>Đội ngũ nghệ nhân cắm hoa chuyên nghiệp</strong> với hơn 5 năm kinh nghiệm.</li>
            <li>🚚 <strong>Giao hàng nhanh</strong> trong 2 giờ tại TP. HCM, miễn phí với đơn trên 500.000đ.</li>
            <li>💬 <strong>Chăm sóc khách hàng tận tâm</strong> qua Zalo, Facebook và Hotline 24/7.</li>
            <li>🎁 <strong>Thiết kế độc quyền</strong> – mẫu hoa cập nhật theo xu hướng mới nhất.</li>
        </ul>
    </section>

    <section>
        <h4>5. Thông tin liên hệ</h4>
        <p>
            📍 <strong>Địa chỉ:</strong> 123 Đường Hoa Hồng, Phường 7, Quận Phú Nhuận, TP. Hồ Chí Minh<br>
            ☎️ <strong>Hotline:</strong> 0909 123 456<br>
            💌 <strong>Email:</strong> contact@flowershop.com<br>
            🌐 <strong>Website:</strong> <a href="#">www.flowershop.com</a><br>
            🕒 <strong>Giờ làm việc:</strong> 7:30 – 21:30 (Tất cả các ngày trong tuần)
        </p>
    </section>
</main>

</div>

 <footer class="footer">
    <jsp:include page="/Trang/footer.jsp" />
</footer>

</body>
</html>

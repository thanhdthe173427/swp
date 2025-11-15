<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giới thiệu - FlowerShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@600&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(135deg, #fff0f5, #ffffff);
            margin: 0;
            padding: 0;
            color: #333;
        }

        /* ====== CONTAINER ====== */
        .main-content-wrapper {
            display: flex;
            gap: 25px;
            padding: 50px 60px;
            flex-wrap: wrap;
        }

        /* ====== SIDEBAR ====== */
        .sidebar {
            width: 260px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(255, 182, 193, 0.3);
            border: 1px solid #ffcce0;
            padding: 25px;
            flex-shrink: 0;
            position: sticky;
            top: 30px;
            height: fit-content;
        }

        .sidebar h3 {
            color: #e60073;
            font-size: 18px;
            border-bottom: 2px solid #ffe6f2;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar li {
            margin-bottom: 8px;
        }

        .sidebar a {
            display: block;
            text-decoration: none;
            color: #555;
            padding: 10px 14px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .sidebar a:hover {
            background-color: #fff0f5;
            color: #e60073;
            font-weight: 500;
            transform: translateX(5px);
        }

        /* ====== MAIN CONTENT ====== */
        .main-content {
            flex: 1;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(255, 182, 193, 0.3);
            border: 1px solid #ffcce0;
            padding: 40px 50px;
            line-height: 1.8;
        }

        .main-content h3 {
            color: #e60073;
            font-family: "Dancing Script", cursive;
            font-size: 34px;
            margin-top: 0;
            text-align: center;
            margin-bottom: 20px;
        }

        section {
            margin-bottom: 35px;
        }

        section h4 {
            color: #8b0057;
            font-size: 18px;
            margin-bottom: 10px;
            border-left: 4px solid #e60073;
            padding-left: 10px;
        }

        section p {
            margin: 8px 0;
            font-size: 15px;
            color: #555;
        }

        ul {
            padding-left: 20px;
            margin-top: 10px;
        }

        ul li {
            margin: 6px 0;
            color: #555;
        }

        strong {
            color: #8b0057;
        }

        a {
            color: #e60073;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        /* ====== HIỆU ỨNG NHẸ ====== */
        .main-content section {
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ====== RESPONSIVE ====== */
        @media (max-width: 900px) {
            .main-content-wrapper {
                flex-direction: column;
                padding: 30px 20px;
            }
            .sidebar {
                width: 100%;
                position: static;
            }
            .main-content {
                padding: 25px 20px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/Trang/header.jsp" />

<div class="main-content-wrapper">
    <!-- Sidebar -->
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

    <!-- Main Content -->
    <main class="main-content">
        <h3>🌸 Giới thiệu về FlowerShop 🌸</h3>

        <section>
            <h4>1. Giới thiệu tổng quan</h4>
            <p><strong>FlowerShop</strong> là cửa hàng hoa tươi uy tín tại TP. Hồ Chí Minh, chuyên cung cấp sản phẩm hoa nghệ thuật phục vụ mọi dịp lễ, sự kiện và nhu cầu cá nhân.</p>
            <p>Với phương châm <em>"Trao gửi yêu thương bằng những đóa hoa tươi đẹp nhất"</em>, chúng tôi luôn nỗ lực mang đến cho khách hàng trải nghiệm tuyệt vời cả về chất lượng lẫn dịch vụ.</p>
        </section>

        <section>
            <h4>2. Lịch sử hình thành</h4>
            <p>Thành lập từ năm <strong>2018</strong> với khởi đầu là một cửa hàng nhỏ tại Quận Phú Nhuận, FlowerShop đã nhanh chóng phát triển thành hệ thống chuỗi cửa hàng hoa chuyên nghiệp, phục vụ hàng nghìn khách hàng mỗi tháng.</p>
            <p>Trong suốt quá trình hoạt động, chúng tôi không ngừng đổi mới – từ nghệ thuật cắm hoa đến dịch vụ giao hàng tận nơi, mang lại sự hài lòng tuyệt đối cho khách hàng.</p>
        </section>

        <section>
            <h4>3. Sản phẩm & Dịch vụ</h4>
            <ul>
                <li>💐 Hoa bó tặng sinh nhật, kỷ niệm, lễ tình nhân...</li>
                <li>🌷 Hoa giỏ, hoa hộp sang trọng cho dịp chúc mừng, khai trương.</li>
                <li>🌹 Hoa cưới, hoa cầm tay cô dâu, trang trí tiệc cưới.</li>
                <li>🌼 Hoa chia buồn, vòng hoa tang lễ tinh tế.</li>
                <li>🌸 Dịch vụ giao hoa tận nơi trong ngày – nhanh chóng và đúng hẹn.</li>
            </ul>
        </section>

        <section>
            <h4>4. Lợi thế cạnh tranh</h4>
            <ul>
                <li>🌿 <strong>Hoa tươi 100%</strong> nhập mới mỗi ngày từ Đà Lạt.</li>
                <li>🎀 <strong>Đội ngũ nghệ nhân cắm hoa</strong> chuyên nghiệp và sáng tạo.</li>
                <li>🚚 <strong>Giao hàng nhanh</strong> trong 2 giờ tại TP.HCM, miễn phí đơn trên 500.000đ.</li>
                <li>💬 <strong>Hỗ trợ khách hàng</strong> 24/7 qua Zalo, Facebook và Hotline.</li>
                <li>🎁 <strong>Mẫu hoa độc quyền</strong>, thiết kế theo xu hướng mới nhất.</li>
            </ul>
        </section>

        <section>
            <h4>5. Thông tin liên hệ</h4>
            <p>
                📍 <strong>Địa chỉ:</strong> 123 Hoa Hồng, Phú Nhuận, TP. Hồ Chí Minh<br>
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

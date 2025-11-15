<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tin tức & Blog - FlowerShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            margin: 0;
            color: #333;
        }

        h1 {
            color: #e60073;
            font-family: "Dancing Script", cursive;
            font-size: 38px;
            text-align: center;
            margin-top: 50px;
            margin-bottom: 10px;
        }

        .subtitle {
            text-align: center;
            font-size: 15px;
            color: #666;
            margin-bottom: 40px;
        }

        /* === GRID === */
        .news-grid {
            max-width: 1200px;
            margin: 0 auto 60px;
            padding: 0 40px;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 30px;
        }

        /* === CARD === */
        .news-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(255, 182, 193, 0.3);
            overflow: hidden;
            text-align: center;
            transition: all 0.3s ease;
        }

        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 18px rgba(231, 84, 128, 0.35);
        }

        .news-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-bottom: 2px solid #ffe6f2;
            border-radius: 10px 10px 0 0;
            transition: transform 0.4s ease;
        }

        .news-card:hover img {
            transform: scale(1.05);
        }

        .news-info {
            padding: 18px;
        }

        .news-title {
            font-size: 17px;
            color: #8b0057;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .news-date {
            color: #999;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .news-desc {
            font-size: 14px;
            color: #555;
            line-height: 1.5;
            min-height: 60px;
            margin-bottom: 12px;
        }

        /* === Nút xem chi tiết === */
        .read-more {
            display: inline-block;
            background-color: #e60073;
            color: white;
            padding: 6px 16px;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
        }

        .read-more:hover {
            background-color: #cc0066;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<jsp:include page="/Trang/header.jsp" />

<h1>Tin tức & Blog</h1>
<p class="subtitle">Khám phá những câu chuyện, mẹo chọn hoa và xu hướng quà tặng mới nhất 🌸</p>

<div class="news-grid">

    <!-- Bài viết 1 -->
    <div class="news-card">
        <img src="https://tse4.mm.bing.net/th/id/OIP.b5ygDtGUNnoNaYkhcYyZUwHaFj?cb=12ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3" alt="Hoa hồng và tình yêu">
        <div class="news-info">
            <div class="news-title">🌹 Ý nghĩa hoa hồng trong tình yêu</div>
            <div class="news-date">🗓 20 Tháng 10, 2025</div>
            <div class="news-desc">
                Hoa hồng là biểu tượng của tình yêu vĩnh cửu. Mỗi màu hoa đều mang một ý nghĩa riêng — thể hiện cảm xúc và thông điệp chân thành nhất.
            </div>
            <a href="#" class="read-more">Xem chi tiết</a>
        </div>
    </div>

    <!-- Bài viết 2 -->
    <div class="news-card">
        <img src="https://tse4.mm.bing.net/th/id/OIP.b5ygDtGUNnoNaYkhcYyZUwHaFj?cb=12ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3" alt="Hoa tulip tươi lâu">
        <div class="news-info">
            <div class="news-title">🌷 Cách chăm hoa tulip tươi lâu</div>
            <div class="news-date">🗓 10 Tháng 10, 2025</div>
            <div class="news-desc">
                Tulip là loài hoa sang trọng và thanh nhã. Hãy cùng tìm hiểu bí quyết giữ hoa tulip tươi lâu để không gian của bạn luôn rực rỡ sắc màu.
            </div>
            <a href="#" class="read-more">Xem chi tiết</a>
        </div>
    </div>

    <!-- Bài viết 3 -->
    <div class="news-card">
        <img src="https://tse4.mm.bing.net/th/id/OIP.b5ygDtGUNnoNaYkhcYyZUwHaFj?cb=12ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3" alt="Hoa sinh nhật">
        <div class="news-info">
            <div class="news-title">🎁 Chọn hoa sinh nhật theo cung hoàng đạo</div>
            <div class="news-date">🗓 02 Tháng 10, 2025</div>
            <div class="news-desc">
                Mỗi cung hoàng đạo đại diện cho một tính cách. Hãy chọn bó hoa phù hợp để món quà sinh nhật của bạn trở nên ý nghĩa hơn bao giờ hết!
            </div>
            <a href="#" class="read-more">Xem chi tiết</a>
        </div>
    </div>

    <!-- Bài viết 4 -->
    <div class="news-card">
        <img src="https://tse4.mm.bing.net/th/id/OIP.b5ygDtGUNnoNaYkhcYyZUwHaFj?cb=12ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3" alt="Hoa lan sang trọng">
        <div class="news-info">
            <div class="news-title">🌸 Hoa lan – biểu tượng của sự cao quý</div>
            <div class="news-date">🗓 28 Tháng 9, 2025</div>
            <div class="news-desc">
                Hoa lan là biểu tượng của vẻ đẹp sang trọng và tinh tế. Cùng khám phá cách trưng bày hoa lan để thu hút năng lượng tích cực cho ngôi nhà.
            </div>
            <a href="#" class="read-more">Xem chi tiết</a>
        </div>
    </div>

    <!-- Bài viết 5 -->
    <div class="news-card">
        <img src="https://tse4.mm.bing.net/th/id/OIP.b5ygDtGUNnoNaYkhcYyZUwHaFj?cb=12ucfimg=1&rs=1&pid=ImgDetMain&o=7&rm=3" alt="Hoa cẩm tú cầu">
        <div class="news-info">
            <div class="news-title">💐 Cẩm tú cầu – lời xin lỗi chân thành</div>
            <div class="news-date">🗓 15 Tháng 9, 2025</div>
            <div class="news-desc">
                Với vẻ đẹp mong manh, cẩm tú cầu tượng trưng cho lòng biết ơn và lời xin lỗi sâu sắc. Hãy để hoa thay bạn nói điều chưa kịp nói.
            </div>
            <a href="#" class="read-more">Xem chi tiết</a>
        </div>
    </div>

</div>

<jsp:include page="/Trang/footer.jsp" />

</body>
</html>

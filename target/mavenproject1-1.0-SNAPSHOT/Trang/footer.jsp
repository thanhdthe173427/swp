<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>FlowerShop - Footer</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background-color: #fff;
        }

        /* ===== FOOTER ===== */
        .footer {
            background-color: #fff0f6;
            border-top: 3px solid #e60073;
            color: #333;
            padding: 40px 20px 20px;
            font-size: 14px;
        }

        .footer-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            max-width: 1200px;
            margin: 0 auto;
            gap: 20px;
        }

        .footer-section {
            flex: 1 1 220px;
            margin: 10px;
        }

        .footer-section h4 {
            color: #8b0057;
            margin-bottom: 12px;
            font-size: 16px;
            border-bottom: 2px solid #e60073;
            display: inline-block;
            padding-bottom: 4px;
        }

        .footer-section ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .footer-section ul li {
            margin-bottom: 8px;
            color: #333;
        }

        .footer-section ul li a {
            color: #333;
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-section ul li a:hover {
            color: #e60073;
            text-decoration: underline;
        }

        .social-links {
            display: flex;
            gap: 10px;
            margin-top: 5px;
        }

        .social-links a img {
            width: 24px;
            height: 24px;
            transition: transform 0.3s;
        }

        .social-links a:hover img {
            transform: scale(1.2);
        }

        .footer-bottom {
            text-align: center;
            border-top: 1px solid #ffcce0;
            margin-top: 20px;
            padding-top: 15px;
            color: #8b0057;
        }

        .footer-bottom span {
            font-weight: bold;
            color: #e60073;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .footer-container {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .footer-section {
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-section">
            <h4>Liên hệ</h4>
            <ul>
                <li>Email: contact@flowershop.com</li>
                <li>Địa chỉ: 123 Đường Hoa Hồng, TP. HCM</li>
                <li>Hotline: 0909 123 456</li>
            </ul>
        </div>

        <div class="footer-section">
            <h4>Phản hồi</h4>
            <ul>
                <li><a href="#">Gửi phản hồi</a></li>
                <li><a href="#">Câu hỏi thường gặp</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h4>Chính sách</h4>
            <ul>
                <li><a href="#">Chính sách thanh toán</a></li>
                <li><a href="#">Chính sách vận chuyển</a></li>
                <li><a href="#">Chính sách đổi trả</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h4>Kết nối với chúng tôi</h4>
            <div class="social-links">
                <a href="#"><img src="https://img.icons8.com/ios-filled/24/8b0057/facebook-new.png" alt="Facebook"></a>
                <a href="#"><img src="https://img.icons8.com/ios-filled/24/8b0057/instagram-new.png" alt="Instagram"></a>
                <a href="#"><img src="https://img.icons8.com/ios-filled/24/8b0057/zalo.png" alt="Zalo"></a>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p>© 2025 <span>FlowerShop</span>. All rights reserved 🌸</p>
    </div>
</footer>

</body>
</html>

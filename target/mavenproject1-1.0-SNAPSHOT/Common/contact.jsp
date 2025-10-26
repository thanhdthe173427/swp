<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Liên hệ với chúng tôi - FlowerShop</title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(120deg, #ffe6f2, #fff);
            margin: 0;
            color: #333;
        }

        h1 {
            color: #e60073;
            font-family: "Dancing Script", cursive;
            font-size: 42px;
            text-align: center;
            margin: 60px 0 5px;
            letter-spacing: 1px;
        }

        .subtitle {
            text-align: center;
            color: #666;
            font-size: 16px;
            margin-bottom: 50px;
        }

        .contact-wrapper {
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 20px 60px;
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            justify-content: center;
        }

        /* ==== THÔNG TIN LIÊN HỆ ==== */
        .contact-info {
            flex: 1 1 400px;
            background: rgba(255, 240, 245, 0.8);
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
            backdrop-filter: blur(6px);
        }

        .contact-info h2 {
            color: #8b0057;
            margin-bottom: 15px;
            border-left: 5px solid #e60073;
            padding-left: 10px;
            font-size: 20px;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 15px;
            margin: 18px 0;
            color: #555;
        }

        .contact-item span {
            background-color: #e60073;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            box-shadow: 0 3px 8px rgba(230, 0, 115, 0.2);
        }

        .contact-item p {
            margin: 0;
            font-size: 15px;
        }

        .contact-item a {
            color: #e60073;
            text-decoration: none;
        }
        .contact-item a:hover {
            text-decoration: underline;
        }

        /* ==== FORM LIÊN HỆ ==== */
        .contact-form {
            flex: 1 1 400px;
            background: #fff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(255, 182, 193, 0.3);
        }

        .contact-form h2 {
            color: #8b0057;
            margin-bottom: 20px;
            border-left: 5px solid #e60073;
            padding-left: 10px;
            font-size: 20px;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        input, textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ffcce0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

        input:focus, textarea:focus {
            border-color: #e60073;
            box-shadow: 0 0 6px rgba(230, 0, 115, 0.2);
            outline: none;
        }

        textarea {
            resize: none;
            height: 120px;
        }

        button {
            background-color: #e60073;
            color: #fff;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 4px 10px rgba(230, 0, 115, 0.2);
        }

        button:hover {
            background-color: #cc0066;
            transform: translateY(-2px);
        }

        /* ==== GOOGLE MAP ==== */
        .map-container {
            max-width: 1100px;
            margin: 50px auto 80px;
            padding: 0 20px;
        }

        iframe {
            border: none;
            width: 100%;
            height: 350px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* ==== RESPONSIVE ==== */
        @media (max-width: 768px) {
            .contact-wrapper {
                flex-direction: column;
                padding: 20px;
            }

            .contact-info, .contact-form {
                padding: 30px 25px;
            }

            h1 {
                font-size: 32px;
                margin-top: 40px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/Trang/header.jsp" />

<h1>Liên hệ với chúng tôi</h1>
<p class="subtitle">Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn mọi lúc 🌸</p>

<div class="contact-wrapper">
    <!-- Thông tin liên hệ -->
    <div class="contact-info">
        <h2>Thông tin liên hệ</h2>
        <div class="contact-item">
            <span>📍</span>
            <p>123 Hoa Hồng, Quận 1, TP. Hồ Chí Minh</p>
        </div>
        <div class="contact-item">
            <span>📞</span>
            <p>Hotline: <strong>0909 123 456</strong></p>
        </div>
        <div class="contact-item">
            <span>✉️</span>
            <p>Email: <a href="mailto:flowershop@gmail.com">flowershop@gmail.com</a></p>
        </div>
        <div class="contact-item">
            <span>🌐</span>
            <p>Website: <a href="https://flowershop.vn" target="_blank">www.flowershop.vn</a></p>
        </div>
        <p style="margin-top: 20px;">
            Giờ làm việc: <br>
            <strong>Thứ 2 - Chủ nhật: 7:00 - 22:00</strong>
        </p>
    </div>

    <!-- Form gửi tin nhắn -->
    <div class="contact-form">
        <h2>Gửi tin nhắn cho chúng tôi</h2>
        <form action="#" method="post">
            <input type="text" name="name" placeholder="Họ và tên của bạn" required>
            <input type="email" name="email" placeholder="Địa chỉ Email" required>
            <textarea name="message" placeholder="Nội dung tin nhắn..." required></textarea>
            <button type="submit">💌 Gửi tin nhắn</button>
        </form>
    </div>
</div>

<!-- Google Map -->
<div class="map-container">
    <iframe 
        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.508927980786!2d106.70042301533843!3d10.776888992322557!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f3e3edfd6b3%3A0xecd38a8b1a6d1a7b!2zMTIzIFRy4bqnbiBOaMOibiwgUXXhuq1uIDEuIFRow6BuaCBwaOG7kSBtw6ksIFTDom4gUXXhuq1uLCBIb8OgIENoaSBNaW5o!5e0!3m2!1svi!2s!4v1698244100000!5m2!1svi!2s"
        allowfullscreen=""
        loading="lazy">
    </iframe>
</div>

<jsp:include page="/Trang/footer.jsp" />

</body>
</html>

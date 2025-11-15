<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký thành công - FlowerShop</title>
    <meta http-equiv="refresh" content="10;url=homepage.jsp"> <!-- ⏰ Tự chuyển sau 10s -->
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(to right, #ffe6f2, #fff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .success-box {
            background: white;
            border: 1px solid #ffcce0;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(231, 84, 128, 0.25);
            padding: 40px 60px;
            text-align: center;
            max-width: 450px;
        }

        h2 {
            color: #e60073;
            margin-bottom: 10px;
            font-size: 26px;
        }

        p {
            color: #555;
            font-size: 15px;
            margin-bottom: 25px;
        }

        .success-icon {
            font-size: 50px;
            color: #e60073;
            margin-bottom: 20px;
        }

        .back-home {
            text-decoration: none;
            background-color: #e60073;
            color: white;
            padding: 10px 25px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            transition: 0.3s;
        }

        .back-home:hover {
            background-color: #cc0066;
            transform: translateY(-1px);
        }

        .countdown {
            font-size: 14px;
            color: #888;
            margin-top: 10px;
        }
    </style>
</head>
<body>

    <div class="success-box">
        <div class="success-icon">✅</div>
        <h2>Đăng ký thành công!</h2>
        <p>Cảm ơn bạn đã đăng ký tài khoản tại <strong>FlowerShop</strong> 💐</p>

        <p><strong>Tên đăng nhập:</strong> ${username}</p>
        <p><strong>Email:</strong> ${email}</p>
        <p><strong>Họ tên:</strong> ${fullname}</p>
        <p><strong>SĐT:</strong> ${phone}</p>
        <p><strong>Địa chỉ:</strong> ${address}</p>

        <br>
        <a href="homepage.jsp" class="back-home">← Quay lại trang chủ</a>

        <p class="countdown">Trang sẽ tự động quay lại sau <span id="time">10</span> giây...</p>
    </div>

    <script>
        // ⏳ Đếm ngược hiển thị trên giao diện
        let timeLeft = 10;
        const timer = document.getElementById("time");
        const countdown = setInterval(() => {
            timeLeft--;
            timer.textContent = timeLeft;
            if (timeLeft <= 0) {
                clearInterval(countdown);
                window.location.href = "homepage.jsp";
            }
        }, 1000);
    </script>

</body>
</html>

package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

/**
 * ✉️ EmailUtil - Gửi email qua Gmail (App Password)
 * Sử dụng cho chức năng: xác nhận thanh toán, quên mật khẩu, thông báo đơn hàng, v.v.
 */
public class EmailUtil {

    // ⚠️ Thông tin Gmail gửi đi (phải bật App Password)
    private static final String USERNAME = "thanhdthe173427@fpt.edu.vn";
    private static final String PASSWORD = "irprgkxcdkvdmguk"; // App password 16 ký tự

    // ✅ Tạo phiên làm việc SMTP
    private static Session createSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });
    }

    // ✅ Hàm gửi email cơ bản (HTML)
    public static void send(String to, String subject, String htmlContent)
            throws MessagingException, UnsupportedEncodingException {

        Message msg = new MimeMessage(createSession());
        msg.setFrom(new InternetAddress(USERNAME, "FlowerShop Support")); // tên hiển thị
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject(subject);
        msg.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(msg);
        System.out.println("✅ Gửi email thành công tới: " + to);
    }

    // ✅ Hàm gửi email xác nhận thanh toán VNPay
    public static void sendPaymentConfirmation(String to, String orderCode, double amount, String transactionNo) {
        String subject = "Xác nhận thanh toán VNPay - Đơn hàng #" + orderCode;

        StringBuilder content = new StringBuilder();
        content.append("<div style='font-family:Arial,sans-serif;line-height:1.6;'>")
                .append("<h2 style='color:#009688;'>🌸 Cảm ơn bạn đã thanh toán qua VNPay!</h2>")
                .append("<p>Đơn hàng của bạn đã được xác nhận thành công.</p>")
                .append("<table style='border-collapse:collapse;margin-top:10px;'>")
                .append("<tr><td><b>Mã đơn hàng:</b></td><td>").append(orderCode).append("</td></tr>")
                .append("<tr><td><b>Số tiền:</b></td><td>").append(String.format("%,.0f", amount)).append(" VNĐ</td></tr>")
                .append("<tr><td><b>Mã giao dịch:</b></td><td>").append(transactionNo).append("</td></tr>")
                .append("</table>")
                .append("<p>Chúng tôi sẽ giao hàng cho bạn trong thời gian sớm nhất.</p>")
                .append("<p>Trân trọng,<br><b>FlowerShop Team</b></p>")
                .append("</div>");

        try {
            send(to, subject, content.toString());
        } catch (Exception e) {
            System.err.println("❌ Gửi email xác nhận thanh toán thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ✅ Hàm gửi email quên mật khẩu
    public static void sendResetPassword(String to, String newPassword) {
        String subject = "Khôi phục mật khẩu - FlowerShop";
        String content = "<div style='font-family:Arial,sans-serif;line-height:1.6;'>"
                + "<h2 style='color:#e91e63;'>🔑 Mật khẩu mới của bạn</h2>"
                + "<p>Xin chào,</p>"
                + "<p>Hệ thống đã đặt lại mật khẩu cho tài khoản của bạn:</p>"
                + "<p><b>" + newPassword + "</b></p>"
                + "<p>Vui lòng đăng nhập và đổi mật khẩu ngay sau khi truy cập.</p>"
                + "<p>Trân trọng,<br><b>FlowerShop Team</b></p>"
                + "</div>";

        try {
            send(to, subject, content);
        } catch (Exception e) {
            System.err.println("❌ Gửi email khôi phục mật khẩu thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailUtil {
    // ⚠️ Phải là email Gmail hợp lệ
    private static final String USERNAME = "thanhdthe173427@fpt.edu.vn";
    
    // ✅ App Password 16 ký tự bạn lấy từ Google App Password
    private static final String PASSWORD = "irprgkxcdkvdmguk"; 

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

    public static void send(String to, String subject, String htmlContent)
            throws MessagingException, UnsupportedEncodingException {
        Message msg = new MimeMessage(createSession());
        msg.setFrom(new InternetAddress(USERNAME, "FlowerShop Support"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject(subject);
        msg.setContent(htmlContent, "text/html; charset=UTF-8");
        Transport.send(msg);
        System.out.println("✅ Gửi email thành công tới " + to);
    }

    
}

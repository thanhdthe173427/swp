package utils;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import jakarta.servlet.http.HttpServletRequest;

/**
 * ⚙️ Config cho VNPay và các hàm tiện ích
 * Tác giả: bạn (Flower Shop)
 */
public class Config {

    // Lưu tạm mã đơn hàng đang tạo (sử dụng trong callback VNPay)
    public static long orderID = 0;

    // 🏦 Cấu hình VNPay Sandbox
    public static String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static String vnp_ReturnUrl = "http://localhost:9999/mavenproject1/handle-payment-result"; // URL callback sau khi thanh toán
    public static String vnp_TmnCode = "CGXZLS0Z"; // mã Terminal Code của bạn trên VNPay
    public static String vnp_HashSecret = "XNBCJFAKAZQSGTARRLGCHVZWCIOIGSHN"; // secret key để ký
    public static String vnp_ApiUrl = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";

    // ============================================================ //
    // 🔒 Các hàm mã hóa hỗ trợ (MD5, SHA256, HmacSHA512)
    // ============================================================ //

    public static String md5(String message) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(message.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder(2 * hash.length);
            for (byte b : hash) sb.append(String.format("%02x", b & 0xff));
            return sb.toString();
        } catch (UnsupportedEncodingException | NoSuchAlgorithmException ex) {
            return "";
        }
    }

    public static String sha256(String message) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(message.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder(2 * hash.length);
            for (byte b : hash) sb.append(String.format("%02x", b & 0xff));
            return sb.toString();
        } catch (UnsupportedEncodingException | NoSuchAlgorithmException ex) {
            return "";
        }
    }

    // Tạo chữ ký HmacSHA512 cho VNPay
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException("Key hoặc Data null");
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes();
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) sb.append(String.format("%02x", b & 0xff));
            return sb.toString();
        } catch (Exception ex) {
            System.err.println("Lỗi khi hash HmacSHA512: " + ex.getMessage());
            return "";
        }
    }

    // Hash toàn bộ field VNPay (để tạo signature)
    public static String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder sb = new StringBuilder();
        for (Iterator<String> itr = fieldNames.iterator(); itr.hasNext();) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                sb.append(fieldName).append("=").append(fieldValue);
            }
            if (itr.hasNext()) sb.append("&");
        }
        return hmacSHA512(vnp_HashSecret, sb.toString());
    }

    // ============================================================ //
    // 🌐 Các hàm tiện ích khác
    // ============================================================ //

    // Lấy địa chỉ IP thật của client
    public static String getIpAddress(HttpServletRequest request) {
        try {
            String ipAddress = request.getHeader("X-FORWARDED-FOR");
            if (ipAddress == null || ipAddress.isEmpty()) {
                ipAddress = request.getRemoteAddr();
            }
            return ipAddress;
        } catch (Exception e) {
            return "Invalid IP: " + e.getMessage();
        }
    }

    // Tạo số ngẫu nhiên (cho mã đơn hàng hoặc vnp_TxnRef)
    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
}

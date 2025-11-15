package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private static final String URL = "jdbc:mysql://localhost:3306/shop_flower?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "Trumsolo456@";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("❌ Không tìm thấy MySQL Driver: " + e.getMessage());
        }
    }

    // ✅ Mỗi lần gọi getConnection() → tạo connection mới, đảm bảo autoCommit=true
    public Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            conn.setAutoCommit(true);
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Không thể kết nối CSDL: " + e.getMessage());
            return null;
        }
    }
    
    // 🟢 Hàm main test kết nối CSDL
    public static void main(String[] args) {
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection()) {  // try-with-resources tự động đóng connection
            if (conn != null) {
                System.out.println("✅ Kết nối CSDL thành công!");
            } else {
                System.out.println("❌ Kết nối CSDL thất bại!");
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi thao tác với connection: " + e.getMessage());
        }
    }
    
}


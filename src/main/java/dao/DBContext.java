package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBContext {
    private static final String URL = "jdbc:mysql://localhost:3306/shop_flower?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private Connection connection;

    public DBContext() {
        try {
            // Load driver
            Class.forName(DRIVER);

            // Tạo kết nối
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Kết nối MySQL thành công!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ Không tìm thấy MySQL Driver: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kết nối CSDL: " + e.getMessage());
        }
    }

    public Connection getConnection() {
        return connection;
    }

    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("🔒 Đã đóng kết nối MySQL.");
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi đóng kết nối: " + e.getMessage());
        }
    }

    /** ✅ Hàm main để test nhanh kết nối MySQL */
    public static void main(String[] args) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();

        if (conn == null) {
            System.err.println("⚠️ Không thể kết nối tới database. Kiểm tra URL, user hoặc password!");
            return;
        }

        System.out.println("🧩 Bắt đầu test truy vấn dữ liệu...");
        try (Statement stmt = conn.createStatement()) {
            String sql = "SELECT id, full_name, email FROM users LIMIT 5";
            ResultSet rs = stmt.executeQuery(sql);

            System.out.println("📋 Danh sách người dùng trong bảng `users`:");
            System.out.println("--------------------------------------------------");

            while (rs.next()) {
                long id = rs.getLong("id");
                String name = rs.getString("full_name");
                String email = rs.getString("email");

                System.out.printf("👤 ID: %-3d | %-20s | %s%n", id, name, email);
            }

            System.out.println("--------------------------------------------------");
            rs.close();

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi truy vấn dữ liệu: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.closeConnection();
        }
    }
}

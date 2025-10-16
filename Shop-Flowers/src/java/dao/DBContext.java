package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    public Connection connection;
    
    public DBContext() {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            String url = "jdbc:mysql://localhost:3306/shop_flower";
            String user = "root";
            String password = "Trumsolo456@"; // Mật khẩu MySQL của bạn
            
            connection = DriverManager.getConnection(url, user, password);
            System.out.println("✓ Kết nối thành công!");
            
        } catch (ClassNotFoundException e) {
            System.out.println("✗ Không tìm thấy MySQL Driver: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("✗ Lỗi kết nối: " + e.getMessage());
        }
    }
    
    // Method để đóng kết nối
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Đã đóng kết nối!");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi đóng kết nối: " + e.getMessage());
        }
    }
    
    public static void main(String[] args) {
        DBContext db = new DBContext();
        System.out.println("Connection object: " + db.connection);
        db.closeConnection();
    }
}
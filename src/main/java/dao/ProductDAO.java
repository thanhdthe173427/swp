package dao;

import model.Product;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class ProductDAO {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    // ✅ Lấy sản phẩm theo ID
    public Product getProductById(long id) {
        Product p = null;
        String sql = "SELECT * FROM products WHERE id = ?";

        try {
            conn = new DBContext().getConnection(); // dùng DBContext thay vì tự tạo connection
            ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                p = new Product();
                p.setId(rs.getLong("id"));
                p.setCategoryId(rs.getLong("category_id"));
                p.setSku(rs.getString("sku"));
                p.setSlug(rs.getString("slug"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setBasePrice(rs.getBigDecimal("base_price"));
                p.setCostPrice(rs.getBigDecimal("cost_price"));
                p.setUnit(rs.getString("unit"));
                p.setIsActive(rs.getBoolean("is_active"));
                p.setIsAccessory(rs.getBoolean("is_accessory"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                p.setUrl(rs.getString("image_url")); // ✅ Lấy thêm cột URL
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        return p;
    }
    
    public List<Product> getAllProducts() {
    List<Product> list = new ArrayList<>();
    String sql = "SELECT * FROM products WHERE is_active = 1 ORDER BY created_at DESC";

    try {
        conn = new DBContext().getConnection();
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            Product p = new Product();
            p.setId(rs.getLong("id"));
            p.setCategoryId(rs.getLong("category_id"));
            p.setSku(rs.getString("sku"));
            p.setSlug(rs.getString("slug"));
            p.setName(rs.getString("name"));
            p.setDescription(rs.getString("description"));
            p.setBasePrice(rs.getBigDecimal("base_price"));
            p.setCostPrice(rs.getBigDecimal("cost_price"));
            p.setUnit(rs.getString("unit"));
            p.setIsActive(rs.getBoolean("is_active"));
            p.setIsAccessory(rs.getBoolean("is_accessory"));
            p.setCreatedAt(rs.getTimestamp("created_at"));
            p.setUpdatedAt(rs.getTimestamp("updated_at"));
            p.setUrl(rs.getString("image_url"));
            list.add(p);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeConnection();
    }
    return list;
}


    // ✅ Hàm đóng kết nối an toàn
    private void closeConnection() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        List<Product> list = dao.getAllProducts();
        System.out.println("Số sản phẩm trong DB: " + list.size());
        for (Product p : list) {
            System.out.println(p);
        }
    }
    
}

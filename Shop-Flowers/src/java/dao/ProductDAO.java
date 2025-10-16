package dao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private DBContext db;

    public ProductDAO() {
        db = new DBContext();
    }

    // Lấy tất cả sản phẩm
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
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
                list.add(p);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy sản phẩm theo id
    public Product getById(long id) {
        String sql = "SELECT * FROM products WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
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
                return p;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm sản phẩm mới
    public void add(Product p) {
        String sql = "INSERT INTO products(category_id, sku, slug, name, description, base_price, cost_price, unit, is_active, is_accessory, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, p.getCategoryId());
            ps.setString(2, p.getSku());
            ps.setString(3, p.getSlug());
            ps.setString(4, p.getName());
            ps.setString(5, p.getDescription());
            ps.setBigDecimal(6, p.getBasePrice());
            ps.setBigDecimal(7, p.getCostPrice());
            ps.setString(8, p.getUnit());
            ps.setBoolean(9, p.isIsActive());
            ps.setBoolean(10, p.isIsAccessory());
            ps.setTimestamp(11, new Timestamp(System.currentTimeMillis())); // created_at
            ps.setTimestamp(12, new Timestamp(System.currentTimeMillis())); // updated_at
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật sản phẩm
    public void update(Product p) {
        String sql = "UPDATE products SET category_id=?, sku=?, slug=?, name=?, description=?, base_price=?, cost_price=?, unit=?, is_active=?, is_accessory=?, updated_at=? WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, p.getCategoryId());
            ps.setString(2, p.getSku());
            ps.setString(3, p.getSlug());
            ps.setString(4, p.getName());
            ps.setString(5, p.getDescription());
            ps.setBigDecimal(6, p.getBasePrice());
            ps.setBigDecimal(7, p.getCostPrice());
            ps.setString(8, p.getUnit());
            ps.setBoolean(9, p.isIsActive());
            ps.setBoolean(10, p.isIsAccessory());
            ps.setTimestamp(11, new Timestamp(System.currentTimeMillis())); // updated_at
            ps.setLong(12, p.getId());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa sản phẩm
    public void delete(long id) {
        String sql = "DELETE FROM products WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, id);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Test
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        List<Product> list = dao.getAll();
        if (list.isEmpty()) {
            System.out.println("⚠️ Không có sản phẩm nào trong bảng products.");
        } else {
            System.out.println("✅ Danh sách sản phẩm:");
            for (Product p : list) {
                System.out.println(
                        p.getId() + " | " +
                        p.getSku() + " | " +
                        p.getName() + " | " +
                        p.getBasePrice() + " | " +
                        p.getCostPrice() + " | " +
                        (p.isIsActive() ? "ACTIVE" : "INACTIVE")
                );
            }
        }
    }
}

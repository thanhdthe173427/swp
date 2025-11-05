package dao;

import model.Product;
import java.sql.*;
import java.util.*;

public class ProductDAO {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    // ✅ Lấy sản phẩm theo ID
    public Product getProductById(long id) {
        Product p = null;
        String sql = "SELECT * FROM products WHERE id = ?";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                p = extractProduct(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        return p;
    }

    // ✅ Lấy tất cả sản phẩm đang hoạt động
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = 1 ORDER BY created_at DESC";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        return list;
    }

    // ✅ Lấy sản phẩm theo slug của danh mục
    public List<Product> getProductsByCategorySlug(String slug) {
        List<Product> list = new ArrayList<>();
        String sql =
            "SELECT p.* " +
            "FROM products p " +
            "JOIN categories c ON p.category_id = c.id " +
            "WHERE p.is_active = 1 AND c.slug = ? " +
            "ORDER BY p.created_at DESC";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, slug);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        return list;
    }

    // ✅ Lấy sản phẩm nổi bật (trang chủ)
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = 1 ORDER BY created_at DESC LIMIT ?";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
        return list;
    }

    // ✅ Hàm gợi ý hoa theo dịp (birthday, love, opening, funeral, ...)
    public List<Product> getProductsByOccasion(String occasion) {
        List<Product> list = new ArrayList<>();

        String sql =
            "SELECT * FROM products " +
            "WHERE is_active = 1 " +
            "  AND ( " +
            "        LOWER(COALESCE(occasion, '')) LIKE ? " +
            "     OR LOWER(COALESCE(tags, '')) LIKE ? " +
            "     OR LOWER(COALESCE(name, '')) LIKE ? " +
            "     OR LOWER(COALESCE(description, '')) LIKE ? " +
            "      ) " +
            "ORDER BY created_at DESC";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);

            String keyword = "%" + occasion.toLowerCase() + "%";
            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ps.setString(3, keyword);
            ps.setString(4, keyword);

            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

        return list;
    }

    // ✅ Hàm tái sử dụng: Chuyển ResultSet → Product
    private Product extractProduct(ResultSet rs) throws SQLException {
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
        return p;
    }

    // ✅ Đóng kết nối an toàn
    private void closeConnection() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Giữ tương thích với JSP cũ
    public List<Product> getProductsByCategory(String slug) {
        return getProductsByCategorySlug(slug);
    }

    // ✅ Test nhanh
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();

        Product list = dao.getProductById(7);
        System.out.println("🎂 Hoa sinh nhật: " + list.getName());

        
    }
}

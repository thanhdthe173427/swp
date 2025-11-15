package dao;

import model.Product;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // ============================================================
    // 🔹 HỖ TRỢ KẾT NỐI
    // ============================================================
    private Connection getConnection() throws SQLException {
        return new DBContext().getConnection();
    }

    // ============================================================
    // 🔹 LẤY TẤT CẢ SẢN PHẨM (KHÔNG LỌC is_active)
    // ============================================================
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ============================================================
    // 🔹 LẤY TẤT CẢ SẢN PHẨM ĐANG HOẠT ĐỘNG
    // ============================================================
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = 1 ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ============================================================
    // 🔹 LẤY SẢN PHẨM THEO ID (cho Admin, Formula)
    // ============================================================
    public Product getById(long id) {
        Product p = null;
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = extractProduct(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    public boolean deductAccessoryStock(long productId, int quantityToDeduct, Connection conn) throws SQLException {
        // Dùng WHERE quantity >= ? để đảm bảo không bị âm kho
        String sql = "UPDATE products SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityToDeduct);
            ps.setLong(2, productId);
            ps.setInt(3, quantityToDeduct); // Điều kiện kiểm tra

            int rowsAffected = ps.executeUpdate();

            // Nếu rowsAffected = 0, nghĩa là không đủ hàng (quantity < quantityToDeduct)
            return rowsAffected > 0;
        }
    }

    // ============================================================
    // 🔹 LẤY SẢN PHẨM THEO ID (cho Cart, Product Detail)
    // ============================================================
    public Product getProductById(long id) {
        Product p = null;
        // Câu SQL không đổi
        String sql = "SELECT id, category_id, sku, slug, name, description, base_price, cost_price, "
                + "unit, is_active, is_accessory, image_url, quantity, created_at, updated_at "
                + "FROM products WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
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
                    p.setIsAccessory(rs.getBoolean("is_accessory")); // Lấy cờ
                    p.setUrl(rs.getString("image_url"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // ===================================
                    // 🔹 LOGIC TÍNH SỐ LƯỢNG MỚI (Giống như trên)
                    // ===================================
                    if (p.isIsAccessory()) {
                        p.setQuantity(rs.getInt("quantity"));
                    } else {
                        p.setQuantity(calculateStockForBouquet(p.getId()));
                    }
                    // ===================================
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    // ============================================================
    // 🔹 🚀 HÀM MỚI HỖ TRỢ TRANSACTION 🚀
    // ============================================================
    /**
     * Lấy Product (dùng BÊN TRONG 1 transaction)
     *
     * @param conn Kết nối CÓ SẴN từ transaction
     */
    public Product getProductById(long id, Connection conn) throws SQLException {
        Product p = null;
        String sql = "SELECT * FROM products WHERE id = ?"; // Lấy tất cả các cột

        // KHÔNG mở kết nối mới, dùng conn có sẵn
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
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
                    p.setQuantity(rs.getInt("quantity")); // Lấy số lượng hiện tại
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    try {
                        p.setUrl(rs.getString("image_url"));
                    } catch (SQLException ignore) {
                    }
                }
            }
        }
        return p;
    }

    // ============================================================
    // 🔹 PHÂN TRANG (18 sản phẩm / trang)
    // ============================================================
    public List<Product> getProductsByPage(int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products WHERE is_active = 1 "
                + "ORDER BY created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ============================================================
    // 🔹 ĐẾM TỔNG SẢN PHẨM (phục vụ phân trang)
    // ============================================================
    public int countAllProducts() {
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ============================================================
    // 🔹 LẤY SẢN PHẨM THEO SLUG DANH MỤC (SQL CHUẨN)
    // ============================================================
    public List<Product> getProductsByCategorySlug(String slug) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM products p "
                + "INNER JOIN categories c ON p.category_id = c.id "
                + "WHERE p.is_active = 1 AND c.slug = ? "
                + "ORDER BY p.created_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByCategory(String slug) {
        return getProductsByCategorySlug(slug);
    }

    public static void main(String[] args) {
        // 1. Đổi tên biến 'd' thành 'dao' cho rõ nghĩa
        ProductDAO dao = new ProductDAO();

        // 2. Đổi tên 'ld' thành 'productList'
        List<Product> productList = dao.getAllProducts();

        System.out.println("--- Danh sách sản phẩm ---");

        // 3. Đổi tên biến lặp 'd' thành 'p' (cho Product)
        for (Product p : productList) {
            // 4. In ra chính đối tượng 'p'
            System.out.println(p);
        }
    }

    // ============================================================
    // 🔹 THÊM SẢN PHẨM
    // ============================================================
    public void add(Product p) {
        // ✅ SỬA DÒNG "VALUES" BÊN DƯỚI
        String sql = "INSERT INTO products "
                + "(category_id, sku, slug, name, description, base_price, cost_price, unit, "
                + "is_active, is_accessory, quantity, created_at, updated_at, image_url) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW(), ?)"; // <-- Đã sửa

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, p.getCategoryId());
            ps.setString(2, p.getSku());
            ps.setString(3, p.getSlug());
            ps.setString(4, p.getName());
            ps.setString(5, p.getDescription());
            ps.setBigDecimal(6, p.getBasePrice() != null ? p.getBasePrice() : BigDecimal.ZERO);
            ps.setBigDecimal(7, p.getCostPrice() != null ? p.getCostPrice() : BigDecimal.ZERO);
            ps.setString(8, p.getUnit());
            ps.setBoolean(9, p.isIsActive());
            ps.setBoolean(10, p.isIsAccessory());
            ps.setInt(11, p.getQuantity());

            // Cột 12 (created_at) và 13 (updated_at) là NOW()
            // ✅ Dấu ? thứ 12 là cho cột "image_url"
            ps.setString(12, p.getUrl());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ============================================================
    // 🔹 CẬP NHẬT SẢN PHẨM
    // ============================================================
    public void update(Product p) {
        // ✅ THÊM "image_url=?" VÀO CÂU SQL
        String sql = "UPDATE products "
                + "SET category_id=?, sku=?, slug=?, name=?, description=?, base_price=?, cost_price=?, unit=?, "
                + "is_active=?, is_accessory=?, quantity=?, image_url=?, updated_at=NOW() "
                + "WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
            ps.setInt(11, p.getQuantity());

            // ✅ THÊM DÒNG NÀY (tham số 12)
            ps.setString(12, p.getUrl());

            // ✅ SỬA DÒNG NÀY (từ 12 thành 13)
            ps.setLong(13, p.getId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void softDelete(long id) {
        String sql = "UPDATE products SET is_active = 0, updated_at = NOW() WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean checkProductInOrders(long productId) {
        String sql = "SELECT COUNT(*) FROM order_items WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void delete(long id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void restore(long id) {
        String sql = "UPDATE products SET is_active = 1, updated_at = NOW() WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isProductInUse(long productId) {
        // Kiểm tra trong order_items
        String sqlOrder = "SELECT COUNT(*) FROM order_items WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sqlOrder)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Kiểm tra trong cart_items
        String sqlCart = "SELECT COUNT(*) FROM cart_items WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sqlCart)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Product> getProductsByOccasion(String occasion) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products "
                + "WHERE is_active = 1 AND ("
                + "LOWER(COALESCE(occasion, '')) LIKE ? OR "
                + "LOWER(COALESCE(tags, '')) LIKE ? OR "
                + "LOWER(COALESCE(name, '')) LIKE ? OR "
                + "LOWER(COALESCE(description, '')) LIKE ?) "
                + "ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            String keyword = "%" + occasion.toLowerCase() + "%";
            for (int i = 1; i <= 4; i++) {
                ps.setString(i, keyword);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProduct(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

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
        p.setIsAccessory(rs.getBoolean("is_accessory")); // Lấy cờ phụ kiện

        // ===================================
        // 🔹 LOGIC TÍNH SỐ LƯỢNG MỚI
        // ===================================
        if (p.isIsAccessory()) {
            // NẾU LÀ PHỤ KIỆN (is_accessory = 1):
            // Lấy số lượng được lưu trữ trong cột 'quantity'
            p.setQuantity(rs.getInt("quantity"));
        } else {
            // NẾU LÀ BÓ HOA (is_accessory = 0):
            // Gọi hàm tính toán số lượng dựa trên công thức
            p.setQuantity(calculateStockForBouquet(p.getId()));
        }
        // ===================================
        // 🔹 KẾT THÚC LOGIC MỚI
        // ===================================

        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        try {
            p.setUrl(rs.getString("image_url"));
        } catch (SQLException ignore) {
        }
        return p;
    }

    // trong ProductDAO.java
    public void updateCostPrice(long productId, BigDecimal newCostPrice) {
        String sql = "UPDATE products SET cost_price = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, newCostPrice);
            ps.setLong(2, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int calculateStockForBouquet(long productId) {
        /*
     * Câu SQL này thực hiện các bước:
     * 1. (Subquery 'ms'): Lấy TỔNG tồn kho của TẤT CẢ nguyên liệu từ bảng 'inventory'.
     * 2. (Subquery 'Calculations'): JOIN công thức ('formulas') với tồn kho ('ms').
     * Tính toán số lượng có thể làm được cho TỪNG nguyên liệu 
     * (FLOOR(tồn_kho / số_lượng_cần)).
     * 3. (Main Query): Lấy MIN() của tất cả các kết quả đó.
         */
        String sql = "SELECT COALESCE(MIN(buildable_units), 0) AS final_stock "
                + "FROM ( "
                + "    SELECT FLOOR(COALESCE(ms.total_stock, 0) / f.quantity) AS buildable_units "
                + "    FROM formulas f "
                + "    LEFT JOIN ( "
                + "        SELECT material_id, SUM(quantity) AS total_stock "
                + "        FROM inventory "
                + "        GROUP BY material_id "
                + "    ) ms ON f.material_id = ms.material_id "
                + "    WHERE f.product_id = ? "
                + ") AS Calculations";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("final_stock");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu có lỗi hoặc không có công thức
    }

}

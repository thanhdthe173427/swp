package dao;

import java.sql.*;
import java.util.*;
import model.Formula;
import model.Material;

public class FormulaDAO {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    // ✅ Lấy tất cả công thức (sản phẩm + list nguyên liệu)
    public List<Formula> getAllWithNames(String search) throws Exception {
        Connection conn = new DBContext().getConnection();
        List<Formula> list = new ArrayList<>();
        String sql = "SELECT f.product_id, p.name AS product_name, m.id AS material_id, m.name AS material_name, f.quantity "
                + "FROM formulas f "
                + "JOIN products p ON f.product_id = p.id "
                + "JOIN materials m ON f.material_id = m.id ";

        if (search != null && !search.trim().isEmpty()) {
            sql += "WHERE p.name LIKE ?";
        }

        try (
                PreparedStatement ps = conn.prepareStatement(sql)) {

            if (search != null && !search.trim().isEmpty()) {
                ps.setString(1, "%" + search + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                Map<Long, Formula> map = new LinkedHashMap<>();
                while (rs.next()) {
                    long productId = rs.getLong("product_id");
                    String productName = rs.getString("product_name");
                    long materialId = rs.getLong("material_id");
                    String materialName = rs.getString("material_name");
                    int quantity = rs.getInt("quantity");

                    Formula f = map.get(productId);
                    if (f == null) {
                        f = new Formula();
                        f.setProductId(productId);
                        f.setProductName(productName);
                        f.setMaterials(new ArrayList<>());
                        map.put(productId, f);
                    }

                    // Dùng Material làm container tạm để lưu id, name, quantity
                    Material m = new Material();
                    m.setId(materialId);
                    m.setName(materialName);
                    m.setQuantity(quantity); // quantity từ formulas
                    f.getMaterials().add(m);
                }
                list.addAll(map.values());
            }
        }
        return list;
    }

    // ✅ Lấy nguyên liệu theo product_id
    public List<Material> getMaterialsByProductId(long productId) throws Exception {
        Connection conn = new DBContext().getConnection();
        List<Material> materials = new ArrayList<>();
        String sql = "SELECT m.id, m.name, f.quantity FROM formulas f "
                + "JOIN materials m ON f.material_id = m.id "
                + "WHERE f.product_id = ?";
        try (
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Material m = new Material();
                    m.setId(rs.getLong("id"));
                    m.setName(rs.getString("name"));
                    m.setQuantity(rs.getInt("quantity"));
                    materials.add(m);
                }
            }
        }
        return materials;
    }

    // ✅ Xóa toàn bộ nguyên liệu của 1 sản phẩm
    public void deleteByProduct(long productId) throws Exception {
        Connection conn = new DBContext().getConnection();
        String sql = "DELETE FROM formulas WHERE product_id = ?";
        try (
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.executeUpdate();
        }
    }

    // ✅ Thêm mới nhiều nguyên liệu cho 1 sản phẩm
    public void addFormulas(long productId, Map<Long, Integer> materialQuantities) throws Exception {
        Connection conn = new DBContext().getConnection();
        if (materialQuantities == null || materialQuantities.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO formulas (product_id, material_id, quantity) VALUES (?, ?, ?)";

        try (
                PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Map.Entry<Long, Integer> entry : materialQuantities.entrySet()) {
                ps.setLong(1, productId);
                ps.setLong(2, entry.getKey());
                ps.setInt(3, entry.getValue());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

}

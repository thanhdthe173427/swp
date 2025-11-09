package dao;

import model.Material;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class MaterialDAO {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    // CREATE
    public void add(Material material) {
        String sql = "INSERT INTO materials (id, name, description, unit, cost_price, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
        
        // Sử dụng try-with-resources để đảm bảo conn và ps luôn được đóng
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, material.getId()); // id lấy từ product
            ps.setString(2, material.getName());
            ps.setString(3, material.getDescription());
            ps.setString(4, material.getUnit());
            ps.setBigDecimal(5, material.getCostPrice());
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi ra console để debug
        }
    }
  
    // READ ALL
    public List<Material> getAll() {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM materials";

        // Sử dụng try-with-resources
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Material m = new Material(
                        rs.getLong("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("unit"),
                        rs.getBigDecimal("cost_price"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi
        }
        // Luôn trả về list (sẽ là list rỗng nếu có lỗi)
        return list;
    }

    // READ by ID
    public Material getById(long id) {
        String sql = "SELECT * FROM materials WHERE id = ?";
        
        // Sử dụng try-with-resources
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Material(
                            rs.getLong("id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("unit"),
                            rs.getBigDecimal("cost_price"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("updated_at")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Trả về null nếu không tìm thấy hoặc có lỗi
        return null;
    }

    // UPDATE
    public void update(Material material) {
        String sql = "UPDATE materials SET name=?, description=?, unit=?, cost_price=?, updated_at=NOW() WHERE id=?";
        
        // Sử dụng try-with-resources
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, material.getName());
            ps.setString(2, material.getDescription());
            ps.setString(3, material.getUnit());
            ps.setBigDecimal(4, material.getCostPrice());
            ps.setLong(5, material.getId());
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // DELETE
    public void delete(long id) {
        String sql = "DELETE FROM materials WHERE id=?";
        
        // Sử dụng try-with-resources
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, id);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        // Khối try-catch trong main vẫn giữ nguyên là tốt
        // vì các phương thức DAO bây giờ không ném lỗi
        try {
            MaterialDAO dao = new MaterialDAO();
            List<Material> materials = dao.getAll();

            for (Material m : materials) {
                System.out.println(
                        m.getId() + " | "
                        + m.getName() + " | "
                        + m.getDescription() + " | "
                        + m.getUnit() + " | "
                        + m.getCostPrice() + " | "
                        + m.getCreatedAt() + " | "
                        + m.getUpdatedAt()
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Material> search(String keyword) {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM materials WHERE name LIKE ? OR description LIKE ?";
        
        // Sử dụng try-with-resources
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Material(
                            rs.getLong("id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("unit"),
                            rs.getBigDecimal("cost_price"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("updated_at")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Trả về list rỗng nếu có lỗi
        return list;
    }
}
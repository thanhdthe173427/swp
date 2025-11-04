package dao;

import model.Material;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class MaterialDAO {

    private DBContext db;
    
    public MaterialDAO() {
        db = new DBContext();
    }

    // CREATE
    public void add(Material material) throws SQLException {
    String sql = "INSERT INTO materials (id, name, description, unit, cost_price, created_at, updated_at) " +
                 "VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
    try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
        ps.setLong(1, material.getId()); // id lấy từ product
        ps.setString(2, material.getName());
        ps.setString(3, material.getDescription());
        ps.setString(4, material.getUnit());
        ps.setBigDecimal(5, material.getCostPrice());
        ps.executeUpdate();
        }
    }


    // READ ALL
    public List<Material> getAll() throws SQLException {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM materials";
        try (PreparedStatement ps = db.connection.prepareStatement(sql);
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
        }
        return list;
    }

    // READ by ID
    public Material getById(long id) throws SQLException {
        String sql = "SELECT * FROM materials WHERE id = ?";
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
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
        }
        return null;
    }

    // UPDATE
    public void update(Material material) throws SQLException {
        String sql = "UPDATE materials SET name=?, description=?, unit=?, cost_price=?, updated_at=NOW() WHERE id=?";
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setString(1, material.getName());
            ps.setString(2, material.getDescription());
            ps.setString(3, material.getUnit());
            ps.setBigDecimal(4, material.getCostPrice());
            ps.setLong(5, material.getId());
            ps.executeUpdate();
        }
    }

    // DELETE
    public void delete(long id) throws SQLException {
        String sql = "DELETE FROM materials WHERE id=?";
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }
    
    public static void main(String[] args) {
        try {
            // Lấy connection từ DBContext (bạn thay bằng cách lấy connection của bạn)

            MaterialDAO dao = new MaterialDAO();
            List<Material> materials = dao.getAll();

            for (Material m : materials) {
                System.out.println(
                        m.getId() + " | " +
                        m.getName() + " | " +
                        m.getDescription() + " | " +
                        m.getUnit() + " | " +
                        m.getCostPrice() + " | " +
                        m.getCreatedAt() + " | " +
                        m.getUpdatedAt()
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
     public List<Material> search(String keyword) throws SQLException {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM materials WHERE name LIKE ? OR description LIKE ?";
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
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
        }
        return list;
    }
}

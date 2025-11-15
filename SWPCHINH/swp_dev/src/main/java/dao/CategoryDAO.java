package dao;

import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    public List<Category> getAll() {
        conn = new DBContext().getConnection();
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getLong("id"));
                c.setParentId(rs.getLong("parent_id"));
                c.setSlug(rs.getString("slug"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setIsActive(rs.getBoolean("is_active"));
                c.setCreatedAt(rs.getDate("created_at"));
                c.setUpdatedAt(rs.getDate("updated_at"));
                list.add(c);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Category getById(long id) {
        conn = new DBContext().getConnection();
        String sql = "SELECT * FROM categories WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Category c = new Category();
                c.setId(rs.getLong("id"));
                c.setParentId(rs.getLong("parent_id"));
                c.setSlug(rs.getString("slug"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setIsActive(rs.getBoolean("is_active"));
                c.setCreatedAt(rs.getDate("created_at"));
                c.setUpdatedAt(rs.getDate("updated_at"));
                return c;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void add(Category c) {
        conn = new DBContext().getConnection();
        String sql = "INSERT INTO categories(parent_id, slug, name, description, is_active, created_at, updated_at) VALUES (?,?,?,?,?,?,?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            if (c.getParentId() != null) {
                ps.setLong(1, c.getParentId());
            } else {
                ps.setNull(1, Types.BIGINT);
            }
            ps.setString(2, c.getSlug());
            ps.setString(3, c.getName());
            ps.setString(4, c.getDescription());
            ps.setBoolean(5, c.isIsActive());
            ps.setDate(6, new java.sql.Date(System.currentTimeMillis()));
            ps.setDate(7, new java.sql.Date(System.currentTimeMillis()));
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Category c) {
        conn = new DBContext().getConnection();
        String sql = "UPDATE categories SET slug=?, name=?, description=?, is_active=?, updated_at=? WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, c.getSlug());
            ps.setString(2, c.getName());
            ps.setString(3, c.getDescription());
            ps.setBoolean(4, c.isIsActive());
            ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            ps.setLong(6, c.getId());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(long id) {
        conn = new DBContext().getConnection();
        String sql = "DELETE FROM categories WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String createSlug(String name) {
        if (name == null) {
            return null;
        }
        return name.toLowerCase()
                .trim()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-");
    }

}

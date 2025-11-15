/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.Warehouse;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WarehouseDAO {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    // Lấy tất cả kho
    public List<Warehouse> getAll() {
        conn = new DBContext().getConnection();
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT * FROM warehouses";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setId(rs.getLong("id"));
                w.setCode(rs.getString("code"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setIsActive(rs.getBoolean("is_active"));
                list.add(w);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy kho theo ID
    public Warehouse getById(long id) {
        conn = new DBContext().getConnection();
        String sql = "SELECT * FROM warehouses WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Warehouse w = new Warehouse();
                w.setId(rs.getLong("id"));
                w.setCode(rs.getString("code"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setIsActive(rs.getBoolean("is_active"));
                rs.close();
                ps.close();
                return w;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tìm kiếm kho theo tên hoặc mã
    public List<Warehouse> search(String keyword) {
        conn = new DBContext().getConnection();
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT * FROM warehouses WHERE name LIKE ? OR code LIKE ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setId(rs.getLong("id"));
                w.setCode(rs.getString("code"));
                w.setName(rs.getString("name"));
                w.setAddress(rs.getString("address"));
                w.setIsActive(rs.getBoolean("is_active"));
                list.add(w);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm kho mới
    public void add(Warehouse w) {
        conn = new DBContext().getConnection();
        String sql = "INSERT INTO warehouses(code, name, address, is_active) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, w.getCode());
            ps.setString(2, w.getName());
            ps.setString(3, w.getAddress());
            ps.setBoolean(4, w.isIsActive());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật thông tin kho
    public void update(Warehouse w) {
        conn = new DBContext().getConnection();
        String sql = "UPDATE warehouses SET code=?, name=?, address=?, is_active=? WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, w.getCode());
            ps.setString(2, w.getName());
            ps.setString(3, w.getAddress());
            ps.setBoolean(4, w.isIsActive());
            ps.setLong(5, w.getId());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa kho
    public void delete(long id) {
        conn = new DBContext().getConnection();
        String sql = "DELETE FROM warehouses WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

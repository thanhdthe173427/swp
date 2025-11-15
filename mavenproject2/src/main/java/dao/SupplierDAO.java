package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Supplier;

public class SupplierDAO {

    private DBContext db;

    public SupplierDAO() {
        db = new DBContext();
    }

    // Lấy tất cả supplier
    public List<Supplier> getAll() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM suppliers";

        try (PreparedStatement ps = db.connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToSupplier(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy supplier theo id
    public Supplier getById(long id) {
        String sql = "SELECT * FROM suppliers WHERE id = ?";
        Supplier s = null;

        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    s = mapResultSetToSupplier(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return s;
    }

    // Thêm supplier mới
    public boolean add(Supplier s) {
        String sql = """
            INSERT INTO suppliers 
            (name, contact_name, contact_phone, contact_email, address, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, NOW(), NOW())
        """;

        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getContactName());
            ps.setString(3, s.getContactPhone());
            ps.setString(4, s.getContactEmail());
            ps.setString(5, s.getAddress());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật supplier
    public boolean update(Supplier s) {
        String sql = """
            UPDATE suppliers 
            SET name = ?, contact_name = ?, contact_phone = ?, contact_email = ?, address = ?, updated_at = NOW()
            WHERE id = ?
        """;

        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getContactName());
            ps.setString(3, s.getContactPhone());
            ps.setString(4, s.getContactEmail());
            ps.setString(5, s.getAddress());
            ps.setLong(6, s.getId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa supplier
    public boolean delete(long id) {
        String sql = "DELETE FROM suppliers WHERE id = ?";
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ---------------- Utility ----------------
    private Supplier mapResultSetToSupplier(ResultSet rs) throws SQLException {
        Supplier s = new Supplier();
        s.setId(rs.getLong("id"));
        s.setName(rs.getString("name"));
        s.setContactName(rs.getString("contact_name"));
        s.setContactPhone(rs.getString("contact_phone"));
        s.setContactEmail(rs.getString("contact_email"));
        s.setAddress(rs.getString("address"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setUpdatedAt(rs.getTimestamp("updated_at"));
        return s;
    }
}

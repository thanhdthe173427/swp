package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Inventory;

public class InventoryDAO {

    private DBContext db;

    public InventoryDAO() {
        db = new DBContext();
    }

    // Lấy tất cả tồn kho (kèm tên kho & sản phẩm)
    public List<Inventory> getAll() {
        List<Inventory> list = new ArrayList<>();
        String sql = """
            SELECT i.*, p.name AS product_name, w.name AS warehouse_name
            FROM inventory i
            JOIN products p ON i.product_id = p.id
            JOIN warehouses w ON i.warehouse_id = w.id
            ORDER BY w.name, p.name
        """;
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Inventory inv = new Inventory();
                inv.setId(rs.getLong("id"));
                inv.setProductId(rs.getLong("product_id"));
                inv.setWarehouseId(rs.getLong("warehouse_id"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setUpdatedAt(rs.getTimestamp("updated_at"));
                inv.setProductName(rs.getString("product_name"));
                inv.setWarehouseName(rs.getString("warehouse_name"));
                list.add(inv);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tồn kho theo product và warehouse
    public Inventory getByProductAndWarehouse(long productId, long warehouseId) {
        String sql = """
            SELECT i.*, p.name AS product_name, w.name AS warehouse_name
            FROM inventory i
            JOIN products p ON i.product_id = p.id
            JOIN warehouses w ON i.warehouse_id = w.id
            WHERE i.product_id = ? AND i.warehouse_id = ?
        """;
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, productId);
            ps.setLong(2, warehouseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Inventory inv = new Inventory();
                inv.setId(rs.getLong("id"));
                inv.setProductId(rs.getLong("product_id"));
                inv.setWarehouseId(rs.getLong("warehouse_id"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setUpdatedAt(rs.getTimestamp("updated_at"));
                inv.setProductName(rs.getString("product_name"));
                inv.setWarehouseName(rs.getString("warehouse_name"));
                rs.close();
                ps.close();
                return inv;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm mới hoặc cập nhật tồn kho khi nhập hàng
    public void addOrUpdate(long productId, long warehouseId, int qtyToAdd) {
        Inventory inv = getByProductAndWarehouse(productId, warehouseId);
        try {
            if (inv == null) {
                // Thêm mới
                String insert = "INSERT INTO inventory (product_id, warehouse_id, quantity, updated_at) VALUES (?, ?, ?, NOW())";
                PreparedStatement ps = db.connection.prepareStatement(insert);
                ps.setLong(1, productId);
                ps.setLong(2, warehouseId);
                ps.setInt(3, qtyToAdd);
                ps.executeUpdate();
                ps.close();
            } else {
                // Cập nhật cộng dồn số lượng
                String update = "UPDATE inventory SET quantity = quantity + ?, updated_at = NOW() WHERE product_id = ? AND warehouse_id = ?";
                PreparedStatement ps = db.connection.prepareStatement(update);
                ps.setInt(1, qtyToAdd);
                ps.setLong(2, productId);
                ps.setLong(3, warehouseId);
                ps.executeUpdate();
                ps.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật thủ công số lượng (ví dụ chỉnh trong admin)
    public void updateQuantity(long productId, long warehouseId, int newQty) {
        String sql = "UPDATE inventory SET quantity = ?, updated_at = NOW() WHERE product_id = ? AND warehouse_id = ?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setInt(1, newQty);
            ps.setLong(2, productId);
            ps.setLong(3, warehouseId);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa dòng tồn kho (ít khi dùng)
    public void delete(long productId, long warehouseId) {
        String sql = "DELETE FROM inventory WHERE product_id = ? AND warehouse_id = ?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, productId);
            ps.setLong(2, warehouseId);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy tất cả tồn kho theo warehouseId
    public List<Inventory> getByWarehouse(long warehouseId) {
        List<Inventory> list = new ArrayList<>();
        String sql = """
        SELECT i.*, p.name AS product_name, w.name AS warehouse_name
        FROM inventory i
        JOIN products p ON i.product_id = p.id
        JOIN warehouses w ON i.warehouse_id = w.id
        WHERE i.warehouse_id = ?
        ORDER BY p.name
    """;
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Inventory inv = new Inventory();
                inv.setId(rs.getLong("id"));
                inv.setProductId(rs.getLong("product_id"));
                inv.setWarehouseId(rs.getLong("warehouse_id"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setUpdatedAt(rs.getTimestamp("updated_at"));
                inv.setProductName(rs.getString("product_name"));
                inv.setWarehouseName(rs.getString("warehouse_name"));
                list.add(inv);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}

package dao;

import model.Inventory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    private DBContext db;

    public InventoryDAO() {
        db = new DBContext();
    }

    // Lấy tất cả tồn kho theo warehouseId
    public List<Inventory> getByWarehouse(Long warehouseId) {
        this.syncInventoryQuantities();

        List<Inventory> list = new ArrayList<>();
        String sql = """
        SELECT i.id, i.material_id, i.warehouse_id, i.quantity, i.updated_at, m.name AS material_name
        FROM inventory i
        LEFT JOIN materials m ON i.material_id = m.id
        WHERE i.warehouse_id = ? OR (i.warehouse_id IS NULL AND ? IS NULL)
        ORDER BY i.material_id
    """;

        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            if (warehouseId != null) {
                ps.setLong(1, warehouseId);
                ps.setLong(2, warehouseId);
            } else {
                ps.setNull(1, Types.BIGINT);
                ps.setNull(2, Types.BIGINT);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Inventory inv = new Inventory();
                    inv.setId(rs.getLong("id"));
                    inv.setMaterialId(rs.getLong("material_id"));
                    inv.setWarehouseId(rs.getObject("warehouse_id") != null ? rs.getLong("warehouse_id") : null);
                    inv.setQuantity(rs.getInt("quantity"));
                    inv.setUpdatedAt(rs.getTimestamp("updated_at"));
                    inv.setMaterialName(rs.getString("material_name")); // ✅ đây mới là tên vật liệu
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy tồn kho theo material + warehouse
    public Inventory getByMaterialAndWarehouse(Long materialId, Long warehouseId) {
        String sql = """
            SELECT *
            FROM inventory
            WHERE material_id=? AND (warehouse_id=? OR (warehouse_id IS NULL AND ? IS NULL))
        """;
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setLong(1, materialId);
            if (warehouseId != null) {
                ps.setLong(2, warehouseId);
                ps.setLong(3, warehouseId);
            } else {
                ps.setNull(2, Types.BIGINT);
                ps.setNull(3, Types.BIGINT);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Inventory inv = new Inventory();
                    inv.setId(rs.getLong("id"));
                    inv.setMaterialId(rs.getLong("material_id"));
                    inv.setWarehouseId(rs.getObject("warehouse_id") != null ? rs.getLong("warehouse_id") : null);
                    inv.setQuantity(rs.getInt("quantity"));
                    inv.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return inv;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm mới hoặc cộng tồn kho
    public void addOrUpdateMaterial(Long materialId, Long warehouseId, int qtyToAdd) {
        Inventory inv = getByMaterialAndWarehouse(materialId, warehouseId);
        try {
            if (inv == null) {
                String insert = "INSERT INTO inventory(material_id, warehouse_id, quantity, updated_at) VALUES (?, ?, ?, NOW())";
                try (PreparedStatement ps = db.connection.prepareStatement(insert)) {
                    ps.setLong(1, materialId);
                    if (warehouseId != null) {
                        ps.setLong(2, warehouseId);
                    } else {
                        ps.setNull(2, Types.BIGINT);
                    }
                    ps.setInt(3, qtyToAdd);
                    ps.executeUpdate();
                }
            } else {
                String update = """
                    UPDATE inventory
                    SET quantity = quantity + ?, updated_at = NOW()
                    WHERE material_id=? AND (warehouse_id=? OR (warehouse_id IS NULL AND ? IS NULL))
                """;
                try (PreparedStatement ps = db.connection.prepareStatement(update)) {
                    ps.setInt(1, qtyToAdd);
                    ps.setLong(2, materialId);
                    if (warehouseId != null) {
                        ps.setLong(3, warehouseId);
                        ps.setLong(4, warehouseId);
                    } else {
                        ps.setNull(3, Types.BIGINT);
                        ps.setNull(4, Types.BIGINT);
                    }
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void syncInventoryQuantities() {
        String sql = """
        UPDATE inventory i
        JOIN (
            SELECT 
                b.material_id,
                COALESCE(SUM(b.qty_reserved), 0) AS total_in,
                COALESCE(SUM(oi.quantity), 0) AS total_sold,
                (COALESCE(SUM(b.qty_reserved), 0) - COALESCE(SUM(oi.quantity), 0)) AS new_quantity
            FROM batches b
            LEFT JOIN order_items oi ON oi.batch_id = b.id
            GROUP BY b.material_id
        ) AS calc ON calc.material_id = i.material_id
        SET i.quantity = calc.new_quantity,
            i.updated_at = NOW();
    """;

        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            int updated = ps.executeUpdate();
            System.out.println("✅ Inventory quantities synced: " + updated + " rows updated.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

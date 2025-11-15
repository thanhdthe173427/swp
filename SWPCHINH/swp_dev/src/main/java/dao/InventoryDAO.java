package dao;

import model.Inventory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    public static void main(String[] args) {
        InventoryDAO d = new InventoryDAO();
        Connection conn = null; // Khai báo bên ngoài
        
        try {
            conn = new DBContext().getConnection();
            
            // 1. TẮT AUTO-COMMIT (Đây là mấu chốt)
            conn.setAutoCommit(false); 
            
            System.out.println("Bắt đầu transaction...");
            
            // 2. Gọi hàm deductStock
            // Thử trừ 4 cho material_id = 4
            d.deductStock(conn, 2, 4); 
            
            // 3. Nếu không có lỗi, commit transaction
            conn.commit();
            System.out.println("✅ Trừ kho thành công! Đã commit.");

        } catch (SQLException e) {
            // 4. Nếu có lỗi (ví dụ: "Không đủ nguyên liệu")
            System.err.println("LỖI: " + e.getMessage());
            System.out.println("⚠️ Đang rollback transaction...");
            if (conn != null) {
                try {
                    conn.rollback(); // Hoàn tác mọi thay đổi
                    System.out.println("Rollback thành công.");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            // 5. Luôn đóng connection
            if (conn != null) {
                try {
                    conn.close();
                    System.out.println("Đã đóng connection.");
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    public void deductStock(Connection conn, long materialId, int quantityToDeduct) throws SQLException {

        int remainingToDeduct = quantityToDeduct;

        // 1. Truy vấn tất cả kho CÓ HÀNG, sắp xếp theo thứ tự (ví dụ: id kho)
        //    Dùng "FOR UPDATE" để khóa các dòng này lại, tránh người khác mua cùng lúc
        String sqlSelect = "SELECT id, quantity FROM inventory "
                + "WHERE material_id = ? AND quantity > 0 "
                + "ORDER BY id ASC FOR UPDATE"; // Sắp xếp theo ID kho

        String sqlUpdate = "UPDATE inventory SET quantity = ? WHERE id = ?";

        try (PreparedStatement psSelect = conn.prepareStatement(sqlSelect)) {
            psSelect.setLong(1, materialId);

            try (ResultSet rs = psSelect.executeQuery()) {

                while (rs.next() && remainingToDeduct > 0) {
                    long inventoryId = rs.getLong("id"); // ID của dòng inventory
                    int stockInThisWarehouse = rs.getInt("quantity");

                    int newStock;

                    if (stockInThisWarehouse >= remainingToDeduct) {
                        // Kho này đủ hàng
                        newStock = stockInThisWarehouse - remainingToDeduct;
                        remainingToDeduct = 0; // Đã trừ đủ
                    } else {
                        // Kho này không đủ, trừ hết kho này và chuyển sang kho tiếp
                        newStock = 0;
                        remainingToDeduct = remainingToDeduct - stockInThisWarehouse;
                    }

                    // Cập nhật lại số lượng trong kho này
                    try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                        psUpdate.setInt(1, newStock);
                        psUpdate.setLong(2, inventoryId);
                        psUpdate.executeUpdate();
                    }
                }
            }
        }

        // 6. Nếu sau khi lặp hết các kho mà vẫn còn hàng cần trừ
        if (remainingToDeduct > 0) {
            // Ném lỗi để báo hiệu Rollback
            throw new SQLException("Không đủ nguyên liệu (ID: " + materialId + ") trong kho. "
                    + "Còn thiếu: " + remainingToDeduct);
        }
    }

    // Lấy tất cả tồn kho theo warehouseId
    public List<Inventory> getByWarehouse(Long warehouseId) {
        Connection conn = new DBContext().getConnection();
//        this.syncInventoryQuantities();

        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.id, i.material_id, i.warehouse_id, i.quantity, i.updated_at, m.name AS material_name        FROM inventory i        LEFT JOIN materials m ON i.material_id = m.id        WHERE i.warehouse_id = ? OR (i.warehouse_id IS NULL AND ? IS NULL)        ORDER BY i.material_id";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
        Connection conn = new DBContext().getConnection();
        String sql = " SELECT *            FROM inventory            WHERE material_id=? AND (warehouse_id=? OR (warehouse_id IS NULL AND ? IS NULL))";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
        Connection conn = new DBContext().getConnection();
        Inventory inv = getByMaterialAndWarehouse(materialId, warehouseId);
        try {
            if (inv == null) {
                String insert = "INSERT INTO inventory(material_id, warehouse_id, quantity, updated_at) VALUES (?, ?, ?, NOW())";
                try (PreparedStatement ps = conn.prepareStatement(insert)) {
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
                String update = " UPDATE inventory  SET quantity = quantity + ?, updated_at = NOW()   WHERE material_id=? AND warehouse_id=?";
                try (PreparedStatement ps = conn.prepareStatement(update)) {
                    ps.setInt(1, qtyToAdd);
                    ps.setLong(2, materialId);
                    ps.setLong(3, warehouseId);
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateQuantity(Long materialId, Long warehouseId, int qtyToAdd) {
        String updateSql = "UPDATE inventory "
                + "SET quantity = ?, updated_at = NOW() "
                + "WHERE id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(updateSql)) {

            ps.setInt(1, qtyToAdd);
            ps.setLong(2, materialId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected == 0) {
                System.out.println("⚠️ Không tìm thấy inventory để update: id=" + materialId);
            } else {
                System.out.println("✅ Cập nhật thành công inventory id=" + materialId);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

//    public void syncInventoryQuantities() {
//        Connection conn = new DBContext().getConnection();
//        String sql = "UPDATE inventory i        JOIN (            SELECT                 b.material_id,                COALESCE(SUM(b.qty_reserved), 0) AS total_in,                COALESCE(SUM(oi.quantity), 0) AS total_sold,                (COALESCE(SUM(b.qty_reserved), 0) - COALESCE(SUM(oi.quantity), 0)) AS new_quantity            FROM batches b            LEFT JOIN order_items oi ON oi.batch_id = b.id            GROUP BY b.material_id        ) AS calc ON calc.material_id = i.material_id        SET i.quantity = calc.new_quantity,            i.updated_at = NOW();";
//
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            int updated = ps.executeUpdate();
//            System.out.println("✅ Inventory quantities synced: " + updated + " rows updated.");
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
    public int getTotalQuantityByMaterialId(long materialId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) AS total_qty FROM inventory WHERE material_id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, materialId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_qty"); // trả về tổng quantity
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // mặc định 0 nếu lỗi
    }

}

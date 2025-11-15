package dao;

import model.Batch;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BatchDAO {

    private DBContext db;

    public BatchDAO() {
        db = new DBContext();
    }

    // Lấy tất cả batch
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    public List<Batch> getAll() {
        List<Batch> list = new ArrayList<>();
        String sql = "SELECT * FROM batches";
        try (
             PreparedStatement ps = db.connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Batch b = new Batch();
                b.setId(rs.getLong("id"));
                b.setMaterialId(rs.getLong("material_id"));
                b.setWarehouseId(rs.getLong("warehouse_id"));
                b.setSupplierId(rs.getLong("supplier_id"));
                b.setBatchCode(rs.getString("batch_code"));
                b.setMfgDate(rs.getDate("mfg_date"));
                b.setQtyReserved(rs.getInt("qty_reserved"));

                // 👉 Tính tồn kho tạm thời:
                int soldQty = orderItemDAO.getSoldQuantityByBatchId(b.getId());
                int qtyOnHand = b.getQtyReserved() - soldQty;
                b.setQtyOnHand(Math.max(qtyOnHand, 0)); // tránh âm

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy batch theo ID
    public Batch getById(long id) {
        String sql = "SELECT * FROM batches WHERE id=?";
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBatch(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tìm batch theo batch_code
    public List<Batch> searchByBatchCode(String keyword) {
        List<Batch> list = new ArrayList<>();
        String sql = "SELECT * FROM batches WHERE batch_code LIKE ?";
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBatch(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm batch mới
    public void add(Batch b) {
        String sql = """
            INSERT INTO batches(material_id, warehouse_id, supplier_id, batch_code, mfg_date, qty_on_hand, qty_reserved)
            VALUES (?,?,?,?,?,?,?)
        """;
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {

            setNullableLong(ps, 1, b.getMaterialId());
            setNullableLong(ps, 2, b.getWarehouseId());
            setNullableLong(ps, 3, b.getSupplierId());
            ps.setString(4, b.getBatchCode());
            setNullableDate(ps, 5, b.getMfgDate());
            ps.setInt(6, b.getQtyOnHand());
            ps.setInt(7, b.getQtyReserved());

            ps.executeUpdate();

            // Cập nhật tồn kho
            InventoryDAO inventoryDao = new InventoryDAO();
            inventoryDao.addOrUpdateMaterial(b.getMaterialId(), b.getWarehouseId(), b.getQtyOnHand());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật batch
    public void update(Batch b) {
        String sql = """
            UPDATE batches 
            SET material_id=?, warehouse_id=?, supplier_id=?, batch_code=?, mfg_date=?, qty_on_hand=?, qty_reserved=?
            WHERE id=?
        """;
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {

            setNullableLong(ps, 1, b.getMaterialId());
            setNullableLong(ps, 2, b.getWarehouseId());
            setNullableLong(ps, 3, b.getSupplierId());
            ps.setString(4, b.getBatchCode());
            setNullableDate(ps, 5, b.getMfgDate());
            ps.setInt(6, b.getQtyOnHand());
            ps.setInt(7, b.getQtyReserved());
            ps.setLong(8, b.getId());

            ps.executeUpdate();

            InventoryDAO inventoryDao = new InventoryDAO();
            inventoryDao.addOrUpdateMaterial(b.getMaterialId(), b.getWarehouseId(), b.getQtyOnHand());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa batch
    public void delete(long id) {
        String sql = "DELETE FROM batches WHERE id=?";
        try (PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ---------------- Utility ----------------
    private Batch mapResultSetToBatch(ResultSet rs) throws SQLException {
        Batch b = new Batch();
        b.setId(rs.getLong("id"));
        b.setMaterialId(rs.getLong("material_id"));
        b.setWarehouseId(rs.getLong("warehouse_id"));
        b.setSupplierId(rs.getLong("supplier_id"));
        b.setBatchCode(rs.getString("batch_code"));
        b.setMfgDate(rs.getDate("mfg_date"));
        b.setQtyOnHand(rs.getInt("qty_on_hand"));
        b.setQtyReserved(rs.getInt("qty_reserved"));
        return b;
    }

    private void setNullableLong(PreparedStatement ps, int index, Long value) throws SQLException {
        if (value != null) ps.setLong(index, value);
        else ps.setNull(index, Types.BIGINT);
    }

    private void setNullableDate(PreparedStatement ps, int index, java.util.Date date) throws SQLException {
        if (date != null) ps.setDate(index, new java.sql.Date(date.getTime()));
        else ps.setNull(index, Types.DATE);
    }
}

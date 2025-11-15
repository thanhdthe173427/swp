package dao;

import model.Batch;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BatchDAO {

    // ✅ Lấy tất cả các lô hàng
    public List<Batch> getAll() {
        List<Batch> list = new ArrayList<>();
        String sql = "SELECT id, warehouse_id, supplier_invoice_id, batch_code, "
                   + "mfg_date, expiry_date, qty_on_hand, qty_reserved, "
                   + "material_id, supplier_id "
                   + "FROM batches";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToBatch(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ Lấy batch theo ID
    public Batch getById(long id) {
        String sql = "SELECT id, warehouse_id, supplier_invoice_id, batch_code, "
                   + "mfg_date, expiry_date, qty_on_hand, qty_reserved, "
                   + "material_id, supplier_id "
                   + "FROM batches WHERE id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBatch(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Tìm batch theo batch_code
    public List<Batch> searchByBatchCode(String keyword) {
        List<Batch> list = new ArrayList<>();
        String sql = "SELECT id, warehouse_id, supplier_invoice_id, batch_code, "
                   + "mfg_date, expiry_date, qty_on_hand, qty_reserved, "
                   + "material_id, supplier_id "
                   + "FROM batches WHERE batch_code LIKE ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBatch(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Thêm batch mới
    public void add(Batch b) {
        String sql = "INSERT INTO batches(material_id, warehouse_id, supplier_id, supplier_invoice_id, "
                   + "batch_code, mfg_date, expiry_date, qty_on_hand, qty_reserved) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setNullableLong(ps, 1, b.getMaterialId());
            setNullableLong(ps, 2, b.getWarehouseId());
            setNullableLong(ps, 3, b.getSupplierId());
            setNullableLong(ps, 4, b.getSupplierInvoiceId());
            ps.setString(5, b.getBatchCode());
            setNullableDate(ps, 6, b.getMfgDate());
            setNullableDate(ps, 7, b.getExpiryDate());
            ps.setInt(8, b.getQtyOnHand());
            ps.setInt(9, b.getQtyReserved());
            ps.executeUpdate();

            // ✅ Cập nhật tồn kho (nếu có InventoryDAO)
            InventoryDAO inventoryDao = new InventoryDAO();
            inventoryDao.addOrUpdateMaterial(b.getMaterialId(), b.getWarehouseId(), b.getQtyOnHand());

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật batch
    public void update(Batch b) {
        String sql = "UPDATE batches SET material_id=?, warehouse_id=?, supplier_id=?, supplier_invoice_id=?, "
                   + "batch_code=?, mfg_date=?, expiry_date=?, qty_on_hand=?, qty_reserved=? "
                   + "WHERE id=?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setNullableLong(ps, 1, b.getMaterialId());
            setNullableLong(ps, 2, b.getWarehouseId());
            setNullableLong(ps, 3, b.getSupplierId());
            setNullableLong(ps, 4, b.getSupplierInvoiceId());
            ps.setString(5, b.getBatchCode());
            setNullableDate(ps, 6, b.getMfgDate());
            setNullableDate(ps, 7, b.getExpiryDate());
            ps.setInt(8, b.getQtyOnHand());
            ps.setInt(9, b.getQtyReserved());
            ps.setLong(10, b.getId());
            ps.executeUpdate();

            InventoryDAO inventoryDao = new InventoryDAO();
            inventoryDao.addOrUpdateMaterial(b.getMaterialId(), b.getWarehouseId(), b.getQtyOnHand());

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Xóa batch
    public void delete(long id) {
        String sql = "DELETE FROM batches WHERE id=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===========================================================
    // 🔹 Utility Functions
    // ===========================================================
    private Batch mapResultSetToBatch(ResultSet rs) throws SQLException {
        Batch b = new Batch();
        b.setId(rs.getLong("id"));
        b.setWarehouseId(rs.getLong("warehouse_id"));
        b.setSupplierInvoiceId(rs.getLong("supplier_invoice_id"));
        b.setBatchCode(rs.getString("batch_code"));
        b.setMfgDate(rs.getDate("mfg_date"));
        b.setExpiryDate(rs.getDate("expiry_date"));
        b.setQtyOnHand(rs.getInt("qty_on_hand"));
        b.setQtyReserved(rs.getInt("qty_reserved"));
        b.setMaterialId(rs.getLong("material_id"));
        b.setSupplierId(rs.getLong("supplier_id"));
        return b;
    }

    private void setNullableLong(PreparedStatement ps, int index, Long value) throws SQLException {
        if (value != null) {
            ps.setLong(index, value);
        } else {
            ps.setNull(index, Types.BIGINT);
        }
    }

    private void setNullableDate(PreparedStatement ps, int index, java.util.Date date) throws SQLException {
        if (date != null) {
            ps.setDate(index, new java.sql.Date(date.getTime()));
        } else {
            ps.setNull(index, Types.DATE);
        }
    }
}

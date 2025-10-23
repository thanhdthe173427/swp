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

    public List<Batch> getAll() {
        List<Batch> list = new ArrayList<>();
        String sql = "SELECT * FROM batches";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Batch b = new Batch();
                b.setId(rs.getLong("id"));
                b.setProductId(rs.getLong("product_id"));
                b.setWarehouseId(rs.getLong("warehouse_id"));
                b.setSupplierInvoiceId(rs.getLong("supplier_invoice_id"));
                b.setBatchCode(rs.getString("batch_code"));
                b.setMfgDate(rs.getDate("mfg_date"));
                b.setExpiryDate(rs.getDate("expiry_date"));
                b.setQtyOnHand(rs.getInt("qty_on_hand"));
                b.setQtyReserved(rs.getInt("qty_reserved"));
                list.add(b);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Batch getById(long id) {
        String sql = "SELECT * FROM batches WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Batch b = new Batch();
                b.setId(rs.getLong("id"));
                b.setProductId(rs.getLong("product_id"));
                b.setWarehouseId(rs.getLong("warehouse_id"));
                b.setSupplierInvoiceId(rs.getLong("supplier_invoice_id"));
                b.setBatchCode(rs.getString("batch_code"));
                b.setMfgDate(rs.getDate("mfg_date"));
                b.setExpiryDate(rs.getDate("expiry_date"));
                b.setQtyOnHand(rs.getInt("qty_on_hand"));
                b.setQtyReserved(rs.getInt("qty_reserved"));
                return b;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Batch> searchByBatchCode(String keyword) {
        List<Batch> list = new ArrayList<>();
        String sql = "SELECT * FROM batches WHERE batch_code LIKE ?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Batch b = new Batch();
                b.setId(rs.getLong("id"));
                b.setProductId(rs.getLong("product_id"));
                b.setWarehouseId(rs.getLong("warehouse_id"));
                b.setSupplierInvoiceId(rs.getLong("supplier_invoice_id"));
                b.setBatchCode(rs.getString("batch_code"));
                b.setMfgDate(rs.getDate("mfg_date"));
                b.setExpiryDate(rs.getDate("expiry_date"));
                b.setQtyOnHand(rs.getInt("qty_on_hand"));
                b.setQtyReserved(rs.getInt("qty_reserved"));
                list.add(b);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void add(Batch b) {
        String sql = "INSERT INTO batches(product_id, warehouse_id, supplier_invoice_id, batch_code, mfg_date, expiry_date, qty_on_hand, qty_reserved) VALUES (?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, b.getProductId());
            if (b.getWarehouseId() != null) {
                ps.setLong(2, b.getWarehouseId());
            } else {
                ps.setNull(2, Types.BIGINT);
            }
            if (b.getSupplierInvoiceId() != null) {
                ps.setLong(3, b.getSupplierInvoiceId());
            } else {
                ps.setNull(3, Types.BIGINT);
            }
            ps.setString(4, b.getBatchCode());
            ps.setDate(5, new java.sql.Date(b.getMfgDate().getTime()));
            ps.setDate(6, new java.sql.Date(b.getExpiryDate().getTime()));
            ps.setInt(7, b.getQtyOnHand());
            ps.setInt(8, b.getQtyReserved());

            InventoryDAO inventoryDao = new InventoryDAO();
            inventoryDao.addOrUpdate(b.getProductId(), b.getWarehouseId(), b.getQtyOnHand());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Batch b) {
        String sql = "UPDATE batches SET product_id=?, warehouse_id=?, supplier_invoice_id=?, batch_code=?, mfg_date=?, expiry_date=?, qty_on_hand=?, qty_reserved=? WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, b.getProductId());
            if (b.getWarehouseId() != null) {
                ps.setLong(2, b.getWarehouseId());
            } else {
                ps.setNull(2, Types.BIGINT);
            }
            if (b.getSupplierInvoiceId() != null) {
                ps.setLong(3, b.getSupplierInvoiceId());
            } else {
                ps.setNull(3, Types.BIGINT);
            }
            ps.setString(4, b.getBatchCode());
            ps.setDate(5, new java.sql.Date(b.getMfgDate().getTime()));
            ps.setDate(6, new java.sql.Date(b.getExpiryDate().getTime()));
            ps.setInt(7, b.getQtyOnHand());
            ps.setInt(8, b.getQtyReserved());
            ps.setLong(9, b.getId());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(long id) {
        String sql = "DELETE FROM batches WHERE id=?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, id);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ---------------------- START: Tracking methods ----------------------
    /**
     * Lấy tổng số lượng hàng tồn theo productId
     */
    public int getTotalQtyByProductId(long productId) {
        String sql = "SELECT SUM(qty_on_hand) FROM batches WHERE product_id = ?";
        int total = 0;
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Lấy tổng số batch theo productId
     */
    public int getTotalBatchesByProductId(long productId) {
        String sql = "SELECT COUNT(*) FROM batches WHERE product_id = ?";
        int count = 0;
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    /**
     * Lấy danh sách tên kho chứa product theo productId
     */
    public List<String> getWarehouseNamesByProductId(long productId) {
        List<String> warehouses = new ArrayList<>();
        String sql = "SELECT DISTINCT w.name FROM batches b "
                + "JOIN warehouses w ON b.warehouse_id = w.id "
                + "WHERE b.product_id = ?";
        try {
            PreparedStatement ps = db.connection.prepareStatement(sql);
            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                warehouses.add(rs.getString("name"));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return warehouses;
    }
// ---------------------- END: Tracking methods ----------------------

}

package dao;

import model.SupplierInvoice;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class SupplierInvoiceDAO {

    private  Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    // Lấy tất cả hóa đơn nhà cung cấp
    public List<SupplierInvoice> getAll() {
        conn = new DBContext().getConnection();
        List<SupplierInvoice> list = new ArrayList<>();
        String sql = "SELECT * FROM supplier_invoices";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SupplierInvoice s = new SupplierInvoice();
                s.setId(rs.getLong("id"));
                s.setSupplierId(rs.getLong("supplier_id"));
                s.setInvoiceNo(rs.getString("invoice_no"));
                s.setInvoiceDate(rs.getDate("invoice_date"));
                s.setTotalAmount(rs.getBigDecimal("total_amount"));
                s.setNote(rs.getString("note"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                s.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(s);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy hóa đơn theo ID
    public SupplierInvoice getById(long id) {
        conn = new DBContext().getConnection();
        String sql = "SELECT * FROM supplier_invoices WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SupplierInvoice s = new SupplierInvoice();
                s.setId(rs.getLong("id"));
                s.setSupplierId(rs.getLong("supplier_id"));
                s.setInvoiceNo(rs.getString("invoice_no"));
                s.setInvoiceDate(rs.getDate("invoice_date"));
                s.setTotalAmount(rs.getBigDecimal("total_amount"));
                s.setNote(rs.getString("note"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                s.setUpdatedAt(rs.getTimestamp("updated_at"));
                rs.close();
                ps.close();
                return s;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tìm kiếm hóa đơn theo mã hóa đơn
    public List<SupplierInvoice> searchByInvoiceNo(String keyword) {
        conn = new DBContext().getConnection();
        List<SupplierInvoice> list = new ArrayList<>();
        String sql = "SELECT * FROM supplier_invoices WHERE invoice_no LIKE ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SupplierInvoice s = new SupplierInvoice();
                s.setId(rs.getLong("id"));
                s.setSupplierId(rs.getLong("supplier_id"));
                s.setInvoiceNo(rs.getString("invoice_no"));
                s.setInvoiceDate(rs.getDate("invoice_date"));
                s.setTotalAmount(rs.getBigDecimal("total_amount"));
                s.setNote(rs.getString("note"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                s.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(s);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm hóa đơn mới
    public void add(SupplierInvoice s) {
        conn = new DBContext().getConnection();
        String sql = "INSERT INTO supplier_invoices (supplier_id, invoice_no, invoice_date, total_amount, note, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setLong(1, s.getSupplierId());
            ps.setString(2, s.getInvoiceNo());
            ps.setDate(3, new java.sql.Date(s.getInvoiceDate().getTime()));
            ps.setBigDecimal(4, s.getTotalAmount());
            ps.setString(5, s.getNote());
            ps.setTimestamp(6, new java.sql.Timestamp(s.getCreatedAt().getTime()));
            ps.setTimestamp(7, new java.sql.Timestamp(s.getUpdatedAt().getTime()));
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật hóa đơn
    public void update(SupplierInvoice s) {
        conn = new DBContext().getConnection();
        String sql = "UPDATE supplier_invoices SET supplier_id=?, invoice_no=?, invoice_date=?, total_amount=?, note=?, updated_at=? WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setLong(1, s.getSupplierId());
            ps.setString(2, s.getInvoiceNo());
            ps.setDate(3, new java.sql.Date(s.getInvoiceDate().getTime()));
            ps.setBigDecimal(4, s.getTotalAmount());
            ps.setString(5, s.getNote());
            ps.setTimestamp(6, new java.sql.Timestamp(s.getUpdatedAt().getTime()));
            ps.setLong(7, s.getId());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa hóa đơn
    public void delete(long id) {
        conn = new DBContext().getConnection();
        String sql = "DELETE FROM supplier_invoices WHERE id=?";
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

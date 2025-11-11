package dao;

import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import model.Order;
import dao.DBContext; // class tiện ích để mở kết nối

public class OrderDAO {
    
    private DBContext db;

    public OrderDAO() {
        db = new DBContext();
    }
    
    public List<Order> getAllOrders(String keyword) throws Exception {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE order_code LIKE ? OR customer_name LIKE ? OR customer_phone LIKE ?";
        }
        sql += " ORDER BY created_at DESC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
                ps.setString(3, kw);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getLong("id"));
                o.setOrderCode(rs.getString("order_code"));
                o.setUserId(rs.getLong("user_id"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setCustomerPhone(rs.getString("customer_phone"));
                o.setBillingAddressId(rs.getLong("billing_address_id"));
                o.setShippingAddressId(rs.getLong("shipping_address_id"));
                o.setVoucherCode(rs.getString("voucher_code"));
                o.setStatus(rs.getString("status"));
                o.setPaymentStatus(rs.getString("payment_status"));
                o.setSubtotal(rs.getBigDecimal("subtotal"));
                o.setDiscountTotal(rs.getBigDecimal("discount_total"));
                o.setShippingFee(rs.getBigDecimal("shipping_fee"));
                o.setTaxTotal(rs.getBigDecimal("tax_total"));
                o.setGrandTotal(rs.getBigDecimal("grand_total"));
                o.setNote(rs.getString("note"));
                o.setPlacedAt(rs.getTimestamp("placed_at"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                o.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(o);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

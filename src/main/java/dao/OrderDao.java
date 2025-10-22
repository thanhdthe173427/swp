package dao;

import model.Order;
import model.OrderItem;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class OrderDao {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;
    
    public boolean updateOrderStatus(long orderId, String status) {
    String sql = "UPDATE orders SET status = ? WHERE id = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, status);
        ps.setLong(2, orderId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}


   // ✅ Tạo đơn hàng mới (COD hoặc VNPay)
public long createOrder(Order order, List<OrderItem> items) {
    String sqlOrder =
        "INSERT INTO orders (" +
        "order_code, user_id, customer_name, customer_phone, " +
        "billing_address_id, shipping_address_id, voucher_code, " +
        "status, payment_status, subtotal, discount_total, " +
        "shipping_fee, tax_total, grand_total, note, " +
        "placed_at, created_at, updated_at" +
        ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    String sqlItem =
        "INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) " +
        "VALUES (?, ?, ?, ?, ?)";

    long orderId = 0;

    try {
        conn = new DBContext().getConnection();
        conn.setAutoCommit(false);

        // ✅ Insert order
        PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
        psOrder.setString(1, order.getOrderCode());
        psOrder.setObject(2, order.getUserId(), Types.BIGINT);
        psOrder.setString(3, order.getCustomerName());
        psOrder.setString(4, order.getCustomerPhone());
        psOrder.setObject(5, order.getBillingAddressId(), Types.BIGINT);
        psOrder.setObject(6, order.getShippingAddressId(), Types.BIGINT);
        psOrder.setString(7, order.getVoucherCode());
        psOrder.setString(8, order.getStatus());
        psOrder.setString(9, order.getPaymentStatus());
        psOrder.setBigDecimal(10, order.getSubtotal() != null ? order.getSubtotal() : BigDecimal.ZERO);
        psOrder.setBigDecimal(11, order.getDiscountTotal() != null ? order.getDiscountTotal() : BigDecimal.ZERO);
        psOrder.setBigDecimal(12, order.getShippingFee() != null ? order.getShippingFee() : BigDecimal.ZERO);
        psOrder.setBigDecimal(13, order.getTaxTotal() != null ? order.getTaxTotal() : BigDecimal.ZERO);
        psOrder.setBigDecimal(14, order.getGrandTotal() != null ? order.getGrandTotal() : BigDecimal.ZERO);
        psOrder.setString(15, order.getNote());
        psOrder.setTimestamp(16, new Timestamp(order.getPlacedAt() != null ? order.getPlacedAt().getTime() : System.currentTimeMillis()));
        psOrder.setTimestamp(17, new Timestamp(System.currentTimeMillis()));
        psOrder.setTimestamp(18, new Timestamp(System.currentTimeMillis()));
        psOrder.executeUpdate();

        // ✅ Lấy order_id vừa tạo
        ResultSet rsKey = psOrder.getGeneratedKeys();
        if (rsKey.next()) {
            orderId = rsKey.getLong(1);
        }

        // ✅ Insert order items
        if (orderId > 0 && items != null && !items.isEmpty()) {
            PreparedStatement psItem = conn.prepareStatement(sqlItem);
            for (OrderItem item : items) {
                psItem.setLong(1, orderId);
                psItem.setLong(2, item.getProductId());
                psItem.setInt(3, item.getQuantity());
                psItem.setBigDecimal(4, item.getUnitPrice());
                psItem.setBigDecimal(5, item.getTotalPrice());
                psItem.addBatch();
            }
            psItem.executeBatch();
        }

        conn.commit();
    } catch (Exception e) {
        e.printStackTrace();
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        orderId = 0; // thất bại
    } finally {
        closeConnection();
    }

    return orderId;
}


    // ✅ Lấy danh sách tất cả đơn hàng của user
    public List<Order> getOrdersByUserId(long userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setLong(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getLong("id"));
                o.setOrderCode(rs.getString("order_code"));
                o.setUserId(rs.getLong("user_id"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setCustomerPhone(rs.getString("customer_phone"));
                o.setStatus(rs.getString("status"));
                o.setPaymentStatus(rs.getString("payment_status"));
                o.setGrandTotal(rs.getBigDecimal("grand_total"));
                o.setPlacedAt(rs.getTimestamp("placed_at"));
                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

        return list;
    }

    // ✅ Lấy chi tiết 1 đơn hàng
    public Order getOrderById(long id) {
        Order o = null;
        String sql = "SELECT * FROM orders WHERE id = ?";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                o = new Order();
                o.setId(rs.getLong("id"));
                o.setOrderCode(rs.getString("order_code"));
                o.setUserId(rs.getLong("user_id"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setCustomerPhone(rs.getString("customer_phone"));
                o.setStatus(rs.getString("status"));
                o.setPaymentStatus(rs.getString("payment_status"));
                o.setSubtotal(rs.getBigDecimal("subtotal"));
                o.setGrandTotal(rs.getBigDecimal("grand_total"));
                o.setNote(rs.getString("note"));
                o.setPlacedAt(rs.getTimestamp("placed_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

        return o;
    }

    // ✅ Đóng kết nối an toàn
    private void closeConnection() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Test nhanh
    public static void main(String[] args) {
        OrderDao dao = new OrderDao();
        List<Order> orders = dao.getOrdersByUserId(1);
        System.out.println("Số đơn hàng: " + orders.size());
        for (Order o : orders) {
            System.out.println(o.getOrderCode() + " - " + o.getGrandTotal());
        }
    }
}

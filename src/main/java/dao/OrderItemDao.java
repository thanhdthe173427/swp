package dao;

import model.OrderItem;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class OrderItemDao {

    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    // ✅ Lấy tất cả item theo Order ID
    public List<OrderItem> getItemsByOrderId(long orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setLong(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getLong("id"));
                item.setOrderId(rs.getLong("order_id"));
                item.setProductId(rs.getLong("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getBigDecimal("unit_price"));
                item.setDiscount(rs.getBigDecimal("discount"));
                item.setTotalPrice(rs.getBigDecimal("total_price"));
                item.setBatchId(rs.getLong("batch_id"));
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

        return list;
    }

    // ✅ Thêm mới OrderItem
    public int insertOrderItem(OrderItem item) {
        int rows = 0;
        String sql = "INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price, discount, total_price, batch_id) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);

            ps.setLong(1, item.getOrderId());
            ps.setObject(2, item.getProductId(), Types.BIGINT);
            ps.setString(3, item.getProductName());
            ps.setInt(4, item.getQuantity());

            // 💰 Đây chính là 2 dòng bạn hỏi
            ps.setBigDecimal(5, item.getUnitPrice());  // giá mỗi sản phẩm
            ps.setBigDecimal(6, item.getDiscount());   // giảm giá
            ps.setBigDecimal(7, item.getTotalPrice()); // tổng tiền (sau giảm)
            
            ps.setObject(8, item.getBatchId(), Types.BIGINT);

            rows = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

        return rows;
    }

    // ✅ Xóa item theo ID
    public int deleteOrderItem(long id) {
        int rows = 0;
        String sql = "DELETE FROM order_items WHERE id = ?";

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            rows = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }

        return rows;
    }

    // ✅ Đóng kết nối an toàn
    private void closeConnection() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Test nhanh
    public static void main(String[] args) {
        OrderItemDao dao = new OrderItemDao();

        // Test insert
        OrderItem item = new OrderItem();
        item.setOrderId(1);
        item.setProductId(10L);
        item.setProductName("Hoa hồng đỏ");
        item.setQuantity(3);
        item.setUnitPrice(new BigDecimal("120000"));
        item.setDiscount(new BigDecimal("0"));
        item.setTotalPrice(new BigDecimal("360000"));
        item.setBatchId(null);

        int result = dao.insertOrderItem(item);
        System.out.println("Insert result: " + result);

        // Test get list
        List<OrderItem> items = dao.getItemsByOrderId(1);
        System.out.println("Items in order 1: " + items.size());
        for (OrderItem i : items) {
            System.out.println(i.getProductName() + " - " + i.getTotalPrice());
        }
    }

    int getSoldQuantityByBatchId(long id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}

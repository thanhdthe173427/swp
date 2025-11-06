package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.OrderItem;

public class OrderItemDAO {
    
    private DBContext db;

    public OrderItemDAO() {
        db = new DBContext();
    }

    public int getSoldQuantityByBatchId(long batchId) {
        int totalSold = 0;
        String sql = "SELECT SUM(quantity) AS total_sold FROM order_items WHERE batch_id = ?";
        try (
             PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setLong(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalSold = rs.getInt("total_sold");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalSold;
    }
    
     public List<OrderItem> getItemsByOrderId(long orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = """
            SELECT oi.id, oi.order_id, oi.product_id, p.name AS product_name, 
                   oi.quantity, oi.unit_price, oi.discount, oi.total_price, oi.batch_id
            FROM order_items oi
            JOIN products p ON oi.product_id = p.id
            WHERE oi.order_id = ?
        """;

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, orderId);
            ResultSet rs = ps.executeQuery();

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
        }
        return list;
    }

}

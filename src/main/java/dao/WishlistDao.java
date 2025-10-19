package dao;

import model.WishlistItem;
import java.sql.*;
import java.util.*;

public class WishlistDao extends DBContext {

    /** ✅ Lấy danh sách sản phẩm yêu thích của user */
    public List<WishlistItem> getWishlistByUser(long userId) {
        List<WishlistItem> list = new ArrayList<>();
        String sql = "SELECT * FROM wishlist WHERE user_id = ? ORDER BY added_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                WishlistItem item = new WishlistItem();
                item.setId(rs.getLong("id"));
                item.setUserId(rs.getLong("user_id"));
                item.setProductId(rs.getLong("product_id"));
                item.setAddedAt(rs.getTimestamp("added_at"));
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /** ✅ Thêm sản phẩm vào wishlist */
    public void addToWishlist(long userId, long productId) {
        String sql = "INSERT INTO wishlist (user_id, product_id, added_at) VALUES (?, ?, NOW())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.setLong(2, productId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** ✅ Xóa sản phẩm khỏi wishlist */
    public void removeFromWishlist(long userId, long productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.setLong(2, productId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** ✅ Kiểm tra sản phẩm đã có trong wishlist chưa */
    public boolean isInWishlist(long userId, long productId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.setLong(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

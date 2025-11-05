package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.CartItem;
import model.Product;

public class CartDao extends DBContext {

    // 🔹 Lấy giỏ hàng theo user
    public Cart getCartByUserId(long userId) {
        Cart cart = null;
        String sqlCart = "SELECT * FROM carts WHERE user_id = ?";
        String sqlItems = "SELECT * FROM cart_items WHERE cart_id = ?";

        try (Connection conn = getConnection(); PreparedStatement psCart = conn.prepareStatement(sqlCart)) {

            psCart.setLong(1, userId);
            ResultSet rsCart = psCart.executeQuery();

            if (rsCart.next()) {
                cart = new Cart();
                cart.setId(rsCart.getLong("id"));
                cart.setUserId(rsCart.getLong("user_id"));
                cart.setTotalItems(rsCart.getInt("total_items"));
                cart.setTotalAmount(rsCart.getBigDecimal("total_amount"));
                cart.setCreatedAt(rsCart.getTimestamp("created_at"));
                cart.setUpdatedAt(rsCart.getTimestamp("updated_at"));

                // Lấy item
                try (PreparedStatement psItems = conn.prepareStatement(sqlItems)) {
                    psItems.setLong(1, cart.getId());
                    ResultSet rsItems = psItems.executeQuery();
                    while (rsItems.next()) {
                        CartItem item = new CartItem();
                        item.setId(rsItems.getLong("id"));
                        item.setCartId(rsItems.getLong("cart_id"));
                        item.setProductId(rsItems.getLong("product_id"));
                        item.setQuantity(rsItems.getInt("quantity"));
                        item.setUnitPrice(rsItems.getBigDecimal("unit_price"));
                        item.setProductName(rsItems.getString("product_name"));
                        item.setProductImage(rsItems.getString("product_image"));
                        cart.getItems().add(item);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cart;
    }

    // 🔹 Tạo giỏ hàng mới
    public boolean insertCart(Cart cart) {
        String sql = "INSERT INTO carts (user_id, created_at, updated_at) VALUES (?, NOW(), NOW())";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, cart.getUserId());
            int rowsAffected = ps.executeUpdate(); // Kiểm tra số dòng bị ảnh hưởng

            if (rowsAffected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    cart.setId(rs.getLong(1));  // Lấy ID giỏ hàng mới
                    System.out.println("🛒 Tạo giỏ hàng mới ID = " + cart.getId());
                    return true;  // Thành công
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;  // Không thành công (lỗi hoặc không tạo được giỏ hàng)
    }

    // 🔹 Thêm hoặc cập nhật sản phẩm trong giỏ
    /**
     *
     * @param cartId
     * @param item
     */
    public boolean addItemToCart(long cartId, CartItem item) {
        String sql = "INSERT INTO cart_items \n"
                + "(cart_id, product_id, quantity, unit_price, product_name, product_image)\n"
                + "VALUES (?, ?, ?, ?, ?,?)\n"
                + "AS new_values\n"
                + "ON DUPLICATE KEY UPDATE\n"
                + "    cart_items.quantity = cart_items.quantity + new_values.quantity,\n"
                + "    cart_items.unit_price = new_values.unit_price,\n"
                + "    cart_items.product_name = new_values.product_name,\n"
                + "    cart_items.product_image = new_values.product_image,\n"
                + "    cart_items.updated_at = NOW();";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // ✅ Bảo vệ dữ liệu null
            if (item.getProductName() == null || item.getProductImage() == null) {
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.getProductById(item.getProductId());
                if (product != null) {
                    item.setProductName(product.getName());
                    item.setProductImage(product.getUrl());
                } else {
                    // Nếu không tìm thấy sản phẩm trong DB, trả về false
                    System.err.println("❌ Không tìm thấy sản phẩm với ID: " + item.getProductId());
                    return false;
                }
            }

            // Gán giá trị vào PreparedStatement
            ps.setLong(1, cartId);
            ps.setLong(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getUnitPrice());
            ps.setString(5, item.getProductName());
            ps.setString(6, item.getProductImage());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                System.out.println("✅ Thêm/cập nhật giỏ hàng thành công (" + rows + " dòng)");
                // Chỉ tính lại tổng nếu thêm/sửa thành công
                recalculateCartTotals(cartId);
                return true;
            } else {
                System.err.println("❌ Không có dòng nào bị ảnh hưởng.");
                return false;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 🔹 Xóa toàn bộ item trong giỏ (nếu cần reset)
    public void clearCart(long cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            int rows = ps.executeUpdate();
            System.out.println("🧹 Xóa " + rows + " sản phẩm khỏi giỏ #" + cartId);
            recalculateCartTotals(cartId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🟢 Tăng / giảm số lượng
    public void updateItemQuantity(long cartId, long productId, int delta) {
        String sql = "UPDATE cart_items "
                + "SET quantity = quantity + ? "
                + "WHERE cart_id = ? AND product_id = ? AND quantity + ? > 0";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, delta);
            ps.setLong(2, cartId);
            ps.setLong(3, productId);
            ps.setInt(4, delta);
            ps.executeUpdate();

            recalculateCartTotals(cartId);
            System.out.println("✅ Cập nhật số lượng sản phẩm thành công!");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

// ❌ Xóa sản phẩm khỏi giỏ hàng
    public void removeItem(long cartId, long productId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, cartId);
            ps.setLong(2, productId);
            ps.executeUpdate();

            recalculateCartTotals(cartId);
            System.out.println("🗑️ Đã xóa sản phẩm khỏi giỏ hàng.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

// 🔁 Tính lại tổng tiền giỏ hàng
    public void recalculateCartTotals(long cartId) {
        String sql = "UPDATE carts c JOIN ( "
                + "SELECT cart_id, SUM(quantity) AS total_items, "
                + "SUM(quantity * unit_price) AS total_amount "
                + "FROM cart_items WHERE cart_id = ? GROUP BY cart_id "
                + ") t ON c.id = t.cart_id "
                + "SET c.total_items = t.total_items, "
                + "c.total_amount = t.total_amount, c.updated_at = NOW()";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, cartId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔹 Test thủ công
    public static void main(String[] args) {
        CartDao dao = new CartDao();
        long userId = 1;      // ID có thật trong bảng users
        long productId = 2;   // ID có thật trong bảng products

        System.out.println("===== 🧪 TEST CartDao START =====");

        // 1️⃣ Lấy hoặc tạo giỏ
        Cart cart = dao.getCartByUserId(userId);
        if (cart == null) {
            System.out.println("❌ Chưa có giỏ → tạo mới...");
            cart = new Cart();
            cart.setUserId(userId);
            dao.insertCart(cart);
        } else {
            System.out.println("✅ Giỏ hàng có sẵn ID: " + cart.getId());
        }

        // 2️⃣ Thêm sản phẩm vào giỏ
        CartItem item = new CartItem();
        item.setProductId(productId);
        item.setQuantity(2);
        item.setUnitPrice(new BigDecimal("55000"));
        item.setProductName("Pink Rose");
        item.setProductImage("https://cdn-icons-png.flaticon.com/512/765/765539.png");
        dao.addItemToCart(cart.getId(), item);

        // 3️⃣ In lại giỏ hàng
        Cart updatedCart = dao.getCartByUserId(userId);
        System.out.println("\n📦 Giỏ hàng user #" + userId + " (Cart ID: " + updatedCart.getId() + ")");
        System.out.println("Tổng sản phẩm: " + updatedCart.getTotalItems());
        System.out.println("Tổng tiền: " + updatedCart.getTotalAmount());
        for (CartItem i : updatedCart.getItems()) {
            System.out.printf("  • ProductID: %-3s | Qty: %-2d | Giá: %,.0fđ%n",
                    i.getProductName(), i.getQuantity(), i.getUnitPrice());
        }

        System.out.println("===== ✅ TEST CartDao COMPLETE =====");
    }
}

package model;

import java.util.*;
import java.math.BigDecimal;

public class Cart {
    private long id;
    private long userId;
    private int totalItems;             // ✅ tổng số sản phẩm trong giỏ
    private BigDecimal totalAmount;     // ✅ tổng tiền
    private Date createdAt;
    private Date updatedAt;
    private List<CartItem> items = new ArrayList<>();

    public Cart() {
        this.totalAmount = BigDecimal.ZERO;
    }

    public Cart(long id, long userId, int totalItems, BigDecimal totalAmount, Date createdAt, Date updatedAt) {
        this.id = id;
        this.userId = userId;
        this.totalItems = totalItems;
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // 🧩 Getter / Setter
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public int getTotalItems() { return totalItems; }
    public void setTotalItems(int totalItems) { this.totalItems = totalItems; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
    }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public List<CartItem> getItems() { return items; }
    public void setItems(List<CartItem> items) { this.items = items; }

    // 🧮 Tính lại tổng tiền (tự động, từ danh sách items)
    public BigDecimal calculateTotalAmount() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            if (item.getUnitPrice() != null) {
                total = total.add(item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            }
        }
        this.totalAmount = total;
        return total;
    }

    // 🔢 Tính lại tổng số lượng
    public int calculateTotalItems() {
        int total = 0;
        for (CartItem item : items) {
            total += item.getQuantity();
        }
        this.totalItems = total;
        return total;
    }

    // ➕ Thêm sản phẩm vào giỏ (local-level, khi chưa sync DB)
    public void addItem(CartItem newItem) {
        for (CartItem item : items) {
            if (item.getProductId() == newItem.getProductId()) {
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                calculateTotalItems();
                calculateTotalAmount();
                return;
            }
        }
        items.add(newItem);
        calculateTotalItems();
        calculateTotalAmount();
    }

    // ❌ Xóa sản phẩm khỏi giỏ
    public void removeItem(long productId) {
        items.removeIf(i -> i.getProductId() == productId);
        calculateTotalItems();
        calculateTotalAmount();
    }

    // 🧹 Xóa toàn bộ giỏ
    public void clear() {
        items.clear();
        totalItems = 0;
        totalAmount = BigDecimal.ZERO;
    }

    // 🧾 Debug tiện dụng
    @Override
    public String toString() {
        return String.format(
            "🛒 Cart #%d | UserID: %d | Items: %d | Total: %,.0fđ",
            id, userId, totalItems, totalAmount
        );
    }
}

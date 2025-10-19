package model;

import java.math.BigDecimal;
import java.util.Date;

public class CartItem {
    private long id;
    private long cartId;
    private long productId;
    private String productName;
    private String productImage;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
    private Date createdAt;
    private Date updatedAt;

    public CartItem() {
        this.unitPrice = BigDecimal.ZERO;
        this.totalPrice = BigDecimal.ZERO;
        this.quantity = 1;
    }

    public CartItem(long id, long cartId, long productId,String productName, String productImage, int quantity, BigDecimal unitPrice) {
        this();
        this.id = id;
        this.cartId = cartId;
        this.productId = productId;
        this.productName = productName;
        this.productImage = productImage;
        this.quantity = Math.max(1, quantity);
        this.unitPrice = unitPrice != null ? unitPrice : BigDecimal.ZERO;
        calculateTotalPrice();
    }

    // 🧩 Getter & Setter
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getCartId() { return cartId; }
    public void setCartId(long cartId) { this.cartId = cartId; }

    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) {
        this.quantity = Math.max(0, quantity);
        calculateTotalPrice();
    }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice != null ? unitPrice : BigDecimal.ZERO;
        calculateTotalPrice();
    }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice != null ? totalPrice : BigDecimal.ZERO;
    }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // 🔹 Tính tổng tiền
    public BigDecimal calculateTotalPrice() {
        if (unitPrice == null) unitPrice = BigDecimal.ZERO;
        this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));
        return totalPrice;
    }

    // 🔹 Tăng / giảm số lượng
    public void increaseQuantity(int amount) {
        this.quantity += Math.max(1, amount);
        calculateTotalPrice();
    }

    public void decreaseQuantity(int amount) {
        this.quantity = Math.max(0, this.quantity - Math.max(1, amount));
        calculateTotalPrice();
    }

    // 🔹 Hiển thị định dạng tiền
    public String getFormattedUnitPrice() {
        return String.format("%,.0f", unitPrice);
    }

    public String getFormattedTotalPrice() {
        return String.format("%,.0f", totalPrice);
    }

    @Override
    public String toString() {
        return String.format("🛍️ Item #%d | ProductID: %d | Qty: %d | Unit: %,.0fđ | Total: %,.0fđ",
                id, productId, quantity, unitPrice, totalPrice);
    }
}

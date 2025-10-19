package model;

import java.util.Date;

public class WishlistItem {
    private long id;
    private long userId;
    private long productId;
    private Date addedAt;

    public WishlistItem() {}

    public WishlistItem(long id, long userId, long productId, Date addedAt) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.addedAt = addedAt;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }

    public Date getAddedAt() { return addedAt; }
    public void setAddedAt(Date addedAt) { this.addedAt = addedAt; }
}

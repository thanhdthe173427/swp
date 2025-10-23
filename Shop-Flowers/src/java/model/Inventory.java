package model;

import java.util.Date;

public class Inventory {
    private long id;
    private long productId;
    private long warehouseId;
    private int quantity;
    private int minQuantity;
    private Date updatedAt;

    // Thêm quan hệ hiển thị
    private String productName;
    private String warehouseName;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }

    public long getWarehouseId() { return warehouseId; }
    public void setWarehouseId(long warehouseId) { this.warehouseId = warehouseId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getMinQuantity() { return minQuantity; }
    public void setMinQuantity(int minQuantity) { this.minQuantity = minQuantity; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
}

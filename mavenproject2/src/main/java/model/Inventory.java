package model;

import java.util.Date;

public class Inventory {
    private long id;
    private long productId;
    private long warehouseId;
    private long materialId;
    private int quantity;
    private int minQuantity;
    private Date updatedAt;

    // Thêm quan hệ hiển thị
    private String materialName;
    private String productName;
    private String warehouseName;

    public Inventory() {
    }

    public Inventory(long id, long productId, long warehouseId, long materialId, int quantity, int minQuantity, Date updatedAt, String productName, String warehouseName) {
        this.id = id;
        this.productId = productId;
        this.warehouseId = warehouseId;
        this.materialId = materialId;
        this.quantity = quantity;
        this.minQuantity = minQuantity;
        this.updatedAt = updatedAt;
        this.productName = productName;
        this.warehouseName = warehouseName;
    }

    public void setMaterialId(long materialId) {
        this.materialId = materialId;
    }

    public long getMaterialId() {
        return materialId;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public String getMaterialName() {
        return materialName;
    }

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

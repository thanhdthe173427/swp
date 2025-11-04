package model;

import java.math.BigDecimal;
import java.util.Date;

public class StockMovement {
    private long id;
    private long productId;
    private Long warehouseId;
    private Long batchId;
    private String moveType;
    private int quantity;
    private BigDecimal unitCost;
    private String refTable;
    private Long refId;
    private String note;
    private Date createdAt;

    // Getters & Setters

    public StockMovement() {
    }

    public StockMovement(long id, long productId, Long warehouseId, Long batchId, String moveType, int quantity, BigDecimal unitCost, String refTable, Long refId, String note, Date createdAt) {
        this.id = id;
        this.productId = productId;
        this.warehouseId = warehouseId;
        this.batchId = batchId;
        this.moveType = moveType;
        this.quantity = quantity;
        this.unitCost = unitCost;
        this.refTable = refTable;
        this.refId = refId;
        this.note = note;
        this.createdAt = createdAt;
    }

    
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public Long getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(Long warehouseId) {
        this.warehouseId = warehouseId;
    }

    public Long getBatchId() {
        return batchId;
    }

    public void setBatchId(Long batchId) {
        this.batchId = batchId;
    }

    public String getMoveType() {
        return moveType;
    }

    public void setMoveType(String moveType) {
        this.moveType = moveType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(BigDecimal unitCost) {
        this.unitCost = unitCost;
    }

    public String getRefTable() {
        return refTable;
    }

    public void setRefTable(String refTable) {
        this.refTable = refTable;
    }

    public Long getRefId() {
        return refId;
    }

    public void setRefId(Long refId) {
        this.refId = refId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    
}

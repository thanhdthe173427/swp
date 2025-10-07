package model;

import java.util.Date;

public class Batch {
    private long id;
    private long productId;
    private Long warehouseId;
    private Long supplierInvoiceId;
    private String batchCode;
    private Date mfgDate;
    private Date expiryDate;
    private int qtyOnHand;
    private int qtyReserved;

    // Getters & Setters

    public Batch() {
    }

    public Batch(long id, long productId, Long warehouseId, Long supplierInvoiceId, String batchCode, Date mfgDate, Date expiryDate, int qtyOnHand, int qtyReserved) {
        this.id = id;
        this.productId = productId;
        this.warehouseId = warehouseId;
        this.supplierInvoiceId = supplierInvoiceId;
        this.batchCode = batchCode;
        this.mfgDate = mfgDate;
        this.expiryDate = expiryDate;
        this.qtyOnHand = qtyOnHand;
        this.qtyReserved = qtyReserved;
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

    public Long getSupplierInvoiceId() {
        return supplierInvoiceId;
    }

    public void setSupplierInvoiceId(Long supplierInvoiceId) {
        this.supplierInvoiceId = supplierInvoiceId;
    }

    public String getBatchCode() {
        return batchCode;
    }

    public void setBatchCode(String batchCode) {
        this.batchCode = batchCode;
    }

    public Date getMfgDate() {
        return mfgDate;
    }

    public void setMfgDate(Date mfgDate) {
        this.mfgDate = mfgDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getQtyOnHand() {
        return qtyOnHand;
    }

    public void setQtyOnHand(int qtyOnHand) {
        this.qtyOnHand = qtyOnHand;
    }

    public int getQtyReserved() {
        return qtyReserved;
    }

    public void setQtyReserved(int qtyReserved) {
        this.qtyReserved = qtyReserved;
    }
    
}

package model;

import java.util.Date;

public class Batch {
    private long id;
    private Long productId;
    private Long materialId;
    private Long warehouseId;
    private Long supplierInvoiceId;
    private String batchCode;
    private Date mfgDate;
    private Date expiryDate;
    private int qtyOnHand;
    private int qtyReserved;
    private String materialName;
    private Long supplierId;
    
    private String supplierName;

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierId(Long supplierId) {
        this.supplierId = supplierId;
    }

    public Long getSupplierId() {
        return supplierId;
    }

    public void setMaterialId(Long materialId) {
        this.materialId = materialId;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public String getMaterialName() {
        return materialName;
    }

    // Getters & Setters

    public Batch() {
    }

    public Batch(long id, Long productId, Long materialId, Long warehouseId, Long supplierInvoiceId, String batchCode, Date mfgDate, Date expiryDate, int qtyOnHand, int qtyReserved) {
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

    public Long getMaterialId() {
        return materialId;
    }

    
    public long getId() {
        return id;
    }

    public void setMaterialId(long materialId) {
        this.materialId = materialId;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Long getProductId() {
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

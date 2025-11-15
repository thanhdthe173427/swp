package model;

import java.math.BigDecimal;
import java.util.Date;

public class SupplierInvoice {
    private long id;
    private long supplierId;
    private String invoiceNo;
    private Date invoiceDate;
    private BigDecimal totalAmount;
    private String note;
    private Date createdAt;
    private Date updatedAt;

    public SupplierInvoice() {
    }

    public SupplierInvoice(long id, long supplierId, String invoiceNo, Date invoiceDate, BigDecimal totalAmount, String note, Date createdAt, Date updatedAt) {
        this.id = id;
        this.supplierId = supplierId;
        this.invoiceNo = invoiceNo;
        this.invoiceDate = invoiceDate;
        this.totalAmount = totalAmount;
        this.note = note;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(long supplierId) {
        this.supplierId = supplierId;
    }

    public String getInvoiceNo() {
        return invoiceNo;
    }

    public void setInvoiceNo(String invoiceNo) {
        this.invoiceNo = invoiceNo;
    }

    public Date getInvoiceDate() {
        return invoiceDate;
    }

    public void setInvoiceDate(Date invoiceDate) {
        this.invoiceDate = invoiceDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
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

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    
}

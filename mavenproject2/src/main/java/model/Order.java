package model;

import java.math.BigDecimal;
import java.util.Date;

public class Order {
    private long id;
    private String orderCode;
    private Long userId;
    private String customerName;
    private String customerPhone;
    private Long billingAddressId;
    private Long shippingAddressId;
    private String voucherCode;
    private String status;
    private String paymentStatus;
    private BigDecimal subtotal;
    private BigDecimal discountTotal;
    private BigDecimal shippingFee;
    private BigDecimal taxTotal;
    private BigDecimal grandTotal;
    private String note;
    private Date placedAt;
    private Date createdAt;
    private Date updatedAt;

    // Getters & Setters

    public Order() {
    }

    public Order(long id, String orderCode, Long userId, String customerName, String customerPhone, Long billingAddressId, Long shippingAddressId, String voucherCode, String status, String paymentStatus, BigDecimal subtotal, BigDecimal discountTotal, BigDecimal shippingFee, BigDecimal taxTotal, BigDecimal grandTotal, String note, Date placedAt, Date createdAt, Date updatedAt) {
        this.id = id;
        this.orderCode = orderCode;
        this.userId = userId;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.billingAddressId = billingAddressId;
        this.shippingAddressId = shippingAddressId;
        this.voucherCode = voucherCode;
        this.status = status;
        this.paymentStatus = paymentStatus;
        this.subtotal = subtotal;
        this.discountTotal = discountTotal;
        this.shippingFee = shippingFee;
        this.taxTotal = taxTotal;
        this.grandTotal = grandTotal;
        this.note = note;
        this.placedAt = placedAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public Long getBillingAddressId() {
        return billingAddressId;
    }

    public void setBillingAddressId(Long billingAddressId) {
        this.billingAddressId = billingAddressId;
    }

    public Long getShippingAddressId() {
        return shippingAddressId;
    }

    public void setShippingAddressId(Long shippingAddressId) {
        this.shippingAddressId = shippingAddressId;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getDiscountTotal() {
        return discountTotal;
    }

    public void setDiscountTotal(BigDecimal discountTotal) {
        this.discountTotal = discountTotal;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public BigDecimal getTaxTotal() {
        return taxTotal;
    }

    public void setTaxTotal(BigDecimal taxTotal) {
        this.taxTotal = taxTotal;
    }

    public BigDecimal getGrandTotal() {
        return grandTotal;
    }

    public void setGrandTotal(BigDecimal grandTotal) {
        this.grandTotal = grandTotal;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getPlacedAt() {
        return placedAt;
    }

    public void setPlacedAt(Date placedAt) {
        this.placedAt = placedAt;
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

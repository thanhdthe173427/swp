package model;

import java.math.BigDecimal;
import java.util.Date;

public class Product {

    private long id;
    private Long categoryId;
    private String sku;
    private String slug;
    private String name;
    private String description;
    private BigDecimal basePrice;
    private BigDecimal costPrice;
    private String unit;
    private boolean isActive;
    private boolean isAccessory;
    private Date createdAt;
    private Date updatedAt;
    private String url; // ✅ thêm mới
    private int totalQty;
    private int totalBatches;
    private String warehouses;

    public Product() {
    }

    public Product(long id, Long categoryId, String sku, String slug, String name, String description, BigDecimal basePrice, BigDecimal costPrice, String unit, boolean isActive, boolean isAccessory, Date createdAt, Date updatedAt, String url, int totalQty, int totalBatches, String warehouses) {
        this.id = id;
        this.categoryId = categoryId;
        this.sku = sku;
        this.slug = slug;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.costPrice = costPrice;
        this.unit = unit;
        this.isActive = isActive;
        this.isAccessory = isAccessory;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.url = url;
        this.totalQty = totalQty;
        this.totalBatches = totalBatches;
        this.warehouses = warehouses;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
    }

    public BigDecimal getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(BigDecimal costPrice) {
        this.costPrice = costPrice;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public boolean isIsAccessory() {
        return isAccessory;
    }

    public void setIsAccessory(boolean isAccessory) {
        this.isAccessory = isAccessory;
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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public int getTotalQty() {
        return totalQty;
    }

    public void setTotalQty(int totalQty) {
        this.totalQty = totalQty;
    }

    public int getTotalBatches() {
        return totalBatches;
    }

    public void setTotalBatches(int totalBatches) {
        this.totalBatches = totalBatches;
    }

    public String getWarehouses() {
        return warehouses;
    }

    public void setWarehouses(String warehouses) {
        this.warehouses = warehouses;
    }
    
}
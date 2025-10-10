package model;

import java.util.Date;

public class Address {
    private long id;
    private long userId;
    private String fullAddress;
    private String recipientName;
    private String phone;
    private boolean isDefault;
    private Date createdAt;
    private Date updatedAt;

    public Address() {
    }

    public Address(long id, long userId, String fullAddress, String recipientName, String phone, boolean isDefault, Date createdAt, Date updatedAt) {
        this.id = id;
        this.userId = userId;
        this.fullAddress = fullAddress;
        this.recipientName = recipientName;
        this.phone = phone;
        this.isDefault = isDefault;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    
    // Getters and Setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public String getFullAddress() { return fullAddress; }
    public void setFullAddress(String fullAddress) { this.fullAddress = fullAddress; }

    public String getRecipientName() { return recipientName; }
    public void setRecipientName(String recipientName) { this.recipientName = recipientName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}

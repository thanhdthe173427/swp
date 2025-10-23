package model;

import java.util.Date;

public class Supplier {
    private long id;
    private String name;
    private String contactName;
    private String contactPhone;
    private String contactEmail;
    private String address;
    private Date createdAt;
    private Date updatedAt;

    // Getters & Setters

    public Supplier() {
    }

    public Supplier(long id, String name, String contactName, String contactPhone, String contactEmail, String address, Date createdAt, Date updatedAt) {
        this.id = id;
        this.name = name;
        this.contactName = contactName;
        this.contactPhone = contactPhone;
        this.contactEmail = contactEmail;
        this.address = address;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

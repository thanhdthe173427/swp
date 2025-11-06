package model;

import java.util.Date;

public class Delivery {
    private long id;
    private long orderId;
    private Date scheduledDate;
    private String scheduledWindow;
    private Long addressId;
    private Long shipperUserId;
    private String status;
    private String receiverName;
    private String receiverPhone;
    private String podNote;
    private String podPhotoUrl;
    private Date deliveredAt;
    private String note;

    // Getters & Setters

    public Delivery() {
    }

    public Delivery(long id, long orderId, Date scheduledDate, String scheduledWindow, Long addressId, Long shipperUserId, String status, String receiverName, String receiverPhone, String podNote, String podPhotoUrl, Date deliveredAt, String note) {
        this.id = id;
        this.orderId = orderId;
        this.scheduledDate = scheduledDate;
        this.scheduledWindow = scheduledWindow;
        this.addressId = addressId;
        this.shipperUserId = shipperUserId;
        this.status = status;
        this.receiverName = receiverName;
        this.receiverPhone = receiverPhone;
        this.podNote = podNote;
        this.podPhotoUrl = podPhotoUrl;
        this.deliveredAt = deliveredAt;
        this.note = note;
    }

    
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public Date getScheduledDate() {
        return scheduledDate;
    }

    public void setScheduledDate(Date scheduledDate) {
        this.scheduledDate = scheduledDate;
    }

    public String getScheduledWindow() {
        return scheduledWindow;
    }

    public void setScheduledWindow(String scheduledWindow) {
        this.scheduledWindow = scheduledWindow;
    }

    public Long getAddressId() {
        return addressId;
    }

    public void setAddressId(Long addressId) {
        this.addressId = addressId;
    }

    public Long getShipperUserId() {
        return shipperUserId;
    }

    public void setShipperUserId(Long shipperUserId) {
        this.shipperUserId = shipperUserId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public String getPodNote() {
        return podNote;
    }

    public void setPodNote(String podNote) {
        this.podNote = podNote;
    }

    public String getPodPhotoUrl() {
        return podPhotoUrl;
    }

    public void setPodPhotoUrl(String podPhotoUrl) {
        this.podPhotoUrl = podPhotoUrl;
    }

    public Date getDeliveredAt() {
        return deliveredAt;
    }

    public void setDeliveredAt(Date deliveredAt) {
        this.deliveredAt = deliveredAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
}

package com.sliit.pickmegoweb.model;

import com.google.gson.annotations.SerializedName;
import java.sql.Timestamp;

public class Notification {
    
    @SerializedName("NotificationID")
    private int notificationId;
    
    @SerializedName("TripID")
    private int tripId;
    
    @SerializedName("DriverID")
    private int driverId;
    
    @SerializedName("CustomerID")
    private int customerId;
    
    @SerializedName("NotificationType")
    private String notificationType; // "RIDE_REQUEST", "RIDE_ACCEPTED", "RIDE_REJECTED"
    
    @SerializedName("Message")
    private String message;
    
    @SerializedName("IsRead")
    private boolean isRead;
    
    @SerializedName("CreatedDate")
    private Timestamp createdTime;
    
    @SerializedName("TripDetails")
    private Trip tripDetails;
    
    // Constructors
    public Notification() {}
    
    public Notification(int tripId, int driverId, int customerId, String notificationType, String message) {
        this.tripId = tripId;
        this.driverId = driverId;
        this.customerId = customerId;
        this.notificationType = notificationType;
        this.message = message;
        this.isRead = false;
        this.createdTime = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }
    
    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }
    
    public int getTripId() {
        return tripId;
    }
    
    public void setTripId(int tripId) {
        this.tripId = tripId;
    }
    
    public int getDriverId() {
        return driverId;
    }
    
    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }
    
    public int getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
    
    public String getNotificationType() {
        return notificationType;
    }
    
    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }
    
    public Timestamp getCreatedTime() {
        return createdTime;
    }
    
    public void setCreatedTime(Timestamp createdTime) {
        this.createdTime = createdTime;
    }
    
    public Trip getTripDetails() {
        return tripDetails;
    }
    
    public void setTripDetails(Trip tripDetails) {
        this.tripDetails = tripDetails;
    }
}

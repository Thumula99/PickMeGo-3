package com.sliit.pickmegoweb.model;

import com.google.gson.annotations.SerializedName;

public class DriverWatchlist {
    @SerializedName("watchlistId")
    private int watchlistId;
    
    @SerializedName("driverId")
    private int driverId;
    
    @SerializedName("adminId")
    private int adminId;
    
    @SerializedName("reason")
    private String reason;
    
    @SerializedName("status")
    private String status;
    
    @SerializedName("createdDate")
    private java.sql.Timestamp createdDate;
    
    @SerializedName("updatedDate")
    private java.sql.Timestamp updatedDate;
    
    // Driver details (for display purposes)
    @SerializedName("driverName")
    private String driverName;
    
    @SerializedName("driverEmail")
    private String driverEmail;
    
    @SerializedName("adminName")
    private String adminName;

    // Constructors
    public DriverWatchlist() {}

    public DriverWatchlist(int driverId, int adminId, String reason) {
        this.driverId = driverId;
        this.adminId = adminId;
        this.reason = reason;
        this.status = "Active";
    }

    // Getters and Setters
    public int getWatchlistId() {
        return watchlistId;
    }

    public void setWatchlistId(int watchlistId) {
        this.watchlistId = watchlistId;
    }

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public java.sql.Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(java.sql.Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public java.sql.Timestamp getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(java.sql.Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getDriverEmail() {
        return driverEmail;
    }

    public void setDriverEmail(String driverEmail) {
        this.driverEmail = driverEmail;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    @Override
    public String toString() {
        return "DriverWatchlist{" +
                "watchlistId=" + watchlistId +
                ", driverId=" + driverId +
                ", adminId=" + adminId +
                ", reason='" + reason + '\'' +
                ", status='" + status + '\'' +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}

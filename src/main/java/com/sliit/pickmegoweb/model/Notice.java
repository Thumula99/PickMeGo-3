package com.sliit.pickmegoweb.model;

import com.google.gson.annotations.SerializedName;
import com.google.gson.annotations.Expose;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Notice {
    @SerializedName("NoticeID")
    @Expose
    private int noticeId;
    
    @SerializedName("Title")
    @Expose
    private String title;
    
    @SerializedName("Message")
    @Expose
    private String message;
    
    @SerializedName("NoticeType")
    @Expose
    private String noticeType;
    
    @SerializedName("Priority")
    @Expose
    private String priority;
    
    @SerializedName("CreatedBy")
    @Expose
    private int createdBy;
    
    @SerializedName("CreatedDate")
    @Expose
    private String createdDate; // Changed to String to avoid LocalDateTime serialization issues
    
    @SerializedName("ExpiryDate")
    @Expose
    private String expiryDate; // Changed to String to avoid LocalDateTime serialization issues
    
    @SerializedName("IsActive")
    @Expose
    private boolean isActive;
    
    @SerializedName("TargetAudience")
    @Expose
    private String targetAudience;
    
    // Constructors
    public Notice() {}
    
    public Notice(String title, String message, String noticeType, String priority, 
                  int createdBy, String targetAudience) {
        this.title = title;
        this.message = message;
        this.noticeType = noticeType;
        this.priority = priority;
        this.createdBy = createdBy;
        this.targetAudience = targetAudience;
        this.isActive = true;
    }
    
    // Getters and Setters
    public int getNoticeId() {
        return noticeId;
    }
    
    public void setNoticeId(int noticeId) {
        this.noticeId = noticeId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getNoticeType() {
        return noticeType;
    }
    
    public void setNoticeType(String noticeType) {
        this.noticeType = noticeType;
    }
    
    public String getPriority() {
        return priority;
    }
    
    public void setPriority(String priority) {
        this.priority = priority;
    }
    
    public int getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }
    
    public String getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(String createdDate) {
        this.createdDate = createdDate;
    }
    
    public String getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public String getTargetAudience() {
        return targetAudience;
    }
    
    public void setTargetAudience(String targetAudience) {
        this.targetAudience = targetAudience;
    }
    
    @Override
    public String toString() {
        return "Notice{" +
                "noticeId=" + noticeId +
                ", title='" + title + '\'' +
                ", message='" + message + '\'' +
                ", noticeType='" + noticeType + '\'' +
                ", priority='" + priority + '\'' +
                ", createdBy=" + createdBy +
                ", createdDate='" + createdDate + '\'' +
                ", expiryDate='" + expiryDate + '\'' +
                ", isActive=" + isActive +
                ", targetAudience='" + targetAudience + '\'' +
                '}';
    }
}

package com.sliit.pickmegoweb.model;

import java.sql.Timestamp;

public class Feedback {
    private int id;
    private int customerId;
    private String title;
    private String content;
    private Integer rating; // 1..5 optional
    private String status; // Open | Resolved
    private String reply;
    private Timestamp createdAt;
    private Timestamp repliedAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getRepliedAt() { return repliedAt; }
    public void setRepliedAt(Timestamp repliedAt) { this.repliedAt = repliedAt; }
}



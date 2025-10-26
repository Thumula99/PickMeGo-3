package com.sliit.pickmegoweb.model;

import java.sql.Timestamp;

public class Offer {
	private int id;
	private String title;
	private String description;
	private String discountType; // PERCENT or FIXED
	private double discountValue;
	private String vehicleType; // optional, null means all
	private Timestamp expiresAt; // nullable
	private int createdBy; // userId
	private boolean active;

	public int getId() { return id; }
	public void setId(int id) { this.id = id; }

	public String getTitle() { return title; }
	public void setTitle(String title) { this.title = title; }

	public String getDescription() { return description; }
	public void setDescription(String description) { this.description = description; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}



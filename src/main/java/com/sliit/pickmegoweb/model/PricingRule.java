package com.sliit.pickmegoweb.model;

public class PricingRule {
	private String vehicleType;
	private double basePrice;
	private double pricePerKm;

	public PricingRule() {}

	public PricingRule(String vehicleType, double basePrice, double pricePerKm) {
		this.vehicleType = vehicleType;
		this.basePrice = basePrice;
		this.pricePerKm = pricePerKm;
	}

	public String getVehicleType() { return vehicleType; }
	public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

	public double getBasePrice() { return basePrice; }
	public void setBasePrice(double basePrice) { this.basePrice = basePrice; }

	public double getPricePerKm() { return pricePerKm; }
	public void setPricePerKm(double pricePerKm) { this.pricePerKm = pricePerKm; }
}



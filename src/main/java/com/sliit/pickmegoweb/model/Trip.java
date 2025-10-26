package com.sliit.pickmegoweb.model;

import com.google.gson.annotations.SerializedName;
import java.sql.Timestamp;

public class Trip {

    @SerializedName("TripID")
    private int tripId;

    @SerializedName("CustomerID")
    private int customerId;

    @SerializedName("DriverID")
    private int driverId;

    @SerializedName("PickupLocation")
    private String pickupLocation;

    @SerializedName("DropOffLocation")
    private String dropoffLocation;

    // If you want to send coordinates in JSON, keep them with mapping
    @SerializedName("PickupLatitude")
    private double pickupLatitude;

    @SerializedName("PickupLongitude")
    private double pickupLongitude;

    @SerializedName("DropOffLatitude")
    private double dropoffLatitude;

    @SerializedName("DropOffLongitude")
    private double dropoffLongitude;

    @SerializedName("distance")
    private String distance;

    @SerializedName("vehicle_type")
    private String vehicleType;

    @SerializedName("price")
    private double price;

    @SerializedName("tip")
    private double tip;

    @SerializedName("TripStatus")
    private String status;

    @SerializedName("BookingTime")
    private Timestamp bookingTime;

    @SerializedName("CompletionTime")
    private Timestamp completionTime;

    // Constructors
    public Trip() {}

    // Getters and Setters
    public int getTripId() { return tripId; }
    public void setTripId(int tripId) { this.tripId = tripId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getDriverId() { return driverId; }
    public void setDriverId(int driverId) { this.driverId = driverId; }

    public String getPickupLocation() { return pickupLocation; }
    public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }

    public String getDropoffLocation() { return dropoffLocation; }
    public void setDropoffLocation(String dropoffLocation) { this.dropoffLocation = dropoffLocation; }

    public double getPickupLatitude() { return pickupLatitude; }
    public void setPickupLatitude(double pickupLatitude) { this.pickupLatitude = pickupLatitude; }

    public double getPickupLongitude() { return pickupLongitude; }
    public void setPickupLongitude(double pickupLongitude) { this.pickupLongitude = pickupLongitude; }

    public double getDropoffLatitude() { return dropoffLatitude; }
    public void setDropoffLatitude(double dropoffLatitude) { this.dropoffLatitude = dropoffLatitude; }

    public double getDropoffLongitude() { return dropoffLongitude; }
    public void setDropoffLongitude(double dropoffLongitude) { this.dropoffLongitude = dropoffLongitude; }

    public String getDistance() { return distance; }
    public void setDistance(String distance) { this.distance = distance; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getTip() { return tip; }
    public void setTip(double tip) { this.tip = tip; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getBookingTime() { return bookingTime; }
    public void setBookingTime(Timestamp bookingTime) { this.bookingTime = bookingTime; }

    public Timestamp getCompletionTime() { return completionTime; }
    public void setCompletionTime(Timestamp completionTime) { this.completionTime = completionTime; }
}

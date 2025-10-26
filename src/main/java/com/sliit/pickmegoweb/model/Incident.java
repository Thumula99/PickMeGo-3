package com.sliit.pickmegoweb.model;

import com.google.gson.annotations.SerializedName;
import java.sql.Timestamp;

public class Incident {
    
    @SerializedName("IncidentID")
    private int incidentId;
    
    @SerializedName("TripID")
    private int tripId;
    
    @SerializedName("DriverID")
    private int driverId;
    
    @SerializedName("IncidentType")
    private String incidentType; // "Breakdown", "Accident", "Other"
    
    @SerializedName("Description")
    private String description;
    
    @SerializedName("Location")
    private String location;
    
    @SerializedName("Latitude")
    private double latitude;
    
    @SerializedName("Longitude")
    private double longitude;
    
    @SerializedName("Severity")
    private String severity; // "Low", "Medium", "High", "Critical"
    
    @SerializedName("Status")
    private String status; // "Reported", "Under Investigation", "Resolved", "Closed"
    
    @SerializedName("ReportedDate")
    private Timestamp reportedDate;
    
    @SerializedName("ResolvedDate")
    private Timestamp resolvedDate;
    
    @SerializedName("Notes")
    private String notes;
    
    @SerializedName("DriverName")
    private String driverName;
    
    @SerializedName("TripDetails")
    private Trip tripDetails;
    
    // Constructors
    public Incident() {}
    
    public Incident(int tripId, int driverId, String incidentType, String description, 
                   String location, double latitude, double longitude, String severity) {
        this.tripId = tripId;
        this.driverId = driverId;
        this.incidentType = incidentType;
        this.description = description;
        this.location = location;
        this.latitude = latitude;
        this.longitude = longitude;
        this.severity = severity;
        this.status = "Reported";
        this.reportedDate = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getIncidentId() {
        return incidentId;
    }
    
    public void setIncidentId(int incidentId) {
        this.incidentId = incidentId;
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
    
    public String getIncidentType() {
        return incidentType;
    }
    
    public void setIncidentType(String incidentType) {
        this.incidentType = incidentType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public double getLatitude() {
        return latitude;
    }
    
    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }
    
    public double getLongitude() {
        return longitude;
    }
    
    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }
    
    public String getSeverity() {
        return severity;
    }
    
    public void setSeverity(String severity) {
        this.severity = severity;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getReportedDate() {
        return reportedDate;
    }
    
    public void setReportedDate(Timestamp reportedDate) {
        this.reportedDate = reportedDate;
    }
    
    public Timestamp getResolvedDate() {
        return resolvedDate;
    }
    
    public void setResolvedDate(Timestamp resolvedDate) {
        this.resolvedDate = resolvedDate;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public String getDriverName() {
        return driverName;
    }
    
    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }
    
    public Trip getTripDetails() {
        return tripDetails;
    }
    
    public void setTripDetails(Trip tripDetails) {
        this.tripDetails = tripDetails;
    }
}

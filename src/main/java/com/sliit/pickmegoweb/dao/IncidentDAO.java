package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.Incident;
import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IncidentDAO {
    
    private Connection connection;
    
    public IncidentDAO() {
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Failed to get database connection for IncidentDAO.");
        }
    }
    
    // ------------------- CREATE INCIDENT -------------------
    public boolean createIncident(Incident incident) {
        String sql = "INSERT INTO Incidents (TripID, DriverID, IncidentType, Description, Location, Latitude, Longitude, Severity, Status, ReportedDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, incident.getTripId());
            ps.setInt(2, incident.getDriverId());
            ps.setString(3, incident.getIncidentType());
            ps.setString(4, incident.getDescription());
            ps.setString(5, incident.getLocation());
            ps.setDouble(6, incident.getLatitude());
            ps.setDouble(7, incident.getLongitude());
            ps.setString(8, incident.getSeverity());
            ps.setString(9, incident.getStatus());
            ps.setTimestamp(10, incident.getReportedDate());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated incident ID
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        incident.setIncidentId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("Incident created successfully with ID: " + incident.getIncidentId());
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ------------------- READ INCIDENTS -------------------
    public Incident getIncidentById(int incidentId) {
        String sql = "SELECT i.*, u.firstName + ' ' + u.lastName as DriverName, " +
                    "t.PickupLocation, t.DropOffLocation, t.distance, t.vehicle_type, t.price, " +
                    "t.TripStatus, t.BookingTime, t.CompletionTime, t.CustomerID " +
                    "FROM Incidents i " +
                    "LEFT JOIN Users u ON i.DriverID = u.UserID " +
                    "LEFT JOIN Trips t ON i.TripID = t.TripID " +
                    "WHERE i.IncidentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, incidentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractIncidentWithTripDetailsFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Incident> getAllIncidents() {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT i.*, u.firstName + ' ' + u.lastName as DriverName, " +
                    "t.PickupLocation, t.DropOffLocation, t.distance, t.vehicle_type, t.price, " +
                    "t.TripStatus, t.BookingTime, t.CompletionTime, t.CustomerID " +
                    "FROM Incidents i " +
                    "LEFT JOIN Users u ON i.DriverID = u.UserID " +
                    "LEFT JOIN Trips t ON i.TripID = t.TripID " +
                    "ORDER BY i.ReportedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                incidents.add(extractIncidentWithTripDetailsFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    public List<Incident> getIncidentsByDriverId(int driverId) {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT i.*, u.firstName + ' ' + u.lastName as DriverName " +
                    "FROM Incidents i " +
                    "LEFT JOIN Users u ON i.DriverID = u.UserID " +
                    "WHERE i.DriverID = ? " +
                    "ORDER BY i.ReportedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                incidents.add(extractIncidentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    public List<Incident> getIncidentsByStatus(String status) {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT i.*, u.firstName + ' ' + u.lastName as DriverName " +
                    "FROM Incidents i " +
                    "LEFT JOIN Users u ON i.DriverID = u.UserID " +
                    "WHERE i.Status = ? " +
                    "ORDER BY i.ReportedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                incidents.add(extractIncidentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    public List<Incident> getIncidentsByTripId(int tripId) {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT i.*, u.firstName + ' ' + u.lastName as DriverName " +
                    "FROM Incidents i " +
                    "LEFT JOIN Users u ON i.DriverID = u.UserID " +
                    "WHERE i.TripID = ? " +
                    "ORDER BY i.ReportedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                incidents.add(extractIncidentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return incidents;
    }
    
    // ------------------- UPDATE INCIDENT -------------------
    public boolean updateIncident(Incident incident) {
        String sql = "UPDATE Incidents SET IncidentType = ?, Description = ?, Location = ?, " +
                    "Latitude = ?, Longitude = ?, Severity = ?, Status = ?, Notes = ?, " +
                    "ResolvedDate = ? WHERE IncidentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, incident.getIncidentType());
            ps.setString(2, incident.getDescription());
            ps.setString(3, incident.getLocation());
            ps.setDouble(4, incident.getLatitude());
            ps.setDouble(5, incident.getLongitude());
            ps.setString(6, incident.getSeverity());
            ps.setString(7, incident.getStatus());
            ps.setString(8, incident.getNotes());
            ps.setTimestamp(9, incident.getResolvedDate());
            ps.setInt(10, incident.getIncidentId());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Incident updated successfully: " + incident.getIncidentId());
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateIncidentStatus(int incidentId, String status, String notes) {
        String sql = "UPDATE Incidents SET Status = ?, Notes = ?, ResolvedDate = ? WHERE IncidentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, notes);
            
            // Set resolved date if status is "Resolved" or "Closed"
            if ("Resolved".equals(status) || "Closed".equals(status)) {
                ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }
            
            ps.setInt(4, incidentId);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Incident status updated successfully: " + incidentId + " to " + status);
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ------------------- DELETE INCIDENT -------------------
    public boolean deleteIncident(int incidentId) {
        String sql = "DELETE FROM Incidents WHERE IncidentID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, incidentId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Incident deleted successfully: " + incidentId);
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ------------------- HELPER METHODS -------------------
    private Incident extractIncidentFromResultSet(ResultSet rs) throws SQLException {
        Incident incident = new Incident();
        incident.setIncidentId(rs.getInt("IncidentID"));
        incident.setTripId(rs.getInt("TripID"));
        incident.setDriverId(rs.getInt("DriverID"));
        incident.setIncidentType(rs.getString("IncidentType"));
        incident.setDescription(rs.getString("Description"));
        incident.setLocation(rs.getString("Location"));
        incident.setLatitude(rs.getDouble("Latitude"));
        incident.setLongitude(rs.getDouble("Longitude"));
        incident.setSeverity(rs.getString("Severity"));
        incident.setStatus(rs.getString("Status"));
        incident.setReportedDate(rs.getTimestamp("ReportedDate"));
        incident.setResolvedDate(rs.getTimestamp("ResolvedDate"));
        incident.setNotes(rs.getString("Notes"));
        
        // Set driver name if available
        try {
            incident.setDriverName(rs.getString("DriverName"));
        } catch (SQLException e) {
            // DriverName column might not exist in some queries
        }
        
        return incident;
    }
    
    private Incident extractIncidentWithTripDetailsFromResultSet(ResultSet rs) throws SQLException {
        Incident incident = extractIncidentFromResultSet(rs);
        
        // Extract trip details if available
        try {
            Trip tripDetails = new Trip();
            tripDetails.setTripId(rs.getInt("TripID"));
            tripDetails.setCustomerId(rs.getInt("CustomerID"));
            tripDetails.setPickupLocation(rs.getString("PickupLocation"));
            tripDetails.setDropoffLocation(rs.getString("DropOffLocation"));
            tripDetails.setDistance(String.valueOf(rs.getDouble("distance")));
            tripDetails.setVehicleType(rs.getString("vehicle_type"));
            tripDetails.setPrice(rs.getDouble("price"));
            tripDetails.setStatus(rs.getString("TripStatus"));
            tripDetails.setBookingTime(rs.getTimestamp("BookingTime"));
            tripDetails.setCompletionTime(rs.getTimestamp("CompletionTime"));
            
            incident.setTripDetails(tripDetails);
        } catch (SQLException e) {
            // Trip details might not be available in some queries
            System.out.println("Trip details not available for incident: " + incident.getIncidentId());
        }
        
        return incident;
    }
    
    // Get incident statistics for operations manager
    public int getIncidentCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Incidents WHERE Status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTotalIncidentCount() {
        String sql = "SELECT COUNT(*) FROM Incidents";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

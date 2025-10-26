package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RideDAO {

    private Connection connection;

    public RideDAO() {
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Failed to get database connection.");
        }
    }

    // ------------------- CREATE TRIP -------------------
    public int createTrip(Trip trip) {
        String sql = "INSERT INTO Trips (CustomerID, PickupLocation, DropOffLocation, distance, vehicle_type, price, tip, TripStatus, BookingTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, trip.getCustomerId());
            ps.setString(2, trip.getPickupLocation());
            ps.setString(3, trip.getDropoffLocation());

            // Handle potential null or bad distance values
            String distanceStr = trip.getDistance();
            double distance = 0.0;
            if (distanceStr != null && !distanceStr.isEmpty()) {
                try {
                    // This handles cases where distance might include " km"
                    distance = Double.parseDouble(distanceStr.replace(" km", "").trim());
                } catch (NumberFormatException e) {
                    System.err.println("Invalid distance format: " + distanceStr);
                    // Leave distance as 0.0 if parsing fails
                }
            }
            ps.setDouble(4, distance);

            // Corrected: Convert vehicleType to lowercase for consistency
            ps.setString(5, trip.getVehicleType() != null ? trip.getVehicleType().toLowerCase() : null);

            ps.setDouble(6, trip.getPrice());
            ps.setDouble(7, trip.getTip());
            ps.setString(8, trip.getStatus());
            ps.setTimestamp(9, new Timestamp(trip.getBookingTime().getTime()));
            
            System.out.println("DEBUG: createTrip - Trip details:");
            System.out.println("  CustomerID: " + trip.getCustomerId());
            System.out.println("  PickupLocation: " + trip.getPickupLocation());
            System.out.println("  DropoffLocation: " + trip.getDropoffLocation());
            System.out.println("  Distance: " + distance);
            System.out.println("  VehicleType: " + trip.getVehicleType());
            System.out.println("  Price: " + trip.getPrice());
            System.out.println("  Tip: " + trip.getTip());
            System.out.println("  Status: " + trip.getStatus());

            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated TripID
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int tripId = generatedKeys.getInt(1);
                        trip.setTripId(tripId); // Set the TripID in the trip object
                        return tripId;
                    }
                }
            }
            return -1; // Return -1 if creation failed
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    // ------------------- GET TRIPS -------------------
    public Trip getTripById(int tripId) {
        String sql = "SELECT * FROM Trips WHERE TripID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractTripFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get current trip for a customer
    public Trip getCurrentTripByCustomerId(int customerId) {
        String sql = "SELECT * FROM Trips WHERE CustomerID = ? AND TripStatus IN ('Pending', 'Accepted', 'InProgress', 'Arrived') ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractTripFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ------------------- UPDATE TRIP LOCATIONS -------------------
    public boolean updateTripLocations(int tripId, String pickupLocation, String dropoffLocation, 
                                     double pickupLat, double pickupLng, double dropoffLat, double dropoffLng) {
        // Calculate distance using Haversine formula
        double distance = calculateDistance(pickupLat, pickupLng, dropoffLat, dropoffLng);
        
        // Calculate price based on distance and vehicle type
        Trip trip = getTripById(tripId);
        double price = calculatePrice(distance, trip.getVehicleType());
        
        String sql = "UPDATE Trips SET PickupLocation = ?, DropOffLocation = ?, PickupLatitude = ?, " +
                    "PickupLongitude = ?, DropOffLatitude = ?, DropOffLongitude = ?, distance = ?, price = ? " +
                    "WHERE TripID = ? AND TripStatus IN ('Pending', 'Accepted')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pickupLocation);
            ps.setString(2, dropoffLocation);
            ps.setDouble(3, pickupLat);
            ps.setDouble(4, pickupLng);
            ps.setDouble(5, dropoffLat);
            ps.setDouble(6, dropoffLng);
            ps.setDouble(7, distance);
            ps.setDouble(8, price);
            ps.setInt(9, tripId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: updateTripLocations - rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in updateTripLocations: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ------------------- UPDATE TRIP PICKUP LOCATION ONLY -------------------
    public boolean updateTripPickupLocation(int tripId, String pickupLocation, double pickupLat, double pickupLng) {
        // Get current trip to preserve dropoff location and calculate new distance/price
        Trip trip = getTripById(tripId);
        if (trip == null) {
            return false;
        }
        
        // Calculate distance using Haversine formula with new pickup and existing dropoff
        double distance = calculateDistance(pickupLat, pickupLng, trip.getDropoffLatitude(), trip.getDropoffLongitude());
        
        // Calculate price based on distance and vehicle type
        double price = calculatePrice(distance, trip.getVehicleType());
        
        String sql = "UPDATE Trips SET PickupLocation = ?, PickupLatitude = ?, " +
                    "PickupLongitude = ?, distance = ?, price = ? " +
                    "WHERE TripID = ? AND TripStatus IN ('Pending', 'Accepted')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pickupLocation);
            ps.setDouble(2, pickupLat);
            ps.setDouble(3, pickupLng);
            ps.setDouble(4, distance);
            ps.setDouble(5, price);
            ps.setInt(6, tripId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: updateTripPickupLocation - rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in updateTripPickupLocation: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ------------------- UPDATE TRIP TIP -------------------
    public boolean updateTripTip(int tripId, double newTip) {
        String sql = "UPDATE Trips SET tip = ? WHERE TripID = ? AND TripStatus IN ('Pending', 'Accepted', 'InProgress')";
        System.out.println("DEBUG: updateTripTip - SQL: " + sql);
        System.out.println("DEBUG: updateTripTip - Parameters: tripId=" + tripId + ", newTip=" + newTip);
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, newTip);
            ps.setInt(2, tripId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: updateTripTip - rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in updateTripTip: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ------------------- CANCEL TRIP -------------------
    public boolean cancelTrip(int tripId) {
        String sql = "UPDATE Trips SET TripStatus = 'Cancelled' WHERE TripID = ? AND TripStatus IN ('Pending', 'Accepted')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------- DRIVER METHODS -------------------
    
    // Accept a trip (assign driver to trip) - with trip limit check
    public boolean acceptTrip(int tripId, int driverId) {
        // First check if driver can accept more trips (max 2 active trips)
        int activeTripCount = getActiveTripCountByDriverId(driverId);
        if (activeTripCount >= 2) {
            System.out.println("Driver " + driverId + " already has " + activeTripCount + " active trips. Cannot accept more.");
            return false;
        }
        
        String sql = "UPDATE Trips SET DriverID = ?, TripStatus = 'Accepted' WHERE TripID = ? AND TripStatus = 'Pending'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, tripId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Trip " + tripId + " accepted by driver " + driverId);
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Reject a trip (mark as rejected)
    public boolean rejectTrip(int tripId) {
        String sql = "UPDATE Trips SET TripStatus = 'Rejected' WHERE TripID = ? AND TripStatus = 'Pending'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Trip " + tripId + " rejected");
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update trip status with validation
    public boolean updateTripStatus(int tripId, String status) {
        // First get current trip status
        String currentStatus = getCurrentTripStatus(tripId);
        if (currentStatus == null) {
            System.out.println("Trip not found: " + tripId);
            return false;
        }
        
        // Validate status transition
        if (!isValidStatusTransition(currentStatus, status)) {
            System.out.println("Invalid status transition from " + currentStatus + " to " + status);
            return false;
        }
        
        String sql = "UPDATE Trips SET TripStatus = ? WHERE TripID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, tripId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Trip " + tripId + " status updated from " + currentStatus + " to " + status);
            }
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get current trip status
    public String getCurrentTripStatus(int tripId) {
        String sql = "SELECT TripStatus FROM Trips WHERE TripID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("TripStatus");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Validate status transitions
    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        // Define valid transitions using database-compatible status values
        switch (currentStatus) {
            case "Accepted":
                return newStatus.equals("InProgress") || newStatus.equals("Cancelled");
            case "InProgress":
                return newStatus.equals("Arrived") || newStatus.equals("Cancelled");
            case "Arrived":
                return newStatus.equals("Completed") || newStatus.equals("Cancelled");
            case "Completed":
            case "Cancelled":
                return false; // Terminal states
            default:
                return false;
        }
    }

    // Get current trip for a driver
    public Trip getCurrentTripByDriverId(int driverId) {
        String sql = "SELECT * FROM Trips WHERE DriverID = ? AND TripStatus IN ('Accepted', 'InProgress', 'Arrived') ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractTripFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get pending trips by vehicle type
    public List<Trip> getPendingTripsByVehicleType(String vehicleType) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM Trips WHERE TripStatus = 'Pending' AND vehicle_type = ? ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, vehicleType.toLowerCase());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trips.add(extractTripFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    // Get accepted trips by driver ID
    public List<Trip> getAcceptedTripsByDriverId(int driverId) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM Trips WHERE DriverID = ? AND TripStatus IN ('Accepted', 'InProgress', 'Arrived') ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trips.add(extractTripFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    // Get pending trip count by vehicle type
    public int getPendingTripCountByVehicleType(String vehicleType) {
        String sql = "SELECT COUNT(*) FROM Trips WHERE TripStatus = 'Pending' AND vehicle_type = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, vehicleType.toLowerCase());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get active trip count by driver ID
    public int getActiveTripCountByDriverId(int driverId) {
        String sql = "SELECT COUNT(*) FROM Trips WHERE DriverID = ? AND TripStatus IN ('Accepted', 'InProgress', 'Arrived')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get new trips since a specific timestamp
    public List<Trip> getNewTripsSince(String vehicleType, Timestamp since) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM Trips WHERE TripStatus = 'Pending' AND vehicle_type = ? AND BookingTime > ? ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, vehicleType.toLowerCase());
            ps.setTimestamp(2, since);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trips.add(extractTripFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    // Get available drivers (those with less than 2 active trips) by vehicle type
    public List<Integer> getAvailableDriverIdsByVehicleType(String vehicleType) {
        List<Integer> availableDriverIds = new ArrayList<>();
        String sql = "SELECT DISTINCT u.UserID FROM Users u " +
                    "LEFT JOIN Trips t ON u.UserID = t.DriverID AND t.TripStatus IN ('Accepted', 'InProgress', 'Arrived') " +
                    "WHERE u.role = 'Driver' AND LOWER(u.vehicleType) = LOWER(?) " +
                    "GROUP BY u.UserID " +
                    "HAVING COUNT(t.TripID) < 2";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, vehicleType.toLowerCase());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                availableDriverIds.add(rs.getInt("UserID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return availableDriverIds;
    }

    // Get all trips for a customer
    public List<Trip> getTripsByCustomerId(int customerId) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM Trips WHERE CustomerID = ? ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trips.add(extractTripFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    // Get all trips (for admin purposes)
    public List<Trip> getAllTrips() {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM Trips ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trips.add(extractTripFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }
    
    // Get trip count (for admin dashboard)
    public int getTripCount() {
        String sql = "SELECT COUNT(*) FROM Trips";
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

    // Get trip history for a customer
    public List<Trip> getTripHistoryByCustomerId(int customerId) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM Trips WHERE CustomerID = ? AND TripStatus IN ('Completed', 'Cancelled') ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trips.add(extractTripFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    // Get trip history for a driver
    public List<Trip> getTripHistoryByDriverId(int driverId) {
        List<Trip> trips = new ArrayList<>();
        String sql = "SELECT * FROM Trips WHERE DriverID = ? AND TripStatus IN ('Completed', 'Cancelled') ORDER BY BookingTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trips.add(extractTripFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    // Complete a trip
    public boolean completeTrip(int tripId) {
        String sql = "UPDATE Trips SET TripStatus = 'Completed', CompletionTime = ? WHERE TripID = ? AND TripStatus IN ('Accepted', 'InProgress', 'Arrived')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, tripId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------- HELPER METHODS -------------------
    
    // Calculate distance between two points using Haversine formula
    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Radius of the earth in km
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c; // Distance in km
    }
    
    // Calculate price based on distance and vehicle type
    private double calculatePrice(double distance, String vehicleType) {
        double basePrice = 50.0; // Base price in LKR
        double pricePerKm = 25.0; // Price per km in LKR
        
        // Adjust price based on vehicle type
        if (vehicleType != null) {
            switch (vehicleType.toLowerCase()) {
                case "car":
                    pricePerKm = 30.0;
                    basePrice = 70.0;
                    break;
                case "tuk tuk":
                    pricePerKm = 20.0;
                    basePrice = 40.0;
                    break;
                case "van":
                    pricePerKm = 35.0;
                    basePrice = 80.0;
                    break;
                default:
                    pricePerKm = 25.0;
                    basePrice = 50.0;
            }
        }
        
        return basePrice + (distance * pricePerKm);
    }

    // Helper method to extract trip from ResultSet
    private Trip extractTripFromResultSet(ResultSet rs) throws SQLException {
        Trip trip = new Trip();
        trip.setTripId(rs.getInt("TripID"));
        trip.setCustomerId(rs.getInt("CustomerID"));
        // Null checks for nullable columns to avoid errors
        Integer driverId = rs.getObject("DriverID", Integer.class);
        if (driverId != null) {
            trip.setDriverId(driverId);
        } else {
            trip.setDriverId(0); // or handle as null
        }
        
        // Handle pickup and dropoff locations with proper null checks
        String pickupLocation = rs.getString("PickupLocation");
        trip.setPickupLocation(pickupLocation != null ? pickupLocation : "");
        
        String dropoffLocation = rs.getString("DropOffLocation");
        trip.setDropoffLocation(dropoffLocation != null ? dropoffLocation : "");
        
        // Handle coordinates with null checks - these columns may not exist in database
        try {
            Double pickupLat = rs.getObject("PickupLatitude", Double.class);
            trip.setPickupLatitude(pickupLat != null ? pickupLat : 0.0);
        } catch (SQLException e) {
            if (e.getMessage().contains("PickupLatitude")) {
                trip.setPickupLatitude(0.0);
            } else {
                throw e;
            }
        }
        
        try {
            Double pickupLng = rs.getObject("PickupLongitude", Double.class);
            trip.setPickupLongitude(pickupLng != null ? pickupLng : 0.0);
        } catch (SQLException e) {
            if (e.getMessage().contains("PickupLongitude")) {
                trip.setPickupLongitude(0.0);
            } else {
                throw e;
            }
        }
        
        try {
            Double dropoffLat = rs.getObject("DropOffLatitude", Double.class);
            trip.setDropoffLatitude(dropoffLat != null ? dropoffLat : 0.0);
        } catch (SQLException e) {
            if (e.getMessage().contains("DropOffLatitude")) {
                trip.setDropoffLatitude(0.0);
            } else {
                throw e;
            }
        }
        
        try {
            Double dropoffLng = rs.getObject("DropOffLongitude", Double.class);
            trip.setDropoffLongitude(dropoffLng != null ? dropoffLng : 0.0);
        } catch (SQLException e) {
            if (e.getMessage().contains("DropOffLongitude")) {
                trip.setDropoffLongitude(0.0);
            } else {
                throw e;
            }
        }
        
        // Corrected: Handle the distance value safely
        double distance = rs.getDouble("distance");
        trip.setDistance(String.valueOf(distance));

        trip.setVehicleType(rs.getString("vehicle_type"));
        trip.setPrice(rs.getDouble("price"));
        
        // Handle tip field with null check
        try {
            Double tip = rs.getObject("tip", Double.class);
            trip.setTip(tip != null ? tip : 0.0);
        } catch (SQLException e) {
            if (e.getMessage().contains("tip")) {
                trip.setTip(0.0);
            } else {
                throw e;
            }
        }
        
        trip.setStatus(rs.getString("TripStatus"));
        trip.setBookingTime(rs.getTimestamp("BookingTime"));
        trip.setCompletionTime(rs.getTimestamp("CompletionTime"));
        return trip;
    }
}

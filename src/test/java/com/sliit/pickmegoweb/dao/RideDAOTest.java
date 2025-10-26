package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.Trip;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.Timestamp;
import java.util.List;

/**
 * Test class for RideDAO functionality, specifically testing the 2-ride limit for drivers
 */
public class RideDAOTest {
    
    private RideDAO rideDAO;
    
    @BeforeEach
    public void setUp() {
        rideDAO = new RideDAO();
    }
    
    @Test
    public void testGetActiveTripCountByDriverId() {
        // Test getting active trip count for a driver
        int driverId = 1;
        int activeCount = rideDAO.getActiveTripCountByDriverId(driverId);
        
        // Should return a non-negative number
        assertTrue(activeCount >= 0, "Active trip count should be non-negative");
        
        System.out.println("Driver " + driverId + " has " + activeCount + " active trips");
    }
    
    @Test
    public void testAcceptTripWithLimit() {
        // Test accepting trips up to the limit
        int driverId = 1;
        int tripId1 = 1;
        int tripId2 = 2;
        int tripId3 = 3;
        
        // Get initial active count
        int initialCount = rideDAO.getActiveTripCountByDriverId(driverId);
        System.out.println("Initial active trip count: " + initialCount);
        
        // Try to accept first trip
        boolean success1 = rideDAO.acceptTrip(tripId1, driverId);
        System.out.println("Accept trip " + tripId1 + ": " + success1);
        
        // Try to accept second trip
        boolean success2 = rideDAO.acceptTrip(tripId2, driverId);
        System.out.println("Accept trip " + tripId2 + ": " + success2);
        
        // Try to accept third trip (should fail if limit is enforced)
        boolean success3 = rideDAO.acceptTrip(tripId3, driverId);
        System.out.println("Accept trip " + tripId3 + ": " + success3);
        
        // Check final active count
        int finalCount = rideDAO.getActiveTripCountByDriverId(driverId);
        System.out.println("Final active trip count: " + finalCount);
        
        // Verify that the count doesn't exceed 2
        assertTrue(finalCount <= 2, "Active trip count should not exceed 2");
    }
    
    @Test
    public void testGetAcceptedTripsByDriverId() {
        // Test getting accepted trips for a driver
        int driverId = 1;
        List<Trip> acceptedTrips = rideDAO.getAcceptedTripsByDriverId(driverId);
        
        // Should return a list (may be empty)
        assertNotNull(acceptedTrips, "Accepted trips list should not be null");
        
        System.out.println("Driver " + driverId + " has " + acceptedTrips.size() + " accepted trips");
        
        // Print details of accepted trips
        for (Trip trip : acceptedTrips) {
            System.out.println("Accepted Trip ID: " + trip.getTripId() + 
                             ", Pickup: " + trip.getPickupLocation() + 
                             ", Dropoff: " + trip.getDropoffLocation() +
                             ", Status: " + trip.getStatus());
        }
    }
    
    @Test
    public void testRideLimitEnforcement() {
        // Test that the 2-ride limit is properly enforced
        int driverId = 999; // Use a test driver ID
        
        // Create test trips
        Trip trip1 = createTestTrip(1, driverId, "Test Pickup 1", "Test Dropoff 1");
        Trip trip2 = createTestTrip(2, driverId, "Test Pickup 2", "Test Dropoff 2");
        Trip trip3 = createTestTrip(3, driverId, "Test Pickup 3", "Test Dropoff 3");
        
        // Try to accept trips
        boolean accept1 = rideDAO.acceptTrip(trip1.getTripId(), driverId);
        boolean accept2 = rideDAO.acceptTrip(trip2.getTripId(), driverId);
        boolean accept3 = rideDAO.acceptTrip(trip3.getTripId(), driverId);
        
        // Check active count
        int activeCount = rideDAO.getActiveTripCountByDriverId(driverId);
        
        System.out.println("Accept results: " + accept1 + ", " + accept2 + ", " + accept3);
        System.out.println("Active trip count: " + activeCount);
        
        // The third acceptance should fail if limit is enforced
        if (accept1 && accept2) {
            assertFalse(accept3, "Third trip acceptance should fail due to 2-ride limit");
            assertEquals(2, activeCount, "Active trip count should be exactly 2");
        }
    }
    
    @Test
    public void testUpdateTripPickupLocation() {
        // Test updating only the pickup location of a trip
        int tripId = 1; // Use an existing trip ID
        String newPickupLocation = "New Pickup Location";
        double newPickupLat = 6.9271; // Colombo coordinates
        double newPickupLng = 79.8612;
        
        // Get the trip before update
        Trip tripBefore = rideDAO.getTripById(tripId);
        if (tripBefore == null) {
            System.out.println("No trip found with ID " + tripId + ". Skipping pickup location update test.");
            return;
        }
        
        System.out.println("Before update - Pickup: " + tripBefore.getPickupLocation() + 
                          ", Dropoff: " + tripBefore.getDropoffLocation() +
                          ", Distance: " + tripBefore.getDistance() +
                          ", Price: " + tripBefore.getPrice());
        
        // Update only the pickup location
        boolean updateSuccess = rideDAO.updateTripPickupLocation(tripId, newPickupLocation, newPickupLat, newPickupLng);
        
        assertTrue(updateSuccess, "Pickup location update should succeed");
        
        // Get the trip after update
        Trip tripAfter = rideDAO.getTripById(tripId);
        assertNotNull(tripAfter, "Trip should still exist after update");
        
        System.out.println("After update - Pickup: " + tripAfter.getPickupLocation() + 
                          ", Dropoff: " + tripAfter.getDropoffLocation() +
                          ", Distance: " + tripAfter.getDistance() +
                          ", Price: " + tripAfter.getPrice());
        
        // Verify pickup location was updated
        assertEquals(newPickupLocation, tripAfter.getPickupLocation(), "Pickup location should be updated");
        assertEquals(newPickupLat, tripAfter.getPickupLatitude(), 0.0001, "Pickup latitude should be updated");
        assertEquals(newPickupLng, tripAfter.getPickupLongitude(), 0.0001, "Pickup longitude should be updated");
        
        // Verify dropoff location was NOT changed
        assertEquals(tripBefore.getDropoffLocation(), tripAfter.getDropoffLocation(), "Dropoff location should remain unchanged");
        assertEquals(tripBefore.getDropoffLatitude(), tripAfter.getDropoffLatitude(), 0.0001, "Dropoff latitude should remain unchanged");
        assertEquals(tripBefore.getDropoffLongitude(), tripAfter.getDropoffLongitude(), 0.0001, "Dropoff longitude should remain unchanged");
        
        // Verify distance and price were recalculated
        assertNotEquals(tripBefore.getDistance(), tripAfter.getDistance(), "Distance should be recalculated");
        assertNotEquals(tripBefore.getPrice(), tripAfter.getPrice(), "Price should be recalculated");
        
        System.out.println("Pickup location update test passed successfully!");
    }
    
    private Trip createTestTrip(int tripId, int customerId, String pickup, String dropoff) {
        Trip trip = new Trip();
        trip.setTripId(tripId);
        trip.setCustomerId(customerId);
        trip.setPickupLocation(pickup);
        trip.setDropoffLocation(dropoff);
        trip.setDistance("5.0");
        trip.setVehicleType("car");
        trip.setPrice(150.0);
        trip.setStatus("Pending");
        trip.setBookingTime(new Timestamp(System.currentTimeMillis()));
        return trip;
    }
}

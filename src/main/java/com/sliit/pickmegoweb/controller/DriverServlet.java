package com.sliit.pickmegoweb.controller;

import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.dao.NotificationDAO;
import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.model.User;
import com.sliit.pickmegoweb.model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
import com.google.gson.Gson;

/**
 * DriverServlet handles all requests for the Driver Dashboard.
 * Drivers can view pending rides, accept trips, update status, etc.
 */
@WebServlet("/DriverServlet")
public class DriverServlet extends HttpServlet {
    private RideDAO rideDAO;       // DAO to interact with DB
    private NotificationDAO notificationDAO; // DAO for notifications
    private final Gson gson = new Gson(); // For converting objects to JSON

    @Override
    public void init() {
        rideDAO = new RideDAO(); // Initialize DAO
        notificationDAO = new NotificationDAO(); // Initialize notification DAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action"); // What action the driver wants
        HttpSession session = request.getSession(false);

        // Check if driver is logged in
        if (session == null || session.getAttribute("user") == null ||
                !"Driver".equals(((User) session.getAttribute("user")).getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        User driver = (User) session.getAttribute("user");

        // Prepare response as JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            switch (action) {
                case "viewRequests": {
                    // Get driver's vehicle type
                    String vehicleType = driver.getVehicleType();
                    if (vehicleType == null || vehicleType.isEmpty()) {
                        vehicleType = "Car";
                    }
                    // Get pending trips for this vehicle type
                    List<Trip> pendingTrips = rideDAO.getPendingTripsByVehicleType(vehicleType);
                    
                    // Debug logging
                    System.out.println("DEBUG: Driver vehicle type: " + vehicleType);
                    System.out.println("DEBUG: Found " + pendingTrips.size() + " pending trips");
                    for (Trip trip : pendingTrips) {
                        System.out.println("DEBUG: Trip ID: " + trip.getTripId() + 
                                         ", Pickup: " + trip.getPickupLocation() + 
                                         ", Dropoff: " + trip.getDropoffLocation());
                    }
                    
                    out.print(gson.toJson(pendingTrips));
                    break;
                }

                case "viewCurrentTrip": {
                    // Get the current active trip for this driver
                    Trip currentTrip = rideDAO.getCurrentTripByDriverId(driver.getId());
                    
                    // Debug logging
                    System.out.println("DEBUG: Driver ID: " + driver.getId());
                    if (currentTrip != null) {
                        System.out.println("DEBUG: Current trip found - ID: " + currentTrip.getTripId() + 
                                         ", Pickup: " + currentTrip.getPickupLocation() + 
                                         ", Dropoff: " + currentTrip.getDropoffLocation() +
                                         ", Status: " + currentTrip.getStatus());
                    } else {
                        System.out.println("DEBUG: No current trip found for driver");
                    }
                    
                    out.print(gson.toJson(currentTrip));
                    break;
                }

                case "acceptTrip": {
                    int tripId = Integer.parseInt(request.getParameter("tripId"));
                    
                    // Check current active trip count before attempting to accept
                    int activeTripCount = rideDAO.getActiveTripCountByDriverId(driver.getId());
                    if (activeTripCount >= 2) {
                        out.print("{\"success\": false, \"message\": \"You already have 2 active trips. Complete or cancel one before accepting another.\"}");
                        break;
                    }
                    
                    boolean success = rideDAO.acceptTrip(tripId, driver.getId());
                    if (success) {
                        // Create notification for customer (with error handling)
                        try {
                            createCustomerNotification(tripId, driver.getId(), "RIDE_ACCEPTED", 
                                "Your ride has been accepted by " + driver.getFirstName() + " " + driver.getLastName());
                        } catch (Exception e) {
                            System.err.println("Failed to create notification: " + e.getMessage());
                            // Continue execution even if notification fails
                        }
                        out.print("{\"success\": true, \"message\": \"Trip accepted successfully.\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"Failed to accept trip. It may have been accepted by another driver.\"}");
                    }
                    break;
                }

                case "rejectTrip": {
                    int tripId = Integer.parseInt(request.getParameter("tripId"));
                    boolean success = rideDAO.rejectTrip(tripId);
                    if (success) {
                        // Get trip details to find customer ID
                        Trip trip = rideDAO.getTripById(tripId);
                        if (trip != null) {
                            // Create notification for customer
                            createCustomerNotification(tripId, driver.getId(), "RIDE_REJECTED", 
                                "Your ride request was declined by " + driver.getFirstName() + " " + driver.getLastName());
                        }
                        out.print("{\"success\": true, \"message\": \"Trip rejected.\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"Failed to reject trip.\"}");
                    }
                    break;
                }

                case "updateStatus": {
                    int tripIdToUpdate = Integer.parseInt(request.getParameter("tripId"));
                    String status = request.getParameter("status");
                    boolean statusUpdated = rideDAO.updateTripStatus(tripIdToUpdate, status);
                    if (statusUpdated) {
                        // Create notification for customer based on status (with error handling)
                        try {
                            createTripStatusNotification(tripIdToUpdate, driver, status);
                        } catch (Exception e) {
                            System.err.println("Failed to create trip status notification: " + e.getMessage());
                            // Continue execution even if notification fails
                        }
                        out.print("{\"success\": true, \"message\": \"Status updated.\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"Failed to update status.\"}");
                    }
                    break;
                }

                case "checkNewRides": {
                    // Check if there are new rides since last time
                    long lastCheckTime = Long.parseLong(request.getParameter("lastCheck"));
                    Timestamp since = new Timestamp(lastCheckTime);

                    String vType = driver.getVehicleType();
                    if (vType == null || vType.isEmpty()) {
                        vType = "Car";
                    }

                    List<Trip> newTrips = rideDAO.getNewTripsSince(vType, since);

                    String jsonResponse = "{\"newTrips\": " + gson.toJson(newTrips) +
                            ", \"currentTime\": " + System.currentTimeMillis() + "}";
                    out.print(jsonResponse);
                    break;
                }

                case "getPendingCount": {
                    String vTypeForCount = driver.getVehicleType();
                    if (vTypeForCount == null || vTypeForCount.isEmpty()) {
                        vTypeForCount = "Car";
                    }
                    int count = rideDAO.getPendingTripCountByVehicleType(vTypeForCount);
                    out.print("{\"count\": " + count + "}");
                    break;
                }

                case "viewAcceptedTrips": {
                    // Get all accepted trips for this driver
                    List<Trip> acceptedTrips = rideDAO.getAcceptedTripsByDriverId(driver.getId());
                    
                    // Debug logging
                    System.out.println("DEBUG: Driver ID: " + driver.getId());
                    System.out.println("DEBUG: Found " + acceptedTrips.size() + " accepted trips");
                    for (Trip trip : acceptedTrips) {
                        System.out.println("DEBUG: Accepted Trip ID: " + trip.getTripId() + 
                                         ", Pickup: " + trip.getPickupLocation() + 
                                         ", Dropoff: " + trip.getDropoffLocation() +
                                         ", Status: " + trip.getStatus());
                    }
                    
                    out.print(gson.toJson(acceptedTrips));
                    break;
                }

                case "getActiveTripCount": {
                    int activeTripCount = rideDAO.getActiveTripCountByDriverId(driver.getId());
                    out.print("{\"activeTripCount\": " + activeTripCount + "}");
                    break;
                }

                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
    }

    // For POST requests, just call doGet (since logic is the same)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void createCustomerNotification(int tripId, int driverId, String notificationType, String message) {
        try {
            // Check if notificationDAO is available
            if (notificationDAO == null) {
                System.err.println("NotificationDAO not available - skipping notification creation");
                return;
            }
            
            // Get trip details to find customer ID
            Trip trip = rideDAO.getTripById(tripId);
            if (trip != null) {
                Notification notification = new Notification(
                    tripId, 
                    driverId, 
                    trip.getCustomerId(), 
                    notificationType, 
                    message
                );
                boolean success = notificationDAO.createNotification(notification);
                if (!success) {
                    System.err.println("Failed to create notification in database");
                }
            }
        } catch (Exception e) {
            System.err.println("Error creating customer notification: " + e.getMessage());
            // Don't print stack trace for database connection issues
            if (!e.getMessage().contains("Invalid column name")) {
                e.printStackTrace();
            }
        }
    }
    
    private void createTripStatusNotification(int tripId, User driver, String status) {
        try {
            // Check if notificationDAO is available
            if (notificationDAO == null) {
                System.err.println("NotificationDAO not available - skipping trip status notification creation");
                return;
            }
            
            // Get trip details to find customer ID
            Trip trip = rideDAO.getTripById(tripId);
            if (trip != null) {
                String notificationType = "";
                String message = "";
                
                switch (status) {
                    case "On The Way":
                        notificationType = "DRIVER_ON_THE_WAY";
                        message = driver.getFirstName() + " " + driver.getLastName() + " is on the way to pick you up!";
                        break;
                    case "Arrived":
                        notificationType = "DRIVER_ARRIVED";
                        message = driver.getFirstName() + " " + driver.getLastName() + " has arrived at your pickup location!";
                        break;
                    case "Completed":
                        notificationType = "TRIP_COMPLETED";
                        message = "Your trip has been completed by " + driver.getFirstName() + " " + driver.getLastName() + ". Thank you for using PickMeGo!";
                        break;
                    case "Cancelled":
                        notificationType = "TRIP_CANCELLED";
                        message = "Your trip has been cancelled by " + driver.getFirstName() + " " + driver.getLastName() + ". We apologize for the inconvenience.";
                        break;
                    default:
                        notificationType = "TRIP_STATUS_UPDATE";
                        message = "Your trip status has been updated to: " + status;
                        break;
                }
                
                Notification notification = new Notification(
                    tripId, 
                    driver.getId(), 
                    trip.getCustomerId(), 
                    notificationType, 
                    message
                );
                boolean success = notificationDAO.createNotification(notification);
                if (!success) {
                    System.err.println("Failed to create trip status notification in database");
                }
            }
        } catch (Exception e) {
            System.err.println("Error creating trip status notification: " + e.getMessage());
            // Don't print stack trace for database connection issues
            if (!e.getMessage().contains("Invalid column name")) {
                e.printStackTrace();
            }
        }
    }
}

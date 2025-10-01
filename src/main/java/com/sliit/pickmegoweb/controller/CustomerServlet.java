package com.sliit.pickmegoweb.controller;

import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.dao.NotificationDAO;
import com.sliit.pickmegoweb.dao.UserDAO;
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
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import com.google.gson.Gson;

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    private RideDAO rideDAO;
    private NotificationDAO notificationDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        rideDAO = new RideDAO();
        notificationDAO = new NotificationDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action != null && action.equals("getCurrentTrip")) {
            getCurrentTrip(request, response);
        } else {
            // Redirect to the book ride page for other GET requests
            response.sendRedirect(request.getContextPath() + "/views/customer/book_ride.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null && action.equals("bookRide")) {
            bookRide(request, response);
        } else if (action != null && action.equals("updateTrip")) {
            updateTrip(request, response);
        } else if (action != null && action.equals("cancelTrip")) {
            cancelTrip(request, response);
        } else {
            // Handle unknown actions
            request.setAttribute("error", "Invalid action requested.");
            request.getRequestDispatcher("/views/customer/book_ride.jsp").forward(request, response);
        }
    }

    private void bookRide(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        User customer = (User) session.getAttribute("user");
        System.out.println("DEBUG: User from session: " + (customer != null ? customer.getEmail() : "null user"));

        if (customer == null || !"Customer".equals(customer.getRole())) {
            System.out.println("DEBUG: User is not a customer or session expired. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        try {
            // Retrieve all necessary parameters from the form
            String pickupLocation = sanitizeInput(request.getParameter("pickupLocation"));
            String dropoffLocation = sanitizeInput(request.getParameter("dropoffLocation"));
            String distance = sanitizeInput(request.getParameter("distance"));
            String pickupLatStr = sanitizeInput(request.getParameter("pickupLat"));
            String pickupLngStr = sanitizeInput(request.getParameter("pickupLng"));
            String dropoffLatStr = sanitizeInput(request.getParameter("dropoffLat"));
            String dropoffLngStr = sanitizeInput(request.getParameter("dropoffLng"));
            String vehicleType = sanitizeInput(request.getParameter("vehicleType"));
            String finalPriceStr = sanitizeInput(request.getParameter("finalPrice"));

            System.out.println("DEBUG: Received Parameters:");
            System.out.println("  Pickup Location: " + pickupLocation);
            System.out.println("  Drop-off Location: " + dropoffLocation);
            System.out.println("  Distance: " + distance);
            System.out.println("  Pickup Lat: " + pickupLatStr);
            System.out.println("  Pickup Lng: " + pickupLngStr);
            System.out.println("  Drop-off Lat: " + dropoffLatStr);
            System.out.println("  Drop-off Lng: " + dropoffLngStr);
            System.out.println("  Vehicle Type: " + vehicleType);
            System.out.println("  Final Price: " + finalPriceStr);

            // Validate essential parameters
            if (isEmpty(pickupLatStr) || isEmpty(dropoffLatStr) || isEmpty(pickupLocation) || isEmpty(dropoffLocation) || isEmpty(vehicleType) || isEmpty(finalPriceStr)) {
                System.out.println("DEBUG: Missing required parameters. Redirecting back to form.");
                request.setAttribute("error", "Please select valid pickup and drop-off locations and a vehicle type.");
                request.getRequestDispatcher("/views/customer/book_ride.jsp").forward(request, response);
                return;
            }

            double pickupLat = Double.parseDouble(pickupLatStr);
            double pickupLng = Double.parseDouble(pickupLngStr);
            double dropoffLat = Double.parseDouble(dropoffLatStr);
            double dropoffLng = Double.parseDouble(dropoffLngStr);
            double finalPrice = Double.parseDouble(finalPriceStr);

            // Validate coordinate ranges
            if (!isValidLatitude(pickupLat) || !isValidLongitude(pickupLng) ||
                    !isValidLatitude(dropoffLat) || !isValidLongitude(dropoffLng)) {
                request.setAttribute("error", "Invalid coordinates provided. Please select a valid location.");
                request.getRequestDispatcher("/views/customer/book_ride.jsp").forward(request, response);
                return;
            }

            // Create a new Trip object
            Trip newTrip = new Trip();
            newTrip.setCustomerId(customer.getId());
            newTrip.setPickupLocation(pickupLocation);
            newTrip.setDropoffLocation(dropoffLocation);
            newTrip.setDistance(distance);
            newTrip.setPickupLatitude(pickupLat);
            newTrip.setPickupLongitude(pickupLng);
            newTrip.setDropoffLatitude(dropoffLat);
            newTrip.setDropoffLongitude(dropoffLng);
            newTrip.setStatus("Pending");
            newTrip.setBookingTime(new java.sql.Timestamp(new Date().getTime()));
            newTrip.setVehicleType(vehicleType);
            newTrip.setPrice(finalPrice);

            int tripId = rideDAO.createTrip(newTrip);

            if (tripId > 0) {
                // Create notifications for drivers with matching vehicle type
                createNotificationsForDrivers(newTrip, customer);
                
                // Set trip in session for status page to use
                session.setAttribute("currentTrip", newTrip);
                request.setAttribute("message", "Ride booking successful! Waiting for a driver to accept.");
                response.sendRedirect(request.getContextPath() + "/views/customer/view_status.jsp");
            } else {
                request.setAttribute("error", "Ride booking failed. Please try again.");
                request.getRequestDispatcher("/views/customer/book_ride.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            System.err.println("DEBUG: NumberFormatException - one of the numeric parameters is not a valid number.");
            e.printStackTrace();
            request.setAttribute("error", "Invalid data provided. Please try again.");
            request.getRequestDispatcher("/views/customer/book_ride.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("DEBUG: An unexpected error occurred.");
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred during booking.");
            request.getRequestDispatcher("/views/customer/book_ride.jsp").forward(request, response);
        }
    }

    private String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.trim();
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private boolean isValidLatitude(double latitude) {
        return latitude >= -90 && latitude <= 90;
    }

    private boolean isValidLongitude(double longitude) {
        return longitude >= -180 && longitude <= 180;
    }
    
    private void createNotificationsForDrivers(Trip trip, User customer) {
        try {
            // Get all drivers with matching vehicle type
            List<User> drivers = userDAO.getDriversByVehicleType(trip.getVehicleType());
            
            for (User driver : drivers) {
                // Extract numeric value from distance string (e.g., "47.1 km" -> "47.1")
                String distanceValue = trip.getDistance().replaceAll("[^0-9.]", "");
                double distance = Double.parseDouble(distanceValue);
                
                String message = String.format("New ride request: %s to %s (%.2f km) - Rs.%.2f", 
                    trip.getPickupLocation(), 
                    trip.getDropoffLocation(), 
                    distance, 
                    trip.getPrice());
                
                Notification notification = new Notification(
                    trip.getTripId(), 
                    driver.getId(), 
                    customer.getId(), 
                    "RIDE_REQUEST", 
                    message
                );
                
                notificationDAO.createNotification(notification);
            }
            
            System.out.println("Created notifications for " + drivers.size() + " drivers with vehicle type: " + trip.getVehicleType());
        } catch (Exception e) {
            System.err.println("Error creating notifications for drivers: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void updateTrip(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        User customer = (User) session.getAttribute("user");
        if (customer == null || !"Customer".equals(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        try {
            // Get trip ID
            String tripIdStr = sanitizeInput(request.getParameter("tripId"));
            if (isEmpty(tripIdStr)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"Trip ID is required\"}");
                return;
            }

            int tripId = Integer.parseInt(tripIdStr);
            
            // Verify the trip belongs to this customer
            Trip currentTrip = rideDAO.getTripById(tripId);
            if (currentTrip == null || currentTrip.getCustomerId() != customer.getId()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"error\": \"Trip not found or access denied\"}");
                return;
            }

            // Check if trip can be updated (only Pending or Accepted trips)
            if (!"Pending".equals(currentTrip.getStatus()) && !"Accepted".equals(currentTrip.getStatus())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"Trip cannot be updated in current status\"}");
                return;
            }

            // Get new location parameters
            String pickupLocation = sanitizeInput(request.getParameter("pickupLocation"));
            String dropoffLocation = sanitizeInput(request.getParameter("dropoffLocation"));
            String pickupLatStr = sanitizeInput(request.getParameter("pickupLat"));
            String pickupLngStr = sanitizeInput(request.getParameter("pickupLng"));
            String dropoffLatStr = sanitizeInput(request.getParameter("dropoffLat"));
            String dropoffLngStr = sanitizeInput(request.getParameter("dropoffLng"));

            // Validate parameters
            if (isEmpty(pickupLatStr) || isEmpty(dropoffLatStr) || isEmpty(pickupLocation) || 
                isEmpty(dropoffLocation)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"All location parameters are required\"}");
                return;
            }

            double pickupLat = Double.parseDouble(pickupLatStr);
            double pickupLng = Double.parseDouble(pickupLngStr);
            double dropoffLat = Double.parseDouble(dropoffLatStr);
            double dropoffLng = Double.parseDouble(dropoffLngStr);

            // Validate coordinate ranges
            if (!isValidLatitude(pickupLat) || !isValidLongitude(pickupLng) ||
                    !isValidLatitude(dropoffLat) || !isValidLongitude(dropoffLng)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"Invalid coordinates provided\"}");
                return;
            }

            // Update the trip (distance and price will be calculated automatically)
            boolean isUpdated = rideDAO.updateTripLocations(tripId, pickupLocation, dropoffLocation,
                    pickupLat, pickupLng, dropoffLat, dropoffLng);

            if (isUpdated) {
                // Create notification for driver if trip is accepted
                if ("Accepted".equals(currentTrip.getStatus()) && currentTrip.getDriverId() > 0) {
                    String message = String.format("Trip updated: %s to %s", pickupLocation, dropoffLocation);
                    Notification notification = new Notification(
                        tripId, 
                        currentTrip.getDriverId(), 
                        customer.getId(), 
                        "TRIP_UPDATED", 
                        message
                    );
                    notificationDAO.createNotification(notification);
                }

                response.setContentType("application/json");
                response.getWriter().print("{\"success\": true, \"message\": \"Trip updated successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"error\": \"Failed to update trip\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\": \"Invalid numeric parameters\"}");
        } catch (Exception e) {
            System.out.println("DEBUG: Error in updateTrip: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"An error occurred while updating trip: " + e.getMessage() + "\"}");
        }
    }

    private void cancelTrip(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        User customer = (User) session.getAttribute("user");
        if (customer == null || !"Customer".equals(customer.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        try {
            // Get trip ID
            String tripIdStr = sanitizeInput(request.getParameter("tripId"));
            if (isEmpty(tripIdStr)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"Trip ID is required\"}");
                return;
            }

            int tripId = Integer.parseInt(tripIdStr);
            
            // Verify the trip belongs to this customer
            Trip currentTrip = rideDAO.getTripById(tripId);
            if (currentTrip == null || currentTrip.getCustomerId() != customer.getId()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"error\": \"Trip not found or access denied\"}");
                return;
            }

            // Check if trip can be cancelled (only Pending or Accepted trips)
            if (!"Pending".equals(currentTrip.getStatus()) && !"Accepted".equals(currentTrip.getStatus())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"Trip cannot be cancelled in current status\"}");
                return;
            }

            // Cancel the trip
            boolean isCancelled = rideDAO.cancelTrip(tripId);

            if (isCancelled) {
                // Create notification for driver if trip is accepted
                if ("Accepted".equals(currentTrip.getStatus()) && currentTrip.getDriverId() > 0) {
                    String message = "Trip has been cancelled by the customer";
                    Notification notification = new Notification(
                        tripId, 
                        currentTrip.getDriverId(), 
                        customer.getId(), 
                        "TRIP_CANCELLED", 
                        message
                    );
                    notificationDAO.createNotification(notification);
                }

                // Create notification for customer
                String customerMessage = "Your trip has been cancelled successfully";
                Notification customerNotification = new Notification(
                    tripId, 
                    customer.getId(), 
                    customer.getId(), 
                    "TRIP_CANCELLED", 
                    customerMessage
                );
                notificationDAO.createNotification(customerNotification);

                response.setContentType("application/json");
                response.getWriter().print("{\"success\": true, \"message\": \"Trip cancelled successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"error\": \"Failed to cancel trip\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\": \"Invalid trip ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"An error occurred while cancelling trip\"}");
        }
    }

    private void getCurrentTrip(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User customer = (User) request.getSession().getAttribute("user");
            if (customer == null || !"Customer".equals(customer.getRole())) {
                response.sendRedirect(request.getContextPath() + "/views/login.jsp");
                return;
            }
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            // Get the current trip for this customer
            Trip currentTrip = rideDAO.getCurrentTripByCustomerId(customer.getId());
            
            if (currentTrip != null) {
                // If trip has a driver, get driver details
                if (currentTrip.getDriverId() > 0) {
                    User driver = userDAO.getUserById(currentTrip.getDriverId());
                    if (driver != null) {
                        // Create a response object with trip and driver details
                        Map<String, Object> responseData = new HashMap<>();
                        responseData.put("trip", currentTrip);
                        responseData.put("driver", driver);
                        responseData.put("hasDriver", true);
                        
                        Gson gson = new Gson();
                        out.print(gson.toJson(responseData));
                    } else {
                        // Trip exists but driver not found
                        Map<String, Object> responseData = new HashMap<>();
                        responseData.put("trip", currentTrip);
                        responseData.put("hasDriver", false);
                        
                        Gson gson = new Gson();
                        out.print(gson.toJson(responseData));
                    }
                } else {
                    // Trip exists but no driver assigned yet
                    Map<String, Object> responseData = new HashMap<>();
                    responseData.put("trip", currentTrip);
                    responseData.put("hasDriver", false);
                    
                    Gson gson = new Gson();
                    out.print(gson.toJson(responseData));
                }
            } else {
                // No current trip
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("trip", null);
                responseData.put("hasDriver", false);
                
                Gson gson = new Gson();
                out.print(gson.toJson(responseData));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"Failed to get current trip\"}");
        }
    }
}
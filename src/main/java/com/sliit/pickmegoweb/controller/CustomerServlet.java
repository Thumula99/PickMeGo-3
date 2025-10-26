package com.sliit.pickmegoweb.controller;
import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.dao.NotificationDAO;
import com.sliit.pickmegoweb.dao.UserDAO;
import com.sliit.pickmegoweb.dao.NoticeDAO;
import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.model.User;
import com.sliit.pickmegoweb.model.Notification;
import com.sliit.pickmegoweb.model.Notice;
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
    private NoticeDAO noticeDAO;

    @Override
    public void init() {
        rideDAO = new RideDAO();
        notificationDAO = new NotificationDAO();
        userDAO = new UserDAO();
        noticeDAO = new NoticeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action != null && action.equals("getCurrentTrip")) {
            getCurrentTrip(request, response);
        } else if (action != null && action.equals("getNotices")) {
            getNotices(request, response);
        } else {
            // Redirect to the book ride page for other GET requests
            response.sendRedirect(request.getContextPath() + "/views/customer/book_ride.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("CustomerServlet.doPost - Method called");
        String action = request.getParameter("action");
        System.out.println("CustomerServlet.doPost - Action: " + action);
        
        // Debug: Log all parameters
        System.out.println("CustomerServlet.doPost - All parameters:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("  " + paramName + " = " + paramValue);
        }
        if (action != null && action.equals("bookRide")) {
            bookRide(request, response);
        } else if (action != null && action.equals("updateTrip")) {
            updateTrip(request, response);
        } else if (action != null && action.equals("updateTip")) {
            updateTip(request, response);
        } else if (action != null && action.equals("cancelTrip")) {
            cancelTrip(request, response);
        } else {
            System.out.println("CustomerServlet.doPost - Unknown action: " + action);
            // Handle unknown actions with JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\": false, \"error\": \"Invalid action requested: " + action + "\"}");
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
            String tipStr = sanitizeInput(request.getParameter("tip"));

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
            System.out.println("  Tip: " + tipStr);

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
            
            // Parse tip amount (default to 0 if not provided)
            double tipAmount = 0.0;
            if (!isEmpty(tipStr)) {
                try {
                    tipAmount = Double.parseDouble(tipStr);
                    if (tipAmount < 0) {
                        tipAmount = 0.0; // Ensure tip is not negative
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG: Invalid tip amount, using 0.0");
                    tipAmount = 0.0;
                }
            }

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
            newTrip.setTip(tipAmount);

            int tripId = rideDAO.createTrip(newTrip);

            if (tripId > 0) {
                // Set success message for booking with tip
                if (tipAmount > 0) {
                    session.setAttribute("successMessage", "Trip booked successfully with tip of LKR " + String.format("%.2f", tipAmount) + "!");
                } else {
                    session.setAttribute("successMessage", "Trip booked successfully!");
                }
                
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
        System.out.println("CustomerServlet.updateTrip - Method called");
        System.out.println("CustomerServlet.updateTrip - Request action: " + request.getParameter("action"));
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\": false, \"error\": \"Session expired. Please login again.\"}");
            return;
        }

        User customer = (User) session.getAttribute("user");
        if (customer == null || !"Customer".equals(customer.getRole())) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\": false, \"error\": \"Authentication required. Please login as a customer.\"}");
            return;
        }

        try {
            // Get trip ID
            String tripIdStr = sanitizeInput(request.getParameter("tripId"));
            if (isEmpty(tripIdStr)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"Trip ID is required\"}");
                return;
            }

            int tripId = Integer.parseInt(tripIdStr);
            
            // Verify the trip belongs to this customer
            Trip currentTrip = rideDAO.getTripById(tripId);
            System.out.println("CustomerServlet.updateTrip - Retrieved trip: " + (currentTrip != null ? "Found" : "Not found"));
            if (currentTrip != null) {
                System.out.println("CustomerServlet.updateTrip - Trip details:");
                System.out.println("  Trip ID: " + currentTrip.getTripId());
                System.out.println("  Customer ID: " + currentTrip.getCustomerId());
                System.out.println("  Status: " + currentTrip.getStatus());
                System.out.println("  Pickup: " + currentTrip.getPickupLocation());
                System.out.println("  Dropoff: " + currentTrip.getDropoffLocation());
            }
            
            if (currentTrip == null || currentTrip.getCustomerId() != customer.getId()) {
                System.out.println("CustomerServlet.updateTrip - Access denied: trip not found or doesn't belong to customer");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"success\": false, \"error\": \"Trip not found or access denied\"}");
                return;
            }

            // Check if trip can be updated (only Pending or Accepted trips)
            if (!"Pending".equals(currentTrip.getStatus()) && !"Accepted".equals(currentTrip.getStatus())) {
                System.out.println("CustomerServlet.updateTrip - Trip cannot be updated: status is " + currentTrip.getStatus());
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"Trip cannot be updated in current status: " + currentTrip.getStatus() + "\"}");
                return;
            }

            // Get new pickup location parameters only
            String pickupLocation = sanitizeInput(request.getParameter("pickupLocation"));
            String pickupLatStr = sanitizeInput(request.getParameter("pickupLat"));
            String pickupLngStr = sanitizeInput(request.getParameter("pickupLng"));

            // Validate parameters - only pickup location required
            System.out.println("CustomerServlet.updateTrip - Parameter validation:");
            System.out.println("  pickupLocation: '" + pickupLocation + "' (empty: " + isEmpty(pickupLocation) + ")");
            System.out.println("  pickupLatStr: '" + pickupLatStr + "' (empty: " + isEmpty(pickupLatStr) + ")");
            System.out.println("  pickupLngStr: '" + pickupLngStr + "' (empty: " + isEmpty(pickupLngStr) + ")");
            
            if (isEmpty(pickupLatStr) || isEmpty(pickupLocation) || isEmpty(pickupLngStr)) {
                System.out.println("CustomerServlet.updateTrip - Validation failed: missing required pickup parameters");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"Pickup location parameters are required\"}");
                return;
            }

            System.out.println("CustomerServlet.updateTrip - Parsing coordinates:");
            double pickupLat = Double.parseDouble(pickupLatStr);
            double pickupLng = Double.parseDouble(pickupLngStr);
            System.out.println("CustomerServlet.updateTrip - Parsed coordinates:");
            System.out.println("  pickupLat: " + pickupLat + ", pickupLng: " + pickupLng);

            // Validate coordinate ranges
            if (!isValidLatitude(pickupLat) || !isValidLongitude(pickupLng)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"Invalid pickup coordinates provided\"}");
                return;
            }

            // Update only the pickup location (distance and price will be calculated automatically)
            System.out.println("CustomerServlet.updateTrip - Attempting to update trip with:");
            System.out.println("  Trip ID: " + tripId);
            System.out.println("  Current Trip Status: " + currentTrip.getStatus());
            System.out.println("  Pickup Location: " + pickupLocation);
            System.out.println("  Pickup Coordinates: " + pickupLat + ", " + pickupLng);
            
            boolean isUpdated = rideDAO.updateTripPickupLocation(tripId, pickupLocation, pickupLat, pickupLng);
            System.out.println("CustomerServlet.updateTrip - Update result: " + isUpdated);

            if (isUpdated) {
                // Create notification for driver if trip is accepted
                if ("Accepted".equals(currentTrip.getStatus()) && currentTrip.getDriverId() > 0) {
                    String message = String.format("Pickup location updated to: %s", pickupLocation);
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
                System.out.println("CustomerServlet.updateTrip - Update failed, checking trip status and details");
                System.out.println("  Trip exists: " + (currentTrip != null));
                if (currentTrip != null) {
                    System.out.println("  Trip status: " + currentTrip.getStatus());
                    System.out.println("  Trip ID: " + currentTrip.getTripId());
                    System.out.println("  Customer ID: " + currentTrip.getCustomerId());
                }
                
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"success\": false, \"error\": \"Failed to update pickup location. Trip may not be in updatable status (Pending/Accepted) or database error occurred.\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\": false, \"error\": \"Invalid numeric parameters\"}");
        } catch (Exception e) {
            System.out.println("DEBUG: Error in updateTrip: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"success\": false, \"error\": \"An error occurred while updating trip: " + e.getMessage() + "\"}");
        }
    }

    private void updateTip(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
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
            // Get trip ID and new tip amount
            String tripIdStr = sanitizeInput(request.getParameter("tripId"));
            String newTipStr = sanitizeInput(request.getParameter("newTip"));

            if (isEmpty(tripIdStr) || isEmpty(newTipStr)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"Trip ID and new tip amount are required\"}");
                return;
            }

            int tripId = Integer.parseInt(tripIdStr);
            double newTip = Double.parseDouble(newTipStr);

            // Validate tip amount
            if (newTip < 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"Tip amount cannot be negative\"}");
                return;
            }

            // Verify the trip belongs to this customer
            Trip currentTrip = rideDAO.getTripById(tripId);
            System.out.println("CustomerServlet.updateTip - Retrieved trip: " + (currentTrip != null ? "Found" : "Not found"));
            if (currentTrip != null) {
                System.out.println("CustomerServlet.updateTip - Trip details:");
                System.out.println("  Trip ID: " + currentTrip.getTripId());
                System.out.println("  Customer ID: " + currentTrip.getCustomerId());
                System.out.println("  Status: " + currentTrip.getStatus());
                System.out.println("  Current Tip: " + currentTrip.getTip());
                System.out.println("  New Tip: " + newTip);
            }

            if (currentTrip == null || currentTrip.getCustomerId() != customer.getId()) {
                System.out.println("CustomerServlet.updateTip - Access denied: trip not found or doesn't belong to customer");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"success\": false, \"error\": \"Trip not found or access denied\"}");
                return;
            }

            // Check if trip can be updated (only Pending, Accepted, or InProgress trips)
            if (!"Pending".equals(currentTrip.getStatus()) && !"Accepted".equals(currentTrip.getStatus()) && !"InProgress".equals(currentTrip.getStatus())) {
                System.out.println("CustomerServlet.updateTip - Trip cannot be updated: status is " + currentTrip.getStatus());
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"Tip can only be updated for trips in Pending, Accepted, or InProgress status\"}");
                return;
            }

            // Validate that new tip is not lower than current tip
            double currentTip = currentTrip.getTip();
            if (newTip < currentTip) {
                System.out.println("CustomerServlet.updateTip - New tip (" + newTip + ") is lower than current tip (" + currentTip + ")");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"New tip amount cannot be lower than current tip amount (LKR " + String.format("%.2f", currentTip) + ")\"}");
                return;
            }

            if (newTip == currentTip) {
                System.out.println("CustomerServlet.updateTip - New tip is same as current tip");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"New tip amount is the same as current tip amount\"}");
                return;
            }

            // Update the tip amount
            System.out.println("CustomerServlet.updateTip - Attempting to update tip:");
            System.out.println("  Trip ID: " + tripId);
            System.out.println("  Current Tip: " + currentTip);
            System.out.println("  New Tip: " + newTip);

            boolean isUpdated = rideDAO.updateTripTip(tripId, newTip);
            System.out.println("CustomerServlet.updateTip - Update result: " + isUpdated);

            if (isUpdated) {
                // Create notification for driver if trip is accepted or in progress
                if (("Accepted".equals(currentTrip.getStatus()) || "InProgress".equals(currentTrip.getStatus())) && currentTrip.getDriverId() > 0) {
                    String message = String.format("Customer updated tip to LKR %.2f", newTip);
                    Notification notification = new Notification(
                        tripId,
                        currentTrip.getDriverId(),
                        customer.getId(),
                        "TIP_UPDATED",
                        message
                    );
                    notificationDAO.createNotification(notification);
                }

                // Set success message in session for dashboard display
                session.setAttribute("successMessage", "Tip updated successfully! New tip amount: LKR " + String.format("%.2f", newTip));
                
                // Check if redirect to dashboard is requested
                String redirect = request.getParameter("redirect");
                if ("dashboard".equals(redirect)) {
                    response.sendRedirect(request.getContextPath() + "/views/customer/dashboard.jsp");
                    return;
                }
                
                response.setContentType("application/json");
                response.getWriter().print("{\"success\": true, \"message\": \"Tip updated successfully\"}");
            } else {
                System.out.println("CustomerServlet.updateTip - Update failed");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"success\": false, \"error\": \"Failed to update tip amount\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\": false, \"error\": \"Invalid numeric parameters\"}");
        } catch (Exception e) {
            System.out.println("DEBUG: Error in updateTip: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"success\": false, \"error\": \"An error occurred while updating tip: " + e.getMessage() + "\"}");
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
                response.getWriter().print("{\"success\": false, \"error\": \"Trip ID is required\"}");
                return;
            }

            int tripId = Integer.parseInt(tripIdStr);
            
            // Verify the trip belongs to this customer
            Trip currentTrip = rideDAO.getTripById(tripId);
            if (currentTrip == null || currentTrip.getCustomerId() != customer.getId()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().print("{\"success\": false, \"error\": \"Trip not found or access denied\"}");
                return;
            }

            // Check if trip can be cancelled (only Pending or Accepted trips)
            if (!"Pending".equals(currentTrip.getStatus()) && !"Accepted".equals(currentTrip.getStatus())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\": false, \"error\": \"Trip cannot be cancelled in current status\"}");
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
                response.getWriter().print("{\"success\": false, \"error\": \"Failed to cancel trip\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\": false, \"error\": \"Invalid trip ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"success\": false, \"error\": \"An error occurred while cancelling trip\"}");
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
            response.getWriter().print("{\"success\": false, \"error\": \"Failed to get current trip\"}");
        }
    }
    
    private void getNotices(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            // Get notices targeted to customers or all users
            List<Notice> notices = noticeDAO.getNoticesForAudience("Customers");
            
            Gson gson = new Gson();
            out.print(gson.toJson(notices));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"success\": false, \"error\": \"Failed to get notices\"}");
        }
    }
}

package com.sliit.pickmegoweb.controller;

import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.sql.Timestamp; // Import Timestamp class

@WebServlet("/RideServlet")
public class RideServlet extends HttpServlet {
    private RideDAO rideDAO;

    public void init() {
        rideDAO = new RideDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("bookRide")) {
            bookRide(request, response);
        }
    }

    private void bookRide(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            User customer = (User) request.getSession().getAttribute("user");
            if (customer == null || !"Customer".equals(customer.getRole())) {
                response.sendRedirect(request.getContextPath() + "/views/login.jsp");
                return;
            }

            String pickupLocation = request.getParameter("pickupLocation");
            String dropOffLocation = request.getParameter("dropOffLocation");

            Trip newTrip = new Trip();
            newTrip.setCustomerId(customer.getId());
            newTrip.setPickupLocation(pickupLocation);
            newTrip.setDropoffLocation(dropOffLocation);
            newTrip.setStatus("Pending");

            // Corrected line: Convert java.util.Date to java.sql.Timestamp
            newTrip.setBookingTime(new Timestamp(new Date().getTime()));

            int tripId = rideDAO.createTrip(newTrip);

            if (tripId > 0) {
                request.setAttribute("message", "Ride booking successful! Waiting for a driver to accept.");
                request.getRequestDispatcher("/views/customer/view_status.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Ride booking failed. Please try again.");
                request.getRequestDispatcher("/views/customer/book_ride.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during booking.");
            request.getRequestDispatcher("/views/customer/book_ride.jsp").forward(request, response);
        }
    }
}
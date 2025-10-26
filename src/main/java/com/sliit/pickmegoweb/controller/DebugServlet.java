package com.sliit.pickmegoweb.controller;

import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/DebugServlet")
public class DebugServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Debug</title></head><body>");
        out.println("<h1>Database Debug Information</h1>");
        
        try {
            Connection conn = DBConnection.getConnection();
            out.println("<h2>Database Connection: SUCCESS</h2>");
            
            // Check table structure
            out.println("<h2>Trips Table Structure:</h2>");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("DESCRIBE Trips");
            
            out.println("<table border='1'>");
            out.println("<tr><th>Column</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("Field") + "</td>");
                out.println("<td>" + rs.getString("Type") + "</td>");
                out.println("<td>" + rs.getString("Null") + "</td>");
                out.println("<td>" + rs.getString("Key") + "</td>");
                out.println("<td>" + rs.getString("Default") + "</td>");
                out.println("<td>" + rs.getString("Extra") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Check sample data
            out.println("<h2>Sample Trip Data:</h2>");
            rs = stmt.executeQuery("SELECT * FROM Trips LIMIT 3");
            
            out.println("<table border='1'>");
            out.println("<tr><th>TripID</th><th>CustomerID</th><th>PickupLocation</th><th>DropOffLocation</th><th>Status</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("TripID") + "</td>");
                out.println("<td>" + rs.getInt("CustomerID") + "</td>");
                out.println("<td>" + rs.getString("PickupLocation") + "</td>");
                out.println("<td>" + rs.getString("DropOffLocation") + "</td>");
                out.println("<td>" + rs.getString("TripStatus") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Test RideDAO
            out.println("<h2>RideDAO Test:</h2>");
            RideDAO rideDAO = new RideDAO();
            java.util.List<Trip> trips = rideDAO.getAllTrips();
            out.println("<p>Total trips in database: " + trips.size() + "</p>");
            
            if (!trips.isEmpty()) {
                Trip firstTrip = trips.get(0);
                out.println("<p>First trip - ID: " + firstTrip.getTripId() + 
                           ", Pickup: " + firstTrip.getPickupLocation() + 
                           ", Dropoff: " + firstTrip.getDropoffLocation() + "</p>");
            }
            
            conn.close();
            
        } catch (Exception e) {
            out.println("<h2>ERROR: " + e.getMessage() + "</h2>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
}

package com.sliit.pickmegoweb.controller;

import com.sliit.pickmegoweb.dao.IncidentDAO;
import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.model.Incident;
import com.sliit.pickmegoweb.model.User;
import com.google.gson.Gson;
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

@WebServlet("/IncidentServlet")
public class IncidentServlet extends HttpServlet {
    private IncidentDAO incidentDAO;
    private RideDAO rideDAO;
    private Gson gson;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
        rideDAO = new RideDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            switch (action) {
                case "getIncidents":
                    if ("Driver".equals(user.getRole())) {
                        List<Incident> driverIncidents = incidentDAO.getIncidentsByDriverId(user.getId());
                        out.print(gson.toJson(driverIncidents));
                    } else if ("Admin".equals(user.getRole()) || "Operations".equals(user.getRole())) {
                        List<Incident> allIncidents = incidentDAO.getAllIncidents();
                        // Map to DTO with exact keys the admin UI expects
                        com.google.gson.JsonArray arr = new com.google.gson.JsonArray();
                        for (Incident inc : allIncidents) {
                            com.google.gson.JsonObject o = new com.google.gson.JsonObject();
                            o.addProperty("IncidentID", inc.getIncidentId());
                            o.addProperty("TripID", inc.getTripId());
                            o.addProperty("DriverName", inc.getDriverName() == null ? "" : inc.getDriverName());
                            o.addProperty("IncidentType", inc.getIncidentType() == null ? "" : inc.getIncidentType());
                            o.addProperty("Severity", inc.getSeverity() == null ? "" : inc.getSeverity());
                            o.addProperty("Status", inc.getStatus() == null ? "" : inc.getStatus());
                            o.addProperty("Location", inc.getLocation() == null ? "" : inc.getLocation());
                            o.addProperty("ReportedDate", inc.getReportedDate() == null ? "" : inc.getReportedDate().toString());
                            arr.add(o);
                        }
                        out.print(gson.toJson(arr));
                    }
                    break;

                case "getIncidentById":
                    int incidentId = Integer.parseInt(request.getParameter("incidentId"));
                    Incident incident = incidentDAO.getIncidentById(incidentId);
                    out.print(gson.toJson(incident));
                    break;

                case "getIncidentsByStatus":
                    String status = request.getParameter("status");
                    List<Incident> statusIncidents = incidentDAO.getIncidentsByStatus(status);
                    out.print(gson.toJson(statusIncidents));
                    break;

                case "getIncidentsByTrip":
                    int tripId = Integer.parseInt(request.getParameter("tripId"));
                    List<Incident> tripIncidents = incidentDAO.getIncidentsByTripId(tripId);
                    out.print(gson.toJson(tripIncidents));
                    break;

                case "getIncidentStats":
                    if ("Admin".equals(user.getRole()) || "Operations".equals(user.getRole())) {
                        int totalIncidents = incidentDAO.getTotalIncidentCount();
                        int reportedCount = incidentDAO.getIncidentCountByStatus("Reported");
                        int underInvestigationCount = incidentDAO.getIncidentCountByStatus("Under Investigation");
                        int resolvedCount = incidentDAO.getIncidentCountByStatus("Resolved");
                        int closedCount = incidentDAO.getIncidentCountByStatus("Closed");
                        
                        String statsJson = String.format(
                            "{\"total\": %d, \"reported\": %d, \"underInvestigation\": %d, \"resolved\": %d, \"closed\": %d}",
                            totalIncidents, reportedCount, underInvestigationCount, resolvedCount, closedCount
                        );
                        out.print(statsJson);
                    }
                    break;

                default:
                    out.print("{\"error\": \"Invalid action\"}");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            switch (action) {
                case "createIncident":
                    createIncident(request, response, user);
                    break;

                case "updateIncident":
                    updateIncident(request, response, user);
                    break;

                case "updateIncidentStatus":
                    updateIncidentStatus(request, response, user);
                    break;

                case "deleteIncident":
                    deleteIncident(request, response, user);
                    break;

                default:
                    out.print("{\"error\": \"Invalid action\"}");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }

    private void createIncident(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        PrintWriter out = response.getWriter();
        
        if (!"Driver".equals(user.getRole())) {
            out.print("{\"success\": false, \"message\": \"Only drivers can report incidents\"}");
            return;
        }

        try {
            int tripId = Integer.parseInt(request.getParameter("tripId"));
            String incidentType = request.getParameter("incidentType");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            double latitude = Double.parseDouble(request.getParameter("latitude"));
            double longitude = Double.parseDouble(request.getParameter("longitude"));
            String severity = request.getParameter("severity");

            // Validate required fields
            if (incidentType == null || incidentType.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                location == null || location.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"All fields are required\"}");
                return;
            }
            
            // Validate coordinate ranges
            if (latitude < -90 || latitude > 90) {
                out.print("{\"success\": false, \"message\": \"Latitude must be between -90 and 90 degrees\"}");
                return;
            }
            if (longitude < -180 || longitude > 180) {
                out.print("{\"success\": false, \"message\": \"Longitude must be between -180 and 180 degrees\"}");
                return;
            }
            
            // Round coordinates to 8 decimal places to fit database precision
            latitude = Math.round(latitude * 100000000.0) / 100000000.0;
            longitude = Math.round(longitude * 100000000.0) / 100000000.0;

            // Create incident
            Incident incident = new Incident(tripId, user.getId(), incidentType, description, 
                                           location, latitude, longitude, severity);
            
            boolean success = incidentDAO.createIncident(incident);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Incident reported successfully\", \"incidentId\": " + incident.getIncidentId() + "}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to report incident\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid numeric values\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"An error occurred while reporting incident\"}");
        }
    }

    private void updateIncident(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        PrintWriter out = response.getWriter();
        
        try {
            int incidentId = Integer.parseInt(request.getParameter("incidentId"));
            String incidentType = request.getParameter("incidentType");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            double latitude = Double.parseDouble(request.getParameter("latitude"));
            double longitude = Double.parseDouble(request.getParameter("longitude"));
            String severity = request.getParameter("severity");
            String notes = request.getParameter("notes");

            // Get existing incident
            Incident incident = incidentDAO.getIncidentById(incidentId);
            if (incident == null) {
                out.print("{\"success\": false, \"message\": \"Incident not found\"}");
                return;
            }

            // Check permissions - drivers can only update their own incidents, admins can update any
            if ("Driver".equals(user.getRole()) && incident.getDriverId() != user.getId()) {
                out.print("{\"success\": false, \"message\": \"You can only update your own incidents\"}");
                return;
            }

            // Update incident
            incident.setIncidentType(incidentType);
            incident.setDescription(description);
            incident.setLocation(location);
            incident.setLatitude(latitude);
            incident.setLongitude(longitude);
            incident.setSeverity(severity);
            incident.setNotes(notes);

            boolean success = incidentDAO.updateIncident(incident);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Incident updated successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update incident\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid numeric values\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"An error occurred while updating incident\"}");
        }
    }

    private void updateIncidentStatus(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        PrintWriter out = response.getWriter();
        
        // Only admins and operations managers can update incident status
        if (!"Admin".equals(user.getRole()) && !"Operations".equals(user.getRole())) {
            out.print("{\"success\": false, \"message\": \"Insufficient permissions\"}");
            return;
        }

        try {
            int incidentId = Integer.parseInt(request.getParameter("incidentId"));
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");

            boolean success = incidentDAO.updateIncidentStatus(incidentId, status, notes);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Incident status updated successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update incident status\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid incident ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"An error occurred while updating incident status\"}");
        }
    }

    private void deleteIncident(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        PrintWriter out = response.getWriter();
        
        // Only admins can delete incidents
        if (!"Admin".equals(user.getRole())) {
            out.print("{\"success\": false, \"message\": \"Insufficient permissions\"}");
            return;
        }

        try {
            int incidentId = Integer.parseInt(request.getParameter("incidentId"));
            
            boolean success = incidentDAO.deleteIncident(incidentId);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Incident deleted successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to delete incident\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid incident ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"An error occurred while deleting incident\"}");
        }
    }
}

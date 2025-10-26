package com.sliit.pickmegoweb.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sliit.pickmegoweb.dao.DriverWatchlistDAO;
import com.sliit.pickmegoweb.dao.IncidentDAO;
import com.sliit.pickmegoweb.dao.NoticeDAO;
import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.dao.UserDAO;
import com.sliit.pickmegoweb.model.DriverWatchlist;
import com.sliit.pickmegoweb.model.Incident;
import com.sliit.pickmegoweb.model.Notice;
import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private UserDAO userDAO;
    private RideDAO rideDAO;
    private IncidentDAO incidentDAO;
    private NoticeDAO noticeDAO;
    private DriverWatchlistDAO driverWatchlistDAO;
    private Gson gson;

    public void init() {
        userDAO = new UserDAO();
        rideDAO = new RideDAO();
        incidentDAO = new IncidentDAO();
        noticeDAO = new NoticeDAO();
        driverWatchlistDAO = new DriverWatchlistDAO();
        gson = new Gson();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and has Admin, Operations, or Feedback role
        if (user == null || (!"Admin".equals(user.getRole()) && !"Operations".equals(user.getRole()) && !"Feedback".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            switch (action) {
                case "listUsers":
                    listUsers(request, response);
                    break;
                case "listTrips":
                    listTrips(request, response);
                    break;
                case "getUserCount":
                    getUserCount(out);
                    break;
                case "getTripCount":
                    getTripCount(out);
                    break;
                case "getUsersByRole":
                    getUsersByRole(request, out);
                    break;
                case "getUserById":
                    getUserById(request, out);
                    break;
                case "getAllIncidents":
                    getAllIncidents(out);
                    break;
                case "getIncidentById":
                    getIncidentById(request, out);
                    break;
                case "getIncidentDetails":
                    getIncidentDetails(request, out);
                    break;
                case "getAllNotices":
                    getAllNotices(out);
                    break;
                case "getNoticeById":
                    getNoticeById(request, out);
                    break;
                case "getActiveNotices":
                    getActiveNotices(out);
                    break;
                case "getNoticesForAudience":
                    getNoticesForAudience(request, out);
                    break;
                default:
                    request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "An error occurred: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and has Admin, Operations, or Feedback role
        if (user == null || (!"Admin".equals(user.getRole()) && !"Operations".equals(user.getRole()) && !"Feedback".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            // Debug logging
            System.out.println("AdminServlet.doPost - Request method: " + request.getMethod());
            System.out.println("AdminServlet.doPost - Request URI: " + request.getRequestURI());
            System.out.println("AdminServlet.doPost - Referer: " + request.getHeader("Referer"));
            System.out.println("AdminServlet.doPost - User-Agent: " + request.getHeader("User-Agent"));
            System.out.println("AdminServlet.doPost - Content-Type: " + request.getContentType());
            System.out.println("AdminServlet.doPost - Content-Length: " + request.getContentLength());
            
            String action = request.getParameter("action");
            System.out.println("AdminServlet.doPost - Action parameter: " + action);
            
            // Check if action parameter is null or empty
            if (action == null || action.trim().isEmpty()) {
                System.out.println("AdminServlet.doPost - Action parameter is null or empty");
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Action parameter is required");
                out.print(gson.toJson(jsonResponse));
                return;
            }
            
            switch (action) {
                case "createUser":
                    createUser(request, jsonResponse);
                    break;
                case "updateUser":
                    updateUser(request, jsonResponse);
                    break;
                case "updateUserRole":
                    updateUserRole(request, jsonResponse);
                    break;
                case "deleteUser":
                    deleteUser(request, jsonResponse);
                    break;
                case "updateIncidentStatus":
                    updateIncidentStatus(request, jsonResponse);
                    break;
                case "deleteIncident":
                    deleteIncident(request, jsonResponse);
                    break;
                case "createNotice":
                    createNotice(request, jsonResponse);
                    break;
                case "updateNotice":
                    updateNotice(request, jsonResponse);
                    break;
                case "deleteNotice":
                    deleteNotice(request, jsonResponse);
                    break;
                case "toggleNoticeStatus":
                    toggleNoticeStatus(request, jsonResponse);
                    break;
                case "addDriverToWatchlist":
                    addDriverToWatchlist(request, jsonResponse);
                    break;
                case "removeDriverFromWatchlist":
                    removeDriverFromWatchlist(request, jsonResponse);
                    break;
                case "getWatchlist":
                    getWatchlist(request, jsonResponse);
                    break;
                default:
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "An error occurred: " + e.getMessage());
        }
        
        out.print(gson.toJson(jsonResponse));
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<User> userList = userDAO.getAllUsers();
            
            // Return JSON response instead of forwarding to JSP
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.add("users", gson.toJsonTree(userList));
            
            out.print(gson.toJson(jsonResponse));
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "An error occurred while fetching user data: " + e.getMessage());
            
            out.print(gson.toJson(errorResponse));
        }
    }

    private void listTrips(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("AdminServlet.listTrips - Getting all trips");
            List<Trip> tripList = rideDAO.getAllTrips();
            System.out.println("AdminServlet.listTrips - Found " + tripList.size() + " trips");
            
            // Return JSON response instead of forwarding to JSP
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(tripList));
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("AdminServlet.listTrips - Error: " + e.getMessage());
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching trips: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    // GET methods for JSON responses
    private void getUserCount(PrintWriter out) {
        try {
            int count = userDAO.getUserCount();
            JsonObject response = new JsonObject();
            response.addProperty("count", count);
            out.print(gson.toJson(response));
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("count", 0);
            out.print(gson.toJson(errorResponse));
        }
    }

    private void getTripCount(PrintWriter out) {
        try {
            int count = rideDAO.getTripCount();
            JsonObject response = new JsonObject();
            response.addProperty("count", count);
            out.print(gson.toJson(response));
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("count", 0);
            out.print(gson.toJson(errorResponse));
        }
    }

    private void getUsersByRole(HttpServletRequest request, PrintWriter out) {
        try {
            String role = request.getParameter("role");
            System.out.println("AdminServlet.getUsersByRole - Role parameter: " + role);
            
            List<User> users;
            if (role == null || role.isEmpty() || "All".equals(role)) {
                System.out.println("AdminServlet.getUsersByRole - Getting all users");
                users = userDAO.getAllUsers();
            } else {
                System.out.println("AdminServlet.getUsersByRole - Getting users by role: " + role);
                users = userDAO.getUsersByRole(role);
            }
            
            System.out.println("AdminServlet.getUsersByRole - Found " + users.size() + " users");
            System.out.println("AdminServlet.getUsersByRole - Users: " + users);
            
            // Return users as JSON array
            out.print(gson.toJson(users));
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("AdminServlet.getUsersByRole - Error: " + e.getMessage());
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching users by role: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    private void getUserById(HttpServletRequest request, PrintWriter out) {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            User user = userDAO.getUserById(userId);
            
            JsonObject response = new JsonObject();
            if (user != null) {
                response.addProperty("success", true);
                response.add("user", gson.toJsonTree(user));
            } else {
                response.addProperty("success", false);
                response.addProperty("message", "User not found");
            }
            out.print(gson.toJson(response));
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching user: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    private void getAllIncidents(PrintWriter out) {
        try {
            System.out.println("AdminServlet.getAllIncidents - Getting all incidents");
            List<Incident> incidents = incidentDAO.getAllIncidents();
            System.out.println("AdminServlet.getAllIncidents - Found " + incidents.size() + " incidents");
            System.out.println("AdminServlet.getAllIncidents - Incidents: " + incidents);
            out.print(gson.toJson(incidents));
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching incidents");
            out.print(gson.toJson(errorResponse));
        }
    }

    private void getIncidentById(HttpServletRequest request, PrintWriter out) {
        try {
            int incidentId = Integer.parseInt(request.getParameter("incidentId"));
            Incident incident = incidentDAO.getIncidentById(incidentId);
            out.print(gson.toJson(incident));
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching incident");
            out.print(gson.toJson(errorResponse));
        }
    }

    private void getIncidentDetails(HttpServletRequest request, PrintWriter out) {
        try {
            String incidentIdParam = request.getParameter("incidentId");
            if (incidentIdParam == null || incidentIdParam.trim().isEmpty() || "undefined".equals(incidentIdParam)) {
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Invalid incident ID parameter");
                out.print(gson.toJson(errorResponse));
                return;
            }
            
            int incidentId = Integer.parseInt(incidentIdParam);
            Incident incident = incidentDAO.getIncidentById(incidentId);
            
            if (incident != null) {
                // Create a comprehensive response with all incident details
                JsonObject response = new JsonObject();
                response.addProperty("success", true);
                response.add("incident", gson.toJsonTree(incident));
                
                // Add additional context information
                JsonObject context = new JsonObject();
                context.addProperty("hasTripDetails", incident.getTripDetails() != null);
                if (incident.getTripDetails() != null) {
                    context.add("tripDetails", gson.toJsonTree(incident.getTripDetails()));
                }
                response.add("context", context);
                
                out.print(gson.toJson(response));
            } else {
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Incident not found");
                out.print(gson.toJson(errorResponse));
            }
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching incident details: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    // POST methods for data modification
    private void createUser(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phoneNumber = request.getParameter("phoneNumber");
            String role = request.getParameter("role");

            User newUser = new User();
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setPhoneNumber(phoneNumber);
            newUser.setRole(role);

            boolean success = userDAO.createUser(newUser);
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "User created successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to create user");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error creating user: " + e.getMessage());
        }
    }

    private void updateUser(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");

            User user = userDAO.getUserById(userId);
            if (user != null) {
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setEmail(email);
                user.setPhoneNumber(phoneNumber);

                boolean success = userDAO.updateUser(user);
                if (success) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "User updated successfully");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Failed to update user");
                }
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "User not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error updating user: " + e.getMessage());
        }
    }

    private void updateUserRole(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String newRole = request.getParameter("role");

            boolean success = userDAO.updateUserRole(userId, newRole);
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "User role updated successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to update user role");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error updating user role: " + e.getMessage());
        }
    }

    private void deleteUser(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String deleteType = request.getParameter("deleteType"); // "soft" or "hard"

            boolean success;
            String message;
            
            if ("hard".equals(deleteType)) {
                // Hard delete - remove all related data
                success = userDAO.hardDeleteUser(userId);
                message = success ? "User and all related data deleted successfully" : "Failed to delete user";
            } else {
                // Soft delete - mark as inactive (default)
                success = userDAO.deleteUser(userId);
                message = success ? "User deactivated successfully" : "Failed to deactivate user";
            }
            
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", message);
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            if (e.getMessage().contains("REFERENCE constraint")) {
                jsonResponse.addProperty("message", "Cannot delete user: User has related data (feedbacks, trips, etc.). Use 'Hard Delete' to remove all related data, or contact database administrator.");
            } else {
                jsonResponse.addProperty("message", "Database error deleting user: " + e.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error deleting user: " + e.getMessage());
        }
    }

    private void updateIncidentStatus(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            String incidentIdParam = request.getParameter("incidentId");
            if (incidentIdParam == null || incidentIdParam.trim().isEmpty() || "undefined".equals(incidentIdParam)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Invalid incident ID parameter");
                return;
            }
            
            int incidentId = Integer.parseInt(incidentIdParam);
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");

            boolean success = incidentDAO.updateIncidentStatus(incidentId, status, notes);
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Incident status updated successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to update incident status");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error updating incident status: " + e.getMessage());
        }
    }

    private void deleteIncident(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            int incidentId = Integer.parseInt(request.getParameter("incidentId"));

            boolean success = incidentDAO.deleteIncident(incidentId);
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Incident deleted successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to delete incident");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error deleting incident: " + e.getMessage());
        }
    }

    // Notice Management Methods
    
    private void getAllNotices(PrintWriter out) {
        try {
            System.out.println("AdminServlet.getAllNotices - Getting all notices");
            List<Notice> notices = noticeDAO.getAllNotices();
            System.out.println("AdminServlet.getAllNotices - Found " + notices.size() + " notices");
            System.out.println("AdminServlet.getAllNotices - Notices: " + notices);
            out.print(gson.toJson(notices));
        } catch (Exception e) {
            System.out.println("AdminServlet.getAllNotices - Error: " + e.getMessage());
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching notices: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }
    
    private void getActiveNotices(PrintWriter out) {
        try {
            List<Notice> notices = noticeDAO.getActiveNotices();
            out.print(gson.toJson(notices));
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching active notices");
            out.print(gson.toJson(errorResponse));
        }
    }
    
    private void getNoticesForAudience(HttpServletRequest request, PrintWriter out) {
        try {
            String audience = request.getParameter("audience");
            if (audience == null || audience.isEmpty()) {
                audience = "All";
            }
            List<Notice> notices = noticeDAO.getNoticesForAudience(audience);
            out.print(gson.toJson(notices));
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching notices for audience");
            out.print(gson.toJson(errorResponse));
        }
    }
    
    private void getNoticeById(HttpServletRequest request, PrintWriter out) {
        try {
            int noticeId = Integer.parseInt(request.getParameter("noticeId"));
            Notice notice = noticeDAO.getNoticeById(noticeId);
            
            JsonObject response = new JsonObject();
            if (notice != null) {
                response.addProperty("success", true);
                response.add("notice", gson.toJsonTree(notice));
            } else {
                response.addProperty("success", false);
                response.addProperty("message", "Notice not found");
            }
            out.print(gson.toJson(response));
        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Error fetching notice: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }
    
    private void createNotice(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            String title = request.getParameter("title");
            String message = request.getParameter("message");
            String noticeType = request.getParameter("noticeType");
            String priority = request.getParameter("priority");
            String targetAudience = request.getParameter("targetAudience");
            String expiryDateStr = request.getParameter("expiryDate");
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int createdBy = user != null ? user.getId() : 1; // Default to admin if no user
            
            Notice notice = new Notice(title, message, noticeType, priority, createdBy, targetAudience);
            
            // Set expiry date if provided
            if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
                notice.setExpiryDate(expiryDateStr);
            }
            
            boolean success = noticeDAO.createNotice(notice);
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Notice created successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to create notice");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error creating notice: " + e.getMessage());
        }
    }
    
    private void updateNotice(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            int noticeId = Integer.parseInt(request.getParameter("noticeId"));
            String title = request.getParameter("title");
            String message = request.getParameter("message");
            String noticeType = request.getParameter("noticeType");
            String priority = request.getParameter("priority");
            String targetAudience = request.getParameter("targetAudience");
            String expiryDateStr = request.getParameter("expiryDate");
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            
            Notice notice = noticeDAO.getNoticeById(noticeId);
            if (notice != null) {
                notice.setTitle(title);
                notice.setMessage(message);
                notice.setNoticeType(noticeType);
                notice.setPriority(priority);
                notice.setTargetAudience(targetAudience);
                notice.setActive(isActive);
                
                if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
                    notice.setExpiryDate(expiryDateStr);
                }
                
                boolean success = noticeDAO.updateNotice(notice);
                if (success) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Notice updated successfully");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Failed to update notice");
                }
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Notice not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error updating notice: " + e.getMessage());
        }
    }
    
    private void deleteNotice(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            String noticeIdParam = request.getParameter("noticeId");
            if (noticeIdParam == null || noticeIdParam.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Notice ID is required");
                return;
            }
            
            int noticeId = Integer.parseInt(noticeIdParam);
            boolean success = noticeDAO.deleteNotice(noticeId);
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Notice deleted successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to delete notice");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error deleting notice: " + e.getMessage());
        }
    }
    
    private void toggleNoticeStatus(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            String noticeIdParam = request.getParameter("noticeId");
            if (noticeIdParam == null || noticeIdParam.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Notice ID is required");
                return;
            }
            
            int noticeId = Integer.parseInt(noticeIdParam);
            boolean success = noticeDAO.toggleNoticeStatus(noticeId);
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Notice status toggled successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to toggle notice status");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error toggling notice status: " + e.getMessage());
        }
    }

    // ------------------- DRIVER WATCHLIST METHODS -------------------
    
    private void addDriverToWatchlist(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            HttpSession session = request.getSession();
            User admin = (User) session.getAttribute("user");
            
            String driverIdParam = request.getParameter("driverId");
            String reason = request.getParameter("reason");
            
            // Debug logging
            System.out.println("DEBUG: addDriverToWatchlist - driverIdParam: " + driverIdParam);
            System.out.println("DEBUG: addDriverToWatchlist - reason: " + reason);
            System.out.println("DEBUG: addDriverToWatchlist - admin: " + (admin != null ? admin.getId() : "null"));
            
            if (driverIdParam == null || reason == null || reason.trim().isEmpty()) {
                System.out.println("DEBUG: addDriverToWatchlist - Missing required parameters");
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Driver ID and reason are required");
                return;
            }
            
            int driverId = Integer.parseInt(driverIdParam);
            System.out.println("DEBUG: addDriverToWatchlist - Parsed driverId: " + driverId);
            
            // Check if driver is already on watchlist
            if (driverWatchlistDAO.isDriverOnWatchlist(driverId)) {
                System.out.println("DEBUG: addDriverToWatchlist - Driver already on watchlist");
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Driver is already on the watchlist");
                return;
            }
            
            boolean success = driverWatchlistDAO.addDriverToWatchlist(driverId, admin.getId(), reason.trim());
            System.out.println("DEBUG: addDriverToWatchlist - Database operation success: " + success);
            
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Driver added to watchlist successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to add driver to watchlist");
            }
        } catch (NumberFormatException e) {
            System.out.println("DEBUG: addDriverToWatchlist - NumberFormatException: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Invalid driver ID format: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("DEBUG: addDriverToWatchlist - General exception: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error adding driver to watchlist: " + e.getMessage());
        }
    }
    
    private void removeDriverFromWatchlist(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            String watchlistIdParam = request.getParameter("watchlistId");
            
            if (watchlistIdParam == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Watchlist ID is required");
                return;
            }
            
            int watchlistId = Integer.parseInt(watchlistIdParam);
            boolean success = driverWatchlistDAO.removeDriverFromWatchlist(watchlistId);
            
            if (success) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Driver removed from watchlist successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to remove driver from watchlist");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error removing driver from watchlist: " + e.getMessage());
        }
    }
    
    private void getWatchlist(HttpServletRequest request, JsonObject jsonResponse) {
        try {
            List<DriverWatchlist> watchlist = driverWatchlistDAO.getAllWatchlistEntries();
            jsonResponse.addProperty("success", true);
            jsonResponse.add("watchlist", gson.toJsonTree(watchlist));
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Error retrieving watchlist: " + e.getMessage());
        }
    }
}
package com.sliit.pickmegoweb.controller;

import com.sliit.pickmegoweb.dao.UserDAO;
import com.sliit.pickmegoweb.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== UserServlet.doPost called ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Request URL: " + request.getRequestURL());
        System.out.println("Request method: " + request.getMethod());
        System.out.println("Content type: " + request.getContentType());
        System.out.println("Servlet path: " + request.getServletPath());
        System.out.println("Path info: " + request.getPathInfo());
        
        String action = request.getParameter("action");
        System.out.println("Action parameter: " + action);
        
        // Log all parameters
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("Parameter: " + paramName + " = " + paramValue);
        }
        if (action != null) {
            switch (action) {
                case "register":
                    registerUser(request, response);
                    break;
                case "login":
                    loginUser(request, response);
                    break;
                case "updateProfile":
                    updateUserProfile(request, response);
                    break;
                case "deleteAccount":
                    deleteUserAccount(request, response);
                    break;
                case "logout":
                    logoutUser(request, response);
                    break;
                default:
                    System.out.println("Unknown action: " + action);
                    response.sendRedirect("views/login.jsp");
                    break;
            }
        } else {
            System.out.println("No action parameter provided");
            response.sendRedirect("views/login.jsp");
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phoneNumber = request.getParameter("phoneNumber");
            String role = request.getParameter("role");
            // Avoid duplicate emails before insert
            try {
                if (userDAO.emailExists(email)) {
                    request.setAttribute("error", "Email already exists. Please use a different email.");
                    request.getRequestDispatcher("views/register.jsp").forward(request, response);
                    return;
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            User newUser = new User(firstName, lastName, email, password, phoneNumber, role);
            boolean isRegistered = userDAO.registerUser(newUser);
            if (isRegistered) {
                request.setAttribute("message", "Registration successful. Please login.");
                request.getRequestDispatcher("views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("views/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration.");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
        }
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            User loggedInUser = userDAO.loginUser(email, password);
            if (loggedInUser != null) {
                request.getSession().setAttribute("user", loggedInUser);
                switch (loggedInUser.getRole()) {
                    case "Customer":
                        response.sendRedirect("views/customer/dashboard.jsp");
                        break;
                    case "Driver":
                        response.sendRedirect("views/driver/dashboard.jsp");
                        break;
                    case "Admin":
                        response.sendRedirect("views/admin/dashboard.jsp");
                        break;
                    case "Finance":
                        response.sendRedirect("views/finance/dashboard.jsp");
                        break;
                    case "Feedback":
                        response.sendRedirect("views/feedback/dashboard.jsp");
                        break;
                    case "Operations":
                        // Operations users can access admin dashboard
                        response.sendRedirect("views/admin/dashboard.jsp");
                        break;
                    default:
                        response.sendRedirect("views/home.jsp");
                        break;
                }
            } else {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login.");
            request.getRequestDispatcher("views/login.jsp").forward(request, response);
        }
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null && action.equalsIgnoreCase("logout")) {
            logoutUser(request, response);
        }
    }

    private void logoutUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Invalidate the session to remove the user object and all session data
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Redirect to the login page
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
    }

    private void updateUserProfile(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        System.out.println("updateUserProfile method called");
        
        try {
            HttpSession session = request.getSession(false);
            System.out.println("Session: " + session);
            if (session == null || session.getAttribute("user") == null) {
                System.out.println("No session or user not logged in");
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "User not logged in");
                out.print(jsonResponse.toString());
                return;
            }
            
            User currentUser = (User) session.getAttribute("user");
            System.out.println("Current user: " + currentUser.getFirstName() + " " + currentUser.getLastName());
            
            // Get updated values from request
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String vehicleType = request.getParameter("vehicleType");
            String vehicleName = request.getParameter("vehicleName");
            
            System.out.println("Received parameters:");
            System.out.println("firstName: " + firstName);
            System.out.println("lastName: " + lastName);
            System.out.println("email: " + email);
            System.out.println("phoneNumber: " + phoneNumber);
            System.out.println("vehicleType: " + vehicleType);
            System.out.println("vehicleName: " + vehicleName);
            
            // Update user object
            currentUser.setFirstName(firstName);
            currentUser.setLastName(lastName);
            currentUser.setEmail(email);
            currentUser.setPhoneNumber(phoneNumber);
            if ("Driver".equals(currentUser.getRole())) {
                currentUser.setVehicleType(vehicleType);
                currentUser.setVehicleName(vehicleName);
            }
            
            // Update in database
            System.out.println("Attempting to update user in database...");
            boolean updated = userDAO.updateUser(currentUser);
            System.out.println("Update result: " + updated);
            
            if (updated) {
                // Update session with new user data
                session.setAttribute("user", currentUser);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Profile updated successfully");
                System.out.println("Profile updated successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to update profile");
                System.out.println("Failed to update profile");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "An error occurred while updating profile");
        }
        
        out.print(jsonResponse.toString());
    }
    
    private void deleteUserAccount(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "User not logged in");
                out.print(jsonResponse.toString());
                return;
            }
            
            User currentUser = (User) session.getAttribute("user");
            
            // Delete user from database
            boolean deleted = userDAO.deleteUser(currentUser.getId());
            
            if (deleted) {
                // Invalidate session
                session.invalidate();
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Account deleted successfully");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to delete account");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "An error occurred while deleting account");
        }
        
        out.print(jsonResponse.toString());
    }
    
}
package com.sliit.pickmegoweb.controller;

import com.google.gson.Gson;
import com.sliit.pickmegoweb.dao.NotificationDAO;
import com.sliit.pickmegoweb.model.Notification;
import com.sliit.pickmegoweb.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {
    
    private NotificationDAO notificationDAO;
    private Gson gson;
    
    public void init() {
        notificationDAO = new NotificationDAO();
        gson = new Gson();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            switch (action) {
                case "getNotifications":
                    getNotifications(user, out);
                    break;
                case "getUnreadNotifications":
                    getUnreadNotifications(user, out);
                    break;
                case "getUnreadCount":
                    getUnreadCount(user, out);
                    break;
                case "markAsRead":
                    markAsRead(request, out);
                    break;
                case "markAllAsRead":
                    markAllAsRead(user, out);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            switch (action) {
                case "createNotification":
                    createNotification(request, out);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }
    
    private void getNotifications(User user, PrintWriter out) {
        List<Notification> notifications;
        if ("Driver".equals(user.getRole())) {
            notifications = notificationDAO.getNotificationsForDriver(user.getId());
        } else {
            notifications = notificationDAO.getNotificationsForCustomer(user.getId());
        }
        out.print(gson.toJson(notifications));
    }
    
    private void getUnreadNotifications(User user, PrintWriter out) {
        List<Notification> notifications;
        if ("Driver".equals(user.getRole())) {
            notifications = notificationDAO.getUnreadNotificationsForDriver(user.getId());
        } else {
            notifications = notificationDAO.getUnreadNotificationsForCustomer(user.getId());
        }
        out.print(gson.toJson(notifications));
    }
    
    private void getUnreadCount(User user, PrintWriter out) {
        int count;
        if ("Driver".equals(user.getRole())) {
            count = notificationDAO.getUnreadNotificationCountForDriver(user.getId());
        } else {
            count = notificationDAO.getUnreadNotificationCountForCustomer(user.getId());
        }
        out.print("{\"count\": " + count + "}");
    }
    
    private void markAsRead(HttpServletRequest request, PrintWriter out) {
        int notificationId = Integer.parseInt(request.getParameter("notificationId"));
        boolean success = notificationDAO.markNotificationAsRead(notificationId);
        out.print("{\"success\": " + success + "}");
    }
    
    private void markAllAsRead(User user, PrintWriter out) {
        boolean success = notificationDAO.markAllNotificationsAsRead(user.getId(), user.getRole());
        out.print("{\"success\": " + success + "}");
    }
    
    private void createNotification(HttpServletRequest request, PrintWriter out) {
        int tripId = Integer.parseInt(request.getParameter("tripId"));
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String notificationType = request.getParameter("notificationType");
        String message = request.getParameter("message");
        
        Notification notification = new Notification(tripId, driverId, customerId, notificationType, message);
        boolean success = notificationDAO.createNotification(notification);
        out.print("{\"success\": " + success + "}");
    }
}

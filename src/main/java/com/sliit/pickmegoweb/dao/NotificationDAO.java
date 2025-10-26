package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.Notification;
import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    
    private Connection connection;
    
    public NotificationDAO() {
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Failed to get database connection for NotificationDAO.");
        }
    }
    
    // Create a new notification
    public boolean createNotification(Notification notification) {
        String sql = "INSERT INTO Notifications (TripID, DriverID, CustomerID, NotificationType, Message, IsRead, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, notification.getTripId());
            ps.setInt(2, notification.getDriverId());
            ps.setInt(3, notification.getCustomerId());
            ps.setString(4, notification.getNotificationType());
            ps.setString(5, notification.getMessage());
            ps.setBoolean(6, notification.isRead());
            ps.setTimestamp(7, notification.getCreatedTime());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get notifications for a specific driver
    public List<Notification> getNotificationsForDriver(int driverId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, t.* FROM Notifications n " +
                    "LEFT JOIN Trips t ON n.TripID = t.TripID " +
                    "WHERE n.DriverID = ? ORDER BY n.CreatedDate DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Notification notification = extractNotificationFromResultSet(rs);
                if (rs.getString("PickupLocation") != null) {
                    Trip trip = extractTripFromResultSet(rs);
                    notification.setTripDetails(trip);
                }
                notifications.add(notification);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }
    
    // Get notifications for a specific customer
    public List<Notification> getNotificationsForCustomer(int customerId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, t.* FROM Notifications n " +
                    "LEFT JOIN Trips t ON n.TripID = t.TripID " +
                    "WHERE n.CustomerID = ? ORDER BY n.CreatedDate DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Notification notification = extractNotificationFromResultSet(rs);
                if (rs.getString("PickupLocation") != null) {
                    Trip trip = extractTripFromResultSet(rs);
                    notification.setTripDetails(trip);
                }
                notifications.add(notification);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }
    
    // Get unread notifications for a driver
    public List<Notification> getUnreadNotificationsForDriver(int driverId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, t.* FROM Notifications n " +
                    "LEFT JOIN Trips t ON n.TripID = t.TripID " +
                    "WHERE n.DriverID = ? AND n.IsRead = 0 ORDER BY n.CreatedDate DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Notification notification = extractNotificationFromResultSet(rs);
                if (rs.getString("PickupLocation") != null) {
                    Trip trip = extractTripFromResultSet(rs);
                    notification.setTripDetails(trip);
                }
                notifications.add(notification);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }
    
    // Get unread notifications for a customer
    public List<Notification> getUnreadNotificationsForCustomer(int customerId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, t.* FROM Notifications n " +
                    "LEFT JOIN Trips t ON n.TripID = t.TripID " +
                    "WHERE n.CustomerID = ? AND n.IsRead = 0 ORDER BY n.CreatedDate DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Notification notification = extractNotificationFromResultSet(rs);
                if (rs.getString("PickupLocation") != null) {
                    Trip trip = extractTripFromResultSet(rs);
                    notification.setTripDetails(trip);
                }
                notifications.add(notification);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }
    
    // Mark notification as read
    public boolean markNotificationAsRead(int notificationId) {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Mark all notifications as read for a user
    public boolean markAllNotificationsAsRead(int userId, String userType) {
        String sql;
        if ("Driver".equals(userType)) {
            sql = "UPDATE Notifications SET IsRead = 1 WHERE DriverID = ?";
        } else {
            sql = "UPDATE Notifications SET IsRead = 1 WHERE CustomerID = ?";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get count of unread notifications for a driver
    public int getUnreadNotificationCountForDriver(int driverId) {
        String sql = "SELECT COUNT(*) as count FROM Notifications WHERE DriverID = ? AND IsRead = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get count of unread notifications for a customer
    public int getUnreadNotificationCountForCustomer(int customerId) {
        String sql = "SELECT COUNT(*) as count FROM Notifications WHERE CustomerID = ? AND IsRead = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Delete old notifications (cleanup)
    public boolean deleteOldNotifications(int daysOld) {
        String sql = "DELETE FROM Notifications WHERE CreatedDate < DATE_SUB(NOW(), INTERVAL ? DAY)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, daysOld);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Helper method to extract notification from ResultSet
    private Notification extractNotificationFromResultSet(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationId(rs.getInt("NotificationID"));
        notification.setTripId(rs.getInt("TripID"));
        notification.setDriverId(rs.getInt("DriverID"));
        notification.setCustomerId(rs.getInt("CustomerID"));
        notification.setNotificationType(rs.getString("NotificationType"));
        notification.setMessage(rs.getString("Message"));
        notification.setRead(rs.getBoolean("IsRead"));
        notification.setCreatedTime(rs.getTimestamp("CreatedDate"));
        return notification;
    }
    
    // Helper method to extract trip from ResultSet
    private Trip extractTripFromResultSet(ResultSet rs) throws SQLException {
        Trip trip = new Trip();
        trip.setTripId(rs.getInt("TripID"));
        trip.setCustomerId(rs.getInt("CustomerID"));
        
        Integer driverId = rs.getObject("DriverID", Integer.class);
        if (driverId != null) {
            trip.setDriverId(driverId);
        } else {
            trip.setDriverId(0);
        }
        
        // Handle pickup and dropoff locations with proper null checks
        String pickupLocation = rs.getString("PickupLocation");
        trip.setPickupLocation(pickupLocation != null ? pickupLocation : "");
        
        String dropoffLocation = rs.getString("DropOffLocation");
        trip.setDropoffLocation(dropoffLocation != null ? dropoffLocation : "");
        
        double distance = rs.getDouble("distance");
        trip.setDistance(String.valueOf(distance));
        
        trip.setVehicleType(rs.getString("vehicle_type"));
        trip.setPrice(rs.getDouble("price"));
        trip.setStatus(rs.getString("TripStatus"));
        trip.setBookingTime(rs.getTimestamp("BookingTime"));
        trip.setCompletionTime(rs.getTimestamp("CompletionTime"));
        
        return trip;
    }
}
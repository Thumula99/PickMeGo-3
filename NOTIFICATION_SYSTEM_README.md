# PickMeGo Ride Booking Notification System

## Overview
This implementation adds a comprehensive notification system to the PickMeGo ride booking application. When customers book a ride, the system automatically sends notifications to relevant drivers based on their vehicle type. Drivers can accept or reject rides, and customers are notified of the driver's decision in real-time.

## Features Implemented

### 1. Notification System Components
- **Notification Model**: Stores notification data including trip details, driver/customer IDs, message, and read status
- **NotificationDAO**: Database operations for creating, retrieving, and managing notifications
- **NotificationServlet**: REST API endpoints for notification management

### 2. Driver Matching by Vehicle Type
- When a customer books a ride, the system automatically finds all drivers with matching vehicle types
- Notifications are sent to all relevant drivers simultaneously
- Drivers can see trip details including pickup/dropoff locations, distance, and price

### 3. Real-time Updates
- **Driver Dashboard**: Shows notifications with accept/reject buttons
- **Customer Status Page**: Real-time updates on ride status (searching, accepted, rejected)
- Polling mechanism updates every 5-10 seconds for real-time experience

### 4. Accept/Reject Functionality
- Drivers can accept rides (updates trip status to "Accepted")
- Drivers can reject rides (notifies customer of rejection)
- Customers receive immediate notifications of driver decisions

## Database Schema

### Notifications Table
```sql
CREATE TABLE IF NOT EXISTS Notifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    TripID INT NOT NULL,
    DriverID INT NOT NULL,
    CustomerID INT NOT NULL,
    NotificationType VARCHAR(50) NOT NULL,
    Message TEXT NOT NULL,
    IsRead BOOLEAN DEFAULT FALSE,
    CreatedTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TripID) REFERENCES Trips(TripID) ON DELETE CASCADE,
    FOREIGN KEY (DriverID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID) ON DELETE CASCADE
);
```

## API Endpoints

### NotificationServlet Endpoints
- `GET /NotificationServlet?action=getNotifications` - Get all notifications for user
- `GET /NotificationServlet?action=getUnreadNotifications` - Get unread notifications
- `GET /NotificationServlet?action=getUnreadCount` - Get count of unread notifications
- `GET /NotificationServlet?action=markAsRead&notificationId={id}` - Mark specific notification as read
- `GET /NotificationServlet?action=markAllAsRead` - Mark all notifications as read
- `POST /NotificationServlet?action=createNotification` - Create new notification

### DriverServlet Endpoints (Enhanced)
- `GET /DriverServlet?action=acceptTrip&tripId={id}` - Accept a trip (creates customer notification)
- `GET /DriverServlet?action=rejectTrip&tripId={id}` - Reject a trip (creates customer notification)

## User Interface Enhancements

### Driver Dashboard
- **Notification Panel**: Shows unread notifications with trip details
- **Accept/Reject Buttons**: For each pending ride request
- **Real-time Updates**: Notifications refresh every 10 seconds
- **Notification Badge**: Shows count of unread notifications

### Customer Status Page
- **Dynamic States**: Searching, Accepted, Rejected states with visual indicators
- **Trip Details**: Shows pickup/dropoff locations, distance, price
- **Real-time Updates**: Status updates every 5 seconds
- **Notification History**: Shows recent updates from drivers

## Workflow

### 1. Customer Books Ride
1. Customer fills out ride booking form
2. System creates trip record with "Pending" status
3. System finds all drivers with matching vehicle type
4. System creates notifications for each relevant driver
5. Customer is redirected to status page

### 2. Driver Receives Notification
1. Driver dashboard shows new notification
2. Driver can see trip details (pickup, dropoff, distance, price)
3. Driver can accept or reject the ride

### 3. Driver Accepts Ride
1. Trip status updated to "Accepted"
2. Driver ID assigned to trip
3. Customer receives "RIDE_ACCEPTED" notification
4. Customer status page shows "Driver Found!" state

### 4. Driver Rejects Ride
1. Customer receives "RIDE_REJECTED" notification
2. Customer status page shows "Driver Declined" state
3. System continues searching for other drivers

## Technical Implementation

### Key Classes Added/Modified

#### New Classes
- `Notification.java` - Model class for notifications
- `NotificationDAO.java` - Database operations for notifications
- `NotificationServlet.java` - REST API for notification management

#### Modified Classes
- `CustomerServlet.java` - Added notification creation on ride booking
- `DriverServlet.java` - Added accept/reject functionality with notifications
- `UserDAO.java` - Added method to get drivers by vehicle type
- `RideDAO.java` - Added method to get trip by ID

### Database Operations
- Automatic notification creation when rides are booked
- Efficient querying with proper indexing
- Foreign key constraints for data integrity
- Cleanup methods for old notifications

## Setup Instructions

1. **Database Setup**:
   ```sql
   -- Run the notifications_schema.sql script
   source pickmegoweb/database/notifications_schema.sql
   ```

2. **Deploy Application**:
   - Deploy the updated WAR file to your servlet container
   - Ensure all dependencies are included

3. **Test the System**:
   - Register drivers with different vehicle types
   - Book rides as a customer
   - Verify notifications appear for relevant drivers
   - Test accept/reject functionality

## Future Enhancements

1. **Push Notifications**: Integrate with mobile push notification services
2. **WebSocket Support**: Replace polling with WebSocket for true real-time updates
3. **Notification Preferences**: Allow users to configure notification settings
4. **Email Notifications**: Send email notifications for important updates
5. **SMS Integration**: Send SMS notifications for critical updates

## Troubleshooting

### Common Issues
1. **Notifications not appearing**: Check database connection and table creation
2. **Real-time updates not working**: Verify JavaScript console for errors
3. **Driver matching issues**: Ensure vehicle types match exactly (case-insensitive)

### Debug Features
- Driver dashboard includes debug panel for troubleshooting
- Console logging for all API calls
- Error handling with user-friendly messages

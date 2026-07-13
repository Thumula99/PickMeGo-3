# PickMeGo - Ride Booking System

A comprehensive ride-booking web application built with Java, featuring real-time driver notifications, vehicle matching, and a complete notification system for managing ride requests.

## 📋 Project Overview

PickMeGo is a Java-based web application that connects customers with drivers for ride-sharing services. The application includes a robust notification system that automatically matches customers' ride requests with available drivers based on vehicle type and manages the entire booking workflow.

### Key Features

- **Ride Booking System**: Customers can request rides with pickup and dropoff locations
- **Driver Matching**: Automatic matching of customers with available drivers by vehicle type
- **Real-time Notifications**: Instant notifications sent to relevant drivers when rides are booked
- **Trip Management**: Track trip status through various states (Pending, Accepted, Rejected)
- **Driver Dashboard**: Real-time display of available ride requests with accept/reject functionality
- **Customer Status Page**: Live updates on ride status with driver information
- **Notification Management**: Comprehensive notification history and read/unread tracking

## 🛠️ Technical Stack

- **Language**: Java 17
- **Build Tool**: Maven 3.x
- **Server**: Jakarta Servlet Container (WAR deployment)
- **Database**: Microsoft SQL Server
- **Web Framework**: Jakarta Servlet & JSP (JSTL)
- **JSON Processing**: Google Gson 2.10.1
- **Testing**: JUnit 5

### Project Dependencies

- `jakarta.servlet-api` (6.1.0) - Servlet API
- `mssql-jdbc` (13.2.0) - SQL Server JDBC Driver
- `gson` (2.10.1) - JSON serialization/deserialization
- `jakarta.servlet.jsp.jstl` (3.0.1) - JSP Standard Tag Library
- `junit-jupiter` (5.11.0) - Unit testing framework

## 📁 Project Structure

```
PickMeGo-3/
├── src/                           # Source code
├── pom.xml                        # Maven configuration
├── NOTIFICATION_SYSTEM_README.md  # Detailed notification system documentation
└── README.md                      # This file
```

## 🔄 Ride Booking Workflow

### 1. Customer Books a Ride
1. Customer fills out the ride booking form with pickup and dropoff locations
2. System creates a trip record with "Pending" status
3. System identifies all drivers with matching vehicle types
4. Notifications are automatically created for each eligible driver
5. Customer is redirected to a status page showing real-time updates

### 2. Driver Receives Notification
1. Driver dashboard updates with new ride request notification
2. Driver can view trip details:
   - Pickup and dropoff locations
   - Estimated distance
   - Ride price
3. Driver has options to accept or reject the ride

### 3. Driver Accepts Ride
1. Trip status is updated to "Accepted"
2. Driver ID is assigned to the trip
3. Customer receives "RIDE_ACCEPTED" notification
4. Customer status page displays "Driver Found!" with driver details

### 4. Driver Rejects Ride
1. Customer receives "RIDE_REJECTED" notification
2. Customer status page shows rejection status
3. System continues searching for other available drivers

## 📊 Database Schema

### Key Tables

#### Notifications Table
Stores all notification records with the following structure:
- `NotificationID` - Primary key
- `TripID` - Reference to the trip
- `DriverID` - Driver receiving the notification
- `CustomerID` - Customer who booked the ride
- `NotificationType` - Type of notification (RIDE_REQUEST, RIDE_ACCEPTED, RIDE_REJECTED, etc.)
- `Message` - Notification message content
- `IsRead` - Read status flag
- `CreatedTime` - Timestamp of creation

#### Supporting Tables (Referenced)
- `Users` - Driver and customer information
- `Trips` - Ride booking information

For detailed schema information, see [NOTIFICATION_SYSTEM_README.md](./NOTIFICATION_SYSTEM_README.md).

## 🚀 Getting Started

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- Microsoft SQL Server or compatible database
- Jakarta-compatible servlet container (Tomcat 10+, etc.)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Thumula99/PickMeGo-3.git
   cd PickMeGo-3
   ```

2. **Configure Database Connection**
   - Update database credentials in your application configuration
   - Create necessary database tables (see NOTIFICATION_SYSTEM_README.md for schema)

3. **Build the Project**
   ```bash
   mvn clean package
   ```

4. **Deploy**
   - Deploy the generated WAR file to your servlet container
   - Example for Tomcat: `cp target/pickmegoweb-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/`

5. **Start the Application**
   - Start your servlet container
   - Access the application at `http://localhost:8080/pickmegoweb/`

## 🔌 API Endpoints

### Notification API
- **GET** `/NotificationServlet?action=getNotifications` - Get all notifications for current user
- **GET** `/NotificationServlet?action=getUnreadNotifications` - Get unread notifications only
- **GET** `/NotificationServlet?action=getUnreadCount` - Get count of unread notifications
- **GET** `/NotificationServlet?action=markAsRead&notificationId={id}` - Mark notification as read
- **GET** `/NotificationServlet?action=markAllAsRead` - Mark all notifications as read
- **POST** `/NotificationServlet?action=createNotification` - Create new notification

### Driver API
- **GET** `/DriverServlet?action=acceptTrip&tripId={id}` - Accept a ride request
- **GET** `/DriverServlet?action=rejectTrip&tripId={id}` - Reject a ride request

## 🧪 Testing

Run the test suite using Maven:
```bash
mvn test
```

## 📋 Features in Detail

### Real-time Updates
- Driver dashboard refreshes every 10 seconds
- Customer status page updates every 5 seconds
- JavaScript polling mechanism for smooth updates

### Notification Management
- Automatic creation upon ride booking
- Read/unread status tracking
- Notification history viewing
- Bulk mark-as-read functionality

### Driver Matching
- Automatic vehicle type matching
- Simultaneous multi-driver notification
- Flexible matching criteria

## 🚧 Future Enhancements

- Push notifications for mobile devices
- WebSocket support for real-time updates
- User notification preferences configuration
- Email notification integration
- SMS alerts for critical updates
- Advanced filtering and search capabilities
- Rating and review system
- Payment integration

## 🐛 Troubleshooting

### Common Issues

**Notifications not appearing**
- Verify database connection is active
- Check that notification table has been created
- Review application logs for errors

**Real-time updates not working**
- Check browser console for JavaScript errors
- Verify polling interval is correctly configured
- Ensure servlet endpoints are accessible

**Driver matching not working**
- Confirm vehicle types match exactly (check for case sensitivity)
- Verify drivers have been registered with vehicle types
- Check database for driver records

## 📝 Documentation

For detailed information about the notification system implementation, refer to [NOTIFICATION_SYSTEM_README.md](./NOTIFICATION_SYSTEM_README.md).

## 📄 License

This project is currently unlicensed. See LICENSE file for more information.

## 👤 Author

- **Thumula99** - Initial development and implementation

## 📞 Support

For issues, questions, or contributions, please open an issue on the [GitHub repository](https://github.com/Thumula99/PickMeGo-3).

---

**Note**: This is an actively developed project. Please refer to the issues and pull requests for ongoing work and planned features.

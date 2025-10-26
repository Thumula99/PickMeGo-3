<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <style>
        /* Custom styles for driver dashboard */
        .driver-specific {
            /* Driver-specific overrides can go here */
        }
        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        h1, h2 {
            color: #2c3e50;
        }
        .trip-request {
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .trip-details p {
            margin: 5px 0;
        }
        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-accept {
            background: #2ecc71;
            color: white;
        }
        .btn-update {
            background: #3498db;
            color: white;
        }
        .btn-complete {
            background: #27ae60;
            color: white;
        }
        .btn-cancel {
            background: #e74c3c;
            color: white;
        }
        .btn-reject {
            background: #e67e22;
            color: white;
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }
        .header-info h1 {
            margin: 0;
        }
        .header-info p {
            margin: 5px 0 0 0;
            color: #666;
        }
        .header-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .header-actions .btn {
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            font-size: 14px;
            padding: 8px 12px;
        }
        .header-actions .btn i {
            margin-right: 5px;
        }
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                align-items: flex-start;
            }
            .header-actions {
                width: 100%;
                justify-content: flex-start;
            }
        }
        .notification-badge {
            background: #e74c3c;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
            margin-left: 10px;
        }
        .notification-item {
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 10px;
            background: #f9f9f9;
        }
        .notification-item.unread {
            background: #e8f4fd;
            border-left: 4px solid #3498db;
        }
        .status-buttons button {
            margin-right: 5px;
        }
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        .error-message {
            color: #e74c3c;
            padding: 10px;
            background-color: #fadbd8;
            border-radius: 4px;
            margin: 10px 0;
        }
        .debug-panel {
            background-color: #f8f9fa;
            border-left: 4px solid #e74c3c;
            padding: 15px;
            margin-top: 20px;
            font-family: monospace;
            font-size: 14px;
            display: none;
        }
        .debug-toggle {
            background: #95a5a6;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        
        /* Current Trip Styles */
        .current-trip-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }
        
        .current-trip-card h3 {
            margin: 0 0 20px 0;
            font-size: 1.5em;
            text-align: center;
            border-bottom: 2px solid rgba(255, 255, 255, 0.3);
            padding-bottom: 10px;
        }
        
        .trip-details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .detail-item i {
            font-size: 1.5em;
            margin-right: 15px;
            width: 30px;
            text-align: center;
        }
        
        .pickup-icon { color: #2ecc71; }
        .dropoff-icon { color: #e74c3c; }
        .distance-icon { color: #3498db; }
        .price-icon { color: #f39c12; }
        .vehicle-icon { color: #9b59b6; }
        .status-icon { color: #1abc9c; }
        
        .detail-content {
            flex: 1;
        }
        
        .detail-content strong {
            display: block;
            font-size: 0.9em;
            margin-bottom: 5px;
            opacity: 0.9;
        }
        
        .detail-content span {
            font-size: 1.1em;
            font-weight: 500;
        }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-accepted { background: #2ecc71; color: white; }
        .status-on-the-way { background: #3498db; color: white; }
        .status-arrived { background: #f39c12; color: white; }
        .status-completed { background: #27ae60; color: white; }
        .status-cancelled { background: #e74c3c; color: white; }
        .status-pending { background: #95a5a6; color: white; }
        
        .trip-actions {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .trip-actions h4 {
            margin: 0 0 15px 0;
            text-align: center;
            font-size: 1.2em;
        }
        
        .no-trip-message {
            text-align: center;
            padding: 40px 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border: 2px dashed #dee2e6;
        }
        
        .no-trip-message i {
            font-size: 3em;
            color: #6c757d;
            margin-bottom: 15px;
        }
        
        .no-trip-message p {
            color: #6c757d;
            margin: 10px 0;
        }
        
        /* Accepted Trips Styles */
        .accepted-trip-card {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            margin-bottom: 15px;
            border-left: 5px solid #1e8449;
        }
        
        .accepted-trip-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.3);
        }
        
        .accepted-trip-header h4 {
            margin: 0;
            font-size: 1.2em;
            display: flex;
            align-items: center;
        }
        
        .accepted-trip-header h4 i {
            margin-right: 10px;
            font-size: 1.1em;
        }
        
        .accepted-trip-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .accepted-detail-item {
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 12px;
            border-radius: 8px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .accepted-detail-item i {
            font-size: 1.3em;
            margin-right: 12px;
            width: 25px;
            text-align: center;
        }
        
        .accepted-detail-content {
            flex: 1;
        }
        
        .accepted-detail-content strong {
            display: block;
            font-size: 0.85em;
            margin-bottom: 4px;
            opacity: 0.9;
        }
        
        .accepted-detail-content span {
            font-size: 1em;
            font-weight: 500;
        }
        
        .accepted-trip-actions {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 8px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .accepted-trip-actions h5 {
            margin: 0 0 10px 0;
            text-align: center;
            font-size: 1em;
            opacity: 0.9;
        }
        
        .accepted-status-badge {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.8em;
            font-weight: bold;
            text-transform: uppercase;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .no-accepted-trips-message {
            text-align: center;
            padding: 40px 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border: 2px dashed #dee2e6;
        }
        
        .no-accepted-trips-message i {
            font-size: 3em;
            color: #28a745;
            margin-bottom: 15px;
        }
        
        .no-accepted-trips-message p {
            color: #6c757d;
            margin: 10px 0;
        }
        
        /* Active Trip Count Styles */
        .trip-limit-warning {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            text-align: center;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
        }
        
        .trip-limit-warning i {
            margin-right: 10px;
            font-size: 1.2em;
        }
        
        .btn-accept:disabled {
            background: #95a5a6;
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        .btn-accept:disabled:hover {
            background: #95a5a6;
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <div class="header-content">
            <div class="header-info">
                <h1><i class="fas fa-tachometer-alt"></i> Driver Dashboard</h1>
                <p>Welcome, ${sessionScope.user.fullName}!</p>
            </div>
            <div class="header-actions">
                <a href="profile_view.jsp" class="btn btn-update">
                    <i class="fas fa-user"></i> View Profile
                </a>
                <a href="../UserServlet?action=logout" class="btn btn-cancel">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </header>

    <div class="card">
        <h2><i class="fas fa-exclamation-triangle"></i> Customer Cancellations <span id="notification-count" class="notification-badge">0</span></h2>
        <div id="notifications">
            <p><i class="fas fa-spinner loading"></i> Loading cancellation notifications...</p>
        </div>
        <button class="btn btn-update" onclick="markAllNotificationsAsRead()">Mark All as Read</button>
    </div>

    <div class="card">
        <h2><i class="fas fa-list-ul"></i> Pending Ride Requests 
            <span id="active-trip-count" class="notification-badge" style="background: #3498db;">0/2</span>
        </h2>
        <div id="pending-requests">
            <p><i class="fas fa-spinner loading"></i> Loading requests...</p>
        </div>
    </div>

    <div class="card">
        <h2><i class="fas fa-route"></i> My Current Trip</h2>
        <div id="current-trip">
            <p><i class="fas fa-spinner loading"></i> Loading current trip...</p>
        </div>
    </div>

    <div class="card">
        <h2><i class="fas fa-check-circle"></i> Accepted Trip Details</h2>
        <div id="accepted-trips">
            <p><i class="fas fa-spinner loading"></i> Loading accepted trips...</p>
        </div>
    </div>

    <button class="debug-toggle" onclick="toggleDebug()">Toggle Debug Info</button>
    <div class="debug-panel" id="debug-panel">
        <h3>Debug Information</h3>
        <div id="debug-info"></div>
    </div>
</div>

<script>
    // Debug functions
    function debugLog(message) {
        var debugInfo = document.getElementById('debug-info');
        var time = new Date().toLocaleTimeString();
        debugInfo.innerHTML += '<p>' + time + ': ' + message + '</p>';
    }

    function toggleDebug() {
        var panel = document.getElementById('debug-panel');
        panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
    }

    // Function to get context path correctly
    function getContextPath() {
        return "${pageContext.request.contextPath}";
    }

    // Function to fetch and display customer cancellation notifications
    function fetchNotifications() {
        debugLog("Fetching customer cancellation notifications...");
        var container = document.getElementById('notifications');
        var countElement = document.getElementById('notification-count');
        
        fetch(getContextPath() + '/NotificationServlet?action=getUnreadNotifications')
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                debugLog("Received " + data.length + " notifications");
                debugLog("Notification data structure: " + JSON.stringify(data));
                var container = document.getElementById('notifications');
                var countElement = document.getElementById('notification-count');
                
                // Filter for customer cancellation/rejection notifications
                var cancellationNotifications = data.filter(function(notification) {
                    var notificationType = notification.NotificationType || notification.notificationType;
                    return notificationType === 'CUSTOMER_CANCELLED' || 
                           notificationType === 'CUSTOMER_REJECTED' || 
                           notificationType === 'TRIP_CANCELLED_BY_CUSTOMER';
                });
                
                countElement.textContent = cancellationNotifications.length;

                if (cancellationNotifications && cancellationNotifications.length > 0) {
                    container.innerHTML = '';
                    cancellationNotifications.forEach(function(notification) {
                        // Debug the notification object structure
                        debugLog("Processing cancellation notification: " + JSON.stringify(notification));
                        
                        // Handle different possible property names (including JSON serialized names)
                        var notificationId = notification.NotificationID || notification.notificationId;
                        var notificationType = notification.NotificationType || notification.notificationType;
                        var message = notification.Message || notification.message;
                        var isRead = notification.IsRead !== undefined ? notification.IsRead : notification.isRead;
                        var createdTime = notification.CreatedDate || notification.createdTime;
                        
                        debugLog("Extracted - ID: " + notificationId + ", Type: " + notificationType + ", Message: " + message + ", Created: " + createdTime);
                        
                        var notificationDiv = document.createElement('div');
                        notificationDiv.className = 'notification-item' + (isRead ? '' : ' unread');
                        
                        var tripDetails = '';
                        if (notification.TripDetails || notification.tripDetails) {
                            var trip = notification.TripDetails || notification.tripDetails;
                            var pickupLocation = trip.PickupLocation || trip.pickupLocation;
                            var dropoffLocation = trip.DropOffLocation || trip.dropoffLocation;
                            tripDetails = '<p><strong>From:</strong> ' + (pickupLocation || 'N/A') + 
                                         ' <strong>To:</strong> ' + (dropoffLocation || 'N/A') + '</p>';
                        }
                        
                        var formattedDate = 'N/A';
                        if (createdTime) {
                            try {
                                // Handle different date formats
                                var date = new Date(createdTime);
                                if (isNaN(date.getTime())) {
                                    formattedDate = 'Invalid Date';
                                } else {
                                    formattedDate = date.toLocaleString();
                                }
                            } catch (e) {
                                debugLog("Date parsing error: " + e.message + " for value: " + createdTime);
                                formattedDate = 'Invalid Date';
                            }
                        }
                        
                        var markAsReadButton = '';
                        if (notificationId && notificationId !== 'undefined' && notificationId !== 'null') {
                            markAsReadButton = '<button class="btn btn-update" onclick="markNotificationAsRead(' + notificationId + ')">Mark as Read</button>';
                        } else {
                            debugLog("Skipping mark as read button for invalid notification ID: " + notificationId);
                        }
                        
                        // Format notification type for display
                        var displayType = (notificationType || 'Unknown Type')
                            .replace(/_/g, ' ')
                            .replace(/\b\w/g, l => l.toUpperCase());
                        
                        notificationDiv.innerHTML = 
                            '<p><strong><i class="fas fa-times-circle"></i> ' + displayType + '</strong></p>' +
                            '<p>' + (message || 'No message') + '</p>' +
                            tripDetails +
                            '<p><small>' + formattedDate + '</small></p>' +
                            markAsReadButton;
                        
                        container.appendChild(notificationDiv);
                    });
                } else {
                    container.innerHTML = '<p>No customer cancellations at this time.</p>';
                }
            })
            .catch(function(err) {
                console.error('Error fetching notifications:', err);
                debugLog("Error fetching notifications: " + err.message);
                var container = document.getElementById('notifications');
                var countElement = document.getElementById('notification-count');
                
                countElement.textContent = '0';
                container.innerHTML = 
                    '<div class="error-message">' +
                    '<p><strong>Error loading cancellation notifications:</strong> ' + err.message + '</p>' +
                    '<p>This might be due to:</p>' +
                    '<ul>' +
                    '<li>Database connection issues</li>' +
                    '<li>Notifications table not created</li>' +
                    '<li>Server configuration problems</li>' +
                    '</ul>' +
                    '<p>Check the debug panel for more details.</p>' +
                    '</div>';
            });
        
    }

    // Function to mark notification as read
    function markNotificationAsRead(notificationId) {
        fetch(getContextPath() + '/NotificationServlet?action=markAsRead&notificationId=' + notificationId)
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    fetchNotifications();
                }
            })
            .catch(function(err) {
                console.error('Error marking notification as read:', err);
            });
    }

    // Function to mark all notifications as read
    function markAllNotificationsAsRead() {
        fetch(getContextPath() + '/NotificationServlet?action=markAllAsRead')
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    fetchNotifications();
                }
            })
            .catch(function(err) {
                console.error('Error marking all notifications as read:', err);
            });
    }

    // Function to reject a trip
    function rejectTrip(tripId) {
        debugLog("Rejecting trip with ID: " + tripId);
        console.log("Reject button clicked for trip ID:", tripId);
        
        // Validate tripId
        if (!tripId || tripId === 'undefined' || tripId === 'null') {
            alert('Invalid trip ID. Cannot reject this trip.');
            debugLog("Invalid trip ID provided: " + tripId);
            return;
        }

        if (confirm('Are you sure you want to reject this trip?')) {
            debugLog("User confirmed rejection, making request...");
            fetch(getContextPath() + '/DriverServlet?action=rejectTrip&tripId=' + tripId)
                .then(function(response) {
                    debugLog("Reject response status: " + response.status);
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    debugLog("Reject response data: " + JSON.stringify(data));
                    if (data.success) {
                        alert('Trip rejected!');
                        fetchPendingRequests();
                    } else {
                        alert('Failed to reject trip: ' + (data.message || 'Unknown error'));
                    }
                })
                .catch(function(err) {
                    console.error('Error rejecting trip:', err);
                    debugLog("Error rejecting trip: " + err.message);
                    alert('Error rejecting trip. Check console for details.');
                });
        } else {
            debugLog("User cancelled rejection");
        }
    }

    // Function to fetch active trip count
    function fetchActiveTripCount() {
        fetch(getContextPath() + '/DriverServlet?action=getActiveTripCount')
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                var countElement = document.getElementById('active-trip-count');
                var activeCount = data.activeTripCount || 0;
                countElement.textContent = activeCount + '/2';
                
                // Change color based on count
                if (activeCount >= 2) {
                    countElement.style.background = '#e74c3c'; // Red when at limit
                } else if (activeCount >= 1) {
                    countElement.style.background = '#f39c12'; // Orange when 1 active
                } else {
                    countElement.style.background = '#3498db'; // Blue when none
                }
            })
            .catch(function(err) {
                console.error('Error fetching active trip count:', err);
            });
    }

    // Function to fetch and display pending requests
    function fetchPendingRequests() {
        debugLog("Fetching pending requests...");

        // First get the active trip count to determine if accept buttons should be disabled
        fetch(getContextPath() + '/DriverServlet?action=getActiveTripCount')
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(countData) {
                var activeTripCount = countData.activeTripCount || 0;
                var isAtLimit = activeTripCount >= 2;
                
                // Now fetch pending requests
                return fetch(getContextPath() + '/DriverServlet?action=viewRequests')
                    .then(function(response) {
                        debugLog("Response status: " + response.status);
                        if (!response.ok) {
                            throw new Error('Network response was not ok: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(function(data) {
                        debugLog("Received " + data.length + " pending requests");
                        var container = document.getElementById('pending-requests');
                        container.innerHTML = '';

                        // Show warning if at limit
                        if (isAtLimit) {
                            var warningDiv = document.createElement('div');
                            warningDiv.className = 'trip-limit-warning';
                            warningDiv.innerHTML = '<i class="fas fa-exclamation-triangle"></i>You have reached the maximum of 2 active trips. Complete or cancel a trip to accept new requests.';
                            container.appendChild(warningDiv);
                        }

                        if (data && data.length > 0) {
                            data.forEach(function(trip) {
                                // Debug the trip object structure
                                debugLog("Trip object keys: " + Object.keys(trip).join(', '));
                                debugLog("Trip data: " + JSON.stringify(trip));

                                var tripDiv = document.createElement('div');
                                tripDiv.className = 'trip-request';

                                // Handle different possible property names (including JSON serialized names)
                                var tripId = trip.tripId || trip.tripID || trip.id || trip.TripID;
                                var pickupLocation = trip.pickupLocation || trip.pickup_location || trip.PickupLocation;
                                var dropoffLocation = trip.dropoffLocation || trip.dropoff_location || trip.DropOffLocation;
                                var distance = trip.distance || trip.trip_distance;
                                var vehicleType = trip.vehicleType || trip.vehicle_type;
                                var price = trip.price ? 'LKR ' + parseFloat(trip.price).toFixed(2) : 'N/A';
                                
                                // Debug the extracted values
                                debugLog("Extracted - Pickup: " + pickupLocation + ", Dropoff: " + dropoffLocation);
                                debugLog("Trip ID for buttons: " + tripId);
                                
                                // Skip this trip if tripId is invalid
                                if (!tripId || tripId === 'undefined' || tripId === 'null') {
                                    debugLog("Skipping trip with invalid ID: " + tripId);
                                    return;
                                }

                                var acceptButton = isAtLimit ? 
                                    '<button class="btn btn-accept" disabled title="You have reached the maximum of 2 active trips">Accept</button>' :
                                    '<button class="btn btn-accept" onclick="acceptTrip(' + tripId + ')">Accept</button>';

                                tripDiv.innerHTML = '<div class="trip-details">' +
                                    '<p><strong>Pickup:</strong> ' + (pickupLocation || 'N/A') + '</p>' +
                                    '<p><strong>Drop-off:</strong> ' + (dropoffLocation || 'N/A') + '</p>' +
                                    '<p><strong>Distance:</strong> ' + (distance || 'N/A') + ' km</p>' +
                                    '<p><strong>Vehicle Type:</strong> ' + (vehicleType || 'N/A') + '</p>' +
                                    '<p><strong>Price:</strong> ' + price + '</p>' +
                                    '</div>' +
                                    '<div class="status-buttons">' +
                                    acceptButton +
                                    '<button class="btn btn-reject" onclick="rejectTrip(' + tripId + ')">Reject</button>' +
                                    '</div>';

                                container.appendChild(tripDiv);
                            });
                        } else {
                            container.innerHTML = '<p>No pending ride requests at this time.</p>';
                        }
                    });
            })
            .catch(function(err) {
                console.error('Error fetching pending requests:', err);
                debugLog("Error: " + err.message);
                document.getElementById('pending-requests').innerHTML =
                    '<div class="error-message">' +
                    '<p>Error loading requests: ' + err.message + '</p>' +
                    '<p>Check console for more details.</p>' +
                    '</div>';
            });
    }

    // Function to fetch and display the current trip
    function fetchCurrentTrip() {
        debugLog("Fetching current trip...");

        fetch(getContextPath() + '/DriverServlet?action=viewCurrentTrip')
            .then(function(response) {
                debugLog("Current trip response status: " + response.status);
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                debugLog("Received current trip data: " + JSON.stringify(data));
                var container = document.getElementById('current-trip');

                if (data && (data.tripId || data.tripID || data.id)) {
                    // Handle different possible property names (including JSON serialized names)
                    var tripId = data.tripId || data.tripID || data.id;
                    var pickupLocation = data.pickupLocation || data.pickup_location || data.PickupLocation;
                    var dropoffLocation = data.dropoffLocation || data.dropoff_location || data.DropOffLocation;
                    var status = data.status || data.trip_status || data.TripStatus;
                    var distance = data.distance || data.trip_distance;
                    var vehicleType = data.vehicleType || data.vehicle_type;
                    var price = data.price ? 'LKR ' + parseFloat(data.price).toFixed(2) : 'N/A';
                    var bookingTime = data.bookingTime || data.BookingTime;
                    
                    // Debug the extracted values
                    debugLog("Current trip - ID: " + tripId + ", Pickup: " + pickupLocation + ", Dropoff: " + dropoffLocation);
                    
                    // Validate tripId before proceeding
                    if (!tripId || tripId === 'undefined' || tripId === 'null') {
                        debugLog("Invalid trip ID for current trip: " + tripId);
                        container.innerHTML = '<div class="no-trip-message">' +
                            '<i class="fas fa-info-circle"></i>' +
                            '<p>You currently do not have an active trip.</p>' +
                            '<p>Accept a ride request to see trip details here.</p>' +
                            '</div>';
                        return;
                    }

                    container.innerHTML = '<div class="current-trip-card">' +
                        '<h3><i class="fas fa-route"></i> Current Trip Details</h3>' +
                        '<div class="trip-details-grid">' +
                        '<div class="detail-item">' +
                        '<i class="fas fa-map-marker-alt pickup-icon"></i>' +
                        '<div class="detail-content">' +
                        '<strong>Pickup Location</strong><br>' +
                        '<span>' + (pickupLocation || 'N/A') + '</span>' +
                        '</div>' +
                        '</div>' +
                        '<div class="detail-item">' +
                        '<i class="fas fa-flag-checkered dropoff-icon"></i>' +
                        '<div class="detail-content">' +
                        '<strong>Drop-off Location</strong><br>' +
                        '<span>' + (dropoffLocation || 'N/A') + '</span>' +
                        '</div>' +
                        '</div>' +
                        '<div class="detail-item">' +
                        '<i class="fas fa-road distance-icon"></i>' +
                        '<div class="detail-content">' +
                        '<strong>Distance</strong><br>' +
                        '<span>' + (distance || 'N/A') + ' km</span>' +
                        '</div>' +
                        '</div>' +
                        '<div class="detail-item">' +
                        '<i class="fas fa-money-bill-wave price-icon"></i>' +
                        '<div class="detail-content">' +
                        '<strong>Price</strong><br>' +
                        '<span>' + price + '</span>' +
                        '</div>' +
                        '</div>' +
                        '<div class="detail-item">' +
                        '<i class="fas fa-car vehicle-icon"></i>' +
                        '<div class="detail-content">' +
                        '<strong>Vehicle Type</strong><br>' +
                        '<span>' + (vehicleType || 'N/A') + '</span>' +
                        '</div>' +
                        '</div>' +
                        '<div class="detail-item">' +
                        '<i class="fas fa-info-circle status-icon"></i>' +
                        '<div class="detail-content">' +
                        '<strong>Status</strong><br>' +
                        '<span class="status-badge status-' + (status || 'unknown').toLowerCase().replace(' ', '-') + '">' + (status || 'N/A') + '</span>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="trip-actions">' +
                        '<h4><i class="fas fa-tasks"></i> Trip Actions</h4>' +
                        '<div class="status-buttons">' +
                        generateTripActionButtons(tripId, status) +
                        '</div>' +
                        '</div>' +
                        '</div>';
                } else {
                    container.innerHTML = '<div class="no-trip-message">' +
                        '<i class="fas fa-info-circle"></i>' +
                        '<p>You currently do not have an active trip.</p>' +
                        '<p>Accept a ride request to see trip details here.</p>' +
                        '</div>';
                }
            })
            .catch(function(err) {
                console.error('Error fetching current trip:', err);
                debugLog("Error: " + err.message);
                document.getElementById('current-trip').innerHTML =
                    '<div class="error-message">' +
                    '<p>Error loading current trip: ' + err.message + '</p>' +
                    '<p>Check console for more details.</p>' +
                    '</div>';
            });
    }

    // Function to accept a trip
    function acceptTrip(tripId) {
        debugLog("Accepting trip with ID: " + tripId);
        console.log("Accept button clicked for trip ID:", tripId);
        
        // Validate tripId
        if (!tripId || tripId === 'undefined' || tripId === 'null') {
            alert('Invalid trip ID. Cannot accept this trip.');
            debugLog("Invalid trip ID provided: " + tripId);
            return;
        }

        if (confirm('Are you sure you want to accept this trip?')) {
            debugLog("User confirmed acceptance, making request...");
            fetch(getContextPath() + '/DriverServlet?action=acceptTrip&tripId=' + tripId)
                .then(function(response) {
                    debugLog("Accept response status: " + response.status);
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    debugLog("Accept response data: " + JSON.stringify(data));
                    if (data.success) {
                        alert('Trip accepted!');
                        fetchPendingRequests();
                        fetchCurrentTrip();
                        fetchAcceptedTrips(); // Refresh accepted trips list
                        fetchActiveTripCount(); // Refresh active trip count
                    } else {
                        alert('Failed to accept trip: ' + (data.message || 'Unknown error'));
                    }
                })
                .catch(function(err) {
                    console.error('Error accepting trip:', err);
                    debugLog("Error accepting trip: " + err.message);
                    alert('Error accepting trip. Check console for details.');
                });
        } else {
            debugLog("User cancelled acceptance");
        }
    }

    // Function to generate trip action buttons based on current status
    function generateTripActionButtons(tripId, currentStatus) {
        var buttons = '';
        
        switch(currentStatus) {
            case 'Accepted':
                buttons += '<button class="btn btn-primary" onclick="confirmTripAction(' + tripId + ', \'InProgress\', \'Start Trip\')">' +
                          '<i class="fas fa-play"></i> Start Trip' +
                          '</button>';
                buttons += '<button class="btn btn-danger" onclick="confirmTripAction(' + tripId + ', \'Cancelled\', \'Cancel Trip\')">' +
                          '<i class="fas fa-times"></i> Cancel Trip' +
                          '</button>';
                break;
            case 'InProgress':
                buttons += '<button class="btn btn-warning" onclick="confirmTripAction(' + tripId + ', \'Arrived\', \'Mark Arrived\')">' +
                          '<i class="fas fa-map-marker-alt"></i> Mark Arrived' +
                          '</button>';
                buttons += '<button class="btn btn-danger" onclick="confirmTripAction(' + tripId + ', \'Cancelled\', \'Cancel Trip\')">' +
                          '<i class="fas fa-times"></i> Cancel Trip' +
                          '</button>';
                buttons += '<button class="btn btn-warning" onclick="openIncidentModal(' + tripId + ')" style="background-color: #e74c3c;">' +
                          '<i class="fas fa-exclamation-triangle"></i> Report Incident' +
                          '</button>';
                break;
            case 'Arrived':
                buttons += '<button class="btn btn-success" onclick="confirmTripAction(' + tripId + ', \'Completed\', \'Complete Trip\')">' +
                          '<i class="fas fa-check"></i> Complete Trip' +
                          '</button>';
                buttons += '<button class="btn btn-danger" onclick="confirmTripAction(' + tripId + ', \'Cancelled\', \'Cancel Trip\')">' +
                          '<i class="fas fa-times"></i> Cancel Trip' +
                          '</button>';
                break;
            case 'Completed':
            case 'Cancelled':
                buttons += '<span class="text-muted"><i class="fas fa-info-circle"></i> Trip is ' + currentStatus.toLowerCase() + '</span>';
                break;
            default:
                buttons += '<span class="text-muted"><i class="fas fa-question-circle"></i> Unknown status</span>';
        }
        
        return buttons;
    }

    // Function to confirm trip action
    function confirmTripAction(tripId, status, actionName) {
        var message = 'Are you sure you want to ' + actionName.toLowerCase() + '?';
        
        if (status === 'Cancelled') {
            message = 'Are you sure you want to cancel this trip? This action cannot be undone.';
        }
        
        if (confirm(message)) {
            updateTripStatus(tripId, status);
        }
    }

    // Function to update trip status
    function updateTripStatus(tripId, status) {
        debugLog("Updating trip " + tripId + " to status: " + status);

        // Show loading state
        showLoadingState();

        fetch(getContextPath() + '/DriverServlet?action=updateStatus&tripId=' + tripId + '&status=' + encodeURIComponent(status))
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                hideLoadingState();
                if (data.success) {
                    showSuccessMessage('Trip status updated to ' + status);
                    fetchCurrentTrip();
                    fetchAcceptedTrips(); // Refresh accepted trips after status update
                    fetchActiveTripCount(); // Refresh active trip count after status update
                } else {
                    showErrorMessage('Failed to update status: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(function(err) {
                hideLoadingState();
                console.error('Error updating trip status:', err);
                showErrorMessage('Error updating trip status. Please try again.');
            });
    }

    // Function to show loading state
    function showLoadingState() {
        // Create loading overlay if it doesn't exist
        var loadingOverlay = document.getElementById('loading-overlay');
        if (!loadingOverlay) {
            loadingOverlay = document.createElement('div');
            loadingOverlay.id = 'loading-overlay';
            loadingOverlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 9999;
            `;
            loadingOverlay.innerHTML = `
                <div style="background: white; padding: 20px; border-radius: 8px; text-align: center;">
                    <div style="border: 4px solid #f3f3f3; border-top: 4px solid #3498db; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin: 0 auto 10px;"></div>
                    <p>Updating trip status...</p>
                </div>
            `;
            document.body.appendChild(loadingOverlay);
        }
        loadingOverlay.style.display = 'flex';
    }

    // Function to hide loading state
    function hideLoadingState() {
        var loadingOverlay = document.getElementById('loading-overlay');
        if (loadingOverlay) {
            loadingOverlay.style.display = 'none';
        }
    }

    // Function to show success message
    function showSuccessMessage(message) {
        showNotification(message, 'success');
    }

    // Function to show error message
    function showErrorMessage(message) {
        showNotification(message, 'error');
    }

    // Function to show notification
    function showNotification(message, type) {
        // Remove existing notifications
        var existingNotifications = document.querySelectorAll('.notification');
        existingNotifications.forEach(function(notification) {
            notification.remove();
        });

        // Create notification element
        var notification = document.createElement('div');
        notification.className = 'notification notification-' + type;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            font-weight: bold;
            z-index: 10000;
            max-width: 300px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            animation: slideIn 0.3s ease-out;
        `;

        // Set background color based on type
        if (type === 'success') {
            notification.style.backgroundColor = '#27ae60';
        } else if (type === 'error') {
            notification.style.backgroundColor = '#e74c3c';
        }

        // Add icon and message
        var icon = type === 'success' ? '✓' : '✗';
        notification.innerHTML = '<span style="margin-right: 10px;">' + icon + '</span>' + message;

        // Add to page
        document.body.appendChild(notification);

        // Auto remove after 3 seconds
        setTimeout(function() {
            if (notification.parentNode) {
                notification.style.animation = 'slideOut 0.3s ease-in';
                setTimeout(function() {
                    if (notification.parentNode) {
                        notification.remove();
                    }
                }, 300);
            }
        }, 3000);
    }

    // Function to fetch and display accepted trips
    function fetchAcceptedTrips() {
        debugLog("Fetching accepted trips...");
        console.log("Fetching accepted trips from:", getContextPath() + '/DriverServlet?action=viewAcceptedTrips');

        fetch(getContextPath() + '/DriverServlet?action=viewAcceptedTrips')
            .then(function(response) {
                debugLog("Accepted trips response status: " + response.status);
                console.log("Accepted trips response status:", response.status);
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                debugLog("Received accepted trips data: " + JSON.stringify(data));
                console.log("Received accepted trips data:", data);
                debugLog("Data type: " + typeof data);
                debugLog("Data is null: " + (data === null));
                debugLog("Data is undefined: " + (data === undefined));
                
                var container = document.getElementById('accepted-trips');
                console.log("Container element:", container);

                if (data && data.length > 0) {
                    console.log("Found", data.length, "accepted trips to display");
                    container.innerHTML = '';
                    
                    var processedCount = 0;
                    data.forEach(function(trip, index) {
                        // Handle JSON serialized property names from Trip model
                        var tripId = trip.TripID || trip.tripId || trip.tripID || trip.id;
                        var pickupLocation = trip.PickupLocation || trip.pickupLocation || trip.pickup_location;
                        var dropoffLocation = trip.DropOffLocation || trip.dropoffLocation || trip.dropoff_location;
                        var status = trip.TripStatus || trip.status || trip.trip_status;
                        var distance = trip.distance || trip.trip_distance;
                        var vehicleType = trip.vehicle_type || trip.vehicleType;
                        var price = trip.price ? 'LKR ' + parseFloat(trip.price).toFixed(2) : 'N/A';
                        var bookingTime = trip.BookingTime || trip.bookingTime;
                        
                        // Debug the extracted values
                        console.log("Processing trip #" + (index + 1) + ":", trip);
                        console.log("Extracted values - ID:", tripId, "Pickup:", pickupLocation, "Dropoff:", dropoffLocation);
                        debugLog("Accepted trip - ID: " + tripId + ", Pickup: " + pickupLocation + ", Dropoff: " + dropoffLocation);
                        
                        // Skip this trip if tripId is invalid
                        if (!tripId || tripId === 'undefined' || tripId === 'null') {
                            debugLog("Skipping accepted trip with invalid ID: " + tripId);
                            return;
                        }

                        var tripCard = document.createElement('div');
                        tripCard.className = 'accepted-trip-card';
                        
                        var bookingDate = '';
                        if (bookingTime) {
                            try {
                                var date = new Date(bookingTime);
                                bookingDate = date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
                            } catch (e) {
                                bookingDate = 'N/A';
                            }
                        } else {
                            bookingDate = 'N/A';
                        }

                        tripCard.innerHTML = 
                            '<div class="accepted-trip-header">' +
                                '<h4><i class="fas fa-check-circle"></i> Trip #' + tripId + '</h4>' +
                                '<span class="accepted-status-badge">' + (status || 'Accepted') + '</span>' +
                            '</div>' +
                            '<div class="accepted-trip-details">' +
                                '<div class="accepted-detail-item">' +
                                    '<i class="fas fa-map-marker-alt pickup-icon"></i>' +
                                    '<div class="accepted-detail-content">' +
                                        '<strong>Pickup Location</strong>' +
                                        '<span>' + (pickupLocation || 'N/A') + '</span>' +
                                    '</div>' +
                                '</div>' +
                                '<div class="accepted-detail-item">' +
                                    '<i class="fas fa-flag-checkered dropoff-icon"></i>' +
                                    '<div class="accepted-detail-content">' +
                                        '<strong>Drop-off Location</strong>' +
                                        '<span>' + (dropoffLocation || 'N/A') + '</span>' +
                                    '</div>' +
                                '</div>' +
                                '<div class="accepted-detail-item">' +
                                    '<i class="fas fa-road distance-icon"></i>' +
                                    '<div class="accepted-detail-content">' +
                                        '<strong>Distance</strong>' +
                                        '<span>' + (distance || 'N/A') + ' km</span>' +
                                    '</div>' +
                                '</div>' +
                                '<div class="accepted-detail-item">' +
                                    '<i class="fas fa-money-bill-wave price-icon"></i>' +
                                    '<div class="accepted-detail-content">' +
                                        '<strong>Price</strong>' +
                                        '<span>' + price + '</span>' +
                                    '</div>' +
                                '</div>' +
                                '<div class="accepted-detail-item">' +
                                    '<i class="fas fa-car vehicle-icon"></i>' +
                                    '<div class="accepted-detail-content">' +
                                        '<strong>Vehicle Type</strong>' +
                                        '<span>' + (vehicleType || 'N/A') + '</span>' +
                                    '</div>' +
                                '</div>' +
                                '<div class="accepted-detail-item">' +
                                    '<i class="fas fa-calendar-alt status-icon"></i>' +
                                    '<div class="accepted-detail-content">' +
                                        '<strong>Booking Time</strong>' +
                                        '<span>' + bookingDate + '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<div class="accepted-trip-actions">' +
                                '<h5><i class="fas fa-tasks"></i> Available Actions</h5>' +
                                '<div class="status-buttons">' +
                                    generateTripActionButtons(tripId, status) +
                                '</div>' +
                            '</div>';

                        container.appendChild(tripCard);
                        processedCount++;
                    });
                    
                    console.log("Successfully processed", processedCount, "out of", data.length, "accepted trips");
                } else {
                    container.innerHTML = '<div class="no-accepted-trips-message">' +
                        '<i class="fas fa-check-circle"></i>' +
                        '<p>You currently have no accepted trips.</p>' +
                        '<p>Accept ride requests to see them here.</p>' +
                        '</div>';
                }
            })
            .catch(function(err) {
                console.error('Error fetching accepted trips:', err);
                debugLog("Error: " + err.message);
                document.getElementById('accepted-trips').innerHTML =
                    '<div class="error-message">' +
                    '<p>Error loading accepted trips: ' + err.message + '</p>' +
                    '<p>Check console for more details.</p>' +
                    '</div>';
            });
    }

    // Initial load and periodic refresh
    document.addEventListener('DOMContentLoaded', function() {
        debugLog("Dashboard initialized");
        console.log("Dashboard DOM loaded, initializing...");
        fetchNotifications();
        fetchPendingRequests();
        fetchCurrentTrip();
        fetchActiveTripCount(); // Load active trip count
        
        // Add a small delay to ensure all elements are ready
        setTimeout(function() {
            console.log("Calling fetchAcceptedTrips...");
            fetchAcceptedTrips(); // Load accepted trips on page load
        }, 100);
        
        setInterval(fetchNotifications, 10000); // Check notifications every 10 seconds
        setInterval(fetchPendingRequests, 30000);
        setInterval(fetchCurrentTrip, 30000); // Also refresh current trip
        setInterval(fetchAcceptedTrips, 30000); // Refresh accepted trips every 30 seconds
        setInterval(fetchActiveTripCount, 30000); // Refresh active trip count every 30 seconds
    });

    // Add CSS animations for notifications
    var style = document.createElement('style');
    style.textContent = `
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
        
        .status-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        
        .status-buttons .btn {
            flex: 1;
            min-width: 120px;
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .status-buttons .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .text-muted {
            color: #6c757d;
            font-style: italic;
            padding: 10px;
            text-align: center;
        }
        
        /* Incident Modal Styles */
        .incident-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .incident-modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: none;
            border-radius: 10px;
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow-y: auto;
        }
        
        .incident-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e74c3c;
        }
        
        .incident-modal-header h3 {
            color: #e74c3c;
            margin: 0;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #e74c3c;
        }
        
        .incident-form-group {
            margin-bottom: 15px;
        }
        
        .incident-form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .incident-form-group input,
        .incident-form-group select,
        .incident-form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .incident-form-group textarea {
            height: 100px;
            resize: vertical;
        }
        
        .incident-form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .incident-form-actions button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }
        
        .btn-submit {
            background-color: #e74c3c;
            color: white;
        }
        
        .btn-submit:hover {
            background-color: #c0392b;
        }
        
        .btn-cancel {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-cancel:hover {
            background-color: #5a6268;
        }
        
        .location-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        
        .severity-indicator {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            margin-left: 5px;
        }
        
        .severity-low { background-color: #d4edda; color: #155724; }
        .severity-medium { background-color: #fff3cd; color: #856404; }
        .severity-high { background-color: #f8d7da; color: #721c24; }
        .severity-critical { background-color: #f5c6cb; color: #721c24; }
    `;
    document.head.appendChild(style);
</script>

<!-- Incident Reporting Modal -->
<div id="incidentModal" class="incident-modal">
    <div class="incident-modal-content">
        <div class="incident-modal-header">
            <h3><i class="fas fa-exclamation-triangle"></i> Report Incident</h3>
            <span class="close" onclick="closeIncidentModal()">&times;</span>
        </div>
        <form id="incidentForm">
            <input type="hidden" id="incidentTripId" name="tripId">
            
            <div class="incident-form-group">
                <label for="incidentType">Incident Type *</label>
                <select id="incidentType" name="incidentType" required>
                    <option value="">Select incident type</option>
                    <option value="Breakdown">Vehicle Breakdown</option>
                    <option value="Accident">Accident</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            
            <div class="incident-form-group">
                <label for="severity">Severity Level *</label>
                <select id="severity" name="severity" required>
                    <option value="">Select severity</option>
                    <option value="Low">Low - Minor issue</option>
                    <option value="Medium">Medium - Moderate issue</option>
                    <option value="High">High - Serious issue</option>
                    <option value="Critical">Critical - Emergency</option>
                </select>
            </div>
            
            <div class="incident-form-group">
                <label for="location">Location *</label>
                <input type="text" id="location" name="location" placeholder="Enter current location" required>
            </div>
            
            <div class="incident-form-group">
                <label>Coordinates</label>
                <div class="location-inputs">
                    <input type="number" id="latitude" name="latitude" placeholder="Latitude" step="any" required>
                    <input type="number" id="longitude" name="longitude" placeholder="Longitude" step="any" required>
                </div>
            </div>
            
            <div class="incident-form-group">
                <label for="description">Description *</label>
                <textarea id="description" name="description" placeholder="Describe the incident in detail..." required></textarea>
            </div>
            
            <div class="incident-form-actions">
                <button type="button" class="btn-cancel" onclick="closeIncidentModal()">Cancel</button>
                <button type="submit" class="btn-submit">Report Incident</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Incident reporting functions
    function openIncidentModal(tripId) {
        document.getElementById('incidentTripId').value = tripId;
        document.getElementById('incidentModal').style.display = 'block';
        
        // Get current location if available
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                document.getElementById('latitude').value = position.coords.latitude;
                document.getElementById('longitude').value = position.coords.longitude;
            }, function(error) {
                console.log('Geolocation error:', error);
            });
        }
    }
    
    function closeIncidentModal() {
        document.getElementById('incidentModal').style.display = 'none';
        document.getElementById('incidentForm').reset();
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
        var modal = document.getElementById('incidentModal');
        if (event.target == modal) {
            closeIncidentModal();
        }
    }
    
    // Handle incident form submission
    document.getElementById('incidentForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        var formData = new FormData(this);
        var incidentData = {
            action: 'createIncident',
            tripId: formData.get('tripId'),
            incidentType: formData.get('incidentType'),
            description: formData.get('description'),
            location: formData.get('location'),
            latitude: parseFloat(formData.get('latitude')),
            longitude: parseFloat(formData.get('longitude')),
            severity: formData.get('severity')
        };
        
        // Validate required fields
        if (!incidentData.incidentType || !incidentData.description || !incidentData.location || 
            !incidentData.latitude || !incidentData.longitude || !incidentData.severity) {
            alert('Please fill in all required fields.');
            return;
        }
        
        // Validate coordinate ranges
        if (incidentData.latitude < -90 || incidentData.latitude > 90) {
            alert('Latitude must be between -90 and 90 degrees.');
            return;
        }
        if (incidentData.longitude < -180 || incidentData.longitude > 180) {
            alert('Longitude must be between -180 and 180 degrees.');
            return;
        }
        
        // Round coordinates to 8 decimal places to fit database precision
        incidentData.latitude = Math.round(incidentData.latitude * 100000000) / 100000000;
        incidentData.longitude = Math.round(incidentData.longitude * 100000000) / 100000000;
        
        // Submit incident report
        fetch(getContextPath() + '/IncidentServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams(incidentData)
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.status);
            }
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                alert('Incident reported successfully! Incident ID: ' + data.incidentId);
                closeIncidentModal();
                // Refresh the current trip display
                fetchCurrentTrip();
            } else {
                alert('Failed to report incident: ' + (data.message || 'Unknown error'));
            }
        })
        .catch(function(error) {
            console.error('Error reporting incident:', error);
            alert('Error reporting incident. Please try again.');
        });
    });
</script>

</body>
</html>
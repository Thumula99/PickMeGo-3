<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ride Status</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Enhanced customer theme with vibrant black, green, and ash colors */
        .customer-theme {
            /* Vibrant Green Colors */
            --primary: #00cc7a; /* Bright emerald green */
            --primary-dark: #009e5e; /* Deep forest green */
            --primary-light: #33ff99; /* Neon lime green */
            --primary-darker: #006633; /* Darker green for depth */

            /* Refined Ash/Gray Colors */
            --ash-light: #f1eeee; /* Softer light gray */
            --ash-medium: #d1d5db; /* Neutral mid-gray */
            --ash-dark: #6b7280; /* Cool slate gray */
            --ash-darker: #4b5563; /* Deep charcoal gray */

            /* Rich Black Colors */
            --black-light: #1f2937; /* Soft black with blue undertone */
            --black-medium: #111827; /* Deep midnight black */
            --black-dark: #0a0e17; /* Near-black for depth */
            --black-darker: #030712; /* Pure black for accents */

            /* Complementary Accent Colors */
            --accent: #00cc7a; /* Matches primary green */
            --accent-dark: #009e5e; /* Darker accent green */
            --accent-light: #33ff99; /* Light accent for highlights */
            --secondary-accent: #facc15; /* Warm yellow for contrast */
            --secondary-accent-dark: #ca9e12; /* Darker yellow */
            --tertiary-accent: #1f2937; /* Matches black-light */
            --tertiary-accent-dark: #111827; /* Matches black-medium */
            --warm-accent: #facc15; /* Warm yellow for buttons */
            --warm-accent-dark: #ca9e12; /* Darker yellow for hover */

            /* Set background to light ash */
            background: var(--ash-light);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--ash-light);
            color: var(--black-light);
            padding: 20px;
            margin: 0;
        }
        .container {
            max-width: 800px;
            margin: auto;
        }
        .card {
            background: var(--ash-light);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid var(--ash-medium);
        }
        h1 {
            color: var(--primary);
            margin-bottom: 20px;
            font-weight: 700;
        }
        .status-icon {
            font-size: 4em;
            margin-bottom: 20px;
        }
        .status-icon.searching {
            color: var(--secondary-accent);
            animation: pulse 2s infinite;
        }
        .status-icon.accepted {
            color: var(--primary);
        }
        .status-icon.on-the-way {
            color: var(--primary-light);
            animation: pulse 2s infinite;
        }
        .status-icon.arrived {
            color: var(--secondary-accent);
        }
        .status-icon.completed {
            color: var(--primary-dark);
        }
        .status-icon.rejected {
            color: #e11d48;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        .status-message {
            font-size: 1.3em;
            margin: 20px 0;
            padding: 15px;
            border-radius: 8px;
        }
        .status-message.searching {
            background-color: rgba(250, 204, 21, 0.15);
            color: var(--secondary-accent-dark);
        }
        .status-message.accepted {
            background-color: rgba(0, 204, 122, 0.15);
            color: var(--primary-dark);
        }
        .status-message.on-the-way {
            background-color: rgba(51, 255, 153, 0.15);
            color: var(--primary-dark);
        }
        .status-message.arrived {
            background-color: rgba(250, 204, 21, 0.15);
            color: var(--secondary-accent-dark);
        }
        .status-message.completed {
            background-color: rgba(0, 158, 94, 0.15);
            color: var(--primary-darker);
        }
        .status-message.rejected {
            background-color: rgba(225, 29, 72, 0.15);
            color: #e11d48;
        }
        .trip-details {
            background-color: var(--ash-light);
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: left;
            border: 1px solid var(--ash-medium);
        }
        .trip-details h3 {
            margin-top: 0;
            color: var(--black-light);
        }
        .trip-details p {
            margin: 10px 0;
            color: var(--ash-darker);
        }
        
        .driver-details {
            background-color: rgba(0, 204, 122, 0.1);
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: left;
            border-left: 4px solid var(--primary);
        }
        .driver-details h3 {
            margin-top: 0;
            color: var(--black-light);
        }
        
        .driver-info-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 15px;
            background: var(--ash-light);
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border: 1px solid var(--ash-medium);
        }
        
        .driver-info-item i {
            font-size: 1.3em;
            margin-right: 15px;
            color: var(--primary);
            width: 25px;
        }
        
        .driver-info-item .info-content {
            flex: 1;
        }
        
        .driver-info-item .info-label {
            font-weight: bold;
            color: var(--black-light);
            margin-bottom: 5px;
        }
        
        .driver-info-item .info-value {
            color: var(--ash-darker);
            font-size: 0.95em;
        }
        .notification-item {
            background-color: rgba(51, 255, 153, 0.1);
            border-left: 4px solid var(--primary-light);
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: left;
        }
        .notification-item.accepted {
            background-color: rgba(0, 204, 122, 0.15);
            border-left-color: var(--primary);
        }
        .notification-item.on-the-way {
            background-color: rgba(51, 255, 153, 0.15);
            border-left-color: var(--primary-light);
        }
        .notification-item.arrived {
            background-color: rgba(250, 204, 21, 0.15);
            border-left-color: var(--secondary-accent);
        }
        .notification-item.completed {
            background-color: rgba(0, 158, 94, 0.15);
            border-left-color: var(--primary-dark);
        }
        .notification-item.cancelled {
            background-color: rgba(225, 29, 72, 0.15);
            border-left-color: #e11d48;
        }
        .notification-item.rejected {
            background-color: rgba(225, 29, 72, 0.15);
            border-left-color: #e11d48;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            margin: 10px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0, 204, 122, 0.3);
        }
        .btn:hover {
            background: linear-gradient(90deg, var(--primary-dark) 0%, var(--primary-darker) 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 204, 122, 0.4);
        }
        .btn-danger {
            background: linear-gradient(90deg, #e11d48 0%, #be123c 100%);
            box-shadow: 0 4px 15px rgba(225, 29, 72, 0.3);
        }
        .btn-danger:hover {
            background: linear-gradient(90deg, #be123c 0%, #9f1239 100%);
            box-shadow: 0 8px 25px rgba(225, 29, 72, 0.4);
        }
        .btn-warning {
            background: linear-gradient(90deg, var(--secondary-accent) 0%, var(--secondary-accent-dark) 100%);
            box-shadow: 0 4px 15px rgba(250, 204, 21, 0.3);
        }
        .btn-warning:hover {
            background: linear-gradient(90deg, var(--secondary-accent-dark) 0%, #a16207 100%);
            box-shadow: 0 8px 25px rgba(250, 204, 21, 0.4);
        }
        .btn-group {
            margin: 20px 0;
            text-align: center;
        }
        .loading-spinner {
            border: 4px solid var(--ash-medium);
            border-top: 4px solid var(--primary);
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body class="customer-theme">
<div class="container">
    <div class="card">
        <h1><i class="fas fa-car"></i> Ride Status</h1>
        
        <!-- Searching State -->
        <div id="searching-state">
            <div class="status-icon searching">
                <i class="fas fa-search"></i>
            </div>
            <div class="status-message searching">
                <i class="fas fa-spinner fa-spin"></i> Searching for a driver...
            </div>
            <p>We're looking for drivers with your preferred vehicle type.</p>
            <div class="loading-spinner"></div>
        </div>
        
        <!-- Accepted State -->
        <div id="accepted-state" class="hidden">
            <div class="status-icon accepted">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="status-message accepted">
                <i class="fas fa-check"></i> Driver Found!
            </div>
            <p>Your ride has been accepted. Your driver will arrive shortly.</p>
        </div>
        
        <!-- On The Way State -->
        <div id="on-the-way-state" class="hidden">
            <div class="status-icon on-the-way">
                <i class="fas fa-car"></i>
            </div>
            <div class="status-message on-the-way">
                <i class="fas fa-route"></i> Driver On The Way!
            </div>
            <p>Your driver is heading to your pickup location.</p>
        </div>
        
        <!-- Arrived State -->
        <div id="arrived-state" class="hidden">
            <div class="status-icon arrived">
                <i class="fas fa-map-marker-alt"></i>
            </div>
            <div class="status-message arrived">
                <i class="fas fa-flag-checkered"></i> Driver Arrived!
            </div>
            <p>Your driver has arrived at your pickup location.</p>
        </div>
        
        <!-- Completed State -->
        <div id="completed-state" class="hidden">
            <div class="status-icon completed">
                <i class="fas fa-check-double"></i>
            </div>
            <div class="status-message completed">
                <i class="fas fa-star"></i> Trip Completed!
            </div>
            <p>Your trip has been completed successfully. Thank you for using PickMeGo!</p>
        </div>
        
        <!-- Rejected State -->
        <div id="rejected-state" class="hidden">
            <div class="status-icon rejected">
                <i class="fas fa-times-circle"></i>
            </div>
            <div class="status-message rejected">
                <i class="fas fa-exclamation-triangle"></i> Driver Declined
            </div>
            <p>Your ride request was declined. We're searching for another driver.</p>
        </div>
        
        <!-- Trip Details -->
        <div id="trip-details" class="trip-details hidden">
            <h3><i class="fas fa-route"></i> Trip Details</h3>
            <div id="trip-info"></div>
        </div>
        
        <!-- Driver Details -->
        <div id="driver-details" class="driver-details hidden">
            <h3><i class="fas fa-user"></i> Driver Details</h3>
            <div id="driver-info"></div>
        </div>
        
        <!-- Notifications -->
        <div id="notifications-section" class="hidden">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h3 style="margin: 0;"><i class="fas fa-bell"></i> Recent Updates</h3>
                <button id="clear-notifications-btn" class="btn btn-danger" onclick="clearAllNotifications()" style="padding: 8px 16px; font-size: 0.9em;">
                    <i class="fas fa-trash"></i> Clear All
                </button>
            </div>
            <div id="notifications"></div>
        </div>
        
        <!-- Action Buttons -->
        <div id="action-buttons" class="btn-group hidden">
            <button id="update-trip-btn" class="btn btn-warning" onclick="toggleUpdateForm()">
                <i class="fas fa-edit"></i> Update Locations
            </button>
            <button id="cancel-trip-btn" class="btn btn-danger" onclick="cancelTrip()">
                <i class="fas fa-times"></i> Cancel Trip
            </button>
        </div>
        
        <!-- Inline Update Form -->
        <div id="update-form-section" class="hidden">
            <div class="card">
                <h3><i class="fas fa-edit"></i> Update Trip Locations</h3>
                <form id="update-form">
                    <div class="form-group">
                        <label for="update-pickup"><i class="fas fa-map-marker-alt"></i> Pickup Location:</label>
                        <input type="text" id="update-pickup" name="pickupLocation" placeholder="Enter new pickup location" required>
                    </div>
                    <div class="form-group">
                        <label for="update-dropoff"><i class="fas fa-flag-checkered"></i> Drop-off Location:</label>
                        <input type="text" id="update-dropoff" name="dropoffLocation" placeholder="Enter new drop-off location" required>
                    </div>
                    <!-- Hidden fields for coordinates -->
                    <input type="hidden" id="update-pickup-lat" name="pickupLat">
                    <input type="hidden" id="update-pickup-lng" name="pickupLng">
                    <input type="hidden" id="update-dropoff-lat" name="dropoffLat">
                    <input type="hidden" id="update-dropoff-lng" name="dropoffLng">
                    <div class="form-group">
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-save"></i> Update Trip
                        </button>
                        <button type="button" class="btn" onclick="toggleUpdateForm()">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <a href="dashboard.jsp" class="btn">
            <i class="fas fa-home"></i> Go to Dashboard
        </a>
    </div>
</div>

<style>
.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: var(--black-light);
}

.form-group input {
    width: 100%;
    padding: 10px;
    border: 1px solid var(--ash-medium);
    border-radius: 8px;
    font-size: 16px;
    background: var(--ash-light);
    color: var(--black-light);
}

.form-group input:focus {
    outline: none;
    border-color: var(--primary);
    box-shadow: 0 0 5px rgba(0, 204, 122, 0.3);
}
</style>

<script>
    // Function to get context path correctly
    function getContextPath() {
        return "${pageContext.request.contextPath}";
    }
    
    // Function to fetch current trip with driver details
    function fetchCurrentTrip() {
        fetch(getContextPath() + '/CustomerServlet?action=getCurrentTrip')
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                console.log('Current trip data:', data);
                
                // Store trip data globally
                currentTripData = data;
                
                if (data.trip) {
                    // Update trip details
                    updateTripDetails(data.trip);
                    
                    // Show/hide driver details based on whether driver is assigned
                    if (data.hasDriver && data.driver) {
                        updateDriverDetails(data.driver);
                        document.getElementById('driver-details').classList.remove('hidden');
                    } else {
                        document.getElementById('driver-details').classList.add('hidden');
                    }
                    
                    // Update status based on trip status
                    updateTripStatus(data.trip.status || data.trip.TripStatus);
                } else {
                    // No current trip
                    document.getElementById('trip-details').classList.add('hidden');
                    document.getElementById('driver-details').classList.add('hidden');
                    document.getElementById('action-buttons').classList.add('hidden');
                }
            })
            .catch(function(err) {
                console.error('Error fetching current trip:', err);
            });
    }
    
    // Function to update trip details display
    function updateTripDetails(trip) {
        var tripInfo = document.getElementById('trip-info');
        var pickupLocation = trip.PickupLocation || trip.pickupLocation || 'N/A';
        var dropoffLocation = trip.DropOffLocation || trip.dropoffLocation || 'N/A';
        var distance = trip.distance || 'N/A';
        var vehicleType = trip.vehicle_type || trip.vehicleType || 'N/A';
        var price = trip.price ? 'LKR ' + parseFloat(trip.price).toFixed(2) : 'N/A';
        
        tripInfo.innerHTML = 
            '<p><strong>Pickup Location:</strong> ' + pickupLocation + '</p>' +
            '<p><strong>Drop-off Location:</strong> ' + dropoffLocation + '</p>' +
            '<p><strong>Distance:</strong> ' + distance + '</p>' +
            '<p><strong>Vehicle Type:</strong> ' + vehicleType + '</p>' +
            '<p><strong>Price:</strong> ' + price + '</p>';
    }
    
    // Function to update driver details display
    function updateDriverDetails(driver) {
        var driverInfo = document.getElementById('driver-info');
        var firstName = driver.FirstName || driver.firstName || 'N/A';
        var lastName = driver.LastName || driver.lastName || 'N/A';
        var email = driver.Email || driver.email || 'N/A';
        var phone = driver.PhoneNumber || driver.phoneNumber || 'N/A';
        var vehicleType = driver.VehicleType || driver.vehicleType || 'N/A';
        
        driverInfo.innerHTML = 
            '<div class="driver-info-item">' +
                '<i class="fas fa-user"></i>' +
                '<div class="info-content">' +
                    '<div class="info-label">Driver Name</div>' +
                    '<div class="info-value">' + firstName + ' ' + lastName + '</div>' +
                '</div>' +
            '</div>' +
            '<div class="driver-info-item">' +
                '<i class="fas fa-envelope"></i>' +
                '<div class="info-content">' +
                    '<div class="info-label">Email</div>' +
                    '<div class="info-value">' + email + '</div>' +
                '</div>' +
            '</div>' +
            '<div class="driver-info-item">' +
                '<i class="fas fa-phone"></i>' +
                '<div class="info-content">' +
                    '<div class="info-label">Phone Number</div>' +
                    '<div class="info-value">' + phone + '</div>' +
                '</div>' +
            '</div>' +
            '<div class="driver-info-item">' +
                '<i class="fas fa-car"></i>' +
                '<div class="info-content">' +
                    '<div class="info-label">Vehicle Type</div>' +
                    '<div class="info-value">' + vehicleType + '</div>' +
                '</div>' +
            '</div>';
    }
    
    // Function to update trip status display
    function updateTripStatus(status) {
        // Hide all states first
        document.getElementById('searching-state').classList.add('hidden');
        document.getElementById('accepted-state').classList.add('hidden');
        document.getElementById('on-the-way-state').classList.add('hidden');
        document.getElementById('arrived-state').classList.add('hidden');
        document.getElementById('completed-state').classList.add('hidden');
        document.getElementById('rejected-state').classList.add('hidden');
        
        // Show/hide action buttons based on status
        var actionButtons = document.getElementById('action-buttons');
        if (status === 'Pending' || status === 'Accepted') {
            actionButtons.classList.remove('hidden');
        } else {
            actionButtons.classList.add('hidden');
        }
        
        // Show appropriate state based on status
        switch(status) {
            case 'Pending':
                document.getElementById('searching-state').classList.remove('hidden');
                break;
            case 'Accepted':
                document.getElementById('accepted-state').classList.remove('hidden');
                document.getElementById('trip-details').classList.remove('hidden');
                break;
            case 'InProgress':
            case 'Started':
            case 'Active':
            case 'On The Way':
                document.getElementById('on-the-way-state').classList.remove('hidden');
                document.getElementById('trip-details').classList.remove('hidden');
                break;
            case 'Arrived':
                document.getElementById('arrived-state').classList.remove('hidden');
                document.getElementById('trip-details').classList.remove('hidden');
                break;
            case 'Completed':
                document.getElementById('completed-state').classList.remove('hidden');
                document.getElementById('trip-details').classList.remove('hidden');
                break;
            case 'Cancelled':
                showCancelledState();
                break;
            case 'Rejected':
                document.getElementById('rejected-state').classList.remove('hidden');
                break;
            default:
                document.getElementById('searching-state').classList.remove('hidden');
        }
    }
    
    // Function to fetch notifications
    function fetchNotifications() {
        fetch(getContextPath() + '/NotificationServlet?action=getUnreadNotifications')
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                var notificationsContainer = document.getElementById('notifications');
                var notificationsSection = document.getElementById('notifications-section');
                
                if (data && data.length > 0) {
                    notificationsSection.classList.remove('hidden');
                    notificationsContainer.innerHTML = '';
                    
                    data.forEach(function(notification) {
                        // Handle different possible property names (including JSON serialized names)
                        var notificationType = notification.NotificationType || notification.notificationType;
                        var message = notification.Message || notification.message;
                        var createdTime = notification.CreatedDate || notification.createdTime;
                        
                        var notificationDiv = document.createElement('div');
                        notificationDiv.className = 'notification-item';
                        
                        // Handle different notification types
                        if (notificationType === 'RIDE_ACCEPTED') {
                            notificationDiv.classList.add('accepted');
                            showAcceptedState();
                        } else if (notificationType === 'RIDE_REJECTED') {
                            notificationDiv.classList.add('rejected');
                            showRejectedState();
                        } else if (notificationType === 'DRIVER_ON_THE_WAY') {
                            notificationDiv.classList.add('on-the-way');
                            showOnTheWayState();
                        } else if (notificationType === 'DRIVER_ARRIVED') {
                            notificationDiv.classList.add('arrived');
                            showArrivedState();
                        } else if (notificationType === 'TRIP_COMPLETED') {
                            notificationDiv.classList.add('completed');
                            showCompletedState();
                        } else if (notificationType === 'TRIP_CANCELLED') {
                            notificationDiv.classList.add('cancelled');
                            showCancelledState();
                        }
                        
                        var displayType = (notificationType || 'Unknown').replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
                        
                        var formattedDate = 'N/A';
                        if (createdTime) {
                            try {
                                var date = new Date(createdTime);
                                if (isNaN(date.getTime())) {
                                    formattedDate = 'Invalid Date';
                                } else {
                                    formattedDate = date.toLocaleString();
                                }
                            } catch (e) {
                                formattedDate = 'Invalid Date';
                            }
                        }
                        
                        notificationDiv.innerHTML = 
                            '<p><strong>' + displayType + '</strong></p>' +
                            '<p>' + (message || 'No message') + '</p>' +
                            '<p><small>' + formattedDate + '</small></p>';
                        
                        notificationsContainer.appendChild(notificationDiv);
                    });
                } else {
                    // No notifications, hide the section
                    notificationsSection.classList.add('hidden');
                }
            })
            .catch(function(err) {
                console.error('Error fetching notifications:', err);
            });
    }
    
    // Function to clear all notifications
    function clearAllNotifications() {
        if (!confirm('Are you sure you want to clear all notifications?')) {
            return;
        }
        
        fetch(getContextPath() + '/NotificationServlet?action=markAllAsRead', {
            method: 'GET'
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.status);
            }
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                // Clear the notifications display
                var notificationsContainer = document.getElementById('notifications');
                var notificationsSection = document.getElementById('notifications-section');
                
                notificationsContainer.innerHTML = '';
                notificationsSection.classList.add('hidden');
                
                // Show success message
                alert('All notifications have been cleared successfully!');
            } else {
                alert('Failed to clear notifications. Please try again.');
            }
        })
        .catch(function(err) {
            console.error('Error clearing notifications:', err);
            alert('An error occurred while clearing notifications. Please try again.');
        });
    }
    
    // Function to show accepted state
    function showAcceptedState() {
        document.getElementById('searching-state').classList.add('hidden');
        document.getElementById('rejected-state').classList.add('hidden');
        document.getElementById('on-the-way-state').classList.add('hidden');
        document.getElementById('arrived-state').classList.add('hidden');
        document.getElementById('completed-state').classList.add('hidden');
        document.getElementById('accepted-state').classList.remove('hidden');
        document.getElementById('trip-details').classList.remove('hidden');
        // Don't show driver details here as it will be handled by fetchCurrentTrip
    }
    
    // Function to show rejected state
    function showRejectedState() {
        document.getElementById('searching-state').classList.add('hidden');
        document.getElementById('accepted-state').classList.add('hidden');
        document.getElementById('on-the-way-state').classList.add('hidden');
        document.getElementById('arrived-state').classList.add('hidden');
        document.getElementById('completed-state').classList.add('hidden');
        document.getElementById('rejected-state').classList.remove('hidden');
    }
    
    // Function to show on the way state
    function showOnTheWayState() {
        document.getElementById('searching-state').classList.add('hidden');
        document.getElementById('accepted-state').classList.add('hidden');
        document.getElementById('arrived-state').classList.add('hidden');
        document.getElementById('completed-state').classList.add('hidden');
        document.getElementById('rejected-state').classList.add('hidden');
        document.getElementById('on-the-way-state').classList.remove('hidden');
        document.getElementById('trip-details').classList.remove('hidden');
    }
    
    // Function to show arrived state
    function showArrivedState() {
        document.getElementById('searching-state').classList.add('hidden');
        document.getElementById('accepted-state').classList.add('hidden');
        document.getElementById('on-the-way-state').classList.add('hidden');
        document.getElementById('completed-state').classList.add('hidden');
        document.getElementById('rejected-state').classList.add('hidden');
        document.getElementById('arrived-state').classList.remove('hidden');
        document.getElementById('trip-details').classList.remove('hidden');
    }
    
    // Function to show completed state
    function showCompletedState() {
        document.getElementById('searching-state').classList.add('hidden');
        document.getElementById('accepted-state').classList.add('hidden');
        document.getElementById('on-the-way-state').classList.add('hidden');
        document.getElementById('arrived-state').classList.add('hidden');
        document.getElementById('rejected-state').classList.add('hidden');
        document.getElementById('completed-state').classList.remove('hidden');
        document.getElementById('trip-details').classList.remove('hidden');
    }
    
    // Function to show cancelled state
    function showCancelledState() {
        document.getElementById('searching-state').classList.add('hidden');
        document.getElementById('accepted-state').classList.add('hidden');
        document.getElementById('on-the-way-state').classList.add('hidden');
        document.getElementById('arrived-state').classList.add('hidden');
        document.getElementById('completed-state').classList.add('hidden');
        document.getElementById('rejected-state').classList.remove('hidden');
        // Update the rejected state to show cancelled message
        document.getElementById('rejected-state').innerHTML = 
            '<div class="status-icon rejected">' +
                '<i class="fas fa-times-circle"></i>' +
            '</div>' +
            '<div class="status-message rejected">' +
                '<i class="fas fa-exclamation-triangle"></i> Trip Cancelled' +
            '</div>' +
            '<p>Your trip has been cancelled. We apologize for the inconvenience.</p>';
    }
    
    // Function to load trip details from session
    function loadTripDetails() {
        // This would typically come from the session or a separate API call
        var tripInfo = document.getElementById('trip-info');
        tripInfo.innerHTML = 
            '<p><strong>Pickup Location:</strong> ${sessionScope.currentTrip.pickupLocation}</p>' +
            '<p><strong>Drop-off Location:</strong> ${sessionScope.currentTrip.dropoffLocation}</p>' +
            '<p><strong>Distance:</strong> ${sessionScope.currentTrip.distance} km</p>' +
            '<p><strong>Vehicle Type:</strong> ${sessionScope.currentTrip.vehicleType}</p>' +
            '<p><strong>Price:</strong> LKR ${sessionScope.currentTrip.price}</p>';
    }
    
    // Global variable to store current trip
    var currentTripData = null;
    
    // Function to cancel trip
    function cancelTrip() {
        if (!currentTripData || !currentTripData.trip) {
            alert('No trip data available');
            return;
        }
        
        if (!confirm('Are you sure you want to cancel this trip?')) {
            return;
        }
        
        var tripId = currentTripData.trip.TripID || currentTripData.trip.tripId;
        
        fetch(getContextPath() + '/CustomerServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=cancelTrip&tripId=' + tripId
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                alert('Trip cancelled successfully');
                // Refresh the page to show updated status
                location.reload();
            } else {
                alert('Error: ' + (data.error || 'Failed to cancel trip'));
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            alert('An error occurred while cancelling the trip');
        });
    }
    
    // Handle update form submission
    document.getElementById('update-form').addEventListener('submit', function(e) {
        e.preventDefault();
        
        if (!currentTripData || !currentTripData.trip) {
            alert('No trip data available');
            return;
        }
        
        // Validate that locations are selected from autocomplete
        var pickupLat = document.getElementById('update-pickup-lat').value;
        var pickupLng = document.getElementById('update-pickup-lng').value;
        var dropoffLat = document.getElementById('update-dropoff-lat').value;
        var dropoffLng = document.getElementById('update-dropoff-lng').value;
        
        // Debug logging
        console.log('Form validation - Pickup Lat:', pickupLat, 'Lng:', pickupLng);
        console.log('Form validation - Dropoff Lat:', dropoffLat, 'Lng:', dropoffLng);
        console.log('Pickup input value:', document.getElementById('update-pickup').value);
        console.log('Dropoff input value:', document.getElementById('update-dropoff').value);
        
        if (!pickupLat || !pickupLng || !dropoffLat || !dropoffLng) {
            alert('Please select valid locations from the dropdown suggestions for both pickup and drop-off locations.\n\nDebug info:\nPickup: ' + pickupLat + ',' + pickupLng + '\nDropoff: ' + dropoffLat + ',' + dropoffLng);
            return;
        }
        
        var tripId = currentTripData.trip.TripID || currentTripData.trip.tripId;
        var formData = new FormData(this);
        formData.append('action', 'updateTrip');
        formData.append('tripId', tripId);
        
        // Use actual coordinates from Google Places API
        formData.append('pickupLat', pickupLat);
        formData.append('pickupLng', pickupLng);
        formData.append('dropoffLat', dropoffLat);
        formData.append('dropoffLng', dropoffLng);
        
        fetch(getContextPath() + '/CustomerServlet', {
            method: 'POST',
            body: formData
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                alert('Trip updated successfully! Distance and price have been automatically calculated.');
                toggleUpdateForm(); // Hide the form
                // Refresh the page to show updated data
                location.reload();
            } else {
                alert('Error: ' + (data.error || 'Failed to update trip'));
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            alert('An error occurred while updating the trip');
        });
    });
    
    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        // Fetch current trip with driver details
        fetchCurrentTrip();
        fetchNotifications();
        
        // Check for updates every 5 seconds
        setInterval(fetchCurrentTrip, 5000);
        setInterval(fetchNotifications, 5000);
    });
</script>

<!-- Google Maps API with Places library -->
<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDIjP4YwT_snNdKDYrCTzXhGVrtuAJdac8&libraries=places,geocoding"></script>

<script>
    // Google Places API functionality for update form
    let updatePickupAutocomplete, updateDropoffAutocomplete;
    
    // Function to initialize Google Places Autocomplete for update form
    function initializeUpdateFormAutocomplete() {
        // Check if Google Maps API is loaded
        if (typeof google === 'undefined' || !google.maps || !google.maps.places) {
            console.log('Google Maps API not loaded yet, retrying...');
            setTimeout(initializeUpdateFormAutocomplete, 500);
            return;
        }
        
        const updatePickupInput = document.getElementById('update-pickup');
        const updateDropoffInput = document.getElementById('update-dropoff');
        
        if (updatePickupInput && updateDropoffInput) {
            console.log('Found both input elements:', updatePickupInput, updateDropoffInput);
            // Clear any existing autocomplete instances
            if (updatePickupAutocomplete) {
                google.maps.event.clearInstanceListeners(updatePickupInput);
            }
            if (updateDropoffAutocomplete) {
                google.maps.event.clearInstanceListeners(updateDropoffInput);
            }
            
            // Initialize autocomplete for pickup location
            updatePickupAutocomplete = new google.maps.places.Autocomplete(updatePickupInput, {
                types: ['establishment', 'geocode']
            });
            updatePickupAutocomplete.addListener('place_changed', function() {
                const place = updatePickupAutocomplete.getPlace();
                console.log('Pickup place_changed event triggered');
                console.log('Place object:', place);
                if (place.geometry) {
                    const lat = place.geometry.location.lat();
                    const lng = place.geometry.location.lng();
                    document.getElementById('update-pickup-lat').value = lat;
                    document.getElementById('update-pickup-lng').value = lng;
                    console.log('Pickup location updated - Lat:', lat, 'Lng:', lng, 'Address:', place.formatted_address);
                } else {
                    console.log('No geometry found for pickup place');
                }
            });
            
            // Initialize autocomplete for dropoff location
            updateDropoffAutocomplete = new google.maps.places.Autocomplete(updateDropoffInput, {
                types: ['establishment', 'geocode']
            });
            updateDropoffAutocomplete.addListener('place_changed', function() {
                const place = updateDropoffAutocomplete.getPlace();
                console.log('Dropoff place_changed event triggered');
                console.log('Dropoff Place object:', place);
                console.log('Dropoff place.geometry:', place.geometry);
                if (place.geometry) {
                    const lat = place.geometry.location.lat();
                    const lng = place.geometry.location.lng();
                    const latElement = document.getElementById('update-dropoff-lat');
                    const lngElement = document.getElementById('update-dropoff-lng');
                    console.log('Dropoff elements found:', latElement, lngElement);
                    if (latElement && lngElement) {
                        latElement.value = lat;
                        lngElement.value = lng;
                        console.log('Dropoff location updated - Lat:', lat, 'Lng:', lng, 'Address:', place.formatted_address);
                        console.log('Dropoff element values after setting:', latElement.value, lngElement.value);
                    } else {
                        console.log('Dropoff elements not found!');
                    }
                } else {
                    console.log('No geometry found for dropoff place');
                }
            });
            
            console.log('Google Places Autocomplete initialized for update form');
        } else {
            console.log('Update form inputs not found');
        }
    }
    
    // Enhanced toggleUpdateForm function to initialize autocomplete when form is shown
    function toggleUpdateForm() {
        var updateFormSection = document.getElementById('update-form-section');
        var updateBtn = document.getElementById('update-trip-btn');
        
        if (updateFormSection.classList.contains('hidden')) {
            // Show form and populate with current data
            if (!currentTripData || !currentTripData.trip) {
                alert('No trip data available');
                return;
            }
            
            var trip = currentTripData.trip;
            document.getElementById('update-pickup').value = trip.PickupLocation || trip.pickupLocation || '';
            document.getElementById('update-dropoff').value = trip.DropOffLocation || trip.dropoffLocation || '';
            
            updateFormSection.classList.remove('hidden');
            updateBtn.innerHTML = '<i class="fas fa-times"></i> Cancel Update';
            updateBtn.onclick = toggleUpdateForm;
            
            // Initialize autocomplete after form is shown
            console.log('About to initialize autocomplete in 200ms...');
            setTimeout(function() {
                console.log('Initializing autocomplete now...');
                initializeUpdateFormAutocomplete();
            }, 200);
        } else {
            // Hide form
            updateFormSection.classList.add('hidden');
            updateBtn.innerHTML = '<i class="fas fa-edit"></i> Update Locations';
            updateBtn.onclick = toggleUpdateForm;
        }
    }
</script>

</body>
</html>
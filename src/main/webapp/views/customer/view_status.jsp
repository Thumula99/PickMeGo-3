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
                <i class="fas fa-edit"></i> Update Pickup Location
            </button>
            <button id="update-tip-btn" class="btn btn-info" onclick="updateTipSimple()">
                <i class="fas fa-gift"></i> Update Tip
            </button>
            <button id="cancel-trip-btn" class="btn btn-danger" onclick="cancelTrip()">
                <i class="fas fa-times"></i> Cancel Trip
            </button>
        </div>
        
        <!-- Inline Update Form -->
        <div id="update-form-section" class="hidden">
            <div class="card">
                <h3><i class="fas fa-edit"></i> Update Pickup Location</h3>
                <form id="update-form">
                    <div class="form-group">
                        <label for="update-pickup"><i class="fas fa-map-marker-alt"></i> New Pickup Location:</label>
                        <input type="text" id="update-pickup" name="pickupLocation" placeholder="Enter new pickup location" required>
                        <small class="help-text">Start typing to see location suggestions, or enter coordinates manually below</small>
                    </div>
                    
                    <!-- Manual coordinate input as fallback -->
                    <div class="form-group">
                        <label><i class="fas fa-crosshairs"></i> Manual Coordinates (if autocomplete doesn't work):</label>
                        <div style="display: flex; gap: 10px;">
                            <input type="number" id="manual-lat" placeholder="Latitude (e.g., 6.9271)" step="0.0001" style="flex: 1;">
                            <input type="number" id="manual-lng" placeholder="Longitude (e.g., 79.8612)" step="0.0001" style="flex: 1;">
                            <button type="button" onclick="useManualCoordinates()" class="btn" style="padding: 8px 12px;">Use These</button>
                        </div>
                        <small class="help-text">Enter coordinates manually if location suggestions don't appear</small>
                    </div>
                    
                    <!-- Quick location buttons -->
                    <div class="form-group">
                        <label><i class="fas fa-map-pin"></i> Quick Locations:</label>
                        <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                            <button type="button" onclick="setQuickLocation('Colombo', 6.9271, 79.8612)" class="btn" style="padding: 5px 10px; font-size: 12px;">Colombo</button>
                            <button type="button" onclick="setQuickLocation('Kandy', 7.2906, 80.6337)" class="btn" style="padding: 5px 10px; font-size: 12px;">Kandy</button>
                            <button type="button" onclick="setQuickLocation('Galle', 6.0329, 80.2169)" class="btn" style="padding: 5px 10px; font-size: 12px;">Galle</button>
                            <button type="button" onclick="setQuickLocation('Negombo', 7.2086, 79.8358)" class="btn" style="padding: 5px 10px; font-size: 12px;">Negombo</button>
                        </div>
                        <small class="help-text">Click a location to set coordinates automatically</small>
                    </div>
                    
                    <!-- Hidden fields for coordinates (no name attributes to avoid duplicates) -->
                    <input type="hidden" id="update-pickup-lat">
                    <input type="hidden" id="update-pickup-lng">
                    <div class="form-group">
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-save"></i> Update Pickup Location
                        </button>
                        <button type="button" class="btn" onclick="toggleUpdateForm()">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Tip Update Form -->
        <div id="tip-update-section" class="hidden">
            <div class="card">
                <h3><i class="fas fa-gift"></i> Update Tip Amount</h3>
                <form id="tip-update-form">
                    <input type="hidden" name="action" value="updateTip">
                    <input type="hidden" id="tip-trip-id" name="tripId">
                    
                    <div class="form-group">
                        <label for="current-tip-display"><i class="fas fa-info-circle"></i> Current Tip:</label>
                        <div id="current-tip-display" class="tip-display">LKR 0.00</div>
                        <small class="help-text">This is your current tip amount</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="new-tip-amount"><i class="fas fa-gift"></i> New Tip Amount:</label>
                        <div class="tip-input-container">
                            <input type="number" id="new-tip-amount" name="newTip" min="0" step="0.01" placeholder="0.00" required>
                            <span class="currency">LKR</span>
                        </div>
                        <small class="help-text">Tip amount cannot be lower than current tip</small>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Tip
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="toggleTipUpdateForm()">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="button" class="btn btn-warning" onclick="testTipUpdate()">
                            <i class="fas fa-bug"></i> Test Tip Update
                        </button>
                        <button type="button" class="btn btn-danger" onclick="simpleTest()">
                            <i class="fas fa-exclamation-triangle"></i> Simple Test
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

/* Google Places Autocomplete Styles */
.pac-container {
    background-color: #fff;
    border: 1px solid #ccc;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    font-family: Arial, sans-serif;
    z-index: 9999 !important;
    margin-top: 2px;
}

.pac-item {
    padding: 10px 15px;
    border-bottom: 1px solid #eee;
    cursor: pointer;
    font-size: 14px;
}

.pac-item:hover {
    background-color: #f5f5f5;
}

.pac-item-selected {
    background-color: #e3f2fd;
}

.pac-item-query {
    font-weight: bold;
    color: #333;
}

.pac-matched {
    font-weight: bold;
    color: #1976d2;
}

/* Ensure autocomplete dropdown is visible */
#update-pickup {
    position: relative;
    z-index: 1;
}

.help-text {
    display: block;
    margin-top: 5px;
    font-size: 12px;
    color: #666;
    font-style: italic;
}

.btn {
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.btn:hover {
    background-color: #0056b3;
}

/* Tip Update Form Styles */
.tip-display {
    background-color: #e3f2fd;
    border: 2px solid #1976d2;
    border-radius: 8px;
    padding: 12px 16px;
    font-size: 18px;
    font-weight: bold;
    color: #1976d2;
    text-align: center;
    margin: 8px 0;
}

.tip-input-container {
    position: relative;
    display: flex;
    align-items: center;
}

.tip-input-container input {
    flex: 1;
    padding-right: 50px;
}

.tip-input-container .currency {
    position: absolute;
    right: 15px;
    color: #666;
    font-weight: 600;
    pointer-events: none;
}

.btn-info {
    background-color: #17a2b8;
    color: white;
    border: none;
    border-radius: 4px;
    padding: 10px 20px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.btn-info:hover {
    background-color: #138496;
}

.btn-warning {
    background-color: #ffc107;
    color: #212529;
    border: none;
    border-radius: 4px;
    padding: 10px 20px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.btn-warning:hover {
    background-color: #e0a800;
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
        var tip = trip.tip ? 'LKR ' + parseFloat(trip.tip).toFixed(2) : 'LKR 0.00';
        
        tripInfo.innerHTML = 
            '<p><strong>Pickup Location:</strong> ' + pickupLocation + '</p>' +
            '<p><strong>Drop-off Location:</strong> ' + dropoffLocation + '</p>' +
            '<p><strong>Distance:</strong> ' + distance + '</p>' +
            '<p><strong>Vehicle Type:</strong> ' + vehicleType + '</p>' +
            '<p><strong>Price:</strong> ' + price + '</p>' +
            '<p><strong>Tip:</strong> ' + tip + '</p>';
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
        
        // Validate that pickup location is selected from autocomplete
        var pickupLat = document.getElementById('update-pickup-lat').value;
        var pickupLng = document.getElementById('update-pickup-lng').value;
        
        // Debug logging
        console.log('Form validation - Pickup Lat:', pickupLat, 'Lng:', pickupLng);
        console.log('Pickup input value:', document.getElementById('update-pickup').value);
        
        if (!pickupLat || !pickupLng) {
            // Try to get coordinates using Geocoding API as fallback
            console.log('Missing pickup coordinates, attempting geocoding fallback...');
            var pickupAddress = document.getElementById('update-pickup').value;
            
            if (pickupAddress) {
                // Geocode pickup address
                geocodeAddress(pickupAddress).then(function(pickupCoords) {
                    if (pickupCoords) {
                        console.log('Geocoding successful:', pickupCoords);
                        // Update hidden fields
                        document.getElementById('update-pickup-lat').value = pickupCoords.lat;
                        document.getElementById('update-pickup-lng').value = pickupCoords.lng;
                        
                        // Continue with form submission
                        submitUpdateForm();
                    } else {
                        alert('Could not get coordinates for the entered pickup address. Please select a location from the dropdown suggestions.');
                    }
                }).catch(function(error) {
                    console.error('Geocoding error:', error);
                    alert('Error getting coordinates for pickup location. Please select a location from the dropdown suggestions.\n\nDebug info:\nPickup: ' + pickupLat + ',' + pickupLng);
                });
                return;
            } else {
                alert('Please enter a valid pickup location and select it from the dropdown suggestions.\n\nDebug info:\nPickup: ' + pickupLat + ',' + pickupLng);
                return;
            }
        }
        
        // If we have all coordinates, proceed with form submission
        submitUpdateForm();
    });
    
    // Geocoding function as fallback
    function geocodeAddress(address) {
        return new Promise(function(resolve, reject) {
            if (!window.google || !window.google.maps) {
                reject('Google Maps API not loaded');
                return;
            }
            
            var geocoder = new google.maps.Geocoder();
            geocoder.geocode({ address: address }, function(results, status) {
                if (status === 'OK' && results[0]) {
                    var location = results[0].geometry.location;
                    resolve({
                        lat: location.lat(),
                        lng: location.lng()
                    });
                } else {
                    console.error('Geocoding failed for address:', address, 'Status:', status);
                    // Instead of rejecting, try to use approximate coordinates for Sri Lanka
                    console.log('Using fallback coordinates for Sri Lanka');
                    resolve({
                        lat: 6.9271, // Colombo coordinates as fallback
                        lng: 79.8612
                    });
                }
            });
        });
    }
    
    // Separate function for form submission
    function submitUpdateForm() {
        console.log('submitUpdateForm - currentTripData:', currentTripData);
        var tripId = currentTripData.trip.TripID || currentTripData.trip.tripId;
        console.log('submitUpdateForm - tripId:', tripId);
        
        if (!tripId) {
            alert('Error: Trip ID not found. Please refresh the page and try again.');
            return;
        }
        
        var formData = new FormData(document.getElementById('update-form'));
        formData.append('action', 'updateTrip');
        formData.append('tripId', tripId);
        
        // Get coordinate values and append them (hidden fields have no name attributes)
        var pickupLat = document.getElementById('update-pickup-lat').value;
        var pickupLng = document.getElementById('update-pickup-lng').value;
        
        formData.append('pickupLat', pickupLat);
        formData.append('pickupLng', pickupLng);
        
        // Use the same coordinate values for logging
        console.log('Submitting pickup location update with coordinates:', {
            pickup: pickupLat + ',' + pickupLng
        });
        
        // Debug: Log all FormData entries
        console.log('FormData entries:');
        for (let [key, value] of formData.entries()) {
            console.log('  ' + key + ' = ' + value);
        }
        
        fetch(getContextPath() + '/CustomerServlet', {
            method: 'POST',
            body: formData
        })
        .then(function(response) {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            
            if (!response.ok) {
                throw new Error('HTTP error! status: ' + response.status);
            }
            
            // Check if response is JSON
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                throw new Error('Response is not JSON. Content-Type: ' + contentType);
            }
            
            return response.text(); // Get as text first
        })
        .then(function(text) {
            console.log('Raw response length:', text.length);
            console.log('Raw response first 200 chars:', text.substring(0, 200));
            
            // Check if response starts with HTML
            if (text.trim().startsWith('<!DOCTYPE') || text.trim().startsWith('<html')) {
                console.error('Server returned HTML instead of JSON. This usually means:');
                console.error('1. Server error occurred');
                console.error('2. Authentication issue');
                console.error('3. Servlet routing problem');
                alert('Server returned HTML instead of JSON. Please check:\n1. Server logs for errors\n2. User authentication\n3. Servlet configuration');
                return;
            }
            
            try {
                const data = JSON.parse(text);
                console.log('Parsed response:', data);
                
                if (data.success) {
                    alert('Pickup location updated successfully! Distance and price have been automatically recalculated.');
                    toggleUpdateForm(); // Hide the form
                    // Refresh the page to show updated data
                    location.reload();
                } else {
                    console.error('Server error:', data.error);
                    alert('Error: ' + (data.error || 'Failed to update pickup location'));
                }
            } catch (parseError) {
                console.error('JSON parse error:', parseError);
                console.error('Response text:', text);
                alert('Error parsing server response. Check console for details.\n\nResponse: ' + text.substring(0, 200));
            }
        })
        .catch(function(error) {
            console.error('Fetch error:', error);
            alert('An error occurred while updating the trip: ' + error.message);
        });
    }
    
    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        // Fetch current trip with driver details
        fetchCurrentTrip();
        fetchNotifications();
        
        // Attach tip update form event listener
        var tipUpdateForm = document.getElementById('tip-update-form');
        if (tipUpdateForm) {
            tipUpdateForm.addEventListener('submit', function(e) {
                e.preventDefault();
                console.log('Tip update form submitted');
                submitTipUpdateForm();
            });
            
            // Also attach click handler to submit button as backup
            var submitBtn = tipUpdateForm.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    console.log('Tip update submit button clicked');
                    submitTipUpdateForm();
                });
            }
        } else {
            console.error('Tip update form not found');
        }
        
        // Check for updates every 5 seconds
        setInterval(fetchCurrentTrip, 5000);
        setInterval(fetchNotifications, 5000);
    });
    
    // Simple tip update function
    function updateTipSimple() {
        var newTipAmount = prompt('Enter new tip amount (LKR):');
        if (newTipAmount === null) return;
        
        var newTip = parseFloat(newTipAmount);
        if (isNaN(newTip) || newTip < 0) {
            alert('Please enter a valid tip amount');
            return;
        }
        
        if (!currentTripData || !currentTripData.trip) {
            alert('No trip data available');
            return;
        }
        
        var tripId = currentTripData.trip.TripID || currentTripData.trip.tripId;
        var currentTip = parseFloat(currentTripData.trip.tip || 0);
        
        if (newTip < currentTip) {
            alert('New tip amount cannot be lower than current tip amount (LKR ' + currentTip.toFixed(2) + ')');
            return;
        }
        
        // Create simple form and submit
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = getContextPath() + '/CustomerServlet';
        
        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'updateTip';
        form.appendChild(actionInput);
        
        var tripIdInput = document.createElement('input');
        tripIdInput.type = 'hidden';
        tripIdInput.name = 'tripId';
        tripIdInput.value = tripId;
        form.appendChild(tripIdInput);
        
        var tipInput = document.createElement('input');
        tipInput.type = 'hidden';
        tipInput.name = 'newTip';
        tipInput.value = newTip;
        form.appendChild(tipInput);
        
        document.body.appendChild(form);
        
        // Add a hidden input to redirect to dashboard after update
        var redirectInput = document.createElement('input');
        redirectInput.type = 'hidden';
        redirectInput.name = 'redirect';
        redirectInput.value = 'dashboard';
        form.appendChild(redirectInput);
        
        form.submit();
    }
</script>

<!-- Google Maps API with Places library -->
<script async defer src="https://maps.googleapis.com/maps/api/js?key=----------------------8&libraries=places,geocoding"></script>

<script>
    // Google Places API functionality for update form
    let updatePickupAutocomplete;
    
    // Function to initialize Google Places Autocomplete for update form
    function initializeUpdateFormAutocomplete() {
        console.log('initializeUpdateFormAutocomplete called');
        
        // Check if Google Maps API is loaded
        if (typeof google === 'undefined' || !google.maps || !google.maps.places) {
            console.log('Google Maps API not loaded yet, retrying in 500ms...');
            setTimeout(initializeUpdateFormAutocomplete, 500);
            return;
        }
        
        console.log('Google Maps API is loaded, proceeding with autocomplete initialization');
        
        const updatePickupInput = document.getElementById('update-pickup');
        
        if (updatePickupInput) {
            console.log('Found pickup input element:', updatePickupInput);
            
            // Clear any existing autocomplete instances
            if (updatePickupAutocomplete) {
                console.log('Clearing existing autocomplete instance');
                google.maps.event.clearInstanceListeners(updatePickupInput);
            }
            
            try {
                // Initialize autocomplete for pickup location only
                updatePickupAutocomplete = new google.maps.places.Autocomplete(updatePickupInput, {
                    types: ['establishment', 'geocode'],
                    componentRestrictions: { country: 'lk' } // Restrict to Sri Lanka
                });
                
                console.log('Autocomplete instance created:', updatePickupAutocomplete);
                
                updatePickupAutocomplete.addListener('place_changed', function() {
                    const place = updatePickupAutocomplete.getPlace();
                    console.log('Pickup place_changed event triggered');
                    console.log('Place object:', place);
                    
                    if (!place || place.place_id === undefined) {
                        console.error('Invalid place object or no place selected');
                        alert('Please select a valid location from the dropdown suggestions.');
                        return;
                    }
                    
                    if (place.geometry && place.geometry.location) {
                        const lat = place.geometry.location.lat();
                        const lng = place.geometry.location.lng();
                        document.getElementById('update-pickup-lat').value = lat;
                        document.getElementById('update-pickup-lng').value = lng;
                        console.log('PICKUP COORDINATE ASSIGNMENT:');
                        console.log('  Input text: "' + updatePickupInput.value + '"');
                        console.log('  Selected place: "' + place.formatted_address + '"');
                        console.log('  Assigned coordinates: ' + lat + ', ' + lng);
                        
                        // Visual feedback
                        updatePickupInput.style.borderColor = '#28a745';
                        setTimeout(() => {
                            updatePickupInput.style.borderColor = '';
                        }, 2000);
                    } else {
                        console.error('No geometry found for pickup place');
                    }
                });
                
                console.log('Google Places Autocomplete initialized successfully for pickup location');
                
                // Add manual trigger for autocomplete
                updatePickupInput.addEventListener('input', function() {
                    console.log('Input event triggered, value:', this.value);
                    if (this.value.length > 2 && updatePickupAutocomplete) {
                        console.log('Triggering autocomplete for:', this.value);
                        // Force autocomplete to show suggestions
                        google.maps.event.trigger(updatePickupAutocomplete, 'place_changed');
                    }
                });
                
                // Add focus event to ensure autocomplete is ready
                updatePickupInput.addEventListener('focus', function() {
                    console.log('Input focused, autocomplete should be ready');
                    if (updatePickupAutocomplete) {
                        console.log('Autocomplete instance exists on focus');
                    }
                });
                
                // Test if autocomplete is working by checking if the input has the pac-container
                setTimeout(() => {
                    const pacContainer = document.querySelector('.pac-container');
                    if (pacContainer) {
                        console.log('Pac-container found, autocomplete should be working');
                    } else {
                        console.warn('Pac-container not found, autocomplete might not be working');
                        // Try to manually trigger autocomplete
                        if (updatePickupAutocomplete && updatePickupInput.value.length > 0) {
                            console.log('Attempting to manually trigger autocomplete');
                            google.maps.event.trigger(updatePickupAutocomplete, 'place_changed');
                        }
                    }
                }, 1000);
                
            } catch (error) {
                console.error('Error initializing autocomplete:', error);
                alert('Error initializing location autocomplete. Please refresh the page and try again.');
            }
        } else {
            console.error('Could not find pickup input element for autocomplete');
        }
    }
    
    // Function to use manually entered coordinates
    function useManualCoordinates() {
        const lat = document.getElementById('manual-lat').value;
        const lng = document.getElementById('manual-lng').value;
        
        if (!lat || !lng) {
            alert('Please enter both latitude and longitude values');
            return;
        }
        
        // Validate coordinate ranges
        const latNum = parseFloat(lat);
        const lngNum = parseFloat(lng);
        
        if (latNum < -90 || latNum > 90) {
            alert('Latitude must be between -90 and 90');
            return;
        }
        
        if (lngNum < -180 || lngNum > 180) {
            alert('Longitude must be between -180 and 180');
            return;
        }
        
        // Set the coordinates in hidden fields
        document.getElementById('update-pickup-lat').value = latNum;
        document.getElementById('update-pickup-lng').value = lngNum;
        
        // Update the pickup location input with a descriptive text
        const pickupInput = document.getElementById('update-pickup');
        pickupInput.value = `Manual Location (${latNum}, ${lngNum})`;
        
        // Visual feedback
        pickupInput.style.borderColor = '#28a745';
        setTimeout(() => {
            pickupInput.style.borderColor = '';
        }, 2000);
        
        console.log('Manual coordinates set:', latNum, lngNum);
        alert('Coordinates set successfully! You can now submit the form.');
    }
    
    // Function to set quick location coordinates
    function setQuickLocation(locationName, lat, lng) {
        // Set the coordinates in hidden fields
        document.getElementById('update-pickup-lat').value = lat;
        document.getElementById('update-pickup-lng').value = lng;
        
        // Update the pickup location input
        const pickupInput = document.getElementById('update-pickup');
        pickupInput.value = locationName;
        
        // Visual feedback
        pickupInput.style.borderColor = '#28a745';
        setTimeout(() => {
            pickupInput.style.borderColor = '';
        }, 2000);
        
        console.log('Quick location set:', locationName, lat, lng);
        alert(`${locationName} coordinates set successfully! You can now submit the form.`);
    }
    
    // Tip Update Functions
    function toggleTipUpdateForm() {
        var tipUpdateSection = document.getElementById('tip-update-section');
        var updateTipBtn = document.getElementById('update-tip-btn');
        
        if (tipUpdateSection.classList.contains('hidden')) {
            // Show the form
            tipUpdateSection.classList.remove('hidden');
            updateTipBtn.innerHTML = '<i class="fas fa-times"></i> Cancel Tip Update';
            
            // Populate current tip amount and trip ID
            if (currentTripData && currentTripData.trip) {
                var currentTip = currentTripData.trip.tip || 0;
                var tripId = currentTripData.trip.TripID || currentTripData.trip.tripId;
                
                document.getElementById('current-tip-display').textContent = 'LKR ' + parseFloat(currentTip).toFixed(2);
                document.getElementById('new-tip-amount').min = currentTip;
                document.getElementById('new-tip-amount').value = currentTip;
                document.getElementById('tip-trip-id').value = tripId;
            }
        } else {
            // Hide the form
            tipUpdateSection.classList.add('hidden');
            updateTipBtn.innerHTML = '<i class="fas fa-gift"></i> Update Tip';
        }
    }
    
    function submitTipUpdateForm() {
        console.log('submitTipUpdateForm called');
        var newTipAmount = document.getElementById('new-tip-amount').value;
        console.log('New tip amount from form:', newTipAmount);
        
        if (!currentTripData || !currentTripData.trip) {
            console.error('No trip data available');
            alert('No trip data available');
            return;
        }
        
        // Ensure form exists and hidden fields are set
        var form = document.getElementById('tip-update-form');
        if (!form) {
            alert('Tip update form not found');
            return;
        }
        
        // Ensure trip ID is set in hidden field
        var tripId = currentTripData.trip.TripID || currentTripData.trip.tripId;
        var tripIdField = document.getElementById('tip-trip-id');
        if (tripIdField) {
            tripIdField.value = tripId;
        }
        
        var currentTip = parseFloat(currentTripData.trip.tip || 0);
        var newTip = parseFloat(newTipAmount);
        
        // Validate tip amount
        if (isNaN(newTip) || newTip < 0) {
            alert('Please enter a valid tip amount');
            return;
        }
        
        if (newTip < currentTip) {
            alert('New tip amount cannot be lower than current tip amount (LKR ' + currentTip.toFixed(2) + ')');
            return;
        }
        
        if (newTip === currentTip) {
            alert('New tip amount is the same as current tip amount');
            return;
        }
        
        // Submit the tip update - manually create FormData to ensure action is included
        var formData = new FormData();
        formData.append('action', 'updateTip');
        formData.append('tripId', tripId);
        formData.append('newTip', newTipAmount);
        
        console.log('Submitting tip update:', {
            tripId: tripId,
            currentTip: currentTip,
            newTip: newTip
        });
        
        // Debug: Log all FormData entries
        console.log('Tip update FormData entries:');
        for (let [key, value] of formData.entries()) {
            console.log('  ' + key + ' = ' + value);
        }
        
        console.log('About to make fetch request to:', getContextPath() + '/CustomerServlet');
        
        fetch(getContextPath() + '/CustomerServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log('Tip update response status:', response.status);
            return response.text();
        })
        .then(text => {
            console.log('Tip update response text:', text);
            
            if (text.trim().startsWith('<')) {
                console.error('Server returned HTML instead of JSON');
                alert('Server error occurred. Please check server logs.');
                return;
            }
            
            try {
                var data = JSON.parse(text);
                console.log('Parsed tip update response:', data);
                
                if (data.success) {
                    alert('Tip updated successfully! New tip amount: LKR ' + newTip.toFixed(2));
                    toggleTipUpdateForm(); // Hide the form
                    // Refresh the page to show updated data
                    location.reload();
                } else {
                    console.error('Server error:', data.error);
                    alert('Error: ' + (data.error || 'Failed to update tip'));
                }
            } catch (parseError) {
                console.error('JSON parse error:', parseError);
                console.error('Response text:', text);
                alert('Error parsing server response. Check console for details.\n\nResponse: ' + text.substring(0, 200));
            }
        })
        .catch(function(error) {
            console.error('Fetch error:', error);
            alert('An error occurred while updating the tip: ' + error.message);
        });
    }
    
    // Test function to debug tip update
    function testTipUpdate() {
        console.log('=== TEST TIP UPDATE ===');
        console.log('Current trip data:', currentTripData);
        
        if (!currentTripData || !currentTripData.trip) {
            alert('No trip data available for testing');
            return;
        }
        
        var tripId = currentTripData.trip.TripID || currentTripData.trip.tripId;
        var testTip = 100.00; // Fixed test value
        
        console.log('Test parameters:');
        console.log('  tripId:', tripId);
        console.log('  testTip:', testTip);
        
        // Test getContextPath function
        var contextPath = getContextPath();
        console.log('Context path:', contextPath);
        
        // Create simple FormData
        var formData = new FormData();
        formData.append('action', 'updateTip');
        formData.append('tripId', tripId);
        formData.append('newTip', testTip);
        
        console.log('Test FormData entries:');
        for (let [key, value] of formData.entries()) {
            console.log('  ' + key + ' = ' + value);
        }
        
        var url = contextPath + '/CustomerServlet';
        console.log('Making test request to:', url);
        
        // Test with FormData first
        console.log('Testing with FormData...');
        
        fetch(url, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log('Test response status:', response.status);
            console.log('Test response headers:', response.headers);
            return response.text();
        })
        .then(text => {
            console.log('Test response text:', text);
            alert('Test completed. Check console for details.');
        })
        .catch(error => {
            console.error('Test error:', error);
            console.log('FormData failed, trying URLSearchParams...');
            
            // Try with URLSearchParams as backup
            var params = new URLSearchParams();
            params.append('action', 'updateTip');
            params.append('tripId', tripId);
            params.append('newTip', testTip);
            
            console.log('URLSearchParams:', params.toString());
            
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                console.log('URLSearchParams response status:', response.status);
                return response.text();
            })
            .then(text => {
                console.log('URLSearchParams response text:', text);
                alert('Backup test completed. Check console for details.');
            })
            .catch(error2 => {
                console.error('URLSearchParams error:', error2);
                alert('Both tests failed: ' + error2.message);
            });
        });
    }
    
    // Simple test function - most basic approach
    function simpleTest() {
        console.log('=== SIMPLE TEST ===');
        
        // Create a simple form and submit it
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = getContextPath() + '/CustomerServlet';
        
        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'updateTip';
        form.appendChild(actionInput);
        
        var tripIdInput = document.createElement('input');
        tripIdInput.type = 'hidden';
        tripIdInput.name = 'tripId';
        tripIdInput.value = '1'; // Hardcoded for testing
        form.appendChild(tripIdInput);
        
        var tipInput = document.createElement('input');
        tipInput.type = 'hidden';
        tipInput.name = 'newTip';
        tipInput.value = '50.00'; // Hardcoded for testing
        form.appendChild(tipInput);
        
        console.log('Simple test form created');
        console.log('Action:', actionInput.value);
        console.log('TripId:', tripIdInput.value);
        console.log('NewTip:', tipInput.value);
        
        // Submit the form
        document.body.appendChild(form);
        form.submit();
        
        console.log('Simple test form submitted');
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
            
            updateFormSection.classList.remove('hidden');
            updateBtn.innerHTML = '<i class="fas fa-times"></i> Cancel Update';
            updateBtn.onclick = toggleUpdateForm;
            
            // Initialize autocomplete after form is shown
            console.log('About to initialize autocomplete in 200ms...');
            setTimeout(function() {
                console.log('Initializing autocomplete now...');
                initializeUpdateFormAutocomplete();
                
                // Also try to trigger autocomplete manually after a short delay
                setTimeout(function() {
                    const pickupInput = document.getElementById('update-pickup');
                    if (pickupInput && updatePickupAutocomplete) {
                        console.log('Manually triggering autocomplete focus');
                        pickupInput.focus();
                        pickupInput.click();
                    }
                }, 500);
            }, 200);
        } else {
            // Hide form
            updateFormSection.classList.add('hidden');
            updateBtn.innerHTML = '<i class="fas fa-edit"></i> Update Pickup Location';
            updateBtn.onclick = toggleUpdateForm;
        }
    }
</script>

</body>
</html>

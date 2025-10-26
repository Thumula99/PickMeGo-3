<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
            color: #333;
            padding: 20px;
            min-height: 100vh;
        }

        .container {
            max-width: 900px;
            margin: auto;
        }

        header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
        }

        .trip-request {
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }

        .trip-request:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }

        .trip-details p {
            margin: 5px 0;
        }

        .location-details {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .location-icon {
            font-size: 18px;
            margin-right: 10px;
            color: #3498db;
        }

        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.2s ease;
        }

        .btn:hover {
            opacity: 0.9;
            transform: scale(1.05);
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

        .status-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
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
            margin-right: 10px;
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

        .no-data {
            text-align: center;
            padding: 20px;
            color: #7f8c8d;
        }

        .debug-panel {
            background-color: #f8f9fa;
            border-left: 4px solid #e74c3c;
            padding: 15px;
            margin-top: 20px;
            font-family: monospace;
            font-size: 14px;
            display: none;
            max-height: 300px;
            overflow-y: auto;
        }

        .debug-toggle {
            background: #95a5a6;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .driver-info {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 10px;
        }

        .driver-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #3498db;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
        }

        @media (max-width: 768px) {
            .trip-request {
                flex-direction: column;
                align-items: flex-start;
            }

            .trip-request button {
                margin-top: 10px;
                align-self: flex-end;
            }

            .status-buttons {
                flex-direction: column;
            }

            .status-buttons button {
                margin-bottom: 5px;
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <header>
        <h1><i class="fas fa-tachometer-alt"></i> Driver Dashboard</h1>
        <div class="driver-info">
            <div class="driver-avatar">JD</div>
            <p>Welcome, John Driver!</p>
        </div>
    </header>

    <div class="card">
        <h2><i class="fas fa-list-ul"></i> Pending Ride Requests</h2>
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
        debugInfo.scrollTop = debugInfo.scrollHeight;
    }

    function toggleDebug() {
        var panel = document.getElementById('debug-panel');
        panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
    }

    // Function to get context path correctly
    function getContextPath() {
        return "/ridebooking"; // This should match your application context path
    }

    // Function to fetch and display pending requests
    function fetchPendingRequests() {
        debugLog("Fetching pending requests...");

        // Simulate API call with mock data
        setTimeout(function() {
            var mockData = [
                {
                    tripId: 101,
                    pickupLocation: "123 Main Street, City Center",
                    dropoffLocation: "456 Oak Avenue, Downtown",
                    distance: 5.2,
                    vehicleType: "Standard",
                    price: 12.50
                },
                {
                    tripId: 102,
                    pickupLocation: "789 Elm Road, West District",
                    dropoffLocation: "321 Pine Boulevard, East Side",
                    distance: 3.8,
                    vehicleType: "Premium",
                    price: 18.75
                }
            ];

            debugLog("Received " + mockData.length + " pending requests");
            var container = document.getElementById('pending-requests');
            container.innerHTML = '';

            if (mockData && mockData.length > 0) {
                mockData.forEach(function(trip) {
                    // Debug the trip object structure
                    debugLog("Trip object keys: " + Object.keys(trip).join(', '));

                    var tripDiv = document.createElement('div');
                    tripDiv.className = 'trip-request';

                    // Handle different possible property names
                    var tripId = trip.tripId || trip.tripID || trip.id;
                    var pickupLocation = trip.pickupLocation || trip.pickup_location || trip.pickup;
                    var dropoffLocation = trip.dropoffLocation || trip.dropoff_location || trip.dropoff;
                    var distance = trip.distance || trip.trip_distance;
                    var vehicleType = trip.vehicleType || trip.vehicle_type;
                    var price = trip.price ? 'LKR ' + parseFloat(trip.price).toFixed(2) : 'N/A';

                    tripDiv.innerHTML = '<div class="trip-details">' +
                        '<div class="location-details"><span class="location-icon"><i class="fas fa-map-marker-alt"></i></span><p><strong>Pickup:</strong> ' + (pickupLocation || 'N/A') + '</p></div>' +
                        '<div class="location-details"><span class="location-icon"><i class="fas fa-flag"></i></span><p><strong>Drop-off:</strong> ' + (dropoffLocation || 'N/A') + '</p></div>' +
                        '<p><strong>Distance:</strong> ' + (distance || 'N/A') + ' km</p>' +
                        '<p><strong>Vehicle Type:</strong> ' + (vehicleType || 'N/A') + '</p>' +
                        '<p><strong>Price:</strong> ' + price + '</p>' +
                        '</div>' +
                        '<button class="btn btn-accept" onclick="acceptTrip(' + tripId + ')">Accept</button>';

                    container.appendChild(tripDiv);
                });
            } else {
                container.innerHTML = '<div class="no-data"><i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px;"></i><p>No pending ride requests at this time.</p></div>';
            }
        }, 1000); // Simulate network delay
    }

    // Function to fetch and display the current trip
    function fetchCurrentTrip() {
        debugLog("Fetching current trip...");

        // Simulate API call with mock data
        setTimeout(function() {
            var mockData = {
                tripId: 100,
                pickupLocation: "555 Broadway, Central District",
                dropoffLocation: "888 Market Street, Shopping Area",
                status: "In Progress",
                distance: 7.5,
                price: 22.30
            };

            debugLog("Received current trip data: " + JSON.stringify(mockData));
            var container = document.getElementById('current-trip');

            if (mockData && (mockData.tripId || mockData.tripID || mockData.id)) {
                // Handle different possible property names
                var tripId = mockData.tripId || mockData.tripID || mockData.id;
                var pickupLocation = mockData.pickupLocation || mockData.pickup_location || mockData.pickup;
                var dropoffLocation = mockData.dropoffLocation || mockData.dropoff_location || mockData.dropoff;
                var status = mockData.status || mockData.trip_status;
                var distance = mockData.distance || mockData.trip_distance;
                var price = mockData.price ? 'LKR ' + parseFloat(mockData.price).toFixed(2) : 'N/A';

                container.innerHTML = '<div class="trip-details">' +
                    '<div class="location-details"><span class="location-icon"><i class="fas fa-map-marker-alt"></i></span><p><strong>Pickup:</strong> ' + (pickupLocation || 'N/A') + '</p></div>' +
                    '<div class="location-details"><span class="location-icon"><i class="fas fa-flag"></i></span><p><strong>Drop-off:</strong> ' + (dropoffLocation || 'N/A') + '</p></div>' +
                    '<p><strong>Status:</strong> <span style="color: #3498db; font-weight: bold;">' + (status || 'N/A') + '</span></p>' +
                    '<p><strong>Distance:</strong> ' + (distance || 'N/A') + ' km</p>' +
                    '<p><strong>Price:</strong> ' + price + '</p>' +
                    '</div>' +
                    '<div class="status-buttons">' +
                    '<button class="btn btn-update" onclick="updateTripStatus(' + tripId + ', \'On The Way\')"><i class="fas fa-car"></i> On The Way</button>' +
                    '<button class="btn btn-update" onclick="updateTripStatus(' + tripId + ', \'Arrived\')"><i class="fas fa-check-circle"></i> Arrived</button>' +
                    '<button class="btn btn-complete" onclick="updateTripStatus(' + tripId + ', \'Completed\')"><i class="fas fa-flag-checkered"></i> Completed</button>' +
                    '<button class="btn btn-cancel" onclick="updateTripStatus(' + tripId + ', \'Cancelled\')"><i class="fas fa-times-circle"></i> Cancel Trip</button>' +
                    '</div>';
            } else {
                container.innerHTML = '<div class="no-data"><i class="fas fa-route" style="font-size: 48px; margin-bottom: 15px;"></i><p>You currently do not have an active trip.</p></div>';
            }
        }, 1200); // Simulate network delay
    }

    // Function to accept a trip
    function acceptTrip(tripId) {
        debugLog("Accepting trip with ID: " + tripId);

        if (confirm('Are you sure you want to accept this trip?')) {
            // Simulate API call
            setTimeout(function() {
                alert('Trip accepted!');
                fetchPendingRequests();
                fetchCurrentTrip();
            }, 500);
        }
    }

    // Function to update trip status
    function updateTripStatus(tripId, status) {
        debugLog("Updating trip " + tripId + " to status: " + status);

        // Simulate API call
        setTimeout(function() {
            alert('Trip status updated to ' + status);
            fetchCurrentTrip();
        }, 500);
    }

    // Initial load and periodic refresh
    document.addEventListener('DOMContentLoaded', function() {
        debugLog("Dashboard initialized");
        fetchPendingRequests();
        fetchCurrentTrip();
        setInterval(fetchPendingRequests, 30000);
    });
</script>

</body>
</html>
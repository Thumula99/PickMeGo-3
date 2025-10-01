<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking with Directions</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
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
        
        /* Book ride specific layout */
        .book-ride-container {
            max-width: 1200px;
            margin: auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--spacing-lg);
        }
        
        @media (max-width: 900px) {
            .book-ride-container {
                grid-template-columns: 1fr;
            }
        }
        
        .book-ride-header {
            grid-column: 1 / -1;
            text-align: center;
            padding: var(--spacing-xl);
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            margin-bottom: var(--spacing-lg);
            position: relative;
            padding-left: 80px; /* room for left-side back button */
        }
        
        .book-ride-header h1 {
            font-size: var(--font-size-4xl);
            margin-bottom: var(--spacing-sm);
            font-weight: var(--font-weight-bold);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .book-ride-header h1 i {
            margin-right: var(--spacing-md);
        }
        
        .map-container {
            position: relative;
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow);
            height: 500px;
        }
        
        #map {
            height: 100%;
            width: 100%;
        }
        
        .booking-panel {
            background: var(--ash-light);
            padding: var(--spacing-xl);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            border: 1px solid var(--ash-medium);
        }
        
        .panel-title {
            font-size: var(--font-size-2xl);
            margin-bottom: var(--spacing-lg);
            color: var(--black-light);
            border-bottom: 2px solid var(--ash-medium);
            padding-bottom: var(--spacing-md);
            display: flex;
            align-items: center;
        }
        
        .panel-title i {
            margin-right: var(--spacing-sm);
            color: var(--primary);
        }
        
        .location-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
        }
        
        @media (max-width: 768px) {
            .location-inputs {
                grid-template-columns: 1fr;
            }
        }
        
        .input-group {
            display: flex;
            flex-direction: column;
        }
        
        .input-group label {
            font-weight: var(--font-weight-semibold);
            margin-bottom: var(--spacing-sm);
            color: var(--black-light);
        }
        
        .input-group input,
        .input-group select {
            width: 100%;
            padding: var(--spacing-md);
            border: 1px solid var(--ash-medium);
            border-radius: var(--radius-md);
            font-size: var(--font-size-base);
            font-family: var(--font-family);
            background: var(--ash-light);
            color: var(--black-light);
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        
        .input-group input:focus,
        .input-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(0, 204, 122, 0.2);
            transform: translateY(-2px);
        }
        
        .action-buttons {
            display: flex;
            gap: var(--spacing-lg);
            margin-top: var(--spacing-lg);
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }
        }
        
        .btn {
            padding: var(--spacing-lg) var(--spacing-xl);
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: var(--font-weight-semibold);
            flex: 1;
            transition: all 0.3s ease;
            font-family: var(--font-family);
            font-size: var(--font-size-base);
            position: relative;
            overflow: hidden;
        }
        
        .btn::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }
        
        .btn:hover::after {
            transform: translateX(0);
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .btn-primary {
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 204, 122, 0.3);
        }
        
        .btn-primary:hover {
            box-shadow: 0 8px 25px rgba(0, 204, 122, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(90deg, #e11d48 0%, #be123c 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(225, 29, 72, 0.3);
        }
        
        .btn-secondary:hover {
            box-shadow: 0 8px 25px rgba(225, 29, 72, 0.4);
        }
        
        .btn-tertiary {
            background: linear-gradient(90deg, var(--black-light) 0%, var(--black-medium) 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(31, 41, 55, 0.3);
        }
        
        .btn-tertiary:hover {
            box-shadow: 0 8px 25px rgba(31, 41, 55, 0.4);
        }
        
        .route-info {
            background: var(--ash-light);
            padding: var(--spacing-lg);
            border-radius: var(--radius-md);
            margin-bottom: var(--spacing-lg);
            border-left: 4px solid var(--primary);
            border: 1px solid var(--ash-medium);
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: var(--spacing-sm) 0;
            border-bottom: 1px solid var(--ash-medium);
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: var(--font-weight-semibold);
            color: var(--black-light);
        }
        
        .info-value {
            color: var(--ash-darker);
        }
        
        #price {
            font-size: var(--font-size-4xl);
            font-weight: var(--font-weight-bold);
            color: var(--primary);
            text-align: center;
            margin: var(--spacing-lg) 0;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .loading {
            text-align: center;
            padding: var(--spacing-xl);
            display: none;
        }
        
        .loading i {
            animation: spin 1s linear infinite;
            font-size: var(--font-size-2xl);
            color: var(--primary);
            margin-bottom: var(--spacing-md);
        }
        
        .back-btn {
            position: absolute;
            top: 50%;
            left: 20px;
            transform: translateY(-50%);
            background: linear-gradient(90deg, var(--black-light) 0%, var(--black-medium) 100%);
            color: #ffffff;
            border: 1px solid rgba(0, 0, 0, 0.3);
            padding: 12px 16px;
            border-radius: var(--radius-md);
            text-decoration: none;
            font-weight: var(--font-weight-medium);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }
        
        .back-btn:hover {
            background: linear-gradient(90deg, var(--black-medium) 0%, var(--black-dark) 100%);
            transform: translate(-0px, calc(-50% - 2px));
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3);
        }
        
        .back-btn i {
            margin-right: var(--spacing-xs);
        }
    </style>
</head>
<body class="customer-theme">
<div class="book-ride-container">
    <div class="book-ride-header">
        <a href="${pageContext.request.contextPath}/views/customer/dashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        <h1><i class="fas fa-route"></i> Book a Ride</h1>
        <p>Select your pickup and destination to get started</p>
    </div>

    <div class="map-container">
        <div id="map"></div>
    </div>

    <div class="booking-panel">
        <h2 class="panel-title"><i class="fas fa-list-alt"></i> Route Details</h2>
        <div class="location-inputs">
            <div class="input-group">
                <label for="pickup-input"><i class="fas fa-map-marker-alt"></i> Pickup Location</label>
                <input type="text" id="pickup-input" placeholder="Enter pickup location">
            </div>
            <div class="input-group">
                <label for="dropoff-input"><i class="fas fa-flag-checkered"></i> Dropoff Location</label>
                <input type="text" id="dropoff-input" placeholder="Enter drop-off location">
            </div>
        </div>

        <div class="location-inputs">
            <div class="input-group">
                <label for="vehicle-type"><i class="fas fa-car-side"></i> Vehicle Type</label>
                <select id="vehicle-type" name="vehicleType" required>
                    <option value="Tuk Tuk">Tuk Tuk</option>
                    <option value="Car" selected>Car</option>
                    <option value="Motorcycle">Motorcycle</option>
                </select>
            </div>
        </div>

        <div class="route-info">
            <div class="info-item">
                <span class="info-label">Distance:</span>
                <span id="distance">-</span>
            </div>
            <div class="info-item">
                <span class="info-label">Duration:</span>
                <span id="duration">-</span>
            </div>
        </div>

        <div id="price">LKR 0.00</div>

        <div class="action-buttons">
            <button class="btn btn-primary" id="calculate-btn">
                <i class="fas fa-calculator"></i> Calculate Route
            </button>
            <button class="btn btn-secondary" id="reset-btn">
                <i class="fas fa-redo"></i> Reset
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/CustomerServlet" method="POST" id="booking-form">
            <input type="hidden" name="action" value="bookRide">
            <input type="hidden" id="pickupLat" name="pickupLat">
            <input type="hidden" id="pickupLng" name="pickupLng">
            <input type="hidden" id="dropoffLat" name="dropoffLat">
            <input type="hidden" id="dropoffLng" name="dropoffLng">
            <input type="hidden" id="pickupAddress" name="pickupLocation">
            <input type="hidden" id="dropoffAddress" name="dropoffLocation">
            <input type="hidden" id="tripDistance" name="distance">
            <input type="hidden" id="finalPrice" name="finalPrice">
            <input type="hidden" id="vehicleTypeHidden" name="vehicleType">

            <button type="submit" class="btn btn-tertiary" id="book-btn" disabled>
                <i class="fas fa-taxi"></i> Book Ride
            </button>
        </form>
    </div>
</div>

<script>
    const API_KEY = "AIzaSyDIjP4YwT_snNdKDYrCTzXhGVrtuAJdac8"; // Replace with your actual API key

    let map, directionsService, directionsRenderer, geocoder;
    let pickupAutocomplete, dropoffAutocomplete;

    const pickupInput = document.getElementById("pickup-input");
    const dropoffInput = document.getElementById("dropoff-input");
    const vehicleTypeSelect = document.getElementById("vehicle-type");
    const calculateBtn = document.getElementById("calculate-btn");
    const resetBtn = document.getElementById("reset-btn");
    const bookBtn = document.getElementById("book-btn");
    const distanceEl = document.getElementById("distance");
    const durationEl = document.getElementById("duration");
    const priceEl = document.getElementById("price");
    const pickupLatEl = document.getElementById("pickupLat");
    const pickupLngEl = document.getElementById("pickupLng");
    const dropoffLatEl = document.getElementById("dropoffLat");
    const dropoffLngEl = document.getElementById("dropoffLng");
    const pickupAddressEl = document.getElementById("pickupAddress");
    const dropoffAddressEl = document.getElementById("dropoffAddress");
    const tripDistanceEl = document.getElementById("tripDistance");
    const finalPriceInput = document.getElementById("finalPrice");
    const vehicleTypeHidden = document.getElementById("vehicleTypeHidden");

    const rates = {
        "Tuk Tuk": 50,
        "Car": 100,
        "Motorcycle": 30
    };

    function initMap() {
        directionsService = new google.maps.DirectionsService();
        directionsRenderer = new google.maps.DirectionsRenderer();
        geocoder = new google.maps.Geocoder();

        map = new google.maps.Map(document.getElementById("map"), {
            center: { lat: 6.9271, lng: 79.8612 },
            zoom: 12,
        });
        directionsRenderer.setMap(map);

        // Places Autocomplete
        pickupAutocomplete = new google.maps.places.Autocomplete(pickupInput);
        dropoffAutocomplete = new google.maps.places.Autocomplete(dropoffInput);

        pickupAutocomplete.addListener('place_changed', () => {
            const place = pickupAutocomplete.getPlace();
            if (place.geometry) {
                pickupLatEl.value = place.geometry.location.lat();
                pickupLngEl.value = place.geometry.location.lng();
                pickupAddressEl.value = place.formatted_address;
            }
        });

        dropoffAutocomplete.addListener('place_changed', () => {
            const place = dropoffAutocomplete.getPlace();
            if (place.geometry) {
                dropoffLatEl.value = place.geometry.location.lat();
                dropoffLngEl.value = place.geometry.location.lng();
                dropoffAddressEl.value = place.formatted_address;
            }
        });

        // Event listeners for buttons and vehicle type change
        calculateBtn.addEventListener('click', calculateAndDisplayRoute);
        resetBtn.addEventListener('click', resetRoute);
        vehicleTypeSelect.addEventListener('change', calculateAndDisplayRoute);
    }

    function calculateAndDisplayRoute() {
        if (!pickupInput.value || !dropoffInput.value) {
            alert("Please enter both pickup and drop-off locations.");
            return;
        }

        // Ensure hidden fields are populated by autocomplete before proceeding
        if (!pickupLatEl.value || !dropoffLatEl.value) {
            alert("Please select a valid location from the dropdown suggestions.");
            return;
        }

        const origin = { lat: parseFloat(pickupLatEl.value), lng: parseFloat(pickupLngEl.value) };
        const destination = { lat: parseFloat(dropoffLatEl.value), lng: parseFloat(dropoffLngEl.value) };

        directionsService.route({
            origin: origin,
            destination: destination,
            travelMode: google.maps.TravelMode.DRIVING,
        }, (response, status) => {
            if (status === 'OK') {
                directionsRenderer.setDirections(response);
                const leg = response.routes[0].legs[0];
                distanceEl.textContent = leg.distance.text;
                durationEl.textContent = leg.duration.text;
                tripDistanceEl.value = leg.distance.text;

                // Set vehicle type in hidden field for form submission
                vehicleTypeHidden.value = vehicleTypeSelect.value;

                calculatePrice(leg.distance.value);
                bookBtn.disabled = false;
            } else {
                window.alert('Directions request failed due to ' + status);
                resetRouteInfo();
            }
        });
    }

    function calculatePrice(distanceMeters) {
        const distanceKm = distanceMeters / 1000;
        const selectedVehicle = vehicleTypeSelect.value;
        const ratePerKm = rates[selectedVehicle];

        if (ratePerKm) {
            const price = distanceKm * ratePerKm;
            priceEl.textContent = "LKR " + price.toFixed(2);
            finalPriceInput.value = price.toFixed(2);
        } else {
            priceEl.textContent = "LKR 0.00";
            finalPriceInput.value = "0.00";
        }
    }

    function resetRoute() {
        directionsRenderer.setDirections({ routes: [] });
        pickupInput.value = "";
        dropoffInput.value = "";
        resetRouteInfo();
        bookBtn.disabled = true;
    }

    function resetRouteInfo() {
        distanceEl.textContent = "-";
        durationEl.textContent = "-";
        priceEl.textContent = "LKR 0.00";
        pickupLatEl.value = "";
        pickupLngEl.value = "";
        dropoffLatEl.value = "";
        dropoffLngEl.value = "";
        pickupAddressEl.value = "";
        dropoffAddressEl.value = "";
        tripDistanceEl.value = "";
        finalPriceInput.value = "";
        vehicleTypeHidden.value = "";
    }
</script>

<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDIjP4YwT_snNdKDYrCTzXhGVrtuAJdac8&callback=initMap&libraries=places,geocoding"></script>
</body>
</html>
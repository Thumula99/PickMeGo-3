<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sliit.pickmegoweb.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard | PickMeGo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
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

        /* Enhanced stat cards with vibrant gradients and animations */
        .customer-theme .stat-card {
            transition: all 0.3s ease-in-out;
            border-radius: var(--radius-md);
        }

        .customer-theme .stat-card:nth-child(1) {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            box-shadow: 0 6px 20px rgba(0, 204, 122, 0.3);
        }

        .customer-theme .stat-card:nth-child(2) {
            background: linear-gradient(135deg, var(--black-light) 0%, var(--black-medium) 100%);
            box-shadow: 0 6px 20px rgba(31, 41, 55, 0.3);
        }

        .customer-theme .stat-card:nth-child(3) {
            background: linear-gradient(135deg, var(--ash-dark) 0%, var(--black-light) 100%);
            box-shadow: 0 6px 20px rgba(107, 114, 128, 0.3);
        }

        .customer-theme .stat-card:nth-child(4) {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-darker) 100%);
            box-shadow: 0 6px 20px rgba(0, 158, 94, 0.3);
        }

        .customer-theme .stat-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
            filter: brightness(1.1);
        }

        .customer-theme .stat-number {
            color: var(--ash-light);
            font-size: var(--font-size-2xl);
            font-weight: var(--font-weight-bold);
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

        .customer-theme .stat-label {
            color: var(--ash-light);
            opacity: 0.9;
            font-weight: var(--font-weight-medium);
        }

        /* Enhanced feature cards with dynamic borders and hover effects */
        .customer-theme .feature-card {
            border: 1px solid var(--ash-medium);
            border-radius: var(--radius-md);
            transition: all 0.3s ease-in-out;
            background: var(--ash-light); /* Changed to light ash */
        }

        .customer-theme .feature-card:nth-child(1) {
            border-left: 5px solid var(--primary);
        }

        .customer-theme .feature-card:nth-child(2) {
            border-left: 5px solid var(--secondary-accent);
        }

        .customer-theme .feature-card:hover {
            border-left-color: var(--accent-light);
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 204, 122, 0.2);
            background: var(--ash-light); /* Maintain light ash on hover */
        }

        .customer-theme .feature-card .btn {
            background: linear-gradient(90deg, var(--primary) 0%, var(--accent-dark) 100%);
            color: var(--ash-light);
            border-radius: var(--radius-sm);
            padding: var(--spacing-sm) var(--spacing-md);
            transition: all 0.3s ease-in-out;
        }

        .customer-theme .feature-card:nth-child(2) .btn {
            background: linear-gradient(90deg, var(--secondary-accent) 0%, var(--secondary-accent-dark) 100%);
        }

        .customer-theme .feature-card .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 204, 122, 0.4);
            filter: brightness(1.15);
        }

        /* Enhanced notification badge with vibrant animation */
        .notification-badge {
            background: linear-gradient(135deg, var(--error) 0%, #e11d48 100%);
            color: var(--ash-light);
            border-radius: 50%;
            padding: 6px 10px;
            font-size: var(--font-size-sm);
            font-weight: var(--font-weight-bold);
            margin-left: var(--spacing-sm);
            box-shadow: 0 3px 10px rgba(225, 29, 72, 0.4);
            animation: pulse 1.5s ease-in-out infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); box-shadow: 0 3px 10px rgba(225, 29, 72, 0.4); }
            50% { transform: scale(1.1); box-shadow: 0 5px 15px rgba(225, 29, 72, 0.6); }
            100% { transform: scale(1); box-shadow: 0 3px 10px rgba(225, 29, 72, 0.4); }
        }

        /* Enhanced sidebar with sleek gradient */
        .customer-theme .sidebar {
            background: linear-gradient(180deg, var(--black-medium) 0%, var(--black-dark) 100%);
            border-right: 2px solid var(--ash-dark);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }

        .customer-theme .sidebar-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: var(--ash-light);
            margin: calc(-1 * var(--spacing-xl));
            margin-bottom: var(--spacing-lg);
            padding: var(--spacing-xl);
            border-radius: 0;
            border-bottom: 2px solid var(--primary-darker);
        }

        .customer-theme .sidebar-header h3 {
            color: var(--ash-light);
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        }

        .customer-theme .sidebar-header p {
            color: var(--ash-light);
            opacity: 0.85;
        }

        /* Enhanced navigation items with vibrant hover effects */
        .customer-theme .nav-item {
            color: var(--ash-light);
            transition: all 0.3s ease-in-out;
        }

        .customer-theme .nav-item:hover,
        .customer-theme .nav-item.active {
            background: linear-gradient(90deg, var(--primary-light) 0%, rgba(51, 255, 153, 0.2) 100%);
            color: var(--black-dark);
            border-left: 4px solid var(--primary);
            transform: translateX(8px);
        }

        /* Enhanced header with light ash background */
        .customer-theme .header {
            background: var(--ash-light); /* Changed to light ash */
            border-bottom: 2px solid var(--ash-medium);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .customer-theme .header h1 i {
            color: var(--primary);
            filter: drop-shadow(0 2px 4px rgba(0, 204, 122, 0.3));
        }

        /* Enhanced cards with light ash background */
        .customer-theme .card {
            background: var(--ash-light); /* Changed to light ash */
            border: 1px solid var(--ash-medium);
            border-radius: var(--radius-md);
            transition: all 0.3s ease-in-out;
        }

        .customer-theme .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .customer-theme .card-header {
            border-bottom: 2px solid var(--ash-medium);
        }

        .customer-theme .card-header h3 i {
            color: var(--primary);
            filter: drop-shadow(0 2px 4px rgba(0, 204, 122, 0.3));
        }

        /* Status-specific colors with vibrant highlights */
        .ride-status-pending {
            color: var(--ash-dark);
            background: rgba(107, 114, 128, 0.15);
            padding: var(--spacing-xs) var(--spacing-sm);
            border-radius: var(--radius-sm);
            font-weight: var(--font-weight-medium);
        }

        .ride-status-confirmed {
            color: var(--primary);
            background: rgba(0, 204, 122, 0.15);
            padding: var(--spacing-xs) var(--spacing-sm);
            border-radius: var(--radius-sm);
            font-weight: var(--font-weight-medium);
        }

        .ride-status-completed {
            color: var(--black-light);
            background: rgba(31, 41, 55, 0.15);
            padding: var(--spacing-xs) var(--spacing-sm);
            border-radius: var(--radius-sm);
            font-weight: var(--font-weight-medium);
        }

        .ride-status-cancelled {
            color: var(--error);
            background: rgba(225, 29, 72, 0.15);
            padding: var(--spacing-xs) var(--spacing-sm);
            border-radius: var(--radius-sm);
            font-weight: var(--font-weight-medium);
        }

        /* Enhanced loading states with vibrant animations */
        .customer-theme .loading i {
            color: var(--primary);
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Enhanced empty states with subtle colors */
        .customer-theme .empty-state {
            text-align: center;
            padding: var(--spacing-xl);
            color: var(--ash-dark);
        }

        .customer-theme .empty-state i {
            font-size: var(--font-size-3xl);
            color: var(--ash-medium);
            margin-bottom: var(--spacing-md);
            filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
        }
    </style>
</head>
<body class="customer-theme">
<div class="dashboard-container">
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h3><i class="fas fa-car"></i> PickMeGo</h3>
            <p>Welcome, ${sessionScope.user.fullName}!</p>
        </div>

        <ul class="nav-menu">
            <li><a href="#" class="nav-item active"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/views/customer/profile_view.jsp" class="nav-item"><i class="fas fa-user"></i> Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/views/customer/book_ride.jsp" class="nav-item"><i class="fas fa-car"></i> Book Ride</a></li>
            <li><a href="${pageContext.request.contextPath}/views/customer/view_status.jsp" class="nav-item"><i class="fas fa-history"></i> Ride Status</a></li>
            <li><a href="#" class="nav-item"><i class="fas fa-cog"></i> Settings</a></li>
            <li><a href="${pageContext.request.contextPath}/UserServlet?action=logout" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <div class="header">
            <h1><i class="fas fa-home"></i> Dashboard</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/views/customer/profile_view.jsp" class="btn btn-primary">
                    <i class="fas fa-user"></i> View Profile
                </a>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number" id="total-rides">0</div>
                <div class="stat-label">Total Rides</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="completed-rides">0</div>
                <div class="stat-label">Completed Rides</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="cancelled-rides">0</div>
                <div class="stat-label">Cancelled Rides</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="total-spent">Rs. 0</div>
                <div class="stat-label">Total Spent</div>
            </div>
        </div>

        <!-- Feature Cards -->
        <div class="info-grid">
            <div class="card feature-card">
                <div class="card-header">
                    <h3><i class="fas fa-car"></i> Book a Ride</h3>
                </div>
                <div class="card-body">
                    <p>Request a ride from your current location to your destination.</p>
                    <a href="${pageContext.request.contextPath}/views/customer/book_ride.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Book Now
                    </a>
                </div>
            </div>

            <div class="card feature-card">
                <div class="card-header">
                    <h3><i class="fas fa-history"></i> Ride History</h3>
                </div>
                <div class="card-body">
                    <p>View your past rides and track their status.</p>
                    <a href="${pageContext.request.contextPath}/views/customer/view_status.jsp" class="btn btn-primary">
                        <i class="fas fa-eye"></i> View Status
                    </a>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-clock"></i> Recent Activity</h3>
            </div>
            <div class="card-body">
                <div id="recent-activity">
                    <div class="loading">
                        <i class="fas fa-spinner"></i>
                        <p>Loading recent activity...</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Notifications -->
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-bell"></i> Notifications</h3>
                <span id="notification-count" class="notification-badge">0</span>
            </div>
            <div class="card-body">
                <div id="notifications">
                    <div class="loading">
                        <i class="fas fa-spinner"></i>
                        <p>Loading notifications...</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Current Ride Status -->
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-route"></i> Current Ride</h3>
            </div>
            <div class="card-body">
                <div id="current-ride">
                    <div class="loading">
                        <i class="fas fa-spinner"></i>
                        <p>Loading current ride...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Function to get context path correctly
    function getContextPath() {
        return "${pageContext.request.contextPath}";
    }

    // Function to show loading
    function showLoading(elementId) {
        document.getElementById(elementId).innerHTML =
            '<div class="loading"><i class="fas fa-spinner"></i><p>Loading...</p></div>';
    }

    // Function to show empty state
    function showEmptyState(elementId, message) {
        document.getElementById(elementId).innerHTML =
            '<div class="empty-state"><i class="fas fa-inbox"></i><h3>No Data</h3><p>' + message + '</p></div>';
    }

    // Function to show error state
    function showErrorState(elementId, message) {
        document.getElementById(elementId).innerHTML =
            '<div class="alert alert-error"><i class="fas fa-exclamation-triangle"></i> ' + message + '</div>';
    }

    // Function to load customer statistics
    function loadCustomerStats() {
        document.getElementById('total-rides').textContent = '0';
        document.getElementById('completed-rides').textContent = '0';
        document.getElementById('cancelled-rides').textContent = '0';
        document.getElementById('total-spent').textContent = 'Rs. 0';


    }

    // Function to load recent activity
    function loadRecentActivity() {
        showLoading('recent-activity');

        // Simulate loading recent activity
        setTimeout(() => {
            showEmptyState('recent-activity', 'No recent activity');
        }, 1000);
    }

    // Function to load notifications
    function loadNotifications() {
        showLoading('notifications');

        // Simulate loading notifications
        setTimeout(() => {
            document.getElementById('notification-count').textContent = '0';
            showEmptyState('notifications', 'No new notifications');
        }, 1000);
    }

    // Function to load current ride
    function loadCurrentRide() {
        showLoading('current-ride');

        // Simulate loading current ride
        setTimeout(() => {
            showEmptyState('current-ride', 'No active ride');
        }, 1000);
    }

    // Initialize dashboard
    function initializeDashboard() {
        console.log("Initializing customer dashboard...");

        // Load all data
        loadCustomerStats();
        loadRecentActivity();
        loadNotifications();
        loadCurrentRide();
    }

    // Start the dashboard when page loads
    document.addEventListener('DOMContentLoaded', function() {
        initializeDashboard();
    });
</script>
</body>
</html>
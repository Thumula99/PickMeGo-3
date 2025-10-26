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
        /* Customer-specific theme overrides */
        .customer-theme {
            --primary: #27ae60;
            --primary-dark: #229954;
        }
        
        .customer-theme .stat-card {
            background: linear-gradient(135deg, var(--success) 0%, #00a085 100%);
            color: white;
        }
        
        .customer-theme .stat-number {
            color: white;
        }
        
        .customer-theme .stat-label {
            color: rgba(255, 255, 255, 0.9);
        }
        
        .customer-theme .feature-card:hover {
            border-color: var(--success);
        }
        
        .customer-theme .feature-card .btn {
            background: var(--success);
        }
        
        .customer-theme .feature-card .btn:hover {
            background: #00a085;
            box-shadow: 0 8px 20px rgba(0, 184, 148, 0.3);
        }
        
        .notification-badge {
            background: var(--error);
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: var(--font-size-xs);
            font-weight: var(--font-weight-bold);
            margin-left: var(--spacing-sm);
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
            // For now, we'll show placeholder data
            // In a real application, you would fetch this from the server
            document.getElementById('total-rides').textContent = '0';
            document.getElementById('completed-rides').textContent = '0';
            document.getElementById('cancelled-rides').textContent = '0';
            document.getElementById('total-spent').textContent = 'Rs. 0';
            
            // You can implement actual statistics loading here:
            // fetch(getContextPath() + '/CustomerServlet?action=getStats')
            //     .then(response => response.json())
            //     .then(data => {
            //         document.getElementById('total-rides').textContent = data.totalRides || '0';
            //         document.getElementById('completed-rides').textContent = data.completedRides || '0';
            //         document.getElementById('cancelled-rides').textContent = data.cancelledRides || '0';
            //         document.getElementById('total-spent').textContent = 'Rs. ' + (data.totalSpent || '0');
            //     })
            //     .catch(error => {
            //         console.error('Error loading stats:', error);
            //     });
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

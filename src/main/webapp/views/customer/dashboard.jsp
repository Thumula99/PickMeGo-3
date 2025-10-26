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

        /* Notices Section */
        .notices-section {
            margin: var(--spacing-xl) 0;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: var(--font-weight-bold, 700);
            color: var(--black-dark);
            margin-bottom: var(--spacing-lg);
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
        }

        .section-title i {
            color: var(--primary);
        }

        .notices-container {
            display: grid;
            gap: var(--spacing-md);
        }

        .notice-card {
            background: white;
            border-radius: var(--radius-md, 12px);
            padding: var(--spacing-lg);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-left: 4px solid var(--primary);
            transition: all 0.3s ease;
        }

        .notice-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .notice-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: var(--spacing-sm);
        }

        .notice-title {
            font-size: 1.1rem;
            font-weight: var(--font-weight-bold, 700);
            color: var(--black-dark);
            margin: 0;
        }

        .notice-badges {
            display: flex;
            gap: var(--spacing-xs);
        }

        .notice-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: var(--font-weight-medium, 500);
            text-transform: uppercase;
        }

        .notice-type-general {
            background: #e3f2fd;
            color: #1565c0;
        }

        .notice-type-maintenance {
            background: #fff3e0;
            color: #ef6c00;
        }

        .notice-type-service {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .notice-type-emergency {
            background: #ffebee;
            color: #c62828;
        }

        .notice-priority-low {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .notice-priority-normal {
            background: #e3f2fd;
            color: #1565c0;
        }

        .notice-priority-high {
            background: #fff3e0;
            color: #ef6c00;
        }

        .notice-priority-critical {
            background: #ffebee;
            color: #c62828;
        }

        .notice-message {
            color: var(--ash-dark);
            line-height: 1.6;
            margin-bottom: var(--spacing-sm);
        }

        .notice-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
            color: var(--ash-medium);
        }

        .notice-date {
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
        }

        .notice-expiry {
            font-style: italic;
        }

        .no-notices {
            text-align: center;
            color: var(--ash-medium);
            font-style: italic;
            padding: var(--spacing-xl);
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

        <!-- Success Message -->
        <%
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                session.removeAttribute("successMessage"); // Remove after displaying
        %>
        <div class="alert alert-success" style="margin: 20px 0; padding: 15px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 8px; color: #155724;">
            <i class="fas fa-check-circle"></i> <%= successMessage %>
        </div>
        <%
            }
        %>

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

        <!-- Notices Section -->
        <div class="notices-section">
            <h2 class="section-title">
                <i class="fas fa-bullhorn"></i> Important Notices
            </h2>
            <div id="noticesContainer" class="notices-container">
                <div class="loading">Loading notices...</div>
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

        <!-- Offers -->
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-tags"></i> Available Offers</h3>
            </div>
            <div class="card-body" id="offers-container">
                <div class="loading"><i class="fas fa-spinner"></i><p>Loading offers...</p></div>
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

        <!-- Feedback: Create -->
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-comment-dots"></i> Leave Feedback</h3>
            </div>
            <div class="card-body">
                <form id="feedbackForm" onsubmit="return submitFeedback(event)">
                    <div class="input-group">
                        <label for="fbTitle">Title</label>
                        <input id="fbTitle" type="text" placeholder="Short title" required>
                    </div>
                    <div class="input-group">
                        <label for="fbContent">Feedback</label>
                        <input id="fbContent" type="text" placeholder="Write your feedback" required>
                    </div>
                    <div class="input-group">
                        <label for="fbRating">Rating (1-5)</label>
                        <select id="fbRating">
                            <option value="">No rating</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </div>
                    <button class="btn btn-primary" type="submit"><i class="fas fa-paper-plane"></i> Submit</button>
                </form>
            </div>
        </div>

        <!-- Feedback: My submissions -->
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-comments"></i> My Feedback</h3>
            </div>
            <div class="card-body" id="myFeedbackContainer">
                <div class="loading"><i class="fas fa-spinner"></i><p>Loading...</p></div>
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
        loadOffers();
        loadMyFeedback();
        loadCurrentRide();
    }

    // Load notices for customers
    function loadNotices() {
        const container = document.getElementById('noticesContainer');
        if (!container) return;
        
        container.innerHTML = '<div class="loading"><i class="fas fa-spinner"></i><p>Loading notices...</p></div>';
        
        fetch(getContextPath() + '/CustomerServlet?action=getNotices')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(notices => {
                console.log('Notices received:', notices);
                displayNotices(notices);
            })
            .catch(error => {
                console.error('Error loading notices:', error);
                container.innerHTML = '<div class="no-notices">Unable to load notices at this time.</div>';
            });
    }
    
    function displayNotices(notices) {
        const container = document.getElementById('noticesContainer');
        if (!container) return;
        
        if (!notices || notices.length === 0) {
            container.innerHTML = '<div class="no-notices">No notices at this time.</div>';
            return;
        }
        
        let noticesHTML = '';
        notices.forEach(notice => {
            const noticeId = notice.NoticeID || notice.noticeId;
            const title = notice.Title || notice.title;
            const message = notice.Message || notice.message;
            const noticeType = notice.NoticeType || notice.noticeType;
            const priority = notice.Priority || notice.priority;
            const createdDate = notice.CreatedDate || notice.createdDate;
            const expiryDate = notice.ExpiryDate || notice.expiryDate;
            
            const typeClass = 'notice-type-' + noticeType.toLowerCase();
            const priorityClass = 'notice-priority-' + priority.toLowerCase();
            
            const createdDateStr = createdDate ? new Date(createdDate).toLocaleDateString() : 'N/A';
            const expiryDateStr = expiryDate ? new Date(expiryDate).toLocaleDateString() : null;
            
            noticesHTML += '<div class="notice-card">';
            noticesHTML += '<div class="notice-header">';
            noticesHTML += '<h3 class="notice-title">' + title + '</h3>';
            noticesHTML += '<div class="notice-badges">';
            noticesHTML += '<span class="notice-badge ' + typeClass + '">' + noticeType + '</span>';
            noticesHTML += '<span class="notice-badge ' + priorityClass + '">' + priority + '</span>';
            noticesHTML += '</div>';
            noticesHTML += '</div>';
            noticesHTML += '<div class="notice-message">' + message + '</div>';
            noticesHTML += '<div class="notice-footer">';
            noticesHTML += '<div class="notice-date">';
            noticesHTML += '<i class="fas fa-calendar"></i>';
            noticesHTML += '<span>Posted: ' + createdDateStr + '</span>';
            noticesHTML += '</div>';
            if (expiryDateStr) {
                noticesHTML += '<div class="notice-expiry">Expires: ' + expiryDateStr + '</div>';
            }
            noticesHTML += '</div>';
            noticesHTML += '</div>';
        });
        
        container.innerHTML = noticesHTML;
    }

    // Start the dashboard when page loads
    document.addEventListener('DOMContentLoaded', function() {
        initializeDashboard();
        loadNotices(); // Load notices for customers
    });

    function loadOffers(){
        const el = document.getElementById('offers-container');
        el.innerHTML = '<div class="loading"><i class="fas fa-spinner"></i><p>Loading offers...</p></div>';
        fetch(getContextPath() + '/OfferServlet')
            .then(r=>r.json())
            .then(list=>{
                if(!list || list.length===0){
                    el.innerHTML = '<div class="empty-state"><i class="fas fa-inbox"></i><h3>No Offers</h3><p>There are no active offers right now.</p></div>';
                    return;
                }
                let html = '';
                list.forEach(o=>{
                    html += '<div class="feature-card" style="margin-bottom:12px; padding:12px;">'
                        + '<div class="card-header"><h3><i class="fas fa-badge-percent"></i> ' + (o.title||'Offer') + '</h3></div>'
                        + '<div class="card-body">'
                        + '<p>' + (o.description||'') + '</p>'
                        + '<p><strong>Discount:</strong> ' + (o.discountType === 'PERCENT' ? (o.discountValue + '%') : ('LKR ' + o.discountValue)) + '</p>'
                        + (o.vehicleType ? ('<p><strong>Vehicle:</strong> ' + o.vehicleType + '</p>') : '')
                        + '</div>'
                        + '</div>';
                });
                el.innerHTML = html;
            })
            .catch(()=>{
                el.innerHTML = '<div class="empty-state"><i class="fas fa-triangle-exclamation"></i><h3>Error</h3><p>Failed to load offers.</p></div>';
            });
    }

    // Feedback client functions
    function submitFeedback(e){
        e.preventDefault();
        const body = new URLSearchParams({
            action:'create',
            title: document.getElementById('fbTitle').value,
            content: document.getElementById('fbContent').value,
            rating: document.getElementById('fbRating').value
        });
        fetch(getContextPath() + '/FeedbackServlet', { method:'POST', body })
            .then(r=>r.json()).then(res=>{ if(res.success){
                document.getElementById('feedbackForm').reset();
                loadMyFeedback();
                alert('Feedback submitted');
            }});
        return false;
    }
    function loadMyFeedback(){
        const el = document.getElementById('myFeedbackContainer');
        el.innerHTML = '<div class="loading"><i class="fas fa-spinner"></i><p>Loading...</p></div>';
        fetch(getContextPath() + '/FeedbackServlet?action=listMine')
            .then(r=>r.json()).then(rows=>{
                if(!rows || rows.length===0){ el.innerHTML = '<div class="empty-state"><i class="fas fa-inbox"></i><h3>No Feedback</h3><p>You have not submitted any feedback yet.</p></div>'; return; }
                let html = '<table class="data-table"><thead><tr><th>#</th><th>Title</th><th>Status</th><th>Rating</th><th>Reply</th><th></th></tr></thead><tbody>';
                rows.forEach(f=>{
                    html += '<tr>'+
                        '<td>#'+f.id+'</td>'+
                        '<td>'+escapeHtml(f.title||'')+'</td>'+
                        '<td>'+escapeHtml(f.status||'')+'</td>'+
                        '<td>'+(f.rating==null?'-':f.rating)+'</td>'+
                        '<td>'+(f.reply?escapeHtml(f.reply):'-')+'</td>'+
                        '<td><button class="btn btn-secondary" onclick="deleteFeedback('+f.id+')"><i class="fas fa-trash"></i></button></td>'+
                    '</tr>';
                });
                html += '</tbody></table>';
                el.innerHTML = html;
            });
    }
    function deleteFeedback(id){
        if(!confirm('Delete this feedback?')) return;
        const body = new URLSearchParams({ action:'delete', id:String(id) });
        fetch(getContextPath() + '/FeedbackServlet', { method:'POST', body })
            .then(r=>r.json()).then(_=>loadMyFeedback());
    }
    function escapeHtml(s){
        return String(s).replace(/[&<>\"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','\"':'&quot;'}[c]); });
    }
</script>
</body>
</html>
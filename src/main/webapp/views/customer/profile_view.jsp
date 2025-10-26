<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <style>
        /* Define color variables for consistency with dashboard */
        :root {
            /* Vibrant Green Colors */
            --primary: #00cc7a; /* Bright emerald green */
            --primary-dark: #009e5e; /* Deep forest green */
            --primary-light: #33ff99; /* Neon lime green */
            --primary-darker: #006633; /* Darker green for depth */

            /* Refined Ash/Gray Colors */
            --ash-light: #f5f6fa; /* Softer light gray */
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
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--ash-light); /* Light ash background */
            color: var(--black-medium);
            padding: 20px;
            margin: 0;
            min-height: 100vh;
        }

        .container {
            max-width: 800px;
            margin: auto;
        }

        .header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%); /* Green gradient header */
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 204, 122, 0.3);
        }

        .back-btn {
            background: linear-gradient(90deg, var(--black-light) 0%, var(--black-medium) 100%); /* Black gradient for button */
            color: var(--ash-light);
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 20px;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease-in-out;
            box-shadow: 0 2px 8px rgba(17, 24, 39, 0.2);
        }

        .back-btn:hover {
            background: linear-gradient(90deg, var(--black-medium) 0%, var(--black-dark) 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(17, 24, 39, 0.3);
        }

        .back-btn i {
            margin-right: 5px;
        }

        h1 {
            color: var(--ash-light); /* Light text for contrast on black header */
            margin: 0;
        }

        h1 i {
            color: var(--primary);
            filter: drop-shadow(0 2px 4px rgba(0, 204, 122, 0.3));
        }

        .card {
            background: linear-gradient(135deg, var(--ash-light) 0%, var(--ash-medium) 100%); /* Mixed ash gradient */
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            margin-bottom: 20px;
            border: 1px solid var(--ash-dark); /* Darker ash border */
        }

        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--ash-dark); /* Darker ash border */
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--black-light) 0%, var(--black-medium) 100%); /* Black gradient for avatar */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--ash-light);
            font-size: 32px;
            font-weight: bold;
            margin-right: 25px;
            box-shadow: 0 4px 15px rgba(17, 24, 39, 0.3);
        }

        .profile-info h2 {
            margin: 0 0 5px 0;
            color: var(--black-medium);
            font-size: 28px;
        }

        .profile-info .role-badge {
            background: rgba(0, 204, 122, 0.15);
            color: var(--primary);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-section {
            margin-bottom: 25px;
        }

        .info-section h3 {
            color: var(--black-medium);
            margin-bottom: 15px;
            font-size: 18px;
            display: flex;
            align-items: center;
        }

        .info-section h3 i {
            margin-right: 10px;
            color: var(--primary);
            filter: drop-shadow(0 2px 4px rgba(0, 204, 122, 0.3));
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .info-item {
            background: linear-gradient(135deg, var(--ash-light) 0%, var(--ash-medium) 100%); /* Mixed ash gradient */
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid var(--primary);
            transition: all 0.3s ease-in-out;
        }

        .info-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 204, 122, 0.2);
        }

        .info-item.preferences-info {
            border-left-color: var(--secondary-accent);
        }

        .info-label {
            font-weight: 600;
            color: var(--ash-dark);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 16px;
            color: var(--black-medium);
            font-weight: 500;
        }

        .info-value.empty {
            color: var(--ash-dark);
            font-style: italic;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            margin-right: 10px;
        }

        .btn i {
            margin-right: 8px;
        }

        .btn-primary {
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: var(--ash-light);
        }

        .btn-primary:hover {
            background: linear-gradient(90deg, var(--primary-dark) 0%, var(--primary-darker) 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 204, 122, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(90deg, var(--black-light) 0%, var(--black-medium) 100%); /* Black gradient for secondary button */
            color: var(--ash-light);
        }

        .btn-secondary:hover {
            background: linear-gradient(90deg, var(--black-medium) 0%, var(--black-dark) 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(17, 24, 39, 0.3);
        }

        .btn-group {
            margin-top: 30px;
            text-align: center;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .stat-card {
            background: linear-gradient(135deg, var(--black-light) 0%, var(--black-medium) 100%); /* Black gradient for stat cards */
            color: var(--ash-light);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(17, 24, 39, 0.3);
            transition: all 0.3s ease-in-out;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(17, 24, 39, 0.4);
            filter: brightness(1.1);
        }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 5px;
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
            }

            .profile-avatar {
                margin-right: 0;
                margin-bottom: 15px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .btn-group {
                text-align: center;
            }

            .btn {
                width: 100%;
                margin-bottom: 10px;
                margin-right: 0;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <a href="${pageContext.request.contextPath}/views/customer/dashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Back to Dashboard
        </a>
        <h1><i class="fas fa-user"></i> My Profile</h1>
    </div>

    <div class="card">
        <div class="profile-header">
            <div class="profile-avatar">
                ${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}
            </div>
            <div class="profile-info">
                <h2>${sessionScope.user.fullName}</h2>
                <div class="role-badge">
                    <i class="fas fa-id-badge"></i> ${sessionScope.user.role}
                </div>
            </div>
        </div>

        <div class="info-section">
            <h3><i class="fas fa-user-circle"></i> Personal Information</h3>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Full Name</div>
                    <div class="info-value">${sessionScope.user.fullName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Email Address</div>
                    <div class="info-value">${sessionScope.user.email}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Phone Number</div>
                    <div class="info-value">${sessionScope.user.phoneNumber}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Account Type</div>
                    <div class="info-value">${sessionScope.user.role}</div>
                </div>
            </div>
        </div>

        <div class="info-section">
            <h3><i class="fas fa-chart-bar"></i> Ride Statistics</h3>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number" id="totalRides">-</div>
                    <div class="stat-label">Total Rides</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" id="completedRides">-</div>
                    <div class="stat-label">Completed Rides</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" id="cancelledRides">-</div>
                    <div class="stat-label">Cancelled Rides</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" id="totalSpent">-</div>
                    <div class="stat-label">Total Spent</div>
                </div>
            </div>
        </div>

        <div class="btn-group">
            <a href="profile.jsp" class="btn btn-primary">
                <i class="fas fa-edit"></i>
                Manage Profile
            </a>
            <a href="${pageContext.request.contextPath}/views/customer/dashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-tachometer-alt"></i>
                Back to Dashboard
            </a>
        </div>
    </div>
</div>

<script>
    // Function to get context path correctly
    function getContextPath() {
        return "${pageContext.request.contextPath}";
    }

    // Function to load customer statistics
    function loadCustomerStats() {
        // For now, we'll show placeholder data
        // In a real application, you would fetch this from the server
        document.getElementById('totalRides').textContent = '0';
        document.getElementById('completedRides').textContent = '0';
        document.getElementById('cancelledRides').textContent = '0';
        document.getElementById('totalSpent').textContent = 'Rs. 0';

        // You can implement actual statistics loading here:
        // fetch(getContextPath() + '/CustomerServlet?action=getStats')
        //     .then(response => response.json())
        //     .then(data => {
        //         document.getElementById('totalRides').textContent = data.totalRides || '0';
        //         document.getElementById('completedRides').textContent = data.completedRides || '0';
        //         document.getElementById('cancelledRides').textContent = data.cancelledRides || '0';
        //         document.getElementById('totalSpent').textContent = 'Rs. ' + (data.totalSpent || '0');
        //     })
        //     .catch(error => {
        //         console.error('Error loading stats:', error);
        //     });
    }

    // Load statistics when page loads
    document.addEventListener('DOMContentLoaded', function() {
        loadCustomerStats();
    });
</script>
</body>
</html>
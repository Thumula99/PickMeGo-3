<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
            color: #333;
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
        }
        
        .back-btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 20px;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        
        .back-btn:hover {
            background: #2980b9;
        }
        
        .back-btn i {
            margin-right: 5px;
        }
        
        h1 {
            color: #2c3e50;
            margin: 0;
        }
        
        .card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        
        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #ecf0f1;
        }
        
        .profile-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 32px;
            font-weight: bold;
            margin-right: 25px;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }
        
        .profile-info h2 {
            margin: 0 0 5px 0;
            color: #2c3e50;
            font-size: 28px;
        }
        
        .profile-info .role-badge {
            background: #e8f5e8;
            color: #27ae60;
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
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 18px;
            display: flex;
            align-items: center;
        }
        
        .info-section h3 i {
            margin-right: 10px;
            color: #3498db;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #3498db;
        }
        
        .info-item.vehicle-info {
            border-left-color: #e74c3c;
        }
        
        .info-label {
            font-weight: 600;
            color: #7f8c8d;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 16px;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .info-value.empty {
            color: #95a5a6;
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
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 5px;
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
            <a href="${pageContext.request.contextPath}/views/driver/dashboard.jsp" class="back-btn">
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
                <h3><i class="fas fa-car"></i> Vehicle Information</h3>
                <div class="info-grid">
                    <div class="info-item vehicle-info">
                        <div class="info-label">Vehicle Type</div>
                        <div class="info-value ${empty sessionScope.user.vehicleType ? 'empty' : ''}">
                            ${empty sessionScope.user.vehicleType ? 'Not specified' : sessionScope.user.vehicleType}
                        </div>
                    </div>
                    <div class="info-item vehicle-info">
                        <div class="info-label">Vehicle Name/Model</div>
                        <div class="info-value ${empty sessionScope.user.vehicleName ? 'empty' : ''}">
                            ${empty sessionScope.user.vehicleName ? 'Not specified' : sessionScope.user.vehicleName}
                        </div>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <h3><i class="fas fa-chart-bar"></i> Driver Statistics</h3>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number" id="totalTrips">-</div>
                        <div class="stat-label">Total Trips</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="completedTrips">-</div>
                        <div class="stat-label">Completed Trips</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="currentTrips">-</div>
                        <div class="stat-label">Active Trips</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="rating">-</div>
                        <div class="stat-label">Rating</div>
                    </div>
                </div>
            </div>

            <div class="btn-group">
                <a href="profile.jsp" class="btn btn-primary">
                    <i class="fas fa-edit"></i>
                    Manage Profile
                </a>
                <a href="${pageContext.request.contextPath}/views/driver/dashboard.jsp" class="btn btn-secondary">
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

        // Function to load driver statistics
        function loadDriverStats() {
            // For now, we'll show placeholder data
            // In a real application, you would fetch this from the server
            document.getElementById('totalTrips').textContent = '0';
            document.getElementById('completedTrips').textContent = '0';
            document.getElementById('currentTrips').textContent = '0';
            document.getElementById('rating').textContent = 'N/A';
            
            // You can implement actual statistics loading here:
            // fetch(getContextPath() + '/DriverServlet?action=getStats')
            //     .then(response => response.json())
            //     .then(data => {
            //         document.getElementById('totalTrips').textContent = data.totalTrips || '0';
            //         document.getElementById('completedTrips').textContent = data.completedTrips || '0';
            //         document.getElementById('currentTrips').textContent = data.currentTrips || '0';
            //         document.getElementById('rating').textContent = data.rating || 'N/A';
            //     })
            //     .catch(error => {
            //         console.error('Error loading stats:', error);
            //     });
        }

        // Load statistics when page loads
        document.addEventListener('DOMContentLoaded', function() {
            loadDriverStats();
        });
    </script>
</body>
</html>

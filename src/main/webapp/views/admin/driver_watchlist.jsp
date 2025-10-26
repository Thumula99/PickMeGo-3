<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sliit.pickmegoweb.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Watchlist | PickMeGo Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Admin Dashboard Theme - Consistent with Admin Dashboard */
        .admin-theme {
            /* Vibrant Green Colors - Same as Admin Dashboard */
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
            font-family: var(--font-family, 'Poppins', sans-serif);
            margin: 0;
            padding: 0;
            background: var(--ash-light);
        }

        .watchlist-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px;
            background: var(--ash-light);
            min-height: 100vh;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: var(--font-weight-bold, 700);
            color: var(--black-dark);
            margin: 0 0 30px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: var(--primary);
            font-size: 1.2em;
        }
        
        .add-driver-section {
            background: white;
            padding: 24px;
            border-radius: var(--radius-sm, 8px);
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-left: 4px solid var(--primary);
        }

        .section-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px;
            background: white;
            border-radius: var(--radius-sm, 8px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .section-info {
            color: var(--ash-dark);
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: var(--font-weight-medium, 500);
            color: var(--black-dark);
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--ash-medium);
            border-radius: var(--radius-sm, 8px);
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(0, 204, 122, 0.1);
        }
        
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        
        .btn {
            padding: var(--spacing-sm, 8px) var(--spacing-md, 16px);
            border: none;
            border-radius: var(--radius-sm, 8px);
            cursor: pointer;
            font-size: 14px;
            font-weight: var(--font-weight-medium, 500);
            transition: all 0.3s ease-in-out;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin: 2px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: var(--ash-light);
            box-shadow: 0 4px 12px rgba(0, 204, 122, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-darker) 100%);
            box-shadow: 0 6px 16px rgba(0, 204, 122, 0.4);
        }
        
        .btn-success {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: var(--ash-light);
            box-shadow: 0 4px 12px rgba(0, 204, 122, 0.3);
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-darker) 100%);
            box-shadow: 0 6px 16px rgba(0, 204, 122, 0.4);
        }
        
        .btn-warning {
            background: linear-gradient(135deg, var(--secondary-accent) 0%, var(--secondary-accent-dark) 100%);
            color: var(--black-dark);
            box-shadow: 0 4px 12px rgba(250, 204, 21, 0.3);
        }
        
        .btn-warning:hover {
            background: linear-gradient(135deg, var(--secondary-accent-dark) 0%, #a68b0a 100%);
            box-shadow: 0 6px 16px rgba(250, 204, 21, 0.4);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: var(--ash-light);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #c82333 0%, #a71e2a 100%);
            box-shadow: 0 6px 16px rgba(220, 53, 69, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, var(--ash-dark) 0%, var(--ash-darker) 100%);
            color: var(--ash-light);
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.3);
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, var(--ash-darker) 0%, var(--black-light) 100%);
            box-shadow: 0 6px 16px rgba(107, 114, 128, 0.4);
        }
        
        .watchlist-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: var(--radius-sm, 8px);
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }
        
        .watchlist-table th,
        .watchlist-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid var(--ash-medium);
        }
        
        .watchlist-table th {
            background: var(--ash-light);
            font-weight: var(--font-weight-bold, 700);
            color: var(--black-dark);
            border-bottom: 2px solid var(--primary);
        }
        
        .watchlist-table tr:hover {
            background: var(--ash-light);
        }
        
        .status-active {
            background: linear-gradient(135deg, var(--primary-light) 0%, var(--primary) 100%);
            color: var(--black-dark);
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: var(--font-weight-medium, 500);
            box-shadow: 0 2px 4px rgba(0, 204, 122, 0.2);
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: var(--radius-sm, 8px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .alert-success {
            color: #155724;
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-color: #c3e6cb;
            border-left: 4px solid var(--primary);
        }
        
        .alert-danger {
            color: #721c24;
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border-color: #f5c6cb;
            border-left: 4px solid #dc3545;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background-color: white;
            padding: 0;
            border-radius: var(--radius-sm, 8px);
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .modal-header {
            padding: 20px;
            border-bottom: 1px solid var(--ash-medium);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h3 {
            margin: 0;
            color: var(--black-dark);
        }
        
        .close {
            color: var(--ash-dark);
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
        }
        
        .close:hover {
            color: var(--black-dark);
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            padding: 20px;
            border-top: 1px solid var(--ash-medium);
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: var(--ash-dark);
            background: white;
            border-radius: var(--radius-sm, 8px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .loading {
            text-align: center;
            padding: 20px;
            color: var(--ash-dark);
            background: white;
            border-radius: var(--radius-sm, 8px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .error-message {
            color: #dc3545;
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            padding: 15px;
            border-radius: var(--radius-sm, 8px);
            margin: 10px 0;
            border-left: 4px solid #dc3545;
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.1);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .watchlist-container {
                padding: 15px;
            }
            
            .section-controls {
                flex-direction: column;
                gap: 10px;
                align-items: stretch;
            }
            
            .watchlist-table {
                font-size: 12px;
            }
            
            .watchlist-table th,
            .watchlist-table td {
                padding: 8px;
            }
        }
    </style>
</head>
<body class="admin-theme">
    <div class="watchlist-container">
        <div class="section-title">
            <i class="fas fa-eye"></i>
            Driver Watchlist Management
        </div>
        
        <div class="section-controls">
            <div style="display: flex; gap: 10px; align-items: center;">
                <a href="${pageContext.request.contextPath}/views/admin/dashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
            <div class="section-info">Manage driver watchlist entries</div>
        </div>

        <!-- Success/Error Messages -->
        <div id="message-container"></div>

        <!-- Add Driver to Watchlist Section -->
        <div class="add-driver-section">
            <h3 style="margin: 0 0 20px 0; color: var(--black-dark); font-size: 1.2rem; font-weight: var(--font-weight-bold, 700); display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-plus" style="color: var(--primary);"></i> Add Driver to Watchlist
            </h3>
            <form id="add-watchlist-form">
                <div class="form-group">
                    <label for="driver-select">Select Driver:</label>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <select id="driver-select" name="driverId" required style="flex: 1;" onchange="console.log('Driver selected:', this.value, this.options[this.selectedIndex]?.textContent)">
                            <option value="">-- Select a Driver --</option>
                        </select>
                        <button type="button" class="btn btn-secondary" onclick="loadDrivers()" style="padding: 8px 12px;">
                            <i class="fas fa-sync-alt"></i> Refresh
                        </button>
                    </div>
                </div>
                <div class="form-group">
                    <label for="watchlist-reason">Reason for Watchlist:</label>
                    <textarea id="watchlist-reason" name="reason" placeholder="Enter the reason for adding this driver to the watchlist..." required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add to Watchlist
                </button>
            </form>
        </div>

        <!-- Watchlist Table -->
        <div class="add-driver-section">
            <h3 style="margin: 0 0 20px 0; color: var(--black-dark); font-size: 1.2rem; font-weight: var(--font-weight-bold, 700); display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-list" style="color: var(--primary);"></i> Current Watchlist
            </h3>
            <table class="watchlist-table" id="watchlist-table">
                <thead>
                    <tr>
                        <th>Driver Name</th>
                        <th>Driver Email</th>
                        <th>Reason</th>
                        <th>Added By</th>
                        <th>Date Added</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="watchlist-tbody">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px;">
                            <i class="fas fa-spinner fa-spin"></i> Loading watchlist...
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Remove Confirmation Modal -->
    <div id="remove-modal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Confirm Removal</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to remove this driver from the watchlist?</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                <button class="btn btn-danger" id="confirm-remove-btn">Remove</button>
            </div>
        </div>
    </div>

    <script>
        let currentRemoveId = null;

        // Load drivers and watchlist on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadDrivers();
            loadWatchlist();
        });

        // Load available drivers
        function loadDrivers() {
            console.log('Loading drivers...');
            fetch('${pageContext.request.contextPath}/AdminServlet?action=listUsers')
                .then(response => {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers);
                    return response.json();
                })
                .then(data => {
                    console.log('Driver data received:', data);
                    if (data.success && data.users) {
                        const driverSelect = document.getElementById('driver-select');
                        console.log('Driver select element:', driverSelect);
                        driverSelect.innerHTML = '<option value="">-- Select a Driver --</option>';
                        
                        let driverCount = 0;
                        data.users.forEach(user => {
                            if (user.role === 'Driver') {
                                const option = document.createElement('option');
                                // Try different possible ID field names
                                const userId = user.userId || user.id || user.UserID || user.user_id;
                                option.value = userId;
                                option.textContent = user.firstName + ' ' + user.lastName + ' (' + user.email + ')';
                                driverSelect.appendChild(option);
                                driverCount++;
                            }
                        });
                        
                        console.log('Total drivers loaded:', driverCount);
                        console.log('Driver select options count:', driverSelect.options.length);
                        
                        if (driverCount === 0) {
                            showMessage('No drivers found in the system', 'danger');
                        } else {
                            showMessage('Loaded ' + driverCount + ' drivers successfully', 'success');
                        }
                    } else {
                        console.error('Failed to load users:', data.message);
                        showMessage('Failed to load drivers: ' + (data.message || 'Unknown error'), 'danger');
                    }
                })
                .catch(error => {
                    console.error('Error loading drivers:', error);
                    showMessage('Error loading drivers', 'danger');
                });
        }

        // Load watchlist
        function loadWatchlist() {
            fetch('${pageContext.request.contextPath}/AdminServlet?action=getWatchlist', {
                method: 'POST'
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.watchlist) {
                        displayWatchlist(data.watchlist);
                    } else {
                        showMessage(data.message || 'Error loading watchlist', 'danger');
                    }
                })
                .catch(error => {
                    console.error('Error loading watchlist:', error);
                    showMessage('Error loading watchlist', 'danger');
                });
        }

        // Display watchlist in table
        function displayWatchlist(watchlist) {
            const tbody = document.getElementById('watchlist-tbody');
            
            if (watchlist.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 20px;">No drivers on watchlist</td></tr>';
                return;
            }
            
            tbody.innerHTML = watchlist.map(entry => {
                const createdDate = new Date(entry.createdDate).toLocaleDateString();
                return '<tr>' +
                    '<td>' + (entry.driverName || 'N/A') + '</td>' +
                    '<td>' + (entry.driverEmail || 'N/A') + '</td>' +
                    '<td>' + entry.reason + '</td>' +
                    '<td>' + (entry.adminName || 'N/A') + '</td>' +
                    '<td>' + createdDate + '</td>' +
                    '<td><span class="status-active">' + entry.status + '</span></td>' +
                    '<td>' +
                        '<button class="btn btn-danger" onclick="confirmRemove(' + entry.watchlistId + ')">' +
                            '<i class="fas fa-trash"></i> Remove' +
                        '</button>' +
                    '</td>' +
                '</tr>';
            }).join('');
        }

        // Handle add to watchlist form submission
        document.getElementById('add-watchlist-form').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form values directly from elements
            const driverSelect = document.getElementById('driver-select');
            const reasonTextarea = document.getElementById('watchlist-reason');
            
            const driverId = driverSelect.value;
            const reason = reasonTextarea.value;
            
            console.log('Form submission debug:');
            console.log('Driver ID:', driverId);
            console.log('Reason:', reason);
            
            // Validate inputs
            if (!driverId || driverId === '' || driverId === 'undefined') {
                showMessage('Please select a driver', 'danger');
                return;
            }
            
            if (!reason || reason.trim() === '') {
                showMessage('Please enter a reason', 'danger');
                return;
            }
            
            // Create form data
            const formData = new URLSearchParams();
            formData.append('action', 'addDriverToWatchlist');
            formData.append('driverId', driverId);
            formData.append('reason', reason.trim());
            
            console.log('Sending data:', formData.toString());
            
            fetch('${pageContext.request.contextPath}/AdminServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                console.log('Response received:', data);
                if (data.success) {
                    showMessage(data.message, 'success');
                    this.reset();
                    loadWatchlist();
                } else {
                    showMessage(data.message, 'danger');
                }
            })
            .catch(error => {
                console.error('Error adding to watchlist:', error);
                showMessage('Error adding driver to watchlist', 'danger');
            });
        });

        // Confirm removal
        function confirmRemove(watchlistId) {
            currentRemoveId = watchlistId;
            document.getElementById('remove-modal').style.display = 'block';
        }

        // Close modal
        function closeModal() {
            document.getElementById('remove-modal').style.display = 'none';
            currentRemoveId = null;
        }

        // Handle remove confirmation
        document.getElementById('confirm-remove-btn').addEventListener('click', function() {
            if (currentRemoveId) {
                const formData = new URLSearchParams();
                formData.append('action', 'removeDriverFromWatchlist');
                formData.append('watchlistId', currentRemoveId);
                
                fetch('${pageContext.request.contextPath}/AdminServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showMessage(data.message, 'success');
                        loadWatchlist();
                    } else {
                        showMessage(data.message, 'danger');
                    }
                    closeModal();
                })
                .catch(error => {
                    console.error('Error removing from watchlist:', error);
                    showMessage('Error removing driver from watchlist', 'danger');
                    closeModal();
                });
            }
        });

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('remove-modal');
            if (event.target === modal) {
                closeModal();
            }
        }

        // Close modal with X button
        document.querySelector('.close').onclick = closeModal;

        // Show message
        function showMessage(message, type) {
            const container = document.getElementById('message-container');
            const iconClass = type === 'success' ? 'check-circle' : 'exclamation-triangle';
            container.innerHTML = 
                '<div class="alert alert-' + type + '">' +
                    '<i class="fas fa-' + iconClass + '"></i>' +
                    message +
                '</div>';
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                container.innerHTML = '';
            }, 5000);
        }
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Check if user is logged in and has Operations or Admin role
    com.sliit.pickmegoweb.model.User user = (com.sliit.pickmegoweb.model.User) session.getAttribute("user");
    if (user == null || (!"Operations".equals(user.getRole()) && !"Admin".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Incident Management - Operations</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <style>
        .operations-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .page-header {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .page-header h1 {
            margin: 0;
            font-size: 2.5rem;
        }
        
        .page-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            border-left: 4px solid #e74c3c;
        }
        
        .stat-card h3 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 1.1rem;
        }
        
        .stat-card .number {
            font-size: 2rem;
            font-weight: bold;
            color: #e74c3c;
        }
        
        .filters-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
        }
        
        .filter-group label {
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .filter-group select,
        .filter-group input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background-color: #e74c3c;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #c0392b;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .incidents-table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .table-header {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .table-header h3 {
            margin: 0;
            color: #333;
        }
        
        .incidents-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .incidents-table th,
        .incidents-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        
        .incidents-table th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        .incidents-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-reported {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-under-investigation {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        
        .status-resolved {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-closed {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .severity-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .severity-low {
            background-color: #d4edda;
            color: #155724;
        }
        
        .severity-medium {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .severity-high {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .severity-critical {
            background-color: #f5c6cb;
            color: #721c24;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        
        .btn-info:hover {
            background-color: #138496;
        }
        
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #218838;
        }
        
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        
        .btn-warning:hover {
            background-color: #e0a800;
        }
        
        .no-incidents {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
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
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: none;
            border-radius: 10px;
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow-y: auto;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e74c3c;
        }
        
        .modal-header h3 {
            color: #e74c3c;
            margin: 0;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #e74c3c;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        
        .modal-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="operations-container">
        <!-- Page Header -->
        <div class="page-header">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1><i class="fas fa-exclamation-triangle"></i> Incident Management</h1>
                    <p>Monitor and manage driver incident reports</p>
                </div>
                <div style="text-align: right; color: rgba(255,255,255,0.9);">
                    <p style="margin: 0; font-size: 14px;">Welcome, <%= user.getFirstName() %> <%= user.getLastName() %></p>
                    <p style="margin: 5px 0 0 0; font-size: 12px;"><%= "Operations".equals(user.getRole()) ? "Operations Manager" : "Administrator" %></p>
                    <a href="<%= request.getContextPath() %>/UserServlet?action=logout" 
                       style="color: white; text-decoration: none; font-size: 12px; margin-top: 5px; display: inline-block;">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Statistics Cards -->
        <div class="stats-grid" id="statsGrid">
            <div class="stat-card">
                <h3>Total Incidents</h3>
                <div class="number" id="totalIncidents">-</div>
            </div>
            <div class="stat-card">
                <h3>Reported</h3>
                <div class="number" id="reportedIncidents">-</div>
            </div>
            <div class="stat-card">
                <h3>Under Investigation</h3>
                <div class="number" id="underInvestigationIncidents">-</div>
            </div>
            <div class="stat-card">
                <h3>Resolved</h3>
                <div class="number" id="resolvedIncidents">-</div>
            </div>
            <div class="stat-card">
                <h3>Closed</h3>
                <div class="number" id="closedIncidents">-</div>
            </div>
        </div>
        
        <!-- Filters Section -->
        <div class="filters-section">
            <div class="filters-grid">
                <div class="filter-group">
                    <label for="statusFilter">Filter by Status</label>
                    <select id="statusFilter" onchange="filterIncidents()">
                        <option value="">All Statuses</option>
                        <option value="Reported">Reported</option>
                        <option value="Under Investigation">Under Investigation</option>
                        <option value="Resolved">Resolved</option>
                        <option value="Closed">Closed</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="typeFilter">Filter by Type</label>
                    <select id="typeFilter" onchange="filterIncidents()">
                        <option value="">All Types</option>
                        <option value="Breakdown">Breakdown</option>
                        <option value="Accident">Accident</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="severityFilter">Filter by Severity</label>
                    <select id="severityFilter" onchange="filterIncidents()">
                        <option value="">All Severities</option>
                        <option value="Low">Low</option>
                        <option value="Medium">Medium</option>
                        <option value="High">High</option>
                        <option value="Critical">Critical</option>
                    </select>
                </div>
                <div class="filter-group">
                    <button class="btn btn-primary" onclick="refreshIncidents()">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Incidents Table -->
        <div class="incidents-table-container">
            <div class="table-header">
                <h3><i class="fas fa-list"></i> Incident Reports</h3>
            </div>
            <div id="incidentsTableContainer">
                <div class="loading">
                    <i class="fas fa-spinner fa-spin"></i> Loading incidents...
                </div>
            </div>
        </div>
    </div>
    
    <!-- Update Status Modal -->
    <div id="updateStatusModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Update Incident Status</h3>
                <span class="close" onclick="closeUpdateModal()">&times;</span>
            </div>
            <form id="updateStatusForm">
                <input type="hidden" id="updateIncidentId" name="incidentId">
                
                <div class="form-group">
                    <label for="newStatus">New Status *</label>
                    <select id="newStatus" name="status" required>
                        <option value="">Select status</option>
                        <option value="Under Investigation">Under Investigation</option>
                        <option value="Resolved">Resolved</option>
                        <option value="Closed">Closed</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="statusNotes">Notes</label>
                    <textarea id="statusNotes" name="notes" placeholder="Add any notes about the status update..."></textarea>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeUpdateModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Status</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        let allIncidents = [];
        let filteredIncidents = [];
        
        // Load incidents on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadIncidentStats();
            loadIncidents();
        });
        
        // Load incident statistics
        function loadIncidentStats() {
            fetch(getContextPath() + '/IncidentServlet?action=getIncidentStats')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    document.getElementById('totalIncidents').textContent = data.total || 0;
                    document.getElementById('reportedIncidents').textContent = data.reported || 0;
                    document.getElementById('underInvestigationIncidents').textContent = data.underInvestigation || 0;
                    document.getElementById('resolvedIncidents').textContent = data.resolved || 0;
                    document.getElementById('closedIncidents').textContent = data.closed || 0;
                })
                .catch(error => {
                    console.error('Error loading incident stats:', error);
                    // Set all stats to 0 on error
                    document.getElementById('totalIncidents').textContent = '0';
                    document.getElementById('reportedIncidents').textContent = '0';
                    document.getElementById('underInvestigationIncidents').textContent = '0';
                    document.getElementById('resolvedIncidents').textContent = '0';
                    document.getElementById('closedIncidents').textContent = '0';
                });
        }
        
        // Load all incidents
        function loadIncidents() {
            fetch(getContextPath() + '/IncidentServlet?action=getIncidents')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    allIncidents = data;
                    filteredIncidents = [...allIncidents];
                    displayIncidents();
                })
                .catch(error => {
                    console.error('Error loading incidents:', error);
                    document.getElementById('incidentsTableContainer').innerHTML = 
                        '<div class="error-message">Error loading incidents: ' + error.message + '. Please check if you are logged in and try again.</div>';
                });
        }
        
        // Display incidents in table
        function displayIncidents() {
            const container = document.getElementById('incidentsTableContainer');
            
            if (filteredIncidents.length === 0) {
                container.innerHTML = '<div class="no-incidents"><i class="fas fa-info-circle"></i><p>No incidents found.</p></div>';
                return;
            }
            
            let tableHTML = `
                <table class="incidents-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Trip ID</th>
                            <th>Driver</th>
                            <th>Type</th>
                            <th>Severity</th>
                            <th>Status</th>
                            <th>Location</th>
                            <th>Reported Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
            
            filteredIncidents.forEach(incident => {
                const reportedDate = new Date(incident.ReportedDate).toLocaleDateString();
                const statusClass = (incident.Status || 'unknown').toLowerCase().replace(' ', '-');
                const severityClass = (incident.Severity || 'unknown').toLowerCase();
                
                tableHTML += `
                    <tr>
                        <td>#${incident.IncidentID}</td>
                        <td>#${incident.TripID}</td>
                        <td>${incident.DriverName || 'Unknown'}</td>
                        <td>${incident.IncidentType || 'Unknown'}</td>
                        <td><span class="severity-badge severity-${severityClass}">${incident.Severity || 'Unknown'}</span></td>
                        <td><span class="status-badge status-${statusClass}">${incident.Status || 'Unknown'}</span></td>
                        <td>${incident.Location || 'Unknown'}</td>
                        <td>${reportedDate}</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn btn-info btn-sm" onclick="viewIncidentDetails(${incident.IncidentID})" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-warning btn-sm" onclick="openUpdateModal(${incident.IncidentID})" title="Update Status">
                                    <i class="fas fa-edit"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
            });
            
            tableHTML += '</tbody></table>';
            container.innerHTML = tableHTML;
        }
        
        // Filter incidents
        function filterIncidents() {
            const statusFilter = document.getElementById('statusFilter').value;
            const typeFilter = document.getElementById('typeFilter').value;
            const severityFilter = document.getElementById('severityFilter').value;
            
            filteredIncidents = allIncidents.filter(incident => {
                const statusMatch = !statusFilter || (incident.Status || '') === statusFilter;
                const typeMatch = !typeFilter || (incident.IncidentType || '') === typeFilter;
                const severityMatch = !severityFilter || (incident.Severity || '') === severityFilter;
                
                return statusMatch && typeMatch && severityMatch;
            });
            
            displayIncidents();
        }
        
        // Refresh incidents
        function refreshIncidents() {
            loadIncidentStats();
            loadIncidents();
        }
        
        // View incident details
        function viewIncidentDetails(incidentId) {
            fetch(getContextPath() + '/IncidentServlet?action=getIncidentById&incidentId=' + incidentId)
                .then(response => response.json())
                .then(incident => {
                    let detailsHTML = `
                        <div style="padding: 20px;">
                            <h3>Incident Details #${incident.incidentId}</h3>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px;">
                                <div>
                                    <strong>Trip ID:</strong> #${incident.tripId}<br>
                                    <strong>Driver:</strong> ${incident.driverName || 'Unknown'}<br>
                                    <strong>Type:</strong> ${incident.incidentType}<br>
                                    <strong>Severity:</strong> <span class="severity-badge severity-${incident.severity.toLowerCase()}">${incident.severity}</span><br>
                                    <strong>Status:</strong> <span class="status-badge status-${incident.status.toLowerCase().replace(' ', '-')}">${incident.status}</span>
                                </div>
                                <div>
                                    <strong>Location:</strong> ${incident.location}<br>
                                    <strong>Coordinates:</strong> ${incident.latitude}, ${incident.longitude}<br>
                                    <strong>Reported:</strong> ${new Date(incident.reportedDate).toLocaleString()}<br>
                                    ${incident.resolvedDate ? '<strong>Resolved:</strong> ' + new Date(incident.resolvedDate).toLocaleString() + '<br>' : ''}
                                </div>
                            </div>
                            <div style="margin-top: 20px;">
                                <strong>Description:</strong><br>
                                <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin-top: 10px;">
                                    ${incident.description}
                                </div>
                            </div>
                            ${incident.notes ? `
                                <div style="margin-top: 20px;">
                                    <strong>Notes:</strong><br>
                                    <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin-top: 10px;">
                                        ${incident.notes}
                                    </div>
                                </div>
                            ` : ''}
                        </div>
                    `;
                    
                    // Create a modal for details
                    const modal = document.createElement('div');
                    modal.className = 'modal';
                    modal.style.display = 'block';
                    modal.innerHTML = `
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3><i class="fas fa-info-circle"></i> Incident Details</h3>
                                <span class="close" onclick="this.closest('.modal').remove()">&times;</span>
                            </div>
                            ${detailsHTML}
                        </div>
                    `;
                    document.body.appendChild(modal);
                    
                    // Close modal when clicking outside
                    modal.onclick = function(event) {
                        if (event.target === modal) {
                            modal.remove();
                        }
                    };
                })
                .catch(error => {
                    console.error('Error loading incident details:', error);
                    alert('Error loading incident details.');
                });
        }
        
        // Open update status modal
        function openUpdateModal(incidentId) {
            document.getElementById('updateIncidentId').value = incidentId;
            document.getElementById('updateStatusModal').style.display = 'block';
        }
        
        // Close update modal
        function closeUpdateModal() {
            document.getElementById('updateStatusModal').style.display = 'none';
            document.getElementById('updateStatusForm').reset();
        }
        
        // Handle update status form submission
        document.getElementById('updateStatusForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const updateData = {
                action: 'updateIncidentStatus',
                incidentId: formData.get('incidentId'),
                status: formData.get('status'),
                notes: formData.get('notes')
            };
            
            fetch(getContextPath() + '/IncidentServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(updateData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Incident status updated successfully!');
                    closeUpdateModal();
                    refreshIncidents();
                } else {
                    alert('Failed to update incident status: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error updating incident status:', error);
                alert('Error updating incident status. Please try again.');
            });
        });
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('updateStatusModal');
            if (event.target === modal) {
                closeUpdateModal();
            }
        }
        
        // Get context path
        function getContextPath() {
            return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
        }
    </script>
</body>
</html>

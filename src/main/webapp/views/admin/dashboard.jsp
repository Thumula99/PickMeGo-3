<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sliit.pickmegoweb.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - PickMeGo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Admin Dashboard Theme - Consistent with Customer Dashboard */
        .admin-theme {
            /* Vibrant Green Colors - Same as Customer Dashboard */
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

        .dashboard-container {
            display: flex;
            min-height: 100vh;
            background: var(--ash-light);
            margin: 0;
            overflow: hidden;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, var(--black-medium) 0%, var(--black-dark) 100%);
            color: var(--ash-light);
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
        }

        .sidebar-title {
            font-size: 1.5rem;
            font-weight: var(--font-weight-bold, 700);
            color: var(--ash-light);
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .sidebar-title i {
            color: var(--primary);
            font-size: 1.2em;
        }

        .sidebar-nav {
            flex: 1;
            padding: 20px 0;
        }

        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: var(--ash-light);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            margin: 2px 0;
        }

        .nav-item:hover {
            background: rgba(0, 204, 122, 0.1);
            border-left-color: var(--primary);
            color: var(--primary-light);
        }

        .nav-item.active {
            background: var(--primary);
            border-left-color: var(--primary-light);
            color: var(--ash-light);
            box-shadow: 0 2px 8px rgba(0, 204, 122, 0.3);
        }

        .nav-item i {
            margin-right: 12px;
            font-size: 1.1em;
            width: 20px;
            text-align: center;
        }

        /* Main Content Area */
        .main-content {
            flex: 1;
            background: var(--ash-light);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .content-header {
            background: var(--ash-light);
            padding: 20px 30px;
            border-bottom: 1px solid var(--ash-medium);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .content-title {
            font-size: 1.8rem;
            font-weight: var(--font-weight-bold, 700);
            color: var(--black-dark);
            margin: 0;
        }

        .header-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .refresh-btn {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: var(--ash-light);
            border: none;
            padding: 10px 20px;
            border-radius: var(--radius-sm, 8px);
            cursor: pointer;
            font-weight: var(--font-weight-medium, 500);
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 204, 122, 0.3);
        }

        .refresh-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 204, 122, 0.4);
        }

        .refresh-btn i {
            margin-right: 8px;
        }

        .logout-btn {
            background: linear-gradient(135deg, #dc3545 0%, #a5061e 100%);
            color: var();
            border: none;
            padding: 10px 20px;
            border-radius: var(--radius-sm, 8px);
            cursor: pointer;
            font-weight: var(--font-weight-medium, 500);
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4);
        }

        .logout-btn i {
            margin-right: 8px;
        }

        .content-body {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }

        /* Dropdown Menu Styles */
        .nav-dropdown {
            position: relative;
            flex: 1;
        }

        .dropdown-toggle {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
        }

        .dropdown-toggle i:last-child {
            margin-left: 8px;
            margin-right: 0;
            font-size: 0.9em;
            transition: transform 0.3s ease;
        }

        .dropdown-toggle.active i:last-child {
            transform: rotate(180deg);
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: var(--ash-light);
            border: 1px solid var(--ash-medium);
            border-radius: var(--radius-sm, 8px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease-in-out;
            margin-top: 4px;
        }

        .dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            padding: var(--spacing-sm, 8px) var(--spacing-md, 16px);
            color: var(--ash-dark);
            text-decoration: none;
            transition: all 0.3s ease;
            border-bottom: 1px solid var(--ash-medium);
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-item:hover {
            background: linear-gradient(90deg, var(--primary-light) 0%, rgba(51, 255, 153, 0.2) 100%);
            color: var(--black-dark);
            transform: translateX(4px);
        }

        .dropdown-item i {
            margin-right: var(--spacing-sm, 8px);
            font-size: 1em;
            width: 16px;
            text-align: center;
        }

        /* Mobile responsiveness for dropdowns */
        @media (max-width: 768px) {
            .nav-tabs {
                flex-direction: column;
                gap: 8px;
            }
            
            .nav-dropdown {
                width: 100%;
            }
            
            .dropdown-menu {
                position: static;
                opacity: 1;
                visibility: visible;
                transform: none;
                box-shadow: none;
                border: none;
                background: transparent;
                margin-top: 0;
                display: none;
            }
            
            .dropdown-menu.show {
                display: block;
            }
            
            .dropdown-item {
                padding: var(--spacing-sm, 8px) var(--spacing-md, 16px);
                background: var(--ash-light);
                margin: 2px 0;
                border-radius: var(--radius-sm, 8px);
                border: 1px solid var(--ash-medium);
            }
        }

        /* Enhanced dropdown animations */
        .dropdown-menu {
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Hover effects for dropdown toggle */
        .dropdown-toggle:hover {
            background: linear-gradient(90deg, var(--primary-light) 0%, rgba(51, 255, 153, 0.2) 100%);
            color: var(--black-dark);
        }

        .dropdown-toggle.active {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: var(--ash-light);
            box-shadow: 0 4px 15px rgba(0, 204, 122, 0.3);
        }
        
        .tab-content {
            display: none;
            background: transparent;
            padding: 0;
            border-radius: 0;
            box-shadow: none;
            border: none;
        }
        
        .tab-content.active {
            display: block;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: var(--font-weight-bold, 700);
            color: var(--black-dark);
            margin: 30px 0 20px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--primary);
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
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: var(--spacing-lg, 24px);
            margin-bottom: var(--spacing-xl, 32px);
        }
        
        .stat-card {
            background: white;
            padding: var(--spacing-lg, 24px);
            border-radius: var(--radius-sm, 8px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border-left: 4px solid var(--primary);
            transition: all 0.3s ease-in-out;
            text-align: left;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: 120px;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .stat-icon {
            color: var(--primary);
            font-size: 2rem;
            margin-bottom: var(--spacing-sm, 8px);
        }

        .stat-number {
            color: var(--black-dark);
            font-size: 2rem;
            font-weight: var(--font-weight-bold, 700);
            margin-bottom: var(--spacing-xs, 4px);
        }

        .stat-label {
            color: var(--ash-dark);
            font-weight: var(--font-weight-medium, 500);
            font-size: 1rem;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            display: table !important;
            visibility: visible !important;
            opacity: 1 !important;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }

        .data-table th,
        .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }

        .data-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }

        .data-table tr:hover {
            background: #f8f9fa;
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
        
        .btn-info {
            background: linear-gradient(135deg, var(--black-light) 0%, var(--black-medium) 100%);
            color: var(--ash-light);
            box-shadow: 0 4px 12px rgba(31, 41, 55, 0.3);
        }
        
        .btn-info:hover {
            background: linear-gradient(135deg, var(--black-medium) 0%, var(--black-dark) 100%);
            box-shadow: 0 6px 16px rgba(31, 41, 55, 0.4);
        }

        .btn-sm {
            padding: var(--spacing-xs, 4px) var(--spacing-sm, 8px);
            font-size: 12px;
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

        /* Fix for rotating buttons in incident table */
        .data-table .btn {
            transform: none !important;
            animation: none !important;
            transition: all 0.3s ease-in-out;
        }

        .data-table .btn:hover {
            transform: translateY(-2px) !important;
            animation: none !important;
        }

        .data-table .btn i {
            transform: none !important;
            animation: none !important;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-pending { background: #fff3cd; color: #856404; }
        .status-accepted { background: #d1ecf1; color: #0c5460; }
        .status-inprogress { background: #d4edda; color: #155724; }
        .status-completed { background: #d1ecf1; color: #0c5460; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        
        .role-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .role-customer { background: #d4edda; color: #155724; }
        .role-driver { background: #d1ecf1; color: #0c5460; }
        .role-admin { background: #f8d7da; color: #721c24; }
        .role-operations { background: #fff3cd; color: #856404; }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }

        .error-message {
            color: #dc3545;
            background: #f8d7da;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
        }
        
        .loading {
            text-align: center;
            padding: 20px;
            color: #6c757d;
        }
        
        /* Ensure users table container is visible */
        #usersTable {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            min-height: 100px;
        }

        #incidentsTable {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            min-height: 100px;
        }

        /* Modal Styles */
        .modal {
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
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .modal-header {
            padding: 20px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            margin: 0;
            color: #2c3e50;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
        }

        .close:hover {
            color: #000;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            padding: 20px;
            border-top: 1px solid #dee2e6;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #495057;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        /* Tab Controls */
        .tab-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 6px;
            border: 1px solid #dee2e6;
        }

        .tab-controls .btn {
            margin: 0 5px;
        }

        .user-count-info {
            color: #6c757d;
            font-size: 14px;
        }

        .info-text {
            font-style: italic;
        }

        /* Large modal for user details */
        .modal-large {
            max-width: 700px;
        }

        /* User details styling */
        .user-details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .user-detail-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border-left: 4px solid #007bff;
        }

        .user-detail-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .user-detail-value {
            color: #2c3e50;
            font-size: 16px;
        }

        .user-detail-full-width {
            grid-column: 1 / -1;
        }

        .user-role-badge-large {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
        }

        /* Incident-specific styling */
        .incident-details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .incident-detail-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border-left: 4px solid #dc3545;
        }

        .incident-detail-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .incident-detail-value {
            color: #2c3e50;
            font-size: 16px;
        }

        .incident-detail-full-width {
            grid-column: 1 / -1;
        }

        .severity-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .severity-low {
            background: #d4edda;
            color: #155724;
        }

        .severity-medium {
            background: #fff3cd;
            color: #856404;
        }

        .severity-high {
            background: #f8d7da;
            color: #721c24;
        }

        .severity-critical {
            background: #721c24;
            color: white;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .status-reported {
            background: #cce5ff;
            color: #004085;
        }

        .status-under-investigation {
            background: #fff3cd;
            color: #856404;
        }

        .status-resolved {
            background: #d4edda;
            color: #155724;
        }

        .status-closed {
            background: #e2e3e5;
            color: #383d41;
        }

        /* Notice-specific styling */
        .notice-details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .notice-detail-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border-left: 4px solid #007bff;
        }

        .notice-detail-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .notice-detail-value {
            color: #2c3e50;
            font-size: 16px;
        }

        .notice-detail-full-width {
            grid-column: 1 / -1;
        }

        /* Notice badges */
        .type-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .type-general {
            background: #e3f2fd;
            color: #1565c0;
        }

        .type-maintenance {
            background: #fff3e0;
            color: #ef6c00;
        }

        .type-service {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .type-emergency {
            background: #ffebee;
            color: #c62828;
        }

        .priority-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .priority-low {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .priority-normal {
            background: #e3f2fd;
            color: #1565c0;
        }

        .priority-high {
            background: #fff3e0;
            color: #ef6c00;
        }

        .priority-critical {
            background: #ffebee;
            color: #c62828;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        /* Delete Button Group Styles */
        .delete-btn-group {
            position: relative;
            display: inline-block;
        }
        
        .delete-btn-group .btn {
            margin-right: 0;
        }
    </style>
</head>
<body class="admin-theme">
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h1 class="sidebar-title">
                    <i class="fas fa-cog"></i> PickMeGo Admin
                </h1>
                </div>
            <nav class="sidebar-nav">
                <a href="#" class="nav-item active" onclick="showTab('overview')">
                    <i class="fas fa-chart-pie"></i> Overview
                </a>
                <a href="#" class="nav-item" onclick="showTab('users')">
                    <i class="fas fa-users"></i> Users
                </a>
                <a href="#" class="nav-item" onclick="showTab('trips')">
                    <i class="fas fa-route"></i> Trips
                </a>
                <a href="#" class="nav-item" onclick="showTab('incidents')">
                    <i class="fas fa-exclamation-triangle"></i> Incidents
                </a>
                <a href="#" class="nav-item" onclick="showTab('notices')">
                    <i class="fas fa-bullhorn"></i> Notices
                </a>
            </nav>
                </div>

        <!-- Main Content Area -->
        <div class="main-content">
            <div class="content-header">
                <h2 class="content-title">Admin Dashboard</h2>
                <div class="header-actions">
                    <button class="refresh-btn" onclick="refreshAll()">
                        <i class="fas fa-sync-alt"></i> Refresh All
                    </button>
                    <button class="logout-btn" onclick="logout()">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
            </div>
        </div>
            <div class="content-body">
            
            <!-- Overview Tab -->
            <div id="overview" class="tab-content active">
                <h2 class="section-title">Dashboard Overview</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon">
                <i class="fas fa-users"></i>
            </div>
                        <div class="stat-number" id="totalUsers">-</div>
                        <div class="stat-label">Total Users</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                <i class="fas fa-route"></i>
            </div>
                        <div class="stat-number" id="totalTrips">-</div>
                        <div class="stat-label">Total Trips</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">
                <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="stat-number" id="totalIncidents">-</div>
                        <div class="stat-label">Total Incidents</div>
            </div>
        </div>
        
                <h2 class="section-title">User Management</h2>
                <div class="section-controls">
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <button class="btn btn-success" onclick="openCreateUserModal()">
                            <i class="fas fa-plus"></i> Add User
                </button>
                        <button class="btn btn-primary" onclick="refreshUsers()">
                            <i class="fas fa-sync-alt"></i> Refresh
                </button>
                        <a href="${pageContext.request.contextPath}/views/admin/driver_watchlist.jsp" class="btn btn-warning">
                            <i class="fas fa-eye"></i> Driver Watchlist
                        </a>
                    </div>
                    <div class="section-info">Viewing all registered users</div>
                </div>
                <div class="data-table-container">
                    <div id="usersTable">Loading users...</div>
                </div>

            </div>
            
            <!-- Users Tab -->
            <div id="users" class="tab-content">
                <h2 class="section-title">User Management</h2>
                <div class="section-controls">
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <button class="btn btn-success" onclick="openCreateUserModal()">
                            <i class="fas fa-plus"></i> Add New User
                </button>
                        <button class="btn btn-primary" onclick="refreshUsers()">
                            <i class="fas fa-sync-alt"></i> Refresh Users
                </button>
                        <a href="${pageContext.request.contextPath}/views/admin/driver_watchlist.jsp" class="btn btn-warning">
                            <i class="fas fa-eye"></i> Driver Watchlist
                        </a>
                    </div>
                    <div class="section-info">Viewing all registered users</div>
                </div>
                <div class="data-table-container">
                    <div id="usersTableDetailed">Loading users...</div>
                </div>
            </div>
            
            <!-- Trips Tab -->
            <div id="trips" class="tab-content">
                <h2 class="section-title">Trip Management</h2>
                <div class="section-controls">
                    <div>
                        <button class="btn btn-primary" onclick="refreshTrips()">
                            <i class="fas fa-sync-alt"></i> Refresh Trips
                        </button>
                        <button class="btn btn-success" onclick="exportTrips()">
                            <i class="fas fa-download"></i> Export Trips
                        </button>
                    </div>
                    <div class="section-info">Viewing all trip records</div>
                    </div>
                <div class="data-table-container">
                    <div id="tripsTable">Loading trips...</div>
                    </div>
                    </div>

        <!-- Incidents Tab -->
        <div id="incidents" class="tab-content">
            <h2>Incident Management</h2>
            <button class="btn btn-primary" onclick="refreshIncidents()">
                <i class="fas fa-sync-alt"></i> Refresh Incidents
            </button>
            <div id="incidentsTable" class="loading">Loading incidents...</div>
                </div>
                
        <!-- Notices Tab -->
        <div id="notices" class="tab-content">
            <h2 class="section-title">Notice Management</h2>
            <div class="section-controls">
                <div>
                    <button class="btn btn-success" onclick="openCreateNoticeModal()">
                        <i class="fas fa-plus"></i> Create Notice
                    </button>
                    <button class="btn btn-primary" onclick="refreshNotices()">
                        <i class="fas fa-sync-alt"></i> Refresh Notices
                        </button>
                    </div>
                <div class="section-info">Manage announcements and notices for customers</div>
                        </div>
            <div class="data-table-container">
                <div id="noticesTable">Loading notices...</div>
                    </div>
                </div>
            </div>
            
    <!-- Create User Modal -->
    <div id="createUserModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-user-plus"></i> Create New User</h3>
                <span class="close" onclick="closeCreateUserModal()">&times;</span>
                    </div>
            <div class="modal-body">
                <form id="createUserForm">
                    <div class="form-group">
                        <label for="createFirstName">First Name:</label>
                        <input type="text" id="createFirstName" name="firstName" required>
                        </div>
                    <div class="form-group">
                        <label for="createLastName">Last Name:</label>
                        <input type="text" id="createLastName" name="lastName" required>
                    </div>
                    <div class="form-group">
                        <label for="createEmail">Email:</label>
                        <input type="email" id="createEmail" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="createPassword">Password:</label>
                        <input type="password" id="createPassword" name="password" required>
                    </div>
                    <div class="form-group">
                        <label for="createPhone">Phone Number:</label>
                        <input type="text" id="createPhone" name="phoneNumber">
                    </div>
                    <div class="form-group">
                        <label for="createRole">Role:</label>
                        <select id="createRole" name="role" required>
                            <option value="">Select Role</option>
                            <option value="Customer">Customer</option>
                            <option value="Driver">Driver</option>
                            <option value="Admin">Admin</option>
                            <option value="Operations">Operations</option>
                            <option value="Finance">Finance</option>
                            <option value="Feedback">Feedback</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeCreateUserModal()">Cancel</button>
                <button type="button" class="btn btn-success" onclick="submitCreateUser()">Create User</button>
            </div>
                </div>
            </div>
            
    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-user-edit"></i> Edit User</h3>
                <span class="close" onclick="closeEditUserModal()">&times;</span>
                    </div>
            <div class="modal-body">
                <form id="editUserForm">
                    <input type="hidden" id="editUserId" name="userId">
                    <div class="form-group">
                        <label for="editFirstName">First Name:</label>
                        <input type="text" id="editFirstName" name="firstName" required>
                        </div>
                    <div class="form-group">
                        <label for="editLastName">Last Name:</label>
                        <input type="text" id="editLastName" name="lastName" required>
                    </div>
                    <div class="form-group">
                        <label for="editEmail">Email:</label>
                        <input type="email" id="editEmail" name="email" required>
                </div>
                    <div class="form-group">
                        <label for="editPhone">Phone Number:</label>
                        <input type="text" id="editPhone" name="phoneNumber">
            </div>
                    <div class="form-group">
                        <label for="editRole">Role:</label>
                        <select id="editRole" name="role" required>
                            <option value="">Select Role</option>
                            <option value="Customer">Customer</option>
                            <option value="Driver">Driver</option>
                            <option value="Admin">Admin</option>
                            <option value="Operations">Operations</option>
                            <option value="Finance">Finance</option>
                            <option value="Feedback">Feedback</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeEditUserModal()">Cancel</button>
                <button type="button" class="btn btn-warning" onclick="submitEditUser()">Update User</button>
            </div>
                </div>
            </div>
            
    <!-- View User Details Modal -->
    <div id="viewUserModal" class="modal" style="display: none;">
        <div class="modal-content modal-large">
            <div class="modal-header">
                <h3><i class="fas fa-user"></i> User Details</h3>
                <span class="close" onclick="closeViewUserModal()">&times;</span>
                    </div>
            <div class="modal-body">
                <div id="userDetailsContent">
                    <!-- User details will be loaded here -->
                    </div>
                    </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeViewUserModal()">Close</button>
                <button type="button" class="btn btn-warning" onclick="editUserFromDetails()">
                    <i class="fas fa-edit"></i> Edit User
                        </button>
                    </div>
                    </div>
                </div>
                
    <!-- View Incident Details Modal -->
    <div id="viewIncidentModal" class="modal" style="display: none;">
        <div class="modal-content modal-large">
            <div class="modal-header">
                <h3><i class="fas fa-exclamation-triangle"></i> Incident Details</h3>
                <span class="close" onclick="closeViewIncidentModal()">&times;</span>
                </div>
            <div class="modal-body">
                <div id="incidentDetailsContent">
                    <!-- Incident details will be loaded here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeViewIncidentModal()">Close</button>
                <button type="button" class="btn btn-warning" onclick="updateIncidentStatus()">
                    <i class="fas fa-edit"></i> Update Status
                </button>
                <button type="button" class="btn btn-danger" onclick="deleteIncidentFromDetails()">
                    <i class="fas fa-trash"></i> Delete Incident
                        </button>
                    </div>
                        </div>
                    </div>
    
    <!-- Create Notice Modal -->
    <div id="createNoticeModal" class="modal" style="display: none;">
        <div class="modal-content modal-large">
            <div class="modal-header">
                <h3><i class="fas fa-bullhorn"></i> Create New Notice</h3>
                <span class="close" onclick="closeCreateNoticeModal()">&times;</span>
                </div>
            <div class="modal-body">
                <form id="createNoticeForm">
                    <div class="form-group">
                        <label for="noticeTitle">Title *</label>
                        <input type="text" id="noticeTitle" name="title" required maxlength="200" placeholder="Enter notice title">
            </div>
                    <div class="form-group">
                        <label for="noticeMessage">Message *</label>
                        <textarea id="noticeMessage" name="message" required maxlength="1000" rows="4" placeholder="Enter notice message"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="noticeType">Notice Type</label>
                        <select id="noticeType" name="noticeType">
                            <option value="General">General</option>
                            <option value="Maintenance">Maintenance</option>
                            <option value="Service">Service</option>
                            <option value="Emergency">Emergency</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="noticePriority">Priority</label>
                        <select id="noticePriority" name="priority">
                            <option value="Low">Low</option>
                            <option value="Normal" selected>Normal</option>
                            <option value="High">High</option>
                            <option value="Critical">Critical</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="targetAudience">Target Audience</label>
                        <select id="targetAudience" name="targetAudience">
                            <option value="All" selected>All Users</option>
                            <option value="Customers">Customers Only</option>
                            <option value="Drivers">Drivers Only</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="expiryDate">Expiry Date (Optional)</label>
                        <input type="datetime-local" id="expiryDate" name="expiryDate">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeCreateNoticeModal()">Cancel</button>
                <button type="button" class="btn btn-success" onclick="submitCreateNotice()">
                    <i class="fas fa-plus"></i> Create Notice
                </button>
            </div>
        </div>
    </div>

    <!-- View Notice Details Modal -->
    <div id="viewNoticeModal" class="modal" style="display: none;">
        <div class="modal-content modal-large">
            <div class="modal-header">
                <h3><i class="fas fa-bullhorn"></i> Notice Details</h3>
                <span class="close" onclick="closeViewNoticeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div id="noticeDetailsContent">
                    <!-- Notice details will be loaded here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeViewNoticeModal()">Close</button>
                <button type="button" class="btn btn-warning" onclick="editNoticeFromDetails()">
                    <i class="fas fa-edit"></i> Edit Notice
                </button>
            </div>
        </div>
    </div>
    
    <script>
        // Simple, working admin dashboard JavaScript
        console.log('Admin Dashboard JavaScript Loading...');

        // Get context path
        function getContextPath() {
            return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
        }

        // Simple tab switching function
        function showTab(tabName) {
            console.log('Switching to tab:', tabName);

            // Hide all tab contents
            const tabContents = document.querySelectorAll('.tab-content');
            tabContents.forEach(tab => tab.classList.remove('active'));
            
            // Remove active class from all nav items
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => item.classList.remove('active'));
            
            // Show selected tab content
            const targetTab = document.getElementById(tabName);
            if (targetTab) {
                targetTab.classList.add('active');
            }

            // Add active class to clicked nav item
            const clickedItem = event.target.closest('.nav-item');
            if (clickedItem) {
                clickedItem.classList.add('active');
            }
            
            // Load data for the selected tab
            switch(tabName) {
                case 'overview':
                    loadOverviewData();
                    break;
                case 'users':
                    loadUsersData();
                    break;
                case 'trips':
                    loadTripsData();
                    break;
                case 'incidents':
                    loadIncidentsData();
                    break;
                case 'notices':
                    loadNoticesData();
                    break;
            }
        }

        // Refresh all data
        function refreshAll() {
            loadOverviewData();
            loadUsersData();
            loadTripsData();
            loadIncidentsData();
            loadNoticesData();
        }

        // Logout function
        function logout() {
            console.log('Logging out...');
            
            // Show confirmation dialog
            if (confirm('Are you sure you want to logout?')) {
                // Clear any stored session data
                sessionStorage.clear();
                localStorage.clear();
                
                // Redirect to login page
                window.location.href = getContextPath() + '/views/login.jsp';
            }
        }
        
        // Dropdown toggle function
        function toggleDropdown(dropdownName) {
            console.log('Toggling dropdown:', dropdownName);
            
            // Close all other dropdowns
            const allDropdowns = document.querySelectorAll('.dropdown-menu');
            const allToggles = document.querySelectorAll('.dropdown-toggle');
            
            allDropdowns.forEach(dropdown => {
                if (dropdown.id !== dropdownName + '-dropdown') {
                    dropdown.classList.remove('show');
                }
            });
            
            allToggles.forEach(toggle => {
                if (!toggle.textContent.includes(dropdownName.charAt(0).toUpperCase() + dropdownName.slice(1))) {
                    toggle.classList.remove('active');
                }
            });
            
            // Toggle the clicked dropdown
            const dropdown = document.getElementById(dropdownName + '-dropdown');
            const toggle = event.target.closest('.dropdown-toggle');
            
            if (dropdown && toggle) {
                dropdown.classList.toggle('show');
                toggle.classList.toggle('active');
            }
        }

        // Close dropdowns when clicking outside
        document.addEventListener('click', function(event) {
            if (!event.target.closest('.nav-dropdown')) {
                const allDropdowns = document.querySelectorAll('.dropdown-menu');
                const allToggles = document.querySelectorAll('.dropdown-toggle');
                
                allDropdowns.forEach(dropdown => dropdown.classList.remove('show'));
                allToggles.forEach(toggle => toggle.classList.remove('active'));
            }
        });

        // Refresh functions
        function refreshOverview() {
            loadOverviewData();
        }

        function refreshUsers() {
            loadUsersData();
        }

        function exportTrips() {
            console.log('Exporting trips...');
            // For now, just show an alert. In a real implementation, this would generate a CSV/Excel file
            alert('Trip export functionality will be implemented here. This would generate a CSV or Excel file with all trip data.');
        }

        function viewTripDetails(tripId) {
            console.log('Viewing trip details for:', tripId);
            // For now, show an alert. In a real implementation, this would open a modal with trip details
            alert('Trip details for Trip #' + tripId + ' will be displayed here. This would show pickup/dropoff locations, timing, fare breakdown, etc.');
        }

        function editTripStatus(tripId) {
            console.log('Editing trip status for:', tripId);
            // For now, show an alert. In a real implementation, this would open a modal to change trip status
            alert('Edit trip status for Trip #' + tripId + ' will be implemented here. This would allow changing status to Completed, Cancelled, etc.');
        }

        function refreshIncidents() {
            loadIncidentsData();
        }

        // Simple data loading functions
        function loadOverviewData() {
            console.log('Loading overview data...');

            // Load user count
            fetch(getContextPath() + '/AdminServlet?action=getUserCount')
                .then(response => response.json())
                .then(data => {
                    const userCountElement = document.getElementById('totalUsers');
                    if (userCountElement) {
                        userCountElement.textContent = data.count || 0;
                    }
                })
                .catch(error => console.error('Error loading user count:', error));
            
            // Load trip count
            fetch(getContextPath() + '/AdminServlet?action=getTripCount')
                .then(response => response.json())
                .then(data => {
                    const tripCountElement = document.getElementById('totalTrips');
                    if (tripCountElement) {
                        tripCountElement.textContent = data.count || 0;
                    }
                })
                .catch(error => console.error('Error loading trip count:', error));
            
            // Load incident count
            fetch(getContextPath() + '/IncidentServlet?action=getIncidentStats')
                .then(response => response.json())
                .then(data => {
                    const incidentCountElement = document.getElementById('totalIncidents');
                    if (incidentCountElement) {
                        incidentCountElement.textContent = data.total || 0;
                    }
                })
                .catch(error => console.error('Error loading incident stats:', error));
        }
        
        function loadUsersData() {
            console.log('Loading users data...');
            const container = document.getElementById('usersTable');
            const detailedContainer = document.getElementById('usersTableDetailed');
            
            if (!container) {
                console.error('usersTable container not found!');
                return;
            }
            
            container.innerHTML = '<div class="loading">Loading users...</div>';
            if (detailedContainer) {
                detailedContainer.innerHTML = '<div class="loading">Loading users...</div>';
            }

            fetch(getContextPath() + '/AdminServlet?action=getUsersByRole&role=All')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Raw data received:', data);
                    console.log('Data type:', typeof data);
                    console.log('Is array:', Array.isArray(data));
                    
                    // Handle different response formats
                    let users = data;
                    if (data && typeof data === 'object' && !Array.isArray(data)) {
                        // If response is an object with success property, extract the data
                        if (data.success === false) {
                            throw new Error(data.message || 'API returned error');
                        }
                        // If it's an object but not an array, it might be a single user or error
                        if (data.users) {
                            users = data.users;
                        } else if (data.user) {
                            users = [data.user];
                    } else {
                            users = [data]; // Single user object
                    }
                    }

                    console.log('Processed users:', users);
                    console.log('Users count:', users ? users.length : 'null/undefined');

                    displayUsersTable(users);
                    if (detailedContainer) {
                        displayUsersTableDetailed(users);
                    }
                })
                .catch(error => {
                    console.error('Error loading users:', error);
                    container.innerHTML = '<div class="error-message">Error loading users: ' + error.message + '</div>';
                    if (detailedContainer) {
                        detailedContainer.innerHTML = '<div class="error-message">Error loading users: ' + error.message + '</div>';
                    }
                });
        }

        function loadTripsData() {
            console.log('Loading trips data...');
            const container = document.getElementById('tripsTable');

            fetch(getContextPath() + '/AdminServlet?action=listTrips')
                .then(response => response.json())
                .then(data => {
                    console.log('Trips data received:', data);
                    displayTripsTable(data);
                })
                .catch(error => {
                    console.error('Error loading trips:', error);
                    container.innerHTML = '<div class="error-message">Error loading trips: ' + error.message + '</div>';
                });
        }
        
        function loadIncidentsData() {
            console.log('Loading incidents data...');
            const container = document.getElementById('incidentsTable');
            
            if (!container) {
                console.error('incidentsTable container not found!');
                return;
            }
            
            container.innerHTML = '<div class="loading">Loading incidents...</div>';

            fetch(getContextPath() + '/AdminServlet?action=getAllIncidents')
                .then(response => {
                    console.log('Incidents response status:', response.status);
                    console.log('Incidents response ok:', response.ok);
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Incidents data received:', data);
                    console.log('Incidents data type:', typeof data);
                    console.log('Incidents data length:', Array.isArray(data) ? data.length : 'Not an array');
                    displayIncidentsTable(data);
                })
                .catch(error => {
                    console.error('Error loading incidents:', error);
                    container.innerHTML = '<div class="error-message">Error loading incidents: ' + error.message + '</div>';
                });
        }

        // Simple table display functions
        function displayUsersTableDetailed(users) {
            const container = document.getElementById('usersTableDetailed');

            if (!container) {
                console.error('usersTableDetailed container not found in displayUsersTableDetailed!');
                return;
            }
            
            if (!users || users.length === 0) {
                container.innerHTML = '<div class="no-data">No users found.</div>';
                return;
            }

            let tableHTML = '<table class="data-table"><thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Actions</th></tr></thead><tbody>';

            users.forEach(user => {
                tableHTML += '<tr>' +
                    '<td>#' + user.id + '</td>' +
                    '<td>' + user.firstName + ' ' + user.lastName + '</td>' +
                    '<td>' + user.email + '</td>' +
                    '<td>' + (user.phoneNumber || 'N/A') + '</td>' +
                    '<td><span class="role-badge role-' + user.role.toLowerCase() + '">' + user.role + '</span></td>' +
                    '<td>' +
                        '<button class="btn btn-info btn-sm" onclick="viewUserDetails(' + user.id + ')" title="View Details">' +
                            '<i class="fas fa-eye"></i>' +
                        '</button>' +
                        '<button class="btn btn-warning btn-sm" onclick="openEditUserModal(' + user.id + ')" title="Edit User">' +
                            '<i class="fas fa-edit"></i>' +
                        '</button>' +
                        '<button class="btn btn-primary btn-sm" onclick="changeUserRole(' + user.id + ', \'' + user.role + '\')" title="Change Role">' +
                            '<i class="fas fa-user-cog"></i>' +
                        '</button>' +
                        '<div class="delete-btn-group">' +
                            '<button class="btn btn-danger btn-sm" onclick="showDeleteOptions(' + user.id + ', \'' + user.firstName + ' ' + user.lastName + '\')" title="Delete User">' +
                                '<i class="fas fa-trash"></i>' +
                            '</button>' +
                        '</div>' +
                    '</td>' +
                    '</tr>';
            });
            
            tableHTML += '</tbody></table>';
            container.innerHTML = tableHTML;
        }

        function displayUsersTable(users) {
            const container = document.getElementById('usersTable');

            if (!container) {
                console.error('usersTable container not found in displayUsersTable!');
                return;
            }

            if (!users || users.length === 0) {
                container.innerHTML = '<div class="no-data">No users found.</div>';
                return;
            }

            // Update the user count info
            const userCountInfo = document.querySelector('.section-info');
            if (userCountInfo) {
                userCountInfo.textContent = 'Viewing all registered users (' + users.length + ' total)';
            }

            let tableHTML = '<table class="data-table"><thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Actions</th></tr></thead><tbody>';

            users.forEach(user => {
                tableHTML += '<tr>' +
                    '<td>#' + user.id + '</td>' +
                    '<td>' + user.firstName + ' ' + user.lastName + '</td>' +
                    '<td>' + user.email + '</td>' +
                    '<td>' + (user.phoneNumber || 'N/A') + '</td>' +
                    '<td><span class="role-badge role-' + user.role.toLowerCase() + '">' + user.role + '</span></td>' +
                    '<td>' +
                        '<button class="btn btn-info btn-sm" onclick="viewUserDetails(' + user.id + ')" title="View Details">' +
                            '<i class="fas fa-eye"></i>' +
                        '</button>' +
                        '<button class="btn btn-warning btn-sm" onclick="openEditUserModal(' + user.id + ')" title="Edit User">' +
                            '<i class="fas fa-edit"></i>' +
                        '</button>' +
                        '<button class="btn btn-primary btn-sm" onclick="changeUserRole(' + user.id + ', \'' + user.role + '\')" title="Change Role">' +
                            '<i class="fas fa-user-cog"></i>' +
                        '</button>' +
                        '<div class="delete-btn-group">' +
                            '<button class="btn btn-danger btn-sm" onclick="showDeleteOptions(' + user.id + ', \'' + user.firstName + ' ' + user.lastName + '\')" title="Delete User">' +
                                '<i class="fas fa-trash"></i>' +
                            '</button>' +
                        '</div>' +
                    '</td>' +
                    '</tr>';
            });

            tableHTML += '</tbody></table>';
            container.innerHTML = tableHTML;
        }

        function displayTripsTable(trips) {
            console.log('displayTripsTable called with:', trips);
            const container = document.getElementById('tripsTable');

            if (!trips || trips.length === 0) {
                container.innerHTML = '<div class="no-data">No trips found.</div>';
                return;
            }

            console.log('Processing ' + trips.length + ' trips');
            console.log('First trip:', trips[0]);

            let tableHTML = '<table class="data-table"><thead><tr><th>Trip ID</th><th>Customer</th><th>Driver</th><th>Status</th><th>Fare</th><th>Pickup</th><th>Dropoff</th><th>Actions</th></tr></thead><tbody>';

            trips.forEach((trip, index) => {
                console.log('Processing trip ' + index + ':', trip);
                
                // Use the correct property names from the backend data
                const tripId = trip.TripID || trip.tripId || trip.id;
                const customerId = trip.CustomerID || trip.customerId;
                const driverId = trip.DriverID || trip.driverId;
                const status = trip.TripStatus || trip.tripStatus || trip.status || 'Unknown';
                const fare = trip.price || trip.fare || trip.Price || 0;
                const pickupLocation = trip.PickupLocation || trip.pickupLocation || 'N/A';
                const dropoffLocation = trip.DropOffLocation || trip.dropOffLocation || trip.dropoffLocation || 'N/A';
                const bookingTime = trip.BookingTime || trip.bookingTime || 'N/A';

                // Format fare to 2 decimal places
                const formattedFare = parseFloat(fare).toFixed(2);

                tableHTML += '<tr>' +
                    '<td>#' + tripId + '</td>' +
                    '<td>Customer #' + customerId + '</td>' +
                    '<td>' + (driverId > 0 ? 'Driver #' + driverId : 'No Driver') + '</td>' +
                    '<td><span class="status-badge status-' + status.toLowerCase().replace(/\s+/g, '-') + '">' + status + '</span></td>' +
                    '<td>$' + formattedFare + '</td>' +
                    '<td title="' + pickupLocation + '">' + (pickupLocation.length > 30 ? pickupLocation.substring(0, 30) + '...' : pickupLocation) + '</td>' +
                    '<td title="' + dropoffLocation + '">' + (dropoffLocation.length > 30 ? dropoffLocation.substring(0, 30) + '...' : dropoffLocation) + '</td>' +
                    '<td>' +
                        '<button class="btn btn-info btn-sm" onclick="viewTripDetails(' + tripId + ')" title="View Details">' +
                            '<i class="fas fa-eye"></i>' +
                        '</button>' +
                        '<button class="btn btn-warning btn-sm" onclick="editTripStatus(' + tripId + ')" title="Edit Status">' +
                            '<i class="fas fa-edit"></i>' +
                        '</button>' +
                    '</td>' +
                    '</tr>';
            });

            tableHTML += '</tbody></table>';
            container.innerHTML = tableHTML;
        }

        function displayIncidentsTable(incidents) {
            console.log('displayIncidentsTable called with:', incidents);
            const container = document.getElementById('incidentsTable');
            console.log('Container element:', container);

            if (!container) {
                console.error('incidentsTable container not found in displayIncidentsTable!');
                return;
            }

            if (!incidents || incidents.length === 0) {
                console.log('No incidents found or empty array');
                container.innerHTML = '<div class="no-data">No incidents found.</div>';
                return;
            }

            console.log('Processing ' + incidents.length + ' incidents');
            console.log('First incident:', incidents[0]);

            let tableHTML = '<table class="data-table"><thead><tr><th>ID</th><th>Type</th><th>Description</th><th>Location</th><th>Severity</th><th>Status</th><th>Driver</th><th>Date</th><th>Actions</th></tr></thead><tbody>';

            incidents.forEach((incident, index) => {
                console.log('Processing incident ' + index + ':', incident);

                // Use the correct property names from JSON serialization
                const incidentId = incident.IncidentID || incident.incidentId;
                const incidentType = incident.IncidentType || incident.incidentType;
                const description = incident.Description || incident.description;
                const location = incident.Location || incident.location;
                const severity = incident.Severity || incident.severity;
                const status = incident.Status || incident.status;
                const driverId = incident.DriverID || incident.driverId;
                const driverName = incident.DriverName || incident.driverName;
                const reportedDate = incident.ReportedDate || incident.reportedDate;

                const severityClass = 'severity-' + (severity || 'low').toLowerCase();
                const statusClass = 'status-' + (status || 'reported').toLowerCase().replace(' ', '-');
                const formattedDate = reportedDate ? new Date(reportedDate).toLocaleDateString() : 'N/A';

                tableHTML += '<tr>' +
                    '<td>#' + incidentId + '</td>' +
                    '<td>' + (incidentType || 'N/A') + '</td>' +
                    '<td>' + (description ? (description.length > 50 ? description.substring(0, 50) + '...' : description) : 'N/A') + '</td>' +
                    '<td>' + (location || 'N/A') + '</td>' +
                    '<td><span class="severity-badge ' + severityClass + '">' + (severity || 'Low') + '</span></td>' +
                    '<td><span class="status-badge ' + statusClass + '">' + (status || 'Reported') + '</span></td>' +
                    '<td>' + (driverName || 'Driver #' + driverId) + '</td>' +
                    '<td>' + formattedDate + '</td>' +
                    '<td>' +
                        '<button class="btn btn-info btn-sm" onclick="viewIncidentDetails(' + incidentId + ')" title="View Details">' +
                            '<i class="fas fa-eye"></i>' +
                        '</button>' +
                        '<button class="btn btn-warning btn-sm" onclick="updateIncidentStatus(' + incidentId + ')" title="Edit Status">' +
                            '<i class="fas fa-edit"></i>' +
                        '</button>' +
                        '<button class="btn btn-danger btn-sm" onclick="deleteIncident(' + incidentId + ')" title="Delete Incident">' +
                            '<i class="fas fa-trash"></i>' +
                        '</button>' +
                    '</td>' +
                    '</tr>';
            });

            tableHTML += '</tbody></table>';
            console.log('Generated table HTML length:', tableHTML.length);
            console.log('Setting container innerHTML');
            container.innerHTML = tableHTML;
            console.log('Table HTML set successfully');

            // Debug: Check if table is actually visible
            setTimeout(() => {
                const table = container.querySelector('.data-table');
                console.log('Table element found:', table);
                if (table) {
                    console.log('Table display style:', window.getComputedStyle(table).display);
                    console.log('Table visibility:', window.getComputedStyle(table).visibility);
                    console.log('Table opacity:', window.getComputedStyle(table).opacity);
                    console.log('Table height:', window.getComputedStyle(table).height);
                    console.log('Table width:', window.getComputedStyle(table).width);
                    console.log('Container height:', window.getComputedStyle(container).height);
                    console.log('Container display:', window.getComputedStyle(container).display);
                    } else {
                    console.error('Table element not found in DOM!');
                }
            }, 100);
        }
        
        // User management functions
        function openCreateUserModal() {
            console.log('openCreateUserModal called');
            document.getElementById('createUserModal').style.display = 'flex';
            // Clear form
            document.getElementById('createUserForm').reset();
        }

        function closeCreateUserModal() {
            document.getElementById('createUserModal').style.display = 'none';
        }

        function submitCreateUser() {
            const form = document.getElementById('createUserForm');
            const formData = new URLSearchParams();

            formData.append('action', 'createUser');
            formData.append('firstName', document.getElementById('createFirstName').value);
            formData.append('lastName', document.getElementById('createLastName').value);
            formData.append('email', document.getElementById('createEmail').value);
            formData.append('password', document.getElementById('createPassword').value);
            formData.append('phoneNumber', document.getElementById('createPhone').value);
            formData.append('role', document.getElementById('createRole').value);

            fetch(getContextPath() + '/AdminServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('User created successfully!');
                    closeCreateUserModal();
                    loadUsersData(); // Refresh the users table
                } else {
                    alert('Error creating user: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error creating user: ' + error.message);
            });
        }

        function openEditUserModal(userId) {
            console.log('openEditUserModal called for user:', userId);

            // First, get user details
            fetch(getContextPath() + '/AdminServlet?action=getUserById&userId=' + userId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.user) {
                        // Populate form with user data
                        document.getElementById('editUserId').value = data.user.id;
                        document.getElementById('editFirstName').value = data.user.firstName;
                        document.getElementById('editLastName').value = data.user.lastName;
                        document.getElementById('editEmail').value = data.user.email;
                        document.getElementById('editPhone').value = data.user.phoneNumber || '';
                        document.getElementById('editRole').value = data.user.role;

                        // Show modal
                        document.getElementById('editUserModal').style.display = 'flex';
                    } else {
                        alert('Error loading user details: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading user details: ' + error.message);
                });
        }

        function closeEditUserModal() {
            document.getElementById('editUserModal').style.display = 'none';
        }

        function submitEditUser() {
            const formData = new URLSearchParams();

            formData.append('action', 'updateUser');
            formData.append('userId', document.getElementById('editUserId').value);
            formData.append('firstName', document.getElementById('editFirstName').value);
            formData.append('lastName', document.getElementById('editLastName').value);
            formData.append('email', document.getElementById('editEmail').value);
            formData.append('phoneNumber', document.getElementById('editPhone').value);
            
            fetch(getContextPath() + '/AdminServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('User updated successfully!');
                    closeEditUserModal();
                    loadUsersData(); // Refresh the users table
                } else {
                    alert('Error updating user: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating user: ' + error.message);
            });
        }
        
        function changeUserRole(userId, currentRole) {
            console.log('changeUserRole called for user:', userId, 'current role:', currentRole);
            const newRole = prompt('Current role: ' + currentRole + '\nEnter new role (Customer, Driver, Admin, Operations, Finance, Feedback):');
            if (newRole && newRole !== currentRole) {
                const formData = new URLSearchParams();
                formData.append('action', 'updateUserRole');
                formData.append('userId', userId);
                formData.append('role', newRole);
                
                fetch(getContextPath() + '/AdminServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('User role updated successfully!');
                        loadUsersData(); // Refresh the users table
                    } else {
                        alert('Error updating user role: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating user role: ' + error.message);
                });
            }
        }
        
        function showDeleteOptions(userId, userName) {
            console.log('showDeleteOptions called for user:', userId, 'name:', userName);
            
            // Create a custom confirmation dialog
            const message = 'Choose delete option for user "' + userName + '":\n\n' +
                '1. Soft Delete (Deactivate) - Safe, reversible\n' +
                '2. Hard Delete (Permanent) - Destructive, irreversible\n\n' +
                'Enter "1" for Soft Delete or "2" for Hard Delete:';
            
            const userChoice = prompt(message);
            
            if (userChoice === null) {
                // User cancelled
                return;
            } else if (userChoice === '1') {
                // Soft delete
                deleteUser(userId, userName, 'soft');
            } else if (userChoice === '2') {
                // Hard delete
                deleteUser(userId, userName, 'hard');
            } else {
                alert('Invalid choice. Please enter "1" for Soft Delete or "2" for Hard Delete.');
            }
        }
        
        function deleteUser(userId, userName, deleteType) {
            console.log('deleteUser called for user:', userId, 'name:', userName, 'type:', deleteType);
            
            let confirmMessage;
            let confirmTitle;
            
            if (deleteType === 'hard') {
                confirmTitle = 'Hard Delete User';
                confirmMessage = '⚠️ WARNING: HARD DELETE ⚠️\n\n' +
                    'Are you sure you want to PERMANENTLY DELETE user "' + userName + '"?\n\n' +
                    'This will:\n' +
                    '• Permanently remove the user account\n' +
                    '• Delete ALL related data (trips, feedbacks, incidents, notifications)\n' +
                    '• This action CANNOT be undone\n\n' +
                    'Type "DELETE" to confirm:';
                
                const userInput = prompt(confirmMessage);
                if (userInput !== 'DELETE') {
                    alert('Hard delete cancelled. You must type "DELETE" to confirm.');
                    return;
                }
            } else {
                confirmTitle = 'Soft Delete User';
                confirmMessage = 'Are you sure you want to deactivate user "' + userName + '"?\n\n' +
                    'This will:\n' +
                    '• Mark the user as inactive\n' +
                    '• User will not be able to login\n' +
                    '• User data will be preserved\n' +
                    '• This can be reversed later';
                
                if (!confirm(confirmMessage)) {
                    return;
                }
            }
            
            const formData = new URLSearchParams();
            formData.append('action', 'deleteUser');
            formData.append('userId', userId);
            formData.append('deleteType', deleteType);
            
            fetch(getContextPath() + '/AdminServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const successMessage = deleteType === 'hard' ? 
                        'User and all related data permanently deleted!' : 
                        'User deactivated successfully!';
                    alert(successMessage);
                    loadUsersData(); // Refresh the users table
                } else {
                    alert('Error deleting user: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting user: ' + error.message);
            });
        }
        
        function viewUserDetails(userId) {
            console.log('viewUserDetails called for user:', userId);

            // First, get user details
            fetch(getContextPath() + '/AdminServlet?action=getUserById&userId=' + userId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.user) {
                        displayUserDetails(data.user);
                        document.getElementById('viewUserModal').style.display = 'flex';
                    } else {
                        alert('Error loading user details: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading user details: ' + error.message);
                });
        }

        function displayUserDetails(user) {
            const container = document.getElementById('userDetailsContent');

            const roleClass = user.role.toLowerCase();
            const roleBadgeClass = 'role-' + roleClass;

            let userDetailsHTML = '<div class="user-details-grid">';

            // User ID
            userDetailsHTML += '<div class="user-detail-item">';
            userDetailsHTML += '<div class="user-detail-label">User ID</div>';
            userDetailsHTML += '<div class="user-detail-value">#' + user.id + '</div>';
            userDetailsHTML += '</div>';

            // Role
            userDetailsHTML += '<div class="user-detail-item">';
            userDetailsHTML += '<div class="user-detail-label">Role</div>';
            userDetailsHTML += '<div class="user-detail-value">';
            userDetailsHTML += '<span class="role-badge ' + roleBadgeClass + ' user-role-badge-large">' + user.role + '</span>';
            userDetailsHTML += '</div>';
            userDetailsHTML += '</div>';

            // First Name
            userDetailsHTML += '<div class="user-detail-item">';
            userDetailsHTML += '<div class="user-detail-label">First Name</div>';
            userDetailsHTML += '<div class="user-detail-value">' + (user.firstName || 'N/A') + '</div>';
            userDetailsHTML += '</div>';

            // Last Name
            userDetailsHTML += '<div class="user-detail-item">';
            userDetailsHTML += '<div class="user-detail-label">Last Name</div>';
            userDetailsHTML += '<div class="user-detail-value">' + (user.lastName || 'N/A') + '</div>';
            userDetailsHTML += '</div>';

            // Email (full width)
            userDetailsHTML += '<div class="user-detail-item user-detail-full-width">';
            userDetailsHTML += '<div class="user-detail-label">Email Address</div>';
            userDetailsHTML += '<div class="user-detail-value">' + (user.email || 'N/A') + '</div>';
            userDetailsHTML += '</div>';

            // Phone Number
            userDetailsHTML += '<div class="user-detail-item">';
            userDetailsHTML += '<div class="user-detail-label">Phone Number</div>';
            userDetailsHTML += '<div class="user-detail-value">' + (user.phoneNumber || 'N/A') + '</div>';
            userDetailsHTML += '</div>';

            // Vehicle Type (if exists)
            if (user.vehicleType) {
                userDetailsHTML += '<div class="user-detail-item">';
                userDetailsHTML += '<div class="user-detail-label">Vehicle Type</div>';
                userDetailsHTML += '<div class="user-detail-value">' + user.vehicleType + '</div>';
                userDetailsHTML += '</div>';
            }

            // Vehicle Name (if exists)
            if (user.vehicleName) {
                userDetailsHTML += '<div class="user-detail-item">';
                userDetailsHTML += '<div class="user-detail-label">Vehicle Name</div>';
                userDetailsHTML += '<div class="user-detail-value">' + user.vehicleName + '</div>';
                userDetailsHTML += '</div>';
            }

            userDetailsHTML += '</div>';

            // Account Information Summary
            userDetailsHTML += '<div class="user-detail-item user-detail-full-width">';
            userDetailsHTML += '<div class="user-detail-label">Account Information</div>';
            userDetailsHTML += '<div class="user-detail-value">';
            userDetailsHTML += '<strong>Full Name:</strong> ' + user.firstName + ' ' + user.lastName + '<br>';
            userDetailsHTML += '<strong>Email:</strong> ' + user.email + '<br>';
            userDetailsHTML += '<strong>Role:</strong> ' + user.role + '<br>';
            userDetailsHTML += '<strong>Phone:</strong> ' + (user.phoneNumber || 'Not provided') + '<br>';

            if (user.vehicleType) {
                userDetailsHTML += '<strong>Vehicle:</strong> ' + (user.vehicleName || 'N/A') + ' (' + user.vehicleType + ')<br>';
            }

            userDetailsHTML += '</div>';
            userDetailsHTML += '</div>';

            container.innerHTML = userDetailsHTML;
        }

        function closeViewUserModal() {
            document.getElementById('viewUserModal').style.display = 'none';
        }

        function editUserFromDetails() {
            // Get the user ID from the current user details
            const userIdElement = document.querySelector('#userDetailsContent .user-detail-value');
            if (userIdElement) {
                const userIdText = userIdElement.textContent;
                const userId = userIdText.replace('#', '');
                closeViewUserModal();
                openEditUserModal(parseInt(userId));
            }
        }

        // Incident management functions
        function viewIncidentDetails(incidentId) {
            console.log('viewIncidentDetails called for incident:', incidentId);

            fetch(getContextPath() + '/AdminServlet?action=getIncidentDetails&incidentId=' + incidentId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.incident) {
                        displayIncidentDetails(data.incident);
                        document.getElementById('viewIncidentModal').style.display = 'flex';
                    } else {
                        alert('Error loading incident details: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading incident details: ' + error.message);
                });
        }

        function displayIncidentDetails(incident) {
            const container = document.getElementById('incidentDetailsContent');

            // Use the correct property names from JSON serialization
            const incidentId = incident.IncidentID || incident.incidentId;
            const tripId = incident.TripID || incident.tripId;
            const driverId = incident.DriverID || incident.driverId;
            const incidentType = incident.IncidentType || incident.incidentType;
            const description = incident.Description || incident.description;
            const location = incident.Location || incident.location;
            const latitude = incident.Latitude || incident.latitude;
            const longitude = incident.Longitude || incident.longitude;
            const severity = incident.Severity || incident.severity;
            const status = incident.Status || incident.status;
            const driverName = incident.DriverName || incident.driverName;
            const reportedDate = incident.ReportedDate || incident.reportedDate;
            const resolvedDate = incident.ResolvedDate || incident.resolvedDate;
            const notes = incident.Notes || incident.notes;

            const severityClass = 'severity-' + (severity || 'low').toLowerCase();
            const statusClass = 'status-' + (status || 'reported').toLowerCase().replace(' ', '-');
            const formattedReportedDate = reportedDate ? new Date(reportedDate).toLocaleString() : 'N/A';
            const formattedResolvedDate = resolvedDate ? new Date(resolvedDate).toLocaleString() : 'Not resolved';

            let incidentDetailsHTML = '<div class="incident-details-grid">';

            // Incident ID
            incidentDetailsHTML += '<div class="incident-detail-item">';
            incidentDetailsHTML += '<div class="incident-detail-label">Incident ID</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">#' + incidentId + '</div>';
            incidentDetailsHTML += '</div>';

            // Trip ID
            incidentDetailsHTML += '<div class="incident-detail-item">';
            incidentDetailsHTML += '<div class="incident-detail-label">Trip ID</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">#' + tripId + '</div>';
            incidentDetailsHTML += '</div>';

            // Incident Type
            incidentDetailsHTML += '<div class="incident-detail-item">';
            incidentDetailsHTML += '<div class="incident-detail-label">Incident Type</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">' + (incidentType || 'N/A') + '</div>';
            incidentDetailsHTML += '</div>';

            // Severity
            incidentDetailsHTML += '<div class="incident-detail-item">';
            incidentDetailsHTML += '<div class="incident-detail-label">Severity</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">';
            incidentDetailsHTML += '<span class="severity-badge ' + severityClass + '">' + (severity || 'Low') + '</span>';
            incidentDetailsHTML += '</div>';
            incidentDetailsHTML += '</div>';

            // Status
            incidentDetailsHTML += '<div class="incident-detail-item">';
            incidentDetailsHTML += '<div class="incident-detail-label">Status</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">';
            incidentDetailsHTML += '<span class="status-badge ' + statusClass + '">' + (status || 'Reported') + '</span>';
            incidentDetailsHTML += '</div>';
            incidentDetailsHTML += '</div>';

            // Driver
            incidentDetailsHTML += '<div class="incident-detail-item">';
            incidentDetailsHTML += '<div class="incident-detail-label">Driver</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">' + (driverName || 'Driver #' + driverId) + '</div>';
            incidentDetailsHTML += '</div>';

            // Location (full width)
            incidentDetailsHTML += '<div class="incident-detail-item incident-detail-full-width">';
            incidentDetailsHTML += '<div class="incident-detail-label">Location</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">' + (location || 'N/A') + '</div>';
            incidentDetailsHTML += '</div>';

            // Description (full width)
            incidentDetailsHTML += '<div class="incident-detail-item incident-detail-full-width">';
            incidentDetailsHTML += '<div class="incident-detail-label">Description</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">' + (description || 'No description provided') + '</div>';
            incidentDetailsHTML += '</div>';

            // Coordinates
            if (latitude && longitude) {
                incidentDetailsHTML += '<div class="incident-detail-item">';
                incidentDetailsHTML += '<div class="incident-detail-label">Latitude</div>';
                incidentDetailsHTML += '<div class="incident-detail-value">' + latitude + '</div>';
                incidentDetailsHTML += '</div>';

                incidentDetailsHTML += '<div class="incident-detail-item">';
                incidentDetailsHTML += '<div class="incident-detail-label">Longitude</div>';
                incidentDetailsHTML += '<div class="incident-detail-value">' + longitude + '</div>';
                incidentDetailsHTML += '</div>';
            }

            // Dates
            incidentDetailsHTML += '<div class="incident-detail-item">';
            incidentDetailsHTML += '<div class="incident-detail-label">Reported Date</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">' + formattedReportedDate + '</div>';
            incidentDetailsHTML += '</div>';

            incidentDetailsHTML += '<div class="incident-detail-item">';
            incidentDetailsHTML += '<div class="incident-detail-label">Resolved Date</div>';
            incidentDetailsHTML += '<div class="incident-detail-value">' + formattedResolvedDate + '</div>';
            incidentDetailsHTML += '</div>';

            // Notes (full width)
            if (notes) {
                incidentDetailsHTML += '<div class="incident-detail-item incident-detail-full-width">';
                incidentDetailsHTML += '<div class="incident-detail-label">Notes</div>';
                incidentDetailsHTML += '<div class="incident-detail-value">' + notes + '</div>';
                incidentDetailsHTML += '</div>';
            }

            incidentDetailsHTML += '</div>';

            container.innerHTML = incidentDetailsHTML;
        }

        function closeViewIncidentModal() {
            document.getElementById('viewIncidentModal').style.display = 'none';
        }

        function updateIncidentStatus(incidentId) {
            const newStatus = prompt('Enter new status (Reported, Under Investigation, Resolved, Closed):');
            if (newStatus && newStatus.trim()) {
                const notes = prompt('Enter notes (optional):');

                const formData = new URLSearchParams();
                formData.append('action', 'updateIncidentStatus');
                formData.append('incidentId', incidentId);
                formData.append('status', newStatus.trim());
                formData.append('notes', notes || '');

                fetch(getContextPath() + '/AdminServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Incident status updated successfully!');
                        loadIncidentsData(); // Refresh the incidents table
                        closeViewIncidentModal();
                    } else {
                        alert('Error updating incident status: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating incident status: ' + error.message);
                });
            }
        }

        function deleteIncident(incidentId) {
            if (confirm('Are you sure you want to delete this incident? This action cannot be undone.')) {
                const formData = new URLSearchParams();
                formData.append('action', 'deleteIncident');
                formData.append('incidentId', incidentId);

                fetch(getContextPath() + '/AdminServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Incident deleted successfully!');
                        loadIncidentsData(); // Refresh the incidents table
                    } else {
                        alert('Error deleting incident: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting incident: ' + error.message);
                });
            }
        }

        function deleteIncidentFromDetails() {
            // Get the incident ID from the current incident details
            const incidentIdElement = document.querySelector('#incidentDetailsContent .incident-detail-value');
            if (incidentIdElement) {
                const incidentIdText = incidentIdElement.textContent;
                const incidentId = incidentIdText.replace('#', '');
                closeViewIncidentModal();
                deleteIncident(parseInt(incidentId));
            }
        }

        // Notice Management Functions
        
        function loadNoticesData() {
            console.log('Loading notices data...');
            const container = document.getElementById('noticesTable');
            if (!container) {
                console.error('noticesTable container not found!');
                return;
            }
            container.innerHTML = '<div class="loading">Loading notices...</div>';
            
            fetch(getContextPath() + '/AdminServlet?action=getAllNotices')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Notices data received:', data);
                    displayNoticesTable(data);
                })
                .catch(error => {
                    console.error('Error loading notices:', error);
                    container.innerHTML = '<div class="error-message">Error loading notices: ' + error.message + '</div>';
                });
        }
        
        function displayNoticesTable(notices) {
            const container = document.getElementById('noticesTable');
            if (!container) {
                console.error('noticesTable container not found in displayNoticesTable!');
                return;
            }
            
            if (!notices || notices.length === 0) {
                container.innerHTML = '<div class="no-data">No notices found.</div>';
                return;
            }
            
            let tableHTML = '<table class="data-table"><thead><tr><th>ID</th><th>Title</th><th>Type</th><th>Priority</th><th>Audience</th><th>Status</th><th>Created</th><th>Actions</th></tr></thead><tbody>';
            
            notices.forEach(notice => {
                const noticeId = notice.NoticeID || notice.noticeId;
                const title = notice.Title || notice.title;
                const noticeType = notice.NoticeType || notice.noticeType;
                const priority = notice.Priority || notice.priority;
                const targetAudience = notice.TargetAudience || notice.targetAudience;
                const isActive = notice.IsActive !== undefined ? notice.IsActive : notice.isActive;
                const createdDate = notice.CreatedDate || notice.createdDate;
                
                const statusClass = isActive ? 'status-active' : 'status-inactive';
                const statusText = isActive ? 'Active' : 'Inactive';
                const priorityClass = 'priority-' + priority.toLowerCase();
                
                tableHTML += '<tr>' +
                    '<td>#' + noticeId + '</td>' +
                    '<td>' + (title.length > 30 ? title.substring(0, 30) + '...' : title) + '</td>' +
                    '<td><span class="type-badge type-' + noticeType.toLowerCase() + '">' + noticeType + '</span></td>' +
                    '<td><span class="priority-badge ' + priorityClass + '">' + priority + '</span></td>' +
                    '<td>' + targetAudience + '</td>' +
                    '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>' +
                    '<td>' + (createdDate ? new Date(createdDate).toLocaleDateString() : 'N/A') + '</td>' +
                    '<td>' +
                        '<button class="btn btn-info btn-sm" onclick="viewNoticeDetails(' + noticeId + ')" title="View Details">' +
                            '<i class="fas fa-eye"></i>' +
                        '</button>' +
                        '<button class="btn btn-warning btn-sm" onclick="toggleNoticeStatus(' + noticeId + ')" title="Toggle Status">' +
                            '<i class="fas fa-toggle-on"></i>' +
                        '</button>' +
                        '<button class="btn btn-danger btn-sm" onclick="deleteNotice(' + noticeId + ')" title="Delete Notice">' +
                            '<i class="fas fa-trash"></i>' +
                        '</button>' +
                    '</td>' +
                    '</tr>';
            });
            
            tableHTML += '</tbody></table>';
            container.innerHTML = tableHTML;
        }
        
        function refreshNotices() {
            loadNoticesData();
        }
        
        function openCreateNoticeModal() {
            document.getElementById('createNoticeModal').style.display = 'flex';
        }
        
        function closeCreateNoticeModal() {
            document.getElementById('createNoticeModal').style.display = 'none';
            document.getElementById('createNoticeForm').reset();
        }
        
        function submitCreateNotice() {
            const form = document.getElementById('createNoticeForm');
            const formData = new URLSearchParams();
            
            formData.append('action', 'createNotice');
            formData.append('title', form.title.value);
            formData.append('message', form.message.value);
            formData.append('noticeType', form.noticeType.value);
            formData.append('priority', form.priority.value);
            formData.append('targetAudience', form.targetAudience.value);
            if (form.expiryDate.value) {
                formData.append('expiryDate', form.expiryDate.value);
            }
            
            fetch(getContextPath() + '/AdminServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Notice created successfully!');
                    closeCreateNoticeModal();
                    loadNoticesData();
                } else {
                    alert('Error creating notice: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error creating notice: ' + error.message);
            });
        }
        
        function viewNoticeDetails(noticeId) {
            console.log('viewNoticeDetails called for notice:', noticeId);
            fetch(getContextPath() + '/AdminServlet?action=getNoticeById&noticeId=' + noticeId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.notice) {
                        displayNoticeDetails(data.notice);
                        document.getElementById('viewNoticeModal').style.display = 'flex';
                    } else {
                        alert('Error loading notice details: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading notice details: ' + error.message);
                });
        }
        
        function displayNoticeDetails(notice) {
            const container = document.getElementById('noticeDetailsContent');
            const noticeId = notice.NoticeID || notice.noticeId;
            const title = notice.Title || notice.title;
            const message = notice.Message || notice.message;
            const noticeType = notice.NoticeType || notice.noticeType;
            const priority = notice.Priority || notice.priority;
            const targetAudience = notice.TargetAudience || notice.targetAudience;
            const isActive = notice.IsActive !== undefined ? notice.IsActive : notice.isActive;
            const createdDate = notice.CreatedDate || notice.createdDate;
            const expiryDate = notice.ExpiryDate || notice.expiryDate;
            const createdBy = notice.CreatedBy || notice.createdBy;
            
            const priorityClass = 'priority-' + priority.toLowerCase();
            const typeClass = 'type-' + noticeType.toLowerCase();
            const statusClass = isActive ? 'status-active' : 'status-inactive';
            
            let noticeDetailsHTML = '<div class="notice-details-grid">';
            noticeDetailsHTML += '<div class="notice-detail-item notice-detail-full-width">';
            noticeDetailsHTML += '<div class="notice-detail-label">Notice ID</div>';
            noticeDetailsHTML += '<div class="notice-detail-value">#' + noticeId + '</div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item notice-detail-full-width">';
            noticeDetailsHTML += '<div class="notice-detail-label">Title</div>';
            noticeDetailsHTML += '<div class="notice-detail-value">' + title + '</div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item notice-detail-full-width">';
            noticeDetailsHTML += '<div class="notice-detail-label">Message</div>';
            noticeDetailsHTML += '<div class="notice-detail-value">' + message + '</div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item">';
            noticeDetailsHTML += '<div class="notice-detail-label">Type</div>';
            noticeDetailsHTML += '<div class="notice-detail-value"><span class="type-badge ' + typeClass + '">' + noticeType + '</span></div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item">';
            noticeDetailsHTML += '<div class="notice-detail-label">Priority</div>';
            noticeDetailsHTML += '<div class="notice-detail-value"><span class="priority-badge ' + priorityClass + '">' + priority + '</span></div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item">';
            noticeDetailsHTML += '<div class="notice-detail-label">Target Audience</div>';
            noticeDetailsHTML += '<div class="notice-detail-value">' + targetAudience + '</div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item">';
            noticeDetailsHTML += '<div class="notice-detail-label">Status</div>';
            noticeDetailsHTML += '<div class="notice-detail-value"><span class="status-badge ' + statusClass + '">' + (isActive ? 'Active' : 'Inactive') + '</span></div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item">';
            noticeDetailsHTML += '<div class="notice-detail-label">Created Date</div>';
            noticeDetailsHTML += '<div class="notice-detail-value">' + (createdDate ? new Date(createdDate).toLocaleString() : 'N/A') + '</div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item">';
            noticeDetailsHTML += '<div class="notice-detail-label">Expiry Date</div>';
            noticeDetailsHTML += '<div class="notice-detail-value">' + (expiryDate ? new Date(expiryDate).toLocaleString() : 'No expiry') + '</div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '<div class="notice-detail-item">';
            noticeDetailsHTML += '<div class="notice-detail-label">Created By</div>';
            noticeDetailsHTML += '<div class="notice-detail-value">User #' + createdBy + '</div>';
            noticeDetailsHTML += '</div>';
            
            noticeDetailsHTML += '</div>';
            container.innerHTML = noticeDetailsHTML;
        }
        
        function closeViewNoticeModal() {
            document.getElementById('viewNoticeModal').style.display = 'none';
        }
        
        function editNoticeFromDetails() {
            const noticeIdElement = document.querySelector('#noticeDetailsContent .notice-detail-value');
            if (noticeIdElement) {
                const noticeIdText = noticeIdElement.textContent;
                const noticeId = noticeIdText.replace('#', '');
                closeViewNoticeModal();
                // For now, just show an alert. In a real implementation, this would open an edit modal
                alert('Edit notice functionality for Notice #' + noticeId + ' will be implemented here.');
            }
        }
        
        function toggleNoticeStatus(noticeId) {
            if (confirm('Are you sure you want to toggle the status of this notice?')) {
                const formData = new URLSearchParams();
                formData.append('action', 'toggleNoticeStatus');
                formData.append('noticeId', noticeId);
                
                fetch(getContextPath() + '/AdminServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Notice status toggled successfully!');
                        loadNoticesData();
                    } else {
                        alert('Error toggling notice status: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error toggling notice status: ' + error.message);
                });
            }
        }
        
        function deleteNotice(noticeId) {
            if (confirm('Are you sure you want to delete this notice? This action cannot be undone.')) {
                const formData = new URLSearchParams();
                formData.append('action', 'deleteNotice');
                formData.append('noticeId', noticeId);
                
                fetch(getContextPath() + '/AdminServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Notice deleted successfully!');
                        loadNoticesData();
                    } else {
                        alert('Error deleting notice: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting notice: ' + error.message);
                });
            }
        }

        // Initialize dashboard
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Dashboard initialized');
            loadOverviewData();
        });
    </script>
</body>
</html>

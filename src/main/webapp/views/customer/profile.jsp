<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Profile Management</title>
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

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--ash-light);
            color: var(--black-light);
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
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 204, 122, 0.3);
        }
        
        .back-btn {
            background: linear-gradient(90deg, var(--black-light) 0%, var(--black-medium) 100%);
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
            transition: all 0.3s ease;
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
            color: var(--ash-light);
            margin: 0;
        }
        
        h1 i {
            color: var(--primary-light);
            filter: drop-shadow(0 2px 4px rgba(51, 255, 153, 0.3));
        }
        
        .card {
            background: var(--ash-light);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            border: 1px solid var(--ash-medium);
        }
        
        .card h2 {
            color: var(--black-light);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        
        .card h2 i {
            color: var(--primary);
            margin-right: 10px;
            filter: drop-shadow(0 2px 4px rgba(0, 204, 122, 0.3));
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--black-light);
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        input[type="text"], 
        input[type="email"], 
        input[type="tel"], 
        select {
            width: 100%;
            padding: 12px;
            border: 2px solid var(--ash-medium);
            border-radius: 8px;
            font-size: 16px;
            background: var(--ash-light);
            color: var(--black-light);
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        
        input[type="text"]:focus, 
        input[type="email"]:focus, 
        input[type="tel"]:focus, 
        select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(0, 204, 122, 0.2);
            transform: translateY(-2px);
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
            color: white;
            box-shadow: 0 4px 15px rgba(0, 204, 122, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(90deg, var(--primary-dark) 0%, var(--primary-darker) 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 204, 122, 0.4);
        }
        
        .btn-danger {
            background: linear-gradient(90deg, #e11d48 0%, #be123c 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(225, 29, 72, 0.3);
        }
        
        .btn-danger:hover {
            background: linear-gradient(90deg, #be123c 0%, #9f1239 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(225, 29, 72, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(90deg, var(--black-light) 0%, var(--black-medium) 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(31, 41, 55, 0.3);
        }
        
        .btn-secondary:hover {
            background: linear-gradient(90deg, var(--black-medium) 0%, var(--black-dark) 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(31, 41, 55, 0.4);
        }
        
        .btn-group {
            margin-top: 30px;
            text-align: center;
        }
        
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .alert-success {
            background: rgba(0, 204, 122, 0.15);
            color: var(--primary-dark);
            border: 1px solid var(--primary);
        }
        
        .alert-error {
            background: rgba(225, 29, 72, 0.15);
            color: #e11d48;
            border: 1px solid #e11d48;
        }
        
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        
        .loading i {
            animation: spin 1s linear infinite;
            font-size: 24px;
            color: var(--primary);
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .delete-confirmation {
            background: rgba(250, 204, 21, 0.15);
            color: var(--secondary-accent-dark);
            border: 1px solid var(--secondary-accent);
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            display: none;
        }
        
        .delete-confirmation h3 {
            margin-top: 0;
            color: var(--secondary-accent-dark);
        }
        
        .delete-confirmation .btn-group {
            margin-top: 15px;
            text-align: center;
        }
        
        
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 0;
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
<body class="customer-theme">
    <div class="container">
        <div class="header">
            <a href="${pageContext.request.contextPath}/views/customer/profile_view.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                Back to Profile
            </a>
            <h1><i class="fas fa-user-edit"></i> Profile Management</h1>
        </div>

        <div id="alert-container"></div>

        <div class="card">
            <h2><i class="fas fa-user"></i> Personal Information</h2>
            <form id="profileForm">
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" value="${sessionScope.user.firstName}" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" value="${sessionScope.user.lastName}" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" value="${sessionScope.user.email}" required>
                </div>
                
                <div class="form-group">
                    <label for="phoneNumber">Phone Number</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${sessionScope.user.phoneNumber}" required>
                </div>
                
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        Update Profile
                    </button>
                    <button type="button" class="btn btn-danger" onclick="showDeleteConfirmation()">
                        <i class="fas fa-trash"></i>
                        Delete Account
                    </button>
                </div>
            </form>
        </div>

        <div class="delete-confirmation" id="deleteConfirmation">
            <h3><i class="fas fa-exclamation-triangle"></i> Confirm Account Deletion</h3>
            <p>Are you sure you want to delete your account? This action cannot be undone and will permanently remove:</p>
            <ul>
                <li>Your profile information</li>
                <li>Your ride history</li>
                <li>All associated data</li>
            </ul>
            <p><strong>This action is irreversible!</strong></p>
            
            <div class="btn-group">
                <button type="button" class="btn btn-danger" onclick="deleteAccount()">
                    <i class="fas fa-trash"></i>
                    Yes, Delete My Account
                </button>
                <button type="button" class="btn btn-secondary" onclick="hideDeleteConfirmation()">
                    <i class="fas fa-times"></i>
                    Cancel
                </button>
            </div>
        </div>

        <div class="loading" id="loading">
            <i class="fas fa-spinner"></i>
            <p>Processing...</p>
        </div>
    </div>

    <script>
        // Function to show alert messages
        function showAlert(message, type) {
            const alertContainer = document.getElementById('alert-container');
            const alertClass = type === 'success' ? 'alert-success' : 'alert-error';
            alertContainer.innerHTML = `<div class="alert ${alertClass}">${message}</div>`;
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                alertContainer.innerHTML = '';
            }, 5000);
        }

        // Function to show loading
        function showLoading() {
            document.getElementById('loading').style.display = 'block';
        }

        // Function to hide loading
        function hideLoading() {
            document.getElementById('loading').style.display = 'none';
        }

        // Function to show delete confirmation
        function showDeleteConfirmation() {
            document.getElementById('deleteConfirmation').style.display = 'block';
        }

        // Function to hide delete confirmation
        function hideDeleteConfirmation() {
            document.getElementById('deleteConfirmation').style.display = 'none';
        }

        // Handle form submission
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            showLoading();
            
            // Create URL-encoded form data instead of FormData
            const formData = new URLSearchParams();
            formData.append('action', 'updateProfile');
            formData.append('firstName', document.getElementById('firstName').value);
            formData.append('lastName', document.getElementById('lastName').value);
            formData.append('email', document.getElementById('email').value);
            formData.append('phoneNumber', document.getElementById('phoneNumber').value);
            
            console.log('Submitting form with action: updateProfile');
            console.log('Context path:', getContextPath());
            console.log('Full URL:', getContextPath() + '/UserServlet');
            
            fetch(getContextPath() + '/UserServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers);
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                hideLoading();
                console.log('Response data:', data);
                if (data.success) {
                    showAlert(data.message, 'success');
                    // Update session data in the form
                    document.getElementById('firstName').value = formData.get('firstName');
                    document.getElementById('lastName').value = formData.get('lastName');
                    document.getElementById('email').value = formData.get('email');
                    document.getElementById('phoneNumber').value = formData.get('phoneNumber');
                } else {
                    showAlert(data.message, 'error');
                }
            })
            .catch(error => {
                hideLoading();
                console.error('Error:', error);
                showAlert('An error occurred while updating your profile: ' + error.message, 'error');
            });
        });

        // Function to delete account
        function deleteAccount() {
            showLoading();
            hideDeleteConfirmation();
            
            const formData = new URLSearchParams();
            formData.append('action', 'deleteAccount');
            
            fetch(getContextPath() + '/UserServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                hideLoading();
                if (data.success) {
                    showAlert('Account deleted successfully. Redirecting to login page...', 'success');
                    setTimeout(() => {
                        window.location.href = '/pickmegoweb_war_exploded/views/login.jsp';
                    }, 2000);
                } else {
                    showAlert(data.message, 'error');
                }
            })
            .catch(error => {
                hideLoading();
                console.error('Error:', error);
                showAlert('An error occurred while deleting your account', 'error');
            });
        }

        // Function to get context path correctly
        function getContextPath() {
            return "${pageContext.request.contextPath}";
        }
    </script>
</body>
</html>

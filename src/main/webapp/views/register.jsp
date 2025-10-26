<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User Registration | PickMeGo</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            /* Black–Green–Ash theme */
            --primary: #00cc7a;
            --primary-dark: #009e5e;
            --secondary: #f8f9fa;
            --text: #1f2937;
            --text-light: #6b7280;
            --success: #00cc7a;
            --error: #e11d48;
            --border: #d1d5db;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.15);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.55)), url('${pageContext.request.contextPath}/assets/images/images.jpg'), url('${pageContext.request.contextPath}/assets/images/images.png');
            background-size: cover; background-position: center; background-attachment: fixed;
            color: #ffffff;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .registration-container {
            display: flex;
            width: 100%;
            max-width: 1000px;
            min-height: 650px;
            background: rgba(255,255,255,0.92);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }

        .registration-left {
            flex: 1;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .registration-left h1 {
            font-size: 2.2rem;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .registration-left p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 30px;
            max-width: 300px;
        }

        .benefits-list {
            text-align: left;
            margin: 20px 0;
            width: 100%;
            max-width: 300px;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .benefit-icon {
            width: 30px;
            height: 30px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .registration-left-img {
            width: 100%;
            max-width: 280px;
            margin-top: 30px;
        }

        .registration-right {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            overflow-y: auto;
        }

        .registration-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .registration-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 10px;
        }

        .registration-header p {
            color: var(--text-light);
            font-size: 1rem;
        }

        .form-style {
            width: 100%;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .input-group {
            margin-bottom: 20px;
            position: relative;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text);
            font-size: 0.95rem;
        }

        .input-group input,
        .input-group select {
            width: 100%;
            padding: 14px 16px 14px 45px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
        }

        .input-group input:focus,
        .input-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(0, 204, 122, 0.25);
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 42px;
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: linear-gradient(90deg, var(--primary-dark) 0%, #006633 100%);
        }

        .form-link {
            text-align: center;
            margin-top: 30px;
            color: var(--text-light);
        }

        .form-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .form-link a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .message {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
        }

        .message i {
            margin-right: 8px;
        }

        .error {
            background: #ffeaea;
            color: var(--error);
            border: 1px solid #f5c6cb;
        }

        .password-requirements {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
            font-size: 0.85rem;
            color: var(--text-light);
        }

        .password-requirements ul {
            padding-left: 20px;
            margin: 10px 0 0;
        }

        .requirement {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }

        .requirement i {
            margin-right: 8px;
            font-size: 0.8rem;
        }

        .valid {
            color: var(--success);
        }

        .invalid {
            color: var(--error);
        }

        @media (max-width: 768px) {
            .registration-container {
                flex-direction: column;
                max-width: 450px;
            }

            .registration-left {
                padding: 30px 20px;
            }

            .registration-left h1 {
                font-size: 1.8rem;
            }

            .registration-left-img {
                max-width: 200px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="registration-container">
    <div class="registration-left">
        <h1>Join Our Community</h1>
        <p>Create an account to access exclusive features and services</p>

        <div class="benefits-list">
            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-check"></i>
                </div>
                <span>Quick and easy registration</span>
            </div>

            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-check"></i>
                </div>
                <span>Secure account protection</span>
            </div>

            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-check"></i>
                </div>
                <span>Personalized experience</span>
            </div>

            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-check"></i>
                </div>
                <span>24/7 customer support</span>
            </div>
        </div>

        <svg class="registration-left-img" viewBox="0 0 500 400" xmlns="http://www.w3.org/2000/svg">
            <path d="M100,300 C150,200 350,200 400,300" stroke="#ffffff" stroke-width="8" fill="none" />
            <circle cx="150" cy="150" r="40" fill="#ffffff" />
            <circle cx="350" cy="150" r="40" fill="#ffffff" />
            <path d="M180,250 C200,290 300,290 320,250" stroke="#ffffff" stroke-width="8" fill="none" />
        </svg>
    </div>

    <div class="registration-right">
        <div class="registration-header">
            <h2>Create Account</h2>
            <p>Fill in your details to get started</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="message error">
            <i class="fas fa-exclamation-circle"></i>
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/UserServlet" method="post" class="form-style" id="registrationForm">
            <input type="hidden" name="action" value="register">

            <div class="form-grid">
                <div class="input-group">
                    <label for="firstName">First Name</label>
                    <i class="input-icon fas fa-user"></i>
                    <input type="text" id="firstName" name="firstName" placeholder="Enter your first name" required>
                </div>

                <div class="input-group">
                    <label for="lastName">Last Name</label>
                    <i class="input-icon fas fa-user"></i>
                    <input type="text" id="lastName" name="lastName" placeholder="Enter your last name" required>
                </div>

                <div class="input-group full-width">
                    <label for="email">Email Address</label>
                    <i class="input-icon fas fa-envelope"></i>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <i class="input-icon fas fa-lock"></i>
                    <input type="password" id="password" name="password" placeholder="Create a password" required>
                </div>

                <div class="input-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <i class="input-icon fas fa-lock"></i>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                </div>

                <div class="input-group full-width">
                    <label for="phoneNumber">Phone Number</label>
                    <i class="input-icon fas fa-phone"></i>
                    <input type="text" id="phoneNumber" name="phoneNumber" placeholder="Enter your phone number" required>
                </div>

                <div class="input-group full-width">
                    <label for="role">Account Type</label>
                    <i class="input-icon fas fa-user-tag"></i>
                    <select id="role" name="role" required>
                        <option value="" disabled selected>Select your role</option>
                        <option value="Customer">Customer</option>
                        <option value="Driver">Driver</option>
                        <option value="Admin">Admin</option>
                        <option value="Finance">Finance Officer</option>
                        <option value="Feedback">Feedback Manager</option>
                    </select>
                </div>
            </div>

            <div class="password-requirements">
                <p><strong>Password must include:</strong></p>
                <ul>
                    <li class="requirement"><i class="fas fa-check-circle valid" id="lengthCheck"></i> At least 8 characters</li>
                    <li class="requirement"><i class="fas fa-check-circle valid" id="numberCheck"></i> At least one number</li>
                    <li class="requirement"><i class="fas fa-check-circle valid" id="letterCheck"></i> At least one letter</li>
                </ul>
            </div>

            <button type="submit" class="btn-submit">Create Account</button>
        </form>

        <p class="form-link">Already have an account? <a href="${pageContext.request.contextPath}/views/login.jsp">Sign in here</a></p>
    </div>
</div>

<script>
    // Password validation logic
    document.addEventListener('DOMContentLoaded', function() {
        const passwordInput = document.getElementById('password');
        const confirmInput = document.getElementById('confirmPassword');
        const lengthCheck = document.getElementById('lengthCheck');
        const numberCheck = document.getElementById('numberCheck');
        const letterCheck = document.getElementById('letterCheck');

        passwordInput.addEventListener('input', function() {
            const password = this.value;

            // Check length
            if (password.length >= 8) {
                lengthCheck.className = 'fas fa-check-circle valid';
            } else {
                lengthCheck.className = 'fas fa-times-circle invalid';
            }

            // Check for number
            if (/\d/.test(password)) {
                numberCheck.className = 'fas fa-check-circle valid';
            } else {
                numberCheck.className = 'fas fa-times-circle invalid';
            }

            // Check for letter
            if (/[a-zA-Z]/.test(password)) {
                letterCheck.className = 'fas fa-check-circle valid';
            } else {
                letterCheck.className = 'fas fa-times-circle invalid';
            }
        });

        // Form validation
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirmPassword = confirmInput.value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }

            if (password.length < 8 || !/\d/.test(password) || !/[a-zA-Z]/.test(password)) {
                e.preventDefault();
                alert('Password does not meet the requirements!');
                return false;
            }

            return true;
        });
    });
</script>
</body>
</html>
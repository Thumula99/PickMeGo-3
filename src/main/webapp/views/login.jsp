<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User Login | PickMeGo</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            /* Black–Green–Ash theme */
            --primary: #00cc7a;
            --primary-dark: #009e5e;
            --secondary: #ffffff;
            --text: #1f2937;
            --text-light: #6b7280;
            --success: #00cc7a;
            --error: #e11d48;
            --border: #d1d5db;
            --card-shadow: 0 15px 30px rgba(0, 0, 0, 0.12);
            --glass-bg: rgba(255, 255, 255, 0.08);
            --glass-border: rgba(255, 255, 255, 0.18);
            --black-light: #1f2937;
            --black-medium: #111827;
            --ash-light: #f1eeee;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.55)), url('${pageContext.request.contextPath}/assets/images/images.jpg'), url('${pageContext.request.contextPath}/assets/images/images.png');
            background-size: cover; background-position: center; background-attachment: fixed;
            color: #ffffff;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            overflow: hidden;
        }

        .login-container {
            display: flex;
            width: 100%;
            max-width: 1000px;
            min-height: 600px;
            background: var(--glass-bg);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            transform: translateY(0);
            transition: transform 0.3s ease;
        }

        .login-container:hover {
            transform: translateY(-5px);
        }

        .login-left {
            flex: 1;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .login-left::before {
            content: '';
            position: absolute;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
            transform: rotate(45deg);
            top: -50%;
            left: -50%;
        }

        .login-left h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            font-weight: 700;
            position: relative;
            z-index: 1;
            animation: fadeInUp 1s ease;
        }

        .login-left p {
            font-size: 1.15rem;
            opacity: 0.9;
            margin-bottom: 30px;
            max-width: 320px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 1s ease 0.2s;
            animation-fill-mode: backwards;
        }

        .login-left-img {
            width: 100%;
            max-width: 300px;
            margin-top: 30px;
            position: relative;
            z-index: 1;
            animation: float 3s ease-in-out infinite;
        }

        .login-right {
            flex: 1;
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: #ffffff;
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .login-header h2 {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 12px;
            animation: fadeIn 1s ease;
        }

        .login-header p {
            color: var(--text-light);
            font-size: 1.05rem;
            animation: fadeIn 1s ease 0.1s;
            animation-fill-mode: backwards;
        }

        .form-style {
            width: 100%;
        }

        .input-group {
            margin-bottom: 28px;
            position: relative;
            transition: transform 0.3s ease;
        }

        .input-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 500;
            color: var(--text);
            font-size: 0.95rem;
        }

        .input-group input {
            width: 100%;
            padding: 16px 16px 16px 50px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font-size: 1rem;
            background: var(--secondary);
            transition: all 0.3s ease;
        }

        .input-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(0, 204, 122, 0.25);
            transform: translateY(-2px);
        }

        .input-icon {
            position: absolute;
            left: 18px;
            top: 44px;
            color: var(--text-light);
            font-size: 1.2rem;
            transition: color 0.3s ease;
        }

        .input-group input:focus + .input-icon {
            color: var(--primary);
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.15rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-submit::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }

        .btn-submit:hover::after {
            transform: translateX(0);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0, 204, 122, 0.35);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 30px 0;
        }

        .divider-line {
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        .divider-text {
            padding: 0 20px;
            color: var(--text-light);
            font-size: 0.95rem;
        }

        .social-login {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .social-btn {
            flex: 1;
            padding: 14px;
            border: 1px solid var(--border);
            border-radius: 10px;
            background: #ffffff;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .social-btn:hover {
            transform: translateY(-2px);
            background: var(--glass-bg);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .social-icon {
            font-size: 1.3rem;
        }

        .google { color: #DB4437; }
        .facebook { color: #4267B2; }
        .twitter { color: #1DA1F2; }

        .form-link {
            text-align: center;
            margin-top: 30px;
            color: var(--text-light);
        }

        .form-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .form-link a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .message {
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 28px;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            animation: slideIn 0.5s ease;
        }

        .message i {
            margin-right: 10px;
        }

        .error {
            background: rgba(214, 48, 49, 0.1);
            color: var(--error);
            border: 1px solid rgba(214, 48, 49, 0.2);
        }

        .success {
            background: rgba(0, 184, 148, 0.1);
            color: var(--success);
            border: 1px solid rgba(0, 184, 148, 0.2);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
                max-width: 400px;
            }

            .login-left {
                padding: 40px 30px;
            }

            .login-left h1 {
                font-size: 2rem;
            }

            .login-left-img {
                max-width: 220px;
            }

            .login-right {
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-left">
        <h1>Welcome Back</h1>
        <p>Sign in to access your personalized dashboard and premium features</p>
        <svg class="login-left-img" viewBox="0 0 500 400" xmlns="http://www.w3.org/2000/svg">
            <path d="M100,300 C150,200 350,200 400,300" stroke="#ffffff" stroke-width="10" fill="none" />
            <circle cx="250" cy="180" r="70" fill="#ffffff" opacity="0.9" />
            <path d="M180,250 C180,290 220,320 250,320 C280,320 320,290 320,250" stroke="#ffffff" stroke-width="10" fill="none" />
        </svg>
    </div>

    <div class="login-right">
        <div class="login-header">
            <h2>Sign In</h2>
            <p>Access your account with your credentials</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="message error">
            <i class="fas fa-exclamation-circle"></i>
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <% if (request.getAttribute("message") != null) { %>
        <div class="message success">
            <i class="fas fa-check-circle"></i>
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/UserServlet" method="post" class="form-style">
            <input type="hidden" name="action" value="login">

            <div class="input-group">
                <label for="email">Email Address</label>
                <i class="input-icon fas fa-envelope"></i>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <i class="input-icon fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="btn-submit">Sign In</button>
        </form>

        <div class="divider">
            <div class="divider-line"></div>
            <div class="divider-text">or continue with</div>
            <div class="divider-line"></div>
        </div>

        <div class="social-login">
            <button class="social-btn">
                <i class="social-icon fab fa-google google"></i>
            </button>
            <button class="social-btn">
                <i class="social-icon fab fa-facebook-f facebook"></i>
            </button>
            <button class="social-btn">
                <i class="social-icon fab fa-twitter twitter"></i>
            </button>
        </div>

        <p class="form-link">New here? <a href="${pageContext.request.contextPath}/views/register.jsp">Create an account</a></p>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const inputs = document.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
                this.parentElement.style.transform = 'translateY(-4px)';
            });
            input.addEventListener('blur', function() {
                if (this.value === '') {
                    this.parentElement.classList.remove('focused');
                }
                this.parentElement.style.transform = 'translateY(0)';
            });
        });

        // Add ripple effect to social buttons
        const socialButtons = document.querySelectorAll('.social-btn');
        socialButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                ripple.classList.add('ripple');
                const rect = button.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = e.clientX - rect.left - size / 2 + 'px';
                ripple.style.top = e.clientY - rect.top - size / 2 + 'px';
                button.appendChild(ripple);
                setTimeout(() => ripple.remove(), 600);
            });
        });
    });
</script>

<style>
    .ripple {
        position: absolute;
        background: rgba(0, 0, 0, 0.1);
        border-radius: 50%;
        transform: scale(0);
        animation: ripple 0.6s linear;
        pointer-events: none;
    }

    @keyframes ripple {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
</style>
</body>
</html>
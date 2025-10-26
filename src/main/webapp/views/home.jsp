<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PickMeGo | Your ride, on demand</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', sans-serif;
        }

        :root {
            --primary: #10b981;
            --primary-dark: #059669;
            --primary-light: #34d399;
        }

        body {
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        .bg-layer {
            position: fixed;
            inset: 0;
            z-index: 0;
            background: linear-gradient(rgba(0, 0, 0, 0.65), rgba(0, 0, 0, 0.65)),
            url('https://images.unsplash.com/photo-1449824913935-59a10b8d2000?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        .gradient-overlay {
            position: fixed;
            inset: 0;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, transparent 50%, rgba(0, 0, 0, 0.3) 100%);
            z-index: 1;
            animation: pulse 4s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 0.8; }
            50% { opacity: 1; }
        }

        .content-wrapper {
            position: relative;
            z-index: 10;
        }

        /* Header */
        .site-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 50;
            padding: 12px 24px;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .header-container {
            max-width: 1280px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand i {
            color: var(--primary);
            font-size: 24px;
            filter: drop-shadow(0 2px 4px rgba(16, 185, 129, 0.4));
        }

        .brand span {
            font-size: 18px;
            font-weight: 700;
            color: white;
            letter-spacing: 0.5px;
        }

        .nav {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .nav a {
            color: #e5e7eb;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            padding: 8px 12px;
            border-radius: 8px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav a:hover {
            background: rgba(255, 255, 255, 0.12);
            color: white;
        }

        .header-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn-login, .btn-register {
            text-decoration: none;
            padding: 10px 16px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 700;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-login {
            background: linear-gradient(90deg, #374151 0%, #111827 100%);
            color: white;
            border: 1px solid rgba(0, 0, 0, 0.35);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.25);
        }

        .btn-register {
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            border: 1px solid rgba(16, 185, 129, 0.35);
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.25);
        }

        .btn-login:hover, .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(0, 0, 0, 0.3);
        }

        /* Clock */
        .clock {
            position: fixed;
            top: 80px;
            right: 24px;
            z-index: 30;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(8px);
            padding: 12px 24px;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(229, 231, 235, 0.5);
        }

        .clock-time {
            font-size: 24px;
            font-weight: 700;
            color: #111827;
            letter-spacing: -0.5px;
            text-align: right;
        }

        .clock-date {
            font-size: 11px;
            font-weight: 600;
            color: #6b7280;
            margin-top: 4px;
            text-align: right;
        }

        /* Main Content */
        main {
            padding-top: 96px;
            padding-bottom: 128px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* Hero Section */
        .hero-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 48px;
            align-items: center;
        }

        @media (min-width: 768px) {
            .hero-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        .hero-content {
            padding: 32px 0;
        }

        .hero-title {
            font-size: 48px;
            font-weight: 900;
            color: white;
            line-height: 1.1;
            margin-bottom: 24px;
            text-transform: uppercase;
            letter-spacing: -1px;
        }

        @media (min-width: 768px) {
            .hero-title {
                font-size: 64px;
            }
        }

        .hero-title-gradient {
            display: block;
            background: linear-gradient(90deg, #34d399 0%, #10b981 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-description {
            font-size: 18px;
            color: #d1d5db;
            line-height: 1.6;
            margin-bottom: 32px;
            max-width: 640px;
        }

        @media (min-width: 768px) {
            .hero-description {
                font-size: 20px;
            }
        }

        .hero-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 48px;
        }

        .btn-primary {
            position: relative;
            padding: 16px 32px;
            border-radius: 16px;
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            font-weight: 700;
            font-size: 18px;
            text-decoration: none;
            border: none;
            box-shadow: 0 8px 24px rgba(16, 185, 129, 0.4);
            transition: all 0.3s;
            cursor: pointer;
            overflow: hidden;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(16, 185, 129, 0.6);
        }

        .btn-secondary {
            padding: 16px 32px;
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            font-weight: 700;
            font-size: 18px;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            padding-top: 32px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 900;
            color: var(--primary-light);
            margin-bottom: 8px;
        }

        @media (min-width: 768px) {
            .stat-number {
                font-size: 40px;
            }
        }

        .stat-label {
            font-size: 14px;
            color: #9ca3af;
            font-weight: 600;
        }

        /* Feature Cards */
        .feature-cards {
            display: none;
            position: relative;
        }

        @media (min-width: 768px) {
            .feature-cards {
                display: block;
            }
        }

        .cards-container {
            position: relative;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        .feature-card {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            border-radius: 16px;
            margin-bottom: 24px;
            transition: all 0.3s;
        }

        .feature-card:last-child {
            margin-bottom: 0;
        }

        .feature-card-active {
            background: rgba(16, 185, 129, 0.2);
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .feature-card-inactive {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .feature-icon {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
            flex-shrink: 0;
        }

        .feature-icon-primary {
            background: linear-gradient(135deg, #34d399 0%, #10b981 100%);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .feature-icon-secondary {
            background: linear-gradient(135deg, #4b5563 0%, #1f2937 100%);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        .feature-content h3 {
            font-size: 18px;
            font-weight: 700;
            color: white;
            margin-bottom: 4px;
        }

        .feature-content p {
            font-size: 14px;
            color: #d1d5db;
        }

        /* Contact Section */
        .contact-section {
            padding: 64px 0;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 32px;
        }

        @media (min-width: 768px) {
            .contact-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        .contact-card {
            position: relative;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            padding: 32px;
            transition: all 0.3s;
        }

        .contact-card:hover {
            border-color: rgba(16, 185, 129, 0.5);
            transform: translateY(-8px);
            box-shadow: 0 16px 48px rgba(16, 185, 129, 0.2);
        }

        .contact-card::before {
            content: '';
            position: absolute;
            top: -8px;
            right: -8px;
            width: 80px;
            height: 80px;
            background: radial-gradient(circle, rgba(16, 185, 129, 0.2) 0%, transparent 70%);
            border-radius: 50%;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .contact-card:hover::before {
            opacity: 1;
        }

        .contact-icon {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
            margin-bottom: 16px;
            transition: all 0.3s;
        }

        .contact-card:hover .contact-icon {
            transform: rotate(6deg) scale(1.1);
        }

        .contact-icon-emerald {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        }

        .contact-icon-blue {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        }

        .contact-icon-orange {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
        }

        .contact-card h3 {
            font-size: 20px;
            font-weight: 700;
            color: white;
            margin-bottom: 8px;
        }

        .contact-card p {
            font-size: 18px;
            color: #d1d5db;
        }

        /* Footer */
        .site-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            z-index: 40;
            padding: 16px 24px;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(12px);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .footer-container {
            max-width: 1280px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        @media (min-width: 768px) {
            .footer-container {
                flex-direction: row;
            }
        }

        .footer-copyright {
            color: #d1d5db;
            font-size: 14px;
        }

        .footer-links {
            display: flex;
            align-items: center;
            gap: 24px;
            font-size: 14px;
        }

        .footer-links a {
            color: #d1d5db;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .footer-links a:hover {
            color: white;
        }

        .footer-separator {
            color: #6b7280;
        }

        /* Mobile Menu Toggle */
        @media (max-width: 767px) {
            .nav {
                display: none;
            }
        }
    </style>
</head>
<body>
<div class="bg-layer"></div>
<div class="gradient-overlay"></div>

<div class="content-wrapper">
    <!-- Header -->
    <header class="site-header">
        <div class="header-container">
            <div class="brand">
                <i class="fas fa-car"></i>
                <span>PickMeGo</span>
            </div>

            <nav class="nav">
                <a href="${pageContext.request.contextPath}/views/home.jsp">
                    <i class="fas fa-home"></i>
                    <span>Home</span>
                </a>
                <a href="${pageContext.request.contextPath}/views/customer/book_ride.jsp">
                    <i class="fas fa-calendar"></i>
                    <span>Book a Ride</span>
                </a>
                <a href="${pageContext.request.contextPath}/views/customer/dashboard.jsp">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>
            </nav>

            <div class="header-actions">
                <a class="btn-login" href="${pageContext.request.contextPath}/views/login.jsp">
                    <i class="fas fa-right-to-bracket"></i>
                    <span>Login</span>
                </a>
                <a class="btn-register" href="${pageContext.request.contextPath}/views/register.jsp">
                    <i class="fas fa-user-plus"></i>
                    <span>Register</span>
                </a>
            </div>
        </div>
    </header>

    <!-- Clock -->
    <div class="clock">
        <div class="clock-time" id="clock-time">00:00 AM +0530</div>
        <div class="clock-date" id="clock-date">Loading...</div>
    </div>

    <!-- Main Content -->
    <main>
        <div class="container">
            <!-- Hero Section -->
            <div class="hero-grid">
                <div class="hero-content">
                    <h1 class="hero-title">
                        Smarter Transport
                        <span class="hero-title-gradient">Management</span>
                    </h1>
                    <p class="hero-description">
                        Plan, dispatch, and monitor rides in real-time. Optimize routes, manage drivers, and deliver a seamless experience for your customers with PickMeGo.
                    </p>

                    <div class="hero-buttons">
                        <a href="${pageContext.request.contextPath}/views/register.jsp" class="btn-primary">Get Started</a>
                        <a href="#contact" class="btn-secondary">Learn More</a>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-number">50K+</div>
                            <div class="stat-label">Active Rides</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">15K+</div>
                            <div class="stat-label">Drivers</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">98%</div>
                            <div class="stat-label">Satisfaction</div>
                        </div>
                    </div>
                </div>

                <!-- Feature Cards (Desktop Only) -->
                <div class="feature-cards">
                    <div class="cards-container">
                        <div class="feature-card feature-card-active">
                            <div class="feature-icon feature-icon-primary">
                                <i class="fas fa-bolt"></i>
                            </div>
                            <div class="feature-content">
                                <h3>Real-time Tracking</h3>
                                <p>Monitor all rides live</p>
                            </div>
                        </div>

                        <div class="feature-card feature-card-inactive">
                            <div class="feature-icon feature-icon-secondary">
                                <i class="fas fa-chart-bar"></i>
                            </div>
                            <div class="feature-content">
                                <h3>Smart Analytics</h3>
                                <p>Data-driven insights</p>
                            </div>
                        </div>

                        <div class="feature-card feature-card-inactive">
                            <div class="feature-icon feature-icon-secondary">
                                <i class="fas fa-route"></i>
                            </div>
                            <div class="feature-content">
                                <h3>Route Optimization</h3>
                                <p>Save time & fuel</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Section -->
            <div class="contact-section" id="contact">
                <div class="contact-grid">
                    <div class="contact-card">
                        <div class="contact-icon contact-icon-emerald">
                            <i class="fas fa-phone"></i>
                        </div>
                        <h3>Call Us Anytime</h3>
                        <p>+94 11 234 5678</p>
                    </div>

                    <div class="contact-card">
                        <div class="contact-icon contact-icon-blue">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3>Support Hours</h3>
                        <p>Mon - Sun 7.00 - 22.00</p>
                    </div>

                    <div class="contact-card">
                        <div class="contact-icon contact-icon-orange">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <h3>Colombo, Sri Lanka</h3>
                        <p>PickMeGo HQ</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="site-footer">
        <div class="footer-container">
            <div class="footer-copyright">
                &copy; <span id="year"></span> PickMeGo. All rights reserved.
            </div>
            <div class="footer-links">
                <a href="${pageContext.request.contextPath}/views/login.jsp">Login</a>
                <span class="footer-separator">·</span>
                <a href="${pageContext.request.contextPath}/views/register.jsp">Register</a>
                <span class="footer-separator">·</span>
                <a href="#">Privacy</a>
            </div>
        </div>
    </footer>
</div>

<script>
    // Update Clock
    function updateClock() {
        const now = new Date();

        const timeOptions = {
            hour: '2-digit',
            minute: '2-digit',
            timeZone: 'Asia/Colombo',
            hour12: true
        };

        const dateOptions = {
            weekday: 'long',
            day: '2-digit',
            month: 'long',
            year: 'numeric'
        };

        const timeString = now.toLocaleTimeString('en-US', timeOptions).replace(' ', '') + ' +0530';
        const dateString = now.toLocaleDateString('en-US', dateOptions);

        document.getElementById('clock-time').textContent = timeString;
        document.getElementById('clock-date').textContent = dateString;
    }

    // Update Year
    document.getElementById('year').textContent = new Date().getFullYear();

    // Initialize clock
    updateClock();
    setInterval(updateClock, 1000);
</script>
</body>
</html>

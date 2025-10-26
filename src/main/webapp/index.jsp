<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World!</title>
    <link rel="stylesheet" href="assets/css/main.css">
    <style>
        /* A simple style for the body to center the content */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 600px;
            width: 100%;
        }

        h1 {
            color: #3498db;
            font-size: 3em;
            margin-bottom: 20px;
        }

        .cta-link {
            display: inline-block;
            padding: 12px 25px;
            background-color: #2ecc71;
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .cta-link:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>
<div class="container">
    <h1><%= "Hello World!" %></h1>
    <p>This is a basic example of a styled JSP page.</p>
    <a href="hello-servlet" class="cta-link">Go to Servlet</a>
</div>
</body>
</html>
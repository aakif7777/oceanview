<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 400px;
            text-align: center;
        }
        
        .logo {
            font-size: 50px;
            margin-bottom: 10px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 5px;
            font-size: 28px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: 600;
            font-size: 14px;
        }
        
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #667eea;
            outline: none;
        }
        
        button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .error {
            color: #e74c3c;
            margin-top: 15px;
            font-size: 14px;
            display: none;
        }
        
        .footer {
            margin-top: 25px;
            color: #999;
            font-size: 12px;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="logo">🌊</div>
        <h1>Ocean View Resort</h1>
        <p class="subtitle">Room Reservation System</p>
        
        <form action="welcome.jsp" method="POST" onsubmit="return validateForm()">
            <div class="form-group">
                <label>Username</label>
                <input type="text" id="username" name="username" placeholder="Enter username" required>
            </div>
            
            <div class="form-group">
                <label>Password</label>
                <input type="password" id="password" name="password" placeholder="Enter password" required>
            </div>
            
            <button type="submit">Sign In</button>
            
            <p class="error" id="errorMsg">❌ Invalid username or password!</p>
        </form>
        
        <div class="footer">
            © 2025 Ocean View Resort. All rights reserved.
        </div>
    </div>

    <script>
        function validateForm() {
            var username = document.getElementById('username').value;
            var password = document.getElementById('password').value;
            
            // Simple validation (in real app, check database)
            if(username === "admin" && password === "123") {
                return true; // Allow to proceed
            } else {
                document.getElementById('errorMsg').style.display = 'block';
                return false; // Stop submission
            }
        }
    </script>

</body>
</html>
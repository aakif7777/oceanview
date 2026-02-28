<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.oceanview.util.DBConnection" %>

<%
    String message = "";
    
    // Only process if form is submitted with all fields
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String roomNumber = request.getParameter("roomNumber");
        String roomType = request.getParameter("roomType");
        String priceStr = request.getParameter("pricePerNight");
        String capacityStr = request.getParameter("capacity");
        String description = request.getParameter("description");
        
        // Check if all fields are filled
        if (roomNumber != null && !roomNumber.isEmpty() && 
            roomType != null && !roomType.isEmpty() &&
            priceStr != null && !priceStr.isEmpty() &&
            capacityStr != null && !capacityStr.isEmpty()) {
            
            try {
                double pricePerNight = Double.parseDouble(priceStr);
                int capacity = Integer.parseInt(capacityStr);
                
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO rooms (room_number, room_type, price_per_night, is_available, capacity, description) VALUES (?, ?, ?, 1, ?, ?)")) {
                    // FIXED: changed 'available' to 'is_available' and 'true' to '1'
                    
                    stmt.setString(1, roomNumber);
                    stmt.setString(2, roomType);
                    stmt.setDouble(3, pricePerNight);
                    stmt.setInt(4, capacity);
                    stmt.setString(5, description != null ? description : "");
                    
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        message = "✅ Room " + roomNumber + " added successfully!";
                    }
                }
            } catch (NumberFormatException e) {
                message = "❌ Error: Please enter valid numbers for price and capacity";
            } catch (Exception e) {
                message = "❌ Error: " + e.getMessage();
            }
        } else {
            message = "❌ Error: Please fill all required fields";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Room - Ocean View Resort</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial; background: #f5f7fa; padding: 20px; }
        .navbar {
            background: white; padding: 15px 30px; display: flex;
            justify-content: space-between; align-items: center;
            border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px;
        }
       .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .nav-brand {
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .nav-brand span:first-child {
            -webkit-text-fill-color: initial;
            font-size: 28px;
        }
        
        .nav-links {
            display: flex;
            gap: 10px;
        }
        
        .nav-links a {
            color: #555;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s;
            font-size: 14px;
            font-weight: 500;
        }
        
           .nav-links a[href="logout"] {
    background: #dc2626;
    color: white;
}

.nav-links a[href="logout"]:hover {
    background: #b91c1c;
}
        
        .nav-links a:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; margin-bottom: 20px; }
        .message { padding: 15px; border-radius: 5px; margin-bottom: 20px; text-align: center; }
        .success { background: #d1fae5; color: #059669; }
        .error { background: #fee2e2; color: #dc2626; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: bold; }
        input, select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; }
        button { width: 100%; padding: 15px; background: #667eea; color: white; border: none; border-radius: 5px; font-size: 18px; cursor: pointer; margin-top: 10px; }
        button:hover { background: #5568d3; }
    </style>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <div class="nav-brand">🌊 Ocean View Resort</div>
        <div class="nav-links">
            <a href="welcome.jsp">Dashboard</a>
            <a href="addroom.jsp">Add Room</a>
            <a href="calculatebill.jsp">Calculate Bill</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <!-- Form -->
    <div class="container">
        <h1>🏨 Add New Room</h1>
        
        <% if (!message.isEmpty()) { %>
            <div class="message <%= message.contains("✅") ? "success" : "error" %>">
                <%= message %>
            </div>
        <% } %>
        
        <form method="POST" action="addroom.jsp">
            <div class="form-group">
                <label>Room Number: *</label>
                <input type="text" name="roomNumber" placeholder="e.g., 111" required>
            </div>
            
            <div class="form-group">
                <label>Room Type: *</label>
                <select name="roomType" required>
                    <option value="">-- Select Type --</option>
                    <option value="Standard">Standard ($100)</option>
                    <option value="Deluxe">Deluxe ($150)</option>
                    <option value="Suite">Suite ($250)</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Price Per Night ($): *</label>
                <input type="number" name="pricePerNight" step="0.01" min="0" placeholder="e.g., 100.00" required>
            </div>
            
            <div class="form-group">
                <label>Capacity (Guests): *</label>
                <input type="number" name="capacity" min="1" value="2" required>
            </div>
            
            <div class="form-group">
                <label>Description:</label>
                <input type="text" name="description" placeholder="e.g., Sea view with balcony">
            </div>
            
            <button type="submit">➕ Add Room</button>
        </form>
    </div>

</body>
</html>
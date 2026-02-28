<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.util.RoomDAO" %>
<%@ page import="com.oceanview.model.Room" %>
<%@ page import="java.util.List" %>

<%
    String message = "";
    List<Room> rooms = RoomDAO.getAllRooms();
    
    // Handle status update
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String newStatus = request.getParameter("newStatus");
        
        boolean updated = RoomDAO.updateRoomStatus(roomId, newStatus);
        if (updated) {
            message = "✅ Room status updated!";
            rooms = RoomDAO.getAllRooms(); // Refresh list
        } else {
            message = "❌ Failed to update status!";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Room Status - Ocean View Resort</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial; background: #f5f7fa; padding: 20px; }
        .navbar {
            background: white; padding: 15px 30px; display: flex;
            justify-content: space-between; align-items: center;
            border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 30px;
        }
        .nav-brand { font-size: 24px; font-weight: bold; color: #667eea; }
        .nav-links { display: flex; gap: 20px; }
        .nav-links a { color: #555; text-decoration: none; padding: 8px 16px; border-radius: 5px; }
        .nav-links a:hover { background: #667eea; color: white; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 40px; border-radius: 10px; }
        h1 { color: #333; margin-bottom: 20px; }
        .message { padding: 15px; border-radius: 5px; margin-bottom: 20px; text-align: center; }
        .success { background: #d1fae5; color: #059669; }
        .error { background: #fee2e2; color: #dc2626; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #667eea; color: white; }
        .available { color: #059669; font-weight: bold; }
        .occupied { color: #dc2626; font-weight: bold; }
        select { padding: 8px; border-radius: 5px; border: 1px solid #ddd; }
        .btn-update { background: #667eea; color: white; padding: 8px 16px; border: none; border-radius: 5px; cursor: pointer; }
        .btn-update:hover { background: #5568d3; }
    </style>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <div class="nav-brand">🌊 Ocean View Resort</div>
        <div class="nav-links">
            <a href="welcome.jsp">Dashboard</a>
            <a href="addguest.jsp">Add Guest</a>
            <a href="viewguests.jsp">View Guests</a>
            <a href="updateroom.jsp">Update Rooms</a>
            <a href="calculatebill.jsp">Calculate Bill</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <!-- Content -->
    <div class="container">
        <h1>🏨 Update Room Status</h1>
        
        <% if (!message.isEmpty()) { %>
            <div class="message <%= message.contains("✅") ? "success" : "error" %>">
                <%= message %>
            </div>
        <% } %>
        
        <table>
            <thead>
                <tr>
                    <th>Room Number</th>
                    <th>Type</th>
                    <th>Rate</th>
                    <th>Current Status</th>
                    <th>Change Status</th>
                </tr>
            </thead>
            <tbody>
                <% for (Room room : rooms) { %>
                <tr>
                    <td><%= room.getRoomNumber() %></td>
                    <td><%= room.getRoomType() %></td>
                    <td>$<%= room.getRoomRate() %></td>
                    <td class="<%= room.getStatus() %>">
                        <%= room.getStatus().toUpperCase() %>
                    </td>
                    <td>
                        <form method="POST" style="display: flex; gap: 10px;">
                            <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">
                            <select name="newStatus">
                                <option value="available" <%= "available".equals(room.getStatus()) ? "selected" : "" %>>Available</option>
                                <option value="occupied" <%= "occupied".equals(room.getStatus()) ? "selected" : "" %>>Occupied</option>
                            </select>
                            <button type="submit" class="btn-update">Update</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</body>
</html>
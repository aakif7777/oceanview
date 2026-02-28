<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.util.RoomDAO" %>
<%@ page import="com.oceanview.model.Room" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Get all rooms from database
    List<Room> rooms = RoomDAO.getAllRooms();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Calculate Bill - Ocean View Resort</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: #f5f7fa;
            padding: 20px;
        }
        
        /* Navbar */
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
        /* Container */
        .container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        
        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        
        select {
            background: white;
            cursor: pointer;
        }
        
        .room-rate-display {
            background: #f0f4f8;
            padding: 12px;
            border-radius: 5px;
            color: #667eea;
            font-weight: bold;
            font-size: 18px;
        }
        
        button {
            width: 100%;
            padding: 15px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            margin-top: 10px;
        }
        
        button:hover {
            background: #5568d3;
        }
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
            <a href="addreservation.jsp">New Reservation</a>
            <a href="viewbills.jsp">View Bills</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <!-- Bill Form -->
    <div class="container">
        <h1>💰 Calculate Bill</h1>
        <form action="billresult.jsp" method="POST" onsubmit="return validateForm()">
            <div class="form-group">
                <label>Guest Name:</label>
                <input type="text" name="guestName" required>
            </div>
            
            <div class="form-group">
                <label>Number of Pax:</label>
                <input type="number" name="numberOfPax" min="1" required>
            </div>
            
            <div class="form-group">
                <label>Number of Nights:</label>
                <input type="number" name="numberOfNights" min="1" required>
            </div>
            
            <div class="form-group">
                <label>Select Room:</label>
                <select name="roomId" id="roomSelect" onchange="updateRoomRate()" required>
                    <option value="">-- Select a Room --</option>
                    <% for (Room room : rooms) { %>
                        <option value="<%= room.getRoomId() %>" data-rate="<%= room.getRoomRate() %>">
                            Room <%= room.getRoomNumber() %> - <%= room.getRoomType() %> 
                            (<%= room.getStatus() %>) - $<%= room.getRoomRate() %>/night
                        </option>
                    <% } %>
                </select>
            </div>
            
            <div class="form-group">
                <label>Room Rate per Night:</label>
                <div class="room-rate-display" id="roomRateDisplay">$0.00</div>
                <input type="hidden" name="roomRate" id="roomRateInput" value="0">
            </div>
            
            <button type="submit">Calculate Bill</button>
        </form>
    </div>

    <script>
        function updateRoomRate() {
            var select = document.getElementById('roomSelect');
            var selectedOption = select.options[select.selectedIndex];
            var rate = selectedOption.getAttribute('data-rate');
            
            document.getElementById('roomRateDisplay').innerText = '$' + parseFloat(rate).toFixed(2);
            document.getElementById('roomRateInput').value = rate;
        }
        
        function validateForm() {
            var roomId = document.getElementById('roomSelect').value;
            if (roomId === '') {
                alert('Please select a room');
                return false;
            }
            return true;
        }
    </script>

</body>
</html>
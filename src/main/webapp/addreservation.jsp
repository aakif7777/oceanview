<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.oceanview.util.DBConnection" %>
<%
    // Check login
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Reservation - Ocean View Resort</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ec 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .nav-brand {
            font-size: 22px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .nav-links a {
            color: #555;
            text-decoration: none;
            margin-left: 20px;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.3s;
            font-size: 14px;
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
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #2d3748;
            margin-bottom: 30px;
            text-align: center;
            font-size: 28px;
        }
        
        .message {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
            text-align: center;
        }
        
        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }
        
        input, select, textarea {
            width: 100%;
            padding: 14px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 15px;
            font-family: inherit;
            transition: border-color 0.3s;
        }
        
        input:focus, select:focus, textarea:focus {
            border-color: #667eea;
            outline: none;
        }
        
        .price-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 25px;
        }
        
        .price-label {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .price-value {
            font-size: 36px;
            font-weight: 700;
            margin-top: 5px;
        }
        
        button {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }
        
        .info-box {
            background: #e0e7ff;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #4c51bf;
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="nav-brand">🌊 Ocean View Resort</div>
        <div class="nav-links">
            <a href="welcome.jsp">Dashboard</a>
            <a href="addguest.jsp">Add Guest</a>
            <a href="viewguests.jsp">View Guests</a>
            <a href="addreservation.jsp">New Reservation</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <h1>📅 Create New Reservation</h1>
        
        <%-- Show messages --%>
        <%
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            if (success != null) {
        %>
            <div class="message success">✅ <%= success %></div>
        <%
            }
            if (error != null) {
        %>
            <div class="message error">❌ <%= error %></div>
        <%
            }
        %>
        
        <form action="addreservation" method="POST" onsubmit="return validateForm()">
            
            <div class="info-box">
                💡 Fill in all details to create a room reservation. Total price will be calculated automatically.
            </div>
            
            <div class="form-grid">
                <!-- Guest Selection -->
                <div class="form-group">
                    <label>Select Guest *</label>
                    <select name="guestId" id="guestId" required>
                        <option value="">-- Select Guest --</option>
                        <%
                            Connection conn = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;
                            try {
                                conn = DBConnection.getConnection();
                                stmt = conn.prepareStatement(
                                    "SELECT id, guest_id, first_name, last_name FROM guests ORDER BY first_name"
                                );
                                rs = stmt.executeQuery();
                                while (rs.next()) {
                                    int id = rs.getInt("id");
                                    String guestId = rs.getString("guest_id");
                                    String firstName = rs.getString("first_name");
                                    String lastName = rs.getString("last_name");
                        %>
                            <option value="<%= id %>">
                                <%= firstName %> <%= lastName %> (<%= guestId %>)
                            </option>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<option value=''>Error: " + e.getMessage() + "</option>");
                            } finally {
                                try { if (rs != null) rs.close(); } catch (Exception e) {}
                                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                            }
                        %>
                    </select>
                </div>
                
                <!-- Room Selection -->
                <div class="form-group">
                    <label>Select Room *</label>
                    <select name="roomId" id="roomId" required onchange="calculateTotal()">
                        <option value="">-- Select Room --</option>
                        <%
                            try {
                                conn = DBConnection.getConnection();
                                stmt = conn.prepareStatement(
                                    "SELECT id, room_number, room_type, price_per_night, capacity FROM rooms WHERE is_available = TRUE"
                                );
                                rs = stmt.executeQuery();
                                while (rs.next()) {
                                    int id = rs.getInt("id");
                                    String roomNum = rs.getString("room_number");
                                    String roomType = rs.getString("room_type");
                                    double price = rs.getDouble("price_per_night");
                                    int capacity = rs.getInt("capacity");
                        %>
                            <option value="<%= id %>" data-price="<%= price %>">
                                Room <%= roomNum %> - <%= roomType %> ($<%= price %>/night, max <%= capacity %> guests)
                            </option>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<option value=''>Error: " + e.getMessage() + "</option>");
                            } finally {
                                try { if (rs != null) rs.close(); } catch (Exception e) {}
                                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                                try { if (conn != null) conn.close(); } catch (Exception e) {}
                            }
                        %>
                    </select>
                </div>
                
                <!-- Check-in Date -->
                <div class="form-group">
                    <label>Check-in Date *</label>
                    <input type="date" name="checkInDate" id="checkInDate" required onchange="calculateTotal()">
                </div>
                
                <!-- Check-out Date -->
                <div class="form-group">
                    <label>Check-out Date *</label>
                    <input type="date" name="checkOutDate" id="checkOutDate" required onchange="calculateTotal()">
                </div>
                
                <!-- Number of Guests -->
                <div class="form-group">
                    <label>Number of Guests *</label>
                    <input type="number" name="numberOfGuests" id="numberOfGuests" min="1" max="6" value="1" required>
                </div>
                
                <!-- Special Requests -->
                <div class="form-group full-width">
                    <label>Special Requests</label>
                    <textarea name="specialRequests" rows="3" placeholder="Any special requirements (e.g., extra bed, late check-in)"></textarea>
                </div>
            </div>
            
            <!-- Price Display -->
            <div class="price-box">
                <div class="price-label">Estimated Total</div>
                <div class="price-value" id="totalPrice">$0.00</div>
            </div>
            
            <button type="submit">💾 Create Reservation</button>
        </form>
    </div>

    <script>
        // Set minimum date to today
        var today = new Date().toISOString().split('T')[0];
        document.getElementById('checkInDate').min = today;
        document.getElementById('checkOutDate').min = today;
        
        function calculateTotal() {
            var roomSelect = document.getElementById('roomId');
            var checkIn = document.getElementById('checkInDate').value;
            var checkOut = document.getElementById('checkOutDate').value;
            var priceDisplay = document.getElementById('totalPrice');
            
            if (roomSelect.selectedIndex > 0 && checkIn && checkOut) {
                var pricePerNight = parseFloat(roomSelect.options[roomSelect.selectedIndex].getAttribute('data-price'));
                var start = new Date(checkIn);
                var end = new Date(checkOut);
                var nights = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
                
                if (nights > 0) {
                    var total = nights * pricePerNight;
                    priceDisplay.textContent = '$' + total.toFixed(2);
                } else {
                    priceDisplay.textContent = '$0.00';
                }
            } else {
                priceDisplay.textContent = '$0.00';
            }
        }
        
        function validateForm() {
            var guestId = document.getElementById('guestId').value;
            var roomId = document.getElementById('roomId').value;
            var checkIn = document.getElementById('checkInDate').value;
            var checkOut = document.getElementById('checkOutDate').value;
            
            if (!guestId || !roomId || !checkIn || !checkOut) {
                alert('Please fill all required fields!');
                return false;
            }
            
            var start = new Date(checkIn);
            var end = new Date(checkOut);
            
            if (end <= start) {
                alert('Check-out date must be after check-in date!');
                return false;
            }
            
            return true;
        }
    </script>

</body>
</html>
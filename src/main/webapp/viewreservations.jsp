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
    <title>View Reservations - Ocean View Resort</title>
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
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #2d3748;
            margin-bottom: 30px;
            font-size: 28px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 500;
        }
        
        td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        tr:hover {
            background: #f7fafc;
        }
        
        .badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .badge-confirmed { background: #d1fae5; color: #065f46; }
        .badge-checked-in { background: #dbeafe; color: #1e40af; }
        .badge-checked-out { background: #e5e7eb; color: #374151; }
        .badge-cancelled { background: #fee2e2; color: #991b1b; }
        
        .no-data {
            text-align: center;
            padding: 60px;
            color: #718096;
        }
        
        .price {
            font-weight: 600;
            color: #059669;
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
        <h1>📋 All Reservations</h1>
        
        <table>
            <thead>
                <tr>
                    <th>Reservation #</th>
                    <th>Guest Name</th>
                    <th>Room</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th>Nights</th>
                    <th>Guests</th>
                    <th>Total</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Connection conn = DBConnection.getConnection();
                        String sql = "SELECT r.*, g.first_name, g.last_name, rm.room_number, rm.room_type " +
                                     "FROM reservations r " +
                                     "JOIN guests g ON r.guest_id = g.id " +
                                     "JOIN rooms rm ON r.room_id = rm.id " +
                                     "ORDER BY r.created_at DESC";
                        
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery();
                        
                        boolean hasData = false;
                        
                        while (rs.next()) {
                            hasData = true;
                            
                            // Calculate nights
                            java.sql.Date checkIn = rs.getDate("check_in_date");
                            java.sql.Date checkOut = rs.getDate("check_out_date");
                            long nights = (checkOut.getTime() - checkIn.getTime()) / (1000 * 60 * 60 * 24);
                            
                            String status = rs.getString("status");
                            String badgeClass = "";
                            switch(status) {
                                case "CONFIRMED": badgeClass = "badge-confirmed"; break;
                                case "CHECKED_IN": badgeClass = "badge-checked-in"; break;
                                case "CHECKED_OUT": badgeClass = "badge-checked-out"; break;
                                case "CANCELLED": badgeClass = "badge-cancelled"; break;
                                default: badgeClass = "badge-confirmed";
                            }
                %>
                    <tr>
                        <td><strong><%= rs.getString("reservation_number") %></strong></td>
                        <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
                        <td>Room <%= rs.getString("room_number") %> (<%= rs.getString("room_type") %>)</td>
                        <td><%= checkIn %></td>
                        <td><%= checkOut %></td>
                        <td><%= nights %></td>
                        <td><%= rs.getInt("number_of_guests") %></td>
                        <td class="price">$<%= String.format("%.2f", rs.getDouble("total_amount")) %></td>
                        <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                    </tr>
                <%
                        }
                        
                        if (!hasData) {
                %>
                    <tr>
                        <td colspan="9" class="no-data">
                            <h3>No reservations found</h3>
                            <p><a href="addreservation.jsp">Create your first reservation →</a></p>
                        </td>
                    </tr>
                <%
                        }
                        
                        rs.close();
                        stmt.close();
                        
                    } catch (Exception e) {
                        out.println("<tr><td colspan='9' style='color:red; padding:20px;'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>
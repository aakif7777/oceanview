<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.util.BillDAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    ResultSet bills = BillDAO.getAllBills();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Bills - Ocean View Resort</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: #f5f7fa;
        }
        
        /* Navigation */
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
            max-width: 1200px;
            margin: 0 auto;
        }
        
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        
        /* Table */
        .bills-table {
            width: 100%;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-collapse: collapse;
        }
        
        .bills-table th {
            background: #667eea;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .bills-table td {
            padding: 15px;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .bills-table tr:hover {
            background: #f9fafb;
        }
        
        .bills-table tr:last-child td {
            border-bottom: none;
        }
        
        .total-cell {
            color: #059669;
            font-weight: bold;
        }
        
        .no-bills {
            text-align: center;
            padding: 40px;
            color: #6b7280;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .btn:hover {
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
            <a href="calculatebill.jsp">Calculate Bill</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <h1>📋 All Bills History</h1>
        <a href="calculatebill.jsp" class="btn">+ Create New Bill</a>
        
        <table class="bills-table">
            <thead>
                <tr>
                    <th>Bill ID</th>
                    <th>Guest Name</th>
                    <th>Pax</th>
                    <th>Nights</th>
                    <th>Room Rate</th>
                    <th>Subtotal</th>
                    <th>Tax</th>
                    <th>Total</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if (bills != null) {
                    try {
                        boolean hasBills = false;
                        while (bills.next()) {
                            hasBills = true;
                %>
                    <tr>
                        <td>#<%= bills.getInt("bill_id") %></td>
                        <td><%= bills.getString("guest_name") %></td>
                        <td><%= bills.getInt("number_of_pax") %></td>
                        <td><%= bills.getInt("number_of_nights") %></td>
                        <td>$<%= bills.getDouble("room_rate") %></td>
                        <td>$<%= String.format("%.2f", bills.getDouble("subtotal")) %></td>
                        <td>$<%= String.format("%.2f", bills.getDouble("tax_amount")) %></td>
                        <td class="total-cell">$<%= String.format("%.2f", bills.getDouble("total_amount")) %></td>
                        <td><%= bills.getTimestamp("bill_date") %></td>
                    </tr>
                <% 
                        }
                        if (!hasBills) {
                %>
                    <tr>
                        <td colspan="9" class="no-bills">No bills found in database</td>
                    </tr>
                <% 
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                %>
                    <tr>
                        <td colspan="9" class="no-bills">Error loading bills: <%= e.getMessage() %></td>
                    </tr>
                <% 
                    }
                } else {
                %>
                    <tr>
                        <td colspan="9" class="no-bills">Could not connect to database</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</body>
</html>
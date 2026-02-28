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
    <title>View Guests - Ocean View Resort</title>
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
            max-width: 1200px;
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
        
        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: 700;
        }
        
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
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
        
        .no-data {
            text-align: center;
            padding: 60px;
            color: #718096;
        }
        
        .no-data a {
            color: #667eea;
            text-decoration: none;
        }
        
        .badge {
            background: #d4edda;
            color: #155724;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
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
            <a href="logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <h1>📋 All Guests in Database</h1>
        
        <%-- Count guests --%>
        <%
            int totalGuests = 0;
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM guests");
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    totalGuests = rs.getInt(1);
                }
                rs.close();
                stmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        
        <div class="stats">
            <div class="stat-box">
                <div class="stat-number"><%= totalGuests %></div>
                <div class="stat-label">Total Guests</div>
            </div>
            <div class="stat-box">
                <div class="stat-number"><%= totalGuests > 0 ? "Active" : "Empty" %></div>
                <div class="stat-label">Database Status</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">MySQL</div>
                <div class="stat-label">Connected</div>
            </div>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>Guest ID</th>
                    <th>Full Name</th>
                    <th>Address</th>
                    <th>Contact</th>
                    <th>Email</th>
                    <th>Registered</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Connection conn = DBConnection.getConnection();
                        String sql = "SELECT * FROM guests ORDER BY created_at DESC";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery();
                        
                        boolean hasData = false;
                        
                        while (rs.next()) {
                            hasData = true;
                %>
                    <tr>
                        <td><strong><%= rs.getString("guest_id") %></strong></td>
                        <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
                        <td><%= rs.getString("address") != null ? rs.getString("address") : "-" %></td>
                        <td><%= rs.getString("contact_number") != null ? rs.getString("contact_number") : "-" %></td>
                        <td><%= rs.getString("email") != null ? rs.getString("email") : "-" %></td>
                        <td><span class="badge"><%= rs.getTimestamp("created_at") %></span></td>
                    </tr>
                <%
                        }
                        
                        if (!hasData) {
                %>
                    <tr>
                        <td colspan="6" class="no-data">
                            <h3>No guests found in database</h3>
                            <p><a href="addguest.jsp">Add your first guest →</a></p>
                        </td>
                    </tr>
                <%
                        }
                        
                        rs.close();
                        stmt.close();
                        
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' style='color:red; padding:20px;'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>
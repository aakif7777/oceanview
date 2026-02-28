<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.model.BillCalculator" %>
<%@ page import="com.oceanview.util.BillDAO" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Get form data
    String guestName = request.getParameter("guestName");
    int numberOfPax = Integer.parseInt(request.getParameter("numberOfPax"));
    int numberOfNights = Integer.parseInt(request.getParameter("numberOfNights"));
    double roomRate = Double.parseDouble(request.getParameter("roomRate"));
    int roomId = Integer.parseInt(request.getParameter("roomId")); // ADD THIS LINE
    
    // Create calculator object
    BillCalculator calc = new BillCalculator(numberOfPax, numberOfNights, roomRate);
    double subtotal = calc.calculateSubtotal();
    double tax = calc.calculateTax();
    double total = calc.calculateTotal();
    
    // Save to database
    boolean saved = BillDAO.saveBill(guestName, numberOfPax, numberOfNights, roomRate, calc);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill Result - Ocean View Resort</title>
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
        
        .nav-links a:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        }
        /* Success/Error Message */
        .message {
            max-width: 500px;
            margin: 0 auto 20px auto;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
        }
        
        .success {
            background: #d1fae5;
            color: #059669;
            border: 1px solid #a7f3d0;
        }
        
        .error {
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        
        /* Bill Container */
        .bill-container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header {
            text-align: center;
            border-bottom: 2px solid #667eea;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        
        .header h1 {
            color: #667eea;
            margin: 0;
        }
        
        .header p {
            color: #888;
            margin-top: 5px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        
        .total-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        
        .grand-total {
            font-size: 24px;
            color: #059669;
            font-weight: bold;
            text-align: right;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 2px solid #ddd;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            margin: 10px 5px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            border: none;
            font-size: 14px;
        }
        
        .btn-print {
            background: #667eea;
            color: white;
        }
        
        .btn-print:hover {
            background: #5568d3;
        }
        
        .btn-new {
            background: #e2e8f0;
            color: #333;
        }
        
        .btn-view {
            background: #059669;
            color: white;
        }
        
        .btn-view:hover {
            background: #047857;
        }
        
        .actions {
            text-align: center;
            margin-top: 30px;
        }
        
        @media print {
            .navbar, .btn, .message { 
                display: none !important; 
            }
            body { 
                background: white; 
                padding: 0;
            }
            .bill-container {
                box-shadow: none;
                max-width: 100%;
            }
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
            <a href="viewbills.jsp">View Bills</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <!-- Database Save Message -->
    <% if (saved) { %>
        <div class="message success">
            ✅ Bill saved to database successfully!
        </div>
    <% } else { %>
        <div class="message error">
            ❌ Error saving bill to database!
        </div>
    <% } %>

    <!-- Bill Result -->
    <div class="bill-container" id="bill">
        <div class="header">
            <h1>🌊 Ocean View Resort</h1>
            <p>Guest Bill</p>
        </div>
        
        <div class="info-row">
            <span><strong>Guest Name:</strong></span>
            <span><%= guestName %></span>
        </div>
        <div class="info-row">
            <span><strong>Number of Pax:</strong></span>
            <span><%= numberOfPax %></span>
        </div>
        <div class="info-row">
            <span><strong>Nights:</strong></span>
            <span><%= numberOfNights %></span>
        </div>
        <div class="info-row">
            <span><strong>Rate per Night:</strong></span>
            <span>$<%= roomRate %></span>
        </div>
        
        <div class="total-section">
            <div class="info-row">
                <span>Subtotal:</span>
                <span>$<%= String.format("%.2f", subtotal) %></span>
            </div>
            <div class="info-row">
                <span>Tax (12%):</span>
                <span>$<%= String.format("%.2f", tax) %></span>
            </div>
            <div class="grand-total">
                TOTAL: $<%= String.format("%.2f", total) %>
            </div>
        </div>
        
        <div class="actions">
            <button class="btn btn-print" onclick="window.print()">🖨️ Print Bill</button>
            <a href="calculatebill.jsp" class="btn btn-new">🔄 New Bill</a>
            <a href="viewbills.jsp" class="btn btn-view">📋 View All Bills</a>
        </div>
    </div>

</body>
</html>
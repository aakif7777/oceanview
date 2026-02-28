<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.util.StatisticsService" %>
<%
    // Check if user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Fetch real statistics from database - USE CORRECT METHOD NAMES
    int availableRooms = StatisticsService.getAvailableRoomsCount();      // FIXED
    int occupiedRooms = StatisticsService.getOccupiedRoomsCount();        // FIXED
    int todayCheckIns = StatisticsService.getTodayCheckIns();             // OK
    int todayCheckOuts = StatisticsService.getTodayCheckOuts();           // OK
    int totalGuests = StatisticsService.getTotalGuests();                 // OK
    int totalReservations = StatisticsService.getActiveReservations();    // FIXED
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Ocean View Resort</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        
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
        
        /* Main Container */
        .container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 40px;
        }
        
        /* Welcome Card */
        .welcome-card {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .welcome-card h1 {
            color: #2d3748;
            margin-bottom: 10px;
            font-size: 32px;
            font-weight: 600;
        }
        
        .welcome-card p {
            color: #718096;
            font-size: 16px;
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.12);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 28px;
        }
        
        .stat-card:nth-child(1) .stat-icon { background: #e0e7ff; }
        .stat-card:nth-child(2) .stat-icon { background: #fce7f3; }
        .stat-card:nth-child(3) .stat-icon { background: #d1fae5; }
        .stat-card:nth-child(4) .stat-icon { background: #fef3c7; }
        
        .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #718096;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 500;
        }
        
        /* Secondary Stats */
        .secondary-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .secondary-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .secondary-info h3 {
            font-size: 14px;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .secondary-info .number {
            font-size: 32px;
            font-weight: 700;
        }
        
        .secondary-icon {
            font-size: 40px;
            opacity: 0.3;
        }
        
        /* Menu Grid */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
        }
        
        .menu-card {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            text-align: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid transparent;
            text-decoration: none;
            display: block;
        }
        
        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            border-color: #e2e8f0;
        }
        
        .menu-icon {
            width: 80px;
            height: 80px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            font-size: 36px;
            transition: transform 0.3s;
        }
        
        .menu-card:hover .menu-icon {
            transform: scale(1.1) rotate(5deg);
        }
        
        .menu-card:nth-child(1) .menu-icon { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .menu-card:nth-child(2) .menu-icon { 
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .menu-card:nth-child(3) .menu-icon { 
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        .menu-card:nth-child(4) .menu-icon { 
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }
        .menu-card:nth-child(5) .menu-icon { 
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }
        .menu-card:nth-child(6) .menu-icon { 
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            color: #764ba2;
        }
        
        .menu-card h3 {
            color: #2d3748;
            margin-bottom: 12px;
            font-size: 20px;
            font-weight: 600;
        }
        
        .menu-card p {
            color: #718096;
            font-size: 14px;
            line-height: 1.6;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .menu-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }
            .nav-links {
                display: none;
            }
            .container {
                padding: 0 20px;
            }
            .stats-grid, .menu-grid, .secondary-stats {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-brand">
            <span>🌊</span>
            <span>Ocean View Resort</span>
        </div>
        <div class="nav-links">
            <a href="addguest.jsp">👥 Add Guest</a>
            <a href="viewguests.jsp">📋 View Guests</a>
            <a href="addroom.jsp">Add Room</a>
            <a href="addreservation.jsp">🛏️ New Reservation</a>
            <a href="calculatebill.jsp">Calculate Bill</a>
            <a href="logout">🚪 Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        
       
        <!-- Welcome -->>
        <div class="welcome-card">
            <h1>Welcome back, <%= session.getAttribute("fullName") %>! 👋</h1>
            <p>Manage your room reservations efficiently. Here's what's happening today at Ocean View Resort.</p>
        </div>
        
        <!-- Main Statistics -->
<%@ page import="com.oceanview.util.StatisticsService" %>

<!-- Statistics -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon">🚪</div>
        <div class="stat-number"><%= StatisticsService.getAvailableRoomsCount() %></div>
        <div class="stat-label">Available Rooms</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">🛏️</div>
        <div class="stat-number"><%= StatisticsService.getOccupiedRoomsCount() %></div>
        <div class="stat-label">Currently Occupied</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">📅</div>
        <div class="stat-number"><%= StatisticsService.getActiveReservations() %></div>
        <div class="stat-label">Active Reservations</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">👥</div>
        <div class="stat-number"><%= StatisticsService.getTotalGuests() %></div>
        <div class="stat-label">Total Guests</div>
    </div>
</div>
<!-- Today's Activity -->
<div class="secondary-stats">
    <div class="secondary-card">
        <div class="secondary-info">
            <h3>Check-ins Today</h3>
            <div class="number"><%= todayCheckIns %></div>
        </div>
        <div class="secondary-icon">📥</div>
    </div>
    <div class="secondary-card">
        <div class="secondary-info">
            <h3>Check-outs Today</h3>
            <div class="number"><%= todayCheckOuts %></div>
        </div>
        <div class="secondary-icon">📤</div>
    </div>
    <div class="secondary-card">
        <div class="secondary-info">
            <h3>Upcoming (7 days)</h3>
            <div class="number"><%= StatisticsService.getTodayCheckIns() %></div>
        </div>
        <div class="secondary-icon">📆</div>
    </div>
    <div class="secondary-card">
        <div class="secondary-info">
            <h3>Total Reservations</h3>
            <div class="number"><%= totalReservations %></div>
        </div>
        <div class="secondary-icon">📝</div>
    </div>
</div>
        
        <!-- Secondary Statistics -->
        <div class="secondary-stats">
            <div class="secondary-card">
                <div class="secondary-info">
                    <h3>Total Guests</h3>
                    <div class="number"><%= totalGuests %></div>
                </div>
                <div class="secondary-icon">👥</div>
            </div>
            
            <div class="secondary-card">
                <div class="secondary-info">
                    <h3>Total Reservations</h3>
                    <div class="number"><%= totalReservations %></div>
                </div>
                <div class="secondary-icon">📅</div>
            </div>
        </div>
        
        <!-- Menu -->
        <div class="menu-grid">
            <a href="addreservation.jsp" class="menu-card">
                <div class="menu-icon">➕</div>
                <h3>New Reservation</h3>
                <p>Create a new room booking for guests with all details</p>
            </a>
            
            <a href="viewreservations.jsp" class="menu-card">
                <div class="menu-icon">📋</div>
                <h3>View Reservations</h3>
                <p>See all current, upcoming and past bookings</p>
            </a>
            
            <a href="viewguests.jsp" class="menu-card">
                <div class="menu-icon">👥</div>
                <h3>Guest Management</h3>
                <p>Manage guest information and booking history</p>
            </a>
            
            <a href="#" class="menu-card">
                <div class="menu-icon">🏨</div>
                <h3>Room Status</h3>
                <p>Check availability and manage room assignments</p>
            </a>
            
                      <a href="calculatebill.jsp" class="menu-card">
    <div class="menu-icon">💰</div>
    <h3>Calculate Bill</h3>
    <p>Calculate and print guest bills</p>
</a>
     
            
            <a href="#" class="menu-card" onclick="alert('Help Center\n\n1. Add Guest: Create new guest profile\n2. New Reservation: Book room for guest\n3. View Guests: See all registered guests\n4. View Reservations: See all bookings\n\nContact: admin@oceanview.com')">
                <div class="menu-icon">❓</div>
                <h3>Help Center</h3>
                <p>Get help and guidance on using the system</p>
            </a>
            
       
        </div>
        
    </div>

</body>
</html>
package com.oceanview.controller;

import com.oceanview.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addreservation")
public class AddReservationServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== ADD RESERVATION SERVLET STARTED ===");
        
        try {
            // Get form data
            String guestIdStr = request.getParameter("guestId");
            String roomIdStr = request.getParameter("roomId");
            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");
            String guestsStr = request.getParameter("numberOfGuests");
            String specialRequests = request.getParameter("specialRequests");
            
            System.out.println("Guest ID: " + guestIdStr);
            System.out.println("Room ID: " + roomIdStr);
            System.out.println("Check In: " + checkInStr);
            System.out.println("Check Out: " + checkOutStr);
            
            // Check for null values
            if (guestIdStr == null || roomIdStr == null || checkInStr == null || checkOutStr == null ||
                guestIdStr.isEmpty() || roomIdStr.isEmpty() || checkInStr.isEmpty() || checkOutStr.isEmpty()) {
                
                System.out.println("❌ ERROR: Empty form fields!");
                request.setAttribute("error", "Please fill all required fields!");
                request.getRequestDispatcher("addreservation.jsp").forward(request, response);
                return;
            }
            
            // Parse values
            int guestId = Integer.parseInt(guestIdStr);
            int roomId = Integer.parseInt(roomIdStr);
            LocalDate checkIn = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);
            int numberOfGuests = Integer.parseInt(guestsStr != null ? guestsStr : "1");
            
            System.out.println("=== Parsed successfully ===");
            
            try (Connection conn = DBConnection.getConnection()) {
                
                // Check room availability
                if (!isRoomAvailable(conn, roomId, checkIn, checkOut)) {
                    request.setAttribute("error", "Room is not available for selected dates!");
                    request.getRequestDispatcher("addreservation.jsp").forward(request, response);
                    return;
                }
                
                // Calculate price
                double pricePerNight = getRoomPrice(conn, roomId);
                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
                double totalAmount = nights * pricePerNight;
                
                // Generate reservation number
                String reservationNumber = generateReservationNumber(conn);
                
                // Insert reservation
                String sql = "INSERT INTO reservations (reservation_number, guest_id, room_id, " +
                            "check_in_date, check_out_date, number_of_guests, total_amount, " +
                            "special_requests, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED')";
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, reservationNumber);
                    stmt.setInt(2, guestId);
                    stmt.setInt(3, roomId);
                    stmt.setDate(4, java.sql.Date.valueOf(checkIn));
                    stmt.setDate(5, java.sql.Date.valueOf(checkOut));
                    stmt.setInt(6, numberOfGuests);
                    stmt.setDouble(7, totalAmount);
                    stmt.setString(8, specialRequests != null ? specialRequests : "");
                    
                    int rows = stmt.executeUpdate();
                    
                    if (rows > 0) {
                        System.out.println("✅ Reservation created: " + reservationNumber);
                        request.setAttribute("success", "Reservation " + reservationNumber + 
                                           " created! Total: $" + String.format("%.2f", totalAmount));
                    } else {
                        request.setAttribute("error", "Failed to create reservation!");
                    }
                }
            }
            
        } catch (Exception e) {
            System.out.println("❌ ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        request.getRequestDispatcher("addreservation.jsp").forward(request, response);
    }
    
    private boolean isRoomAvailable(Connection conn, int roomId, LocalDate checkIn, LocalDate checkOut) 
            throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE room_id = ? " +
                     "AND status != 'CANCELLED' " +
                     "AND ((check_in_date BETWEEN ? AND ?) " +
                     "OR (check_out_date BETWEEN ? AND ?) " +
                     "OR (check_in_date <= ? AND check_out_date >= ?))";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 1; i <= 7; i++) {
                if (i == 1) stmt.setInt(i, roomId);
                else stmt.setDate(i, java.sql.Date.valueOf(i % 2 == 0 ? checkIn : checkOut));
            }
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        }
        return false;
    }
    
    private double getRoomPrice(Connection conn, int roomId) throws SQLException {
        String sql = "SELECT price_per_night FROM rooms WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("price_per_night");
            }
        }
        return 0;
    }
    
    private String generateReservationNumber(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1) + 1;
                return String.format("RES%03d", count);
            }
        }
        return "RES001";
    }
}
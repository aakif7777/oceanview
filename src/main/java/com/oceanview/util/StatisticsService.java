package com.oceanview.util;

import java.sql.*;

public class StatisticsService {
    
    // Available rooms count
    public static int getAvailableRoomsCount() {
        return RoomDAO.getAvailableRoomCount();
    }
    
    // Occupied rooms count - FIXED: changed 'available' to 'is_available'
    public static int getOccupiedRoomsCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM rooms WHERE is_available = 0"; // FIXED
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // Total rooms count
    public static int getTotalRoomsCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM rooms";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // Active reservations - FIXED: changed 'active' to 'CONFIRMED'
    public static int getActiveReservations() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = 'CONFIRMED'"; // FIXED
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // ADD THIS: Total reservations (all statuses)
    public static int getTotalReservations() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM reservations"; // All reservations
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // Total guests
    public static int getTotalGuests() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM guests";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // Today's check-ins
    public static int getTodayCheckIns() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM reservations WHERE check_in_date = CURDATE()";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // Today's check-outs
    public static int getTodayCheckOuts() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM reservations WHERE check_out_date = CURDATE()";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // Upcoming check-ins (next 7 days)
    public static int getUpcomingCheckIns() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM reservations WHERE check_in_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }
}
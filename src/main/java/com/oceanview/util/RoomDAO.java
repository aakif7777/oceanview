package com.oceanview.util;

import com.oceanview.model.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {
    
    // ==================== GET ALL ROOMS ====================
    public static List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_number";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Room room = extractRoomFromResultSet(rs);
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    // ==================== GET AVAILABLE ROOMS ====================
    public static List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE is_available = 1 ORDER BY room_number";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Room room = extractRoomFromResultSet(rs);
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    // ==================== GET AVAILABLE ROOM COUNT ====================
    public static int getAvailableRoomCount() {
        int count = 0;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT COUNT(*) FROM rooms WHERE is_available = 1")) {
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return count;
    }
    
    // ==================== GET ROOM BY ROOM NUMBER ====================
    public static Room getRoomByRoomNumber(String roomNumber) {
        String sql = "SELECT * FROM rooms WHERE room_number = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, roomNumber);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractRoomFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // ==================== GET ROOM RATE BY ROOM NUMBER ====================
    public static double getRoomRate(String roomNumber) {
        String sql = "SELECT price_per_night FROM rooms WHERE room_number = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, roomNumber);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("price_per_night");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    // ==================== UPDATE ROOM AVAILABILITY ====================
    public static boolean updateRoomAvailability(String roomNumber, boolean isAvailable) {
        String sql = "UPDATE rooms SET is_available = ? WHERE room_number = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, isAvailable);
            stmt.setString(2, roomNumber);
            
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ==================== ADD NEW ROOM ====================
    public static boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_number, room_type, price_per_night, is_available, capacity, description) " +
                     "VALUES (?, ?, ?, 1, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, room.getRoomNumber());
            stmt.setString(2, room.getRoomType());
            stmt.setDouble(3, room.getRoomRate());
            stmt.setInt(4, room.getCapacity());
            stmt.setString(5, room.getDescription());
            
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ==================== DELETE ROOM ====================
    public static boolean deleteRoom(String roomNumber) {
        String sql = "DELETE FROM rooms WHERE room_number = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, roomNumber);
            
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ==================== HELPER METHOD ====================
    private static Room extractRoomFromResultSet(ResultSet rs) throws SQLException {
        Room room = new Room();
        // No ID column, use room_number as identifier
        room.setRoomId(0); // or remove this field from Room.java
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(rs.getString("room_type"));
        room.setRoomRate(rs.getDouble("price_per_night"));
        room.setStatus(rs.getInt("is_available") == 1 ? "available" : "occupied");
        room.setCapacity(rs.getInt("capacity"));
        room.setDescription(rs.getString("description"));
        return room;
    }
}
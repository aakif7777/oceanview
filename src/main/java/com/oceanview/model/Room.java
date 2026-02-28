package com.oceanview.model;

public class Room {
    
    // Private fields (encapsulation)
    // Note: No roomId field since your table uses room_number as primary key
    private String roomNumber;  // This is your primary key
    private String roomType;
    private double roomRate;
    private String status;
    private String description;
    private int capacity;
    
    // Default constructor
    public Room() {
    }
    
    // Parameterized constructor (without roomId)
    public Room(String roomNumber, String roomType, double roomRate, 
                String status, String description, int capacity) {
        this.roomNumber = roomNumber;
        this.roomType = roomType;
        this.roomRate = roomRate;
        this.status = status;
        this.description = description;
        this.capacity = capacity;
    }
    
    // Getters and Setters
    
    // Keep this for backward compatibility (returns 0 since no ID in your table)
    public int getRoomId() {
        return 0;
    }
    
    // Keep this for backward compatibility (does nothing)
    public void setRoomId(int roomId) {
        // No ID column in your table, ignore this
    }
    
    public String getRoomNumber() {
        return roomNumber;
    }
    
    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }
    
    public String getRoomType() {
        return roomType;
    }
    
    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }
    
    public double getRoomRate() {
        return roomRate;
    }
    
    public void setRoomRate(double roomRate) {
        this.roomRate = roomRate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getCapacity() {
        return capacity;
    }
    
    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
    
    // toString method for debugging
    @Override
    public String toString() {
        return "Room [roomNumber=" + roomNumber + 
               ", roomType=" + roomType + 
               ", roomRate=" + roomRate + 
               ", status=" + status + "]";
    }
}
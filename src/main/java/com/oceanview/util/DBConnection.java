package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Class
 * Connects to MySQL Workbench database
 */
public class DBConnection {
    
    // ============================================
    // DATABASE SETTINGS - CHANGE IF NEEDED
    // ============================================
    
    // URL format: jdbc:mysql://host:port/databaseName?options
    private static final String URL = 
        "jdbc:mysql://localhost:3306/oceanview_resort?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    
    // Default XAMPP/WAMP username is "root"
    private static final String USERNAME = "root";
    
    // Default XAMPP/WAMP password is EMPTY (blank)
    // If you set a password in MySQL, type it here
    private static final String PASSWORD = "infected_123";
    
    // ============================================
    // CONNECTION METHODS
    // ============================================
    
    private static Connection connection = null;
    
    /**
     * Get database connection
     */
    public static Connection getConnection() {
        try {
            // Load MySQL driver (only once)
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Create connection
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            
            System.out.println("✅ Database connected successfully!");
            
        } catch (ClassNotFoundException e) {
            System.out.println("❌ ERROR: MySQL Driver not found!");
            System.out.println("   Add mysql-connector-java to pom.xml");
            e.printStackTrace();
            
        } catch (SQLException e) {
            System.out.println("❌ ERROR: Cannot connect to database!");
            System.out.println("   Check if MySQL is running");
            System.out.println("   Check username/password");
            System.out.println("   Error: " + e.getMessage());
        }
        
        return connection;
    }
    
    /**
     * Close database connection
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("✅ Database connection closed.");
            }
        } catch (SQLException e) {
            System.out.println("❌ ERROR closing connection: " + e.getMessage());
        }
    }
    
    /**
     * Test if connection works
     */
    public static boolean testConnection() {
        try {
            Connection conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println("❌ Test failed: " + e.getMessage());
        }
        return false;
    }
}
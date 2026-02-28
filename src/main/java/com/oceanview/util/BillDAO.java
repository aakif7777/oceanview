package com.oceanview.util;

import com.oceanview.model.BillCalculator;
import java.sql.*;

public class BillDAO {
    
    // Save bill to database
    public static boolean saveBill(String guestName, int pax, int nights, 
                                    double roomRate, BillCalculator calc) {
        
        String sql = "INSERT INTO bills (guest_name, number_of_pax, number_of_nights, " +
                     "room_rate, subtotal, tax_amount, total_amount) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, guestName);
            stmt.setInt(2, pax);
            stmt.setInt(3, nights);
            stmt.setDouble(4, roomRate);
            stmt.setDouble(5, calc.calculateSubtotal());
            stmt.setDouble(6, calc.calculateTax());
            stmt.setDouble(7, calc.calculateTotal());
            
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all bills (for viewing history)
    public static ResultSet getAllBills() {
        String sql = "SELECT * FROM bills ORDER BY bill_date DESC";
        
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            return stmt.executeQuery(sql);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
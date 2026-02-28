package com.oceanview.controller;

import com.oceanview.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Add Guest Servlet - Saves guest to MySQL database
 */
@WebServlet("/addguest")
public class AddGuestServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form data
        String guestId = request.getParameter("guestId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contactNumber");
        String email = request.getParameter("email");
        
        System.out.println("Adding guest: " + firstName + " " + lastName);
        
        // SQL insert statement
        String sql = "INSERT INTO guests (guest_id, first_name, last_name, address, contact_number, email) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Set values
            stmt.setString(1, guestId);
            stmt.setString(2, firstName);
            stmt.setString(3, lastName);
            stmt.setString(4, address);
            stmt.setString(5, contactNumber);
            stmt.setString(6, email);
            
            // Execute insert
            int rowsInserted = stmt.executeUpdate();
            
            if (rowsInserted > 0) {
                System.out.println("✅ Guest saved to database: " + firstName + " " + lastName);
                request.setAttribute("success", "Guest " + firstName + " " + lastName + " saved to database!");
            } else {
                request.setAttribute("error", "Failed to save guest!");
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Database error: " + e.getMessage());
            
            // Check if duplicate guest ID
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Guest ID '" + guestId + "' already exists!");
            } else {
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
        }
        
        // Go back to form
        request.getRequestDispatcher("addguest.jsp").forward(request, response);
    }
}
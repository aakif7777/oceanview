package com.oceanview.controller;

import com.oceanview.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Login Servlet with Database Authentication
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Login attempt: " + username);
        
        // Check in database
        User user = validateUserFromDB(username, password);
        
        if (user != null) {
            // Login successful
            HttpSession session = request.getSession();
            session.setAttribute("username", user.username);
            session.setAttribute("fullName", user.fullName);
            session.setAttribute("role", user.role);
            
            System.out.println("✅ Login successful: " + user.fullName);
            response.sendRedirect("welcome.jsp");
            
        } else {
            // Login failed
            request.setAttribute("error", "Invalid username or password!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
    
    /**
     * Check user in MySQL database
     */
    private User validateUserFromDB(String username, String password) {
        String sql = "SELECT username, full_name, role FROM users " +
                     "WHERE username = ? AND password = ? AND is_active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.username = rs.getString("username");
                user.fullName = rs.getString("full_name");
                user.role = rs.getString("role");
                return user;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Database error: " + e.getMessage());
        }
        
        return null;
    }
    
    // Simple inner class to hold user data
    private class User {
        String username;
        String fullName;
        String role;
    }
}
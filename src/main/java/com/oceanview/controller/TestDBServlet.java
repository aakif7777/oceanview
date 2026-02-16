package com.oceanview.controller;

import com.oceanview.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head>");
        out.println("<style>");
        out.println("body{font-family:Arial;padding:40px;background:#f5f5f5}");
        out.println(".box{background:white;padding:30px;border-radius:10px;max-width:600px;margin:0 auto}");
        out.println(".success{color:green;font-size:20px}");
        out.println(".error{color:red;font-size:20px}");
        out.println("</style></head><body>");
        
        out.println("<div class='box'>");
        out.println("<h1>🗄️ Database Connection Test</h1><hr>");
        
        // Test connection
        boolean isConnected = DBConnection.testConnection();
        
        if (isConnected) {
            out.println("<p class='success'>✅ Database is CONNECTED!</p>");
            out.println("<p>Database: oceanview_resort</p>");
            out.println("<p>Host: localhost:3306</p>");
            out.println("<br><a href='index.jsp'>Go to Login</a>");
        } else {
            out.println("<p class='error'>❌ Database connection FAILED!</p>");
            out.println("<h3>Check these:</h3>");
            out.println("<ol>");
            out.println("<li>Is MySQL Workbench running?</li>");
            out.println("<li>Did you create database 'oceanview_resort'?</li>");
            out.println("<li>Is username 'root' and password correct?</li>");
            out.println("<li>Check Eclipse Console for error details</li>");
            out.println("</ol>");
        }
        
        out.println("</div></body></html>");
    }
}
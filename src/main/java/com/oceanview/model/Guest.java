package com.oceanview.model;

/**
 * Guest class - stores guest information
 * This is a POJO (Plain Old Java Object) with OOP encapsulation
 */
public class Guest {
    
    // PRIVATE variables (Encapsulation - hide data)
    private Long id;
    private String guestId;
    private String firstName;
    private String lastName;
    private String address;
    private String contactNumber;
    private String email;
    
    // EMPTY constructor (required)
    public Guest() {
    }
    
    // CONSTRUCTOR with all fields
    public Guest(String guestId, String firstName, String lastName, 
                 String address, String contactNumber, String email) {
        this.guestId = guestId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.address = address;
        this.contactNumber = contactNumber;
        this.email = email;
    }
    
    // HELPER method - get full name
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    // GETTERS and SETTERS (access private data)
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getGuestId() {
        return guestId;
    }
    
    public void setGuestId(String guestId) {
        this.guestId = guestId;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getContactNumber() {
        return contactNumber;
    }
    
    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    // toString for easy printing
    @Override
    public String toString() {
        return "Guest [guestId=" + guestId + ", name=" + getFullName() + "]";
    }
}
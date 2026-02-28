package com.oceanview.model;

public class BillCalculator {
    
    private int numberOfPax;
    private int numberOfNights;
    private double roomRatePerNight;
    private double taxRate = 0.12;
    
    public BillCalculator(int numberOfPax, int numberOfNights, double roomRatePerNight) {
        this.numberOfPax = numberOfPax;
        this.numberOfNights = numberOfNights;
        this.roomRatePerNight = roomRatePerNight;
    }
    
    public double calculateSubtotal() {
        return numberOfPax * numberOfNights * roomRatePerNight;
    }
    
    public double calculateTax() {
        return calculateSubtotal() * taxRate;
    }
    
    public double calculateTotal() {
        return calculateSubtotal() + calculateTax();
    }
}
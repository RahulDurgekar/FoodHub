package com.foodDelivery.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    
    private Map<Integer, CartItem> items;
    private int restaurantId; // Track which restaurant's items are in cart
    
    public Cart() {
        items = new HashMap<Integer, CartItem>();
        restaurantId = 0;
    }
    
    // Add item to cart
    public void addItem(CartItem item) {
        // If item is from a different restaurant, reset cart first
        if (restaurantId != 0 && restaurantId != item.getRestaurantId()) {
            items.clear();
            restaurantId = item.getRestaurantId();
        }

        int menuId = item.getMenuId();
        
        if (items.containsKey(menuId)) {
            // Item exists - update quantity
            CartItem existingItem = items.get(menuId);
            existingItem.setQty(existingItem.getQty() + item.getQty());
        } else {
            // New item - add to cart
            items.put(menuId, item);
            // Set the restaurant ID for the cart
            if (restaurantId == 0) {
                restaurantId = item.getRestaurantId();
            }
        }
    }
    
    // Update item quantity
    public void updateItemQty(int menuId, int newQty) {
        if (items.containsKey(menuId)) {
            if (newQty <= 0) {
                items.remove(menuId);
            } else {
                items.get(menuId).setQty(newQty);
            }
        }
        // If cart becomes empty, reset restaurantId
        if (items.isEmpty()) {
            restaurantId = 0;
        }
    }
    
    // Remove item from cart
    public void removeItem(int menuId) {
        items.remove(menuId);
        if (items.isEmpty()) {
            restaurantId = 0;
        }
    }
    
    // Clear entire cart
    public void clearCart() {
        items.clear();
        restaurantId = 0;
    }
    
    // Get all items
    public Map<Integer, CartItem> getItems() {
        return items;
    }
    
    // Get total items count
    public int getTotalItems() {
        int count = 0;
        for (CartItem item : items.values()) {
            count += item.getQty();
        }
        return count;
    }
    
    // Get total price
    public double getTotalPrice() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getPrice() * item.getQty();
        }
        return total;
    }
    
    public int getRestaurantId() {
        return restaurantId;
    }
    
    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public boolean isEmpty() {
        return items.isEmpty();
    }
    
    @Override
    public String toString() {
        return "Cart [items=" + items + ", restaurantId=" + restaurantId + "]";
    }
}
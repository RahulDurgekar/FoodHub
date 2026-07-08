package com.foodDelivery.model;

public class Cart {

    private int cartId;
    private int userId;
    private int menuId;
    private int quantity;
    private double totalPrice;

    public Cart() {
    }

    public Cart(int cartId, int userId, int menuId,
                int quantity, double totalPrice) {

        this.cartId = cartId;
        this.userId = userId;
        this.menuId = menuId;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    @Override
    public String toString() {
        return "Cart cartId: " + cartId +
                ", menuId: " + menuId +
                ", quantity: " + quantity +
                ", totalPrice: " + totalPrice + "";
    }
}
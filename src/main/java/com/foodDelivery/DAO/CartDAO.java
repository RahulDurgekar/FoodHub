package com.foodDelivery.DAO;

import java.util.List;
import com.foodDelivery.model.Cart;

public interface CartDAO {

    void addToCart(Cart cart);
    Cart getCartItem(int cartId);
    List<Cart> getCartByUserId(int userId);
    void updateCartItem(Cart cart);
    void updateQuantity(int cartId, int quantity);
    void removeCartItem(int cartId);
    void clearCart(int userId);
}
package com.foodDelivery.DAO;

import java.util.List;
import com.foodDelivery.model.Order;

public interface OrderDAO {

    void addOrder(Order order);
    Order getOrderById(int orderId);
    List<Order> getAllOrders();
    List<Order> getOrdersByUserId(int userId);
    List<Order> getOrdersByRestaurantId(int restaurantId);
    void updateOrderStatus(int orderId, String status);
    void deleteOrder(int orderId);
}
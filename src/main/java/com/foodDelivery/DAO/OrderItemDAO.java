package com.foodDelivery.DAO;

import java.util.*;

import com.foodDelivery.model.OrderItem;

public interface OrderItemDAO {

    void addOrderItem(OrderItem orderItem);
    OrderItem getOrderItemById(int orderItemId);
    List<OrderItem> getOrderItemsByOrderId(int orderId);
    void updateOrderItem(OrderItem orderItem);
    void deleteOrderItem(int orderItemId);
}

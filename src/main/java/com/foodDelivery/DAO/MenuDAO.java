package com.foodDelivery.DAO;

import java.util.List;
import com.foodDelivery.model.Menu;

public interface MenuDAO {

    void addMenuItem(Menu menu);
    Menu getMenuById(int menuId);
    List<Menu> getAllMenuItems();
    List<Menu> getMenuByRestaurantId(int restaurantId);
    List<Menu> getAvailableMenuItems(int restaurantId);
    void updateMenuItem(Menu menu);
    void deleteMenuItem(int menuId);
}
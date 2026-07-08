package com.foodDelivery.DAO;

import java.util.List;

import com.foodDelivery.model.Restaurant;

public interface RestaurantDAO {
	
	    void addRestaurant(Restaurant restaurant);
	    List<Restaurant> getRestaurantByOwnerId(int ownerId);
	    Restaurant getRestaurantById(int restaurantId);
	    List<Restaurant> getAllRestaurants();
	    List<Restaurant> getThreeRestaurants();
	    List<Restaurant> getActiveRestaurants();
	    List<Restaurant> searchRestaurantByName(String name);
	    void updateRestaurant(Restaurant restaurant);
	    void deleteRestaurant(int restaurantId);
}

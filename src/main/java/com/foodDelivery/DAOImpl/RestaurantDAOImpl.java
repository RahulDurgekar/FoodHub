package com.foodDelivery.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.foodDelivery.DAO.RestaurantDAO;
import com.foodDelivery.Utility.DBConnection;
import com.foodDelivery.model.Restaurant;
import com.foodDelivery.model.User;

public class RestaurantDAOImpl implements RestaurantDAO {

    Connection conn;

    private static final String INSERT_RESTAURANT ="INSERT INTO Restaurant(Name,CuisineType,"
    		+ "DeliveryTime,Address,Rating,IsActive,ImagePath,ownerId) VALUES (?,?,?,?,?,?,?,?)";

    private static final String GET_RESTAURANT_BY_ID ="SELECT * FROM Restaurant "
    		+ "WHERE RestaurantID=?";

    private static final String GET_ALL_RESTAURANTS ="SELECT * FROM Restaurant";

    private static final String GET_ACTIVE_RESTAURANTS ="SELECT * FROM Restaurant "
    		+ "WHERE IsActive=true";

    private static final String SEARCH_RESTAURANT = "SELECT * FROM Restaurant WHERE Name LIKE ?";

    private static final String UPDATE_RESTAURANT ="UPDATE Restaurant SET Name=?,"
    		+ "CuisineType=?,DeliveryTime=?,Address=?,Rating=?,IsActive=?,ImagePath=? "
    		+ "WHERE RestaurantID=?";

    private static final String DELETE_RESTAURANT ="DELETE FROM Restaurant WHERE RestaurantID=?";

	private static final String GET_THREE_RESTAURANTS =  "SELECT * FROM Restaurant ORDER BY rating DESC LIMIT 3";

	private static final String GET_RESTAURANTS_BY_OWNER = "SELECT * FROM Restaurant where ownerId=?";

   
    @Override
    public void addRestaurant(Restaurant restaurant) {
    	Connection conn=DBConnection.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(INSERT_RESTAURANT);
			pstmt.setString(1, restaurant.getName());
			pstmt.setString(2, restaurant.getCuisineType());
			pstmt.setInt(3, restaurant.getDeliveryTime());
			pstmt.setString(4, restaurant.getAddress());
			pstmt.setDouble(5, restaurant.getRating());
			pstmt.setBoolean(6, restaurant.isActive());
			pstmt.setString(7, restaurant.getImagePath());
			pstmt.setInt(8, restaurant.getOwnerId());
			
			int i = pstmt.executeUpdate();
			System.out.println(i);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }

    @Override
    public List<Restaurant> getRestaurantByOwnerId(int ownerId) {
    		List<Restaurant> restaurants=new ArrayList<>();
		Connection conn=DBConnection.getConnection();
		
		try { 
			PreparedStatement pstmt = conn.prepareStatement(GET_RESTAURANTS_BY_OWNER);
			pstmt.setInt(1, ownerId);
			ResultSet rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Restaurant restaurant=new Restaurant(
						//Create Restaurant object directly by
						//passing parameters to constructor by getting them from DB
						rs.getInt("restaurantId"),
						rs.getString("name"),
                        	rs.getString("cuisineType"),
                        	rs.getInt("deliveryTime"),
                        	rs.getString("address"),
                        	rs.getDouble("rating"),
                        	rs.getBoolean("isActive"),
                        	rs.getString("imagePath"),
                        	rs.getInt("ownerId"));
				
				//Add that restaurant object intp Array list named "restaurants"
				
				restaurants.add(restaurant);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return restaurants; // return list of restaurant objects
    }
    
    
    @Override
    public Restaurant getRestaurantById(int restaurantId) {
    		Restaurant restaurant = null;
		Connection conn= DBConnection.getConnection();
        try{
        		PreparedStatement pstmt = conn.prepareStatement(GET_RESTAURANT_BY_ID);
        		pstmt.setInt(1, restaurantId);
        		ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
            	restaurant = new Restaurant(
                        rs.getString("name"),
                        rs.getString("cuisineType"),
                        rs.getInt("deliveryTime"),
                        rs.getString("address"),
                        rs.getDouble("rating"),
                        rs.getBoolean("isActive"),
                        rs.getString("imagePath"),
                        rs.getInt("ownerId"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    
    @Override
    public List<Restaurant> getThreeRestaurants() {
    		List<Restaurant> restaurants=new ArrayList<>();
		Connection conn=DBConnection.getConnection();
		
		try (PreparedStatement pstmt = conn.prepareStatement(GET_THREE_RESTAURANTS)) {
			ResultSet rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Restaurant restaurant=new Restaurant(
						//Create Restaurant object directly by
						//passing parameters to constructor by getting them from DB
						
						rs.getString("name"),
                        	rs.getString("cuisineType"),
                        	rs.getInt("deliveryTime"),
                        	rs.getString("address"),
                        	rs.getDouble("rating"),
                        	rs.getBoolean("isActive"),
                        	rs.getString("imagePath"),
                        	rs.getInt("ownerId"));
				//Add that restaurant object intp Array list named "restaurants"
				
				restaurants.add(restaurant);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return restaurants; // return list of restaurant objects
    }
    
    
    @Override
    public List<Restaurant> getAllRestaurants() {
    		List<Restaurant> restaurants=new ArrayList<>();
		Connection conn=DBConnection.getConnection();
		
		try (PreparedStatement pstmt = conn.prepareStatement(GET_ALL_RESTAURANTS)) {
			ResultSet rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Restaurant restaurant=new Restaurant(
						//Create Restaurant object directly by
						//passing parameters to constructor by getting them from DB
						
						rs.getString("name"),
                        	rs.getString("cuisineType"),
                        	rs.getInt("deliveryTime"),
                        	rs.getString("address"),
                        	rs.getDouble("rating"),
                        	rs.getBoolean("isActive"),
                        	rs.getString("imagePath"),
                        	rs.getInt("ownerId"));
				//Add that restaurant object intp Array list named "restaurants"
				
				restaurants.add(restaurant);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return restaurants; // return list of restaurant objects
    }

    
    @Override
    public List<Restaurant> getActiveRestaurants() {
    	
    		List<Restaurant> restaurants=new ArrayList<>();
		Connection conn=DBConnection.getConnection();
		
		try (PreparedStatement pstmt = conn.prepareStatement(GET_ACTIVE_RESTAURANTS)) {
			ResultSet rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Restaurant activeRestaurant=new Restaurant(
						//Create Restaurant object directly by
						//passing parameters to constructor by getting them from DB
						
						rs.getString("name"),
                        	rs.getString("cuisineType"),
                        	rs.getInt("deliveryTime"),
                        	rs.getString("address"),
                        	rs.getDouble("rating"),
                        	rs.getBoolean("isActive"),
                        	rs.getString("imagePath"),
                        	rs.getInt("ownerId"));
				//Add that restaurant object intp Array list named "restaurants"
				
				restaurants.add(activeRestaurant);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return restaurants; // return list of restaurant objects
    }

    @Override
    public List<Restaurant> searchRestaurantByName(String name) {
    		List<Restaurant> restaurants=new ArrayList<>();
		Connection conn=DBConnection.getConnection();
		
		try (PreparedStatement pstmt = conn.prepareStatement(SEARCH_RESTAURANT)) {
			ResultSet rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Restaurant activeRestaurant=new Restaurant(
						//Create Restaurant object directly by
						//passing parameters to constructor by getting them from DB
						rs.getString("name"),
                        	rs.getString("cuisineType"),
                        	rs.getInt("deliveryTime"),
                        	rs.getString("address"),
                        	rs.getDouble("rating"),
                        	rs.getBoolean("isActive"),
                        	rs.getString("imagePath"),
                        	rs.getInt("ownerId"));
				//Add that restaurant object intp Array list named "restaurants"
				
				restaurants.add(activeRestaurant);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return restaurants; // return list of restaurant objects
    }

    
    @Override
    public void updateRestaurant(Restaurant restaurant) {
    		Connection conn=DBConnection.getConnection();
		try (PreparedStatement pstmt = conn.prepareStatement(UPDATE_RESTAURANT)) {

			pstmt.setString(1, restaurant.getName());
			pstmt.setString(2, restaurant.getCuisineType());
			pstmt.setInt(3, restaurant.getDeliveryTime());
			pstmt.setString(4, restaurant.getAddress());
			pstmt.setDouble(5, restaurant.getRating());
			pstmt.setBoolean(6, restaurant.isActive());
			pstmt.setString(7, restaurant.getImagePath());
			pstmt.setInt(8, restaurant.getRestaurantId());

	        int i = pstmt.executeUpdate();

	        if (i > 0) {
	            System.out.println("Restaurant updated successfully.");
	        } else {
	            System.out.println("Restaurant not found.");
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
    }

    
    @Override
    public void deleteRestaurant(int restaurantId) {
    	Connection conn=DBConnection.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(DELETE_RESTAURANT);
			pstmt.setInt(1, restaurantId);
			
			int i = pstmt.executeUpdate();
			System.out.println(i);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }
}
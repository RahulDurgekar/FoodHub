package com.foodDelivery.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.foodDelivery.DAO.MenuDAO;
import com.foodDelivery.Utility.DBConnection;
import com.foodDelivery.model.Menu;

public class MenuDAOImpl implements MenuDAO{

	private static final String GET_MENU_BYRID = "SELECT * FROM menu where restaurantId=?";
	private static final String ADD_MENU_ITEM = "INSERT INTO menu (restaurantId,itemName,"
			+ "description,price,isAvailable,imagePath) VALUES (?,?,?,?,?,?)";
	private static final String GET_ALL_MENU = "SELECT * FROM menu";
	private static final String GET_MENU_BYmenuID = "SELECT * FROM menu where menuId=?";
	private static final String DELETE_MENU_BY_ID = "DELETE FROM menu WHERE menuId=?";

	@Override
	public void addMenuItem(Menu menu) {
		
		Connection conn = DBConnection.getConnection();
		try {
			
			PreparedStatement pstmt = conn.prepareStatement(ADD_MENU_ITEM);
			
			pstmt.setInt(1, menu.getRestaurantId());
			pstmt.setString(2, menu.getItemName());
			pstmt.setString(3, menu.getDescription());
			pstmt.setDouble(4, menu.getPrice());
			pstmt.setBoolean(5, menu.isAvailable());
			pstmt.setString(6, menu.getImagePath());
			
			int i = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	
	
	@Override
	public Menu getMenuById(int menuId) {
		
		Connection conn = DBConnection.getConnection();
		Menu menu = null;
		try {
			
			PreparedStatement pstmt = conn.prepareStatement(GET_MENU_BYmenuID);
			pstmt.setInt(1, menuId);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				menu= new Menu(
				rs.getInt("menuId"),
				rs.getInt("restaurantId"),
				rs.getString("itemName"),
				rs.getString("description"),
				rs.getDouble("price"),
				rs.getBoolean("isAvailable"),
				rs.getString("imagePath")
				);
						
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return menu;
	}

	
	
	@Override
	public List<Menu> getAllMenuItems() {
		
		List<Menu> menus=new ArrayList<Menu>();
		Connection conn = DBConnection.getConnection();
		try {
			
			PreparedStatement pstmt = conn.prepareStatement(GET_ALL_MENU);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Menu menu= new Menu(
				rs.getInt("menuId"),
				rs.getInt("restaurantId"),
				rs.getString("itemName"),
				rs.getString("description"),
				rs.getDouble("price"),
				rs.getBoolean("isAvailable"),
				rs.getString("imagePath")
				);
						
			menus.add(menu);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return menus;
	}

	
	
	@Override
	public List<Menu> getMenuByRestaurantId(int restaurantId) {
		List<Menu> menus=new ArrayList<Menu>();
		Connection conn = DBConnection.getConnection();
		try {
			
			PreparedStatement pstmt = conn.prepareStatement(GET_MENU_BYRID);
			pstmt.setInt(1, restaurantId);
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Menu menu= new Menu(
				rs.getInt("menuId"),
				rs.getInt("restaurantId"),
				rs.getString("itemName"),
				rs.getString("description"),
				rs.getDouble("price"),
				rs.getBoolean("isAvailable"),
				rs.getString("imagePath")
				);
						
			menus.add(menu);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return menus;
	}

	
	
	@Override
	public List<Menu> getAvailableMenuItems(int restaurantId) {
		// TODO Auto-generated method stub
		return null;
	}

	
	
	@Override
	public void updateMenuItem(Menu menu) {
		
	}

	
	@Override
	public void deleteMenuItem(int menuId) {
		Connection conn = DBConnection.getConnection();
		try {
			
			PreparedStatement pstmt = conn.prepareStatement(DELETE_MENU_BY_ID);
			pstmt.setInt(1, menuId);
			int i=  pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
}

package com.foodDelivery.DAOImpl;


import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.foodDelivery.DAO.UserDAO;
import com.foodDelivery.Utility.DBConnection;
import com.foodDelivery.model.User;

public class UserDAOImpl implements UserDAO{
	
	private static final String ADD_USER = "INSERT INTO users (name, email, phone, "
			+ "address, password, role, createdDate, lastLogIn)"
			+ " VALUES (?,?,?,?,?,?,?,?)";
	
	private static final String DELETE_USER= "DELETE FROM users WHERE userId=?";
	
	private static final String GET_USER_BY_EMAIL= "SELECT * from users where email=?";
	
	private static final String UPDATE_USER = "UPDATE users SET name=?, email=?,"
			+ " phone=?, address=?, password=?, role=? WHERE userId=?";
	
	private static final String GET_ALL_USER="SELECT * FROM users";

	private static final String GET_USER_BY_ID = "SELECT * from users where userId=?";
	
	@Override
	public int addUser(User user) {
		int i=0;
		Connection conn=DBConnection.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(ADD_USER);
			pstmt.setString(1, user.getName());
			pstmt.setString(2, user.getEmail());
			pstmt.setLong(3, user.getPhone());
			pstmt.setString(4, user.getAddress());
			pstmt.setString(5, user.getPassword());
			pstmt.setString(6, user.getRole());
			pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
			pstmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
			
			i = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return i;
	}
	
	
	@Override
	public void deleteUser(int id) {
		Connection conn=DBConnection.getConnection();
		try {
			PreparedStatement pstmt = conn.prepareStatement(DELETE_USER);
			pstmt.setInt(1, id);
			
			int i = pstmt.executeUpdate();
			System.out.println(i);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	@Override
	public User getUserByEmail(String email) {
		User user = null;
		Connection conn=DBConnection.getConnection();
        try{
        		PreparedStatement pstmt = conn.prepareStatement(GET_USER_BY_EMAIL);
        		pstmt.setString(1, email);
        		ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User(
                			rs.getInt("userId"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getLong("phone"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("role")
                );
            }
            
            if(user.getEmail()==null) {
            		System.out.print("User not found");
            }
            

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }
	
	@Override
	public User getUserById(int userId) {
		User user = null;
		Connection conn=DBConnection.getConnection();
        try{
        		PreparedStatement pstmt = conn.prepareStatement(GET_USER_BY_ID);
        		pstmt.setInt(1, userId);
        		ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User(
                			rs.getInt("userId"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getLong("phone"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("role")
                );
            }
            
            if(user.getEmail()==null) {
            		System.out.print("User not found");
            }
            

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }
	
	
	@Override
	public void updateUser(User user) {
		Connection conn=DBConnection.getConnection();
		try (PreparedStatement pstmt = conn.prepareStatement(UPDATE_USER)) {

	        pstmt.setString(1, user.getName());
	        pstmt.setString(2, user.getEmail());
	        pstmt.setLong(3, user.getPhone());
	        pstmt.setString(4, user.getAddress());
	        pstmt.setString(5, user.getPassword());
	        pstmt.setString(6, user.getRole());
	        pstmt.setInt(7, user.getUserId());

	        int i = pstmt.executeUpdate();

	        if (i > 0) {
	            System.out.println("User updated successfully.");
	        } else {
	            System.out.println("User not found.");
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}
	
	
	@Override
	public List<User> getAllUser() {
		
		List<User> users=new ArrayList<>();
		Connection conn=DBConnection.getConnection();
		
		try (PreparedStatement pstmt = conn.prepareStatement(GET_ALL_USER)) {
			ResultSet rSet=pstmt.executeQuery();
			
			while(rSet.next()) {
				User user=new User(
						//rSet.getInt("userId"),  Create User object directly by
						//                        passing parameters by getting them from DB
						rSet.getString("name"),
						rSet.getString("email"),
						rSet.getLong("phone"),
						rSet.getString("address"),
						rSet.getString("password"),
						rSet.getString("role"));
				//Add that user object intp Array list named "users"
				users.add(user);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return users; // return list of user objects
	}
}

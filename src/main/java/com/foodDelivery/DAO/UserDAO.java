package com.foodDelivery.DAO;

import java.util.List;

import com.foodDelivery.model.User;

public interface UserDAO {
	int addUser(User user);
    User getUserByEmail(String email);
    void updateUser(User user);
    void deleteUser(int id);
    List<User> getAllUser();
}
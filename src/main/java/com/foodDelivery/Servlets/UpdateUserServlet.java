package com.foodDelivery.Servlets;

import java.io.IOException;
import java.security.interfaces.RSAKey;

import com.foodDelivery.DAOImpl.UserDAOImpl;
import com.foodDelivery.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/updateUser")
public class UpdateUserServlet extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		int userId = Integer.parseInt(req.getParameter("userId")) ;

		UserDAOImpl userDAOImpl = new UserDAOImpl();
		User user = userDAOImpl.getUserById(userId);
		
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		long phone = Long.parseLong(req.getParameter("phone"));
		String address = req.getParameter("address");
		String role = req.getParameter("role");

		user.setUserId(userId);
		user.setName(name);
		user.setAddress(address);
		user.setEmail(email);
		user.setPhone(phone);
		user.setRole(role);
		
		userDAOImpl.updateUser(user);
		
		resp.sendRedirect("userProfile.jsp");
	}
}

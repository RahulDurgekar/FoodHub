package com.foodDelivery.Servlets;
import com.foodDelivery.DAOImpl.*;
import com.foodDelivery.model.User;

import java.io.IOException;
import java.io.PrintWriter;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logIn")
public class LoginServlet extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = req.getParameter("email");
		String password = req.getParameter("password");
		UserDAOImpl usd = new  UserDAOImpl();
		
		
		User user= usd.getUserByEmail(email);
		
		//HttpSession session;
		
		PrintWriter out = resp.getWriter();
		
		if(user.getEmail().equals(email) && BCrypt.checkpw(password, user.getPassword())) {
			
            
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            
			if(user.getRole().equalsIgnoreCase("CUSTOMER")) {
				resp.sendRedirect("topRestaurant");
			}
			
			else if(user.getRole().equalsIgnoreCase("RESTAURANT ADMIN")) {
				resp.sendRedirect("restaurantAdminServlet");
			}
			
			else if(user.getRole().equalsIgnoreCase("DELIVERY PARTNER")) {
				resp.sendRedirect("deliveryServlet");
			}
			
			else if(user.getRole().equalsIgnoreCase("ADMIN")) {
				resp.sendRedirect("adminServlet");
			}
			
			else {
				out.print("User not found");
			}
		}
		}
}

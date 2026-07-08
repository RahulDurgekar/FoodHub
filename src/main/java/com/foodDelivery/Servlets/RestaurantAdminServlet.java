package com.foodDelivery.Servlets;

import java.io.IOException;
import java.nio.file.attribute.UserDefinedFileAttributeView;
import java.util.List;

import com.foodDelivery.DAOImpl.RestaurantDAOImpl;
import com.foodDelivery.model.Restaurant;
import com.foodDelivery.model.User;
import com.mysql.cj.Session;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/restaurantAdminServlet")
public class RestaurantAdminServlet extends HttpServlet{
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession(false);
		
		if (session == null) {
		    resp.sendRedirect("logIn.html");
		    return;
		}
		
		User user = (User) session.getAttribute("loggedUser");
		System.out.println(user);
		RestaurantDAOImpl rd = new RestaurantDAOImpl();

		List<Restaurant> restaurants = rd.getRestaurantByOwnerId((user.getUserId()));
		System.out.println("User id "+ user.getUserId());
		
		System.out.println("Restaurants fetched: " + restaurants.size());
		
		req.setAttribute("ownerRestaurants", restaurants);
		RequestDispatcher rqd = req.getRequestDispatcher("RestaurantAdminDashboard.jsp");
		rqd.forward(req, resp);
		
	}
	// Set attribute with the getRestaurantByOwnerId 
	//Send redirect to RestaurantAdminDashboard.jsp
	}
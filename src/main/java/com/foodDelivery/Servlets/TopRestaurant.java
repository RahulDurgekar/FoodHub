package com.foodDelivery.Servlets;

import java.io.IOException;
import java.util.List;

import com.foodDelivery.DAOImpl.RestaurantDAOImpl;
import com.foodDelivery.model.Restaurant;
import com.sun.net.httpserver.Request;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.foodDelivery.model.*;

@WebServlet("/topRestaurant")
public class TopRestaurant extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		RestaurantDAOImpl rest= new  RestaurantDAOImpl();
		List<Restaurant> restaurants = rest.getThreeRestaurants();
		
		System.out.println("Restaurants fetched: " + restaurants.size());
		
		req.setAttribute("topThreeRestaurant", restaurants);
		RequestDispatcher rd = req.getRequestDispatcher("index.jsp");
		rd.forward(req, resp);
	}
}
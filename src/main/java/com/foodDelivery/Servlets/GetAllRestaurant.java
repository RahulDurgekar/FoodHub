package com.foodDelivery.Servlets;

import java.io.IOException;
import java.util.List;
import com.foodDelivery.model.*;
import com.foodDelivery.DAOImpl.RestaurantDAOImpl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/allRestaurants")
public class GetAllRestaurant  extends HttpServlet{
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		RestaurantDAOImpl rest= new  RestaurantDAOImpl();
		List<Restaurant> restaurants = rest.getAllRestaurants();
		
		System.out.println("Restaurants fetched: " + restaurants.size());
		
		req.setAttribute("allRestaurants", restaurants);
		RequestDispatcher rd = req.getRequestDispatcher("restaurants.jsp");
		rd.forward(req, resp);
	}
}

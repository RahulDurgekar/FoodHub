package com.foodDelivery.Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;

import com.foodDelivery.DAOImpl.RestaurantDAOImpl;
import com.foodDelivery.model.Restaurant;
import com.foodDelivery.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addRestaurant")
public class AddRestaurantServlet extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
	 	PrintWriter out = resp.getWriter();
		HttpSession session = req.getSession(false);

		User user = (User) session.getAttribute("loggedUser");
		
		String restaurantName=req.getParameter("name");
		String cuisineType=req.getParameter("cuisineType");
		int deliveryTime= Integer.parseInt(req.getParameter("deliveryTime"));
		String address=req.getParameter("address");
		double rating=Double.parseDouble(req.getParameter("rating"));
		boolean isActive=Boolean.parseBoolean(req.getParameter("isActive"));
		String imagePath=req.getParameter("imagePath");
		int ownerId = user.getUserId();
		
		Restaurant restaurant= new Restaurant(restaurantName,cuisineType,deliveryTime,address,rating,isActive,imagePath,ownerId);
		
		RestaurantDAOImpl rsd= new RestaurantDAOImpl();
		rsd.addRestaurant(restaurant);
		
		out.print("Restaurant added succesfully");
		resp.sendRedirect("restaurantAdminServlet");
		
		
	}
}

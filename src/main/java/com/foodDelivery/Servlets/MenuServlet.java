package com.foodDelivery.Servlets;

import java.io.IOException;
import java.net.Authenticator.RequestorType;
import java.util.List;

import com.foodDelivery.DAOImpl.MenuDAOImpl;
import com.foodDelivery.DAOImpl.RestaurantDAOImpl;
import com.foodDelivery.model.Menu;
import com.foodDelivery.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menuServlet")
public class MenuServlet extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		MenuDAOImpl menuDaoImpl = new MenuDAOImpl();
		int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
		List<Menu> allRestMenus = (List<Menu>)menuDaoImpl.getMenuByRestaurantId(restaurantId);
		
		RestaurantDAOImpl rest = new RestaurantDAOImpl();
		
		Restaurant restaurant = rest.getRestaurantById(restaurantId);
		
		req.setAttribute("allMenus", allRestMenus);
		req.setAttribute("restaurant", restaurant); // to pass restaurant object so that it can fetch restaurant name 
		RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
		rd.forward(req, resp);
	}
}

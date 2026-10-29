package com.foodDelivery.Servlets;

import java.io.IOException;

import com.foodDelivery.DAOImpl.MenuDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deleteMenuItem")
public class DeleteMenuServlet extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
		
		int menuId = Integer.parseInt(req.getParameter("menuId"));
		MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
		menuDAOImpl.deleteMenuItem(menuId);
		
		resp.sendRedirect("adminMenuItems?restaurantId=" + restaurantId);
	}
}

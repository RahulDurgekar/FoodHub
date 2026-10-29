package com.foodDelivery.Servlets;

import java.io.IOException;
import java.util.List;

import com.foodDelivery.DAOImpl.MenuDAOImpl;
import com.foodDelivery.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/adminMenuItems")

public class AdminMenuServlet extends HttpServlet {

    MenuDAOImpl menuDAO = new MenuDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));

        List<Menu> menuItems = menuDAO.getMenuByRestaurantId(restaurantId);

        req.setAttribute("restaurantId", restaurantId);
        req.setAttribute("adminMenuItem", menuItems);

        RequestDispatcher rd = req.getRequestDispatcher("addMenu.jsp");
        rd.forward(req, resp);
    }

    
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String imagePath = req.getParameter("imagePath");
        double price = Double.parseDouble(req.getParameter("price"));
        boolean availability = Boolean.parseBoolean(req.getParameter("isAvailable"));

        Menu menu = new Menu(restaurantId, name, description, price, availability, imagePath);

        menuDAO.addMenuItem(menu);
        resp.sendRedirect("adminMenuItems?restaurantId=" + restaurantId);
    }
}
package com.foodDelivery.Servlets;

import java.io.IOException;

import com.foodDelivery.DAOImpl.MenuDAOImpl;
import com.foodDelivery.model.Cart;
import com.foodDelivery.model.CartItem;
import com.foodDelivery.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int menuId = Integer.parseInt(req.getParameter("menuId"));
            int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
            int quantity = req.getParameter("quantity") != null ? Integer.parseInt(req.getParameter("quantity")) : 1;

            MenuDAOImpl menuDAO = new MenuDAOImpl();
            Menu menu = menuDAO.getMenuById(menuId);

            if (menu != null) {
                HttpSession session = req.getSession();
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null) {
                    cart = new Cart();
                }

                CartItem cartItem = new CartItem(
                    menu.getMenuId(),
                    restaurantId,
                    menu.getItemName(),
                    menu.getPrice(),
                    quantity
                );

                cart.addItem(cartItem);
                session.setAttribute("cart", cart);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("cart.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}

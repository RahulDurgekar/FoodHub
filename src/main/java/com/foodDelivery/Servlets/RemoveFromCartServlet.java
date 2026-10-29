package com.foodDelivery.Servlets;

import java.io.IOException;

import com.foodDelivery.model.Cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int menuId = Integer.parseInt(req.getParameter("menuItemId"));

            HttpSession session = req.getSession();
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null) {
                cart.removeItem(menuId);
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

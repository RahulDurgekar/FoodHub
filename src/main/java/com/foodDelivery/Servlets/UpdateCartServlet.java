package com.foodDelivery.Servlets;

import java.io.IOException;

import com.foodDelivery.model.Cart;
import com.foodDelivery.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateCartServlet")
public class UpdateCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int menuId = Integer.parseInt(req.getParameter("menuItemId"));
            String action = req.getParameter("action");

            HttpSession session = req.getSession();
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null && cart.getItems().containsKey(menuId)) {
                CartItem item = cart.getItems().get(menuId);
                if ("inc".equalsIgnoreCase(action)) {
                    cart.updateItemQty(menuId, item.getQty() + 1);
                } else if ("dec".equalsIgnoreCase(action)) {
                    cart.updateItemQty(menuId, item.getQty() - 1);
                } else if (req.getParameter("quantity") != null) {
                    int newQty = Integer.parseInt(req.getParameter("quantity"));
                    cart.updateItemQty(menuId, newQty);
                }
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

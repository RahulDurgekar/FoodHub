package com.foodDelivery.Servlets;

import java.io.IOException;
import java.util.List;

import com.foodDelivery.DAOImpl.OrderDAOImpl;
import com.foodDelivery.model.Order;
import com.foodDelivery.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/userProfile")
public class UserProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            resp.sendRedirect("logIn.html");
            return;
        }

        try {
            OrderDAOImpl orderDAO = new OrderDAOImpl();
            List<Order> userOrders = orderDAO.getOrdersByUserId(user.getUserId());
            req.setAttribute("userOrders", userOrders);
        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher rd = req.getRequestDispatcher("userProfile.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

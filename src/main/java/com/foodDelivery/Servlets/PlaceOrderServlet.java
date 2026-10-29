package com.foodDelivery.Servlets;

import java.io.IOException;
import java.sql.Timestamp;

import com.foodDelivery.DAOImpl.OrderDAOImpl;
import com.foodDelivery.DAOImpl.OrderItemDAOImpl;
import com.foodDelivery.model.Cart;
import com.foodDelivery.model.CartItem;
import com.foodDelivery.model.Order;
import com.foodDelivery.model.OrderItem;
import com.foodDelivery.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            resp.sendRedirect("logIn.html");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect("cart.jsp");
            return;
        }

        String paymentMode = req.getParameter("paymentMode");
        if (paymentMode == null || paymentMode.trim().isEmpty()) {
            paymentMode = "COD";
        }
        paymentMode = paymentMode.toUpperCase();

        double subtotal = cart.getTotalPrice();
        double deliveryFee = 30.0;
        double tax = subtotal * 0.05;
        double totalAmount = subtotal + deliveryFee + tax;

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setRestaurantId(cart.getRestaurantId());
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setTotalAmount(totalAmount);
        order.setStatus("PLACED");
        order.setPaymentMethod(paymentMode);

        OrderDAOImpl orderDAO = new OrderDAOImpl();
        orderDAO.addOrder(order);

        if (order.getOrderId() > 0) {
            OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
            for (CartItem item : cart.getItems().values()) {
                OrderItem orderItem = new OrderItem(
                    order.getOrderId(),
                    item.getMenuId(),
                    item.getQty(),
                    item.getItemTotal()
                );
                orderItemDAO.addOrderItem(orderItem);
            }

            session.setAttribute("lastPlacedOrder", order);
            cart.clearCart();
            session.removeAttribute("cart");

            resp.sendRedirect("orderConfirmation.jsp?orderId=" + order.getOrderId());
        } else {
            resp.sendRedirect("cart.jsp?error=FailedToPlaceOrder");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}

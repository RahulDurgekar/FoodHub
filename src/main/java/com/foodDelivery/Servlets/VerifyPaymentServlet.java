package com.foodDelivery.Servlets;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

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

@WebServlet("/verifyPayment")
public class VerifyPaymentServlet extends HttpServlet {

    private static final String KEY_SECRET = "uO1E9U62Vz3DUw8vkqjTcqOR";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String razorpayPaymentId = req.getParameter("razorpay_payment_id");
        String razorpayOrderId = req.getParameter("razorpay_order_id");
        String razorpaySignature = req.getParameter("razorpay_signature");
        String paymentMode = req.getParameter("paymentMode");

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("logIn.html");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null || cart == null || cart.isEmpty()) {
            resp.sendRedirect("cart.jsp");
            return;
        }

        // Verify cryptographic HMAC-SHA256 signature
        boolean isValidSignature = verifyRazorpaySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature, KEY_SECRET);

        if (isValidSignature) {
            double subtotal = cart.getTotalPrice();
            double deliveryFee = 30.0;
            double tax = subtotal * 0.05;
            double totalAmount = subtotal + deliveryFee + tax;

            if (paymentMode == null || paymentMode.trim().isEmpty()) {
                paymentMode = "CARD";
            }

            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setRestaurantId(cart.getRestaurantId());
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));
            order.setTotalAmount(totalAmount);
            order.setStatus("PLACED");
            order.setPaymentMethod(paymentMode.toUpperCase());

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
                resp.sendRedirect("cart.jsp?error=FailedToSaveOrder");
            }
        } else {
            System.err.println("Razorpay signature verification failed!");
            resp.sendRedirect("cart.jsp?error=InvalidPaymentSignature");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    private boolean verifyRazorpaySignature(String orderId, String paymentId, String signature, String secret) {
        if (orderId == null || paymentId == null || signature == null || secret == null) {
            return false;
        }
        try {
            String data = orderId + "|" + paymentId;
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKey = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKey);
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString().equalsIgnoreCase(signature);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

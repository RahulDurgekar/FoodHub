package com.foodDelivery.Servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import com.foodDelivery.model.Cart;
import com.foodDelivery.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/createRazorpayOrder")
public class CreateRazorpayOrderServlet extends HttpServlet {

    private static final String KEY_ID = "rzp_test_TYEba6xIl4rBwh";
    private static final String KEY_SECRET = "uO1E9U62Vz3DUw8vkqjTcqOR";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null) {
            out.print("{\"status\":\"error\",\"message\":\"Session expired. Please log in.\"}");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null || cart == null || cart.isEmpty()) {
            out.print("{\"status\":\"error\",\"message\":\"Cart is empty or user not logged in.\"}");
            return;
        }

        try {
            double subtotal = cart.getTotalPrice();
            double deliveryFee = 30.0;
            double tax = subtotal * 0.05;
            double totalAmount = subtotal + deliveryFee + tax;
            int amountInPaise = (int) Math.round(totalAmount * 100);

            String receiptId = "rcpt_" + System.currentTimeMillis();

            // Call Razorpay REST API: POST https://api.razorpay.com/v1/orders
            URL url = new URL("https://api.razorpay.com/v1/orders");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json");

            // Basic Auth Header
            String auth = KEY_ID + ":" + KEY_SECRET;
            String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
            conn.setRequestProperty("Authorization", "Basic " + encodedAuth);

            // Request JSON Payload
            String payload = "{\"amount\":" + amountInPaise + ",\"currency\":\"INR\",\"receipt\":\"" + receiptId + "\"}";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(payload.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            InputStream is = (responseCode >= 200 && responseCode < 300) ? conn.getInputStream() : conn.getErrorStream();

            StringBuilder responseBuffer = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    responseBuffer.append(line);
                }
            }

            String jsonResponse = responseBuffer.toString();

            if (responseCode == 200 || responseCode == 201) {
                // Extract razorpay order id from response JSON string
                String razorpayOrderId = extractJsonField(jsonResponse, "id");

                StringBuilder result = new StringBuilder();
                result.append("{");
                result.append("\"status\":\"success\",");
                result.append("\"razorpayOrderId\":\"").append(escapeJson(razorpayOrderId)).append("\",");
                result.append("\"amount\":").append(amountInPaise).append(",");
                result.append("\"keyId\":\"").append(escapeJson(KEY_ID)).append("\",");
                result.append("\"userName\":\"").append(escapeJson(user.getName())).append("\",");
                result.append("\"userEmail\":\"").append(escapeJson(user.getEmail())).append("\",");
                result.append("\"userPhone\":\"").append(user.getPhone()).append("\"");
                result.append("}");

                out.print(result.toString());
            } else {
                out.print("{\"status\":\"error\",\"message\":\"Razorpay API Error: " + escapeJson(jsonResponse) + "\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\",\"message\":\"Server error: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    private String extractJsonField(String json, String key) {
        String searchKey = "\"" + key + "\":\"";
        int start = json.indexOf(searchKey);
        if (start != -1) {
            start += searchKey.length();
            int end = json.indexOf("\"", start);
            if (end != -1) {
                return json.substring(start, end);
            }
        }
        return "";
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}

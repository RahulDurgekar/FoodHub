package com.foodDelivery.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.foodDelivery.DAO.OrderDAO;
import com.foodDelivery.Utility.DBConnection;
import com.foodDelivery.model.Order;

public class OrderDAOImpl implements OrderDAO {

    private static final String INSERT_ORDER = "INSERT INTO ordertable (userId, restaurantId, orderDate, totalAmount, status, paymentMethod) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String GET_ORDER_BY_ID = "SELECT * FROM ordertable WHERE orderId = ?";
    private static final String GET_ALL_ORDERS = "SELECT * FROM ordertable ORDER BY orderDate DESC";
    private static final String GET_ORDERS_BY_USER_ID = "SELECT * FROM ordertable WHERE userId = ? ORDER BY orderDate DESC";
    private static final String GET_ORDERS_BY_RESTAURANT_ID = "SELECT * FROM ordertable WHERE restaurantId = ? ORDER BY orderDate DESC";
    private static final String UPDATE_ORDER_STATUS = "UPDATE ordertable SET status = ? WHERE orderId = ?";
    private static final String DELETE_ORDER = "DELETE FROM ordertable WHERE orderId = ?";

    @Override
    public void addOrder(Order order) {
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setTimestamp(3, order.getOrderDate());
            pstmt.setDouble(4, order.getTotalAmount());
            pstmt.setString(5, order.getStatus() != null ? order.getStatus() : "PLACED");
            pstmt.setString(6, order.getPaymentMethod() != null ? order.getPaymentMethod() : "COD");

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet resKey = pstmt.getGeneratedKeys();
                if (resKey.next()) {
                    order.setOrderId(resKey.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Order getOrderById(int orderId) {
        Connection conn = DBConnection.getConnection();
        Order order = null;
        try {
            PreparedStatement pstmt = conn.prepareStatement(GET_ORDER_BY_ID);
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                order = extractOrderFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(GET_ALL_ORDERS);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extractOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(GET_ORDERS_BY_USER_ID);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extractOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getOrdersByRestaurantId(int restaurantId) {
        List<Order> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(GET_ORDERS_BY_RESTAURANT_ID);
            pstmt.setInt(1, restaurantId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extractOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void updateOrderStatus(int orderId, String status) {
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(UPDATE_ORDER_STATUS);
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(DELETE_ORDER);
            pstmt.setInt(1, orderId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        return new Order(
            rs.getInt("orderId"),
            rs.getInt("userId"),
            rs.getInt("restaurantId"),
            rs.getTimestamp("orderDate"),
            rs.getDouble("totalAmount"),
            rs.getString("status"),
            rs.getString("paymentMethod")
        );
    }
}


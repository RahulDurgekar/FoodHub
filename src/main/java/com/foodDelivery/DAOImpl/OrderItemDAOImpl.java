package com.foodDelivery.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.foodDelivery.DAO.OrderItemDAO;
import com.foodDelivery.Utility.DBConnection;
import com.foodDelivery.model.OrderItem;

public class OrderItemDAOImpl implements OrderItemDAO {

    private static final String INSERT_ORDER_ITEM = "INSERT INTO orderitem (orderId, menuId, quantity, itemTotal) VALUES (?, ?, ?, ?)";
    private static final String GET_ORDER_ITEM_BY_ID = "SELECT * FROM orderitem WHERE orderItemId = ?";
    private static final String GET_ORDER_ITEMS_BY_ORDER_ID = "SELECT * FROM orderitem WHERE orderId = ?";
    private static final String UPDATE_ORDER_ITEM = "UPDATE orderitem SET orderId = ?, menuId = ?, quantity = ?, itemTotal = ? WHERE orderItemId = ?";
    private static final String DELETE_ORDER_ITEM = "DELETE FROM orderitem WHERE orderItemId = ?";

    @Override
    public void addOrderItem(OrderItem orderItem) {
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(INSERT_ORDER_ITEM, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getItemTotal());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet resKey = pstmt.getGeneratedKeys();
                if (resKey.next()) {
                    orderItem.setOrderItemId(resKey.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItemById(int orderItemId) {
        Connection conn = DBConnection.getConnection();
        OrderItem orderItem = null;
        try {
            PreparedStatement pstmt = conn.prepareStatement(GET_ORDER_ITEM_BY_ID);
            pstmt.setInt(1, orderItemId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                orderItem = extractOrderItemFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderItem;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(GET_ORDER_ITEMS_BY_ORDER_ID);
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extractOrderItemFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void updateOrderItem(OrderItem orderItem) {
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(UPDATE_ORDER_ITEM);
            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getMenuId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getItemTotal());
            pstmt.setInt(5, orderItem.getOrderItemId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {
        Connection conn = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(DELETE_ORDER_ITEM);
            pstmt.setInt(1, orderItemId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private OrderItem extractOrderItemFromResultSet(ResultSet rs) throws SQLException {
        return new OrderItem(
            rs.getInt("orderItemId"),
            rs.getInt("orderId"),
            rs.getInt("menuId"),
            rs.getInt("quantity"),
            rs.getDouble("itemTotal")
        );
    }
}


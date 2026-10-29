<%@ page import="com.foodDelivery.model.User, com.foodDelivery.model.Order, com.foodDelivery.model.Restaurant, com.foodDelivery.DAOImpl.OrderDAOImpl, com.foodDelivery.DAOImpl.RestaurantDAOImpl, com.foodDelivery.DAOImpl.UserDAOImpl, java.util.*" %>
<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("logIn.html");
    return;
}

RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
OrderDAOImpl orderDAO = new OrderDAOImpl();
UserDAOImpl userDAO = new UserDAOImpl();

List<Restaurant> myRestaurants = restaurantDAO.getRestaurantByOwnerId(user.getUserId());
List<Order> incomingOrders = new ArrayList<Order>();

if (myRestaurants != null) {
    for (Restaurant r : myRestaurants) {
        List<Order> rOrders = orderDAO.getOrdersByRestaurantId(r.getRestaurantId());
        if (rOrders != null) {
            incomingOrders.addAll(rOrders);
        }
    }
}
// Sort orders newest first
incomingOrders.sort((a, b) -> {
    if (a.getOrderDate() == null || b.getOrderDate() == null) return 0;
    return b.getOrderDate().compareTo(a.getOrderDate());
});
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Incoming Live Orders - FoodHub Owner</title>
<link rel="stylesheet" href="styles.css">
<link rel="icon" type="image/png" href="images/fevicon.png">
<style>
  .admin-wrap { padding: 48px 0 80px; }
  .dashboard-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; flex-wrap: wrap; gap: 16px; }
  .dashboard-header h1 { font-size: clamp(1.8rem, 3vw, 2.4rem); margin: 0; }

  .orders-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 24px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.04);
    overflow-x: auto;
  }

  .admin-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    font-size: 0.92rem;
  }
  .admin-table th {
    padding: 14px 16px;
    background: var(--color-surface-alt);
    color: var(--color-text-muted);
    font-size: 0.78rem;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    font-weight: 700;
    border-bottom: 1px solid var(--color-border);
  }
  .admin-table td {
    padding: 16px;
    border-bottom: 1px solid var(--color-border);
    color: var(--color-text);
    vertical-align: middle;
  }
  .admin-table tr:last-child td { border-bottom: none; }

  .status-select {
    padding: 8px 12px;
    border-radius: var(--radius-sm);
    border: 1px solid var(--color-border);
    background: var(--color-surface-alt);
    color: var(--color-text);
    font-weight: 600;
    font-size: 0.85rem;
    cursor: pointer;
    outline: none;
  }

  .status-badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 9999px;
    font-size: 0.75rem;
    font-weight: 800;
    text-transform: uppercase;
  }
  .status-badge.placed { background: var(--color-primary-light); color: var(--color-primary); }
  .status-badge.confirmed { background: var(--color-accent-light); color: var(--color-accent); }
  .status-badge.preparing { background: #e3f2fd; color: #1976d2; }
  .status-badge.out_for_delivery { background: #fff3e0; color: #e65100; }
  .status-badge.delivered { background: var(--color-success-light); color: var(--color-success); }
  .status-badge.cancelled { background: var(--color-danger-light); color: var(--color-danger); }

  .empty-state { text-align: center; padding: 60px 20px; color: var(--color-text-muted); }
</style>
</head>
<body>

<!-- NAVBAR -->
<header class="navbar">
  <div class="container">
    <a href="restaurantAdminServlet" class="logo">FoodHub<span class="dot">.</span> Owner</a>

    <nav class="nav-links">
      <a href="restaurantAdminServlet">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9.5 12 3l9 6.5"/><path d="M5 10v10h14V10"/></svg>
        Home
      </a>
      <a href="addRestaurant.jsp">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
        Add Restaurant
      </a>
      <a href="getOrders.jsp" class="active">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"/><path d="M8 9h8M8 13h5"/></svg>
        Orders
      </a>
    </nav>

    <div class="nav-actions">
      <button class="theme-toggle" id="themeToggle" aria-label="Toggle dark mode">
        <span class="knob">
          <svg id="themeIcon" viewBox="0 0 24 24" fill="none" stroke-width="2.4" stroke-linecap="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>
        </span>
      </button>

      <a href="LogOutServlet" class="btn btn-ghost btn-sm">Log Out</a>
    </div>
  </div>
</header>

<section class="container admin-wrap">
  <div class="dashboard-header">
    <div>
      <span class="eyebrow">Owner Dashboard</span>
      <h1>Incoming Live Orders</h1>
    </div>
    <a href="restaurantAdminServlet" class="btn btn-secondary">Manage Restaurants</a>
  </div>

  <div class="orders-card">
<% if (incomingOrders.isEmpty()) { %>
    <div class="empty-state">
      <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.6" style="margin-bottom:12px; opacity:0.6;"><rect x="4" y="4" width="16" height="16" rx="2"/><path d="M8 9h8M8 13h5"/></svg>
      <p style="font-size:1.1rem; font-weight:600; color:var(--color-text);">No live incoming orders right now</p>
      <p style="font-size:0.88rem; margin-top:4px;">Orders placed by customers for your kitchens will show up here real-time.</p>
    </div>
<% } else { %>
    <table class="admin-table">
      <thead>
        <tr>
          <th>Order ID</th>
          <th>Restaurant</th>
          <th>Customer</th>
          <th>Date &amp; Time</th>
          <th>Total Amount</th>
          <th>Payment</th>
          <th>Status</th>
          <th>Update Status</th>
        </tr>
      </thead>
      <tbody>
<%
    for (Order ord : incomingOrders) {
        Restaurant r = restaurantDAO.getRestaurantById(ord.getRestaurantId());
        String restName = (r != null) ? r.getName() : "Rest #" + ord.getRestaurantId();
        User customer = userDAO.getUserById(ord.getUserId());
        String custName = (customer != null) ? customer.getName() : "Customer #" + ord.getUserId();
        String st = ord.getStatus() != null ? ord.getStatus().toLowerCase() : "placed";
%>
        <tr>
          <td><strong>#<%= ord.getOrderId() %></strong></td>
          <td><%= restName %></td>
          <td><%= custName %></td>
          <td style="font-size:0.84rem; color:var(--color-text-muted);"><%= ord.getOrderDate() != null ? ord.getOrderDate().toString() : "" %></td>
          <td style="font-family:var(--font-mono); font-weight:700; color:var(--color-primary);">₹<%= String.format("%.2f", ord.getTotalAmount()) %></td>
          <td><%= ord.getPaymentMethod() %></td>
          <td>
            <span class="status-badge <%= st %>"><%= ord.getStatus() %></span>
          </td>
          <td>
            <form action="updateOrderStatus" method="POST" style="margin:0;">
              <input type="hidden" name="orderId" value="<%= ord.getOrderId() %>">
              <select name="status" class="status-select" onchange="this.form.submit()">
                <option value="PLACED" <%= "PLACED".equalsIgnoreCase(ord.getStatus()) ? "selected" : "" %>>PLACED</option>
                <option value="CONFIRMED" <%= "CONFIRMED".equalsIgnoreCase(ord.getStatus()) ? "selected" : "" %>>CONFIRMED</option>
                <option value="PREPARING" <%= "PREPARING".equalsIgnoreCase(ord.getStatus()) ? "selected" : "" %>>PREPARING</option>
                <option value="OUT_FOR_DELIVERY" <%= "OUT_FOR_DELIVERY".equalsIgnoreCase(ord.getStatus()) ? "selected" : "" %>>OUT FOR DELIVERY</option>
                <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(ord.getStatus()) ? "selected" : "" %>>DELIVERED</option>
                <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(ord.getStatus()) ? "selected" : "" %>>CANCEL</option>
              </select>
            </form>
          </td>
        </tr>
<%
    }
%>
      </tbody>
    </table>
<% } %>
  </div>
</section>

<script>
  const root = document.documentElement;
  const themeToggle = document.getElementById('themeToggle');
  const themeIcon = document.getElementById('themeIcon');

  function applyTheme(theme) {
    root.setAttribute('data-theme', theme);
    localStorage.setItem('foodhub-theme', theme);
    if (themeIcon) {
      themeIcon.innerHTML = theme === 'dark'
        ? '<path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/>'
        : '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/>';
    }
  }

  const saved = localStorage.getItem('foodhub-theme') ||
    (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
  applyTheme(saved);

  if (themeToggle) {
    themeToggle.addEventListener('click', () => {
      applyTheme(root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
    });
  }
</script>
</body>
</html>

<%@ page import="com.foodDelivery.model.User, com.foodDelivery.model.Order, com.foodDelivery.DAOImpl.OrderDAOImpl, com.foodDelivery.DAOImpl.RestaurantDAOImpl, com.foodDelivery.model.Restaurant, java.util.*" %>
<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("logIn.html");
    return;
}

List<Order> userOrders = (List<Order>) request.getAttribute("userOrders");
if (userOrders == null && user != null) {
    try {
        OrderDAOImpl orderDAO = new OrderDAOImpl();
        userOrders = orderDAO.getOrdersByUserId(user.getUserId());
    } catch (Exception e) {
        userOrders = new ArrayList<Order>();
    }
}
if (userOrders == null) {
    userOrders = new ArrayList<Order>();
}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile & Orders - FoodHub</title>
<link rel="stylesheet" href="styles.css">
<style>
  .profile-page-grid {
    padding: 48px 0 80px;
    display: grid;
    grid-template-columns: 380px 1fr;
    gap: 40px;
    align-items: start;
  }
  .profile-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 32px 28px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.04);
  }
  .profile-avatar-lg {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--color-primary), var(--color-accent));
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16px;
    color: #fff;
  }
  .profile-avatar-lg svg { width: 30px; height: 30px; stroke: #fff; }
  .profile-card h1 { font-size: 1.5rem; margin-bottom: 4px; color: var(--color-text); }
  .profile-card .role-tag {
    display: inline-block;
    background: var(--color-surface-alt);
    border: 1px solid var(--color-border);
    border-radius: 9999px;
    padding: 3px 12px;
    font-size: 0.76rem;
    font-weight: 700;
    color: var(--color-primary);
    margin-bottom: 24px;
  }
  .form-group { margin-bottom: 16px; }
  .form-group label { display: block; font-size: 0.8rem; font-weight: 700; margin-bottom: 6px; color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.05em; }
  .form-group input {
    width: 100%;
    padding: 10px 14px;
    border-radius: var(--radius-sm);
    border: 1px solid var(--color-border);
    background: var(--color-surface-alt);
    color: var(--color-text);
    outline: none;
    font-size: 0.9rem;
  }
  .profile-actions { display: flex; gap: 12px; margin-top: 20px; }
  .profile-actions .btn { flex: 1; padding: 10px; font-size: 0.88rem; }

  .orders-section h2 { font-size: 1.5rem; margin-bottom: 20px; color: var(--color-text); }
  .order-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 20px 24px;
    margin-bottom: 16px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.03);
    transition: transform var(--transition-fast);
  }
  .order-card:hover { transform: translateY(-2px); }
  .order-card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid var(--color-border);
    padding-bottom: 12px;
    margin-bottom: 12px;
    flex-wrap: wrap;
    gap: 10px;
  }
  .order-card-header .order-id { font-weight: 800; font-size: 1rem; color: var(--color-text); }
  .order-card-header .order-date { font-size: 0.82rem; color: var(--color-text-muted); }
  .status-badge {
    font-size: 0.78rem; font-weight: 700; padding: 4px 10px; border-radius: 9999px; text-transform: uppercase;
  }
  .status-badge.placed { background: var(--color-primary-light); color: var(--color-primary); }
  .status-badge.delivered { background: var(--color-success-light); color: var(--color-success); }
  .order-card-body { display: flex; justify-content: space-between; align-items: center; }
  .order-meta-info { font-size: 0.88rem; color: var(--color-text-secondary); }
  .order-price { font-family: var(--font-mono); font-weight: 800; font-size: 1.1rem; color: var(--color-primary); }

  .no-orders {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 50px 20px;
    text-align: center;
    color: var(--color-text-muted);
  }

  @media (max-width: 900px) {
    .profile-page-grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>

<!-- NAVBAR -->
<header class="navbar">
  <div class="container">
    <a href="topRestaurant" class="logo">FoodHub<span class="dot">.</span></a>

    <nav class="nav-links">
      <a href="topRestaurant">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9.5 12 3l9 6.5"/><path d="M5 10v10h14V10"/></svg>
        Home
      </a>
      <a href="allRestaurants">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 3v18"/><path d="M4 3c2 0 3 1.5 3 3.5S6 10 4 10"/><path d="M15 3v18"/><path d="M20 3v7a3 3 0 0 1-3 3"/><path d="M20 3v18"/></svg>
        Browse Restaurants
      </a>
      <a href="userProfile" class="active">
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

      <a href="cart.jsp" class="icon-btn" aria-label="Cart">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M1 1h4l2.2 12.2a2 2 0 0 0 2 1.8h8.6a2 2 0 0 0 2-1.6L22 6H6"/></svg>
      </a>

      <a href="LogOutServlet" class="btn btn-ghost btn-sm">Log Out</a>
    </div>
  </div>
</header>

<div class="container">
  <div class="profile-page-grid">

    <!-- USER PROFILE CARD -->
    <div class="profile-card">
      <div class="profile-avatar-lg">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-6 8-6s8 2 8 6"/></svg>
      </div>
      <h1><%= user.getName() %></h1>
      <span class="role-tag"><%= user.getRole() %></span>

      <form action="updateUser" method="POST">
        <div class="form-group">
          <label>Full Name</label>
          <input type="text" name="name" value="<%= user.getName() %>" required>
        </div>
        <div class="form-group">
          <label>Email Address</label>
          <input type="email" name="email" value="<%= user.getEmail() %>" required>
        </div>
        <div class="form-group">
          <label>Phone Number</label>
          <input type="tel" name="phone" value="<%= user.getPhone() %>">
        </div>
        <div class="form-group">
          <label>Address</label>
          <input type="text" name="address" value="<%= user.getAddress() %>">
        </div>
        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
        <div class="profile-actions">
          <button type="submit" class="btn btn-primary">Save Changes</button>
          <a href="LogOutServlet" class="btn btn-ghost">Log Out</a>
        </div>
      </form>
    </div>

    <!-- YOUR ORDERS SECTION -->
    <div class="orders-section">
      <h2>Your Orders</h2>

<% if (userOrders.isEmpty()) { %>
      <div class="no-orders">
        <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.6" style="margin-bottom:12px; opacity:0.6;"><rect x="4" y="4" width="16" height="16" rx="2"/><path d="M8 9h8M8 13h5"/></svg>
        <p style="font-size:1.05rem; font-weight:600; color:var(--color-text);">No orders placed yet</p>
        <p style="font-size:0.86rem; margin-top:4px;">When you order meals, your order history will appear here.</p>
        <a href="allRestaurants" class="btn btn-primary" style="margin-top:18px; display:inline-flex;">Explore Restaurants</a>
      </div>
<% } else { %>
<%
      RestaurantDAOImpl restDAO = new RestaurantDAOImpl();
      for (Order ord : userOrders) {
          Restaurant r = restDAO.getRestaurantById(ord.getRestaurantId());
          String restName = (r != null) ? r.getName() : "Restaurant #" + ord.getRestaurantId();
%>
      <div class="order-card">
        <div class="order-card-header">
          <div>
            <span class="order-id">Order #<%= ord.getOrderId() %></span>
            <div class="order-date"><%= ord.getOrderDate() != null ? ord.getOrderDate().toString() : "" %></div>
          </div>
          <span class="status-badge <%= "DELIVERED".equalsIgnoreCase(ord.getStatus()) ? "delivered" : "placed" %>">
            <%= ord.getStatus() %>
          </span>
        </div>
        <div class="order-card-body">
          <div class="order-meta-info">
            <strong style="color:var(--color-text);"><%= restName %></strong>
            <div>Payment: <%= ord.getPaymentMethod() %></div>
          </div>
          <div class="order-price">₹<%= String.format("%.2f", ord.getTotalAmount()) %></div>
        </div>
      </div>
<%
      }
%>
<% } %>
    </div>

  </div>
</div>

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

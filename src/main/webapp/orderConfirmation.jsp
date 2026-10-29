<%@ page import="com.foodDelivery.model.User, com.foodDelivery.model.Order, com.foodDelivery.model.OrderItem, com.foodDelivery.DAOImpl.OrderDAOImpl, com.foodDelivery.DAOImpl.OrderItemDAOImpl, com.foodDelivery.DAOImpl.MenuDAOImpl, com.foodDelivery.model.Menu, java.util.*" %>
<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("logIn.html");
    return;
}

String orderIdParam = request.getParameter("orderId");
Order order = null;
List<OrderItem> orderItems = new ArrayList<>();

if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
    try {
        int orderId = Integer.parseInt(orderIdParam);
        OrderDAOImpl orderDAO = new OrderDAOImpl();
        order = orderDAO.getOrderById(orderId);

        if (order != null) {
            OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
            orderItems = orderItemDAO.getOrderItemsByOrderId(orderId);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}

if (order == null) {
    order = (Order) session.getAttribute("lastPlacedOrder");
}
%>

<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Confirmed - FoodHub</title>
<link rel="stylesheet" href="styles.css">
<link rel="icon" type="image/png" href="images/fevicon.png">
<style>
  .confirm-wrap {
    padding: 60px 0 100px;
    max-width: 680px;
    margin: 0 auto;
  }
  .confirm-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 40px 32px;
    text-align: center;
    box-shadow: 0 10px 40px rgba(0,0,0,0.06);
  }
  .success-badge {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background: var(--color-success-light);
    color: var(--color-success);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 20px;
  }
  .success-badge svg {
    width: 36px;
    height: 36px;
    stroke: currentColor;
  }
  .confirm-card h1 {
    font-size: clamp(1.8rem, 3.5vw, 2.4rem);
    margin-bottom: 8px;
    color: var(--color-text);
  }
  .confirm-card p.subtitle {
    color: var(--color-text-secondary);
    font-size: 0.98rem;
    margin-bottom: 28px;
  }
  .order-meta-box {
    background: var(--color-surface-alt);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    padding: 20px;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
    gap: 16px;
    text-align: left;
    margin-bottom: 28px;
  }
  .meta-item label {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: var(--color-text-muted);
    display: block;
    margin-bottom: 4px;
  }
  .meta-item span {
    font-weight: 700;
    font-size: 0.95rem;
    color: var(--color-text);
  }

  .order-items-list {
    text-align: left;
    border-top: 1px solid var(--color-border);
    padding-top: 20px;
    margin-top: 20px;
  }
  .order-items-list h3 {
    font-size: 1.05rem;
    margin-bottom: 14px;
    color: var(--color-text);
  }
  .item-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px dashed var(--color-border-light);
    font-size: 0.92rem;
  }
  .item-row:last-child { border-bottom: none; }
  .item-name { font-weight: 600; color: var(--color-text); }
  .item-qty { color: var(--color-text-muted); font-size: 0.84rem; margin-left: 6px; }
  .item-price { font-family: var(--font-mono); font-weight: 700; color: var(--color-text); }

  .actions-row {
    display: flex;
    gap: 14px;
    justify-content: center;
    margin-top: 32px;
    flex-wrap: wrap;
  }
</style>
</head>
<body>

<!-- ============================= NAVBAR ============================= -->
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
      <a href="userProfile">
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

      <div class="profile-wrap" id="profileWrap">
        <button class="profile-btn" id="profileBtn">
          <span class="profile-avatar">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-6 8-6s8 2 8 6"/></svg>
          </span>
          <span><%= user.getName() %></span>
        </button>

        <div class="profile-menu" id="profileMenu">
          <div class="profile-menu-header">
            <strong>Welcome to FoodHub, <%= user.getName() %></strong>
            <span><%= user.getRole() %></span>
          </div>
          <a href="userProfile">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-6 8-6s8 2 8 6"/></svg>
            Profile
          </a>
          <a href="LogOutServlet">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><path d="M10 17l5-5-5-5"/><path d="M15 12H3"/></svg>
            Log Out
          </a>
        </div>
      </div>
    </div>
  </div>
</header>

<!-- ============================= CONFIRMATION CONTENT ============================= -->
<section class="container">
  <div class="confirm-wrap">
    <div class="confirm-card">
      <div class="success-badge">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>
      </div>

      <h1>Order Confirmed!</h1>
      <p class="subtitle">Thank you for your order. Your food is being prepared and will be delivered shortly.</p>

<% if (order != null) { %>
      <div class="order-meta-box">
        <div class="meta-item">
          <label>Order ID</label>
          <span>#<%= order.getOrderId() %></span>
        </div>
        <div class="meta-item">
          <label>Status</label>
          <span style="color:var(--color-success);"><%= order.getStatus() %></span>
        </div>
        <div class="meta-item">
          <label>Payment Method</label>
          <span><%= order.getPaymentMethod() %></span>
        </div>
        <div class="meta-item">
          <label>Total Paid</label>
          <span style="color:var(--color-primary);">₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
        </div>
      </div>

<% if (!orderItems.isEmpty()) { %>
      <div class="order-items-list">
        <h3>Items Ordered</h3>
<%
        MenuDAOImpl menuDAO = new MenuDAOImpl();
        for (OrderItem oi : orderItems) {
            Menu m = menuDAO.getMenuById(oi.getMenuId());
            String itemName = (m != null) ? m.getItemName() : "Item #" + oi.getMenuId();
%>
        <div class="item-row">
          <div>
            <span class="item-name"><%= itemName %></span>
            <span class="item-qty">x<%= oi.getQuantity() %></span>
          </div>
          <span class="item-price">₹<%= String.format("%.2f", oi.getItemTotal()) %></span>
        </div>
<%
        }
%>
      </div>
<% } %>
<% } %>

      <div class="actions-row">
        <a href="userProfile" class="btn btn-secondary">View Profile &amp; Orders</a>
        <a href="topRestaurant" class="btn btn-primary">Back to Home</a>
      </div>
    </div>
  </div>
</section>

<script>
  const root = document.documentElement;
  const themeToggle = document.getElementById('themeToggle');
  const themeIcon = document.getElementById('themeIcon');

  function applyTheme(theme) {
    root.setAttribute('data-theme', theme);
    localStorage.setItem('foodhub-theme', theme);
    themeIcon.innerHTML = theme === 'dark'
      ? '<path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/>'
      : '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/>';
  }

  const saved = localStorage.getItem('foodhub-theme') ||
    (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
  applyTheme(saved);

  themeToggle.addEventListener('click', () => {
    applyTheme(root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
  });

  const profileWrap = document.getElementById('profileWrap');
  const profileBtn = document.getElementById('profileBtn');
  if (profileBtn && profileWrap) {
    profileBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      profileWrap.classList.toggle('open');
    });
    document.addEventListener('click', () => profileWrap.classList.remove('open'));
  }
</script>
</body>
</html>

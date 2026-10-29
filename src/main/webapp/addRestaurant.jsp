<%@ page import="com.foodDelivery.model.User" %>
<%
User user = (User) session.getAttribute("loggedUser");

if (user == null) {
    response.sendRedirect("logIn.html");
    return;
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
<title>Add Restaurant - FoodHub</title>
<link rel="stylesheet" href="styles.css">
<link rel="icon" type="image/png" href="/fevicon.png">
<style>
  .auth-wrap {
    min-height: calc(100vh - var(--nav-h));
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 60px 24px;
  }
  .auth-card {
    width: 100%;
    max-width: 650px;
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 40px;
    box-shadow: 0 30px 60px -30px rgba(var(--shadow-color), 0.4);
  }
  .auth-card h1 { font-size: 1.7rem; }
  .auth-card p.sub { color: var(--color-text-muted); margin-top: 6px; margin-bottom: 28px; font-size: 0.92rem; }
  .form-group { margin-bottom: 18px; }
  .form-group label { display: block; margin-bottom: 6px; font-size: 0.82rem; font-weight: 700; }
  .form-group input, .form-group select {
    width: 100%;
    padding: 12px 14px;
    border-radius: var(--radius-sm);
    border: 1px solid var(--color-border);
    background: var(--color-surface-alt);
    color: var(--color-text);
    outline: none;
    font-size: 0.92rem;
    transition: border-color var(--transition-fast);
  }
  .form-group input:focus, .form-group select:focus { border-color: var(--color-primary); }
  .auth-card .btn { width: 100%; margin-top: 6px; padding: 13px; }
</style>
</head>
<body>

<!-- ============================= NAVBAR (admin) ============================= -->
<header class="navbar">
  <div class="container">
    <a href="restaurantAdminServlet" class="logo">FoodHub<span class="dot">.</span></a>

    <nav class="nav-links">
      <a href="restaurantAdminServlet">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9.5 12 3l9 6.5"/><path d="M5 10v10h14V10"/></svg>
        Home
      </a>
      <a href="restaurantAdminServlet">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 3v18"/><path d="M4 3c2 0 3 1.5 3 3.5S6 10 4 10"/><path d="M15 3v18"/><path d="M20 3v7a3 3 0 0 1-3 3"/><path d="M20 3v18"/></svg>
        My Restaurants
      </a>
      <a href="addRestaurant.jsp" class="active">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
        Add Restaurant
      </a>
    </nav>

    <div class="nav-actions">
      <button class="theme-toggle" id="themeToggle" aria-label="Toggle dark mode">
        <span class="knob">
          <svg id="themeIcon" viewBox="0 0 24 24" fill="none" stroke-width="2.4" stroke-linecap="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>
        </span>
      </button>

      <div class="profile-wrap" id="profileWrap">
        <button class="profile-btn" id="profileBtn">
          <span class="profile-avatar">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-6 8-6s8 2 8 6"/></svg>
          </span>
          <span><%= user.getName() %></span>
        </button>

        <div class="profile-menu" id="profileMenu">
          <div class="profile-menu-header">
            <strong>Welcome, <%= user.getName() %></strong>
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

<!-- ============================= ADD RESTAURANT FORM ============================= -->
<div class="auth-wrap">
  <div class="auth-card">
    <span class="eyebrow">Restaurant Registration</span>
    <h1>Add Restaurant</h1>
    <p class="sub">Register your restaurant and start receiving orders.</p>

    <form action="addRestaurant" method="POST">

      <div class="form-group">
        <label>Restaurant Name</label>
        <input type="text" name="name" required>
      </div>

      <div class="form-two">
        <div class="form-group">
          <label>Cuisine Type</label>
          <input type="text" name="cuisineType" required>
        </div>
        <div class="form-group">
          <label>Delivery Time (Minutes)</label>
          <input type="number" name="deliveryTime" required>
        </div>
      </div>

      <div class="form-group">
        <label>Address</label>
        <input type="text" name="address" required>
      </div>

      <div class="form-two">
        <div class="form-group">
          <label>Rating</label>
          <input type="number" step="0.1" min="0" max="5" name="rating" value="0">
        </div>
        <div class="form-group">
          <label>Status</label>
          <select name="isActive">
            <option value="true">Open</option>
            <option value="false">Closed</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label>Image Path</label>
        <input type="text" name="imagePath" placeholder="images/pizzaHut.jpg">
      </div>

      <!-- Owner ID comes from session -->
      <input type="hidden" name="ownerId" value="<%= user.getUserId() %>">

      <button type="submit" class="btn btn-primary">Add Restaurant</button>
    </form>
  </div>
</div>

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
  profileBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    profileWrap.classList.toggle('open');
  });
  document.addEventListener('click', () => profileWrap.classList.remove('open'));
</script>
</body>
</html>

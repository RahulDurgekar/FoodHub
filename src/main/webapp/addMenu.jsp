<%@page import="java.util.*"%>
<%@ page import="com.foodDelivery.model.User,com.foodDelivery.model.Menu" %>

<%
User user = (User) session.getAttribute("loggedUser");

if (user == null || !(user.getRole().equalsIgnoreCase("Restaurant admin"))) {
    response.sendRedirect("logIn.html");
    return;
}

String restaurantId = request.getParameter("restaurantId");
request.setAttribute("restaurantId", restaurantId);
//List<Menu> menuItems = (List<Menu>) request.getAttribute("adminMenuItems");

%>

<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Menu Item - FoodHub</title>
<link rel="stylesheet" href="styles.css">
<link rel="icon" type="image/png" href="/fevicon.png">
<style>
  .auth-wrap {
    min-height: calc(100vh - var(--nav-h));
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 60px 24px;
    gap: 30px;
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
  .form-group input, .form-group select, .form-group textarea {
    width: 100%;
    padding: 12px 14px;
    border-radius: var(--radius-sm);
    border: 1px solid var(--color-border);
    background: var(--color-surface-alt);
    color: var(--color-text);
    outline: none;
    font-size: 0.92rem;
    font-family: inherit;
    transition: border-color var(--transition-fast);
  }
  .form-group textarea { resize: vertical; min-height: 80px; }
  .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: var(--color-primary); }
  .auth-card .btn { width: 100%; margin-top: 6px; padding: 13px; }

  .menu-list-card {
    width: 100%;
    max-width: 650px;
  }
  .menu-list-card h2 { font-size: 1.2rem; margin-bottom: 16px; }

  .existing-item {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 14px 0;
    border-bottom: 1px solid var(--color-border);
  }
  .existing-item:last-child { border-bottom: none; }

  @media (max-width: 480px) {
    .existing-item { flex-wrap: wrap; }
    .existing-item .info { flex-basis: 100%; order: 3; }
    .existing-item .price { order: 2; margin-left: auto; }
  }

  .existing-item .thumb {
    width: 56px;
    height: 56px;
    border-radius: var(--radius-sm);
    object-fit: cover;
    flex-shrink: 0;
    background: var(--color-surface-alt);
    border: 1px solid var(--color-border);
  }
  .existing-item .thumb-placeholder {
    width: 56px;
    height: 56px;
    border-radius: var(--radius-sm);
    flex-shrink: 0;
    background: linear-gradient(135deg, #ffb627, #ff5a1f);
  }

  .existing-item .info { flex: 1; min-width: 0; }
  .existing-item .name { font-weight: 700; }
  .existing-item .cat { color: var(--color-text-muted); font-size: 0.8rem; margin-top: 2px; }
  .existing-item .price { font-family: var(--font-mono); font-weight: 700; color: var(--color-primary); flex-shrink: 0; }

  .existing-item .item-actions {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-shrink: 0;
    margin-left: 4px;
  }
  .existing-item .item-actions form { margin: 0; }
  .icon-action-btn {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid var(--color-border);
    background: var(--color-surface-alt);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--color-text);
    transition: border-color var(--transition-fast), color var(--transition-fast);
  }
  .icon-action-btn svg { width: 14px; height: 14px; stroke: currentColor; }
  .icon-action-btn:hover { border-color: var(--color-primary); color: var(--color-primary); }
  .icon-action-btn.delete-btn:hover { border-color: var(--color-danger); color: var(--color-danger); }
  /* .popup-overlay / .popup-box / .btn-danger etc. now live in styles.css
     as a shared, reusable delete-confirmation component. */
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
      <a href="adminMenuItems<%= restaurantId != null ? "?restaurantId=" + restaurantId : "" %>" class="active">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
        Add Menu
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

<!-- ============================= ADD MENU ITEM FORM ============================= -->
<div class="auth-wrap">
  <div class="auth-card">
    <span class="eyebrow">Menu Management</span>
    <h1>Add Menu Item</h1>
    <p class="sub">Add a dish to your restaurant's menu so customers can order it.</p>

    <% if (restaurantId == null) { %>
      <p style="color:var(--color-danger); font-size:0.88rem; margin-bottom:18px;">
        No restaurant selected. Go to "My Restaurants" and choose a restaurant to add menu items to.
      </p>
    <% } %>

    <form action="adminMenuItems" method="POST">

      <div class="form-group">
        <label>Item Name</label>
        <input type="text" name="name" required>
      </div>

      <div class="form-group">
        <label>Description</label>
        <textarea name="description" placeholder="Short description of the dish"></textarea>
      </div>

      <div class="form-two">
        
        <div class="form-group">
          <label>Price (₹)</label>
          <input type="number" step="0.01" min="0" name="price" required>
        </div>
      </div>

      <div class="form-two">
        <div class="form-group">
          <label>Image Path</label>
          <input type="text" name="imagePath" placeholder="images/paneer-tikka.jpg">
        </div>
        <div class="form-group">
          <label>Availability</label>
          <select name="isAvailable">
            <option value="true">Available</option>
            <option value="false">Out of stock</option>
          </select>
        </div>
      </div>

      <!-- Which restaurant this item belongs to -->
      <input type="hidden" name="restaurantId" value="<%= restaurantId != null ? restaurantId : "" %>">

      <button type="submit" class="btn btn-primary">Add Menu Item</button>
    </form>
  </div>

<% List<Menu> menuItems = (List<Menu>) request.getAttribute("adminMenuItem"); %>
<% if (menuItems != null && !menuItems.isEmpty()) { %>
  <div class="auth-card menu-list-card">
    <h2>Current menu (<%= menuItems.size() %>)</h2>
<%
    // NOTE: this assumes a com.foodDelivery.model.MenuItem class with
    // getName() / getCategory() / getPrice(). Swap the cast + getters
    // below if your class or method names are different.
    
    for (Menu menu : menuItems) {
        String img = menu.getImagePath();
        boolean hasImg = (img != null && !img.trim().isEmpty());
%>
    <div class="existing-item">

<% if (hasImg) { %>
      <img class="thumb" data-src="<%= request.getContextPath() + "/" + img %>" alt="<%= menu.getItemName() %>">
<% } else { %>
      <div class="thumb-placeholder"></div>
<% } %>

      <div class="info">
        <div class="name"><%= menu.getItemName() %></div>
        <div class="cat"><%= menu.getDescription() %></div>
      </div>

      <div class="price">₹<%= menu.getPrice() %></div>

      <div class="item-actions">
        <!-- Manage/edit: adjust target if your edit page/servlet is named differently -->
        <a class="icon-action-btn" title="Manage"
           href="editMenuItem.jsp?menuId=<%= menu.getMenuId() %>&restaurantId=<%= restaurantId %>">
          <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"/><path d="M16.5 3.5a2.1 2.1 0 1 1 3 3L7 19l-4 1 1-4Z"/></svg>
        </a>

        <!-- Delete: adjust the servlet name/params to match your code -->
        <form action="deleteMenuItem" method="POST" class="delete-menu-form">
          <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
          <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
          <button type="button" class="icon-action-btn delete-btn" title="Delete" onclick="showDeletePopup(this)">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/></svg>
          </button>
        </form>
      </div>

    </div>
<%
    }
%>
  </div>
<% } %>
</div>

<!-- Delete Confirmation Popup - this markup MUST come before the <script>
     tag below, since the script looks these elements up by ID as soon as
     it runs. If the script runs first, getElementById returns null and
     the Yes/No buttons silently fail to do anything. -->
<div id="deletePopup" class="popup-overlay">
  <div class="popup-box">
    <div class="popup-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
    </div>
    <h3>Delete Menu Item?</h3>
    <p>Are you sure you want to delete this menu item? This action cannot be undone.</p>
    <div class="popup-actions">
      <button id="deleteConfirmNo" class="btn btn-ghost">No, Keep it</button>
      <button id="deleteConfirmYes" class="btn btn-danger">Yes, Delete</button>
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

  // ---- Set img src from data attributes, with a fallback placeholder
  //      if the file 404s or the browser can't decode the format ----
  document.querySelectorAll('img[data-src]').forEach(el => {
    const raw = el.getAttribute('data-src');
    const encoded = raw.replace(/\\/g, '/').split('/').map(s => encodeURIComponent(s)).join('/');
    el.addEventListener('error', function handleError() {
      el.removeEventListener('error', handleError);
      const placeholder = document.createElement('div');
      placeholder.className = 'thumb-placeholder';
      el.replaceWith(placeholder);
    });
    el.src = encoded;
  });

  // ---- Delete confirmation popup ----
  let pendingDeleteForm = null;
  const deletePopup = document.getElementById('deletePopup');

  function showDeletePopup(btn) {
    pendingDeleteForm = btn.closest('form');
    deletePopup.classList.add('open');
  }

  document.getElementById('deleteConfirmYes').addEventListener('click', () => {
    if (pendingDeleteForm) pendingDeleteForm.submit();
  });

  document.getElementById('deleteConfirmNo').addEventListener('click', () => {
    pendingDeleteForm = null;
    deletePopup.classList.remove('open');
  });

  deletePopup.addEventListener('click', (e) => {
    if (e.target === deletePopup) {
      pendingDeleteForm = null;
      deletePopup.classList.remove('open');
    }
  });
</script>
</body>
</html>

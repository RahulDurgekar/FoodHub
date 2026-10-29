<%@ page import="com.foodDelivery.model.User, com.foodDelivery.model.Restaurant, com.foodDelivery.model.Menu, java.util.*" %>

<%
User user = (User) session.getAttribute("loggedUser");
Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
List<Menu> allMenus = (List<Menu>) request.getAttribute("allMenus");
if (allMenus == null) {
    allMenus = new ArrayList<Menu>();
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
<title><%= restaurant != null ? restaurant.getName() + " - FoodHub" : "Menu - FoodHub" %></title>
<link rel="stylesheet" href="styles.css">
<link rel="icon" type="image/png" href="/fevicon.png">
<style>
  /* .rest-grid / .rest-card / .rest-thumb / .rest-perf / .rest-body / .rest-footer
     all come from styles.css (same classes restaurants.jsp uses) so the menu
     cards line up visually with the restaurant cards. Only page-specific
     layout lives here. */

  .menu-wrap {
    padding: 48px 0 80px;
    display: grid;
    grid-template-columns: minmax(0, 1fr) 320px;
    gap: 40px;
    align-items: start;
  }

  .order-summary-card {
    position: sticky;
    top: calc(var(--nav-h) + 20px);
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 26px;
    box-shadow: 0 8px 25px rgba(var(--shadow-color), 0.08);
  }
  .order-summary-card h3 { font-size: 1.05rem; margin-bottom: 6px; }
  .order-summary-card p { color: var(--color-text-muted); font-size: 0.86rem; margin-bottom: 16px; }
  .order-summary-card .btn { width: 100%; }

  /* the add-to-cart button sits inside a <form> instead of being a plain
     span like on restaurants.jsp, so it needs its own reset */
  .rest-footer form { margin: 0; }
  .rest-footer .add-btn {
    border: none;
    cursor: pointer;
  }

  @media (max-width: 900px) {
    .menu-wrap { grid-template-columns: 1fr; }
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
      <a href="allRestaurants" class="active">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 3v18"/><path d="M4 3c2 0 3 1.5 3 3.5S6 10 4 10"/><path d="M15 3v18"/><path d="M20 3v7a3 3 0 0 1-3 3"/><path d="M20 3v18"/></svg>
        Browse Restaurants
      </a>
      <a href="userProfile">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"/><path d="M8 9h8M8 13h5"/></svg>
        Orders
      </a>
      <a href="delivery.html">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="7" width="14" height="10" rx="1"/><path d="M15 10h4l3 3v4h-7z"/><circle cx="6" cy="19" r="1.6"/><circle cx="17.5" cy="19" r="1.6"/></svg>
        Delivery
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
        </button>

        <div class="profile-menu" id="profileMenu">
<% if (user != null) { %>
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
<% } else { %>
          <div class="profile-menu-header">
            <strong>Welcome to FoodHub</strong>
            <span>Log in to track orders &amp; save favorites</span>
          </div>
          <a href="logIn.html">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><path d="M10 17l5-5-5-5"/><path d="M15 12H3"/></svg>
            Log in
          </a>
          <a href="signUp.html" class="signup-link">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M19 8v6"/><path d="M22 11h-6"/></svg>
            Sign up
          </a>
<% } %>
        </div>
      </div>
    </div>
  </div>
</header>

<!-- ============================= RESTAURANT HEADER ============================= -->
<section class="rest-header">
  <div class="container">
<% if (restaurant == null) { %>
    <span class="eyebrow">Menu</span>
    <h1>Restaurant not found</h1>
    <p style="color:var(--color-text-muted); margin-top:10px;">This restaurant may be unavailable right now. <a href="allRestaurants" style="color:var(--color-primary); font-weight:700;">Browse other restaurants</a>.</p>
<% } else { %>

    <div class="rest-header-top">
      <div>
        <span class="eyebrow"><%= restaurant.getCuisineType() %></span>
        <h1><%= restaurant.getName() %></h1>
        <div style="display:flex; align-items:center; gap:10px; margin-top:8px; flex-wrap:wrap;">
          <span class="rating-badge" style="font-size:0.9rem; padding:5px 12px;">
            <svg viewBox="0 0 24 24" style="width:14px;height:14px;fill:#3fa34d;stroke:none;"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6z"/></svg>
            <%= restaurant.getRating() %>
          </span>
          <div class="rest-header-meta">
            <span>· <%= restaurant.getDeliveryTime() %> min delivery</span>
            <span>· <%= restaurant.getAddress() %></span>
            <span>· <%= restaurant.isActive() ? "Open now" : "Closed" %></span>
          </div>
        </div>

      </div>
    </div>
<% } %>
  </div>
</section>

<!-- ============================= MENU ============================= -->
<section class="container">
  <div class="menu-wrap">

    <div>

<!-- Replace the menu items section in menu.jsp with this -->
<% if (allMenus.isEmpty()) { %>
  <div style="text-align:center; padding:var(--space-2xl) 0; color:var(--color-text-muted);">
    <h3 style="color:var(--color-text); margin-bottom:var(--space-sm);">No menu items yet</h3>
    <p>This restaurant hasn't added any dishes to their menu.</p>
  </div>
<% } else { %>
  <div class="rest-grid">
    <% for (Menu menu : allMenus) {
      boolean available = menu.isAvailable();
    %>
    <article class="rest-card">
      <div class="rest-thumb" data-img="<%= request.getContextPath() + "/" + menu.getImagePath() %>">
        <% if (!available) { %>
          <span class="badge closed">Unavailable</span>
        <% } %>
      </div>
      <div class="rest-perf"></div>
      <div class="rest-body">
        <div class="rest-name-row">
          <h3><%= menu.getItemName() %></h3>
          <span class="price-badge">₹<%= menu.getPrice() %></span>
        </div>
        <div class="rest-meta">
          <span><%= available ? "Available now" : "Out of stock" %></span>
        </div>
        <div class="rest-tags"><%= menu.getDescription() %></div>
        <div class="rest-footer">
          <span class="cost"><%= available ? "Add to order" : "Not available" %></span>
          <% if (available) { %>
            <form action="AddToCartServlet" method="POST">
              <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
              <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
              <input type="hidden" name="quantity" value="1">
              <button type="submit" class="add-btn" aria-label="Add to cart">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2.4" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
              </button>
            </form>
          <% } %>
        </div>
      </div>
    </article>
    <% } %>
  </div>
<% } %>

    </div>

    <aside class="order-summary-card">
      <h3>Your order</h3>
      <p>Items you add here go straight to your cart — review and pay when you're ready.</p>
      <a href="cart.jsp" class="btn btn-primary">Go to cart</a>
    </aside>

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
  profileBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    profileWrap.classList.toggle('open');
  });
  document.addEventListener('click', () => profileWrap.classList.remove('open'));

  // ---- Set background images from data-img, with a graceful fallback
  //      if the file 404s or the browser can't decode the format ----
  const FALLBACK_GRADIENTS = [
    'linear-gradient(135deg,#ffb627,#ff5a1f)',
    'linear-gradient(135deg,#3fa34d,#8bd17c)',
    'linear-gradient(135deg,#e5484d,#ff8a80)',
    'linear-gradient(135deg,#4f8cff,#8ab6ff)',
    'linear-gradient(135deg,#a855f7,#d8b4fe)'
  ];
  document.querySelectorAll('.rest-thumb[data-img]').forEach((el, idx) => {
    const raw = el.getAttribute('data-img');
    // normalize Windows-style backslashes before splitting/encoding
    const encoded = raw.replace(/\\/g, '/').split('/').map(s => encodeURIComponent(s)).join('/');
    const preload = new Image();
    preload.onload = () => { el.style.backgroundImage = 'url("' + encoded + '")'; };
    preload.onerror = () => { el.style.backgroundImage = FALLBACK_GRADIENTS[idx % FALLBACK_GRADIENTS.length]; };
    preload.src = encoded;
  });
</script>
</body>
</html>

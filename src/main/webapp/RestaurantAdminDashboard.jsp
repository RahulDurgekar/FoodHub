<%@ page import="com.foodDelivery.model.User ,com.foodDelivery.model.Restaurant, java.util.*" %>
<%
User user = (User)session.getAttribute("loggedUser");

if (user == null) {
    response.sendRedirect("logIn.html");
    return;
}

List<Restaurant> restaurants = (List<Restaurant>)request.getAttribute("ownerRestaurants");
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Owner Restaurants - FoodHub</title>
<link rel="stylesheet" href="styles.css">
<link rel="icon" type="image/png" href="/fevicon.png">
</head>
<body>

<!-- ============================= NAVBAR ============================= -->
<header class="navbar">
  <div class="container">
    <a href="restaurantAdminServlet" class="logo">FoodHub<span class="dot">.</span></a>

    <nav class="nav-links">
      <a href="restaurantAdminServlet">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9.5 12 3l9 6.5"/><path d="M5 10v10h14V10"/></svg>
        Home
      </a>
    
      <a href="addRestaurant.jsp">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"/><path d="M8 9h8M8 13h5"/></svg>
        Add Restaurants
      </a>
      
      <a href="getOrders.jsp">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"/><path d="M8 9h8M8 13h5"/></svg>
        Orders
      </a>
      
    </nav>

    <form class="nav-search" role="search" action="allRestaurants" method="GET">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
      <input type="text" name="q" placeholder="Search food or restaurants">
    </form>

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
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="8" r="4"/>
            <path d="M4 21c0-4 3.6-6 8-6s8 2 8 6"/>
        </svg>
        Profile
    </a>

    <a href="LogOutServlet">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
            <path d="M10 17l5-5-5-5"/>
            <path d="M15 12H3"/>
        </svg>
        Log Out
    </a>

<% } else { %>

    <div class="profile-menu-header">
        <strong>Welcome to FoodHub</strong>
        <span>Log in to track orders &amp; save favorites</span>
    </div>

    <a href="logIn.html">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
            <path d="M10 17l5-5-5-5"/>
            <path d="M15 12H3"/>
        </svg>
        Log in
    </a>

    <a href="signUp.html" class="signup-link">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M19 8v6"/>
            <path d="M22 11h-6"/>
        </svg>
        Sign up
    </a>

<% } %>

        </div>
      </div>

      <button class="nav-toggle" id="mobileOpen" aria-label="Open menu">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round"><path d="M4 6h16M4 12h16M4 18h16"/></svg>
      </button>
    </div>
  </div>
</header>

<!-- mobile drawer -->
<div class="mobile-menu" id="mobileMenu">
  <div class="mobile-menu-panel">
    <button class="mobile-close" id="mobileClose" aria-label="Close menu">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M18 6 6 18M6 6l12 12"/></svg>
    </button>
    <a href="restaurantAdminServlet">Home</a>
    <a href="allRestaurants">Browse Restaurants</a>
    <a href="orders.html">Orders</a>
    <a href="delivery.html">Delivery</a>
    <a href="cart.html">Cart</a>
    <a href="logIn.html">Log in</a>
    <a href="signUp.html">Sign up</a>
  </div>
</div>

<!-- ============================= PAGE HEADER ============================= -->
<section class="hero" style="padding:56px 0 36px;">
  <div class="container" style="display:block;">
    <span class="eyebrow">All partner kitchens</span>
    <h1 style="font-size:clamp(2rem,4vw,2.8rem); margin-top:10px;"><%= user.getName() %>'s restaurants</h1>
    <p class="lead" style="margin-top:12px;">
      <% int count = (restaurants != null) ? restaurants.size() : 0; %>
      <%= count %> restaurant<%= count == 1 ? "" : "s" %> in your list.
    </p>
  </div>
</section>

<!-- ============================= CUISINE FILTER CHIPS ============================= -->

<!-- ============================= RESTAURANTS GRID ============================= -->
<section class="restaurants" style="padding-top:16px;">
  <div class="container">

<% if (restaurants == null || restaurants.isEmpty()) { %>

    <div style="text-align:center; padding:60px 20px; color:var(--color-text-muted);">
      <h3 style="color:var(--color-text); margin-bottom:8px;">No restaurants to show yet</h3>
      <p>Please add Restaurants.</p>
    </div>

<% } else { %>

    <div class="rest-grid">
<%
    String[] gradients = {
        "linear-gradient(135deg,#ffb627,#ff5a1f)",
        "linear-gradient(135deg,#3fa34d,#8bd17c)",
        "linear-gradient(135deg,#e5484d,#ff8a80)",
        "linear-gradient(135deg,#4f8cff,#8ab6ff)",
        "linear-gradient(135deg,#a855f7,#d8b4fe)"
    };
    int i = 0;
    for (Restaurant restaurant : restaurants) {
        boolean open = restaurant.isActive();
        String gradient = gradients[i % gradients.length];
        i++;
%>
      <a href="adminMenuItems?restaurantId=<%=  restaurant.getRestaurantId() %>" class="rest-card" style="display:block;">
        <div class="rest-thumb" data-img="<%= request.getContextPath() + "/" + restaurant.getImagePath() %>">
          <span class="badge"><%= open ? "Open" : "Closed" %></span>
          <span class="fav"><svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.6l-1-1a5.5 5.5 0 0 0-7.8 7.8l1 1L12 21l7.8-7.6 1-1a5.5 5.5 0 0 0 0-7.8Z"/></svg></span>
          <span class="time-pill"><%= restaurant.getDeliveryTime() %> min</span>
        </div>
        
        <div class="rest-perf"></div>
        <div class="rest-body">
          <div class="rest-name-row">
            <h3><%= restaurant.getName() %></h3>
            <span class="rating-badge"><svg viewBox="0 0 24 24"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6z"/></svg><%= restaurant.getRating() %></span>
          </div>
          <div class="rest-meta">
            <span>· <%= restaurant.getCuisineType() %></span>
          </div>
          <div class="rest-tags"><%= restaurant.getAddress() %></div>
          <div class="rest-footer">
            <span class="cost">Manage Restaurant</span>
            <span class="add-btn"><svg viewBox="0 0 24 24" fill="none" stroke-width="2.4" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg></span>
          </div>
        </div>
      </a>
<%
    }
%>
    </div>

<% } %>

  </div>
</section>

<!-- ============================= FOOTER ============================= -->
<footer class="site-footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-brand">
        <a href="restaurantAdminServlet" class="logo">FoodHub<span class="dot">.</span></a>
        <p>Bringing your city's best kitchens to your door — one ticket at a time.</p>
        <div class="footer-socials">
          <span class="icon-btn"><svg viewBox="0 0 24 24" fill="none" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1"/></svg></span>
          <span class="icon-btn"><svg viewBox="0 0 24 24" fill="none" stroke-width="2"><path d="M22 5.9c-.7.3-1.5.6-2.3.7.8-.5 1.5-1.3 1.8-2.3-.8.5-1.7.8-2.6 1a4.1 4.1 0 0 0-7 3.7A11.6 11.6 0 0 1 3.4 4.6a4.1 4.1 0 0 0 1.3 5.4c-.7 0-1.3-.2-1.9-.5v.1c0 2 1.4 3.6 3.3 4a4 4 0 0 1-1.8.1 4.1 4.1 0 0 0 3.8 2.8A8.2 8.2 0 0 1 2 18.4a11.6 11.6 0 0 0 6.3 1.8c7.5 0 11.6-6.2 11.6-11.6v-.5c.8-.6 1.5-1.3 2.1-2.2Z"/></svg></span>
          <span class="icon-btn"><svg viewBox="0 0 24 24" fill="none" stroke-width="2"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-4 0v7h-4v-7a6 6 0 0 1 6-6Z"/><rect x="2" y="9" width="4" height="12"/><circle cx="4" cy="4" r="2"/></svg></span>
        </div>
      </div>
      <div>
        <h4>Company</h4>
        <ul>
          <li><a href="#">About us</a></li>
          <li><a href="#">Careers</a></li>
          <li><a href="delivery.html">Ride with us</a></li>
        </ul>
      </div>
      <div>
        <h4>For you</h4>
        <ul>
          <li><a href="allRestaurants">Browse restaurants</a></li>
          <li><a href="orders.html">Your orders</a></li>
          <li><a href="cart.html">Your cart</a></li>
        </ul>
      </div>
      <div>
        <h4>Account</h4>
        <ul>
          <li><a href="logIn.html">Log in</a></li>
          <li><a href="signUp.html">Sign up</a></li>
          <li><a href="#">Help center</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <span>© 2026 FoodHub. All rights reserved.</span>
      <span>Made for people who mean it when they say they're starving.</span>
    </div>
  </div>
</footer>

<script>
  // ---- Theme toggle ----
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

  // ---- Profile dropdown ----
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
    const encoded = raw.replace(/\\/g, '/').split('/').map(s => encodeURIComponent(s)).join('/');
    const preload = new Image();
    preload.onload = () => { el.style.backgroundImage = 'url("' + encoded + '")'; };
    preload.onerror = () => { el.style.backgroundImage = FALLBACK_GRADIENTS[idx % FALLBACK_GRADIENTS.length]; };
    preload.src = encoded;
  });

  // ---- Mobile menu ----
  const mobileMenu = document.getElementById('mobileMenu');
  document.getElementById('mobileOpen').addEventListener('click', () => mobileMenu.classList.add('open'));
  document.getElementById('mobileClose').addEventListener('click', () => mobileMenu.classList.remove('open'));
  mobileMenu.addEventListener('click', (e) => { if (e.target === mobileMenu) mobileMenu.classList.remove('open'); });
</script>
</body>
</html>

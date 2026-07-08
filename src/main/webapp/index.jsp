<%@ page import="com.foodDelivery.model.User ,com.foodDelivery.model.Restaurant, java.util.*" %>
<%
User user = (User)session.getAttribute("loggedUser");
List<Restaurant> restaurants = (List<Restaurant>)request.getAttribute("topThreeRestaurant");
%>

<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodHub - Order food you'll actually crave</title>
<link rel="stylesheet" href="styles.css">
<link rel="icon" type="image/png" href="/fevicon.png">
</head>
<body>

<!-- ============================= NAVBAR ============================= -->
<header class="navbar">
  <div class="container">
    <a href="topRestaurant" class="logo">FoodHub<span class="dot">.</span></a>

    <nav class="nav-links">
      <a href="topRestaurant" class="active">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9.5 12 3l9 6.5"/><path d="M5 10v10h14V10"/></svg>
        Home
      </a>
      <a href="allRestaurants">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 3v18"/><path d="M4 3c2 0 3 1.5 3 3.5S6 10 4 10"/><path d="M15 3v18"/><path d="M20 3v7a3 3 0 0 1-3 3"/><path d="M20 3v18"/></svg>
        Browse Restaurants
      </a>
      <a href="orders.html">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"/><path d="M8 9h8M8 13h5"/></svg>
        Orders
      </a>
      <a href="delivery.html">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="7" width="14" height="10" rx="1"/><path d="M15 10h4l3 3v4h-7z"/><circle cx="6" cy="19" r="1.6"/><circle cx="17.5" cy="19" r="1.6"/></svg>
        Delivery
      </a>
    </nav>

    <form class="nav-search" role="search">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
      <input type="text" name="q" placeholder="Search food or restaurants">
    </form>

    <div class="nav-actions">
      <button class="theme-toggle" id="themeToggle" aria-label="Toggle dark mode">
        <span class="knob">
          <svg id="themeIcon" viewBox="0 0 24 24" fill="none" stroke-width="2.4" stroke-linecap="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>
        </span>
      </button>

      <a href="cart.html" class="icon-btn" aria-label="Cart">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M1 1h4l2.2 12.2a2 2 0 0 0 2 1.8h8.6a2 2 0 0 0 2-1.6L22 6H6"/></svg>
        <span class="cart-count">2</span>
      </a>

      <div class="profile-wrap" id="profileWrap">
        <button class="profile-btn" id="profileBtn">
          <span class="profile-avatar">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-6 8-6s8 2 8 6"/></svg>
          </span>
        </button>

        <!-- Profile dropdown: swap these links to your servlet URLs, e.g. /login and /register -->
        <div class="profile-menu" id="profileMenu">

<% if(user != null){ %>

    <div class="profile-menu-header">
        <strong>
            Welcome to FoodHub,
            <%= user.getName() %>
        </strong>

        <span>
            <%= user.getRole() %>
        </span>
    </div>

    <a href="updateUser.jsp">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2"
             stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 20h9"/>
            <path d="M16.5 3.5a2.1 2.1 0 1 1 3 3L7 19l-4 1 1-4Z"/>
        </svg>
        Update Profile
    </a>

    <a href="LogOutServlet">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2"
             stroke-linecap="round" stroke-linejoin="round">
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
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2"
             stroke-linecap="round" stroke-linejoin="round">
            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
            <path d="M10 17l5-5-5-5"/>
            <path d="M15 12H3"/>
        </svg>

        Log in
    </a>

    <a href="signUp.html" class="signup-link">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2"
             stroke-linecap="round" stroke-linejoin="round">
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
    <a href="topRestaurant">Home</a>
    <a href="allRestaurants">Browse Restaurants</a>
    <a href="orders.html">Orders</a>
    <a href="delivery.html">Delivery</a>
    <a href="cart.html">Cart</a>
    <a href="logIn.html">Log in</a>
    <a href="signUp.html">Sign up</a>
  </div>
</div>


<!-- ============================= HERO ============================= -->
<section class="hero">
  <div class="container">
    <div class="hero-copy">
      <span class="eyebrow">Bengaluru's fastest-growing delivery network</span>
      <h1>Your next favourite meal is <em>10 minutes</em> away.</h1>
      <p class="lead">FoodHub connects you to the best local kitchens and grocery stores track every order live, from the pan to your porch.</p>

      <form class="hero-search">
        <div class="field">
          <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
          <input type="text" placeholder="Delivery address" value="BTM, Bengaluru">
        </div>
        <div class="field">
          <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
          <input type="text" placeholder="Search dishes or restaurants">
        </div>
        <button class="btn btn-primary" type="submit">Find food</button>
      </form>

      <div class="hero-stats">
        <div><strong>1,200+</strong><span>Partner restaurants</span></div>
        <div><strong>20 min</strong><span>Average delivery</span></div>
        <div><strong>4.6★</strong><span>Average rating</span></div>
      </div>
    </div>

    <div class="hero-visual">
      <div class="floating-card fc-1"><span class="flame">ð¥</span> 120 orders today</div>
      <div class="ticket">
        <div class="eyebrow">Order #FH-2291</div>
        <div class="ticket-row"><span>Paneer Tikka Wrap</span><strong>₹180</strong></div>
        <div class="ticket-row"><span>Cold Coffee</span><strong>₹90</strong></div>
        <div class="ticket-row"><span>Delivery fee</span><strong>₹20</strong></div>
        <div class="divider"></div>
        <div class="ticket-total"><span>Total</span><span>₹290</span></div>
        <div class="ticket-status"><span class="blip"></span> Out for delivery</div>
      </div>
      <div class="floating-card fc-2">⭐ Rated 4.8 by 900+ diners</div>
    </div>
  </div>
</section>

<!-- ============================= CUISINES ============================= -->
<section class="cuisines">
  <div class="container">
    <span class="eyebrow">What are you craving</span>
    <div class="chip-row" style="margin-top:12px;">
      <div class="chip"><span class="emoji">🍕</span> Pizza</div>
      <div class="chip"><span class="emoji">🍜</span> Noodles</div>
      <div class="chip"><span class="emoji">🍛</span> Biryani</div>
      <div class="chip"><span class="emoji">🍔</span> Burgers</div>
      <div class="chip"><span class="emoji">🥗</span> Healthy</div>
      <div class="chip"><span class="emoji">🍰</span> Desserts</div>
      <div class="chip"><span class="emoji">🥘</span> South Indian</div>
      <div class="chip"><span class="emoji">🌮</span> Mexican</div>
      <div class="chip"><span class="emoji">☕</span> Cafe</div>
    </div>
  </div>
</section>

<!-- ============================= RESTAURANTS ============================= -->
<section class="restaurants">
  <div class="container">
    <div class="section-head">
      <div>
        <span class="eyebrow">Top rated near you</span>
        <h2 class="section-title">Restaurants on a roll</h2>
      </div>
      <a href="allRestaurants" class="btn btn-ghost btn-sm">View all restaurants</a>
    </div>

       <div class="rest-grid">


	<% 
	for( Restaurant restaurant: restaurants){
    boolean open = restaurant.isActive();

	%>
	
      <article class="rest-card">
        <div class="rest-thumb" style="background:<%= restaurant.getImagePath()%>;">
        
          <span class="badge"><%= open ? "Open" : "Closed" %></span>
          <span class="fav"><svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.6l-1-1a5.5 5.5 0 0 0-7.8 7.8l1 1L12 21l7.8-7.6 1-1a5.5 5.5 0 0 0 0-7.8Z"/></svg></span>
          <span class="time-pill"><%= restaurant.getDeliveryTime()%> min</span>
        </div>
        <div class="rest-perf"></div>
        <div class="rest-body">
          <h3><%= restaurant.getName() %> </h3>
          <div class="rest-meta">
            <span class="rating"><svg viewBox="0 0 24 24"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9L5.8 21l1.6-7L2 9.2l7.1-.6z"/></svg> <%= restaurant.getRating() %></span>
            <span>· <%= restaurant.getCuisineType() %> </span>
          </div>
          <div class="rest-tags"><%= restaurant.getAddress() %></div>
          <div class="rest-footer">
            <span class="cost">₹300 for two</span>
            <span class="add-btn"><svg viewBox="0 0 24 24" fill="none" stroke-width="2.4" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg></span>
          </div>
        </div>
      </article>
	
	<%
		} 
	%>

  

    </div>
  </div>
</section>

<!-- ============================= HOW IT WORKS ============================= -->
<section class="how">
  <div class="container">
    <span class="eyebrow">The FoodHub process</span>
    <h2 class="section-title">From craving to doorstep, in three steps</h2>

    <div class="how-grid">
      <div class="how-step">
        <div class="step-icon"><svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg></div>
        <h3>Find your kitchen</h3>
        <p>Search by cuisine, dish, or mood â filter by rating, price, and delivery time.</p>
      </div>
      <div class="how-step">
        <div class="step-icon"><svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M8 2v4M16 2v4M3 10h18"/></svg></div>
        <h3>Place your order</h3>
        <p>Pay securely and get a live order ticket the moment the kitchen confirms.</p>
      </div>
      <div class="how-step">
        <div class="step-icon"><svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="7" width="14" height="10" rx="1"/><path d="M15 10h4l3 3v4h-7z"/><circle cx="6" cy="19" r="1.6"/><circle cx="17.5" cy="19" r="1.6"/></svg></div>
        <h3>Track it live</h3>
        <p>Follow your rider on the map, down to the minute they knock on your door.</p>
      </div>
    </div>
  </div>
</section>

<!-- ============================= PROMO ============================= -->
<section class="promo">
  <div class="promo-inner">
    <div>
      <h2>Become a FoodHub delivery partner and earn on your own schedule.</h2>
      <p>Flexible hours, weekly payouts, and a rider app built for the road.</p>
    </div>
    <a href="delivery.html" class="btn btn-ghost">Start delivering</a>
  </div>
</section>

<!-- ============================= FOOTER ============================= -->
<footer class="site-footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-brand">
        <a href="index.html" class="logo">FoodHub<span class="dot">.</span></a>
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
      <span>Â© 2026 FoodHub. All rights reserved.</span>
      <span>Made for people who mean it when they say they're starving.</span>
    </div>
  </div>
</footer>

<script>
  // ---- Theme toggle (persists via localStorage; swap for a server-side
  // preference later if you want it tied to a logged-in user) ----
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

  // ---- Mobile menu ----
  const mobileMenu = document.getElementById('mobileMenu');
  document.getElementById('mobileOpen').addEventListener('click', () => mobileMenu.classList.add('open'));
  document.getElementById('mobileClose').addEventListener('click', () => mobileMenu.classList.remove('open'));
  mobileMenu.addEventListener('click', (e) => { if (e.target === mobileMenu) mobileMenu.classList.remove('open'); });
</script>
</body>
</html>

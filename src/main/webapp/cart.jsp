<%@ page import="com.foodDelivery.model.User, com.foodDelivery.model.Cart, com.foodDelivery.model.CartItem, java.util.*" %>
<%
User user = (User) session.getAttribute("loggedUser");

if (user == null) {
    response.sendRedirect("logIn.html");
    return;
}

Cart cart = (Cart) session.getAttribute("cart");
if (cart == null) {
    cart = new Cart();
}

Collection<CartItem> cartItems = cart.getItems().values();
double subtotal = cart.getTotalPrice();
double DELIVERY_FEE = cart.isEmpty() ? 0 : 30.0;
double TAX_RATE = 0.05;
double tax = subtotal * TAX_RATE;
double total = subtotal + DELIVERY_FEE + tax;
int restaurantId = cart.getRestaurantId();
%>

<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Your Cart - FoodHub</title>
<link rel="stylesheet" href="styles.css">
<link rel="icon" type="image/png" href="images/fevicon.png">
<!-- Razorpay Checkout JS SDK -->
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<style>
  .cart-wrap {
    padding: 44px 0 80px;
    display: grid;
    grid-template-columns: 1fr 380px;
    gap: 40px;
    align-items: start;
  }
  .cart-header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    flex-wrap: wrap;
    gap: 16px;
  }
  .cart-wrap h1 { font-size: clamp(1.7rem, 3vw, 2.2rem); margin: 0; }

  .cart-items-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 8px 24px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.04);
  }
  .cart-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 20px 0;
    border-bottom: 1px solid var(--color-border);
  }
  .cart-row:last-child { border-bottom: none; }
  .cart-item-info h3 { font-size: 1.05rem; margin-bottom: 4px; color: var(--color-text); }
  .cart-item-info .unit-price { font-family: var(--font-mono); font-size: 0.82rem; color: var(--color-text-muted); }

  .qty-control {
    display: flex;
    align-items: center;
    gap: 10px;
    background: var(--color-surface-alt);
    border: 1px solid var(--color-border);
    border-radius: 9999px;
    padding: 4px 8px;
  }
  .qty-control button {
    width: 28px; height: 28px;
    border-radius: 50%;
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    font-weight: 800;
    display: flex; align-items: center; justify-content: center;
    transition: background var(--transition-fast);
  }
  .qty-control button:hover { background: var(--color-primary-light); color: var(--color-primary); }
  .qty-control span { min-width: 20px; text-align: center; font-weight: 700; font-size: 0.9rem; }

  .cart-row-right { display: flex; align-items: center; gap: 18px; }
  .cart-row-total { font-family: var(--font-mono); font-weight: 700; min-width: 75px; text-align: right; font-size: 1rem; color: var(--color-text); }
  .remove-btn { color: var(--color-danger); font-size: 0.8rem; font-weight: 700; background: none; border: none; cursor: pointer; padding: 4px 8px; border-radius: var(--radius-sm); transition: background var(--transition-fast); }
  .remove-btn:hover { background: var(--color-danger-light); }

  .add-more-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    background: var(--color-surface-alt);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-full);
    font-size: 0.88rem;
    font-weight: 600;
    color: var(--color-text);
    transition: all var(--transition-fast);
    text-decoration: none;
  }
  .add-more-btn:hover {
    background: var(--color-primary);
    color: #ffffff;
    border-color: var(--color-primary);
  }

  .empty-cart { text-align: center; padding: 60px 20px; color: var(--color-text-muted); }
  .empty-cart svg { width: 56px; height: 56px; stroke: var(--color-text-muted); margin: 0 auto 16px; opacity: 0.7; }

  .summary-card {
    position: sticky;
    top: calc(var(--nav-h) + 20px);
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: 26px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.06);
  }
  .summary-card h3 { font-size: 1.15rem; margin-bottom: 18px; }
  .summary-line {
    display: flex; justify-content: space-between;
    font-size: 0.92rem; color: var(--color-text-secondary);
    padding: 7px 0;
  }
  .summary-line.total {
    color: var(--color-text);
    font-weight: 800;
    font-size: 1.1rem;
    border-top: 1.5px dashed var(--color-border);
    margin-top: 10px;
    padding-top: 14px;
  }
  .summary-line.total span:last-child { color: var(--color-primary); }

  .payment-section { margin-top: 26px; }
  .payment-section h4 { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.06em; color: var(--color-text-muted); margin-bottom: 12px; }
  .payment-option {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 13px 14px;
    border: 1.5px solid var(--color-border);
    border-radius: var(--radius-md);
    margin-bottom: 10px;
    cursor: pointer;
    transition: border-color var(--transition-fast), background var(--transition-fast);
  }
  .payment-option:hover { border-color: var(--color-primary); }
  .payment-option input[type="radio"] { width: 16px; height: 16px; accent-color: var(--color-primary); }
  .payment-option svg { width: 18px; height: 18px; stroke: var(--color-text); flex-shrink: 0; }
  .payment-option span { font-weight: 600; font-size: 0.9rem; }
  .payment-option.selected { border-color: var(--color-primary); background: var(--color-surface-alt); }

  .payment-extra {
    display: none;
    padding: 14px;
    background: var(--color-surface-alt);
    border-radius: var(--radius-sm);
    margin: -4px 0 14px;
  }
  .payment-extra.show { display: block; }
  .payment-extra input, .payment-extra select {
    width: 100%;
    padding: 10px 12px;
    border-radius: var(--radius-sm);
    border: 1px solid var(--color-border);
    background: var(--color-surface);
    color: var(--color-text);
    font-size: 0.88rem;
    margin-bottom: 10px;
  }
  .payment-extra .form-two { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }

  .place-order-btn { width: 100%; padding: 14px; margin-top: 6px; font-size: 0.96rem; }

  /* Modal styling */
  .popup-overlay {
    position: fixed; inset: 0; background: rgba(0,0,0,0.5);
    display: flex; align-items: center; justify-content: center;
    opacity: 0; pointer-events: none; transition: opacity 0.2s ease;
    z-index: 999;
  }
  .popup-overlay.open { opacity: 1; pointer-events: auto; }
  .popup-box {
    background: var(--color-surface); border-radius: var(--radius-lg);
    padding: 28px; max-width: 400px; width: 90%; text-align: center;
    border: 1px solid var(--color-border); box-shadow: 0 10px 40px rgba(0,0,0,0.2);
  }
  .popup-icon {
    width: 48px; height: 48px; border-radius: 50%; background: var(--color-danger-light);
    color: var(--color-danger); display: flex; align-items: center; justify-content: center;
    margin: 0 auto 16px;
  }
  .popup-icon svg { width: 24px; height: 24px; stroke: currentColor; }
  .popup-actions { display: flex; gap: 12px; margin-top: 20px; justify-content: center; }

  @media (max-width: 900px) {
    .cart-wrap { grid-template-columns: 1fr; }
    .summary-card { position: static; }
  }
  @media (max-width: 560px) {
    .payment-extra .form-two { grid-template-columns: 1fr; }
    .cart-row { flex-wrap: wrap; }
    .cart-row-right { width: 100%; justify-content: space-between; }
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

      <a href="cart.jsp" class="icon-btn" aria-label="Cart" style="position:relative;">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M1 1h4l2.2 12.2a2 2 0 0 0 2 1.8h8.6a2 2 0 0 0 2-1.6L22 6H6"/></svg>
<% if (!cart.isEmpty()) { %>
        <span class="cart-count"><%= cart.getTotalItems() %></span>
<% } %>
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

<!-- ============================= CART ============================= -->
<section class="container">
  <div class="cart-wrap">

    <div>
      <div class="cart-header-row">
        <h1>Your cart</h1>
<% if (restaurantId > 0) { %>
        <a href="menuServlet?restaurantId=<%= restaurantId %>" class="add-more-btn">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
          Add More Items
        </a>
<% } else { %>
        <a href="allRestaurants" class="add-more-btn">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
          Browse Restaurants
        </a>
<% } %>
      </div>

<% if (cart.isEmpty()) { %>
      <div class="cart-items-card">
        <div class="empty-cart">
          <svg viewBox="0 0 24 24" fill="none" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M1 1h4l2.2 12.2a2 2 0 0 0 2 1.8h8.6a2 2 0 0 0 2-1.6L22 6H6"/></svg>
          <p style="font-size:1.1rem; font-weight:600; color:var(--color-text);">Your cart is currently empty</p>
          <p style="font-size:0.88rem; margin-top:4px;">Explore our delicious dishes and add them to your order.</p>
          <a href="allRestaurants" class="btn btn-primary" style="margin-top:20px; display:inline-flex;">Browse restaurants</a>
        </div>
      </div>
<% } else { %>
      <div class="cart-items-card">
<%
    for (CartItem item : cartItems) {
%>
        <div class="cart-row">
          <div class="cart-item-info">
            <h3><%= item.getName() %></h3>
            <div class="unit-price">₹<%= String.format("%.2f", item.getPrice()) %> each</div>
          </div>

          <div class="cart-row-right">
            <!-- Separate un-nested quantity control forms -->
            <div class="qty-control">
              <form action="UpdateCartServlet" method="POST" style="display:inline; margin:0;">
                <input type="hidden" name="menuItemId" value="<%= item.getMenuId() %>">
                <input type="hidden" name="action" value="dec">
                <button type="submit" aria-label="Decrease quantity">−</button>
              </form>

              <span><%= item.getQty() %></span>

              <form action="UpdateCartServlet" method="POST" style="display:inline; margin:0;">
                <input type="hidden" name="menuItemId" value="<%= item.getMenuId() %>">
                <input type="hidden" name="action" value="inc">
                <button type="submit" aria-label="Increase quantity">+</button>
              </form>
            </div>

            <span class="cart-row-total">₹<%= String.format("%.2f", item.getItemTotal()) %></span>

            <form action="RemoveFromCartServlet" method="POST" style="display:inline; margin:0;">
              <input type="hidden" name="menuItemId" value="<%= item.getMenuId() %>">
              <button type="button" class="remove-btn" onclick="showDeletePopup(this)">Remove</button>
            </form>
          </div>
        </div>
<%
    }
%>
      </div>
<% } %>
    </div>

    <!-- ============================= ORDER SUMMARY + PAYMENT ============================= -->
    <aside class="summary-card">
      <h3>Order summary</h3>

      <div class="summary-line"><span>Subtotal</span><span>₹<%= String.format("%.2f", subtotal) %></span></div>
      <div class="summary-line"><span>Delivery fee</span><span>₹<%= String.format("%.2f", DELIVERY_FEE) %></span></div>
      <div class="summary-line"><span>Taxes (5%)</span><span>₹<%= String.format("%.2f", tax) %></span></div>
      <div class="summary-line total"><span>Total</span><span>₹<%= String.format("%.2f", total) %></span></div>

      <form action="PlaceOrderServlet" method="POST" id="checkoutForm">
        <div class="payment-section">
          <h4>Payment method</h4>

          <label class="payment-option selected">
            <input type="radio" name="paymentMode" value="COD" checked>
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="6" width="20" height="12" rx="2"/><path d="M2 10h20"/></svg>
            <span>Cash on Delivery</span>
          </label>

          <label class="payment-option">
            <input type="radio" name="paymentMode" value="UPI">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2 3 14h7l-1 8 10-12h-7l1-8Z"/></svg>
            <span>Razorpay Online / UPI / Card</span>
          </label>

          <label class="payment-option">
            <input type="radio" name="paymentMode" value="CARD">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2"/><path d="M1 10h22"/></svg>
            <span>Credit / Debit Card</span>
          </label>

          <label class="payment-option">
            <input type="radio" name="paymentMode" value="NET_BANKING">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 21h18M3 10h18M5 10v11M19 10v11M9 10v11M15 10v11M12 3l9-7H3l9-7z"/></svg>
            <span>Net Banking</span>
          </label>
        </div>

        <input type="hidden" name="totalAmount" value="<%= String.format("%.2f", total) %>">
        <button type="submit" class="btn btn-primary place-order-btn" <%= cart.isEmpty() ? "disabled" : "" %>>
          Place Order · ₹<%= String.format("%.2f", total) %>
        </button>
      </form>
    </aside>

  </div>
</section>

<!-- Remove-item confirmation popup -->
<div id="deletePopup" class="popup-overlay">
  <div class="popup-box">
    <div class="popup-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
    </div>
    <h3 style="margin-bottom:8px;">Remove item?</h3>
    <p style="color:var(--color-text-secondary); font-size:0.9rem;">Are you sure you want to remove this item from your cart?</p>
    <div class="popup-actions">
      <button id="deleteConfirmNo" class="btn btn-ghost" style="padding:10px 20px;">No, Keep it</button>
      <button id="deleteConfirmYes" class="btn btn-danger" style="padding:10px 20px;">Yes, Remove</button>
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

  const profileWrap = document.getElementById('profileWrap');
  const profileBtn = document.getElementById('profileBtn');
  if (profileBtn && profileWrap) {
    profileBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      profileWrap.classList.toggle('open');
    });
    document.addEventListener('click', () => profileWrap.classList.remove('open'));
  }

  // ---- Payment method selection ----
  const paymentOptions = document.querySelectorAll('.payment-option');
  paymentOptions.forEach(opt => {
    opt.addEventListener('click', () => {
      paymentOptions.forEach(o => o.classList.remove('selected'));
      opt.classList.add('selected');
      opt.querySelector('input[type="radio"]').checked = true;
    });
  });

  // ---- Checkout Form Submission & Razorpay Integration ----
  const checkoutForm = document.getElementById('checkoutForm');
  checkoutForm.addEventListener('submit', async function(e) {
    const selectedMode = document.querySelector('input[name="paymentMode"]:checked');
    const paymentMode = selectedMode ? selectedMode.value : 'COD';

    // If Cash on Delivery, submit form directly to PlaceOrderServlet
    if (paymentMode === 'COD') {
      return true;
    }

    e.preventDefault(); // Stop default form submit for online payments

    const btn = checkoutForm.querySelector('.place-order-btn');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = 'Connecting to Razorpay...';

    try {
      // Step 1: Call Servlet to create Razorpay Order
      const resp = await fetch('createRazorpayOrder', { method: 'POST' });
      const data = await resp.json();

      if (data.status !== 'success') {
        alert('Payment Initialization Failed: ' + (data.message || 'Error creating order'));
        btn.disabled = false;
        btn.innerHTML = originalText;
        return;
      }

      // Step 2: Open Razorpay Professional Checkout Popup
      const options = {
        "key": data.keyId,
        "amount": data.amount,
        "currency": "INR",
        "name": "FoodHub Delivery",
        "description": "Order Checkout",
        "order_id": data.razorpayOrderId,
        "handler": function (razorpayResponse) {
          btn.innerHTML = 'Verifying Payment...';
          // Step 3: Post Razorpay Response to VerifyPaymentServlet
          const verifyForm = document.createElement('form');
          verifyForm.method = 'POST';
          verifyForm.action = 'verifyPayment';

          const params = {
            'razorpay_payment_id': razorpayResponse.razorpay_payment_id,
            'razorpay_order_id': razorpayResponse.razorpay_order_id,
            'razorpay_signature': razorpayResponse.razorpay_signature,
            'paymentMode': paymentMode
          };

          for (const key in params) {
            const hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = key;
            hidden.value = params[key];
            verifyForm.appendChild(hidden);
          }

          document.body.appendChild(verifyForm);
          verifyForm.submit();
        },
        "prefill": {
          "name": data.userName,
          "email": data.userEmail,
          "contact": data.userPhone
        },
        "theme": {
          "color": "#e8281a" // Brand Red
        },
        "modal": {
          "ondismiss": function() {
            btn.disabled = false;
            btn.innerHTML = originalText;
          }
        }
      };

      const rzp = new Razorpay(options);
      rzp.open();

    } catch (err) {
      console.error(err);
      alert('Error initiating online payment. Please try again.');
      btn.disabled = false;
      btn.innerHTML = originalText;
    }
  });

  // ---- Remove-item confirmation popup ----
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

<%@ page import="com.foodDelivery.model.User ,com.foodDelivery.model.Restaurant, java.util.*" %>
<%@ page import="com.foodDelivery.model.User" %>

<%
User user = (User) session.getAttribute("loggedUser");

if(user==null){
    response.sendRedirect("logIn.html");
    return;
}
%>

<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<title>Add Restaurant</title>

<link rel="stylesheet" href="styles.css">

<style>

.auth-wrap{
    min-height:calc(100vh - var(--nav-h));
    display:flex;
    align-items:center;
    justify-content:center;
    padding:60px 24px;
}

.auth-card{

    width:100%;
    max-width:650px;

    background:var(--color-surface);

    border:1px solid var(--color-border);

    border-radius:var(--radius-lg);

    padding:40px;

    box-shadow:0 30px 60px -30px rgba(var(--shadow-color),0.4);

}

.form-group{

    margin-bottom:18px;

}

.form-group label{

    display:block;

    margin-bottom:6px;

    font-size:0.82rem;

    font-weight:700;

}

.form-group input{

    width:100%;

    padding:12px 14px;

    border-radius:var(--radius-sm);

    border:1px solid var(--color-border);

    background:var(--color-surface-alt);

}

.form-two{

    display:grid;

    grid-template-columns:1fr 1fr;

    gap:14px;

}

.btn{

    width:100%;

    margin-top:15px;

}

</style>

</head>

<body>

<header class="navbar">

<div class="container">

<a href="restaurantAdminServlet" class="logo">

FoodHub<span class="dot">.</span>

</a>

</div>

</header>

<div class="auth-wrap">

<div class="auth-card">

<span class="eyebrow">

Restaurant Registration

</span>

<h1>Add Restaurant</h1>

<p class="sub">

Register your restaurant and start receiving orders.

</p>

<form action="addRestaurant" method="POST">

<div class="form-group">

<label>Restaurant Name</label>

<input
type="text"
name="name"
required>

</div>

<div class="form-two">

<div class="form-group">

<label>Cuisine Type</label>

<input
type="text"
name="cuisineType"
required>

</div>

<div class="form-group">

<label>Delivery Time (Minutes)</label>

<input
type="number"
name="deliveryTime"
required>

</div>

</div>

<div class="form-group">

<label>Address</label>

<input
type="text"
name="address"
required>

</div>

<div class="form-two">

<div class="form-group">

<label>Rating</label>

<input
type="number"
step="0.1"
min="0"
max="5"
name="rating"
value="0">

</div>

<div class="form-group">

<label>Status</label>

<select name="isActive">

<option value="true">

Open

</option>

<option value="false">

Closed

</option>

</select>

</div>

</div>

<div class="form-group">

<label>Image Path</label>

<input
type="text"
name="imagePath"
placeholder="images/pizzaHut.jpg">

</div>

<!-- Owner ID comes from session -->

<input
type="hidden"
name="ownerId"
value="<%= user.getUserId() %>">

<button
type="submit"
class="btn btn-primary">

Add Restaurant

</button>

</form>

</div>

</div>

</body>

</html>
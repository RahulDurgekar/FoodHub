package com.foodDelivery.Servlets;

import com.foodDelivery.DAOImpl.*;

import java.io.IOException;
import java.io.PrintWriter;

import com.foodDelivery.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/signUp")
public class SignUpServlet extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String name=req.getParameter("name");
		String email=req.getParameter("email");
		long phone = Long.parseLong(req.getParameter("phone"));
		String address=req.getParameter("address");
		String role = req.getParameter("role");
		String password=BCrypt.hashpw(req.getParameter("password"), BCrypt.gensalt());
		
		User user=new User();
		user.setName(name);
		user.setEmail(email);
		user.setPhone(phone);
		user.setAddress(address);
		user.setPassword(password);
		user.setRole(role);
		
		UserDAOImpl ud =new UserDAOImpl();
		int i = ud.addUser(user);
		
		if(i==1) {
			resp.sendRedirect("logIn.html");
		}
		else {
			resp.sendRedirect("signUp.html");
		}

	}
}

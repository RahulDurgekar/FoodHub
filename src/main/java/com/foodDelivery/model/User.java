package com.foodDelivery.model;

import java.security.Timestamp;

public class User {
	
	private int userId;
    private String name;
    private String email;
    private long phone;
    private String address;
    private String password;
    private String role;
    private Timestamp createdDate;
    private Timestamp lastLogIn;
    
    
    public User() {
    	
    }
    
    public User(String name, String email, long phone, String address,
    		String password, String role) {
		super();
		this.name = name;
		this.email = email;
		this.phone = phone;
		this.address = address;
		this.password = password;
		this.role = role;
	}



	public User( String name, String email, long phone, String address,
    		String password, String role,Timestamp createdDate, Timestamp lastLogIn){
    		
		super();
    		this.name = name;
    		this.email = email;
    		this.phone = phone;
    		this.address = address;
    		this.password = password;
    		this.role = role;
    		this.createdDate=createdDate;
    		this.lastLogIn=lastLogIn;
    }
    
	
    
	public User(int userId, String name, String email, long phone, String address, String password, String role,
			Timestamp createdDate, Timestamp lastLogIn) {
		
		this.userId = userId;
		this.name = name;
		this.email = email;
		this.phone = phone;
		this.address = address;
		this.password = password;
		this.role = role;
		this.createdDate = createdDate;
		this.lastLogIn = lastLogIn;
	}

	
	
	public User(int userId, String name, String email, long phone, String address, String password, String role) {
		super();
		this.userId = userId;
		this.name = name;
		this.email = email;
		this.phone = phone;
		this.address = address;
		this.password = password;
		this.role = role;
	}

	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public long getPhone() {
		return phone;
	}
	public void setPhone(long phone) {
		this.phone = phone;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
    
	@Override
    public String toString() {
        return "User userId: " +userId+ ", name: "+name+
                ", email: "+email+", phone: "+phone+
                ", address: "+address+", role: "+role+"";
    }


	public Timestamp getCreatedDate() {
		return createdDate;
	}


	public void setCreatedDate(Timestamp createdDate) {
		this.createdDate = createdDate;
	}


	public Timestamp getLastLogIn() {
		return lastLogIn;
	}


	public void setLastLogIn(Timestamp lastLogIn) {
		this.lastLogIn = lastLogIn;
	}
}

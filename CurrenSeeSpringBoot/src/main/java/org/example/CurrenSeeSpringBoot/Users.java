package org.example.CurenSeeSpringBoot;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import com.mongodb.lang.Nullable;

import lombok.Data;
import lombok.NonNull;

@Document(collection="users")
@Data
public class Users {
	
    @Id
    private ObjectId _id;

    @NonNull
    private String username;
    private String password;
    private String email;
    private String phone;
    private String baseCurrency;

    
	public String getPhone() {

		return phone;
	}
	public String getUsername() {

		return username;
	}
	public String getEmail() {

		return email;
	}
	public String getPassword() {

		return password;
	}
	
	public String getBaseCurrency() {
		return baseCurrency;
	}
	
    public void setUsername(String username) {
        this.username = username;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public void setBaseCurrency(String baseCurrency) {
    	this.baseCurrency = baseCurrency;
    }

}

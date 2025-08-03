package org.example.CurenSeeSpringBoot;

import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin
@RestController
public class userController {
	
    @Autowired
    private UserRepo userRepo;
	
    @GetMapping("/login")
	public ResponseEntity<Users> login(@RequestParam String password, @RequestParam String other ) {
    	Users username = userRepo.findUsersByUsername(other);
    	Users email = userRepo.findUsersByEmail(other);
    	Users phone = userRepo.findUsersByPhone(other);
 
		if(username != null && Objects.equals(username.getPassword(), password)) {
			
			return new ResponseEntity<>(username, HttpStatus.OK);	
			
		}else if(email!=null && Objects.equals(email.getPassword(), password)) {
			
				return new ResponseEntity<>(email, HttpStatus.OK);		
			
		}else if(phone!=null && Objects.equals(phone.getPassword(), password)) {
			
				return new ResponseEntity<>(phone, HttpStatus.OK);
			
		}else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	    }
 	

	}
    
    @PostMapping("/new-user")
    public ResponseEntity<Users> createUser(@RequestBody Users user) {
        String username = user.getUsername();
        String email = user.getEmail();
        String phone = user.getPhone();
        String password = user.getPassword();
        String baseCurrency = user.getBaseCurrency();
        
       if(username.isBlank()||username.isEmpty()||email.isBlank()||email.isEmpty()||password.isBlank()||password.isEmpty()||baseCurrency.isEmpty()) {
    	   return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
       }
       else {
       if (userRepo.findUsersByUsername(username) == null && userRepo.findUsersByEmail(email) == null && userRepo.findUsersByPhone(phone) == null) {
            return ResponseEntity.status(HttpStatus.CREATED).body(userRepo.save(user));
        }else {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(null);
        }
       }
     }
    
    @DeleteMapping("/delete-account/{username}")
    public ResponseEntity<Users> deleteUser(@PathVariable String username, @RequestParam String password){
        Users user = userRepo.findUsersByUsername(username);
        if (user == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }else {
            if (password.equals(user.getPassword())) {
                userRepo.delete(user);
                return new ResponseEntity<>(user, HttpStatus.OK);
            }else {
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
            }
        }

   }

    
    @PatchMapping("/editUser/{username}")
    public  ResponseEntity<Users> editUser
    (@PathVariable String username, @RequestParam String password, @RequestBody Users user){
        Users user1 = userRepo.findUsersByUsername(username);
     
        
        
        if (password.equals(user1.getPassword())) {
          
        	if(user.getUsername().isEmpty() || user.getUsername().isBlank() || user.getUsername() == username) {
       		 user1.setUsername(username);
       		 }
       		 
       		    if(user.getEmail().isBlank() || user.getEmail().isEmpty() || user.getEmail() == user1.getEmail()) {
             	 user1.setEmail(user1.getEmail());
             	 }
       		    
       		  if(user.getPhone().isBlank() || user.getPhone().isEmpty() || user.getPhone() == user1.getPhone()) {
            	  user1.setPhone(user1.getPhone());
            	  }
       		  
       		if(user.getPassword().isBlank() || user.getPassword().isEmpty() || user.getPassword() == password) {
             	  user1.setPassword(user1.getPassword());
             	  
             	}
       		
       		if(!user.getUsername().isEmpty() && !user.getUsername().isBlank()) {
       		Users takenUser = userRepo.findUsersByUsername(user.getUsername());
          		 if(takenUser == null || takenUser == user1) {
          			user1.setUsername(user.getUsername());
          		 }else {
          			return new ResponseEntity<>(HttpStatus.CONFLICT);
          		 }
          		 
          		 }
          		 
          		    if(!user.getEmail().isBlank() && !user.getEmail().isEmpty()) {
          		    	Users takenUser = userRepo.findUsersByEmail(user.getEmail());	
                	 if(takenUser == null || takenUser == user1) {
                		 user1.setEmail(user.getEmail());
                	 }else {
               			return new ResponseEntity<>(HttpStatus.CONFLICT);
              		  }
                	 }
          		    
          		  if(!user.getPhone().isBlank() && !user.getPhone().isEmpty()) {
          			Users takenUser = userRepo.findUsersByPhone(user.getPhone());
          			if(takenUser == null || takenUser == user1) {
          				user1.setPhone(user.getPhone());
          			}else {
              			return new ResponseEntity<>(HttpStatus.CONFLICT);
             		 }  
               	  
               	  }
          		  
          		if(!user.getPassword().isBlank() && !user.getPassword().isEmpty()) {
                	  user1.setPassword(user.getPassword());
                	 
                	}
            		 
       		
                return new ResponseEntity<>(userRepo.save(user1), HttpStatus.OK);


   }else {
       return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
      }
    }
    
    @PostMapping("/setBase/{username}")
    public void changeBaseCurrency(@PathVariable String username, @RequestParam String newCurrency) {
    	Users user = userRepo.findUsersByUsername(username);
    	user.setBaseCurrency(newCurrency);
    	userRepo.save(user);
    }
	
   }
 


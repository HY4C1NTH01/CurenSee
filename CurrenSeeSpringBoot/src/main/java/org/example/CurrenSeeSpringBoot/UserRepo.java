package org.example.CurenSeeSpringBoot;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepo extends MongoRepository<Users,ObjectId>{  

    Users findUsersByEmail(String email);
	
    Users findUsersByPhone(String phone);

	Users findUsersByUsername(String username);
}

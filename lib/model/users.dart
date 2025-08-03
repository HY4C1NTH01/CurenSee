import 'dart:convert';

UsersModel usersModelJson(String str) => UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel{
 String username;
 String password;
 String email;
 String phone;

 String baseCurrency;

 UsersModel({required this.username, required this.password, required this.email, required this.phone, required this.baseCurrency});

 factory UsersModel.fromJson(Map<String,dynamic> json) => UsersModel(
   username: json["username"],
   password: json["password"],
   email: json["email"],
   phone: json["phone"],
   baseCurrency: json["baseCurrency"]
 );

 Map<String,dynamic> toJson() => {
   "username": username,
   "password": password,
   "email": email,
   "phone": phone,
   "baseCurrency": baseCurrency
 };



}
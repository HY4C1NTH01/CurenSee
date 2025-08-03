import 'dart:convert';

import 'package:curen_see/landing.dart';
import 'package:curen_see/main.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'signUp.dart';

class Login extends StatefulWidget{

  const Login({super.key});

  @override
  State<Login> createState() {
   return _LoginState();
  }
}

class _LoginState extends State<Login>{

  String _password = "";
  String _other = "";

  Map userData = {};

  final _formKey = GlobalKey<FormState>();

  Future<Object> login(String other, String password, BuildContext context) async{
    var url = Uri(host: "localhost", port: 8085, path: "/login").replace(queryParameters: {
      "password": password,
      "other": other
    });
    var data = await http.get(url);
    var jsonData = json.decode(data.body);

    if(data.statusCode == 200){

      String username = jsonData['username'].toString();
      String baseCurrency = jsonData['baseCurrency'].toString();
      String phone = jsonData['phone'].toString();
      String password1 = jsonData['password'].toString();
      String email = jsonData['email'].toString();

      userData = {"username": username,
        "baseCurrency": baseCurrency,
        "phone": phone,
        "password": password1,
        "email": email
      };

      navigatorKey.currentState?.pushNamed('/home',arguments: userData);

    }else{
      showDialog(context: context, builder: (BuildContext dialogContext){
        return AlertDialog(title: Text("Unexpected error"), content: Text("Either information is incorrect or account doesn't exist"),);
      });
    }

    return "done";
}

  @override
  Widget build(BuildContext context) {
     return Scaffold(

           body: Column(
             
             children: <Widget>[
               Row(
                   children: [ Container(
                     height: 50,
                     width: 70,

                     margin: const EdgeInsets.only(left: 10),
                     child: ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Landing(),));}
                       ,style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                       child: const Icon(Icons.home,color: Colors.white,),),
                   ),
                   ]),
               Padding(padding: const EdgeInsets.all(15),child: Form(
                   key: _formKey,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       TextFormField(
                         onChanged: (value){
                           setState(() {
                             _other = value;
                           });
                         },
                         decoration: const InputDecoration(
                             hintText: 'Email, Username or Phone Number(with country code)',
                             labelText: 'Email, Username or Phone Number',
                             prefixIcon: Icon(Icons.verified_user_sharp),
                             errorStyle: TextStyle(fontSize: 18.0),
                             border: OutlineInputBorder(
                                 borderSide: BorderSide(color: Colors.lightGreen),
                                 borderRadius: BorderRadius.all(Radius.circular(10)),
                                 gapPadding: 20
                             )
                         ),
                       ),
                       SizedBox(
                         height: 40,
                         width: MediaQuery.of(context).size.width,
                       ),
                       TextFormField(
                         onChanged: (value){
                           setState(() {
                             _password = value;
                           });
                         },
                         validator: MultiValidator([
                           RequiredValidator(errorText: "Please enter a Password"),
                           MinLengthValidator(8, errorText: "Password must be at least 8 characters"),
                           PatternValidator(r'(?=.*?[#!@$%^&*-])', errorText: "Password must have at least one special character")
                         ]).call,
                         decoration: const InputDecoration(
                             hintText: 'Password',
                             labelText: 'Password',
                             prefixIcon: Icon(Icons.key),
                             errorStyle: TextStyle(fontSize: 18.0),
                             border: OutlineInputBorder(
                                 borderSide: BorderSide(color: Colors.lightGreen),
                                 borderRadius: BorderRadius.all(Radius.circular(10))
                             )
                         ),
                       ),
                       SizedBox(
                         height: 60,
                         width: MediaQuery.of(context).size.width,
                       ),
                       Container( margin : const EdgeInsets.only(top: 50),
                           child: SizedBox(height: 100, width: 200,
                               child: FloatingActionButton
                                 (onPressed: () async{
                                 if(_formKey.currentState!.validate()){
                                   try{
                                     await login(_other, _password, context);
                                   }on Exception catch (e){
                                     showDialog(context: context, builder: (BuildContext dialogContext){
                                       return AlertDialog(title: Text("Unexpected error: ${e.hashCode}"), content: Text("Either information is incorrect or account doesn't exist"),);
                                     });
                                   }

                                 }else{
                                   debugPrint("Invalid credentials");
                                 }
                               },   heroTag: "loginBtn",
                                 backgroundColor: Colors.green,
                                 hoverColor: Colors.lightGreenAccent,
                                 child: const Text("Login",style: TextStyle(color: Colors.black45,fontSize:30)),)))

                     ],
                   ))
               ),
               Padding(padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                   child: InkWell(child: const Text("Don't have an account? SignUp!"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp(),))))],
           )
       );

  }

}
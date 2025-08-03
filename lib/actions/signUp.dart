import 'dart:async';
import 'dart:convert';

import 'package:curen_see/main.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:http/http.dart' as http;
import 'package:curen_see/landing.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});

  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {


  Timer? timer;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer timer)=> reaload());
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }


  PhoneNumber _phone = PhoneNumber(countryISOCode: "NG", countryCode: "+234", number: "000");
  String _email = "";
  String _password = "";
  String _userName = "";
  Currency? _baseCurrency;

  Future<Object> registerUser(
      String username, String password, String email, String phone, String baseCurrency,
      BuildContext context) async{
    var url = Uri(host: "localhost", port: 8085, path: "/new-user");
    var response = await http.post(url,headers:<String,String>{
      "Content-Type" : "application/json"},
        body: jsonEncode(<String,String>{
          "username" : username,
          "password" : password,
          "email" : email,
          "phone" : phone,
          "baseCurrency" : baseCurrency
        }));

    String responseString = response.body;
    if(response.statusCode == 201){
      final userData = <String,dynamic>{"username" : _userName,
        "password" : _password,
        "email" : _email,
        "phone" : _phone.completeNumber,
        "baseCurrency" : _baseCurrency!.code};

      navigatorKey.currentState?.pushNamed('/home',arguments: userData);
      showDialog(context: context, barrierDismissible: true, builder: (BuildContext dialogContext) {
        return AlertDialog(title: Text("User successfully added"), content: Text(responseString));

      });
    }else{
      showDialog(context: context, builder: (BuildContext dialogContext){
        return AlertDialog(title: Text("Unexpected error"), content: Text("Please check if information is correct. if it is, then either the username, email or phone number already belongs to another account"),);
      });
    }

    return "done";
  }

  String? btnTxt(){
    if(_baseCurrency == null){
      return "Select a default currency";
    }else{
      return "Default currency: ${_baseCurrency?.code} (Tap to change)";
    }
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

                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                    ),

                    ElevatedButton(onPressed: (){
                      showCurrencyPicker(context: context, onSelect: (Currency currency){
                        _baseCurrency = currency;
                        btnTxt();
                      });
                    },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text(btnTxt() as String,style: TextStyle(
                          color: Colors.white
                        ),)),
                  ]),
              Padding(padding: const EdgeInsets.all(15),child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value){
                          setState(() {
                            _userName = value;
                          });
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Username is required"),
                          MinLengthValidator(5, errorText: "Username must contain at least 5 characters")
                        ]).call,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        decoration: const InputDecoration(
                            hintText: 'Make a username for your account',
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.text_fields_outlined),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightGreen),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            )
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                      ),
                      TextFormField(
                        onChanged: (value){
                          setState(() {
                            _email = value;
                          });
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Email address is required"),
                          EmailValidator(errorText: "Please enter a valid email address"),

                        ]).call,
                        decoration: const InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightGreen),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            )
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                      ),
                      TextFormField(
                        onChanged: (value){
                          setState(() {
                            _password = value;
                          });
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Password is required"),
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
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                      ),
                      IntlPhoneField(
                        initialCountryCode: "NG",
                        onChanged: (value) {setState(() {
                          _phone = value;
                        });},
                        decoration: const InputDecoration(
                            hintText: "Enter Phone number",
                            border: OutlineInputBorder()

                        ),
                        validator: (p0) {
                          MultiValidator(
                          [RequiredValidator(errorText: "Phone number required"),
                           LengthRangeValidator(min: 6, max: 11, errorText: "Invalid number")
                          ]
                          );
                          return null;
                        },
                      ),

                      Container(margin : const EdgeInsets.only(top: 50),
                          child: SizedBox(height: 100, width: 200,
                              child: FloatingActionButton
                                (onPressed: () async{
                                  if(_formKey.currentState!.validate()){
                                   try{
                                     await registerUser(_userName, _password, _email, _phone.completeNumber, _baseCurrency!.code, context);
                                   }on NumberTooShortException catch(e) {
                                     showDialog(context: context, builder: (
                                         BuildContext dialogContext) {
                                       return AlertDialog(title: Text('${e.hashCode}'),
                                           content: SingleChildScrollView(
                                               scrollDirection: Axis.vertical,
                                               child: Text(
                                                   "Please input valid credentials. Don't leave any field blank.")));
                                     });
                                   }
                                  }else{
                                    debugPrint("Invalid Phone no");
                                  }
                              },heroTag: "loginBtn",
                                backgroundColor: Colors.green,
                                hoverColor: Colors.lightGreenAccent,
                                child: const Text("Sign Up",style: TextStyle(color: Colors.black45,fontSize:30)),)
                          )
                      )
                    ],
                  ))
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: InkWell(child: const Text("Already have an account? Login!"),onTap: ()=> navigatorKey.currentState?.pushNamed('/login')))],
          )
      );

  }

  void reaload() {
    if(btnTxt() == null || btnTxt() == "Select a default currency"){
      return;
    }else{
      setState(() {});
    }
  }

}

//ElevatedButton(onPressed:
//         (){ Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));}, child: Text("Already have an account? Login!")),

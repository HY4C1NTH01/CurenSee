import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class ChangeDetails extends StatefulWidget {

  final dynamic userData;

  const ChangeDetails({super.key, required this.userData});

  @override
  State<ChangeDetails> createState() {
    return _ChangeState();
  }
}

class _ChangeState extends State<ChangeDetails> {

  final _formKey = GlobalKey<FormState>();

  late String username;
  late String password;
  late String email;
  late String phone;
  late String base;

  late String initUsername;
  late String initPassword;


  void updateUI(dynamic userData) {
    setState(() {
      initUsername = userData['username'].toString();
      phone = userData['phone'].toString();
      initPassword = userData['password'].toString();
      email = userData['email'].toString();
      base = userData['baseCurrency'].toString();
    });
  }


  @override
  void initState() {
    super.initState();
    updateUI(widget.userData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: initUsername,
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                validator: MultiValidator([
                  MinLengthValidator(5,
                      errorText: "Username must contain at least 5 characters")
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
              ),
              TextFormField(
                initialValue: email,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: MultiValidator([
                  EmailValidator(
                      errorText: "Please enter a valid email address"),

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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
              ),
              TextFormField(
                initialValue: initPassword,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: MultiValidator([
                  MinLengthValidator(
                      8, errorText: "Password must be at least 8 characters"),
                  PatternValidator(r'(?=.*?[#!@$%^&*-])',
                      errorText: "Password must have at least one special character")
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
              ),
              IntlPhoneField(
                onChanged: (value) {
                  setState(() {
                    phone = value.completeNumber;
                  });
                },
                decoration: const InputDecoration(
                    hintText: "Enter Phone number",
                    border: OutlineInputBorder()

                ),
              ),

              Container(margin: const EdgeInsets.only(top: 50),
                  child: SizedBox(height: 100, width: 200,
                      child: FloatingActionButton
                        (
                        onPressed: () async {

                            if (_formKey.currentState!.validate()) {
                              await changeUser(
                                initUsername, initPassword,
                                  username, password, email, phone, context);
                            }
                           else {
                            debugPrint("Invalid credentials");
                          }
                        },
                        heroTag: "changeBtn",
                        backgroundColor: Colors.green,
                        hoverColor: Colors.lightGreenAccent,
                        child: const Text("Change Details", style: TextStyle(
                            color: Colors.black45, fontSize: 30)),)))

            ],
          )),

    );
  }

  Future<Object> changeUser(String initUsername, String initPassword,
      String username, String password, String email, String phone,
      BuildContext context) async {
    var url = Uri.parse(
        "http://localhost:8085/editUser/$initUsername?password=$initPassword");
    var response = await http.patch(url, headers: <String, String>{
      "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS, PATCH, GET, DELETE"
      },
        body: jsonEncode(<String, String>{
          "username": username,
          "password": password,
          "email": email,
          "phone": phone}
        ));

    if (response.statusCode == 200) {
      final userData = <String, dynamic>{"username": username,
        "password": password,
        "email": email,
        "phone": phone
      };

      navigatorKey.currentState?.pushNamed('/home', arguments: userData);

    }

    return "done";
  }
}
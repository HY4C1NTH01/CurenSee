import 'package:curen_see/actions/change_details.dart';
import 'package:curen_see/actions/convert_currencies.dart';
import 'package:curen_see/actions/questions.dart';
import 'package:curen_see/actions/signUp.dart';
import 'package:curen_see/accountless/unlogged_home.dart';
import 'package:flutter/material.dart';
import 'package:curen_see/actions/Login.dart';
import 'package:curen_see/accountless/convert_currencies2.dart';

import 'package:curen_see/home.dart';
import 'package:curen_see/landing.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Landing());
      case '/home':
        return MaterialPageRoute(builder: (context) =>
            Home(
              userData: args,
            ));
      case '/unlogged':
        return MaterialPageRoute(builder: (context) => UnloggedHome());
      case '/login':
        return MaterialPageRoute(builder: (context) => Login());
      case '/signup':
        return MaterialPageRoute(builder: (context) => SignUp());
      case '/convert1':
    return MaterialPageRoute(builder: (context) => ConvertCurrencies(userData: args));
      case '/convert2':
        return MaterialPageRoute(builder: (context) => ConvertCurrencies2());
      case '/questions':
        return MaterialPageRoute(builder: (context) => Questions(userData: args));
      case '/change':
        return MaterialPageRoute(builder: (context) => ChangeDetails(userData: args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("ERROR 404"),
          centerTitle: true,
        ),
        body: Center(
          child: Text("Page Not Found"),
        ),
      );
    });
  }
}
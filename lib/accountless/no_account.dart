import 'package:curen_see/actions/signUp.dart';
import 'package:flutter/material.dart';

class NoAccount extends StatelessWidget {
  const NoAccount({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sign Up to get the best of CurrenSee',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 50, 0)),
          useMaterial3: true,
        ),
        home: const SignUp()
    );
  }
}
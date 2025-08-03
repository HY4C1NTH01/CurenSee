import 'package:curen_see/main.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget{

  const Landing({super.key});

  @override
  State<StatefulWidget> createState() => _LandingState();
}

class _LandingState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {

   return Scaffold(
     body: Container(
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
       decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/backgroundtwo.jpg"),
        fit: BoxFit.cover)
       ),
       padding: const EdgeInsets.all(20),
       child: Column(
         children: [
           AppBar(
             automaticallyImplyLeading: false,
             title: Row(
               children: [
                Container(
                 margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/3 ),
                 child: Image.asset('assets/images/logo.jpg',width: 50,height: 50,fit: BoxFit.cover, ),
                ),
                 const Text("Welcome to CurenSee!",style: TextStyle(color: Colors.white,),),
               ],
             ),
             backgroundColor: const Color.fromRGBO(0, 0, 100, 0.5),
           ),

           Column(
             children: [
             Container(
               height: 80,
               width: 150,
               margin: const EdgeInsets.only(top: 70),
               child: FloatingActionButton(
                 backgroundColor: const Color.fromRGBO(0, 0, 100, 0.5),
                 heroTag: 'signupPageBtn',
                 onPressed: (){
                   navigatorKey.currentState?.pushNamed('/signup');
                 },
                 child: const Text("SignUp",style: TextStyle(color: Colors.green)),
               ),
             ),
               Container(
                 height: 80,
                 width: 150,
                 margin: const EdgeInsets.only(top: 20),
                 child: FloatingActionButton(
                   backgroundColor: const Color.fromRGBO(0, 0, 100, 0.5),
                   heroTag: 'loginPageBtn',
                   onPressed: (){
                     navigatorKey.currentState?.pushNamed('/login');
                   },
                   child: const Text("Login",style: TextStyle(color: Colors.yellow)),
                 ),
               ),

             Container(
               height: 80,
               width: 150,
               margin: const EdgeInsets.only(top: 20),
               child: FloatingActionButton(
                 backgroundColor: const Color.fromRGBO(0, 0, 100, 0.5),
                 heroTag: 'homePageBtn',
                 onPressed: (){
                   navigatorKey.currentState?.pushNamed('/unlogged');},
                 child: const Text("See HomePage as Guest",style: TextStyle(color: Colors.deepOrangeAccent),textAlign: TextAlign.center,),
               ),
             )
           ],),


         ],
       ),
     ),
   );
  }

}
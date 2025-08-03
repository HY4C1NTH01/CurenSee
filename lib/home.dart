import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:curen_see/actions/change_details.dart';
import 'package:curen_see/features/notification_service.dart';
import 'package:curen_see/main.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:hover_widget/hover_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'landing.dart';

class Home extends StatefulWidget {

  final dynamic userData;

  const Home({super.key, required this.userData});



  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  late String username;
  late String password;
  late String email;
  late String phone;
  late String baseCurrency;

  @override
  void initState(){
    super.initState();
    updateUI(widget.userData);
  }

  void updateUI(dynamic userData){

    setState(() {
      username = userData['username'].toString();
      phone = userData['phone'].toString();
      password = userData['password'].toString();
      email = userData['email'].toString();
      baseCurrency = userData['baseCurrency'].toString();
    });

  }



  String? btnTxt(){
    return baseCurrency;
  }

  @override
  Widget build(BuildContext homeContext) {

  final Uri url = Uri.parse('https://www.reuters.com/markets/currencies/');
  final Uri url2 = Uri.parse('https://www.fxstreet.com/news');
  final Uri url3 = Uri.parse('https://www.forex.com/en/news-and-analysis/');
  final Uri pastRatesUrl = Uri.parse('https://fxds-hcc.oanda.com/');
  final Uri liveRatesUrl = Uri.parse('https://www.xe.com/currencycharts/?from=$baseCurrency');
  Random random = Random();

  Future<void> onLaunchUrl(Uri uri) async {
  if(!await launchUrl(uri)){
  throw Exception("Error in the link");

  }
  }


  void ranUrl(){
  var rng = random.nextInt(3);
  if(rng == 0){
  onLaunchUrl(url);
  }
  else if(rng == 1){
  onLaunchUrl(url2);
  }
  else if(rng == 2){
  onLaunchUrl(url3);
  }
  }

  void showList (){
    showCurrencyPicker(context: context, onSelect: (Currency currency){
      showList();
    }, favorite: ["USD","EUR","CAD","GBP","NGN"]);
  }


  return  Scaffold(
      drawer: DrawerSideBar(),
      body : Builder(
          builder: (builderContext) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/backgroundthree.jpg"),
                      fit: BoxFit.cover)
              ),
              child: Column(

                children: [
                  AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                    title: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/3),
                            child: IconButton(onPressed: (){
                              navigatorKey.currentState?.pushNamed('/');
                            }, icon: Image.asset('assets/images/logo.jpg',width: 50,height: 50,fit: BoxFit.cover,),)
                        ),
                        const Text("Welcome to CurenSee",style: TextStyle(color: Colors.lime)),
                      ],
                    ),
                    centerTitle: false,
                    actions: <Widget>[

                      IconButton(onPressed: () {
                        showCurrencyPicker(context: context, onSelect: (Currency currency){
                          setState(() async{
                            baseCurrency = currency.code;
                            {
                              var url = Uri.parse("http://localhost:8085/setBase/$username?newCurrency=$baseCurrency");
                              await http.patch(url,headers: {
                                "Access-Control-Allow-Origin": "*", // Required for CORS support to work
                                "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
                                "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                                "Access-Control-Allow-Methods": "POST, OPTIONS, PATCH, GET, DELETE"
                              });

                          }});
                        });
                      }, icon: Text(btnTxt() as String, style: TextStyle(color: Colors.white),),hoverColor: Colors.green,
                          onHover: (value) =>
                              HoverWidget(child: Text("Tap to change default currency"))
                      ),

                      IconButton(onPressed: () {
                        Scaffold.of(builderContext).openDrawer();
                        NotiService().showNotifications(title: 'CurrenSee', body: "Get the latest exchange rate trends here today");
                      }, icon: const Icon(Icons.notifications),hoverColor: Colors.green),

                      IconButton(onPressed: () {
                        Scaffold.of(builderContext).openDrawer();
                      }, icon: const Icon(Icons.account_circle_rounded),hoverColor: Colors.green),
                    ],
                  ),
                  Row(
                    children: [

                      Container(
                          height: 200, width: 200,
                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/5, right: 40, top: 40),
                          child: FittedBox(
                            child:   FloatingActionButton(
                              backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                              heroTag: 'convertBtn',
                              hoverColor: const Color.fromRGBO(0, 50, 0, 1),
                              onPressed: () {
                                dynamic userData ={
                                  "username": username,
                                  "baseCurrency": baseCurrency,
                                  "phone": phone,
                                  "password": password,
                                  "email": email
                                };
                                navigatorKey.currentState?.pushNamed('/convert1',arguments: userData);
                              },
                              child: const Column(
                                  children: [
                                    Icon(Icons.currency_exchange_rounded, color:  Color.fromARGB(255, 0, 200, 0),size: 40),
                                    Text("Convert Currencies",style: TextStyle(
                                        color: Colors.lightGreenAccent,
                                        fontSize: 5

                                    ),)
                                  ]
                              ),
                            ),
                          )
                      ),
                      Container(
                          height: 200, width: 200,
                          margin: const EdgeInsets.only(left: 35,right: 40, top: 40),
                          child: FittedBox(
                            child:   FloatingActionButton(
                              backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                              heroTag: 'ratesBtn',
                              hoverColor: const Color.fromARGB(255, 200, 0, 0),
                              onPressed: () {
                                onLaunchUrl(liveRatesUrl);
                              },
                              child: const Column(
                                  children: [
                                    Icon(Icons.ssid_chart, color: Colors.red,size: 40),
                                    Text("See Exchange rates",style: TextStyle(
                                      color: Colors.pinkAccent,
                                      fontSize: 5,
                                    ),)
                                  ]
                              ),
                            ),
                          )
                      ),
                      Container(
                          height: 200, width: 200,
                          margin: const EdgeInsets.only(left: 35, top: 40),
                          child: FittedBox(
                            child:   FloatingActionButton(
                              backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                              heroTag: 'articlesBtn',
                              hoverColor: const Color.fromARGB(255, 200, 200, 0),
                              onPressed: () {
                                ranUrl();
                              },
                              child: const Column(
                                  children: [
                                    Icon(Icons.art_track_rounded, color: Colors.yellowAccent ,size: 40),
                                    Text("See articles on currency and stock trends",textAlign: TextAlign.center, style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 4
                                    ),)
                                  ]
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [  Container(
                        height: 200, width: 200,
                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/5, right: 40, top: 25),
                        child: FittedBox(
                          child:   FloatingActionButton(
                            backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                            heroTag: 'historyBtn',
                            hoverColor: const Color.fromARGB(255, 30, 30, 0),
                            onPressed: () {
                              onLaunchUrl(pastRatesUrl);
                            },
                            child: const Column(
                                children: [
                                  Icon(Icons.calendar_month_outlined, color: Colors.brown ,size: 40),
                                  Text("Past exchange rate trends",textAlign: TextAlign.center, style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 4
                                  ),)
                                ]
                            ),
                          ),
                        )
                    ),
                      Container(
                          height: 200, width: 200,
                          margin: const EdgeInsets.only(left: 35, right: 40, top: 25),
                          child: FittedBox(
                            child:   FloatingActionButton(
                              backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                              heroTag: 'listBtn',
                              hoverColor: const Color.fromARGB(255, 0, 0, 200),
                              onPressed: () {
                                showList();
                              },
                              child: const Column(
                                  children: [
                                    Icon(Icons.library_books_sharp, color: Colors.lightBlue ,size: 40),
                                    Text("See the list of supported currencies",textAlign: TextAlign.center,style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 4,
                                    ),)
                                  ]
                              ),
                            ),
                          )
                      ),
                      Container(
                          height: 200, width: 200,
                          margin: const EdgeInsets.only(left: 35, top: 25),
                          child: FittedBox(
                            child:   FloatingActionButton(
                              backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                              heroTag: 'helpBtn',
                              hoverColor: Colors.blueGrey,
                              onPressed: () {
                                navigatorKey.currentState?.pushNamed('/questions',arguments: widget.userData);
                              },
                              child: const Column(
                                  children: [
                                    Icon(Icons.question_answer_outlined, color:  Colors.grey,size: 40),
                                    Text("Contact Us",style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 5,
                                    ),)
                                  ]
                              ),
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            );
          }
      )

  );

  }

}



class DrawerSideBar extends StatelessWidget{

  @override
  Widget build(BuildContext context) => Drawer(
    child: Container(
      color: Colors.white70,
      child: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  Divider(color: Colors.green,),
                  const SizedBox(height: 24,),

                  SizedBox(height: 24),
                  buildMenuItem(
                      context: context,
                      text: "Account info",
                      icon: Icons.account_circle,
                      onTap: () {

                      }),
                  SizedBox(height: 16),
                  buildMenuItem(
                      context: context,
                      text: "Notification settings",
                      icon: Icons.notifications,
                      onTap: () {

                      }),
                  SizedBox(height: 16),
                  buildMenuItem(
                      context: context,
                      text: "help",
                      icon: Icons.question_mark,
                      onTap: () {
                        showDialog(context: context, builder: (BuildContext dialogContext){
                          return AlertDialog(title: Text("Help"),
                            content: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text("""
                                CurrenSee allows users to perform various financial actions.
                                Each option leads to a different page with it's own instructions, that show how to convert, see rates, etc according to it's text.
                                The white text at the end of the bar at the top allows users to select a default currency
                                Try pressing it or other buttons on the home page to see further instructions for each action             Enjoy!
                              """),
                            ),);
                        });
                      }),
                  SizedBox(height: 16),
                  buildMenuItem(
                      context: context,
                      text: "quit",
                      icon: Icons.exit_to_app,
                      onTap: () {
                        onQuit(context);
                      }),

                  const SizedBox(height: 24,),
                  Divider(color: Colors.green,),
                  const SizedBox(height: 24,),
                ],
              )
          )
        ],
      ),
    ),
  );

  Widget buildMenuItem({required BuildContext context, required String text, required IconData icon, required GestureTapCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon,color: Colors.green,),
        title: Text(text, style: TextStyle(fontSize: 20, color: Colors.green),),
        onTap: onTap,
      ),
    );
  }

  void onQuit(BuildContext context) {
    showDialog(context: context,
        builder: (BuildContext build){
          return AlertDialog(
            title: Text("Do you really want to Logout and exit?"),
            actions: <Widget>[
              TextButton(onPressed:(){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Landing()));
              }, child: Text("Yes",style: TextStyle(color: Colors.red),)),
              TextButton(onPressed:(){
                 Navigator.of(context).pop(false);
              }, child: Text("No",style: TextStyle(color: Colors.green),))
            ],
          );
        });

  }


}
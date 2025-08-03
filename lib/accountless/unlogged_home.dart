import 'dart:math';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'no_account.dart';

class UnloggedHome extends StatefulWidget {
  const UnloggedHome({super.key});

  @override
  State<UnloggedHome> createState() => _HomeState();
}

class _HomeState extends State<UnloggedHome>{

  final Uri url = Uri.parse('https://www.reuters.com/markets/currencies/');
  final Uri url2 = Uri.parse('https://www.fxstreet.com/news');
  final Uri url3 = Uri.parse('https://www.forex.com/en/news-and-analysis/');
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
   });
 }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body : Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/backgroundthree.jpg"),
                  fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                title: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 270),
                      child: Image.asset('assets/images/logo.jpg',width: 50,height: 50,fit: BoxFit.cover, ),
                    ),
                    const Text("Welcome to CurenSee",style: TextStyle(color: Colors.lime),textAlign: TextAlign.center,),
                  ],
                ),
                centerTitle: false,
                actions: <Widget>[
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NoAccount()));
                  }, icon: const Icon(Icons.currency_pound),hoverColor: Colors.green,),
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NoAccount()));
                  }, icon: const Icon(Icons.notifications),hoverColor: Colors.green),
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NoAccount()));
                  }, icon: const Icon(Icons.account_circle_rounded),hoverColor: Colors.green),
                ],
              ),
              Row(
                children: [
                  Container(
                      height: 200, width: 200,
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/7.5,right: 40, top: 40),
                      child: FittedBox(
                        child:   FloatingActionButton(
                          backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                          heroTag: 'convertBtn',
                          hoverColor: const Color.fromRGBO(0, 50, 0, 1),
                          onPressed: () {
                            navigatorKey.currentState?.pushNamed('/convert2');
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NoAccount()));
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
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/7.5, right: 40, top: 25),
                    child: FittedBox(
                      child:   FloatingActionButton(
                        backgroundColor: const Color.fromRGBO(0, 150, 0, 0.3),
                        heroTag: 'historyBtn',
                        hoverColor: const Color.fromARGB(255, 30, 30, 0),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NoAccount()));
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
                          onPressed: () {},
                          child: const Column(
                              children: [
                                Icon(Icons.question_answer_outlined, color:  Colors.grey,size: 40),
                                Text("Help and Feedback",style: TextStyle(
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
        )

    );
  }


}
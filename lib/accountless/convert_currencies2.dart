import 'dart:convert';

import 'package:curen_see/features/number_step_button.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ConvertCurrencies2 extends StatefulWidget{


  const ConvertCurrencies2({super.key});

  @override
  State<ConvertCurrencies2> createState() => _ConvertState();
}

class _ConvertState extends State<ConvertCurrencies2>{

   Currency? currency1;
   Currency? currency2;
   late int amount;
   String _result = "Result";

   Timer? timer;

   @override
   void initState(){
     super.initState();
     timer = Timer.periodic(Duration(seconds: 2), (Timer timer)=> checkResult());
   }

   @override
   void dispose(){
     timer?.cancel();
     super.dispose();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose the amount and click the icon in the centre to convert",style: TextStyle(
          color: Colors.deepOrangeAccent
        ),),
        centerTitle: true,
        backgroundColor: Colors.white10,
      ),
      body:
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/5, top: 100),
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/backgroundfour.jpeg"),
                fit: BoxFit.cover)
        ),
        child: Row(
          children: [
          Column(
            children: [
             NumericStepButton(onChanged: (value){
               amount = value;
               convert();
             }, symbol: symbolChange1()),

              SizedBox(
                width: 100,
                height: 135,
              ),
              ElevatedButton(onPressed: () {
                showCurrencyPicker(
                    context: context, onSelect: (Currency currency) {
                    currency1 = currency;
                });
              }, child: Text(chooseBaseCurrency()),),
            ],
          ),
            Column(
              children: [
                SizedBox(
                  width: 200,
                  height: MediaQuery.of(context).size.height/3,
                  child: IconButton(onPressed: (){
                    convert();
                  },
                      icon: Icon(Icons.compare_arrows_sharp, size: 70, color: Colors.deepOrangeAccent,)),
                ),
              ],
            ),

            Column(
              children: [
                SizedBox(
                  width:  300,
                  height: 100,
                  child: Text("${symbolChange2()} ${_result.toString()}", style: TextStyle(
                    fontSize: 70,
                    color: Colors.white
                  ),)
                ),
                SizedBox(
                  width: 100,
                  height: 140,
                ),
                ElevatedButton(onPressed: () {
                  showCurrencyPicker(
                      context: context, onSelect: (Currency currency) {
                      currency2 = currency;
                  });
                }, child: Text(chooseTargetCurrency()),)
              ],
            )
          ],
        ),

      ),
    );
  }

  String symbolChange1(){
    if(currency1 == null){
      return "";
    }else{
      return currency1!.symbol;
    }
  }

   String symbolChange2(){
     if(currency2 == null){
       return "";
     }else{
       return currency2!.symbol;
     }
   }

  String chooseBaseCurrency() {
    if (currency1 == null) {
      return "Choose currency to convert from";
    } else {
      return "Converting from: ${currency1!.code} (Tap to change)";
    }

  }
  String chooseTargetCurrency() {
    if (currency2 == null) {
      return "Choose currency to convert to";
    } else {
      return "Converting to: ${currency2!.code} (Tap to change)";
    }
  }

    Future<String> convert() async {
      String base = currency1!.code;
      String target = currency2!.code;
      var url = Uri.parse("https://hexarate.paikama.co/api/rates/latest/$base?target=$target");
      var response = await http.get(url);

    if(response.statusCode != 200) {
     return "Check credentials";
    }else{
      var jsonData = json.decode(response.body);
      var data = jsonData['data'];
      double rate = data['mid'];
      double result = amount*rate;
      _result = "$result";
      return result.toString();
    }

    }

  void checkResult() {
     if(_result == "Result" && amount == 0){
       return;
     }else{
       setState(() {});
     }
  }

  }


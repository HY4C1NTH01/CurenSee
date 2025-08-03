import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../features/number_step_button.dart';
import 'dart:async';

class ConvertCurrencies extends StatefulWidget{

  final dynamic userData;

  const ConvertCurrencies({super.key,required this.userData});

  @override
  State<ConvertCurrencies> createState() => _ConvertState();
}

class _ConvertState extends State<ConvertCurrencies> {
  late String username;
  late String password;
  late String email;
  late String phone;
  late String baseCurrency;

  Currency? currency1;
  Currency? currency2;
  int amount = 1;
  String _result = "Result";

  Timer? timer;

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 2), (Timer timer)=> checkResult());
    super.initState();
    updateUI(widget.userData);
  }

  void updateUI(dynamic userData) {
    setState(() {
      username = userData['username'].toString();
      baseCurrency = userData['baseCurrency'].toString();
      phone = userData['phone'].toString();
      password = userData['password'].toString();
      email = userData['email'].toString();
    });
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
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8, top: 100),
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
                    child: Text("${symbolChange2()} $_result", style: TextStyle(
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

  String chooseBaseCurrency() {
    if (currency1 != null) {
      return "Base currency: ${currency1!.code} (Tap to change)";
    } else {
      return "Default base: $baseCurrency";
    }

  }
  String chooseTargetCurrency() {
    if (currency2 != null) {
      return "Converting to: ${currency2!.code} (Tap to change)";
    } else {
      return "Select currency to convert to";
    }
  }

  String symbolChange1(){
    if(currency1 == null){
      return  baseCurrency;
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

  String chooseBase(){
    if(currency1 == null){
      return baseCurrency;
    }else{
      return currency1!.code;
    }
  }

  String chooseTarget(){
    if(currency2 == null){
      return "USD";
    }else{
      return currency2!.code;
    }
  }

  Future<String> convert() async {
    String base = chooseBase();
    String target = currency2!.code;
    var url = Uri.parse("https://hexarate.paikama.co/api/rates/latest/$base?target=$target");
    var response = await http.get(url);

    if(response.statusCode != 200) {
      _result = "Check credentials";
      return _result;
    }else{
      var jsonData = json.decode(response.body);
      var data = jsonData['data'];
      double rate = data['mid'];
      double result = amount*rate;
      _result = "$result";
      return _result;
    }

  }

  void checkResult() {
    if(_result == "Result" || amount == 0){
      return;
    }else{
      setState(() {});
    }
  }
}

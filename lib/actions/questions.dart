import 'package:curen_see/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../home.dart';

class Questions extends StatefulWidget{

  final dynamic userData;

  const Questions({super.key, required this.userData});

  @override
  State<Questions> createState() => _QuestionState();
}

late String username;
String? email2;

String message = "";
final _formKey = GlobalKey<FormState>();

class _QuestionState extends State<Questions> {
  @override
  void initState(){
    super.initState();
    updateUI(widget.userData);
  }
  void updateUI(dynamic userData) {
    setState(() {
      username = userData['username'].toString();
      email2 = userData['email'];
    });
  }

  Email email = Email(
      body: message,
      subject: "CurrenSee Feedback",
      cc: [?email2],
      recipients: ["okpetaofure@gmail.com"],
      isHTML: false
  );

  void sendEmail() async{
    if(email.body.length<100 || email.body.length>500){
      await FlutterEmailSender.send(email);
      showDialog(context: context, builder: (BuildContext dialogContext){
        return AlertDialog(title: Text("Successful"), content: Text("Email sent to developer"),);
      });
    }else{
      showDialog(context: context, builder: (BuildContext dialogContext){
        return AlertDialog(title: Text("invalid message"), content: Text("Email is too short or long"),);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
          child: Column(
        children: [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Enter your message here',
                  labelText: 'Help and feedback',
                  prefixIcon: Icon(Icons.help_center_sharp),
                  errorStyle: TextStyle(fontSize: 18.0),
                  contentPadding: EdgeInsets.all(50),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  )
              ),
              validator: MultiValidator(
                  [RequiredValidator(errorText: "Message is empty"),
                    LengthRangeValidator(min: 100, max: 600, errorText: "Message is too large or small"),
                  ]
              ).call,
              onChanged: (String value){
                message = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: SizedBox(height: 100, width: 200,
             child: FloatingActionButton(onPressed: () async{
              try{
                sendEmail();
              }on Exception catch(e){
                showDialog(context: context, builder: (BuildContext dialogContext){
                  return AlertDialog(title: Text("Unexpected error ${e.hashCode}"), content: Text("Email is incorrect"),);
                });
              }
              Navigator.pop(context);
            },backgroundColor: Colors.green,
    hoverColor: Colors.lightGreenAccent,
    child: const Text("Send message",style: TextStyle(color: Colors.black45,fontSize:30))
    ),
          )
          )
        ],
      )),
    );
  }

}
import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'Home.dart';


class ConnexionPage extends StatefulWidget {
  ConnexionPage({Key key}) : super(key: key);

  @override
  _ConnexionPage createState() => _ConnexionPage();
}

class _ConnexionPage extends State<ConnexionPage>{

  final _formKey = GlobalKey<FormState>();
  Key _key;
  Dio dio;
  List<String> user;
  String password;
  String mail;
  User leUser = new User();


  void initState() {
        setState(() {
          dio = Dio();
          dio.options.baseUrl = "http://01f8bfabc8fe.ngrok.io/";
        });
        super.initState();
      }

  void _addMail(value){
    setState(() {
          mail = value;
        });
  }

  void _addPass(value){
    setState(() {
          password = value;
        });
  }

  Future<void> _login(token) async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";    
        dio.options.headers['Authorization'] = "Basic "+token; 
      });
      Response reponse = await  dio.post("/signIn");
      Map<String, dynamic> payload = Jwt.parseJwt(reponse.data);
      User use = new User();
      print(reponse.data.toString());
      use.mail = payload['user']['mail'];
      use.first_name = payload['user']['firstname'];
      use.name = payload['user']['name'];

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: use, tokenJWT: reponse.data,),),
      );

      if(use.mail == payload['user']['mail']){
        print("oui");
      }else{
        print("non");
      }
    }catch(e){
      print(e);
    }
  }

  Widget _showForm(){
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
        children : [
          SizedBox(height: 100,),
          Text("Connexion",style:  TextStyle(fontSize: 50, fontWeight: FontWeight.bold ,color: Colors.lightBlue),),
          Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            width: 300,
              child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail),
                      hintText: "Saisir votre email",
                      labelText: 'Email',
                    ),
                    validator: (value){
                        if(value.isEmpty){
                          return 'Veuillez saisir votre email';
                        }
                          return null;
                        },
                    onSaved: (value) => _addMail(value),
                  ),
            alignment: Alignment(0, -0.5),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            width: 300,
            child: TextFormField(
              obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.public),
                      hintText: "Saisir votre password",
                      labelText: 'Password',
                    ),
                    validator: (value){
                        if(value.isEmpty){
                          return 'Veuillez saisir votre password';
                        }
                          return null;
                        },
                    onSaved: (value) => _addPass(value),
                  ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: ElevatedButton(
              key: _key,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue), ),
              child: Text('Connexion',style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              onPressed: () {
                  if(_formKey.currentState.validate()){  
                    _formKey.currentState.save();

                    String token = base64Encode(utf8.encode(mail + ":" + password));
                    _login(token);
                      _formKey.currentState.reset();
                  }
              }
              ),
          )
        ],
        )
        )    
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text("Connexion"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          _showForm()
        ]),
        ),
    );
  }

}
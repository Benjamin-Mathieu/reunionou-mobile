import 'package:flutter/material.dart';
import '../models/User.dart';
import 'package:dio/dio.dart';
import 'Connexion.dart';


class InscriptionPage extends StatefulWidget {
  InscriptionPage({Key key}) : super(key: key);

  @override
  _InscriptionPage createState() => _InscriptionPage();
}



class _InscriptionPage extends State<InscriptionPage>{
  //variable de la page inscription
  final _formKey = GlobalKey<FormState>();
  Key _key;
  Dio dio;
  List<String> user;
  String password;
  String password2;
  String name, firstname;
  String mail;
  User leUser = new User();
  //fonction chargement de la page
  void initState() {
        setState(() {
          dio = Dio();
          dio.options.baseUrl = "http://e485d2a325e6.ngrok.io/";
        });
        super.initState();
      }
  // début des fonctions de save des input txt
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

  void _addPass2(value){
  setState(() {
        password2 = value;
      });
  }

  void _addName(value){
  setState(() {
        name = value;
      });
  }

  void _addFirstName(value){
  setState(() {
        firstname = value;
      });
  }
  //fonction qui call l'api pour créer le user
  Future<void> _signUp() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";     
      });
      Response reponse = await  dio.post("/signUp", data: {"mail" : mail, "name" : name, "firstname" : firstname, "password" : password});

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ConnexionPage(),),
      );
    }catch(e){
      print(e);
    }
  }
  //fonction qui construit le form
  Widget _showForm(){
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
        children : [
          SizedBox(height: 100,),
          Text("Inscription",style:  TextStyle(fontSize: 50, fontWeight: FontWeight.bold ,color: Colors.lightBlue),),
          Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            width: 300,
              child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.supervised_user_circle_rounded),
                      hintText: "Saisir votre nom",
                      labelText: 'Name',
                    ),
                    validator: (value){
                        if(value.isEmpty){
                          return 'Veuillez saisir votre nom';
                        }
                          return null;
                        },
                    onSaved: (value) => _addName(value),
                  ),
            alignment: Alignment(0, -0.5),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            width: 300,
              child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.supervised_user_circle_rounded),
                      hintText: "Saisir votre prénom",
                      labelText: 'firstname',
                    ),
                    validator: (value){
                        if(value.isEmpty){
                          return 'Veuillez saisir votre prénom';
                        }
                          return null;
                        },
                    onSaved: (value) => _addFirstName(value),
                  ),
            alignment: Alignment(0, -0.5),
          ),
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
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            width: 300,
            child: TextFormField(
              obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.security),
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
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            width: 300,
            child: TextFormField(
              obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.security),
                      hintText: "Saisir encore votre password",
                      labelText: 'Password',
                    ),
                    validator: (value){
                        if(value.isEmpty){
                          return 'Veuillez saisir votre password';
                        }
                          return null;
                        },
                    onSaved: (value) => _addPass2(value),
                  ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: ElevatedButton(
              key: _key,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue), ),
              child: Text('Inscription',style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              onPressed: () {
                  if(_formKey.currentState.validate() && password == password2){  
                      _formKey.currentState.save();
                      _signUp();
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
        title: Text("Inscription"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          _showForm()
        ]),
        ),
    );

  }

}
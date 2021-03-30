import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/User.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'Home.dart';
import 'Inscription.dart';


class ConnexionPage extends StatefulWidget {
  ConnexionPage({Key key}) : super(key: key);

  @override
  _ConnexionPage createState() => _ConnexionPage();
}

class _ConnexionPage extends State<ConnexionPage>{

  //variable de la page connexion
  final _formKey = GlobalKey<FormState>();
  Key _key;
  Dio dio;
  List<String> user;
  String password;
  String mail;
  User leUser = new User();

  void initState() { //fonction qui s'execute au chargement de la page
    setState(() {
      dio = Dio();
      dio.options.baseUrl = "http://e485d2a325e6.ngrok.io/";
    });
    super.initState();
  }

  //début des fonctions qui permet de save les infos des inputs txt

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
  // fin des fonctions

  // popup qui s'affiche quand il y a une erreur lors de la connexion
  void _showErrorDialog(){
    Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });
    AlertDialog alert = AlertDialog(
      title: Text("Erreur - Connexion"),
      content: Text("Veuillez saisir le bon mail et/ou mot de passe"),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );   
  }

  //Fonction qui permet de connecter le user
  Future<void> _login(token) async{
    try{
      setState(() {
        //mise en place des headers
        dio.options.headers['Origin'] = "ok ";    
        dio.options.headers['Authorization'] = "Basic "+token; 
      });
      Response reponse = await  dio.post("/signIn");
      Map<String, dynamic> payload = Jwt.parseJwt(reponse.data);
      User use = new User();
      use.mail = payload['user']['mail'];
      use.first_name = payload['user']['firstname'];
      use.name = payload['user']['name'];
      //passage à la page home
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: use, tokenJWT: reponse.data,),),
      );

    }catch(e){
      _showErrorDialog();
      print(e);
    }
  }


  //_showFirm permet d'qfficher le formulaire de connexion
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
            padding: EdgeInsets.fromLTRB(0, 40, 0, 30),
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
          _showForm(),
          Text("Vous n'avez pas de compte ?"),
          ElevatedButton(
            onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => InscriptionPage(),),);} , 
            child: Text("Inscription"))
        ]),
        ),
    );
  }

}
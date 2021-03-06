import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import '../pages/unEvent.dart';
import 'package:dio/dio.dart';

class AddParticipant extends StatefulWidget {
  AddParticipant({Key key, this.connected, this.userCo, this.tokenJWT, this.event}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  Events event;
  @override
  _AddParticipant createState() => _AddParticipant();
}

class _AddParticipant extends State<AddParticipant>{
  //variable de la page
  final _formKey = GlobalKey<FormState>();
  Key _key;
  String _mail;
  Dio dio;
  //chargement de la page
  void initState() {
    setState(() {
      dio = Dio();
      dio.options.baseUrl = "http://272da97b3386.ngrok.io/";
    });
    super.initState();
  }
  //fonction qui save le input txt
  void _addMail(value){
    setState(() {
          _mail = value;
        });
  }
  //affiche une popup si l'api retourne une erreur
  void _showErrorDialog(){
    Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });
    AlertDialog alert = AlertDialog(
      title: Text("Erreur - Ajout participant"),
      content: Text("Veuillez saisir l'adresse mail d'un membre existant"),
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
  //call l'api pour ajouter un participant a l'event
  Future<void> _addParticipants() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";    
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
      });
      Response response = await  dio.post("/events/"+widget.event.id.toString() + "/participants", data: {"mail" : _mail});
    }catch(e){
      print(e);
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context){
  
    return Card(
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail),
                      hintText: "Saisir l'adresse mail",
                      labelText: 'Mail',
                    ),
                    validator: (value){
                        if(value.isEmpty){
                          return "Veuillez saisir l/'mail";
                        }
                          return null;
                        },
                    onSaved: (value) => _addMail(value),
                  ),
            ),
            Container(
              width: 50,
              child: ElevatedButton(
              key: _key,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue), ),
              child: Icon(Icons.add),
              onPressed: () {
                  if(_formKey.currentState.validate()){  
                    _formKey.currentState.save();
                    _addParticipants();
                    _formKey.currentState.reset();
                  }
              }
              ),
            ),
          ],
        )
      )
    );

  }

}
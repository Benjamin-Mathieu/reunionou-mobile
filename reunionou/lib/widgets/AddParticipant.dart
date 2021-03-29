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

  final _formKey = GlobalKey<FormState>();
  Key _key;
  String _mail;
  Dio dio;

    void initState() {
      setState(() {
        dio = Dio();
        dio.options.baseUrl = "http://01f8bfabc8fe.ngrok.io/";
      });
      super.initState();
    }

    void _addMail(value){
      setState(() {
            _mail = value;
          });
    }


    Future<void> _addParticipants() async{
      try{

        setState(() {
          dio.options.headers['Origin'] = "ok ";    
          dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
        });
        Response response = await  dio.post("/events/"+widget.event.id.toString() + "/participants", data: {"mail" : _mail});
      }catch(e){
        print(e);
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
                    print("oui");
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
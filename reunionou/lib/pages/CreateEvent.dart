import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import 'Connexion.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class CreateEvent extends StatefulWidget {
  CreateEvent({Key key, this.connected, this.userCo, this.tokenJWT}) : super(key: key);
  bool connected;
  User userCo;
  Map<String, dynamic> tokenJWT;
  @override
  _CreateEvent createState() => _CreateEvent();
}

class _CreateEvent extends State<CreateEvent>{

    final _formKey = GlobalKey<FormState>();
    Key _key;
    bool _public = false;
    bool _main_event = false;
    

    Widget _showForm(){
      final format = DateFormat("yyyy-MM-dd HH:mm");
      return Form(
        key: _formKey,
        child: Center(
          child: Column(
          children : [
            SizedBox(height: 100,),
            Text("Créer son Event",style:  TextStyle(fontSize: 50, fontWeight: FontWeight.bold ,color: Colors.lightBlue),),
            Container(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
              width: 300,
                child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.title),
                        hintText: "Saisir le titre",
                        labelText: 'Titre',
                      ),
                      validator: (value){
                          if(value.isEmpty){
                            return 'Veuillez saisir votre Titre';
                          }
                            return null;
                          },
                      onSaved: (value) => print("ouiouioui"),
                    ),
              alignment: Alignment(0, -0.5),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 300,
              child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.description),
                        hintText: "Saisir la description",
                        labelText: 'Description',
                      ),
                      validator: (value){
                          if(value.isEmpty){
                            return 'Veuillez saisir votre description';
                          }
                            return null;
                          },
                      onSaved: (value) => print("ouiouioui"),
                    ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 300,
              child: DateTimeField(
                decoration: InputDecoration(icon: Icon(Icons.date_range), labelText: 'Date', hintText: "Saisir votre date", ),
                format: format,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              width: 300,
              child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.pin_drop),
                        hintText: "Saisir l'adresse",
                        labelText: 'Adresse',
                      ),
                      validator: (value){
                          if(value.isEmpty){
                            return 'Veuillez saisir votre Adresse';
                          }
                            return null;
                          },
                      onSaved: (value) => print("ouiouioui"),
                    ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              width: 300,
              child: Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    children: [
                      Text("Publique :"),
                      Checkbox(
                        value: _public,
                        onChanged: (value){
                          setState(() {
                            _public = value;              
                          });
                        },
                      ),
                    ],
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Text("Main Event :"),
                      Checkbox(
                        value: _main_event,
                        onChanged: (value){
                          setState(() {
                            _main_event = value;              
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ElevatedButton(
                key: _key,
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue), ),
                child: Text('Créer l\'event',style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                onPressed: () {
                    if(_formKey.currentState.validate()){  
                      _formKey.currentState.save();

                      // String token = base64Encode(utf8.encode(mail + ":" + password));
                      // _login(token);
                      //   _formKey.currentState.reset();
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
          title: Text("Créer un event"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            _showForm()
          ]),
          ),
      );
    }
}
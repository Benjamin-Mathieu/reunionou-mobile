import 'package:flutter/material.dart';
import '../models/User.dart';
import '../models/Events.dart';
import 'Home.dart';
import 'unEvent.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class CreateEvent extends StatefulWidget {
  CreateEvent({Key key, this.connected, this.userCo, this.tokenJWT, this.isEditing, this.eventId}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  bool isEditing;
  Events eventId;
  @override
  _CreateEvent createState() => _CreateEvent();
}

class _CreateEvent extends State<CreateEvent>{

    final _formKey = GlobalKey<FormState>();
    Key _key;
    Dio dio;
    bool _public = false;
    bool _main_event = false;

    String title, desc, adress;
    DateTime date;
    int public, main_event;

    void _addTitle(value){
      setState(() {
        title = value;          
      });
    }
    void _addDesc(value){
      setState(() {
        desc = value;          
      });
    }
    void _addDate(value){ 
      setState(() {
        date = value;
      });
    }
    void _addAdress(value){
      setState(() {
        adress = value;     
      });
    }

    void _showAlertDialogBadAdress(){
      Widget cancelButton = TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          });
      AlertDialog alert = AlertDialog(
        title: Text("Veuillez saisir une adresse valide"),
        content: Text("ou plus précise"),
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

    void _EditOrNot(){
      if(widget.isEditing){
        _Edit();
      }else{
        _Create();
      }
    }

    Future<void> _Create() async{
      try{
        setState(() {
          dio.options.headers['Origin'] = "ok ";    
          dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
        });
        Response response = await  dio.post("/events", data: {"title" : title, "description" : desc, "date" : date.toString(), "adress" : adress, "public" : _public, "main_event" : _main_event});
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT),),
        );
        
      }on DioError catch(e){
        print(e.response.data['error'].toString());
        if(e.response.data['error'].toString() == "Adress need to be more precise or wrong adress"){
          _showAlertDialogBadAdress();
        }
      }
    }


    Future<void> _Edit() async{
      try{
        setState(() {
          dio.options.headers['Origin'] = "ok ";    
          dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
        });
        Response response = await  dio.put("/events/"+widget.eventId.id.toString(), data: {"title" : title, "description" : desc, "date" : date.toString(), "adress" : adress, "public" : _public, "main_event" : _main_event});
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT,),),
        );
        
      }on DioError catch(e){
        print(e.response.data['error'].toString());
        if(e.response.data['error'].toString() == "Adress need to be more precise or wrong adress"){
          _showAlertDialogBadAdress();
        }
      }
    }

    void initState() {
        setState(() {
          dio = Dio();
          dio.options.baseUrl = "http://e485d2a325e6.ngrok.io/";
          
        });
        super.initState();
      }
    String _errorAdress = " ";
    Widget _showForm(){
      final format = DateFormat("yMd").add_Hm();

      return Form(
        key: _formKey,
        child: Center(
          child: Column(
          children : [
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
                      onSaved: (value) => _addTitle(value),
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
                      onSaved: (value) => _addDesc(value),
                    ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 300,
              child: DateTimeField(
                onSaved: (value) => _addDate(value),
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
                      onSaved: (value) => _addAdress(value),
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
                            print(_public);            
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
                             print(_main_event);  
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
              margin:EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: ElevatedButton(
                key: _key,
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue), ),
                child: (!widget.isEditing) ? Text('Créer l\'event',style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),) : Text('Modifier l\'event',style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                onPressed: () {
                    if(_formKey.currentState.validate()){  
                        _formKey.currentState.save();
                        _EditOrNot();
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
          title: (!widget.isEditing) ? Text("Créer un event") : Text("Modifier un event"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 100,),
            (!widget.isEditing) ? Text("Créer son Event",style:  TextStyle(fontSize: 50, fontWeight: FontWeight.bold ,color: Colors.lightBlue),) : Text("Modifier son Event",style:  TextStyle(fontSize: 50, fontWeight: FontWeight.bold ,color: Colors.lightBlue), textAlign: TextAlign.center,) ,
            Container(
              margin:EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Colors.blue[800]), top: BorderSide(width: 1, color: Colors.blue[800]), left: BorderSide(width: 1, color: Colors.blue[800]), right: BorderSide(width: 1, color: Colors.blue[800])),
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                  Colors.blue[300],
                  Colors.blue[100],
                ]
                ),
              ),
              child: _showForm(),
            ),
          ]),
          ),
      );
    }
}
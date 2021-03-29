import 'package:flutter/material.dart';
import '../models/User.dart';
import 'Home.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class CreateEvent extends StatefulWidget {
  CreateEvent({Key key, this.connected, this.userCo, this.tokenJWT}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
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
      _testAdress();
      setState(() {
        adress = value;     
      });
      
    }

    Future<void> _Create() async{
      try{
        setState(() {
          dio.options.headers['Origin'] = "ok ";    
          dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
        });
        DateTime ladate =DateTime(2020, 02, 27, 20, 50);
        print(ladate.toString());
        Response response = await  dio.post("/events", data: {"title" : title, "description" : desc, "date" : date.toString(), "adress" : adress, "public" : _public, "main_event" : _main_event});
        print(response.data);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT),),
        );
        
      }catch(e){
        print(e);
      }
    }

    void initState() {
        setState(() {
          dio = Dio();
          dio.options.baseUrl = "http://01f8bfabc8fe.ngrok.io/";
          
        });
        super.initState();
      }
    String _errorAdress = " ";
    bool _good;

    Future<bool> _testAdress() async{
      try{
        setState(() {
        dio.options.headers['Origin'] = "ok ";       
        });
        Response response = await dio.get("https://api-adresse.data.gouv.fr/search/?q="+adress);
        print(response.data['features'][0]);
        int y = 0;
        for (var item in response.data['features']) {
          y++;
        }
        if(y == 0){
          setState(() {
            _good = false;
          });
        }else{
          if(y > 1){
            setState(() {
              _good = false;     
            });
          }else{
            setState(() {
              _good = true;         
            });
          }
        }
      }catch(e){
        print(e);
      }

    }
    

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
                child: Text('Créer l\'event',style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                onPressed: () {
                    if(_formKey.currentState.validate()){  
                      
                      if(_good == false){
                        setState(() {
                          _errorAdress = "Veuillez saisir une bonne adresse (soit votre adresse n'est pas en France soit elle n'est pas assez précise";
                          _formKey.currentState.reset();                      
                        });
                      }else{
                        _formKey.currentState.save();
                        _formKey.currentState.reset();
                        _Create();
                      }
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
          title: Text("Créer un event"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 100,),
            Text("Créer son Event",style:  TextStyle(fontSize: 50, fontWeight: FontWeight.bold ,color: Colors.lightBlue),),
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
            Text(_errorAdress),
          ]),
          ),
      );
    }
}
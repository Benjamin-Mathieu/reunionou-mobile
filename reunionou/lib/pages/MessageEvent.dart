import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import '../models/Message.dart';
import '../pages/unEvent.dart';
import 'package:dio/dio.dart';

class MessageEvent extends StatefulWidget {
  MessageEvent({Key key, this.connected, this.userCo, this.tokenJWT, this.event}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  Events event;
  @override
  _MessageEvent createState() => _MessageEvent();
}

class _MessageEvent extends State<MessageEvent>{
  final _formKey = GlobalKey<FormState>();
  Key _key;
  String _text;
  Dio dio;
  List<Message> _ListMsg;
  
  void initState() {
    setState(() {
      dio = Dio();
      dio.options.baseUrl = "http://01f8bfabc8fe.ngrok.io/";
      _getMsg();
    });
    super.initState();
  }

  void _addTxt(value){
      setState(() {
            _text = value;
          });
  }

  Future<void> _addParticipants() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";    
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
      });
      Response response = await  dio.post("/events/"+widget.event.id.toString() + "/messages", data: {"text" : _text});
    }catch(e){
      print(e);
    }
  }


  Future<void> _getMsg() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";    
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
      });
      Response response = await  dio.get("/events/"+widget.event.id.toString() + "/messages");
      print(response.data);
    }catch(e){
      print(e);
    }
    }




  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text("Reunionou"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Text("oui"),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50.0,
          child: Center(
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                      icon: Icon(Icons.message_rounded, color: Colors.red[700]),
                      hintText: "Saisir le message",
                      labelText: 'Message',
                      ),
                      validator: (value){
                          if(value.isEmpty){
                            return "Veuillez saisir le message";
                          }
                            return null;
                          },
                      onSaved: (value) => _addTxt(value),
                      )
                  ),
                  Container(
                    width: 50,
                    child: ElevatedButton(
                    key: _key,
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red[700]), ),
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
                  )
                ],)
            )

          ),
        
        ),
      )
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
    
  }

}
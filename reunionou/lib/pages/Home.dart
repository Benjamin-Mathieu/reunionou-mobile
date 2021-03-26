
import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import 'Connexion.dart';
import 'CreateEvent.dart';
import 'package:dio/dio.dart';
import '../widgets/ShowEventDetail.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.connected, this.userCo, this.tokenJWT}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Events> _ListEvents;
   List<Events> _ListPrivateEvents;
  Dio dio;
  Events _currentEvent;
  bool _showDetail = false;
  bool _showPrivate = false;


  void initState() {
    setState(() {
      _ListEvents = [];
      _ListPrivateEvents = [];
      print(widget.connected);
      print(widget.userCo.mail);
      dio = Dio();
      dio.options.baseUrl = "http://54866077bb23.ngrok.io";
      _getEvents();
      _getPrivateEvents();
      //print(_ListEvents[0]);
    });
    super.initState();
  }

  void _logOut(){
    setState(() {
        widget.connected = false;
        widget.userCo = new User();
    });
  }

  void _showDetailEvent(event){
    setState(() {
      _showDetail = true;
      _currentEvent = event;       
    });
  }



  Future<void> _getEvents() async{
    try{
      setState(() {
       dio.options.headers['Origin'] = "ok ";       
      });
      Response response = await dio.get("/events");
      setState(() {
              var oui = response.data;
              for (var unEvent in oui['events']){
                User creator = new User();
                creator.id = unEvent['event']['creator']['id'];
                creator.name = unEvent['event']['creator']['name'];
                creator.first_name = unEvent['event']['creator']['firstname'];
                creator.mail = unEvent['event']['creator']['mail'];
                _ListEvents.insert(0, Events.fromJson(unEvent['event'], creator)); 
              }
            });
    }catch(e){
      print(e);
    }
  }

  Future<void> _getPrivateEvents() async{
    try{
      setState(() {
       dio.options.headers['Origin'] = "ok ";
       dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;       
      });
      Response response = await dio.get("/privateEvents");
      setState(() {
              var oui = response.data;
              for (var unEvent in oui['events']){
                User creator = new User();
                creator.id = unEvent['event']['creator']['id'];
                creator.name = unEvent['event']['creator']['name'];
                creator.first_name = unEvent['event']['creator']['firstname'];
                creator.mail = unEvent['event']['creator']['mail'];
                _ListPrivateEvents.insert(0, Events.fromJson(unEvent['event'], creator)); 
                
              }
              print(_ListPrivateEvents);
            });
    }catch(e){
      print(e);
    }
  }

  void _ShowPrivateEvent(){
    if(!_showPrivate){
      _getEvents();
    }else{  
      _getPrivateEvents();
    }
  }

  bool _activePublic = false;
  bool _activePrivate = false;

  Color _isActivePublic(){
    if(_activePrivate == false && _activePublic == true){
      return Colors.blue[900];
    }else{
      return Colors.blue;
    }
  }

  Color _isActivePrivate(){
    if(_activePrivate == true && _activePublic == false){
      return Colors.blue[900];
    }else{
      return Colors.blue;
    }
  }

  Widget _choicePublicPrivate(){
    return Card(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(95, 0, 50, 0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(_isActivePublic(),)),
                onPressed: (){setState(() {_showPrivate = false; _activePublic = true; _activePrivate = false;});},
                child:Text("Publique"),
              ),
          ),  
          Container(
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(_isActivePrivate(),)),
              onPressed: (){setState(() {_showPrivate = true; _activePublic = false; _activePrivate = true;});},
              child: Text("Privée"),
          ),
          )
          
        ],
      ),
    );
  }

  Widget showEvents(){
    if(_showPrivate == false){
      return ListView.builder(
        itemCount: _ListEvents.length,
        itemBuilder: (BuildContext context, int index) {
          final Events event = _ListEvents[index];

          return Card(
            child: ListTile(
              onTap: () => _showDetailEvent(event),
              onLongPress: () => print("oui"),
              title: Text(
                event.title,
              ),
            ),
            color: Colors.grey[50]        
          );
        },
      );
    }else{
      return ListView.builder(
        itemCount: _ListPrivateEvents.length,
        itemBuilder: (BuildContext context, int index) {
          final Events event = _ListPrivateEvents[index];

          return Card(
            child: ListTile(
              onTap: () => _showDetailEvent(event),
              onLongPress: () => print("oui"),
              title: Text(
                event.title,
              ),
            ),
            color: Colors.grey[50]        
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reunionou"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          (widget.connected) ? _choicePublicPrivate() : Container(),
          (_showDetail) ? ShowEventDetail(connected: widget.connected, userCo: widget.userCo, tokenJWT: widget.tokenJWT, event: _currentEvent,) : Container(),
          Expanded(
            child: (_ListEvents.length > 0) ? showEvents() : Center(child: Text("Pas d'event public"),),
            )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          height: 50.0,
          child: Center(
            child: (widget.connected) ? Container(padding: EdgeInsets.fromLTRB(30, 0, 0, 0),child: Row(children: [TextButton(child: Text("Déconnexion", style: TextStyle(color: Colors.white, fontSize: 20),), onPressed: (){_logOut();}, autofocus: false, clipBehavior: Clip.none,),Expanded(child: TextButton(child: Text("Créer Events", style: TextStyle(color: Colors.white, fontSize: 20),), onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateEvent(connected: widget.connected, userCo: widget.userCo,tokenJWT: widget.tokenJWT,),),);}, autofocus: false, clipBehavior: Clip.none,)) ],),)  : IconButton(icon: Icon(Icons.login, semanticLabel: "Connexion",) ,iconSize: 40,color: Colors.white,onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnexionPage(),),);})                                                                                                                                                                                                                                                                                                                                                                                                                                             
            ),
          ),
        
        ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
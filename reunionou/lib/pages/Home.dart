
import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import 'Connexion.dart';
import 'CreateEvent.dart';
import 'package:dio/dio.dart';

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
  DateTime laDate = DateTime.utc(2000, 02, 27);
  Dio dio;

  void initState() {
    setState(() {
      _ListEvents = [];
      print(widget.connected);
      print(widget.userCo.mail);
      dio = Dio();
      dio.options.baseUrl = "http://b047c809b01d.ngrok.io";
      _getEvents();
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

  Widget showEvents(){
    return ListView.builder(
      itemCount: _ListEvents.length,
      itemBuilder: (BuildContext context, int index) {
        final Events event = _ListEvents[index];

        return Card(
          child: ListTile(
            onTap: () => print("oui"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reunionou"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
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
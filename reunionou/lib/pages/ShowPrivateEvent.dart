
import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import 'Connexion.dart';
import 'CreateEvent.dart';
import 'package:dio/dio.dart';
import '../widgets/ShowEventDetail.dart';
import 'Home.dart';

class ShowPrivateEvent extends StatefulWidget {
  ShowPrivateEvent({Key key, this.connected, this.userCo, this.tokenJWT}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  @override
  _ShowPrivateEvent createState() => _ShowPrivateEvent();
}

class _ShowPrivateEvent extends State<ShowPrivateEvent>{

  List<Events> _ListPrivateEvents;
  Dio dio;
  Events _currentEvent;
  bool _showDetail = false;
  bool _showPrivate = false;


  void initState() {
    setState(() {
      _ListPrivateEvents = [];
      print(widget.connected);
      print(widget.userCo.mail);
      dio = Dio();
      dio.options.baseUrl = "http://e485d2a325e6.ngrok.io/";
      _getPrivateEvents();
      //print(_ListEvents[0]);
    });
    super.initState();
  }

  void _logOut(){
    setState(() {
        widget.connected = false;
        widget.userCo = new User();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT),),);
    });
  }

  void _showDetailEvent(event){
    setState(() {
      _showDetail = true;
      _currentEvent = event;       
    });
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
                print(unEvent);
                _ListPrivateEvents.insert(0, Events.fromJson(unEvent['event'], creator)); 
                
              }
              print(_ListPrivateEvents);
            });
    }catch(e){
      print(e);
    }
  }

  Widget showPrivateEvent(){
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

  Widget _choicePublic(){
    return Card(
      child: Center(
          child:Container(
            child: ElevatedButton(
              onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT),),);},
              child: Text("Evénement Publique"),
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context){
      return Scaffold(
      appBar: AppBar(
        title: Text("Reunionou"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          (widget.connected) ? _choicePublic() : Container(),
          (_showDetail) ? ShowEventDetail(connected: widget.connected, userCo: widget.userCo, tokenJWT: widget.tokenJWT, event: _currentEvent,) : Container(),
          Expanded(
            child: (_ListPrivateEvents.length > 0) ? showPrivateEvent() : Center(child: Text("ouioui"),),
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


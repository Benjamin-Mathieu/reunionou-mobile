import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'Home.dart';
import '../widgets/AddParticipant.dart';
import 'MessageEvent.dart';


class UnEvent extends StatefulWidget {
  UnEvent({Key key, this.connected, this.userCo, this.tokenJWT, this.event}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  Events event;
  @override
  _UnEvent createState() => _UnEvent();
}

class _UnEvent extends State<UnEvent>{

  Dio dio;
  double _lat;
  double _long;
  bool _isLoaded = false;
  bool _hisCreator = false;
  List<User> _ListParticipent;
  bool _addParticipant;

  void initState() {
    setState(() {
      _addParticipant = false;
      _ListParticipent = [];
      print(widget.connected);
      print(widget.userCo.mail);
      dio = Dio();
      _getCoord();
      _CreatorIsHere();
      _getParticipent();
    });
    super.initState();
  }

  void _showAlertDialog(){
    Widget okButton = TextButton(
      child: Text("Oui !"),
      onPressed: () {
        Navigator.of(context).pop();
        _DeleteEvent();
      }
    );

    Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    AlertDialog alert = AlertDialog(
      title: Text("Supprimer l'event ?"),
      content: Text("êtes-vous sûr ?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );   
  }

    Future<void> _DeleteEvent() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;        
      });
      Response response = await dio.delete("http://01f8bfabc8fe.ngrok.io/events/"+widget.event.id.toString());

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT),),
      );

    }catch(e){
      print(e);
    }
  }

  Future<void> _getCoord() async{
    try{
      setState(() {
       dio.options.headers['Origin'] = "ok ";       
      });
      Response response = await dio.get("https://api-adresse.data.gouv.fr/search/?q="+widget.event.adress);

      setState(() {
        _lat = response.data['features'][0]['geometry']['coordinates'][0];
        _long = response.data['features'][0]['geometry']['coordinates'][1];
        print(_lat);
        print(_long);
        _isLoaded = true;
      });

    }catch(e){
      print(e);
    }
  }

  Widget LoadMap(){
    return Container(
              height: 400,
              child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(_long, _lat,),
                      zoom: 16.00,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 60.0,
                            height: 60.0,
                            point: LatLng(_long, _lat),
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            builder: (ctx) => 
                            Container(
                              child: Image(
                                image: AssetImage("assets/images/logo-reunionou.png"),                          
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            );
  }

  void _CreatorIsHere(){
    if(widget.userCo.mail == widget.event.leUser.mail){
      _hisCreator = true;
    }else{
      _hisCreator = false;
    }
  }

  Map _userpresent = new Map();

  bool _isPresentorNot(User user){
    if(_userpresent[user.id] == 1){
      return true;
    }else{
      return false;
    }

  }

  Widget showParticipent(){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _ListParticipent.length,
        itemBuilder: (BuildContext context, int index) {
          final User user = _ListParticipent[index];
          if(!_isPresentorNot(user)){
            return Card(
              child: ListTile(
                onTap: () => print(_isPresentorNot(user)),
                onLongPress: () => print("oui"),
                title: Text(
                  user.name + ' ' + user.first_name
                ),
              ),
              color: Colors.red[300]        
            );
          }else{
            return Card(
              child: ListTile(
                onTap: () => print(_isPresentorNot(user)),
                onLongPress: () => print("oui"),
                title: Text(
                  user.name + ' ' + user.first_name
                ),
              ),
              color: Colors.green[300],
            );
          } 
          
        },
      );
  }

  Future<void> _getParticipent() async{
    try{
      setState(() {
       dio.options.headers['Origin'] = "ok ";
       dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;       
      });
      Response response = await dio.get("http://01f8bfabc8fe.ngrok.io/events/"+widget.event.id.toString());
      setState(() {
              var oui = response.data;
              for (var unEvent in oui['event']['participants']){
                User participent = new User();
                participent.name = unEvent['name'];
                participent.first_name = unEvent['firstname'];
                participent.id = unEvent['pivot']['user_id'];
                _ListParticipent.insert(0, participent);
                _userpresent[unEvent['pivot']['user_id']] = unEvent['pivot']['present'];  
              }

              
            });
    }catch(e){
      print(e);
    }
  }

  Future<void> _IParticipe(bool lareponse) async{
    try{
      setState(() {
          dio.options.headers['Origin'] = "ok ";    
          dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;
        });
      Response response = await dio.put("http://680643535015.ngrok.io/events/"+widget.event.id.toString()+"/response", data: {"response" : lareponse}, queryParameters: {"token" : widget.event.token});
    }catch(e){
      print(e);
    }
  }

  Widget _btnParticipe(){
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(100, 0, 70, 0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green,)),
                onPressed: () {_IParticipe(true); setState((){_ListParticipent = []; _getParticipent();});},
                child: Icon(Icons.verified_outlined),
              ),
          ),

          Container(
            child: ElevatedButton(
                  onPressed: () {_IParticipe(false); setState((){_ListParticipent = []; _getParticipent();});},
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red,)),
                  child: Icon(Icons.close),
                ),
          )
        ],
        ));
  }

  void _afficherForm(){
    if(_addParticipant == false){
      setState(() {
              _addParticipant = true;
            });
    }else{
      setState(() {
              _addParticipant = false;
            });
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[700],
          title: Text("Un evenement"),
        ),
        body: SingleChildScrollView(
            child: Column(
            children: [
              Text(widget.event.title, style: TextStyle(color: Colors.blue, fontSize: 30,), textAlign: TextAlign.center,),
              Container(
                padding:EdgeInsets.all(40),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    Colors.red[400],
                    Colors.orange[700],
                  ]
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      child:Image.network('https://avatars.dicebear.com/v2/bottts/'+widget.event.leUser.mail+'.png', width: 100,),
                      ),
                    
                    Container(
                      child: Column(
                        children: [
                          Text(widget.event.leUser.first_name + " " + widget.event.leUser.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text(widget.event.leUser.mail, style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold)),
                        ],),
                    )
                  ],),
              ),
              Container(
                height: 140,
                padding:EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                ),
                child: Column(
                  children: [
                    Text(widget.event.description, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                    Text(widget.event.adress, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                    Text(widget.event.date_event, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,), 
                    SizedBox(height: 20,), 
                  ],
                ),
              ),
   
              
              (!_isLoaded) ? Container() : LoadMap(),

              (!_hisCreator) ? Container() : ElevatedButton(onPressed: (){_showAlertDialog();}, child: Icon(Icons.delete)), 
              SizedBox(height: 35,), 
              Text("Liste des participents", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,), 

              Container( width: 300, child: (_ListParticipent.length > 0) ? showParticipent() : Center(child: Text("Pas de participent"),),), 

              (widget.userCo.mail != widget.event.leUser.mail) ? Text("Voulez-vous participer ?", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,) : Text("Voulez vous ajouter un participent?", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              (_addParticipant) ? AddParticipant(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT, event: widget.event) : Container(),
              (widget.userCo.mail != widget.event.leUser.mail) ? _btnParticipe() : ElevatedButton(onPressed: (){_afficherForm();}, child: Text("Ajouter un participent"),),
              
            ],)
          ),
          floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.red[700],
                splashColor: Colors.red[100],
                onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageEvent(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT, event: widget.event,),),);},
                tooltip: 'Increment',
                child: Icon(Icons.message_rounded,),
              ),
      );

  }

}
import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'Home.dart';


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

  void initState() {
    setState(() {
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

    Future<void> _DeleteEvent() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;        
      });
      Response response = await dio.delete("http://54866077bb23.ngrok.io/events/"+widget.event.id.toString());

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
              height: 300,
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
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(_long, _lat),
                            builder: (ctx) => 
                            Container(
                              child: Icon(
                                Icons.add_location,
                                size : 30.0,
                                color: Colors.red[700],
                                ),
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

  Widget showParticipent(){
    return ListView.builder(
        itemCount: _ListParticipent.length,
        itemBuilder: (BuildContext context, int index) {
          final User user = _ListParticipent[index];

          return Card(
            child: ListTile(
              onTap: () => print('oui'),
              onLongPress: () => print("oui"),
              title: Text(
                user.name + ' ' + user.first_name
              ),
            ),
            color: Colors.grey[50]        
          );
        },
      );
  }

  Future<void> _getParticipent() async{
    try{
      setState(() {
       dio.options.headers['Origin'] = "ok ";
       dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;       
      });
      Response response = await dio.get("http://54866077bb23.ngrok.io/events/"+widget.event.id.toString());
      setState(() {
              var oui = response.data;
              for (var unEvent in oui['event']['participants']){
                User participent = new User();
                participent.name = unEvent['name'];
                participent.first_name = unEvent['firstname'];
                _ListParticipent.insert(0, participent);   
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
      Response response = await dio.put("http://54866077bb23.ngrok.io/events/"+widget.event.id.toString()+"/response", data: {"response" : lareponse});
    }catch(e){
      print(e);
    }
  }

  Widget _btnParticipe(){
    return Expanded(
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

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          title: Text("Un evenement"),
        ),
        body: Column(
          children: [
            Text(widget.event.title, style: TextStyle(color: Colors.blue, fontSize: 30,), textAlign: TextAlign.center,),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child:Image.network('https://avatars.dicebear.com/v2/bottts/'+widget.event.leUser.mail+'.png', width: 50,),
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
            Text(widget.event.description, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            Text(widget.event.adress, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Text(widget.event.date_event, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,), 
            SizedBox(height: 20,),    
            
            (!_isLoaded) ? Container() : LoadMap(),

            (!_hisCreator) ? Container() : ElevatedButton(onPressed: (){_DeleteEvent();}, child: Icon(Icons.delete)), 
            SizedBox(height: 35,), 
            Text("Liste des participents", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,), 
            Expanded(
              child: (_ListParticipent.length > 0) ? showParticipent() : Center(child: Text("Pas de participent"),),
            ),
            Text("Voulez-vous participer ?", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,), 
            _btnParticipe(),
          ],)
      );

  }

}
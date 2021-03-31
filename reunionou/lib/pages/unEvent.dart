import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'Home.dart';
import 'CreateEvent.dart';
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

  //variable de la page
  Dio dio;
  double _lat;
  double _long;
  bool _isLoaded = false;
  bool _hisCreator = false;
  List<User> _ListParticipent;
  bool _addParticipant;
  List<String> _ListMeteo;
  
  //fonction qui s'execute au chargement de la page
  void initState() {
    setState(() {
        _ListMeteo = [];
        _addParticipant = false;
        _ListParticipent = [];
        print(widget.connected);
        print(widget.userCo.mail);
        dio = Dio();
        _getCoord();
        _CreatorIsHere();
        _getParticipent();
        getMeteo();
    });
    super.initState();
  }
  //dialog pour supprimer un event 
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
  //fonction qui utilise la route delete pour delete l'event
  Future<void> _DeleteEvent() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;        
      });
      Response response = await dio.delete("http://272da97b3386.ngrok.io/events/"+widget.event.id.toString());

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyHomePage(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT),),
      );

    }catch(e){
      print(e);
    }
  }
  //Fonction qui call l'api du gouv pour récupérer la lat et long de l'adresse
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
  // Fonction qui permet de charger la map quand elle a les coordonnées
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
  // vérifie si c'est le créateur de l'event qui consulte la page
  void _CreatorIsHere(){
    if(widget.userCo.mail == widget.event.leUser.mail){
      _hisCreator = true;
    }else{
      _hisCreator = false;
    }
  }
  //map qui permet de stocket les user et savoir si ils sont présent ou non à l'event
  Map _userpresent = new Map();
  //fonction qui vérifie que le user passé en param est bien la  
  bool _isPresentorNot(User user){
    if(_userpresent[user.id] == 1){
      return true;
    }else{
      return false;
    }
  }
  //affiche la liste des participants et change la couleur si il participe ou non
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
  //récupère les participants au chargement de la page
  Future<void> _getParticipent() async{
    try{
      setState(() {
       dio.options.headers['Origin'] = "ok ";
       dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;       
      });
      Response response = await dio.get("http://272da97b3386.ngrok.io/events/"+widget.event.id.toString());
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
  //utilise l'api pour confirmer la présence ou non à l'event
  Future<void> _IParticipe(bool lareponse) async{
    try{
      setState(() {
          dio.options.headers['Origin'] = "ok ";    
          dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;
        });
      Response response = await dio.put("http://272da97b3386.ngrok.io/events/"+widget.event.id.toString()+"/response", data: {"response" : lareponse}, queryParameters: {"token" : widget.event.token});
    }catch(e){
      print(e);
    }
  }
  //affiche les btn qui permet de choisir si on vient ou pas
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
  // affiche les formulaires 
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
  //affche les infos de la méteo
  Widget _showMeteoData(){
    return Container(
      width: 300.0,
      height: 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        reverse: true,
        itemCount: _ListMeteo.length,
        itemBuilder: (BuildContext context, int index){
          final String meteo = _ListMeteo[index];
          return Container(
            child: ListTile(
              title: Text(meteo),
            ),
          );
        },
      ),
    );
  }
  //ouvre la popup qui permet de voir la méteo
  void _showDialogMeteo(){
    getMeteo();
    Widget cancelButton = TextButton(
        child: Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        });

    AlertDialog alert = AlertDialog(
      title: Text("Metéo le jour de L'event"),
      content: (_ListMeteo.length > 0) ?
               _showMeteoData() :
               Container(child: Text("Pas de encore de météo pour cette date"),),
               
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
  //call l'api méteo par rapport a la lat et long de l'adresse de levent
  Future<void> getMeteo() async{
    try{
      
      Response response = await dio.get("https://www.infoclimat.fr/public-api/gfs/json?_ll="+_long.toString()+","+_lat.toString()+"&_auth=ABpWQQJ8UHIHKldgAXcDKlgwUGUKfAIlCnYLaFw5A34DaFIzUjJTNQdpUSwPIFBmVXgBYgkyCDhUP1AoWigEZQBqVjoCaVA3B2hXMgEuAyhYdlAxCioCJQphC2VcLwNhA2VSPlIvUzAHalE3DyFQZlVnAWAJKQgvVDZQMVo2BGAAYlYzAmFQMwdqVz0BLgMoWG1QMAozAjkKawtoXDYDYAM1UjVSMlM3B25ROw8hUG1VbgFlCTIIMlQ1UD9aNQR4AHxWSwISUC8HKFd3AWQDcVh2UGUKawJu&_c=4c6aef79e116a131371e20fa8c857af0");
      print(response.data[widget.event.date_event.substring(0, 10)+" 05:00:00"]['temperature']['2m']);
      String _temp1 = " 8H : "+ (response.data[widget.event.date_event.substring(0, 10)+" 08:00:00"]['temperature']['2m'] - 273.15).toString().substring(0, 4)+ " °C";
      String _temp2 = " 11H : "+ (response.data[widget.event.date_event.substring(0, 10)+" 11:00:00"]['temperature']['2m'] - 273.15).toString().substring(0, 4)+ " °C";
      String _temp3 = " 14H : "+ (response.data[widget.event.date_event.substring(0, 10)+" 14:00:00"]['temperature']['2m'] - 273.15).toString().substring(0, 4)+ " °C";
      String _temp4 = " 17H : "+ (response.data[widget.event.date_event.substring(0, 10)+" 17:00:00"]['temperature']['2m'] - 273.15).toString().substring(0, 4)+ " °C";
      String _temp5 = " 20H : "+ (response.data[widget.event.date_event.substring(0, 10)+" 20:00:00"]['temperature']['2m'] - 273.15).toString().substring(0, 4)+ " °C";
      String _temp6 = " 23H : "+ (response.data[widget.event.date_event.substring(0, 10)+" 23:00:00"]['temperature']['2m'] - 273.15).toString().substring(0, 4)+ " °C";
      print(_temp6);
      setState(() {
        if(response.data[widget.event.date_event.substring(0, 10)+" 05:00:00"]['temperature']['2m'] != null){

          _ListMeteo.insert(0, _temp1);
          _ListMeteo.insert(0, _temp2);
          _ListMeteo.insert(0, _temp3);
          _ListMeteo.insert(0, _temp4);
          _ListMeteo.insert(0, _temp5);
          _ListMeteo.insert(0, _temp6);  

        }
         
      });
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[700],
          title: Text("Un event"),
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
              //si la carte est chargé il faut l'afficher
              (!_isLoaded) ? Container() : LoadMap(),
              // si c'est le créator qui consulte son event affiche des fonctionnalitées 
              (!_hisCreator) ? Container(child: IconButton(icon: Icon(Icons.cloud, color: Colors.blue, size: 40), onPressed: (){ _showDialogMeteo();}),) : Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ElevatedButton(onPressed: (){_showAlertDialog();}, child: Icon(Icons.delete)),IconButton(icon: Icon(Icons.cloud, color: Colors.blue, size: 40), onPressed: (){_showDialogMeteo();}), ElevatedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateEvent(connected: widget.connected, userCo: widget.userCo,tokenJWT: widget.tokenJWT, isEditing: true, eventId: widget.event,),),);}, child: Icon(Icons.edit))],),),
              SizedBox(height: 35,), 
              Text("Liste des participants", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,), 

              Container( width: 300, child: (_ListParticipent.length > 0) ? showParticipent() : Center(child: Text("Pas de participant"),),), 
              
              (widget.userCo.mail != widget.event.leUser.mail) ? Text("Voulez-vous participer ?", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,) : Text("Voulez vous ajouter un participant?", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              (_addParticipant) ? AddParticipant(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT, event: widget.event) : Container(),
              (widget.userCo.mail != widget.event.leUser.mail) ? _btnParticipe() : ElevatedButton(onPressed: (){_afficherForm();}, child: Text("Ajouter un participant"),),
              
            ],)
          ),
          floatingActionButton: Visibility(
                visible: widget.connected, 
                child:FloatingActionButton(
                  backgroundColor: Colors.red[700],
                  splashColor: Colors.red[100],
                  onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageEvent(connected: true, userCo: widget.userCo, tokenJWT: widget.tokenJWT, event: widget.event,),),);},
                  tooltip: 'Message',
                  child: Icon(Icons.message_rounded,),
              ),),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      );

  }

}
import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import '../pages/unEvent.dart';

class ShowEventDetail extends StatefulWidget {
  ShowEventDetail({Key key, this.connected, this.userCo, this.tokenJWT, this.event}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  Events event;
  @override
  _ShowEventDetail createState() => _ShowEventDetail();
}

class _ShowEventDetail extends State<ShowEventDetail>{

  @override
  Widget build(BuildContext context){
    return Card(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01,
        left: MediaQuery.of(context).size.width * 0.01,
        right: MediaQuery.of(context).size.width * 0.01,
      ),
      child: Row(
        children: [
          Container(
            child: Column(
              children: [
                Text("Evenement crée par "+widget.event.leUser.mail, textAlign: TextAlign.left,),
                Text(widget.event.title, textAlign: TextAlign.left),
                Text("Adresse "+widget.event.adress, textAlign: TextAlign.left),
              ],),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.add_box, color: Colors.blue),
              onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => UnEvent(connected: widget.connected, userCo: widget.userCo,tokenJWT: widget.tokenJWT, event: widget.event, ),),);}
              )
            )
        ],
      ),
    );
  }

}
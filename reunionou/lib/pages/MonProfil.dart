import 'package:flutter/material.dart';
import '../models/User.dart';


class MonProfil extends StatefulWidget {
  MonProfil({Key key, this.connected, this.userCo, this.tokenJWT}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  @override
  _MonProfil createState() => _MonProfil();
}

class _MonProfil extends State<MonProfil>{
    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[700],
          title: Text("Mon profil"),
        ),
        body: Column(
            children: [
              Container(
                margin:EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                    Colors.red[300],
                    Colors.orange[400],
                  ]
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Center(child: Image.network('https://avatars.dicebear.com/v2/bottts/'+widget.userCo.mail+'.png', width: 200,),)
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                      child: Column(
                        children: [
                          Text(widget.userCo.first_name + " " + widget.userCo.name, style: TextStyle(fontSize: 30, color: Colors.white), textAlign: TextAlign.center,),
                          SizedBox(height: 30,),
                          Text(widget.userCo.mail, style: TextStyle(fontSize: 30, color: Colors.white), textAlign: TextAlign.center)
                        ],),
                    ),
                    
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
                  color: Colors.grey[50],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Row(children: [
                            Text("Events Créés : ", style: TextStyle(fontSize: 18),),
                            Text("5", style: TextStyle(color: Colors.red),),
                      ],),
                    ),

                    Container(
                      child: Row(
                        children: [
                          Text("Participation aux Events : ", style: TextStyle(fontSize: 18),),
                          Text("50", style: TextStyle(color: Colors.red[900]),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/logo-reunionou.png'),
                      width: 200,
                      )
                  ],
                )
              )
              
            ],
          ),
      );
    }
}
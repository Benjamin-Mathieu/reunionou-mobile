import 'package:flutter/material.dart';
import '../models/Events.dart';

class ConnexionPage extends StatefulWidget {
  ConnexionPage({Key key}) : super(key: key);

  @override
  _ConnexionPage createState() => _ConnexionPage();
}

class _ConnexionPage extends State<ConnexionPage>{

  final _formKey = GlobalKey<FormState>();
  Key _key;

  Widget _showForm(){
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
        children : [
          SizedBox(height: 100,),
          Text("Connexion",style:  TextStyle(fontSize: 50, fontWeight: FontWeight.bold ,color: Colors.lightBlue),),
          Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            width: 300,
              child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail),
                      hintText: "Saisir votre email",
                      labelText: 'Email',
                    ),
                  ),
            alignment: Alignment(0, -0.5),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            width: 300,
            child: TextFormField(
              obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.public),
                      hintText: "Saisir votre password",
                      labelText: 'Password',
                    ),
                  ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: ElevatedButton(
              key: _key,
              onPressed: (){print('test');},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue), ),
              child: Text('Connexion',style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
        title: Text("Connexion"),
      ),
      body: Column(
        children: [
          _showForm()
        ],
        ),
    );
  }

}
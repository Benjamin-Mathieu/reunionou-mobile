import 'package:flutter/material.dart';
import '../models/Events.dart';
import 'Connexion.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Events> _ListEvents;
  DateTime laDate = DateTime.utc(2000, 02, 27);

  void initState() {
    Events unEvent = new Events("Anniv chez alex", "Tous chez alex", laDate, 1, "gregergger", "5 rue cronstadt Nancy", false, true, 2);
    setState(() {
      //_ListEvents.insert(0, unEvent);
    });
    super.initState();
  }

  Widget showEvents(){
    return ListView.builder(
      itemCount: _ListEvents.length,
      itemBuilder: (BuildContext context, int index) {
        final Events event = _ListEvents[index];
        return Card(
          child: ListTile(
            title: Text(
              event.title,
            ),
          ),
          color: Colors.red[700],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reunionou"),
      ),
      body: Column(
        children: [
          //showEvents(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          height: 50.0,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.login),
                iconSize: 40,
                color: Colors.white,
                onPressed: (){
                  Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ConnexionPage(),),
                  );           
                }
                )
            ],
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
import 'package:flutter/material.dart';
import '../models/Events.dart';
import '../models/User.dart';
import '../models/Message.dart';
import '../pages/unEvent.dart';
import 'package:dio/dio.dart';

class MessageEvent extends StatefulWidget {
  MessageEvent({Key key, this.connected, this.userCo, this.tokenJWT, this.event}) : super(key: key);
  bool connected;
  User userCo;
  String tokenJWT;
  Events event;
  @override
  _MessageEvent createState() => _MessageEvent();
}

class _MessageEvent extends State<MessageEvent>{
  //variable de la page message
  final _formKey = GlobalKey<FormState>();
  final _formKeyEditMess = GlobalKey<FormState>();
  final _contentControllerEditMess = TextEditingController();
  Key _key;
  Key _keytst;
  String _text;
  Dio dio;
  List<Message> _ListMsg;
  //fonction charge page
  void initState() {
    setState(() {
      _ListMsg = [];
      dio = Dio();
      dio.options.baseUrl = "http://docketu.iutnc.univ-lorraine.fr:14000/";
      _getMsg();
    });
    super.initState();
  }
  //fonction qui save le input txt
  void _addTxt(value){
      setState(() {
            _text = value;
          });
  }
  //fonction qui add le msg a lapi
  Future<void> _addMsg() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";    
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
      });
      Response response = await  dio.post("/events/"+widget.event.id.toString() + "/messages", data: {"text" : _text});
      _ListMsg = [];
      _getMsg();
    }catch(e){
      print(e);
    }
  }
  //récupère la list des messages
  Future<void> _getMsg() async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";    
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
      });
      Response response = await  dio.get("/events/"+widget.event.id.toString() + "/messages");
      for (var msg in response.data['messages']){

        Message aMsg = new Message();
        aMsg.id = msg['message']['id'];
        aMsg.text = msg['message']['text'];
        aMsg.user_id = msg['message']['user_id'];
        User creator = new User();
        creator.name = msg['user']['name'];
        creator.first_name = msg['user']['firstname'];
        creator.mail = msg['user']['mail'];
        aMsg.creator = creator;
        setState(() {
           _ListMsg.insert(0, aMsg);       
        });
        
      }
      print(response.data);
    }catch(e){
      print(e);
    }
  }
  //regarde si le message est celui de la personne co ou non
  void _HisMsg(Message msg){
    if(widget.userCo.mail == msg.creator.mail){
      _showAlertDialogDelMsg(msg);
    }else{
      _showAlertDialog();
    }
  }
  //demande la confirmation pour supp un message
  void _showAlertDialogDelMsg(msg){
    Widget okButton = TextButton(
      child: Text("Oui !"),
      onPressed: () {
        Navigator.of(context).pop();
        _DeleteMsg(msg);
      }
    );

    Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    AlertDialog alert = AlertDialog(
      title: Text("Supprimer le message ?"),
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
  //show message erreur
  void _showAlertDialog(){

    Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    AlertDialog alert = AlertDialog(
      title: Text("Vous ne pouvez pas supprimer"),
      content: Text("un message qui n'est pas le vôtre"),
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
  //modifier un message dans la bdd
  Future<void> _editMsg(Message msg) async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";    
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT; 
      });
      Response response = await  dio.put("/events/"+widget.event.id.toString() + "/messages/"+msg.id.toString(), data: {"text" : _text});
      _ListMsg = [];
      _getMsg();
    }catch(e){
      print(e);
    }
  }
  //Affiche la popup avec le form pour modifier un message
  void _showAlertDialogEditMsg(Message msg){
    _contentControllerEditMess.text = msg.text;
    Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    AlertDialog alert = AlertDialog(
      title: Text("Modifier le message"),
      content: Container(
              child: Form(
                key: _formKeyEditMess,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _contentControllerEditMess,
                        decoration: InputDecoration(
                        icon: Icon(Icons.message_rounded, color: Colors.red[700]),
                        hintText: "Saisir le message",
                        labelText: 'Message',
                        ),
                        validator: (value){
                            if(value.isEmpty){
                              return "Veuillez saisir le message";
                            }
                              return null;
                            },
                        onSaved: (value) => _addTxt(value),
                      )
                    ),
                    Container(
                      child: ElevatedButton(
                        key: _keytst,
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red[900]), ),
                        child: Icon(Icons.add),
                        onPressed: () {
                          if(_formKeyEditMess.currentState.validate()){  
                            _formKeyEditMess.currentState.save();
                            _editMsg(msg);
                            
                            _formKeyEditMess.currentState.reset();
                            Navigator.of(context).pop();
                          }
                          
                        }
                    ),
                    )
                  ],
                )
              ),),
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
  //supprime un message (call a lapi)
  Future<void> _DeleteMsg(msg) async{
    try{
      setState(() {
        dio.options.headers['Origin'] = "ok ";
        dio.options.headers['Authorization'] = "Bearer "+widget.tokenJWT;        
      });
      Response response = await dio.delete("http://272da97b3386.ngrok.io/events/"+widget.event.id.toString()+"/messages/"+msg.id.toString());
      _ListMsg = [];
      _getMsg();
    }catch(e){
      print(e);
    }
  }
  //affiche les messages regarde si le message est celui de la personne co si oui affiche le message a droite
  Widget showMsg(){
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      itemCount: _ListMsg.length,
      itemBuilder: (BuildContext context, int index){
        final Message msg = _ListMsg[index];
        if(msg.creator.name == widget.userCo.name && msg.creator.first_name == widget.userCo.first_name){
          return Container(  
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),),
            child: ListTile(
              leading: Container(width: 100, child: Row(children: [IconButton(icon: Icon(Icons.delete), onPressed: (){_HisMsg(msg);}), IconButton(icon: Icon(Icons.edit), onPressed: (){_showAlertDialogEditMsg(msg);})],),),
              trailing: Image.network('https://avatars.dicebear.com/v2/bottts/'+widget.userCo.mail+'.png'),
              onTap: (){print('oui');},
              onLongPress: (){_HisMsg(msg);},
              title: Text(msg.creator.first_name+ "."+msg.creator.name.substring(0,1), textAlign: TextAlign.right, style: TextStyle(color: Colors.red[400])),
              subtitle: Text(msg.text, textAlign: TextAlign.right, style: TextStyle(color: Colors.red[300]),),
              
            ),
          );
        }else{
          return Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),),
            child: ListTile(
              leading: Image.network('https://avatars.dicebear.com/v2/bottts/'+msg.creator.mail+'.png'),
              onTap: (){_HisMsg(msg);},
              onLongPress: (){_HisMsg(msg);},
              title: Text(msg.creator.first_name+ "."+msg.creator.name.substring(0,1) + " : "),
              subtitle: Text(msg.text),
            ),
          );
        }
        
      }
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text("Reunionou - Messages"),
      ),
      body: Center(
        child: (_ListMsg.length > 0) ? showMsg() : Text("pas de messages"),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50.0,
          child: SingleChildScrollView(  
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                      icon: Icon(Icons.message_rounded, color: Colors.red[700]),
                      hintText: "Saisir le message",
                      labelText: 'Message',
                      ),
                      validator: (value){
                          if(value.isEmpty){
                            return "Veuillez saisir le message";
                          }
                            return null;
                          },
                      onSaved: (value) => _addTxt(value),
                      )
                  ),
                  Container(
                    width: 50,
                    child: ElevatedButton(
                    key: _key,
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red[900]), ),
                    child: Icon(Icons.add),
                    onPressed: () {
                        if(_formKey.currentState.validate()){  
                          _formKey.currentState.save();
                          _addMsg();
                          _formKey.currentState.reset();
                        }
                    }
                    ),
                  )
                ],)
            )
          ),
        ),
      )
    );
    
  }

}
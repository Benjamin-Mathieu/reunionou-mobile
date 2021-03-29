import 'User.dart';

class Message{
  String text;
  int id, user_id;
  User creator;


  Message();
  Message.fromJson(Map<String, dynamic> json, User creator, )
    : id = json['id'],
      text = json['text'],
      user_id = json['user_id'],
      creator = creator;


  Map<String, dynamic> toJson() => {
      'id' : id,
      'text' : text,
      'user_id' : user_id,
    };


}
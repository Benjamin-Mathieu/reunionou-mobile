import 'User.dart';

class Events{
  String title, description, token, adress;
  int event_id, user_id;
  int public, main_event;
  String date_event;
  User leUser;

  Events(this.title, this.description, this.date_event, this.leUser, this.token, this.adress, this.public, this.main_event, this.event_id);

  Events.fromJson(Map<String, dynamic> json, User creator)
    : title = json['title'],
      description = json['description'],
      date_event = json['date'],
      leUser = creator,
      token = json['token'],
      adress = json['adress'],
      public = json['public'],
      main_event = json['main_event'],
      event_id = json['event_id'];

  Map<String, dynamic> toJson() => {
      'title' : title,
      'description' : description,
      'date' : date_event,
      'user_id' : user_id,
      'token' : token,
      'adress' : adress,
      'datpublice' : public,
      'main_event' : main_event,
      'event_id' : event_id,
    };


}
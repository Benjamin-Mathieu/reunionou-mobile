class Events{
  String title, description, token, adress;
  int user_id, event_id;
  bool public, main_event;
  DateTime date_event;

  Events(this.title, this.description, this.date_event, this.user_id, this.token, this.adress, this.public, this.main_event, this.event_id);
}
class Task {
  static const String collectionName = 'tasks';
  String id;
  String title;
  String description;
  DateTime datetime;
  bool isDone;

  Task(
      {this.id = '',
      required this.title,
      required this.description,
      required this.datetime,
      this.isDone = false});

////fromFireStore :
  Task.fromJason(Map<String, dynamic> data)
      : this(
          id: data['id'] as String, //m4 lazem casting 3ady
          title: data['title'],
          description: data['description'],
          datetime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
          isDone: data['isDone'] ?? false,
        );

////toFireStore:
//// key = String , Value = Dynamic
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': datetime.millisecondsSinceEpoch,
      'isDone': isDone
    };
  }
}

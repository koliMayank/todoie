import 'package:todo_app/provider/todo_provider.dart';

class TodoItem {
  int? id;
  String title = "";
  String desc = "";
  int status = 0;

  TodoItem(
      {this.id, required this.status, required this.title, required this.desc});

  TodoItem.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    desc = map["desc"];
    status = map["status"];
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> todoItem = <String, dynamic>{};
    todoItem['id'] = id;
    todoItem['title'] = title;
    todoItem['desc'] = desc;
    todoItem['status'] = status;

    return todoItem;
  }

  void updateStatus(int updatedStatus, int id) {
    if (updatedStatus == 1) {
      status = 1;
    } else {
      status = 0;
    }
    LocalDatabaseProvider().updateStatus(id, status);
  }
}

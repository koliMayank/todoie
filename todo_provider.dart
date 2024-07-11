import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_app/models/todo_item_model.dart';

class TodoProvider extends ChangeNotifier {
  final List<TodoItem> _items = [];
  LocalDatabaseProvider provider = LocalDatabaseProvider();

  void getListItems() async {
    try {
      List<TodoItem> lst = await provider.getAllRecords();
      _items.addAll(lst);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  //add item
  void addItem(String name, String desc) {
    var newItem = TodoItem.fromJson({"title": name, "desc": desc, "status": 0});
    provider.insert(newItem);
    _items.add(newItem);
    notifyListeners();
  }

  //delete item
  void removeItem(int index, int id) {
    provider.deleteItem(id);
    _items.removeAt(index);
    notifyListeners();
  }

  //clear item list
  void clearAllItem(List<Object> idList) {
    provider.clearAllItems(idList);
    _items.clear();
  }

  List<TodoItem> get items => _items;
}

class LocalDatabaseProvider {
  String path = "";

  Future<Database> openMyDatabase() async {
    final dbPath = await getDatabasesPath();
    path = "$dbPath/demo.db";
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
create table todolist (
  id integer primary key,
  title text not null,
  desc text not null,
  status integer)
''');
      },
    );
    return database;
  }

  void insert(TodoItem map) async {
    final db = await openMyDatabase();
    try {
      int id = await db.insert(
        'todolist',
        {
          // 'id': map.id,
          'title': map.title,
          'desc': map.desc,
          'status': map.status,
        },
      );
      map.id = id;
    } catch (e) {
      print(e);
    }
  }

  Future<List<TodoItem>> getAllRecords() async {
    final db = await openMyDatabase();
    final rows = await db.query('todolist');
    List<TodoItem> items = [];
    for (var item in rows) {
      items.add(
        TodoItem(
          id: int.parse(item["id"].toString()),
          title: item['title'].toString(),
          desc: item['desc'].toString(),
          status: int.parse(
            item["status"].toString(),
          ),
        ),
      );
    }
    return items;
  }

  void updateStatus(int id, int val) async {
    final db = await openMyDatabase();
    await db.update(
      'todolist',
      {
        'status': val,
      },
      where: 'id = $id',
    );
  }

  void deleteItem(int id) async {
    final db = await openMyDatabase();
    await db.delete(
      'todolist',
      where: 'id = $id',
      // whereArgs: [], to delete multiple selections
    );
  }

  void clearAllItems(List<Object> idList) async {
    final db = await openMyDatabase();
    await db.delete(
      'todolist',
      // where: 'id = $id',
      whereArgs: idList,
    );
  }
}

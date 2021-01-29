import 'package:flutter/material.dart';
import 'package:sqlite/model/todo.dart';
import 'package:sqlite/screens/todo_detail_screen.dart';
import 'package:sqlite/database/dbhelper.dart';

class TodayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodayScreenState();
  }
}

class TodayScreenState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
        body: todoListItems(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Todo(3, ""));
          },
          tooltip: 'Add New Todo',
          child: Icon(Icons.add),
        ));
  }

  todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(this.todos[position].priority),
                radius: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.greenAccent[100],
                  radius: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white, //NetworkImage
                    radius: 9,
                  ), //CircleAvatar
                ), //CircleAvatar
              ),
              title: Text(this.todos[position].title),
              subtitle: Text(this.todos[position].date),
              trailing: Container(
                height: 50,
                width: 5,
                color: getColor(this.todos[position].priority),
              ),
              onTap: () {
                navigateToDetail(this.todos[position]);
              },
            ),
          )),
    );
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));
    if (result == true) {
      getData();
    }
  }

  void getData() {
    final todosFuture = helper.getTodos();
    todosFuture.then((result) => {
          setState(() {
            todos = result;
            count = todos.length;
          })
        });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green[700];
      default:
        return Colors.green;
    }
  }
}

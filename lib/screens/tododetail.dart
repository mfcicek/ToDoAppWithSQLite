import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/model/todo.dart';
import 'package:sqlite/utils/dbhelper.dart';

final List<String> choices = const <String>[menuDelete, menuBack];

const menuDelete = "Delete Todo";
const menuBack = "Back To List";

DbHelper helper = DbHelper();

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() {
    return TodoDetailState(todo);
  }
}

class TodoDetailState extends State {
  Todo todo;

  TodoDetailState(this.todo);

  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";
  final _formDistance = 5.0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descController.text = todo.description;
    dateController.text = todo.date;

    TimeOfDay secilenSaat = TimeOfDay.fromDateTime(DateTime.now());

    var textStyle = Theme.of(context).textTheme.caption;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((e) {
                  return PopupMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: _formDistance,
                      bottom: _formDistance,
                      left: 20.0,
                      right: 20.0),
                  child: TextField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _formDistance,
                      bottom: _formDistance,
                      left: 20.0,
                      right: 20.0),
                  child: TextField(
                      controller: descController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _formDistance,
                      bottom: _formDistance,
                      left: 20.0,
                      right: 20.0),
                  child: TextField(
                      onTap: () async {
                        secilenSaat = await saatSec(context);
                        if (secilenSaat != null) {
                          setState(() {
                            todo.date = secilenSaat.hour.toString() +
                                ":" +
                                secilenSaat.minute.toString();
                          });
                        }
                      },
                      controller: dateController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Saat",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      )),
                ),
                DropdownButton<String>(
                  value: this._priorities[this.todo.priority - 1],
                  items: _priorities.map((String str) {
                    return DropdownMenuItem<String>(
                      value: str,
                      child: Text(str),
                    );
                  }).toList(),
                  onChanged: (String str) {
                    updatePriority(str);
                  },
                ),
                RaisedButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                    textColor: Colors.white,
                    color: Colors.red,
                    child: Text("Add Task"),
                    onPressed: () {
                      save();
                      Navigator.pop(context);
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    )),
              ]),
            )));
  }

  void updatePriority(String value) {
    int priority = 0;
    switch (value) {
      case "High":
        priority = 1;
        break;
      case "Medium":
        priority = 2;
        break;
      case "Low":
        priority = 3;
        break;
      default:
    }
    setState(() {
      this.todo.priority = priority;
    });
  }

  void select(String value) async {
    switch (value) {
      case menuDelete:
        delete();
        break;
      case menuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void delete() async {
    Navigator.pop(context, true);
    if (todo.id == null) {
      return;
    }
    int result;
    result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Delete Todo"),
        content: Text("The Todo has been deleted"),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  void save() {
    todo.title = titleController.text;
    todo.description = descController.text;
    todo.date = dateController.text;

    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
    showAlert(todo.id != null);
  }

  void showAlert(bool isUpdate) {
    AlertDialog alertDialog;
    if (isUpdate) {
      alertDialog = AlertDialog(
        title: Text("Update Todo"),
        content: Text("The Todo has been updated"),
      );
    } else {
      alertDialog = AlertDialog(
        title: Text("Insert Todo"),
        content: Text("The Todo has been inserted"),
      );
    }
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Future<TimeOfDay> saatSec(BuildContext context) {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
}

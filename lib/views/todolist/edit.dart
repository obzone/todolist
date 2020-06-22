import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/viewmodels/list/list.dart';
import 'package:todolist/views/common/segment_control.dart';

class TodoEditView extends StatefulWidget {
  final TodoListViewModel viewModel;
  final TodoModel model;

  TodoEditView({Key key, this.viewModel, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodoEditView(text: model?.name, selectedTodoType: model?.type ?? 'today');
  }
}

class _TodoEditView extends State<TodoEditView> {
  String text;
  String selectedTodoType;

  _TodoEditView({this.text, this.selectedTodoType});

  _onTextFieldchangeText(String text) {
    this.text = text;
  }

  _onSegmentValueChange(dynamic type) {
    this.setState(() {
      this.selectedTodoType = type;
    });
  }

  _onDonePress() async {
    if (widget.model != null) {
      widget.model.name = text;
      widget.model.type = selectedTodoType;
      widget.viewModel.save();
    } else {
      TodoModel model = TodoModel(
        createdTime: DateTime.now(),
        updatedTime: DateTime.now(),
        id: '${DateTime.now().toUtc()}',
        name: text,
        type: selectedTodoType,
      );
      await widget.viewModel.createTodo(model);
      if (selectedTodoType == 'today') {
        await widget.viewModel.addTodayTodo(model);
      }
    }
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: this._onDonePress,
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.radio_button_unchecked),
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none),
                        autofocus: true,
                        controller: TextEditingController(text: text),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onChanged: this._onTextFieldchangeText,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SegmentControlView(
                title: 'deadline:',
                values: ['today', 'week', 'month', 'year'],
                selectedValue: selectedTodoType,
                onValueChange: _onSegmentValueChange,
              ),
            )
          ],
        ),
      ),
    );
  }
}

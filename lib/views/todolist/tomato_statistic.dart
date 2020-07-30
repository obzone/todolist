import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/views/report/todo.dart';

class TomatoStatisticView extends StatefulWidget {
  final TodoModel model;

  TomatoStatisticView({Key key, @required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TomatoStatisticView();
  }
}

class _TomatoStatisticView extends State<TomatoStatisticView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoReportView(
                model: widget.model,
              ),
            ),
          );
        },
        child: Row(
          children: <Widget>[
            ...?widget.model.doHistories?.map(
              (history) => Text(
                '✗ ',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

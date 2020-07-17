import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/todo.dart';

enum deadlineType {
  tag,
  createTime,
  workingTime,
}

class TodoDeadlineView extends StatefulWidget {
  final TodoModel model;

  TodoDeadlineView({Key key, @required this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodoDeadlineView();
  }
}

class _TodoDeadlineView extends State<TodoDeadlineView> {
  int deadlineTypeIndex = 0;

  _totaltime() {
    if (widget.model.doHistories == null || widget.model.doHistories.length == 0) return '00:00';

    int totalTime = 0;
    widget.model.doHistories.forEach((element) {
      if (element.startTime == null || element.endTime == null) return;
      totalTime += (element.endTime.millisecondsSinceEpoch - element.startTime.millisecondsSinceEpoch);
    });

    int hours = (totalTime / (1000 * 60 * 60)).floor();
    int minutes = ((totalTime % (1000 * 60 * 60)) / (1000 * 60)).floor();

    return '${hours < 10 ? '0' : ''}$hours:${minutes < 10 ? '0' : ''}$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.setState(() {
          deadlineTypeIndex = deadlineTypeIndex + 1;
          if (deadlineTypeIndex >= deadlineType.values.length) {
            deadlineTypeIndex = 0;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        color: Theme.of(context).primaryColor,
        child: Text(
          deadlineTypeIndex == 0 ? widget.model.type : deadlineTypeIndex == 1 ? '${DateFormat('yyyy/MM/dd').format(widget.model.createdTime)}' : _totaltime() ?? '',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

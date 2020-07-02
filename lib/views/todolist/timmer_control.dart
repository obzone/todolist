import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/views/todolist/time_selector.dart';

class TimmerControllerView extends StatefulWidget {
  final TodoModel model;
  final Function(int) onStartPress;
  final Function({bool isDone}) onComplete;

  TimmerControllerView({
    Key key,
    @required this.model,
    this.onStartPress,
    this.onComplete,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimmerControllerView();
  }
}

class _TimmerControllerView extends State<TimmerControllerView> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  int selectedTaskDuration;

  List<int> durationItems;

  @override
  void initState() {
    super.initState();

    this.durationItems = [];
    for (var i = 1; i <= 12; i++) {
      durationItems.add(i * 5);
    }

    selectedTaskDuration = widget.model.doing?.totalTime ?? 25 * 60;

    _animationController = AnimationController(duration: Duration(seconds: selectedTaskDuration), vsync: this);
    _animation = Tween<double>(begin: selectedTaskDuration * 10.0, end: 0).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationController.reset();
          widget.onComplete(isDone: true);
        });
      }
    });

    if (widget.model.doing != null && widget.model.doing?.endTime == null) {
      _animationController.value = 1 - (widget.model.doing.surplusSeconds / selectedTaskDuration);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 5),
          minWidth: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return TimeSelectorView(
                  values: durationItems,
                  selectedItem: 4,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      this.selectedTaskDuration = durationItems[index] * 60;
                      _animationController.duration = Duration(seconds: this.selectedTaskDuration);
                      _animation = Tween<double>(begin: selectedTaskDuration * 10.0, end: 0).animate(_animationController);
                    });
                  },
                );
              },
            );
          },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              int minutes = (_animation.value / 600).floor();
              int seconds = (_animation.value % 600 / 10).floor();
              String minuteString = minutes < 10 ? '0$minutes' : '$minutes';
              String secondString = seconds < 10 ? '0$seconds' : '$seconds';
              return Text(
                '$minuteString:$secondString.${(_animation.value % 10).floor()}',
                style: TextStyle(fontSize: 20, fontFamily: 'pingfang', fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              );
            },
          ),
        ),
        MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minWidth: 40,
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() {
              if (_animationController.status == AnimationStatus.forward) {
                _animationController.reset();
                _animationController.value = selectedTaskDuration.toDouble();
                widget.onComplete(isDone: false);
              } else {
                _animationController.forward();
                widget.onStartPress(this.selectedTaskDuration);
              }
            });
          },
          child: Icon(_animationController.status == AnimationStatus.forward ? Icons.stop : Icons.play_arrow, color: Theme.of(context).primaryColor),
        ),
        if (_animationController.status == AnimationStatus.forward)
          MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 40,
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                _animationController.reset();
                _animationController.value = selectedTaskDuration.toDouble();
                widget.onComplete(isDone: true);
              });
            },
            child: Icon(
              Icons.done,
              color: Theme.of(context).primaryColor,
            ),
          ),
      ],
    );
  }
}

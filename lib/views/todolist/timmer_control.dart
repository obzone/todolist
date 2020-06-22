import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';

class TimmerControllerView extends StatefulWidget {
  final TodoModel model;
  final int seconds;
  final Function() onChangeTimePress;
  final Function() onStartPress;
  final Function() onCancelPress;
  final Function() onTimeout;

  TimmerControllerView({Key key, @required this.model, @required this.seconds, this.onChangeTimePress, this.onStartPress, this.onCancelPress, this.onTimeout}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimmerControllerView();
  }
}

class _TimmerControllerView extends State<TimmerControllerView> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: Duration(seconds: widget.seconds), vsync: this);
    _animation = Tween<double>(begin: widget.seconds * 10.0, end: 0).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationController.reset();
          widget.onTimeout();
        });
      } else if (status == AnimationStatus.dismissed) {
        widget.onCancelPress();
      }
    });

    if (widget.model.doHistories != null && widget.model.doHistories.length > 0 && widget.model.doHistories.last.endTime == null) {
      _animationController.value = 1 - (widget.model.doHistories.last.surplusSeconds / widget.seconds);
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
          onPressed: widget.onChangeTimePress,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Text(
                '${(_animation.value / 600).floor()}:${(_animation.value % 600 / 10).floor()}.${(_animation.value % 10).floor()}',
                style: TextStyle(fontSize: 20),
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
                _animationController.value = widget.seconds.toDouble();
                widget.onCancelPress();
              } else {
                _animationController.forward();
                widget.onStartPress();
              }
            });
          },
          child: Icon(_animationController.status == AnimationStatus.forward ? Icons.stop : Icons.play_arrow),
        )
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

class FlipCounterView extends StatefulWidget {
  static double itemHeight = 70;
  static double itemWidth = 100;

  final String currentValue;
  final String nextValue;

  FlipCounterView({
    Key key,
    @required this.currentValue,
    @required this.nextValue,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FlipCounterView();
  }
}

class _FlipCounterView extends State<FlipCounterView> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: pi).animate(controller);

    controller.forward();
  }

  _buildNumberWidget({String value, double fontOffsetY}) {
    return ClipRect(
      child: Container(
        color: Colors.black,
        child: CustomPaint(
          size: Size(FlipCounterView.itemWidth, FlipCounterView.itemHeight),
          painter: NumberPainter(value: value, fontOffsetY: fontOffsetY),
        ),
      ),
    );
  }

  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.currentValue != widget.currentValue)) {
      controller.reset();
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(
        child: Container(
          height: FlipCounterView.itemHeight * 2,
          width: FlipCounterView.itemWidth,
          color: Colors.black,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                children: <Widget>[
                  _buildNumberWidget(value: widget.nextValue),
                  Positioned(
                    top: 70,
                    child: _buildNumberWidget(value: widget.currentValue, fontOffsetY: -FlipCounterView.itemHeight),
                  ),
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: new Matrix4.rotationX(animation.value < (pi / 2) ? animation.value : (pi / 2)),
                    child: _buildNumberWidget(value: widget.currentValue),
                  ),
                  Positioned(
                    top: 70,
                    child: Transform(
                      alignment: Alignment.topCenter,
                      transform: new Matrix4.rotationX(animation.value < (pi / 2) ? (pi / 2) : pi - animation.value),
                      child: _buildNumberWidget(value: widget.nextValue, fontOffsetY: -FlipCounterView.itemHeight),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FlipClockView extends StatefulWidget {
  final int duration;
  final String title;
  final bool decline;
  final int bengin;

  FlipClockView({
    Key key,
    this.duration,
    this.title,
    this.decline = true,
    this.bengin = 0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FlipClockView();
  }
}

class _FlipClockView extends State<FlipClockView> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(seconds: widget.duration), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).maybePop();
      }
    });
    if (widget.decline == true) {
      animation = Tween<double>(begin: widget.duration.toDouble(), end: 0).animate(controller);
    } else {
      animation = Tween<double>(begin: widget.bengin.toDouble(), end: (widget.bengin + widget.duration).toDouble()).animate(controller);
    }

    controller.forward();
  }

  _buildDeclineClock(
    int minutesTenths,
    int minutesQuantile,
    int secondsTenths,
    int secondsQuantile,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > constraints.maxWidth) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${minutesTenths == 5 ? 0 : minutesTenths + 1}',
                    nextValue: '$minutesTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${minutesQuantile == 9 ? 0 : minutesQuantile + 1}',
                    nextValue: '$minutesQuantile',
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${secondsTenths == 5 ? 0 : secondsTenths + 1}',
                    nextValue: '$secondsTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${secondsQuantile == 9 ? 0 : secondsQuantile + 1}',
                    nextValue: '$secondsQuantile',
                  ),
                ],
              )
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${minutesTenths == 5 ? 0 : minutesTenths + 1}',
                    nextValue: '$minutesTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${minutesQuantile == 9 ? 0 : minutesQuantile + 1}',
                    nextValue: '$minutesQuantile',
                  ),
                ],
              ),
              SizedBox(
                width: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${secondsTenths == 5 ? 0 : secondsTenths + 1}',
                    nextValue: '$secondsTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${secondsQuantile == 9 ? 0 : secondsQuantile + 1}',
                    nextValue: '$secondsQuantile',
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }

  _buildIncreaseClock(
    int hoursTenths,
    int houresQuantile,
    int minutesTenths,
    int minutesQuantile,
    int secondsTenths,
    int secondsQuantile,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > constraints.maxWidth) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${hoursTenths == 0 ? 2 : hoursTenths - 1}',
                    nextValue: '$hoursTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${houresQuantile == 0 ? 9 : houresQuantile - 1}',
                    nextValue: '$houresQuantile',
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${minutesTenths == 0 ? 5 : minutesTenths - 1}',
                    nextValue: '$minutesTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${minutesQuantile == 0 ? 9 : minutesQuantile - 1}',
                    nextValue: '$minutesQuantile',
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${secondsTenths == 0 ? 5 : secondsTenths - 1}',
                    nextValue: '$secondsTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${secondsQuantile == 0 ? 9 : secondsQuantile - 1}',
                    nextValue: '$secondsQuantile',
                  ),
                ],
              )
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${hoursTenths == 0 ? 2 : hoursTenths - 1}',
                    nextValue: '$hoursTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${houresQuantile == 0 ? 9 : houresQuantile - 1}',
                    nextValue: '$houresQuantile',
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${minutesTenths == 0 ? 5 : minutesTenths - 1}',
                    nextValue: '$minutesTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${minutesQuantile == 0 ? 9 : minutesQuantile - 1}',
                    nextValue: '$minutesQuantile',
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCounterView(
                    currentValue: '${secondsTenths == 0 ? 5 : secondsTenths - 1}',
                    nextValue: '$secondsTenths',
                  ),
                  FlipCounterView(
                    currentValue: '${secondsQuantile == 0 ? 9 : secondsQuantile - 1}',
                    nextValue: '$secondsQuantile',
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title ?? ''),
      ),
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          int hours = (animation.value / 3600).floor();
          int minutes = ((animation.value % 3600) / 60).floor();
          int seconds = (animation.value % 60).floor();
          int hoursTenths;
          int houresQuantile;
          if (hours < 10) {
            hoursTenths = 0;
            houresQuantile = hours;
          } else {
            hoursTenths = (hours / 10).floor();
            houresQuantile = (hours % 10).ceil();
          }
          int minutesTenths;
          int minutesQuantile;
          if (minutes < 10) {
            minutesTenths = 0;
            minutesQuantile = minutes;
          } else {
            minutesTenths = (minutes / 10).floor();
            minutesQuantile = (minutes % 10).ceil();
          }
          int secondsTenths;
          int secondsQuantile;
          if (seconds < 10) {
            secondsTenths = 0;
            secondsQuantile = seconds;
          } else {
            secondsTenths = (seconds / 10).floor();
            secondsQuantile = seconds % 10.ceil();
          }
          return widget.decline
              ? _buildDeclineClock(minutesTenths, minutesQuantile, secondsTenths, secondsQuantile)
              : _buildIncreaseClock(hoursTenths, houresQuantile, minutesTenths, minutesQuantile, secondsTenths, secondsQuantile);
        },
      ),
    );
  }
}

class NumberPainter extends CustomPainter {
  final String value;
  final double fontOffsetY;

  NumberPainter({@required this.value, this.fontOffsetY}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    TextSpan span = TextSpan(style: TextStyle(fontSize: 100, fontFamily: 'pingfang'), text: this.value);
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    // print(tp.height);
    // print(tp.width);
    tp.paint(canvas, Offset(20, fontOffsetY ?? 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

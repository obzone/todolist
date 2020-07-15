import 'dart:math';

import 'package:flutter/material.dart';

class FlipCounterView extends StatefulWidget {
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

    controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0, end: pi).animate(controller);

    controller.forward();
  }

  _buildNumberWidget({String value, double fontOffsetY}) {
    return ClipRect(
      child: Container(
        color: Colors.black,
        child: CustomPaint(
          size: Size(100, 70),
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
          height: 140,
          width: 100,
          color: Colors.black,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                children: <Widget>[
                  _buildNumberWidget(value: widget.nextValue),
                  Positioned(
                    top: 70,
                    child: _buildNumberWidget(value: widget.currentValue, fontOffsetY: -70),
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
                      child: _buildNumberWidget(value: widget.nextValue, fontOffsetY: -70),
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
  final int seconds;

  FlipClockView({Key key, this.seconds}) : super(key: key);

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

    controller = AnimationController(duration: Duration(seconds: widget.seconds), vsync: this);
    animation = Tween<double>(begin: widget.seconds.toDouble(), end: 0).animate(controller);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          int minutes = (animation.value / 60).floor();
          int seconds = (animation.value % 60).floor();
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
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxHeight > constraints.maxWidth) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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

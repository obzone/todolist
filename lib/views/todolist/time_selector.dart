import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeSelectorView extends StatefulWidget {
  final Function(int) onSelectedItemChanged;
  final int selectedItem;
  final List<int> values;

  TimeSelectorView({Key key, this.onSelectedItemChanged, @required this.values, this.selectedItem}) : super(key: key);

  @override
  _TimeSelectorViewState createState() => _TimeSelectorViewState();
}

class _TimeSelectorViewState extends State<TimeSelectorView> {
  AnimationController _controller;
  int selectedItem;
  FixedExtentScrollController _fixedExtentScrollController;

  @override
  void initState() {
    super.initState();

    _fixedExtentScrollController = FixedExtentScrollController(initialItem: widget.selectedItem);
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[100]),
            ),
          ),
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  widget.onSelectedItemChanged(this.selectedItem ?? widget.selectedItem);
                  Navigator.maybePop(context);
                },
              )
            ],
          ),
        ),
        Container(
          height: 200,
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            scrollController: _fixedExtentScrollController,
            itemExtent: 45,
            onSelectedItemChanged: (index) {
              this.selectedItem = index;
            },
            children: widget.values.map((timeStamp) {
              return Container(
                alignment: Alignment.center,
                child: Text('$timeStamp minutes'),
              );
            }).toList(),
          ),
        ),
        Container(
          color: Colors.white,
          child: SafeArea(
            // bottom: true,
            child: Container(),
          ),
        ),
      ],
    );
  }
}

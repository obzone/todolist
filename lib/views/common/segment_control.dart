import 'package:flutter/material.dart';

class SegmentControlView extends StatefulWidget {
  final List<String> values;
  final String selectedValue;
  final String title;
  final Function(String) onValueChange;

  SegmentControlView({Key key, @required this.values, @required this.title, @required this.onValueChange, this.selectedValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SegmentControlView();
  }
}

class _SegmentControlView extends State<SegmentControlView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(widget.title ?? ''),
          ),
          ...(widget.values ?? []).map(
            (value) => Container(
              color: widget.selectedValue == value ? Theme.of(context).primaryColor : Colors.grey[300],
              child: MaterialButton(
                child: Text(
                  '$value',
                  style: TextStyle(color: widget.selectedValue == value ? Colors.white : null),
                ),
                minWidth: 0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  widget.onValueChange(value);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

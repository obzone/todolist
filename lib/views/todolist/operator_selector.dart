import 'package:flutter/material.dart';

class OpearateSelectorView extends StatelessWidget {
  final List<String> values;
  final Function(String) onValueChange;

  OpearateSelectorView({Key key, this.values, this.onValueChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: values?.map((value) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blueGrey[50],
                    width: 1,
                  ),
                ),
                color: Colors.white,
              ),
              height: 45,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () async {
                  await Navigator.maybePop(context);
                  onValueChange(value);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(value ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          })?.toList() ??
          [],
    );
  }
}

import 'package:flutter/material.dart';

class UserReportView extends StatefulWidget {
  UserReportView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserReportView();
  }
}

class _UserReportView extends State<UserReportView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('hello obzone'),
      ),
    );
  }
}

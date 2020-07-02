import 'package:flutter/material.dart';
import 'package:todolist/viewmodels/common/launch_load.dart';
import 'package:todolist/views/common/launch_loading.dart';
import 'package:todolist/views/playground/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF0F0F0),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LaunchLoadingView(
        viewModel: LaunchLoadingViewModel(),
      ),
      // home: RadialExpansionDemo(),
    );
  }
}

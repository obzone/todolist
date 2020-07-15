import 'package:flutter/material.dart';
import 'package:todolist/viewmodels/common/launch_load.dart';
import 'package:todolist/views/common/launch_loading.dart';

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
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Color(0xFFF0F0F0),
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(color: Colors.lightGreen[900])),
      home: LaunchLoadingView(
        viewModel: LaunchLoadingViewModel(),
      ),
      // home: RadialExpansionDemo(),
    );
  }
}
